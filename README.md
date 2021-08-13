# Cosign Orb

[![CircleCI Build Status](https://circleci.com/gh/cpanato/cosign-orb.svg?style=shield "CircleCI Build Status")](https://circleci.com/gh/cpanato/cosign-orb) [![CircleCI Orb Version](https://badges.circleci.com/orbs/cpanato/cosign-orb.svg)](https://circleci.com/orbs/registry/orb/cpanato/cosign-orb)


### How to Contribute

We welcome [issues](https://github.com/cpanato/cosign-orb/issues) to and [pull requests](https://github.com/cpanato/cosign-orb/pulls) against this repository!

### How to Publish

* Create and push a branch with your new features.
* When ready to publish a new production version, create a Pull Request from _feature branch_ to `master`.
* The title of the pull request must contain a special semver tag: `[semver:<segement>]` where `<segment>` is replaced by one of the following values.

| Increment | Description|
| ----------| -----------|
| major     | Issue a 1.0.0 incremented release|
| minor     | Issue a x.1.0 incremented release|
| patch     | Issue a x.x.1 incremented release|
| skip      | Do not issue a release|

Example: `[semver:major]`

* Squash and merge. Ensure the semver tag is preserved and entered as a part of the commit message.
* On merge, after manual approval, the orb will automatically be published to the Orb Registry.


For further questions/comments about this or other orbs, visit the Orb Category of [CircleCI Discuss](https://discuss.circleci.com/c/orbs).
