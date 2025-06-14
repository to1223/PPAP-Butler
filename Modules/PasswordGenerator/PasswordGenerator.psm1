function New-Password {
param(
    [switch]$Uniq,
    [switch]$NoConfusingLetters,
    # 文字数を制限することにより、Uniqが有効の時に文字数が足りなくなることを防ぐ
    # 紛らわしい文字を除くと数字が8個になるので、それぞれの文字種が均等数なら、8x4=32文字まで可能
    [ValidateRange(8, 20)]
    [int]$Length = 8
)
    $result = [System.Collections.ArrayList]@()

    # 使用する文字セットの準備
    $uppercase = @('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z')
    $lowercase = @('a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z')
    $digit = @('0', '1', '2', '3', '4', '5', '6', '7', '8', '9')
    $symbol = @('!', '"', '#', '$', '%', '&', "'", '(', ')', '*', '+', ',', '-', '.', '/', ':', ';', '<', '=', '>', '?', '@', '[', '\', ']', '^', '_', '`', '{', '|', '}', '~')
    $confusingLetters = @('I', 'l', '1', '|', 'O', '0')

    $uppercase = [System.Collections.ArrayList]$uppercase
    $lowercase = [System.Collections.ArrayList]$lowercase
    $digit = [System.Collections.ArrayList]$digit
    $symbol = [System.Collections.ArrayList]$symbol
    $confusingLetters = [System.Collections.ArrayList]$confusingLetters

    $tokenSet = @($uppercase, $lowercase, $digit, $symbol)

    # 紛らわしい文字を除去
    if ($NoConfusingLetters) {
        foreach ($subset in $tokenSet) {
            foreach ($letter in $confusingLetters) {
                $subset.Remove($letter)
            }
        }
    }

    # 指定長さになるまで、文字のサブセットから順番に1文字ずつ抽出
    foreach ($i in 1..$Length) {
        $subset = $tokenSet[($i-1) % $tokenSet.Length]
        $letter = (Get-Random $subset -Count 1)
        $result += $letter

        # Uniqスイッチが有効の場合、文字セットから抽出した文字を除去
        if ($Uniq) {
            $subset.Remove($letter)
        }
    }

    # 抽出した文字列をシャッフル
    $result = (Get-Random $result -Count $result.Length)

    # 結果
    return ($result -join '')
}
