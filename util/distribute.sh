#!/bin/bash

echo "note: Starting..."

# Don't allow this to run with uncommitted changes.
if [[ $(cd "${PROJECT_DIR}"; git diff --shortstat 2> /dev/null | tail -n1) != "" ]]; then
    echo "error: There are uncommitted changes."
    exit 1
fi

# Get the directory in which this script lives.
SCRIPT_DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)

# Create a temporary directory in which to work.
WORKING_DIR="$(mktemp -dt "${PROJECT}")" || exit 1
echo "note: Using temp directory ${WORKING_DIR}..."

# Clean and Archive.
echo "note: Building clean and archiving..."
ARCHIVE_PATH="${WORKING_DIR}/${PROJECT}.xcarchive"
xcodebuild \
    clean archive \
    -workspace "${PROJECT_DIR}/${PROJECT}.xcworkspace" \
    -scheme "${PROJECT}" \
    -archivePath "${ARCHIVE_PATH}" \
    > /dev/null \
    || exit 1

# Export & Sign.
echo "note: Exporting .app signed with Developer ID..."
APP_PATH="${WORKING_DIR}/${PROJECT}.app"
xcodebuild \
    -verbose \
    -exportArchive \
    -exportFormat app \
    -archivePath "${ARCHIVE_PATH}" \
    -exportPath "${APP_PATH}" \
    -exportSigningIdentity "Developer ID Application: VOKAL LLC (TZPBQT6RZA)" \
    || exit 1

# Zip the app.
echo "note: Zipping .app bundle..."
APP_ZIP_PATH="${WORKING_DIR}/${PROJECT}.app.zip"
ditto -ck --keepParent "${APP_PATH}" "${APP_ZIP_PATH}" || exit 1

# Zip the dSYM.
echo "note: Zipping .dSYM..."
DSYM_PATH="${ARCHIVE_PATH}/dSYMs/${PROJECT}.app.dSYM"
DSYM_ZIP_PATH="${WORKING_DIR}/${PROJECT}.dSYM.zip"
ditto -ck --keepParent "${DSYM_PATH}" "${DSYM_ZIP_PATH}" || exit 1

# Upload to HockeyApp.
echo "note: Uploading to HockeyApp..."
util/puck \
    -submit=auto \
    -app_id=e2a44471302146ef8a121891f117f358 \
    -api_token=FIXME \
    -dsym_path="${DSYM_ZIP_PATH}" \
    "${APP_ZIP_PATH}"

# Tag the version.
PLIST_PATH="${APP_PATH}/Contents/Info.plist"
VERSION_NUMBER="$(/usr/libexec/PlistBuddy -c "Print :TRUBaseVersionNumber" "${PLIST_PATH}")" || exit 1
BUILD_NUMBER="$(/usr/libexec/PlistBuddy -c "Print :CFBundleVersion" "${PLIST_PATH}")" || exit 1
TAG="builds/${VERSION_NUMBER}/${BUILD_NUMBER}"
echo "note: Tagging the release as '${TAG}' in git..." \
    && \
    (cd ${PROJECT_DIR} \
        && git tag "${TAG}" \
        && git remote | xargs -L1 -J % git push % "${TAG}"\
        )

# Remove the working directory and its contents.
echo "note: Cleaning up..."
rm -rf ${WORKING_DIR}
echo "note: Done."
