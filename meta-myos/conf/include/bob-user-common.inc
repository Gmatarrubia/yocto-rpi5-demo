
# Common variables
BOB_USER_NAME = "bob"
BOB_USER_PATH = "/home/${BOB_USER_NAME}/"

inherit useradd

USERADD_PACKAGES = "${PN}"
USERADD_PARAM:${PN} = " \
	--home ${BOB_USER_PATH} \
	--groups users \
	--user-group ${BOB_USER_NAME}\
"
