# aminulbd/devcontainer

My personal development container for VS Code, GithHub Codespaces, and other compatible environments.

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