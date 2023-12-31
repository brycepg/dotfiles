Set-Alias -Name vim -Value nvim
function vimrc()
{
    vim $HOME\dotfiles\nvim\vimrc.vim
}
function nvimrc()
{
    vim $HOME\dotfiles\nvim\init.lua
}
function zomboidmodsloc()
{
    Write-Output "C:\Program Files (x86)\Steam\steamapps\workshop\content\108600"
}
function cdzomboidmods()
{
    $directory = zomboidmodsloc
    Set-Location -Path $directory
}

function gpt()
{
    param(
        [Parameter(ValueFromRemainingArguments=$true)]
        $RemainingArgs
    )
    $concatenatedString = $RemainingArgs -join ' '
    npx chatgpt@latest -m gpt-4 "$concatenatedString"
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

Set-PSReadLineOption -EditMode Emacs


. "$PSScriptRoot\Powershell.Local.ps1"
