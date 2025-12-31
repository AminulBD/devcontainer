# Dev Container for Multi-language Development

[![Build Status](https://github.com/AminulBD/devcontainer/workflows/Release/badge.svg)](https://github.com/AminulBD/devcontainer/actions)
[![Docker Hub](https://img.shields.io/docker/v/aminulbd/devcontainer?logo=docker)](https://hub.docker.com/r/aminulbd/devcontainer)
[![GitHub Container Registry](https://img.shields.io/badge/GHCR-aminulbd%2Fdevcontainer-blue?logo=github)](https://github.com/AminulBD/devcontainer/pkgs/container/devcontainer)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

> Multi-language development container for VS Code, GitHub Codespaces, and other compatible environments.

This devcontainer comes with multiple versions of PHP, Node.js, Go, Deno, and Python pre-installed. Perfect for full-stack developers working across different technology stacks.

## Features

This devcontainer comes with multiple versions of PHP, Node.js, Go, Deno, and Python pre-installed. Here's how to switch between versions:

### Switch PHP Version

To switch between installed PHP versions (5.6, 7.0-7.4, 8.0-8.5):

```bash
# Switch to PHP 8.3
sudo a2dismod php* && sudo a2enmod php8.3
sudo update-alternatives --set php /usr/bin/php8.3

# Verify the version
php -v
```

### Switch Node.js Version

To switch between Node.js versions (14, 16, 18, 20, 22, 24):

```bash
# Switch to Node.js 20
n 20

# Verify the version
node -v
```

### Switch Go Version

To switch between Go versions (1.22.12, 1.23.12, 1.24.11, 1.25.5):

```bash
# Switch to Go 1.24.11
ln -sf /usr/local/go/versions/1.24.11/bin/go /usr/local/bin/go
ln -sf /usr/local/go/versions/1.24.11/bin/gofmt /usr/local/bin/gofmt

# Verify the version
go version
```

### Switch Deno Version

To switch between Deno versions (1.46.3, 2.6.3):

```bash
# Switch to Deno 2.6.3
ln -sf /usr/local/deno/versions/2.6.3/deno /usr/local/bin/deno

# Verify the version
deno --version
```

### Switch Python Version

To switch between Python versions (2.7, 3.8-3.14):

```bash
# Switch to Python 3.12
pyenv global 3.12

# Verify the version
python --version
```

## Quick Start

### Using with VS Code

1. Create a `.devcontainer.json` in your project:

```json
{
  "image": "aminulbd/devcontainer:latest",
  "customizations": {
    "vscode": {
      "extensions": [
        "ms-python.python",
        "golang.go",
        "bmewburn.vscode-intelephense-client"
      ]
    }
  }
}
```

2. Open the folder in VS Code and click "Reopen in Container"

### Using with Docker CLI

```bash
docker run -it --rm aminulbd/devcontainer:latest bash
```

### Using with Docker Compose

```yaml
services:
  devcontainer:
    image: aminulbd/devcontainer:latest
    volumes:
      - .:/workspace
    working_dir: /workspace
    command: sleep infinity
```

## Included Software

- **Web Servers**: Apache2, Nginx
- **PHP**: 5.6, 7.0-7.4, 8.0-8.5 with common extensions
- **Node.js**: 14, 16, 18, 20, 22, 24
- **Go**: 1.22.12, 1.23.12, 1.24.11, 1.25.5
- **Deno**: 1.46.3, 2.6.3
- **Python**: 2.7, 3.8-3.14
- **Tools**: Composer, WP-CLI, Starship prompt, Air (Go live reload)

## Building Locally

To build the image locally:

```bash
docker build -t devcontainer:local .
```

To build with specific versions:

```bash
docker build \
  --build-arg PHP_VERSION=8.4 \
  --build-arg NODE_VERSION=22 \
  --build-arg GO_VERSION=1.24.11 \
  --build-arg PYTHON_VERSION=3.12 \
  -t devcontainer:local .
```

## Multi-Architecture Support

This image supports multiple architectures:
- `linux/amd64`
- `linux/arm64`

Pull the appropriate image for your platform:

```bash
docker pull aminulbd/devcontainer:latest
```

## Configuration

The container includes:
- Starship prompt for a beautiful terminal
- Pre-configured GOPATH at `$HOME/.go`
- Pyenv for Python version management
- `n` for Node.js version management
- Composer global packages including Laravel installer

## License

MIT License - see LICENSE file for details

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.