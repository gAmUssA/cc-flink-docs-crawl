# 🚀 Confluent Cloud Flink Documentation Crawler

A Python-based web crawler that downloads Confluent Cloud Flink SQL documentation and generates an `llms.txt` file according to the [llmstxt.org](https://llmstxt.org) standard. This tool helps train Claude and other language models to understand Flink SQL dialect for Confluent Cloud.

## ✨ Features

- 🕷️ **Web Crawling**: Downloads documentation from configurable URL list
- 📝 **Smart Content Extraction**: Parses HTML and extracts relevant text and code examples
- 🎯 **llms.txt Generation**: Creates standardized format for LLM training
- 🧹 **Clean Output**: Removes navigation, headers, and non-essential content
- 🔧 **Configurable**: Easy to add new documentation URLs
- 🎨 **Colorful Interface**: Beautiful terminal output with emojis and colors
- 🚀 **Automated CI/CD**: GitHub Actions workflow for automatic crawling
- 📊 **Smart Dependencies**: Makefile with dependency tracking and sentinel files
- 📁 **Organized Output**: Structured output directory with summaries and artifacts

## 🛠️ Installation

### Prerequisites
- Python 3.7+
- GNU Make 4.0+ (for Makefile features)
  - On macOS: `brew install make` (available as `gmake`)
  - On Ubuntu/Debian: `sudo apt-get install make`

### Setup

```bash
# Clone the repository
git clone <repository-url>
cd cc-flink-docs-crawl

# Setup virtual environment and install dependencies
# Note: Use 'gmake' on macOS if you have GNU Make installed via Homebrew
gmake setup  # or 'make setup' on Linux

# Or manually:
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

## 🚀 Usage

### Quick Start

```bash
# Run the complete CI pipeline (recommended)
gmake ci-ready  # Setup, validate, crawl, and generate summary

# Or run individual steps
gmake setup     # Create virtual environment and install dependencies
gmake crawl     # Run the documentation crawler
gmake status    # Check build status
gmake summary   # Generate crawl summary

# Traditional workflow
gmake all       # Setup and crawl (without validation/summary)
```

### Manual Usage

```bash
# Activate virtual environment
source venv/bin/activate

# Run the crawler
python3 crawler.py
```

### Configuration

Add URLs to crawl in `links.txt`:
```
https://docs.confluent.io/cloud/current/flink/overview.html
https://docs.confluent.io/cloud/current/flink/get-started/overview.html
# Add more URLs here...
```

## 📁 Project Structure

```
cc-flink-docs-crawl/
├── crawler.py              # Main crawler script
├── links.txt               # URLs to crawl
├── requirements.txt        # Python dependencies
├── Makefile               # Build automation (Davis-Hansson best practices)
├── out/                   # Generated output directory
│   ├── llms.txt           # Generated documentation
│   └── crawl-summary.md   # Crawl statistics and summary
├── tmp/                   # Temporary build files
│   ├── .deps-installed.sentinel
│   └── .tests-passed.sentinel
├── venv/                  # Python virtual environment
├── .github/workflows/     # GitHub Actions automation
│   ├── auto-crawl.yml     # Automated crawling on links.txt changes
│   └── smoketest.yml      # Basic validation tests
├── .gitignore             # Git ignore rules
└── README.md              # This file
```

## 🎯 Available Make Commands

### 🚀 Primary Commands
- `gmake help` - 📖 Show available commands
- `gmake ci-ready` - 🚀 **Complete CI pipeline** (setup→validate→crawl→summary)
- `gmake status` - 📊 Show build status
- `gmake clean` - 🧹 Remove generated files and virtual environment

### 🔧 Individual Steps
- `gmake setup` - 🔧 Create virtual environment and install dependencies
- `gmake validate` - 🔬 Validate crawler script syntax
- `gmake crawl` - 🕷️ Run the documentation crawler
- `gmake summary` - 📊 Generate crawl summary with statistics
- `gmake install` - 📦 Install dependencies (requires setup first)

### 📝 Development Commands
- `gmake test` - 🧪 Run tests (placeholder)
- `gmake lint` - 🔍 Run linting (placeholder)
- `gmake format` - 💅 Format code (placeholder)
- `gmake all` - 🎯 Setup and crawl documentation (legacy)

> **Note**: Use `gmake` on macOS with Homebrew-installed GNU Make, or `make` on Linux systems.

## 🚀 GitHub Actions Automation

The project includes automated crawling via GitHub Actions that triggers when `links.txt` is updated:

### 🎯 Automatic Triggers
- **Push to main/develop**: When `links.txt`, `crawler.py`, or `requirements.txt` are modified
- **Pull requests**: Validates changes before merging
- **Manual trigger**: Via GitHub Actions UI with custom reason

### 📦 Automated Artifacts
- **Downloadable artifacts**: `out/llms.txt`, `out/crawl-summary.md`, `links.txt` (30-day retention)
- **GitHub releases**: On main branch pushes, creates releases with crawl results
- **Job summaries**: Beautiful GitHub Actions summary with statistics

### 🔄 Workflow Consistency
The GitHub Actions workflow uses the same Makefile targets as local development:
```yaml
# GitHub Actions runs the same command as local development
- name: 🚀 Run complete CI pipeline via Makefile
  run: make ci-ready
```

This ensures identical behavior between local development (`gmake ci-ready`) and CI/CD (`make ci-ready`).

### 🎨 Visual Feedback
The workflow provides:
- ✅ Step-by-step progress with emojis
- 📊 Detailed statistics (lines processed, file size, crawl date)
- 🎯 Clear success/failure indicators
- 📋 Downloadable crawl summaries

## 📊 Output

The crawler generates `llms.txt` with:
- **Header**: Project title and description
- **Overview**: What the documentation covers
- **Core Documentation**: Links with brief descriptions
- **Full Content**: Complete extracted text with code examples
- **Code Examples**: SQL snippets formatted for easy parsing

## 🔧 Configuration

### Adding New URLs
Edit `links.txt` to include additional documentation URLs:
```
https://docs.confluent.io/cloud/current/flink/new-page.html
```

### Customizing Output
Modify `crawler.py` to adjust:
- Content extraction selectors
- Text cleaning rules
- Output formatting
- Request delays and headers

## 🧪 Development

### Running Tests
```bash
make test  # When tests are added
```

### Code Quality
```bash
make lint    # When linting is configured
make format  # When formatting is configured
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Built for training Claude on Confluent Cloud Flink SQL
- Uses the [llmstxt.org](https://llmstxt.org) standard
- Inspired by the need for better LLM understanding of Flink SQL dialect

## 📞 Support

If you encounter issues or have questions:
1. Check the existing issues
2. Create a new issue with detailed description
3. Include error logs and environment details

---

Happy crawling! 🕷️✨