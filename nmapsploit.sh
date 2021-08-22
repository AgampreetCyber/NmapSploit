#!/bin/bash

clear

echo ""
echo "-------------------"
echo "|Which tool you use|"
echo "-------------------"
echo ""

echo -n "nmap or metasploit : "
     read a

if [ $a = nmap ]

then
clear

echo ""
echo "ok "
echo ""
echo "---------------------------------"
echo "you have to do it in termux only "
echo "---------------------------------"
echo "------------------------"
echo " please use only termux "
echo "------------------------"
echo ""
sleep 6
echo "IMPORTANT NOTICE !!"
echo "PLEASE USE ONLY EDUCATIONAL PURPOSE DON'T USE ANY ILLIGAL ACTIVITY "
echo ""
sleep 7

apt install figlet

figlet nmap

echo "........"

apt update && apt upgrade

apt install nmap

clear

echo ""
echo "------------------------------------------------"
echo -n "  Enter your router ip (ex : 192.168.X.X) : "
 read b
    echo "------------------------------------------------"
echo ""
echo "....."

sleep 2
echo ""
echo "-----------------------------"
echo "please wait to scan network "
echo "-----------------------------"
sleep 2
nmap $b/24
echo "-------------------------------"
echo "please wait to other open devices "
echo "---------------------------------"
sleep 2
nmap -sV $b/24
echo "------------------------------------"
echo "please wait to tcp open port scanning "
echo "-------------------------------------"
sleep 2
nmap -sT $b/24
echo "--------------------------------"
echo "please wait to list networks ip "
echo "---------------------------------"
sleep 5
nmap -sL $b/24
echo "---------------------------------"
echo "please wait to all ports scanning "
echo "----------------------------------"
sleep 2
nmap -sV -p 1-65535 $b/24
echo "-------------"
echo ""
echo "your result is here Thankyou "

elif [ $a = metasploit ]

then


clear
echo ""
echo " ok "
echo ""
apt install figlet
clear
figlet Metasploit
echo "please wait 30 minutes depend on your network speed "
echo ""
apt install curl

apt install wget

echo "
    +-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+
    |M|e|t|a|s|p|l|o|i|t| |i|n| |T|e|r|m|u|x|
    +-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+
            +-+-+ +-+-+-+-+
            |b|y| |A|G|A|M
            +-+-+-+-+-+-+-+
"
center() {
  termwidth=$(stty size | cut -d" " -f2)
  padding="$(printf '%0.1s' ={1..500})"
  printf '%*.*s %s %*.*s\n' 0 "$(((termwidth-2-${#1})/2))" "$padding" "$1" 0 "$(((termwidth-1-${#1})/2))" "$padding"
}

# Loading spinner
center " Loading..."
source <(echo "c3Bpbm5lcj0oICd8JyAnLycgJy0nICdcJyApOwoKY291bnQoKXsKICBzcGluICYKICBwaWQ9JCEKICBmb3IgaSBpbiBgc2VxIDEgMTBgCiAgZG8KICAgIHNsZWVwIDE7CiAgZG9uZQoKICBraWxsICRwaWQgIAp9CgpzcGluKCl7CiAgd2hpbGUgWyAxIF0KICBkbyAKICAgIGZvciBpIGluICR7c3Bpbm5lcltAXX07IAogICAgZG8gCiAgICAgIGVjaG8gLW5lICJcciRpIjsKICAgICAgc2xlZXAgMC4yOwogICAgZG9uZTsKICBkb25lCn0KCmNvdW50" | base64 -d)

echo
center "*** Dependencies installation..."

