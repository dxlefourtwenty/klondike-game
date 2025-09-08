# deploy.ps1
# Deploy Flutter web build to gh-pages branch

# 1. Make sure main branch is up to date
git checkout main
git pull origin main

# 2. Build the Flutter web project
flutter build web

# 3. Split the build/web folder into a temporary branch
git subtree split --prefix build/web -b gh-pages-temp

# 4. Force push the temporary branch to gh-pages
git push origin gh-pages-temp:gh-pages --force

# 5. Delete the temporary branch locally
git branch -D gh-pages-temp

Write-Host "✅ Deployment to gh-pages completed!"
