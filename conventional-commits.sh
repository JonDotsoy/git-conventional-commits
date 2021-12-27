#!/usr/bin/env sh

function _git_commit_conventional_valid_type() {
  TYPE=$1
  if [[ $TYPE == "build" || $TYPE == "chore" || $TYPE == "ci" || $TYPE == "docs" || $TYPE == "feat" || $TYPE == "fix" || $TYPE == "perf" || $TYPE == "refactor" || $TYPE == "revert" || $TYPE == "style" || $TYPE == "test" ]]; then
    return 0
  else
    return 1
  fi
}

function _git_commit_conventional_reset() {
  git config --local --remove-section git-commit-conventional
}

function _git_commit_conventional_get_commit() {
  TYPE=$1
  SCOPE=$(git config --local -z --get git-commit-conventional.scope)
  BREAKING_CHANGE=$(git config --local -z --get git-commit-conventional.breaking-change)
  BODY_FILE=$(git config --local -z --get git-commit-conventional.body-file-path)

  _git_commit_conventional_valid_type $TYPE
  if [[ $? != 0 ]]; then
    if [[ -z $TYPE ]]; then
      echo "type: <EMPTY> is not valid"
    else
      echo "type: $TYPE is not valid"
    fi
    exit 1
  fi

  HEAD="$TYPE"

  if [[ ! -z $SCOPE ]]; then
    HEAD="$TYPE($SCOPE)"
  fi

  if [[ $BREAKING_CHANGE == "true" ]]; then
    HEAD="$HEAD!"
  fi

  HEAD="$HEAD: ${@:2}"

  if [[ ! -z $BODY_FILE ]]; then
    if [[ -f $BODY_FILE ]]; then
      BODY=$(cat $BODY_FILE)
      HEAD="$HEAD\n\n$BODY"
    fi
  fi

  echo "$HEAD\c"
}

function _git_commit_conventional_set_breaking_change() {
  breaking_change=$([[ -z $1 ]] && echo "false" || [[ $1 == "true" || $1 == "on" || $1 == "1" ]] && echo "true" || echo "false")

  if [[ $breaking_change == "true" ]]; then
    echo "Breaking change: true"
    git config --local --replace-all --bool git-commit-conventional.breaking-change true
  else
    echo "Breaking change: false"
    git config --local --unset git-commit-conventional.breaking-change
  fi
}

function _git_commit_conventional_set_body_file() {
  git config --local --path --replace-all git-commit-conventional.body-file-path $1
}

function _git_commit_conventional_set_scope() {
  SCOPE=$1
  # check scope is not empty
  if [[ "" == "$SCOPE" ]]; then
    git config --local --unset git-commit-conventional.scope
    echo "Scope Removed"
    return 1
  fi

  git config --local --replace-all git-commit-conventional.scope $SCOPE

  echo "Scope Chaned: $SCOPE"
}

function _git_commit_conventional_commits() {
  git commit -m "$(_git_commit_conventional_get_commit $@)"
}

function help() {
  cat $HOME/.commit_conventional_commits/help.txt
}

function commit() {
  if [[ $1 == "build" || $1 == "chore" || $1 == "ci" || $1 == "docs" || $1 == "feat" || $1 == "fix" || $1 == "perf" || $1 == "refactor" || $1 == "revert" || $1 == "style" || $1 == "test" ]]; then
    _git_commit_conventional_commits "$1" "${@:2}"
    return 0
  elif [[ $1 == "scope" || $1 == "s" ]]; then
    _git_commit_conventional_set_scope ${@:2}
    return 0
  elif [[ $1 == "breaking-change" || $1 == "bc" ]]; then
    _git_commit_conventional_set_breaking_change ${@:2}
    return 0
  elif [[ $1 == "message" || $1 == "m" ]]; then
    _git_commit_conventional_get_commit ${@:2}
    return 0
  elif [[ $1 == "reset" ]]; then
    _git_commit_conventional_reset
    return 0
  elif [[ $1 == "body-file" ]]; then
    _git_commit_conventional_set_body_file $2
    return 0
  elif [[ $1 == "help" ]]; then
    help
    return 0
  else
    echo "Type not found. Please use one of the following types: build, chore, ci, docs, feat, fix, perf, refactor, revert, style, test."
    echo ""
    help
    return 1
  fi
}

commit $@
