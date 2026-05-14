#!/usr/bin/env pwsh
#MISE description="Generate changelog"

$version = (Get-Content metadata.json | ConvertFrom-Json).version
git cliff -t $version
prettier -w changelog.md
git add changelog.md