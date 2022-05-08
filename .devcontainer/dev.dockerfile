FROM python:3

ENV TZ=America/New_York \
    PYTHONBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    # add pipx path
    PATH=${PATH}:/home/dev/.local/bin

RUN useradd --create-home --shell /bin/bash dev \
    && apt-get update \
    && apt-get install -y \
    bash-completion \
    nano \
    sudo \
    && rm -rf /var/lib/apt/lists/* \
    && echo "dev ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/dev


USER dev
RUN python3 -m pip install --user pipx \
    && pipx install bandit \
    && pipx install black \
    && pipx install pylint \
    && pipx install glances \
    # install poetry
    && curl -sSL https://install.python-poetry.org | python3 - \
    && poetry config virtualenvs.create false \
    && mkdir --parents /home/dev/.local/share/bash-completion/completions \
    && poetry completions bash > /home/dev/.local/share/bash-completion/completions/poetry \
    && mkdir --parents /home/dev/.cache/pypoetry \
    # add /workspace/scripts to path
    && echo "export PATH=\$PATH:/workspace/.devcontainer/scripts" >> /home/dev/.bashrc \
    && echo "export PYTHONPATH=/home/dev/.local/lib/python3.10/site-packages:/workspace/src" >> /home/dev/.bashrc

CMD ["sleep", "infinity"]