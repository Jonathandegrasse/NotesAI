# NotesAI

# Project Documentation

## Overview

This project is built with Dart and Flutter, designed for mobile application development. It is structured to be robust and scalable. Follow the setup instructions below to get the project running on your local machine.

## File Structure

Important files and directories within this project include:

- **`pubspec.yaml`**: Contains metadata and dependencies required by the project.
- **`android/`**
    - **`app/`**
        - **`src/`**
            - **`main/`**
                - **`AndroidManifest.xml`**: Links the pubspec.yaml file to this file to give android the specific premissions detailed in the .yaml file.
- **`lib/`**:
  - **`main.dart`**: The entry point of the application, which initializes and loads the home screen.
  - **`pages/`**:
    - **`home_page.dart`**: Represents the main page of the application.

- **`.env`**: A file used to store API keys securely. This file is not committed to the public repository for security reasons.

## Setting Up

### Prerequisites

Ensure you have Flutter installed on your system. If not, refer to the [Flutter Installation Guide](https://flutter.dev/docs/get-started/install).

### Configuration

1. **Clone the Repository**
   ```bash
   git clone [repository-url]
   cd [project-directory]

2. **Install Dependencies**
    ```bash
    flutter pub get

3. **API Keys**
- Create a .env file in the project root and include your API keys.
- Example .env content:
    ```makefile
    API_KEY="your_api_key_here"

## Additional Requirements

- **Android Emulator**: To fully test and run the Flutter application, an Android emulator is required. Ensure you have an emulator set up and running before executing the `flutter run` command. You can set up an emulator using Android Studio's AVD Manager or by using other tools like Genymotion.

## Running the Project

Execute the following command to run the project:

```bash
flutter run
```

This will start the Flutter development server and launch the application on your default emulator or connected device.

## Note on API Keys 

The application requires specific API keys to operate correctly, which must be included in the .env file as described. The absence of these keys will impair the functionality of the application.

## Testing

Ensure that your .env file contains all the necessary API keys for testing. Attempting to test without valid API keys will lead to errors or reduced functionality.










