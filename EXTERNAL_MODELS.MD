# Connecting External AI Models to the Platform

## Overview

This guide will walk you through the process of connecting external Large Language Models (LLMs) and embedding models to the platform. This allows you to use your own AI models or third-party services instead of the default models.

**Who should follow this guide:** Platform administrators who want to configure custom AI models.

**What you'll need:**
- Admin access to the platform
- API credentials from your chosen AI service provider (e.g., OpenAI API key)
- The API endpoint URL for your model

---

## Part 1: Connecting a Large Language Model (LLM)

Large Language Models are the AI "brains" that power conversations with your agents. Follow these steps to connect your own LLM.

### Step 1: Log in as Administrator

1. Open the platform in your web browser
2. Enter your login credentials:
   - **Username**: `admin` or your admin username
   - **Password**: The admin password you set during deployment
3. Click the **Log in** button

### Step 2: Navigate to LLM Settings

1. Once logged in, look at the left sidebar
2. Find the sub-section **Settings**
3. In the Settings sub-section, click on **General** (represented by a document icon 📄)
4. You'll see several tabs at the top - click on the **LLM** tab
5. Click the **Create LLM** button

You should now see a form where you can configure a new language model.

### Step 3: Choose Your Vendor

In the **Vendor** dropdown menu, select the service provider you want to use. Common options include:

- **ChatOpenAI**: For OpenAI models or any service with an OpenAI-compatible API
- **Anthropic**: For Claude models
- **Google**: For Gemini models
- **Other vendors**: Depending on your platform configuration

