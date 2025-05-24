inherit bob-user extrausers

EXTRA_USERS_PARAMS = " \
	groupadd -g 1011 users;\
	useradd \
	-u 1010 \
	--home ${BOB_USER_PATH} \
	--groups users \
	--user-group ${BOB_USER_NAME};\
"

CORE_IMAGE_EXTRA_INSTALL += " \
    linux-firmware-bcm43430 \
    bridge-utils \
    hostapd \
    iptables \
    avahi-daemon \
    kernel-modules \
    openssh openssh-keygen openssh-sftp-server \
    ntp ntp-tickadj \
    packagegroup-core-boot \
    procps \
    tzdata \
    canutils \
    iw \
    wpa-supplicant \
    xdg-user-dirs \
    nano \
    podman-homeassistant \
"
