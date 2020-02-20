TARGET_FILE = "lantern"
PRJ_SRC = "${PWD}/init.sh"
PRJ_LIB = $(shell ls -d ${PWD}/src/*)

export PRJ_LIB

SHELL := /bin/env bash
all: define_main add_dependencies invoke_main make_executable

define_main:
	echo -e "#!/usr/bin/env bash\n" > ${TARGET_FILE}
	echo -e "function init() {" >> ${TARGET_FILE}
	cat "${PRJ_SRC}" | sed -e 's/^/  /g' >> ${TARGET_FILE}
	echo -e "}\n" >> ${TARGET_FILE}

add_dependencies:
	for filename in $${PRJ_LIB[*]}; do cat $${filename} >> ${TARGET_FILE}; echo >> ${TARGET_FILE}; done

invoke_main:
	echo "init \$$@" >> ${TARGET_FILE}

make_executable:
	chmod 755 ${TARGET_FILE}
