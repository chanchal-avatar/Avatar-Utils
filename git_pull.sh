set -e

echo "Avatar-FaceKey-3rdParty:"
(cd Avatar-FaceKey-3rdParty && git pull)

echo "Avatar-FaceKey-Android:"
(cd Avatar-FaceKey-Android && git pull)

echo "Avatar-FaceKey-CoreManager:"
(cd Avatar-FaceKey-CoreManager && git pull)

echo "Avatar-FaceKey-Releases:"
(cd Avatar-FaceKey-Releases && git pull)

echo "Avatar-FaceKey-Server:"
(cd Avatar-FaceKey-Server && git pull)

echo "Avatar-Utils:"
(cd Avatar-Utils && git pull)

echo "Avatar-FaceKey-Client:"
(cd avatar_client && git pull)
