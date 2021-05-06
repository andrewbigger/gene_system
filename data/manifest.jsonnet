local conf = {
  variables: {
    apps: [
      {
        "name": "virtualbox",
        "version": "6.0.1",
      },
      {
        "name": "vagrant",
        "version": "9.0.2",
      },
    ],

    bins: [
      "libc",
      "libd",
      "libe"
    ]
  }
};

{
  "name": "macos_ruby_dev",
  "version": "0.1.1",
  "platform": "macos",
  "metadata": {
    "gene_system": {
      "version": "0.1.0"
    },
  },
  "steps": [
    // install apps
    {
      "name": "install " + app.name,
      "exe": {
        "install": {
          "skip": "which yolo",
          "cmd": [
            "echo install " + app.name + app.version 
          ],
        },
        "remove": {
          "cmd": [
            "echo remove " + app.name + app.version 
          ],
        },
      },
      "tags": "app " + app.name
    } for app in conf.variables.apps
  ] + [
    // install bins
    {
      "name": "install " + bin,
      "exe": {
        "install": {
          "cmd": [
            "echo install " + bin 
          ],
        },
        "remove": {
          "cmd": [
            "echo remove " + bin 
          ],
        },
      },
      "tags": "app " + bin
    } for bin in conf.variables.bins
  ] + [
    {
      "name": "ask for input",
      "exe": {
        "install": {
          "prompts": [
            {
              "prompt": "Please enter your name",
              "var": "name",
            },
          ],
          "cmd": [
            "echo 'Hello {{name}}'"
          ],
        },
      },
      "tags": "input"
    },
  ],
}
