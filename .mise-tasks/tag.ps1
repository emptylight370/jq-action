#!/usr/bin/env pwsh
#MISE description="Create tag and push"

# 获取版本号
$metadata = Get-Content "metadata.json" -Raw | ConvertFrom-Json
$version = $metadata.version
Write-Host "Version from metadata: $version"

# 生成标签
$tag_name = "v$version"

# 创建标签
Write-Host "Creating tag: $tag_name"
git tag -s $tag_name -m ""

# 推送标签
Write-Host "Pushing tag to remote: $tag_name"
git push origin $tag_name

# 生成主版本标签
$major_version = "v$($version.Split('.')[0])"
Write-Host "Creating major version tag: $major_version"

# 删除原有标签，重新创建标签
$existing_tag = git tag -l $major_version
if ($existing_tag) {
  git tag -d $major_version
  git push origin --delete $major_version
  git tag -s $major_version -m ""
}

# 推送主版本标签
Write-Host "Pushing major version tag to remote: $major_version"
git push origin $major_version

Write-Host "Tags created and pushed successfully!"
