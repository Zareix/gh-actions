#!/bin/bash

type=$TYPE
file=$FILE
regex=$REGEX

if [ "$type" = "node" ]; then
  if [ "$file" = "__NONE__" ]; then
    file="package.json"
  fi
  if [ -f "$file" ]; then
    echo "Found '$file' file"
    if [ "${file:0:2}" != "./" ]; then
      file="./$file"
    fi
    VERSION=$(node -p "require('$file').version")
  else
    echo "Could not find '$file'"
    exit 1
  fi
elif [ "$type" = "file" ]; then
  if [ "$file" = "__NONE__" ]; then
    file="VERSION"
  fi
  if [ -f "$file" ]; then
    echo "Found '$file' file"
    VERSION=$(cat "$file")
  else
    echo "Could not find '$file' file"
    exit 1
  fi
elif [ "$type" = "regex" ]; then
  echo "Using regex: $regex"
  if [ "$file" = "__NONE__" ]; then
    file="VERSION"
  fi
  if [ -f "$file" ]; then
    echo "Found '$file' file"
    VERSION=$(grep -oP "$regex" "$file")
  else
    echo "Could not find '$file' file"
    exit 1
  fi
else
  echo "Invalid type"
  exit 1
fi

if [ -z "$VERSION" ]; then
  echo "Could not find a version"
  exit 1
fi

echo "Found version: $VERSION"
echo "version=$VERSION" >>$GITHUB_OUTPUT
