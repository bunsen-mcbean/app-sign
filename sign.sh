
export VERSION=`cat jamovi.app/Contents/Resources/jamovi/version`
export IDENTITY="Developer ID Application: Jonathon Love"
export ENTITLEMENTS=entitlements.plist

find "jamovi.app" -iname '*.so' -or -iname '*.dylib' |
    while read libfile; do
        echo signing "${libfile}"
        codesign --sign "${IDENTITY}" \
                 --entitlements "$ENTITLEMENTS" \
                 --deep "${libfile}" \
                 --force \
                 --options runtime;
    done;

codesign --deep --timestamp --verbose --force --entitlements "$ENTITLEMENTS" --sign "$IDENTITY" --options runtime jamovi.app/Contents/MacOS/python
codesign --deep --timestamp --verbose --force --entitlements "$ENTITLEMENTS" --sign "$IDENTITY" --options runtime jamovi.app/Contents/MacOS/jamovi
codesign --deep --timestamp --verbose --force --entitlements "$ENTITLEMENTS" --sign "$IDENTITY" --options runtime jamovi.app/Contents/MacOS/jamovi-engine
codesign --deep --timestamp --verbose --force --entitlements "$ENTITLEMENTS" --sign "$IDENTITY" --options runtime jamovi.app/Contents/MacOS/R
codesign --deep --timestamp --verbose --force --entitlements "$ENTITLEMENTS" --sign "$IDENTITY" --options runtime jamovi.app/Contents/Frameworks/R.framework/Versions/3.6/Resources/bin/exec/R

electron-osx-sign --binaries=jamovi.app/Contents/MacOS/python,jamovi.app/Contents/MacOS/jamovi,jamovi.app/Contents/MacOS/jamovi-engine --hardened-runtime=true --entitlements="$ENTITLEMENTS" --entitlements-inherit="$ENTITLEMENTS" jamovi.app

spctl -a -t exec -vvv jamovi.app
