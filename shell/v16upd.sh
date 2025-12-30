#!/bin/bash
function  eVer(){
 if [ $# -lt 1 ]; then
  echo " Usage: eVer Version ";
  exit
 else
  url=$(echo http://$Site/eset_upd/$1/update.ver | sed 's/dll/\/dll/')
  uDir=$(echo $oPath/$1 | sed 's/dll/\/dll/')
  tFile=./tmp/temp.txt
  udVer=./tmp/update.ver
  uFile=$(echo ./tmp/$1.ver)
  dFile=$(echo ./tmp/$1.lst)
  lFile=$(echo ./tmp/$1.log)
  [ ! -d ./tmp ] && mkdir -p ./tmp
  [ ! -d $uDir ] && mkdir -p $uDir
  wget -N --http-user=$ID --http-password=$PW -O $udVer $url

  sed -n '/\[[^H|^S|^L]/,$ p' $udVer|sed '/CONT/,/size/d'|sed '/_ARM64/,/size/d'|sed '/PICO/,/inte/d' > $tFile
  sed -n "/_l[0-9]/s@file=@http://$Site@ p" $udVer >$dFile
  sed "s@file=\/.*\/@file=@g" $tFile > $uDir/update.ver
  mv $udVer $uFile
  wget -N -b -o $lFile --http-user=$ID --http-password=$PW -P $uDir -i $dFile
 fi
}
#------
ID=TRIAL-0488540542
PW=at5jf5an88
Site=us-update.eset.com
#------  v16dll Supports V16 through V19
oPath=./eset_upd
eVer v16dll
#------ ep12dll Supports ep6.6 through ep12
#oPath=./eset_upd
#eVer ep12dll
