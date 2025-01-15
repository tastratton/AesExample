using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;

// https://learn.microsoft.com/en-us/dotnet/api/system.security.cryptography.aes?view=net-9.0

namespace AesExample;
public class Program
{
    public static void Main(string[] args)
    {
        string? keyText;
        do 
        {
            Console.Write("Enter keyText: ");
            keyText = Console.ReadLine();
        } while (keyText is null);
        byte[] key = Encoding.UTF8.GetBytes(keyText);

        string? textToEncrypt;
        do
        {
            Console.Write("Text to encrypt: ");
            textToEncrypt = Console.ReadLine();
        } while (textToEncrypt is null);
        byte[] bytesToEncrypt = Encoding.UTF8.GetBytes(textToEncrypt);

        byte[] encryptedBytes = Encrypt(bytesToEncrypt, key);
        string encryptedText = Convert.ToBase64String(encryptedBytes);
        Console.WriteLine("Encrypted Text: " + encryptedText);

        byte[] decryptedBytes = Decrypt(encryptedBytes, key);
        string decryptedText = Encoding.UTF8.GetString(decryptedBytes);
        Console.WriteLine("Decrypted Text: " + decryptedText);

    }

    static byte[] Encrypt(byte[] unencryptedBytes, byte[] key)
    {
        byte[]? encryptedBytes = null;

        using (Aes encryptAes = Aes.Create())
        {
            encryptAes.Key = key;
            encryptAes.Mode = CipherMode.ECB;
            encryptAes.Padding = PaddingMode.PKCS7;

            using (ICryptoTransform aesEncryptor = encryptAes.CreateEncryptor())
            {
                encryptedBytes = aesEncryptor.TransformFinalBlock(unencryptedBytes, 0, unencryptedBytes.Length);
            }
        }

        return encryptedBytes;
    }

    static byte[] Decrypt(byte[] encryptedBytes, byte[] key)
    {
        byte[]? decryptedBytes = null;

        using (Aes decryptAes = Aes.Create())
        {
            decryptAes.Key = key;
            decryptAes.Mode = CipherMode.ECB;
            decryptAes.Padding = PaddingMode.PKCS7;

            using (ICryptoTransform aesDecryptor = decryptAes.CreateDecryptor())
            {
                decryptedBytes = aesDecryptor.TransformFinalBlock(encryptedBytes, 0, encryptedBytes.Length);
            }
        }

        return decryptedBytes;
    }
}
