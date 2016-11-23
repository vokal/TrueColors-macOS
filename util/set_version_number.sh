#!/bin/bash

# Update the Info.plist build number with number of git commits (adjusted by 1000 to move past old build numbers)
buildNumber=$((1000 + $(git rev-list HEAD --count))) \
    || exit 1
echo "note: Updating build number to ${buildNumber}..."

# Update the Info.plist build number with number of git commits
/usr/libexec/PlistBuddy \
    -c "Set CFBundleVersion ${buildNumber}" \
    "${TARGET_BUILD_DIR}/${INFOPLIST_PATH}" \
    || exit 1

# Update the build number in the dsym's info.plist if it exists
# (prevents potential version mismatches with the dsym)
if [[ -e "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Info.plist" ]]; then
    /usr/libexec/PlistBuddy \
        -c "Set CFBundleVersion ${buildNumber}" \
        "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Info.plist" \
        || exit 1
fi

# Update the short version string
baseVersion=$(/usr/libexec/PlistBuddy -c "Print :TRUBaseVersionNumber" "${TARGET_BUILD_DIR}/${INFOPLIST_PATH}")
/usr/libexec/PlistBuddy \
    -c "Set :CFBundleShortVersionString ${baseVersion} (${buildNumber})" \
    "${TARGET_BUILD_DIR}/${INFOPLIST_PATH}" \
    || exit 1

echo "note: Done."
