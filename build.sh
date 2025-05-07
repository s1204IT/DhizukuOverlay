#!/bin/bash

# Remove built artifacts
echo "Removing old files..."
rm -v -f res.zip DhizukuOverlay-unaligned.apk DhizukuOverlay.apk DhizukuOverlay.apk.idsig
echo

# Build APK
echo "Building APK..."
#aapt package -v -M AndroidManifest.xml -S res -I $ANDROID_HOME/platforms/android-35/android.jar --min-sdk-version 26 --target-sdk-version 29 -F DhizukuOverlay-unaligned.apk
aapt2 compile -v --dir res -o res.zip
aapt2 link -v --manifest AndroidManifest.xml -I $ANDROID_HOME/platforms/android-35/android.jar -R res.zip --min-sdk-version 26 --target-sdk-version 29 --version-name "1.0" --version-code 1 --auto-add-overlay -o DhizukuOverlay-unaligned.apk
rm res.zip
echo

# Align APK
echo "Aligning APK..."
zipalign -pvf 4 DhizukuOverlay-unaligned.apk DhizukuOverlay.apk
rm DhizukuOverlay-unaligned.apk
echo

# Sign APK
echo "Signing APK..."
apksigner sign -v --v1-signing-enabled true --v2-signing-enabled false --v3-signing-enabled false --key cert/cert.pk8 --cert cert/cert.pem DhizukuOverlay.apk
apksigner verify -v --print-certs DhizukuOverlay.apk
#rm DhizukuOverlay.apk.idsig
echo

# Show file info
echo "Done!!"
ls -lZ DhizukuOverlay.apk
