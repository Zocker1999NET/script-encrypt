# Script-Encrypt

This is a tool which allows you to hide the bad script code you write.
Also you can use this tool to secure any executable file.
For this it uses gpg2.

This tool was designed to encrypt script code,
but it should work with any other binary file which can be executed,
like text files with a shebang (shell, Python, …) or binary executables.

## Use Case

- You are not able to write good shell scripts,
  even after several video tutorials
- You want to build a binary but you only know how to write shell scripts

## Usage

```
./script-encrypt.sh <key> <in> <out>
```

- The script will be encrypted for **key**.
  You can use a mail address, a name or a part of the fingerprint.
  As long as `gpg --list-keys <key>` does list exactly the one key you want,
  it is good enough for this tool.
- **in** and **out** are the input and output files respectively.
  You can omit these or use `-` to refer to stdin / stdout.

### Example

0. Ensure you have stored your key or the key of a person you want to suprise with your "coding skills" in your gpg key database.
1. Create a script without making effort creating readable or maintenable code.
   Otherwise there should be no reason to use this tool.
   This example assumes you called the file `my-shitty-code.sh`
2. Download this tool and make it executable.
3. Call the script and let it hide your shameful code:
   `./script-encrypt.sh 12345678 my-shitty-code.sh binary-file`
4. Remove your old shitty code `rm my-shitty-code.sh` and be happy executing your `binary-file`.
   Please remember that you may need to unlock your gpg key while executing the `binary-file`.

## How it works

This tool encrypts the original code and embeds the armor version of the encrypted blob into shell script,
which is capable of decrypting the blob and executing it right away.
The decrypted version, which will be executed, will be stored in a temp file,
which can only be read by the current user.
The decrypted version will be removed after its execution
even if the execution failed.

Because gpg just ignores the header and footer of the generated script,
you can extract the code written by calling `gpg -d < binary-file`
if you want to see your shitty code again.

## License

This project is licensed under MIT.
