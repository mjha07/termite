#!/bin/bash

# Default source and target folders
SOURCE_PATH=client_source
TARGET_PATH=client_public

# Output folders
LIB_PATH=externals
TOOL_PATH=tools
JS_SOURCE_PATH=$SOURCE_PATH/lib
JS_TARGET_PATH=$TARGET_PATH/lib
CSS_SOURCE_PATH=$SOURCE_PATH/css
CSS_TARGET_PATH=$TARGET_PATH/css

# List of javascript files to minify (in subfolder "js")
JS_MINIFICATION_FILES=(TermTopicMatrixObject TermTopicMatrixVis)

# List of css files to minify (in subfolder "css")
CSS_MINIFICATION_FILES=(TermTopicMatrixVis)

#------------------------------------------------------------------------------#

function __remove_folder__ {
	FOLDER=$1
	if [ -d $FOLDER ]
	then
		echo "Removing folder: $FOLDER"
		rm -rf $FOLDER
	fi
}
function __remove_file__ {
	FILE=$1
	if [ -f $FILE ]
	then
		echo "Removing file: $FILE"
		rm -f $FILE
	fi
}

#------------------------------------------------------------------------------#

function __run_unsetup__ {
	echo "This script removes all files retrieved by setup.sh."
	echo

	__remove_folder__ $LIB_PATH
	__remove_folder__ $TOOL_PATH
	__remove_folder__ $JS_SOURCE_PATH
	__remove_folder__ $JS_TARGET_PATH

	for CSS_FILE in chosen.css chosen-sprite.png
	do
		__remove_file__ $CSS_SOURCE_PATH/$CSS_FILE
		__remove_file__ $CSS_TARGET_PATH/$CSS_FILE
	done
	for JS_FILE in ${JS_MINIFICATION_FILES[@]}
	do
		__remove_file__ $TARGET_PATH/js/$JS_FILE.js
	done
	for CSS_FILE in ${CSS_MINIFICATION_FILES[@]}
	do
		__remove_file__ $TARGET_PATH/css/$CSS_FILE.css
	done

	echo "Completed unsetup."
}

#------------------------------------------------------------------------------#

function __ungenerate_documentations__ {
	JSDOC=node_modules/jsdoc/jsdoc
	OUTPUT=documentation

	if [ -f "$JSDOC" ]
	then
		echo "Uninstalling jsdoc3 (requires 'npm')..."
		npm uninstall jsdoc
	fi
}

#------------------------------------------------------------------------------#

function __ungenerate_tests__ {
	MOCHA=node_modules/mocha

	if [ -d "$MOCHA" ]
	then
		echo "Uninstalling mocha..."
		npm uninstall mocha

		echo "Uninstalling require..."
		npm uninstall require

		echo "Installing chai..."
		npm uninstall chai

		echo "Uninstalling d3..."
		npm uninstall d3

		echo "Uninstalling jquery..."
		npm uninstall jquery

		echo "Uninstalling underscore..."
		npm uninstall underscore

		echo "Uninstalling backbone..."
		npm uninstall backbone
	fi
}

#------------------------------------------------------------------------------#

RUN_TOOLS=0
RUN_DOCS=0
RUN_TESTS=0
RUN_HELP=0
UNKNOWN_OPTION=

if [ $# -eq 0 ]
then
	RUN_HELP=1
fi
for ARG in "$@"
do
	if [ "$ARG" = "-h" ]
	then
		RUN_HELP=1
	elif [ "$ARG" = "--help" ]
	then
		RUN_HELP=1
	elif [ "$ARG" = "tools" ]
	then
		RUN_TOOLS=1
	elif [ "$ARG" = "docs" ]
	then
		RUN_DOCS=1
	elif [ "$ARG" = "tests" ]
	then
		RUN_TESTS=1
	else
		RUN_HELP=1
		UNKNOWN_OPTION=$ARG
	fi
done

if [ $RUN_HELP -eq 1 ]
then
	echo "Usage: `basename $0` [-h|--help] [tools] [docs] [tests]"
	echo
	
	if [ ! -z $UNKNOWN_OPTION ]
	then
		echo "  Unknown option: $ARG"
		exit -1
	else
		echo "  tools:"
		echo "    Remove all files retrieved and generated by setup.sh."
		echo
		echo "  docs:"
		echo "    Remove JSDoc."
		echo "    (require npm; not officially supported)"
		echo
		echo "  tests:"
		echo "    Remove Mocha and other utilities."
		echo "    (require npm; not officially supported)"
		exit 0
	fi
else
	if [ $RUN_TOOLS -eq 1 ]
	then
		__run_unsetup__
		exit 0
	fi
	if [ $RUN_DOCS -eq 1 ]
	then
		__ungenerate_documentations__
		exit 0
	fi
	if [ $RUN_TESTS -eq 1 ]
	then
		__ungenerate_tests__
		exit 0
	fi
fi