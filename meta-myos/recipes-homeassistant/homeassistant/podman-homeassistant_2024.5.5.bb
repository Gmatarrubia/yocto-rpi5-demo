SUMMARY = "Open-source home automation platform running on Docker Compose container"
HOMEPAGE = "https://home-assistant.io/"
LICENSE = "CLOSED"

inherit bob-user systemd

HOMEASSISTANT_USER ?= "${BOB_USER_NAME}"
HOMEASSISTANT_USER[doc] = "homeassistent service runs as docker compose container."
HOMEASSISTANT_DIR ?= "/home/${HOMEASSISTANT_USER}"
HOMEASSISTANT_DIR[doc] = "Installation directory used by home-assistant."
HOMEASSISTANT_CONFIG_DIR ?= "${HOMEASSISTANT_DIR}/config"
HOMEASSISTANT_CONFIG_DIR[doc] = "Configuration directory used by home-assistant."

SRC_URI += "\
    file://homeassistant.service \
    file://startHomeassistant.sh \
"

# Container engine dependencies
RDEPENDS:${PN} = " \
    podman \
"

SYSTEMD_AUTO_ENABLE = "enable"
SYSTEMD_SERVICE:${PN} = "homeassistant.service"

do_install:append () {
    # Install docker compose stuff
    install -d "${D}${HOMEASSISTANT_DIR}"
    install -m 0755 "${WORKDIR}/startHomeassistant.sh" "${D}${HOMEASSISTANT_DIR}/"
    chown -R "${HOMEASSISTANT_USER}" "${D}${HOMEASSISTANT_DIR}"

    # Install systemd unit files and set correct config directory
    install -d "${D}${systemd_unitdir}/system"
    install -d "${D}${sysconfdir}/systemd/system/multi-user.target.wants/"
    install -m 0644 "${WORKDIR}/homeassistant.service" "${D}${systemd_unitdir}/system/"
    ln -s "${systemd_unitdir}/system/homeassistant.service" "${D}${sysconfdir}/systemd/system/multi-user.target.wants/homeassistant.service"
    sed -i -e 's,@HOMEASSISTANT_DIR@,${HOMEASSISTANT_DIR},g' "${D}${systemd_unitdir}/system/homeassistant.service"
    sed -i -e 's,@HOMEASSISTANT_USER@,${HOMEASSISTANT_USER},g' "${D}${systemd_unitdir}/system/homeassistant.service"

}

FILES:${PN} += "\
    ${HOMEASSISTANT_DIR}/* \
    ${systemd_unitdir}/system/* \
    ${sysconfdir}/systemd/system/multi-user.target.wants/* \
"
