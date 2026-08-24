#!/bin/bash

# Universal Games Deploy Script
set -e

echo "🚀 Deploying Universal Games Package"

VERSION=${1:-"1.0.0"}
PLATFORM=${2:-"all"}

echo "📌 Version: $VERSION"
echo "📱 Platform: $PLATFORM"

deploy_android() {
    echo "📱 Deploying Android APK..."
    mkdir -p deploy/android
    cp build/android/*.apk deploy/android/
    echo "✅ Android deployment complete"
}

deploy_ios() {
    echo "🍎 Deploying iOS Framework..."
    mkdir -p deploy/ios
    cp -r build/ios/UniversalGames.framework deploy/ios/
    echo "✅ iOS deployment complete"
}

deploy_package() {
    echo "📦 Deploying package..."
    mkdir -p deploy/package
    cp package.json deploy/package/
    cp README.md deploy/package/
    cp LICENSE deploy/package/
    echo "✅ Package deployment complete"
}

case $PLATFORM in
    "android")
        deploy_android
        ;;
    "ios")
        deploy_ios
        ;;
    "all")
        deploy_android
        deploy_ios
        deploy_package
        ;;
    *)
        echo "❌ Unknown platform: $PLATFORM"
        exit 1
        ;;
esac

echo "🎉 Deployment complete!"
