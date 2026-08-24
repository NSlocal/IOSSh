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
    if [ -f "build/android/*.apk" ]; then
        cp build/android/*.apk deploy/android/
        echo "✅ Android deployment complete"
    else
        echo "⚠️ No APK found in build/android/"
    fi
}

deploy_ios() {
    echo "🍎 Deploying iOS Framework..."
    mkdir -p deploy/ios
    if [ -d "build/ios/UniversalGames.framework" ]; then
        cp -r build/ios/UniversalGames.framework deploy/ios/
        echo "✅ iOS deployment complete"
    else
        echo "⚠️ No iOS framework found in build/ios/"
    fi
}

deploy_package() {
    echo "📦 Deploying package..."
    mkdir -p deploy/package
    if [ -f "package.json" ]; then
        cp package.json deploy/package/
    fi
    if [ -f "README.md" ]; then
        cp README.md deploy/package/
    fi
    if [ -f "LICENSE" ]; then
        cp LICENSE deploy/package/
    fi
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
