# Braise [![[travis]](https://travis-ci.org/IoraHealth/braise.png)](https://travis-ci.org/IoraHealth/braise)

Braise cooks those boring old JSON Schema definitions
down into rock-hard-awesome Ember Data adapters and models.

Releases published on hex.pm at https://hex.pm/packages/braise.

Braise generates Ember Data adapters and models compatible with **Ember Data 2.7+**.

## Installation

```sh
cd ~/src
git clone https://github.com/IoraHealth/braise.git
```

### Add to your PATH
#### Bash
```
echo 'export PATH=$PATH:~/src/braise/bin' >> ~/.bash_profile
```

#### Zsh
```
echo 'export PATH=$PATH:~/src/braise/bin' >> ~/.zshrc
```

## Usage

```sh
$ braise [--file|-f] <JSON_SCHEMA_FILE>
```

Takes that boring JSON schema file and outputs some much better files.

## Building

1. Ensure Elixir 1.4+ is installed. On macOS: `brew install elixir`.
2. Run `make`. See more targets in the [`Makefile`](Makefile)

## Examples

The examples dir has some input json schemas and the corresponding output produced by braise.  To regenerate them

```sh
$ make samples
```

## License
MIT. See [LICENSE.md](LICENSE.md) for full license text.
