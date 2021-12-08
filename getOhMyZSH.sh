#!/bin/bash

# Author: @federicocabreraf
# Script para instalar automaticamente OhMyZsh.
# Pre-requisitos:
# A Unix-like operating system: macOS, Linux, BSD.
# Zsh should be installed (v4.3.9 or more recent is fine but we prefer 5.0.8 and newer).
# curl or wget should be installed.
# git should be installed (recommended v2.4.11 or higher).

# Default dir '.oh-my-zsh'
default_dir="/root/.oh-my-zsh/"

declare -a packages=("zsh" "wget" "curl" "git")

if [ $(id -u) -eq 0 ]; then

	echo -e "\n[*] Buscando paquetes (zsh,curl,wget,git) necesarios en el sistema..."
	
	for pack in "${packages[@]}"; do
		version=$($pack --version 2>/dev/null)
		if [ $? -eq 0 ]; then
			echo -e "\n[+] Se encontro '$pack' en el sistema (si)"
		else
			echo -e "\n[!] No se encontro '$pack' en el sistema (no)"
			echo -ne "\n[*] Es necesario instalar '$pack' desea continuar (Si/no) " && read -r install_confirm
			confirm=$(echo $install_confirm | tr "[:upper:]" "[:lower:]")
			if [ $confirm == "si" -o $confirm == "s" ]; then
				echo -ne "\n[*] Instalando '$pack' ..."
				apt-get install $pack -y > /dev/null
				echo -e "\n\n[+] '$pack' instalado correctamente."
			fi
		fi
	done
		if [ -e $default_dir ]; then
			rm -fr $default_dir
		fi
		echo -ne "\n\n[*] Instalando Oh-My-Zsh ... \n"
		sh -c "wget -O install.sh https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -q"
		sh -c "chmod 777 install.sh"
		sh -c "./install.sh --unattended" > /dev/null
		if [ $? -eq 0 ]; then
			sh -c "rm -f install.sh"
			sed -i "s/robbyrussell/darkblood/g" ~/.zshrc  
			user=$(whoami)
			echo -e "\n[+] Oh-My-Zsh se ha instalado correctamente."
			chsh -s "$(which zsh)" $user
			echo -e "\n[+] Nueva SHELL '/usr/bin/zsh' \n[+] ZSH_THEME='darkblood' \n[*] Cerrando sesion ... \n[!] Por favor vuelva a ingresar.\n\n"
			sleep 3
			pkill -KILL -u $user
		else
			echo -e "\n[!] Ocurrio un error durante la instalacion, intente de nuevo.\n\n"
		fi
	else
		echo -e "\n[!] Usage: sudo ./$0"
fi
