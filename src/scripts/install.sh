Install_Cosign() {
    curl -LO https://storage.googleapis.com/cosign-releases/v0.1.0/cosign
    shaBootstrap=$(shasum -a 256 cosign | cut -d' ' -f1);
    if [[ $shaBootstrap != "fd2e09bb1ca5f5342227b85a4d3b1c498df1ab2439cafb3636381bb82ad29cea" ]]; then exit 1; fi

    semver='^v([0-9]+\.){0,2}(\*|[0-9]+)$'
    if [[ "${COSIGN_VERSION}" =~ $semver ]]; then
        echo "INFO: Custom Cosign Version ${COSIGN_VERSION}"
    else
        echo "ERROR: Unable to validate cosign version: '${COSIGN_VERSION}'"
        exit 1
    fi
    # Download custom cosign
    curl -L https://storage.googleapis.com/cosign-releases/"${COSIGN_VERSION}"/cosign -o cosign_"${COSIGN_VERSION}"
    shaCustom=$(shasum -a 256 cosign_"${COSIGN_VERSION}" | cut -d' ' -f1);
    # check if is the same hash means it is the same release
    if [[ "$shaCustom" != "$shaBootstrap" ]];
    then
        chmod +x cosign
        curl -LO https://github.com/sigstore/cosign/releases/download/"${COSIGN_VERSION}"/cosign.sig
        curl -LO https://raw.githubusercontent.com/sigstore/cosign/"${COSIGN_VERSION}"/.github/workflows/cosign.pub
        if ./cosign verify-blob --key cosign.pub --signature cosign.sig cosign_"${COSIGN_VERSION}"; then exit 1; fi
        rm cosign
        mv cosign_"${COSIGN_VERSION}" cosign
    fi
    # Add to PATH
    chmod +x cosign && mkdir -p "$HOME"/.cosign && mv cosign "$HOME"/.cosign/
    echo "export PATH=${HOME}/.cosign:$PATH" >> "$BASH_ENV"
    source "$BASH_ENV"
}

# Will not run if sourced for bats-core tests.
# View src/tests for more information.
ORB_TEST_ENV="bats-core"
if [ "${0#*$ORB_TEST_ENV}" == "$0" ]; then
    Install_Cosign
fi
