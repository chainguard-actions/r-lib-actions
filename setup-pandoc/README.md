# setup-pandoc

[![RStudio community](https://img.shields.io/badge/community-github--actions-blue?style=social&logo=rstudio&logoColor=75AADB)](https://community.rstudio.com/new-topic?category=Package%20development&tags=github-actions)

This action sets up pandoc and pandoc-citeproc by:

- downloading and caching a relased version of pandoc by version and adding it to the PATH

# Usage

See [action.yml](action.yml)

Basic:
```yaml
steps:
- uses: actions/checkout@master
- uses: r-lib/actions/setup-pandoc@v1
  with:
    pandoc-version: '2.7.3' # The pandoc version to download (if necessary) and use.
- run: echo "# Test" | pandoc -t html
```

# License

The scripts and documentation in this project are released under the [MIT License](LICENSE)

# Contributions

Contributions are welcome!  See [Contributor's Guide](docs/contributors.md)

## Privacy

This Action contacts Chainguard's licensing server to verify authorization. Connection metadata (IP address, GitHub repository identifier, timestamp, and any metadata encoded in the auth token) is transmitted to Chainguard, Inc. even if authorization is denied in accordance with our [Privacy Notice](https://www.chainguard.dev/legal/privacy-notice)
