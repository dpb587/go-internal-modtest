#!/bin/bash

set -eu

export GIT_COMMITTER_DATE='Fri Jan 01 00:00:00 2021 -0000'
export GIT_AUTHOR_DATE="${GIT_COMMITTER_DATE}"

rm -fr repo
mkdir repo
cd repo
cp ../README.md ../LICENSE ../generate.sh ./
git init .
git branch -M main
git remote add origin git@github.com:dpb587/go-internal-modtest.git

go mod init go.dpb.io/internal/modtest
( echo 'package modtest' ; echo ; echo 'const Version = "modtest/0.0.0+dev.main"' ) > version.go
git add .
git commit -m main

git checkout -b v1 main
( echo 'package modtest' ; echo ; echo 'const Version = "modtest/1.0.0"' ) > version.go
git add .
git commit -m v1.0.0
git tag -a -m v1.0.0 v1.0.0

( echo 'package modtest' ; echo ; echo 'const Version = "modtest/1.1.0"' ) > version.go
git add .
git commit -m v1.1.0
git tag -a -m v1.1.0 v1.1.0

git checkout -b v2 main
go mod edit -module go.dpb.io/internal/modtest/v2
( echo 'package modtest' ; echo ; echo 'const Version = "modtest/2.0.0"' ) > version.go
git add .
git commit -m v2.0.0
git tag -a -m v2.0.0 v2.0.0

( echo 'package modtest' ; echo ; echo 'const Version = "modtest/2.1.0"' ) > version.go
git add .
git commit -m v2.1.0
git tag -a -m v2.1.0 v2.1.0

( echo 'package modtest' ; echo ; echo 'const Version = "modtest/2.1.1"' ) > version.go
git add .
git commit -m v2.1.1
git tag -a -m v2.1.1 v2.1.1

( echo 'package modtest' ; echo ; echo 'const Version = "modtest/2.2.0"' ) > version.go
mkdir -p cmd/modtestmain
cd cmd/modtestmain
( echo 'package main' ; echo ; echo 'import "fmt"' ; echo ; echo 'main() {' ; echo '	fmt.Println("main")' ; echo '}' ) > main.go
go mod init go.dpb.io/internal/modtest/cmd/modtestmain/v2
git add .
git commit -m v2.2.0
git tag -a -m v2.2.0 v2.2.0

git push origin --mirror --force
