
# Cosign Orb

[![CircleCI Build Status](https://circleci.com/gh/cpanato/cosign-orb.svg?style=shield "CircleCI Build Status")](https://circleci.com/gh/cpanato/cosign-orb) [![CircleCI Orb Version](https://badges.circleci.com/orbs/cpanato/cosign-orb.svg)](https://circleci.com/orbs/registry/orb/cpanato/cosign-orb)


CircleCI Orb to install cosing in your workflows

For example:

```yaml
usage:
  version: 2.1
  orbs:
    cosign: cpanato/cosign-orb@v2.0.0
  workflows:
    use-cosign-orb:
      jobs:
        - cosign/install
        - run:
            name: verify-sign
            command: |
              export COSIGN_VERSION=v2.4.1
              curl -L https://github.com/sigstore/cosign/releases/download/"${COSIGN_VERSION}"/cosign-linux-amd64 -o cosign_"${COSIGN_VERSION}"
              curl -LO https://github.com/sigstore/cosign/releases/download/"${COSIGN_VERSION}"/cosign-linux-amd64.sig
              curl -LO https://github.com/sigstore/cosign/releases/download/"${COSIGN_VERSION}"/release-cosign.pub
              cosign verify-blob --key release-cosign.pub --signature cosign-linux-amd64.sig cosign_"${COSIGN_VERSION}"
```

### How to Contribute

We welcome [issues](https://github.com/cpanato/cosign-orb/issues) to and [pull requests](https://github.com/cpanato/cosign-orb/pulls) against this repository!
