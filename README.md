# Git Conventional Commits

Command line tool to generate conventional commits in terminal.



![image](https://user-images.githubusercontent.com/3086539/147137713-2afb31fa-b2ff-4005-ac27-49518b25eb8e.png)


## How to install

Run the next line in your shell terminal

```shell
curl -L https://gist.github.com/JonDotsoy/80f495333905a9b702fb681cd1a8faf2/raw/install.sh | sh
```

## Starship Integration

Add custom command to look the current scope setted.

![image](https://user-images.githubusercontent.com/3086539/147137129-fbb8c56a-d23f-46a9-8a12-2bb330293e1f.png)


Open the `starship.toml` file and add the next command:

```toml
[custom.git-commit-conventional_scope]
command = 'echo "$(git config --local -z --get git-commit-conventional.scope)$([[ $(git config --local --get git-commit-conventional.breaking-change) == "true" ]] && echo "!" )"'
when = 'git config --local -z --get git-commit-conventional.scope'
style = "bold green"
symbol = "❇️"
format = "[$symbol ($output )]($style)"
```

