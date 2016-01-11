Braise [![[travis]](https://travis-ci.org/IoraHealth/braise.png)](https://travis-ci.org/IoraHealth/braise)
======

Braise cooks those boring old JSON Schema definitions
down into rock-hard-awesome Ember CLI files.

INSTALLATION
------------

```sh
cd ~/src
git clone https://github.com/IoraHealth/braise.git
```

bash: `echo 'export PATH=$PATH:~/src/braise/bin' >> ~/.bash_profile`

USAGE
-----

```sh
braise --file <JSON_SCHEMA_FILE>
braise -f <JSON_SCHEMA_FILE>
```

Takes that boring JSON schema file and outputs some much better files.

PREREQUISITES
-------------

```
brew install elixir
mix deps.get
mix escript.build
mv braise bin
```

EXAMPLES
--------

The examples dir has some input json schemas and the corresponding output produced by braise.  To regenerate them

```
braise --file examples/source/v3/patients.json --output examples/output
braise --file examples/source/v3/medication_verification.json --output examples/output
braise --file examples/source/v20150918/sponsor_api.json --output examples/output
```

LICENSE
-------

Apache v2.0
