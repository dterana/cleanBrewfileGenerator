# Brewfile Generator

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
- [mas](https://github.com/mas-cli/mas) (for Mac App Store apps)
- [VS Code](https://code.visualstudio.com/) (for VS Code extensions)

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

## How It Works
- The script checks for Homebrew installation
- Backs up any existing Brewfile at the output location
- Dumps taps, formulae, casks, Mac App Store apps, and VS Code extensions into the Brewfile
- Cleans up temporary files automatically

## License
MIT

## Version
1.0.0

## Author
David Terana
