if (-not [Console]::IsInputRedirected -and -not [Console]::IsOutputRedirected) {
    Set-PSReadLineOption -EditMode Emacs
    Set-PSReadLineOption -PredictionSource HistoryAndPlugin
    Set-PSReadLineOption -PredictionViewStyle ListView
    Set-PSReadLineOption -HistorySaveStyle SaveIncrementally
}
