# Cosing Orb

[![CircleCI Build Status](https://circleci.com/gh/cpanato/cosign-orb.svg?style=shield "CircleCI Build Status")](https://circleci.com/gh/cpanato/cosign-orb) [![CircleCI Orb Version](https://badges.circleci.com/orbs/cpanato/cosign-orb.svg)](https://circleci.com/developer/orbs/orb/cpanato/cosign-orb) [![GitHub License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/cpanato/cosign-orb/master/LICENSE) [![CircleCI Community](https://img.shields.io/badge/community-CircleCI%20Discuss-343434.svg)](https://discuss.circleci.com/c/ecosystem/orbs)


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

## Resources

[CircleCI Orb Registry Page](https://circleci.com/developer/orbs/orb/cpanato/cosign-orb) - The official registry page of this orb for all versions, executors, commands, and jobs described.

[CircleCI Orb Docs](https://circleci.com/docs/orb-intro/#section=configuration) - Docs for using, creating, and publishing CircleCI Orbs.

### How to Contribute

We welcome [issues](https://github.com/cpanato/cosign-orb/issues) to and [pull requests](https://github.com/cpanato/cosign-orb/pulls) against this repository!

### How to Publish An Update
1. Merge pull requests with desired changes to the main branch.
    - For the best experience, squash-and-merge and use [Conventional Commit Messages](https://conventionalcommits.org/).
2. Find the current version of the orb.
    - You can run `circleci orb info <namespace>/<orb-name> | grep "Latest"` to see the current version.
3. Create a [new Release](https://github.com/cpanato/cosign-orb/releases/new) on GitHub.
    - Click "Choose a tag" and _create_ a new [semantically versioned](http://semver.org/) tag. (ex: v1.0.0)
      - We will have an opportunity to change this before we publish if needed after the next step.
4.  Click _"+ Auto-generate release notes"_.
    - This will create a summary of all of the merged pull requests since the previous release.
    - If you have used _[Conventional Commit Messages](https://conventionalcommits.org/)_ it will be easy to determine what types of changes were made, allowing you to ensure the correct version tag is being published.
5. Now ensure the version tag selected is semantically accurate based on the changes included.
6. Click _"Publish Release"_.
    - This will push a new tag and trigger your publishing pipeline on CircleCI.

### Development Orbs

Prerequisites:

- An initial sevmer deployment must be performed in order for Development orbs to be published and seen in the [Orb Registry](https://circleci.com/developer/orbs).

A [Development orb](https://circleci.com/docs/orb-concepts/#development-orbs) can be created to help with rapid development or testing. To create a Development orb, change the `orb-tools/publish` job in `test-deploy.yml` to be the following:

```yaml
- orb-tools/publish:
    orb_name: cpanato/cosign-orb
    vcs_type: << pipeline.project.type >>
    pub_type: dev
    # Ensure this job requires all test jobs and the pack job.
    requires:
      - orb-tools/pack
      - command-test
    context: <publishing-context>
    filters: *filters
```

The job output will contain a link to the Development orb Registry page. The parameters `enable_pr_comment` and `github_token` can be set to add the relevant publishing information onto a pull request. Please refer to the [orb-tools/publish](https://circleci.com/developer/orbs/orb/circleci/orb-tools#jobs-publish) documentation for more information and options.
