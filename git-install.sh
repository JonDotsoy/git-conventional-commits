#!/usr/bin/env sh

PATH_COMMIT_BASE="$HOME/.commit_conventional_commits"
PATH_COMMIT_SCRIPT="$HOME/.commit_conventional_commits/commit.sh"
GIT_ALIAS_COMMAND='!sh'
GIT_ALIAS_COMMAND="$GIT_ALIAS_COMMAND $PATH_COMMIT_SCRIPT"

mkdir -p $PATH_COMMIT_BASE

curl -L -o $PATH_COMMIT_SCRIPT https://gist.github.com/JonDotsoy/80f495333905a9b702fb681cd1a8faf2/raw/commit.sh

git config --global --replace-all alias.conventional-commit "$GIT_ALIAS_COMMAND"
git config --global --replace-all alias.m "conventional-commit"
git config --global --replace-all alias.scope "conventional-commit scope"
git config --global --replace-all alias.bc "conventional-commit breaking-change"
git config --global --replace-all alias.breaking-change "conventional-commit breaking-change"

echo ""
echo "Success installed 🎉"
echo ""
echo "To use, just run:"
echo ""
echo "    git scope <scope>"
echo ""
echo "    git m <type> <message>"
echo ""

