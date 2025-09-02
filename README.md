# Tercen Developer's Guide

[![Quarto Publish](https://github.com/tercen/developers_guide/actions/workflows/quarto-publish.yml/badge.svg)](https://github.com/tercen/developers_guide/actions/workflows/quarto-publish.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A comprehensive guide for developing operators, workflow templates, and applications on the Tercen platform.

📖 **[Read the guide online](https://tercen.github.io/developers_guide/)**

## What is Tercen?

Tercen is a collaborative data analysis platform that bridges the gap between data scientists and domain experts. It enables seamless collaboration by allowing:

- **Domain experts** (e.g., biologists, researchers) to explore and analyze their data using intuitive visual interfaces
- **Developers** (e.g., bioinformaticians, data scientists) to create and share reusable analytical tools and web applications

## What You'll Learn

This guide covers everything you need to know about developing for Tercen:

- 🚀 **Getting Started**: Core concepts, environment setup, and platform architecture
- ⚙️ **Operator Development**: Step-by-step workflows with R and Python examples
- 📋 **Workflow Templates**: Creating reusable analysis pipelines
- 🔧 **Advanced Topics**: GPU development, custom visualizations, and CLI tools
- 🛠️ **Best Practices**: Testing, CI/CD, deployment strategies
- 🐛 **Troubleshooting**: Common issues and debugging techniques

## Quick Start

1. **Read the [Environment Setup](https://tercen.github.io/developers_guide/environment-setup.html)** chapter to configure your development environment
2. **Explore [Core Concepts](https://tercen.github.io/developers_guide/core-concepts.html)** to understand Tercen's architecture
3. **Follow the [Operator Development](https://tercen.github.io/developers_guide/operator-development.html)** guide to create your first operator
4. **Check out the [Templates Repository](https://github.com/tercen/r_operator_template)** for starting templates

## Repository Structure

```
├── book/                    # Quarto book source
│   ├── _quarto.yml         # Book configuration
│   ├── index.qmd           # Book homepage
│   ├── 01-getting-started/ # Getting started chapters
│   ├── 02-operator-development/
│   ├── 03-workflow-templates/
│   ├── 04-advanced-topics/
│   ├── 05-troubleshooting/
│   ├── 99-appendices/
│   └── images/             # Book images and assets
├── .github/workflows/      # GitHub Actions for publishing
└── README.md              # This file
```

## Contributing

We welcome contributions to improve this guide! Here's how you can help:

### Reporting Issues
- Found an error or outdated information? [Open an issue](https://github.com/tercen/developers_guide/issues)
- Have a suggestion for improvement? We'd love to hear it!

### Contributing Content
1. Fork this repository
2. Make your changes in the `book/` directory
3. Test locally: `cd book && quarto preview`
4. Submit a pull request with a clear description of your changes

### Writing Guidelines
- Use clear, concise language
- Include practical examples and code snippets
- Test all code examples before submitting
- Follow the existing chapter structure and formatting

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**Built with ❤️ by the Tercen Team**

