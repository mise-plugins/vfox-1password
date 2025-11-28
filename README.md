# vfox-1password

A [vfox](https://github.com/version-fox/vfox) plugin for [1Password CLI](https://developer.1password.com/docs/cli/).

## Install

```bash
# With mise
mise use 1password@latest

# With vfox
vfox add 1password
vfox install 1password@latest
```

## Usage

```bash
# List available versions
mise ls-remote 1password

# Install a specific version
mise use 1password@2.30.0

# Verify installation
op --version
```

## License

MIT
