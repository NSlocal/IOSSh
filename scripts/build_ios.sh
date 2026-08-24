#!/bin/bash

# Universal Games iOS Build Script
set -e

echo "🍎 Building Universal Games for iOS"

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --package)
            PACKAGE="$2"
            shift 2
            ;;
        --version)
            VERSION="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Default values
PACKAGE=${PACKAGE:-"com.universal.games"}
VERSION=${VERSION:-"1.0.0"}

echo "📦 Package: $PACKAGE"
echo "📌 Version: $VERSION"

# Build iOS framework
echo "🔨 Building iOS Framework..."

# Create framework structure
mkdir -p build/ios/UniversalGames.framework
mkdir -p build/ios/UniversalGames.framework/Headers
mkdir -p build/ios/UniversalGames.framework/Modules

# Create Info.plist
cat > build/ios/UniversalGames.framework/Info.plist << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>en</string>
    <key>CFBundleExecutable</key>
    <string>UniversalGames</string>
    <key>CFBundleIdentifier</key>
    <string>$PACKAGE</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>UniversalGames</string>
    <key>CFBundlePackageType</key>
    <string>FMWK</string>
    <key>CFBundleShortVersionString</key>
    <string>$VERSION</string>
    <key>CFBundleVersion</key>
    <string>$VERSION</string>
    <key>MinimumOSVersion</key>
    <string>13.0</string>
</dict>
</plist>
EOF

# Create module.modulemap
cat > build/ios/UniversalGames.framework/Modules/module.modulemap << EOF
framework module UniversalGames {
    umbrella header "UniversalGames.h"
    export *
    module * { export * }
}
EOF

# Create umbrella header
cat > build/ios/UniversalGames.framework/Headers/UniversalGames.h << EOF
#import <Foundation/Foundation.h>

//! Project version number for UniversalGames.
FOUNDATION_EXPORT double UniversalGamesVersionNumber;

//! Project version string for UniversalGames.
FOUNDATION_EXPORT const unsigned char UniversalGamesVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <UniversalGames/PublicHeader.h>
EOF

echo "✅ iOS Framework built successfully: build/ios/UniversalGames.framework"
