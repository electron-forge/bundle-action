#!/usr/bin/env sh
#
# Required environment variables:
#
# * `MACOS_CERT_P12`: base64-encoded `.p12` certificate
# * `MACOS_CERT_PASSWORD`: password to unlock the certificate so it can be imported
#

if test "$(uname -s)" = "Darwin"; then
  KEY_CHAIN=build.keychain
  KEY_CHAIN_USER=actions
  MACOS_CERT_P12_FILE=certificate.p12

  # Recreate the certificate from the secure environment variable
  echo $MACOS_CERT_P12 | base64 --decode > $MACOS_CERT_P12_FILE

  # Create a keychain
  security create-keychain -p $KEY_CHAIN_USER $KEY_CHAIN

  # Make the keychain the default so identities are found
  security default-keychain -s $KEY_CHAIN

  # Unlock the keychain
  security unlock-keychain -p $KEY_CHAIN_USER $KEY_CHAIN

  security import $MACOS_CERT_P12_FILE -k $KEY_CHAIN -P $MACOS_CERT_PASSWORD -T /usr/bin/codesign;

  security set-key-partition-list -S apple-tool:,apple: -s -k $KEY_CHAIN_USER $KEY_CHAIN

  # Remove cert created from this script
  rm "$MACOS_CERT_P12_FILE"
fi
