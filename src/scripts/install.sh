Install_Cosign() {
    bootstrap_version='v1.1.0'
    expected_bootstrap_version_digest='c0b66f6948361f7f2c8c569d82d9471f36dd8354cf43f6bba6e578b31944127b'
    curl -L https://storage.googleapis.com/cosign-releases/$bootstrap_version/cosign-linux-amd64 -o cosign
    shaBootstrap=$(shasum -a 256 cosign | cut -d' ' -f1);
    if [[ $shaBootstrap != "${expected_bootstrap_version_digest}" ]]; then exit 1; fi
    chmod +x cosign

    # If the bootstrap and specified `cosign` releases are the same, we're done.
    if [[ "${COSIGN_VERSION}" == "${bootstrap_version}" ]];
    then
        mkdir -p "$HOME"/.cosign && mv cosign "$HOME"/.cosign/
        echo "export PATH=${HOME}/.cosign:$PATH" >> "$BASH_ENV"
        source "$BASH_ENV"
        cosign version
        exit 0
    fi

    semver='^v([0-9]+\.){0,2}(\*|[0-9]+)$'
    if [[ ${COSIGN_VERSION} =~ $semver ]]; then
        echo "INFO: Custom Cosign Version ${COSIGN_VERSION}"
    else
        echo "ERROR: Unable to validate cosign version: '${COSIGN_VERSION}'"
        exit 1
    fi

    # Download custom cosign
    if [[ "${COSIGN_VERSION}" == 'v0.6.0' ]]; then
        curl -L https://storage.googleapis.com/cosign-releases/v0.6.0/cosign_linux_amd64 -o cosign_"${COSIGN_VERSION}"
    else
        curl -L https://storage.googleapis.com/cosign-releases/"${COSIGN_VERSION}"/cosign-linux-amd64 -o cosign_"${COSIGN_VERSION}"
    fi
    shaCustom=$(shasum -a 256 cosign_"${COSIGN_VERSION}" | cut -d' ' -f1);

    # same hash means it is the same release
    if [[ $shaCustom != "$shaBootstrap" ]];
    then
        if [[ "${COSIGN_VERSION}" == 'v0.6.0' ]]; then
            # v0.6.0's linux release has a dependency on `libpcsclite1`
            sudo apt-get update -q
            sudo apt-get install -yq libpcsclite1
            curl -L https://github.com/sigstore/cosign/releases/download/v0.6.0/cosign_linux_amd64_0.6.0_linux_amd64.sig -o cosign-linux-amd64.sig
        else
            curl -LO https://github.com/sigstore/cosign/releases/download/"${COSIGN_VERSION}"/cosign-linux-amd64.sig
        fi
        if [[ "${COSIGN_VERSION}" < 'v0.6.0' ]]; then
            curl -L https://raw.githubusercontent.com/sigstore/cosign/"${COSIGN_VERSION}"/.github/workflows/cosign.pub -o release-cosign.pub
        else
            curl -LO https://raw.githubusercontent.com/sigstore/cosign/"${COSIGN_VERSION}"/release/release-cosign.pub
        fi
        ./cosign verify-blob -key release-cosign.pub -signature cosign-linux-amd64.sig cosign_"${COSIGN_VERSION}"
        if [[ $? -ne 0 ]]; then exit 1; fi
        rm cosign
        mv cosign_"${COSIGN_VERSION}" cosign
        chmod +x cosign
        mkdir -p "$HOME"/.cosign && mv cosign "$HOME"/.cosign/
        echo "export PATH=${HOME}/.cosign:$PATH" >> "$BASH_ENV"
        source "$BASH_ENV"
        cosign version
    fi
}

# Will not run if sourced for bats-core tests.
# View src/tests for more information.
ORB_TEST_ENV="bats-core"
if [ "${0#*$ORB_TEST_ENV}" == "$0" ]; then
    Install_Cosign
fi
