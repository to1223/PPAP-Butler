Import-Module "$($PSScriptRoot)\Modules\PasswordGenerator" -Force

# パスワード生成
$password = (New-Password -Uniq -NoConfusingLetters -Length 8)

# 作業フォルダ
$outputFolder = [System.Environment]::GetFolderPath("Desktop")

# 圧縮
$7z = "C:\Program Files\7-Zip\7z.exe"
$compressedFileBaseName = "$((Get-Item -LiteralPath $args[0]).BaseName)"
$compressedFileExtension = ".zip"
$compressedFileName = $compressedFileBaseName + $compressedFileExtension
foreach ($arg in $args) {
    & $7z a -ssw "-p$($password)" (Join-Path $outputFolder $compressedFileName) $arg
}

# テキストファイルの作成
$text = @(
    "添付ファイルの解凍用パスワードは下記です："
    $password
) -join "`n"
$textFileName = "$($compressedFileName).ppap.txt"
try {
    # zipファイルは上書きされるみたいなので、これも上書きにしてもいいかも
    New-Item -Path $outputFolder -Name $textFileName -Value $text -ErrorAction Stop
}
catch {
    Write-Output @(
        ""
        "!!CAUTION!!"
        "パスワードを記載したテキストファイルを作成できませんでした。"
        "下記のパスワードをメモしてください。"
        "---"
        $text
        "---"
        ""
    )
    Read-Host "終了するには Enter キーを押してください。"
}
