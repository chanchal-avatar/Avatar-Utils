set -e

REPO_LIST="Avatar-FaceKey-3rdParty \
           Avatar-FaceKey-Android \
           Avatar-FaceKey-CoreManager \
           Avatar-FaceKey-Releases \
           Avatar-FaceKey-Server \
           Avatar-Messaging \
           Avatar-Messaging-SDK \
           Avatar-MobileSDK-iOS \
           Avatar-Selfkey-React-Native \
           Avatar-Utils \
           Avatar-FaceKey-Client"

# Pull all repositories
for REPO in $REPO_LIST; do
    echo "------- ${REPO}:"
    (cd $REPO && git pull)
done

echo "Done."