# Remove not working repositories
rm $PREFIX/etc/apt/sources.list.d/*

# Add gushmazuko repository to install ruby 2.7.2 version
echo 'deb https://github.com/gushmazuko/metasploit_in_termux/raw/master gushmazuko main'  | tee $PREFIX/etc/apt/sources.list.d/gushmazuko.list

pkg install -y gnupg
curl -fsSL https://raw.githubusercontent.com/gushmazuko/metasploit_in_termux/master/gushmazuko-gpg.pubkey | gpg --dearmor | tee $PREFIX/etc/apt/trusted.gpg.d/gushmazuko-repo.gpg

# Set low priority for all gushmazuko repository (for security purposes)
# Set highest priority for ruby package from gushmazuko repository
echo '## Set low priority for all gushmazuko repository (for security purposes)
Package: *
Pin: release gushmazuko
Pin-Priority: 100

## Set highest priority for ruby package from gushmazuko repository
Package: ruby
Pin: release gushmazuko
Pin-Priority: 1001' | tee $PREFIX/etc/apt/preferences.d/preferences

# Purge installed ruby
apt purge ruby -y
rm -fr $PREFIX/lib/ruby/gems

pkg upgrade -y -o Dpkg::Options::="--force-confnew"
pkg install -y python autoconf bison clang coreutils curl findutils apr apr-util postgresql openssl readline libffi libgmp libpcap libsqlite libgrpc libtool libxml2 libxslt ncurses make ncurses-utils ncurses git wget unzip zip tar termux-tools termux-elf-cleaner pkg-config git ruby -o Dpkg::Options::="--force-confnew"

python3 -m pip install --upgrade pip
python3 -m pip install requests

echo
center "*** Fix ruby BigDecimal"
source <(curl -sL https://github.com/termux/termux-packages/files/2912002/fix-ruby-bigdecimal.sh.txt)

echo
center "*** Erasing old metasploit folder..."
rm -rf $HOME/metasploit-framework

echo
center "*** Downloading..."
cd $HOME
git clone https://github.com/rapid7/metasploit-framework.git --depth=1

echo
center "*** Installation..."
cd $HOME/metasploit-framework
sed '/rbnacl/d' -i Gemfile.lock
sed '/rbnacl/d' -i metasploit-framework.gemspec
gem install bundler
sed 's|nokogiri (1.*)|nokogiri (1.8.0)|g' -i Gemfile.lock

gem install nokogiri -v 1.8.0 -- --use-system-libraries

gem install actionpack
bundle update activesupport
bundle update --bundler
bundle install -j$(nproc --all)
$PREFIX/bin/find -type f -executable -exec termux-fix-shebang \{\} \;
rm ./modules/auxiliary/gather/http_pdf_authors.rb
if [ -e $PREFIX/bin/msfconsole ];then
	rm $PREFIX/bin/msfconsole
fi
if [ -e $PREFIX/bin/msfvenom ];then
	rm $PREFIX/bin/msfvenom
fi
ln -s $HOME/metasploit-framework/msfconsole /data/data/com.termux/files/usr/bin/
ln -s $HOME/metasploit-framework/msfvenom /data/data/com.termux/files/usr/bin/
termux-elf-cleaner /data/data/com.termux/files/usr/lib/ruby/gems/2.4.0/gems/pg-0.20.0/lib/pg_ext.so

echo
center "*** Database configuration..."
cd $HOME/metasploit-framework/config
curl -sLO https://raw.githubusercontent.com/gushmazuko/metasploit_in_termux/master/database.yml

mkdir -p $PREFIX/var/lib/postgresql
initdb $PREFIX/var/lib/postgresql

pg_ctl -D $PREFIX/var/lib/postgresql start
createuser msf
createdb msf_database

cd $HOME
curl -sLO https://raw.githubusercontent.com/gushmazuko/metasploit_in_termux/master/postgresql_ctl.sh
chmod +x postgresql_ctl.sh

echo
center "*"
echo -e "\033[32m Installation complete. \n To start msf database use: ./postgresql_ctl.sh start \n Launch metasploit by executing: msfconsole\033[0m"
center "*"

else

clear

echo ""
echo "---------------------"
   echo "invalid option !!"
echo "----------------------"

fi
