# AES Example

## Using dotnet libraries for AES encryption 

AES/ECB/PKCS5Padding with a 16 byte / character symmetric key.

## Use case

This is a proof of concept for checking the encryption / decryption of LEGACY encrypted data given the key.

It could be used to decrypt existing legacy data and then you could migrate the data to more appropriate / modern encryption.

THE ENCRYPTION MECHANISMS USED IN THIS CODE MAY NOT BE SUITABLE DUE TO WEAK ALGORITHMS / PROCESSES.

USE MORE APPROPRIATE MECHANISMS FOR NEW PROJECTS.

## Running

### C# version

~~~powershell
dotnet build
dotnet run
~~~

### Powershell Version (for systems without dotnet command available)

~~~powershell
AesExample.ps1
~~~
