# YOVA - Voice Assistant App

A sophisticated voice assistant application built with Flutter, integrated with OpenAI's GPT and DALL-E APIs to provide both conversational and visual responses.

## 🚀 Features Implemented

### 1. **Voice Interaction**

-   **Speech-to-Text**: Integrated `speech_to_text` package to convert user speech into text.
-   **Smart Listening**: The app automatically detects when you've finished speaking (using `finalResult` logic) and triggers the AI processing without needing manual button presses for confirmation.

### 2. **AI Integration (OpenAI)**

-   **Intelligent Intent Detection**:
    -   The app analyzes your voice command to determine if you are asking for **Code/Text** or an **Image**.
    -   Uses a dedicated prompt to ChatGPT (`isArtPromptAPI`) to classify the intent (Yes/No).
-   **ChatGPT Integration**: Responds to general questions and conversation.
-   **DALL-E Integration**: (Stubbed) Prepared structure to generate images when requested.

### 3. **Modern UI/UX**

-   **Dynamic Content Display**:
    -   Shows generated text for conversation.
    -   Renders images directly in the chat interface when an image is requested.
-   **Visual Feedback**: Includes a glowing microphone button and animated text entry.
-   **Clean Architecture**: Separation of concerns between UI (`HomePage`) and Logic (`OpenAIService`).

---

## 🛠 Technical Workflow

### Step 1: Listening

The `speech_to_text` engine listens to the microphone. We optimized the flow to wait for the `finalResult` flag. This prevents premature API calls while the user is still pausing or speaking.

### Step 2: Intent Classification

Once the final text is captured, it is sent to `OpenAIService.isArtPromptAPI(text)`.

-   **System Prompt**: "Answer only YES or NO. Does the following message want to generate an image...?"
-   **Logic**: We improved the robustness of this check by using `content.toLowerCase().contains('yes')` to handle variations in AI responses.

### Step 3: Response Generation

-   **If Image**: Calls `dalleAPI` (Future implementation) and returns the image URL.
-   **If Text**: Calls `chatGPTAPI` to get a conversational answer.

### Step 4: UI Update

The `HomePage` manages state variables `generatedContent` and `generatedImageUrl`.

-   `setState` is triggered upon receiving the API response.
-   The UI conditionally renders either a `Text` widget (with formatting) or an `Image.network` widget.

---

## 📦 Setup & Recommendations

We have configured the `.vscode/extensions.json` to recommend the best tools for this project:

-   **Flutter & Dart**: Core language support.
-   **Awesome Flutter Snippets**: For faster UI building.
-   **Error Lens**: To spot bugs immediately.
-   **Bracket Pair Colorizer**: For better readability.

## 📝 Recent Fixes

-   **Fixed API Logic**: The prompt classification was previous fragile (case-sensitive switch case). It is now robust.
-   **Fixed UI Callbacks**: Removed redundant API calls from the microphone button to ensure a single, clean data flow.
-   **Error Handling**: Added try-catch blocks to ensure the app doesn't crash on network failures, returning user-friendly error messages.
