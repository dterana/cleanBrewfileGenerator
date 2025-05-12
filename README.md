# Clean Brewfile Generator

A simple Bash script to generate a comprehensive `Brewfile` for your macOS system, including Homebrew taps, formulae, casks, Mac App Store apps, and VS Code extensions.

## Features
- Dumps all Homebrew taps, formulae, and casks
- Includes Mac App Store applications (via `mas`)
- Includes VS Code extensions
- Backs up existing Brewfile before overwriting
- Customizable output path
- Informative logging and error handling

## Requirements
- macOS
- [Homebrew](https://brew.sh/)

## Optional
- [mas](https://github.com/mas-cli/mas) (for Mac App Store apps)
- [VS Code](https://code.visualstudio.com/) (for VS Code extensions)
- [Whalebrew](https://github.com/whalebrew/whalebrew) (for Whalebrew packages)

## Usage

```sh
./generate_brewfile.sh [-o|--output <path>] [-h|--help]
```

### Options
- `-o`, `--output <path>`: Specify output Brewfile path (default: `Brewfile`)
- `-h`, `--help`: Show help message and exit

### Example
Generate a Brewfile in the current directory:

```sh
./generate_brewfile.sh
```

Generate a Brewfile at a custom location:

```sh
./generate_brewfile.sh --output /path/to/MyBrewfile
```

## Example Output
An example of a generated Brewfile can be found in the `brewfile_example` folder.

## How It Works
- The script checks for Homebrew installation
- If a Brewfile already exists at the output location, it is automatically backed up by renaming it with a timestamp suffix.
- **Backup file name format:** `Brewfile.<yymmdd-hhmmss>` (e.g., `Brewfile.250512-125456` for a backup made on May 12, 2025 at 12:54:56)
- Dumps taps, formulae, casks, Mac App Store apps, and VS Code extensions into the Brewfile
- Cleans up temporary files automatically

## License
MIT

## Version
1.0.0

## Author
David Terana
