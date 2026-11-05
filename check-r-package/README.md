# check-r-package

[![RStudio community](https://img.shields.io/badge/community-github--actions-blue?style=social&logo=rstudio&logoColor=75AADB)](https://community.rstudio.com/new-topic?category=Package%20development&tags=github-actions)

This action checks an R package using the [rcmdcheck](https://r-lib.github.io/rcmdcheck/) package.

# Usage

```yaml
steps:
- uses: actions/checkout@master
- uses: r-lib/actions/setup-r@v1
- uses: r-lib/actions/setup-r-dependencies@v1
  with:
    extra-packages: rcmdcheck
- uses: r-lib/actions/check-r-package@v1
```

# License

The scripts and documentation in this project are released under the [MIT License](LICENSE)

# Contributions

Contributions are welcome!

## Privacy

This Action contacts Chainguard's licensing server to verify authorization. Connection metadata (IP address, GitHub repository identifier, timestamp, and any metadata encoded in the auth token) is transmitted to Chainguard, Inc. even if authorization is denied in accordance with our [Privacy Notice](https://www.chainguard.dev/legal/privacy-notice)