**Most common choice**: Select **ChatOpenAI** if you're using:
- Official OpenAI models (GPT-4, GPT-3.5, etc.)
- Local models served via tools like Ollama, LM Studio, or vLLM
- Third-party services with [OpenAI-compatible APIs](https://platform.openai.com/docs/api-reference/introduction)

### Step 4: Enter Model Specifications

In the **Specifications** field, you need to provide configuration details in YAML format. YAML is a simple text format that uses indentation and colons to organize information.

**Important**: Pay attention to spacing and indentation - YAML is sensitive to this!

#### Example for OpenAI or OpenAI-Compatible APIs:

```yaml
api_key: test
base_url: http://localhost:11434/v1
model: hf.co/BSC-LT/salamandra-7b-instruct-tools:Q8_0
```

**Explanation of each field:**

- **`api_key`**: Your API authentication key
  - For OpenAI: Get this from [https://platform.openai.com/api-keys](https://platform.openai.com/api-keys)
  - For local models: Often just `test` or any placeholder text
  
- **`base_url`**: The API endpoint URL
  - For OpenAI: `https://api.openai.com/v1`
  - For local models (Ollama): `http://localhost:11434/v1`
  - For other services: Check their documentation
  
- **`model`**: The specific model identifier
  - For OpenAI: `gpt-4`, `gpt-4-turbo`, `gpt-3.5-turbo`, etc.
  - For local models: The model name as it appears in your local service
  - Example: `hf.co/BSC-LT/salamandra-7b-instruct-tools:Q8_0`

#### More Examples:

**Using Official OpenAI:**
```yaml
api_key: sk-proj-abc123xyz456...
base_url: https://api.openai.com/v1
model: gpt-4-turbo
```

**Using a Local Model with Ollama:**
```yaml
api_key: test
base_url: http://localhost:11434/v1
model: llama3
```

#### Available Specifications by Vendor

Below the specifications field, you'll see a table showing all available parameters for your selected vendor. Common parameters include:

- **`max_retries`**: Maximum number of times to retry if the API request fails (Optional)
- **`max_tokens`**: Maximum length of the response in tokens (Optional)
- **`model`**: The model identifier (Required - type: string)
- **`n`**: Number of completions to generate for each prompt (Optional - type: integer)
- **`temperature`**: Controls randomness (0 = focused, 1 = creative) (Optional)
- **`timeout`**: Maximum time to wait for a response (Optional)

**Tip**: You only need to include the parameters you want to customize. The required ones are typically just `api_key`, `base_url`, and `model`.

### Step 5: Name Your Model

In the **Name** field at the top of the form, enter a unique name for this model configuration.

**Guidelines:**
- Use a descriptive name that helps you identify the model later
- Examples: `gpt-4-production`, `local-llama3`, `claude-opus`
- The name must be unique (no two models can have the same name)

### Step 6: Set as Default (Optional but Recommended)

1. Look for the **Default** checkbox
2. Check this box if you want this model to be used automatically when creating new agents

**What does "Default" mean?**
- When you create a new agent, this model will be pre-selected
- You can still choose different models for individual agents later
- Only one model can be set as default at a time

### Step 7: Submit Your Configuration

1. Double-check all your entries:
   - Name is filled in and unique
   - Vendor is selected correctly
   - Specifications are in valid YAML format (correct indentation and colons)
   - Default is checked if desired

2. Click the **Submit** button at the bottom of the form

3. You should see a success message confirming the model has been added

**What happens next?**
- Your new model is now available in the platform
- When changing agent configuration, you can select this model from the dropdown
- If you set it as default, it will be automatically selected for new agents

---

## Part 2: Connecting an Embedding Model

Embedding models convert text into numerical representations, which is essential for the RAG (Retrieval-Augmented Generation) functionality. This allows agents to search through documents and find relevant information.

**Follow similar steps to add an embedding model:**

### Step 1: Navigate to Embeddings Settings

1. From the **Settings** → **General** page
2. Click on the **Embeddings** tab (instead of LLM)
3. Click the **Create Embedding** button

### Step 2: Configure the Embedding Model

Follow the same process as with LLMs:

1. **Name**: Give your embedding model a unique name (e.g., `openai-embeddings`, `local-embeddings`)

2. **Vendor**: Choose your embedding provider
   - Common options: OpenAI, HuggingFace, Cohere, or custom providers

3. **Specifications**: Enter the configuration in YAML format

#### Example for OpenAI Embeddings:

```yaml
api_key: sk-proj-abc123xyz456...
base_url: https://api.openai.com/v1
model: text-embedding-3-small
```

#### Example for Local Embeddings:

```yaml
api_key: test
base_url: http://localhost:11434/v1
model: nomic-embed-text
```

4. **Default**: Check this box to make it the default embedding model

5. **Submit**: Click the Submit button

---

## Troubleshooting

### "Invalid YAML format" Error

**Problem**: Your specifications aren't formatted correctly

**Solution**:
- Check that each line follows the pattern: `key: value`
- Ensure there are no tabs (use spaces only)
- Make sure colons (`:`) have a space after them
- Verify indentation is consistent
- Don't use special characters in values without quotes

**Example of incorrect YAML:**
```yaml
api_key:test                    ❌ (missing space after colon)
base_url :http://localhost      ❌ (space before colon)
	model: gpt-4                ❌ (using tabs instead of spaces)
```

**Example of correct YAML:**
```yaml
api_key: test                   ✅
base_url: http://localhost      ✅
model: gpt-4                    ✅
```

### "Name must be unique" Error

**Problem**: You're trying to use a name that's already taken

**Solution**:
- Choose a different name for your model
- Or delete/rename the existing model with that name first

### Model Not Responding

**Problem**: The model is configured but doesn't respond to queries

**Solutions**:
1. **Check API Key**: Verify your API key is correct and active
2. **Verify Base URL**: Ensure the URL is reachable
   - For local models: Make sure the local service is running
   - Test the URL in your browser or with `curl`
3. **Check Model Name**: Confirm the model identifier matches exactly what the API expects
4. **Review Logs**: Check the backend logs for error messages
5. **Test API Directly**: Try calling the API endpoint directly to ensure it's working

### Connection Timeout

**Problem**: Requests to the model are timing out

**Solutions**:
- For local models: Ensure the local service is running and accessible
- For cloud APIs: Check your internet connection
- Add a `timeout` parameter to your specifications with a higher value:
  ```yaml
  api_key: your-key
  base_url: https://api.example.com
  model: model-name
  timeout: 60
  ```

---

## Additional Resources

### API Documentation by Provider:

- **OpenAI**: [https://platform.openai.com/docs/api-reference/introduction](https://platform.openai.com/docs/api-reference/introduction)
- **Anthropic (Claude)**: [https://docs.anthropic.com/](https://docs.anthropic.com/)
- **Google (Gemini)**: [https://ai.google.dev/docs](https://ai.google.dev/docs)
- **Ollama (Local Models)**: [https://ollama.com/](https://ollama.com/)

### Getting API Keys:

- **OpenAI**: Sign up at [https://platform.openai.com/](https://platform.openai.com/) and create an API key
- **Anthropic**: Register at [https://www.anthropic.com/](https://www.anthropic.com/)
- **Google**: Use Google Cloud Console for Gemini API access

### YAML Format Help:

- **Learn YAML**: [https://yaml.org/](https://yaml.org/)
- **YAML Validator**: Use online tools like [https://www.yamllint.com/](https://www.yamllint.com/) to check your YAML syntax

---

## Summary Checklist

Before you finish, make sure you've completed these steps:

- [ ] Logged in as admin user
- [ ] Navigated to Settings → General → LLM → Create LLM
- [ ] Selected the appropriate vendor
- [ ] Entered valid specifications in YAML format
- [ ] Given the model a unique, descriptive name
- [ ] Set as default (if desired)
- [ ] Clicked Submit successfully
- [ ] Tested the model by creating/using an agent
- [ ] (Optional) Repeated the process for embedding models

---

## Need Help?

If you encounter issues not covered in this guide:

1. Check the backend logs for detailed error messages
2. Verify your API provider's status page for outages
3. Consult your AI service provider's documentation
4. Refer to the platform's main documentation

