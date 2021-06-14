# GeneSystem

[![Ruby](https://github.com/andrewbigger/gene_system/actions/workflows/build.yml/badge.svg?branch=main)](https://github.com/andrewbigger/gene_system/actions/workflows/build.yml)

A gem for configuring systems via json or jsonnet manifest.

## Installation

Install the gem into your system:

```bash
gem install gene_system
```

## Usage

### Creating a Configuration Manifest

Once installed, you can create a configuration manifest by calling the `new` command:

```bash
genesystem new manifest
```

This creates a file called `manifest.json` in which you can write configuration steps.

### Writing a Configuration Manifest

A configuration manifest looks like this:

```json
{
  "name": "manifest",
  "version": "0.0.1",
  "metadata": {
    "gene_system": {
      "version": "0.3.1"
    }
  },
  "steps": [
    {
      "name": "say hello",
      "exe": {
        "install": {
          "cmd": [
            "echo \"hello\""
          ]
        },
        "remove": {
          "cmd": [
            "echo goodbye"
          ]
        }
      },
      "tags": "example step"
    }
  ]
}
```

Below is a description of the root level manifest attributes, each of which is required:

- `name` is the name of the configuration manifest
- `version` refers to the version of the configuration. You might want to increment this number as you make changes to the manifest.
- `metadata` contains data about the manifest, notably the `gene_system > version` attribute which governs the minimum version of the Gene System gem required to execute the manifest
- `steps` an array of step objects that configure a host machine. 

#### Step Objects

Each step is executed in order and should be in the following format:

```json
{
  "name": "say hello",
  "exe": {
    "install": {
      "cmd": [
        "echo \"hello\""
      ]
    },
    "remove": {
      "cmd": [
        "echo goodbye"
      ]
    }
  },
  "tags": "example step"
}
```

Steps have a `name`, `exe` and `tag` attribute.

- `name` refers to the step name, this will be printed in STDOUT when the step is being executed.
- `exe` is an object that runs during the application or removal of a manifest. It can take an `install` or `remove` object (described below)
- `tags` a space separated string of tags.

#### Install and Remove Objects

The install and remove objects are basically the same, only differing in the sense that the `install` exe instructions are run when the `genesystem install` command is run, and the `remove` exe instructions when the `genesystem remove` command is run.

The install and remove objects require a `cmd` array like the one in the example above. These should be shell commands to be run.

Optionally, both the install and remove objects can accept the following:

- `skip` command that prevents execution of `cmd` instructions
- `prompts` array of prompt that asks the user for input

##### Skip

Skip instructions can speed up the execution of a configuration manifest, by running a shell command to determine whether the step is required.

Skip works by executing a shell command and evaluating whether it returned a zero status (in other words is truthy).

For example you might wish to skip a command in the event that a file or folder exists. You would do this by adding a step like this:

```json
{
  "name": "say hello",
  "exe": {
    "install": {
      "skip": "[ -f greeted.txt ]",
      "cmd": [
        "echo \"hello\""
      ]
    }
  },
  "tags": "example step"
}
```

The `echo "hello"` command would only execute if the `greeted.txt` file does not exist.

##### Prompts

Prompts is an array of objects that describes a prompt for user input. A prompt looks like this:

```json
{
  "prompt": "Please enter your name",
  "var": "name"
}
```

Before the `exe` commands are run, the user will be asked for input, and that input will be saved to a variable named the value of `var`.

In the above example, the user input would be saved to the `name` variable.

The variable is rendered into the `cmd` command using handlebars syntax. Using the example above a prompt can be used thus:

```json
{
  "name": "say hello",
  "exe": {
    "install": {
      "prompts": [
        {
          "prompt": "Please enter your name",
          "var": "name"
        }
      ],
      "cmd": [
        "echo \"hello {{ name }}\""
      ]
    }
  },
  "tags": "example step"
}
```

### Installing a Configuration Manifest

Once a manifest file is created, Gene System can apply the changes described in the manifest using the `install` command with the relative path to the manifest json as an argument.

```bash
genesystem install /path/to/manifest.json
```

This will select all of the `install` commands from the steps and execute them.

### Removing a Configuration Manifest

The Gene System manifest defines `remove` steps which are intended to be reverse commands for removing the configuration applied by the `install` commands. A good manifest should provide these to return a machine to a default state if required.

The `remove` steps can be run by calling the `remove` command with the relative path to the manifest json as an argument:

```bash
genesystem remove /path/to/manifest.json
```

### Jsonnet Support

[Jsonnet](https://jsonnet.org/) is a data templating language for specifying configuration files, and it is a supported format for Gene System manifests.

This might be useful where step loops are useful. 

```jsoonnet
local conf = {
  varibles: {
    pkg: {
      apts: [
        {
          "name": "docker.io"
        },
        {
          "name": "postgresql-client"
        }
      ]
    }
  }
}

{
  "name": "manifest",
  "version": "0.0.1",
  "metadata": {
    "gene_system": {
      "version": "0.3.1"
    }
  },
  "steps": [] + [
    // install apt packages
    {
      "name": "install " + apt.name,
      "exe": {
        "install": {
          "cmd": [
            "echo password | sudo -S apt-get install " + apt.name
          ]
        },
      },
      "tags": "install " + apt.name
    } for apt in conf.variables.pkg.apts
  ]
}
```

## Tests and Quality

Tests cover this project and are written in RSpec. You'll find them in the spec folder.

```bash
bundle exec rspec spec
```

Tests and quality tasks are included in the default rake task which can be run thus:

```bash
bundle exec rake
```

## Contributing

See CONTRIBUTING.md for more information

## Licence

This gem is covered by the terms of the MIT licence. See LICENCE for more information
