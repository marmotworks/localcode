# LocalCode

A local development workspace powered by open-source LLMs, using [opencode](https://opencode.ai) as the CLI interface and [llama.cpp](https://github.com/ggerganov/llama.cpp) for local inference.

## Overview

This repo configures a fully local AI-assisted development environment. Models are downloaded and served locally via `llama-server`, then consumed by `opencode` for coding tasks, web search, and code search.

## Files

| File | Description |
|------|-------------|
| `opencode.json` | Opencode configuration — selects the default model, enables tools (web search, code search), and defines available models with their context/output limits. |
| `config.ini` | llama.cpp preset configuration. |
| `LICENSE` | License for this repository. |

## Models

Three models are supported, all sourced from unsloth on Hugging Face:

- **Qwen3.6-35B-A3B** — default model
- **Gemma 4 31B IT**
- **Gemma 4 26B A4B IT**

## Commands

### Start the local inference server

```bash
llama-server \
  --models-preset ~/.config/llama.cpp/config.ini \
  --host 127.0.0.1 \
  --port 8001
```

### Launch opencode with web search enabled

```bash
OPENCODE_ENABLE_EXA=1 opencode web
```

## Downloading Models

Download a model (and its multimodal projector) from Hugging Face using the `hf` CLI:

```bash
hf download unsloth/Qwen3.6-35B-A3B-GGUF \
    --local-dir unsloth/Qwen3.6-35B-A3B-GGUF \
    --include "*mmproj-F16*" \
    --include "*UD-Q4_K_XL*"
```

```bash
hf download unsloth/gemma-4-31B-it-GGUF \
    --local-dir unsloth/gemma-4-31B-it-GGUF \
    --include "*mmproj-BF16*" \
    --include "*UD-Q8_K_XL*"
```

```bash
hf download unsloth/gemma-4-26B-A4B-it-GGUF \
    --local-dir unsloth/gemma-4-26B-A4B-it-GGUF \
    --include "*mmproj-BF16*" \
    --include "*UD-Q8_K_XL*"
```

## Playwright CLI

[Playwright CLI](https://github.com/microsoft/playwright-cli) provides a token-efficient CLI interface for browser automation, designed to work with coding agents via skills.

### Prerequisites

- Node.js 18 or newer

### Installation

```bash
npm install -g @playwright/cli@latest
playwright-cli --help
```

### Installing Skills

```bash
playwright-cli install --skills
```

### Usage

Once installed, your coding agent (opencode, Claude Code, etc.) will automatically discover and use the Playwright skills. The CLI is headless by default; pass `--headed` to see the browser:

```bash
playwright-cli open https://example.com --headed
playwright-cli snapshot
playwright-cli click e15
playwright-cli screenshot
```

### Key Commands

| Command | Description |
|---------|-------------|
| `playwright-cli open [url]` | Open browser, optionally navigate to URL |
| `playwright-cli goto <url>` | Navigate to a URL |
| `playwright-cli snapshot` | Capture page snapshot to obtain element refs |
| `playwright-cli click <ref>` | Click an element by ref or selector |
| `playwright-cli type <text>` | Type text into an editable element |
| `playwright-cli fill <ref> <text>` | Fill text into an editable element |
| `playwright-cli screenshot [ref]` | Take a screenshot |
| `playwright-cli close` | Close the page |
| `playwright-cli list` | List all sessions |
| `playwright-cli show` | Open visual dashboard for running sessions |

### Sessions

Playwright CLI keeps browser profiles in memory by default. Use `--persistent` for disk persistence and `-s=<name>` for named sessions:

```bash
playwright-cli -s=example open https://example.com --persistent
playwright-cli list
playwright-cli close-all
```

You can also set the `PLAYWRIGHT_CLI_SESSION` environment variable:

```bash
PLAYWRIGHT_CLI_SESSION=example opencode
```

## TODO

- Investigate [QBit](https://github.com/qbit)
- Investigate the [iTerm2 AI plugin](https://iterm2.com/)
