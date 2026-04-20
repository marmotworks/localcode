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

## TODO

- Investigate [QBit](https://github.com/qbit)
- Investigate the [iTerm2 AI plugin](https://iterm2.com/)
