#!/usr/bin/env bash

Install_Cosign() {
    shopt -s expand_aliases
    if [[ -z "${NO_COLOR}" ]]; then
        alias log_info="echo -e \"\033[1;32mINFO\033[0m:\""
        alias log_error="echo -e \"\033[1;31mERROR\033[0m:\""
    else
        alias log_info="echo \"INFO:\""
        alias log_error="echo \"ERROR:\""
    fi
    set -e

    bootstrap_version='v2.4.1'
    expected_bootstrap_version_digest='8b24b946dd5809c6bd93de08033bcf6bc0ed7d336b7785787c080f574b89249b'
    curl -L https://github.com/sigstore/cosign/releases/download/$bootstrap_version/cosign-linux-amd64 -o cosign
    shaBootstrap=$(shasum -a 256 cosign | cut -d' ' -f1);
    if [[ ${shaBootstrap} != "${expected_bootstrap_version_digest}" ]]; then exit 1; fi
    chmod +x cosign

    # If the bootstrap and specified `cosign` releases are the same, we're done.
    if [[ "${COSIGN_VERSION:?}" == "${bootstrap_version}" ]];
    then
        mkdir -p "${HOME}"/.cosign && mv cosign "${HOME}"/.cosign/
        echo "export PATH=${HOME}/.cosign:${PATH}" >> "${BASH_ENV}"
        # shellcheck disable=SC1090
        source "${BASH_ENV}"
        cosign version
        exit 0
    fi

    semver='^v([0-9]+\.){0,2}(\*|[0-9]+)$'
    if [[ ${COSIGN_VERSION:?} =~ ${semver} ]]; then
        echo "INFO: Custom Cosign Version ${COSIGN_VERSION:?}"
    else
        echo "ERROR: Unable to validate cosign version: '${COSIGN_VERSION:?}'"
        exit 1
    fi

    # Download custom cosign
    curl -L https://github.com/sigstore/cosign/releases/download/"${COSIGN_VERSION}"/cosign-linux-amd64 -o cosign_"${COSIGN_VERSION:?}"
    shaCustom=$(shasum -a 256 cosign_"${COSIGN_VERSION:?}" | cut -d' ' -f1);

    # same hash means it is the same release
    if [[ ${shaCustom} != "${shaBootstrap}" ]];
    then
        curl -LO https://github.com/sigstore/cosign/releases/download/"${COSIGN_VERSION:?}"/cosign-linux-amd64.sig
        curl -LO https://raw.githubusercontent.com/sigstore/cosign/"${COSIGN_VERSION:?}"/release/release-cosign.pub

        if  ./cosign verify-blob -key release-cosign.pub -signature cosign-linux-amd64.sig cosign_"${COSIGN_VERSION:?}"; then exit 1; fi
        rm cosign
        mv cosign_"${COSIGN_VERSION:?}" cosign
        chmod +x cosign
        mkdir -p "${HOME}"/.cosign && mv cosign "${HOME}"/.cosign/
        echo "export PATH=${HOME}/.cosign:${PATH}" >> "${BASH_ENV}"
        # shellcheck disable=SC1090
        source "${BASH_ENV}"
        cosign version
    fi
}

# Will not run if sourced for bats-core tests.
# View src/tests for more information.
ORB_TEST_ENV="bats-core"
if [[ "${0#*"$ORB_TEST_ENV"}" == "$0" ]]; then
    Install_Cosign
fi
