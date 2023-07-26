#!/bin/bash   

# User-defined inputs
PROGRAM_ORDER="./program_order.txt"
LOGFILE=output/build.log

# Constants
PATH_TO_ROOT=..
PATH_TO_MAKE_LIB=${PATH_TO_ROOT}/lib/shmake/make_lib.sh
PATH_TO_MAKE_EXT=${PATH_TO_ROOT}/lib/shmake/make_externals.sh
PATH_TO_LIB=${PATH_TO_ROOT}/lib/shmake/lib.sh
PATH_TO_ALL_LIBRARIES=${PATH_TO_ROOT}/lib/

export PATH_TO_ROOT
export LOGFILE
export PATH_TO_LIB

all:
	make clean
	make config
	source ${PATH_TO_LIB} && cat ${PROGRAM_ORDER} | run_programs_in_order
	rm -f ${PATH_TO_LIB}

config:
	mkdir -p output
	mkdir -p output/figures
	mkdir -p output/tables
	rm -f ${LOGFILE}
	${SHELL} ${PATH_TO_MAKE_LIB}
	source ${PATH_TO_LIB} && ${SHELL} ${PATH_TO_MAKE_EXT}
	cp -r ${PATH_TO_ALL_LIBRARIES} ./lib/

clean:
	rm -rf external
	rm -rf output

