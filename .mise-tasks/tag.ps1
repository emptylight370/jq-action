#!/usr/bin/env pwsh
#MISE description="Create tag and push"

$metadata = Get-Content "metadata.json" -Raw | ConvertFrom-Json
$version = $metadata.version
Write-Host "Version from metadata: $version"

$tag_name = "v$version"

Write-Host "Creating tag: $tag_name"
git tag -s $tag_name -m ""

Write-Host "Pushing tag to remote: $tag_name"
git push origin $tag_name

$major_version = "v$($version.Split('.')[0])"
Write-Host "Creating major version tag: $major_version"
git tag -s $major_version -m ""

Write-Host "Pushing major version tag to remote: $major_version"
git push origin $major_version --force

Write-Host "Tags created and pushed successfully!"
