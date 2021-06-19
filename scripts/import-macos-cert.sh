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
  
  if [[ -z $MACOS_CERT_P12 ]]; then
    echo '********' >&2
    echo 'WARNING: No macOS certificate found in repository secrets.' >&2
    echo 'WARNING: THIS WILL CAUSE MACOS SIGNING TO FAIL.' >&2
    echo 'Exiting.' >&2
    echo '********' >&2
    exit 0
  fi

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
  
  echo '********'
  echo 'Certificate imported and ready for signing!'
  echo '********'
fi
