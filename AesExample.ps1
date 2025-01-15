[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$keyText,
    [Parameter(Mandatory)]
    [string]$textToEncrypt
)

# powershell version of Program.cs for environment without dotnet.exe

Set-StrictMode -Version 3.0

function Encrypt {
    [CmdletBinding()]
    [OutputType([Byte[]])]
    Param
    (
        [Parameter(Mandatory = $true, Position = 0)]
        [System.Byte[]] $unencryptedBytes,
        [Parameter(Mandatory = $true, Position = 1)]
        [System.Byte[]] $key
    )
    try {
        [System.Byte[]] $encryptedBytes = [System.Byte[]]::new(0)
        $encryptAes = [System.Security.Cryptography.Aes]::Create()
        $encryptAes.Key = $key
        $encryptAes.Mode = [System.Security.Cryptography.CipherMode]::ECB
        $encryptAes.Padding = [System.Security.Cryptography.PaddingMode]::PKCS7
        try {
            $aesEncryptor = $encryptAes.CreateEncryptor()
            $encryptedBytes = $aesEncryptor.TransformFinalBlock($unencryptedBytes, 0, $unencryptedBytes.Length);
        }
        finally {
            if ($null -ne $aesEncryptor -and $aesEncryptor -is [System.IDisposable]) {
                $aesEncryptor.Dispose()
            }
        }

    }
    finally {
        if ($null -ne $encryptAes -and $encryptAes -is [System.IDisposable]) {
            $encryptAes.Dispose()
        }
    }
    return , $encryptedBytes
}

function Decrypt {
    [CmdletBinding()]
    [OutputType([Byte[]])]
    Param
    (
        [Parameter(Mandatory = $true, Position = 0)]
        [System.Byte[]] $encryptedBytes,
        [Parameter(Mandatory = $true, Position = 1)]
        [System.Byte[]] $key
    )
    try {
        [System.Byte[]] $decryptedBytes = [System.Byte[]]::new(0)
        $decryptAes = [System.Security.Cryptography.Aes]::Create()
        $decryptAes.Key = $key
        $decryptAes.Mode = [System.Security.Cryptography.CipherMode]::ECB
        $decryptAes.Padding = [System.Security.Cryptography.PaddingMode]::PKCS7
        try {
            $aesDecryptor = $decryptAes.CreateDecryptor()
            $decryptedBytes = $aesDecryptor.TransformFinalBlock($encryptedBytes, 0, $encryptedBytes.Length);
        }
        finally {
            if ($null -ne $aesDecryptor -and $aesDecryptor -is [System.IDisposable]) {
                $aesDecryptor.Dispose()
            }
        }

    }
    finally {
        if ($null -ne $decryptAes -and $decryptAes -is [System.IDisposable]) {
            $decryptAes.Dispose()
        }
    }
    return , $decryptedBytes


}


$key = [System.Text.Encoding]::UTF8.GetBytes($keyText)
#Write-ArrayToOutput -items $key | Format-Hex

$bytesToEncrypt = [System.Text.Encoding]::UTF8.GetBytes($textToEncrypt)
$encryptedBytes = Encrypt $bytesToEncrypt $key
$encryptedText = [System.Convert]::ToBase64String($encryptedBytes)
"Encrypted Text: $encryptedText"
$decryptedBytes = Decrypt $encryptedBytes $key
$decryptedText = [System.Text.Encoding]::UTF8.GetString($decryptedBytes)
"Decrypted Text: $decryptedText"