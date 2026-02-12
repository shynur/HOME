# Usage: webm2HEVC.ps1 'path/to/video 1.webm' 'path/to/video N.webm' ...
# 将 webm 视频文件 转换到 HEVC 编码的 MP4 格式, 并删除原文件.

function webm2HEVC {
    param([string]$inputVideo)
    $outputVideo = $inputVideo -replace '\.webm$', '.mp4'
    Invoke-Expression "ffmpeg -i '$inputVideo' -c:v libx265 -preset veryslow -x265-params crf=0 '$outputVideo'" | Out-Null
    if ($LASTEXITCODE -eq 0) {
        Remove-Item "$inputVideo"
    } else {
        Write-Output "转换失败: '$inputVideo'"
    }
}

$jobs = @()
foreach ($arg in $args) {
    $jobs += Start-Job -ScriptBlock ${function:webm2HEVC} -ArgumentList $arg
}
$jobs | Wait-Job
