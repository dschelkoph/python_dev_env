# Python Development Environment
A ready-made [development container](https://code.visualstudio.com/docs/remote/containers) with the following features:

- Package management: [poetry](https://python-poetry.org/)
- Code formatter: [black](https://black.readthedocs.io/en/stable/)
- Type checking: [pyright](https://github.com/microsoft/pyright)
- Test framework: [pytest](https://docs.pytest.org/en/latest/)
- Test coverage: [coverage.py](https://coverage.readthedocs.io/en/latest/)
- Linters:
    - [pylint](https://pylint.pycqa.org/en/latest/)
    - [bandit](https://bandit.readthedocs.io/en/latest/)
- Import sorter: [isort](https://pycqa.github.io/isort/)
- Resource monitor: [glances](https://nicolargo.github.io/glances/)
- Central development tool configuration using [PEP 518](https://peps.python.org/pep-0518/), `pyproject.toml` file
- Features VS Code Adds To Dev Environment (through IDE Settings: devcontainer.json)
    - Auto save
    - Format on save
    - Organize imports on save
    - Extensions:
        - Language Server:
            - [ms-python.python](https://marketplace.visualstudio.com/items?itemName=ms-python.python)
            - [ms-python.pylance](https://marketplace.visualstudio.com/items?itemName=ms-python.vscode-pylance)
        - Assist in generation of docstrings: [njpwerner.autodocstring](https://marketplace.visualstudio.com/items?itemName=njpwerner.autodocstring)
        - Quickly start a server to render webpages: [ritwickdey.liveserver](https://marketplace.visualstudio.com/items?itemName=ritwickdey.LiveServer)
        - View test coverage in editor gutters: [ryanluker.vscode-coverage-gutters](https://marketplace.visualstudio.com/items?itemName=ryanluker.vscode-coverage-gutters)
        - TOML Support: [tamasfe.even-better-toml](https://marketplace.visualstudio.com/items?itemName=tamasfe.even-better-toml)
    - Python Tools (can be directly installed into container using [pipx](https://pypa.github.io/pipx/installation/)):
        - Type checking: [pyright](https://github.com/microsoft/pyright)
        - Import sorter: [isort](https://pycqa.github.io/isort/)

Currently missing profilers, hope to add these in the future.

# Prerequisites
Besides the requires listed in the [VS Code Documentation](https://code.visualstudio.com/docs/remote/containers#_system-requirements) you will need the following:

1. A docker volume named `poetry_cache` will need to be created. In your terminal run the following command:
    ```
    docker volume create poetry_cache
    ```
    This volume caches package downloads and is able to be shared between containers/rebuilds.  This allows repeated package installation to happen more quickly.

2. VS Code with the [Remote Development Extension Pack](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack)

# Startup
1. Clone repo
1. Open folder in VS Code
1. Press the button in the lower left corner that looks similar to: `><`
1. In the menu that appears in the top middle of the screen, select `Reopen in Container`

VS Code will use the files in the `.devcontainer` folder to build the development container image.  Once the image is built, VS Code will install the VS Code server in the container and run `.devcontainer/vscode_scripts/post_create.bash`.

After this process you will be able to use the development environment.

# Use container without VS Code
It is possible to use this container without VS Code, but will require:
- Adding whatever code editing tools you prefer
- Install isort and pyright using pipx
- Install python packages (`poetry update` should work in most cases).

You can build and run the container using the following commands:

```
# Navigate to <repo dir>/.devcontainer
docker-compose build devcontainer
docker-compose up -d

# enter into the container started above
docker exec -it <name of container> /bin/bash
```

# Additional Information

## Default User
The default user is `dev` with UID of 1000. It has full admin permissions via `sudo`

## Dev Tools
As many dev tools as possible are installed using [pipx](https://pypa.github.io/pipx/installation/) so that they don't interfere with your project's package management. `pytest` and `pytest-cov` are installed in the environment under `tool.poetry.dev-dependencies`.

All dev tools listed are configured by the `pyproject.toml` file.

## Using Poetry
Any python packages in the `tool.poetry.dependencies` and `tool.poetry.dev-dependencies` tables in `pyproject.toml` file will be installed when the container is built.

Anything installed using `pip` will not persist between rebuilds.

Add packages using the [`poetry add`](https://python-poetry.org/docs/cli/#add) command.

By default, this container disables Poetry's Virtual Environment Creation. This means that packages are installed in `/home/dev/.local/lib/python3.<minor version>/site-packages`.  This is automatically added to PYTHONPATH in the `dev` user's `~/.bashrc` file in `.devcontainer/dev.dockerfile`.

If you are using VS Code, make sure PYTHONPATH is also set in the top-level `.env` file. VS Code uses this PYTHONPATH variable for some of its python tools.

The default PYTHONPATH is configured for python3.10.

## Running Coverage Reports
`pytest-cov` does not run when test are run in VS Code to prevent performance issues (this can be changed in the `pyproject.toml` file). To get coverage information, run `git_coverage.sh`.  It will create a `coverage` folder with both XML and HTTP reports.  To view the HTTP report, select the index file of the report and click the `Go Live` button in the lower right corner of the VS Code Window.

The HTTP report will show you what tests covered what lines (the `show_contexts` option).

The XML report is used by a VS Code extension to show code coverage in the editor gutters.  Click on the `Watch` button in the lower blue bar on the left side to toggle gutters.

# Details of .devcontainer Directory

## scripts
The container adds `.devcontainer/scripts` to the user's PATH.  Anything in this directory can be run directly from the prompt.  This is where `get_coverage.sh` resides to run coverage information.

## templates
Contains an original `pyproject.toml`, use this to go back to the defaults of the container.

## vscode_scripts
Directory for files that are meant to be run by VS Code Hooks during container build/startup. VS Code refers to them as [Lifecycle Scripts](https://code.visualstudio.com/docs/remote/devcontainerjson-reference#_lifecycle-scripts).  By default, the `postCreate` hook runs `post_create.bash` which installs python packages through poetry.

## dev.dockerfile
Standard dockerfile that describes the base development container. This container can be altered after creation from the Lifecycle Scripts above.

## devcontainer.json
[Configuration file](https://code.visualstudio.com/docs/remote/devcontainerjson-reference) for using development container within VS Code.  Contains IDE Settings and directions on how to build the container.

## docker-compose.yaml
Provides settings for building and running the development container.