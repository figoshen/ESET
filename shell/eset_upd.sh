#!/bin/bash
function  eVer(){
	if [ $# -lt 1 ]; then 
		echo " Usage: eVer Version ";
		exit
	else
		url=$(echo http://$Site/eset_upd/$1/update.ver | sed 's@dll@/dll@')
		uDir=$(echo $oPath/$1 |  sed "$filter")
		tFile=./tmp/temp.txt
		udVer=./tmp/update.ver
		uFile=$(echo ./tmp/$1.ver)
		dFile=$(echo ./tmp/$1.lst)
		lFile=$(echo ./tmp/$1.log)
		[ ! -d ./tmp ] && mkdir -p ./tmp
		[ ! -d $uDir ] && mkdir -p $uDir
		wget -N --http-user=$ID --http-password=$PW -O $udVer $url 
		#sed -n "/\[[^H]/,$ p" $udVer|sed "/CONT/,/size/d"|sed "/PICO/,/inte/d" > $tFile
                sed -n "/\[[^CO|^HO|^SE|^LI|^PI]/,/size/p" $udVer > $tFile
		sed -n "/_l[0-9]/s@file=@http://$Site@ p" $udVer >$dFile
		sed "s@file=\/.*\/@file=@g" $tFile > $uDir/update.ver
		echo -e "[STATS_SERVER]\nserver=http;$HOSTNAME;$Port;/updater_plugin_url/storage_file/" >> $uDir/update.ver
		mv $udVer $uFile
		[ -d $uDir ] && rm -f $lFile
		wget -N -b -o $lFile --http-user=$ID --http-password=$PW -P $uDir -i $dFile
	fi
}
#-------------------
ID=TRIAL-0270694529
PW=4psfpvxuce
Site=update.eset.com
Port=2221
oPath=./eset_upd
filter="s@v4@@"
#-------------------
eVer v4
#===================
filter="s@dll@/dll@"
#===================
eVer v14dll
eVer ep8dll
exit
