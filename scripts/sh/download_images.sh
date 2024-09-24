# bin/bash

#transkribus valid login
#export .secret variables

colId=284592

SRC=`dirname "$0"`/../../../TranskribusPyClient/src

tmp_col_name="toto_$$"

#PYTHON=python
PYTHON=python

function error {
	echo "ERROR: $1"
	exit 1
}

#cleaning any persistent login info
echo "==================================================================="
echo "--- logout"
tmp_col_id=`$PYTHON $SRC/TranskribusCommands/do_logout.py --persist`
echo "OK"

#testing a bad login
echo
echo "--- login"
tmp_col_id=`$PYTHON $SRC/TranskribusCommands/do_login.py --persist -l "tilla" -p "miaouuuu"` && error "login should have failed"
echo
echo "OK"

#making a login and persisting the session token
echo
echo "--- login"
tmp_col_id=`$PYTHON $SRC/TranskribusCommands/do_login.py --persist -l $TRK_USR -p $TRK_PW` || error "login error"
echo "OK"

#---------------------------------------------------
echo "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = ="

#---------------------------------------------------
echo "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = ="
echo
echo "--- download all $colId ---"
rm -rf trnskrbs_$colId 
echo "--- download "
$PYTHON $SRC/TranskribusCommands/Transkribus_downloader.py $colId --persist || error " download error"
echo "OK"
#---------------------------------------------------

#---------------------------------------------------
echo "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = ="
echo
echo "moving transkribus export jpg to facs dir"
cp ./trnskrbs_284592/col/*/*.jpeg ./data/facs
echo "done"
#---------------------------------------------------