#!/bin/sh

flutter pub get

# developer needs to specify runtime variables in ~/.bashrc or similar file
# export API_FUNCTION_KEY="FUNCTION_KEY_PLACEHOLDER"
# export API_TOKEN_ISSUE_BODY="TOKEN_ISSUE_BODY_PLACEHOLDER"

# Off emulator tests
flutter test --dart-define=FUNCTION_KEY=$API_FUNCTION_KEY --dart-define=TOKEN_ISSUE_BODY=$API_TOKEN_ISSUE_BODY

# On emulator tests
flutter test integration_test/on_emulator_test.dart