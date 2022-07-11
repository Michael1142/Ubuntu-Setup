does_file_exist() {
    if test -f $1; then
        mv $1 $1"_old"
        echo $1 "already exsists old configuraltion moved to" $1"_old"
    else
        echo "$1 already exist"
    fi
}

does_dir_exist() {
    if [ ! -d $1 ]; then
        eval "$2"
    else
        echo "$1 already exist"
    fi
}

CWD=$(pwd)


echo "Welcome!"
echo "Let's start setting up your system."
echo ""

echo "What is your git username?"
read git_config_user_name

echo "What is your git email?"
read git_config_user_email

echo "What is your github username?"
read username

cd ~ && sudo apt update -y

echo 'Installing build essential'
sudo apt install build-essential -y

echo 'Installing vim'
sudo apt install vim -y

echo 'Installing curl' 
sudo apt install curl -y

echo 'Installing neofetch' 
sudo apt install neofetch -y

echo 'Installing tool to handle clipboard via CLI'
sudo apt install xclip -y

echo 'Installing latest git' 
sudo add-apt-repository ppa:git-core/ppa -y
sudo apt update && sudo apt install git -y

echo 'Installing python3-pip'
sudo apt install python3-pip -y

echo 'Installing getgist to download dot files from gist'
sudo pip3 install getgist
export GETGIST_USER=$username

echo "Setting up your git global user name and email"
git config --global user.name "$git_config_user_name"
git config --global user.email $git_config_user_email

echo "Making dev dirs"
does_dir_exist "~/repos" "mkdir ~/repos"
does_dir_exist "~/.virtualenvs" "mkdir ~/.virtualenvs"

echo 'Installing ZSH'
sudo apt install zsh -y
does_dir_exist "~/.oh-my-zsh" 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended'
chsh -s $(which zsh)

echo 'Installing Powerline Status bar'
pip3 install --user powerline-status

echo 'Virtaulenvwrapper'
pip3 install --user virtualenv virtualenvwrapper

echo 'Youtube-dl'
sudo pip install --upgrade youtube_dl

echo 'Cobalt2 theme for zsh'
does_dir_exist "Cobalt2-iterm" "git clone https://github.com/wesbos/Cobalt2-iterm.git"
cd ./Cobalt2-iterm
cp ./cobalt2.zsh-theme ~/.oh-my-zsh/themes/cobalt2.zsh-theme

echo 'ZSH Plugins config'
cd ~/.oh-my-zsh/custom/plugins
does_dir_exist "zsh-autosuggestions" "git clone https://github.com/zsh-users/zsh-autosuggestions.git"
does_dir_exist "zsh-syntax-highlighting" "git clone https://github.com/zsh-users/zsh-syntax-highlighting.git"

echo 'Installing FiraCode'
sudo apt install fonts-firacode -y

echo 'Installing VSCode'
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt install apt-transport-https -y
sudo apt update && sudo apt install code -y

echo 'Installing VLC'
sudo apt install vlc -y
sudo apt install vlc-plugin-access-extra libbluray-bdj libdvdcss2 -y

echo 'Installing Peek' 
sudo add-apt-repository ppa:peek-developers/stable -y
sudo apt update && sudo apt install peek -y

echo 'Installing OBS Studio'
sudo apt install ffmpeg && sudo snap install obs-studio -y

echo 'Updating and Cleaning Unnecessary Packages'
sudo -- sh -c 'apt update -y; apt upgrade -y; apt full-upgrade -y; apt autoremove -y; apt autoclean -y'
clear

# replace default zsh config
cd $CWD
ZSH_FILE=.zshrc
does_file_exist ~/$ZSH_FILE
cp dotfiles/$ZSH_FILE ~/$ZSH_FILE

# replace .vimrc file 
VIM_FILE=.vimrc
does_file_exist ~/$VIM_FILE
cp dotfiles/$VIM_FILE ~/$VIM_FILE


echo 'Installing themes'
exec bash -c  "$(wget -qO- https://git.io/vQgMr)"

echo 'Launching zsh.... Enjoy!'
exec /bin/zsh