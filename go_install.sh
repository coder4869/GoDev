#!/bin/sh

cd ~/Downloads/
Download_Dir=$(pwd) #get absolute path
User_Dir=$(dirname $Download_Dir) #/user/username or /home/username
Desktop_Dir="$(dirname $Download_Dir)/Desktop"

Go_Inatsll_Dir=/usr/local/goroot

#searching target go installing package in download directory
Go_Download_Path="${Download_Dir}/go*.tar.gz"
#echo ${Go_Download_Path}
if [ ! -f ${Go_Download_Path} ]; then
	echo "	##############################################################################
	Go installing package not found, Please download it from https://pan.baidu.com/s/1qXPykAK
	and put it in the Downloads directory! 
	"
	exit 1
else
	echo "  ##############################################################################
    Find go installing package in download directory!
	Decompressing go installing package ... ...
	"
fi

echo "#### Decompressing $(basename $Go_Download_Path)  ####"
if [ -d ${Go_Inatsll_Dir} ]; then
        echo "#### Removing old go installing ... ... #####"
	sudo rm -rf ${Go_Inatsll_Dir}/*
fi

sudo mkdir ${Go_Inatsll_Dir}
sudo tar -zxf ${Go_Download_Path} -C ${Go_Inatsll_Dir}

echo "#### Configuring for GOROOT && GOPATH ####"
Bashrc_Path="${User_Dir}/.bashrc"
if [ ! -f ${Bashrc_Path} ]; then
        echo "#### File .bashrc not exist! #####"
	exit 1
else
        echo "#### File .bashrc found! #####"
fi
chmod 777 ${Bashrc_Path}
Go_Path="${Desktop_Dir}/GoProject"
mkdir ${Go_Path}
chmod 777 ${Go_Path}
(
cat <<EOF
    export GOROOT=${Go_Inatsll_Dir}/go
    export GOPATH=${Go_Path}/GoWeb
    export PATH=$PATH:$GOROOT/bin
EOF
) >> ${Bashrc_Path}
source ${Bashrc_Path}

echo "
    Installng for go and configuring for GOROOT/GOPATH environmets are finished.
    Now you can running go with command 'go'. Of course, the GOROOT/GOPATH environmet
    can be mordified as your need.

    The following is one GoWeb example(based on the former default GOPATH environmet).
    In the example, GOPATH is used for one project only, and you can put more than one
    go projects in the GOPATH dir.

    "

if read -t 10 -p "Do you needs to install the default GoWeb example? yes/no " UseGoWeb ; then
    if [ $UseGoWeb == yes ]; then

        echo "Downloading default GoWeb example .... ..."
        timeout=5
        ret_code=`curl -I -s --connect-timeout $timeout "github.com/coder4869/GoWeb" -w %{http_code} | tail -n1`
        if [ "x$ret_code" = "x301" ]; then
            echo "Succeed to get access of github.com! "
            cd ${Go_Path}
            git clone https://github.com/coder4869/GoWeb.git
            go get github.com/coder4869/golibs
            go get gopkg.in/mgo.v2
        else
            echo "Failed to get access of github.com! "
            exit 1
        fi
    else
        echo "You give up to use the default GoWeb example!"
        mkdir -p ${Go_Path}/GoWeb/bin
        mkdir -p ${Go_Path}/GoWeb/src
        mkdir -p ${Go_Path}/GoWeb/pkg
        exit 1
    fi
else
    echo "Failed to get input, time out!"
    exit 1
fi

go



