Set-PSReadLineOption -EditMode Emacs
. ~/.emacs.d/etc/use-emacs.ps1 d:/Progs/emacs/

if (-not $env:EMACS_INVOKED_PWSH) {
    # 1_shell kushal sim-web clean-detailed di4m0nd emodipt-extend night-owl negligible
    oh-my-posh init pwsh  `
      --config ~/AppData/Local/Programs/oh-my-posh/themes/1_shell.omp.json   `
      | Invoke-Expression
}
