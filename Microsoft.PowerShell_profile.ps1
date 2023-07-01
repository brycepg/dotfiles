Set-Alias -Name vim -Value nvim
function vimrc()
{
    vim $HOME\dotfiles\nvim\vimrc.vim
}
function nvimrc()
{
    vim $HOME\dotfiles\nvim\init.lua
}

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

# Better autocomplete
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

Set-Alias ctc ConvertTo-Csv

# install with:
#   winget install JanDeDobbeleer.OhMyPosh -s winget
#   for some reason its not working
# oh-my-posh.exe init pwsh | Invoke-Expression
