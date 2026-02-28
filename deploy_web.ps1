# NotIdea - Flutter Web Build & Vercel Deploy
# Kullanım: .\deploy_web.ps1

Write-Host "Building Flutter web..." -ForegroundColor Cyan
flutter build web --release --web-renderer canvaskit

if ($LASTEXITCODE -ne 0) {
    Write-Host "Build failed!" -ForegroundColor Red
    exit 1
}

Write-Host "Copying vercel.json..." -ForegroundColor Cyan
Copy-Item vercel.json build\web\vercel.json -Force

Write-Host "Deploying to Vercel..." -ForegroundColor Cyan
vercel deploy build\web --prod
