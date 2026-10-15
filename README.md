# homebrew-tap

Homebrew casks for tools by [ingvarch](https://github.com/ingvarch).

## Install

```sh
brew install ingvarch/tap/urga
```

Any cask from the table below installs the same way.

## Casks

<!-- casks:start -->
| Cask | Version | What it is |
| --- | --- | --- |
| [azt](https://github.com/ingvarch/azt) | 0.1.0 | Terminal UI for Azure |
| [tent](https://github.com/ingvarch/tent) | 0.2.0 | Provision and operate HashiCorp Nomad clusters on cloud providers |
| [urga](https://github.com/ingvarch/urga) | 0.12.0 | Terminal UI for HashiCorp Nomad |
<!-- casks:end -->

## How this repo is updated

Each project's release writes its cask to `Casks/` with GoReleaser. Do not
edit the casks here: a change by hand is gone after the next release. To change
a cask's description, change it in that project's GoReleaser config.

After every change in `Casks/`, the `README` workflow rebuilds the table above
with `script/update_readme.rb` and commits it, so each release is followed by a
README commit with the new version. To rebuild it locally:

```sh
ruby script/update_readme.rb
ruby test/update_readme_test.rb
```
