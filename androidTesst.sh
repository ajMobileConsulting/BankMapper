#!/bin/bash

echo "🔍 Android Project Dependency and Test Audit"
echo "============================================"

# 1. Dependency Extraction
echo -e "\n📦 Gradle Dependencies (implementation, api, test):"
find . -name "build.gradle*" -type f \
  | while read -r file; do
      echo "--- $file ---"
      grep -E '^\s*(implementation|api|testImplementation|debugImplementation)' "$file" \
        | sed -E 's/^[ \t]*//'
  done

# 2. Test Coverage Summary
echo -e "\n🧪 Unit Test Summary (src/test/):"
TEST_SRC="./src/test"
if [[ -d "$TEST_SRC" ]]; then
  TEST_FILES=$(find "$TEST_SRC" -name "*.kt" | wc -l)
  TEST_METHODS=$(grep -r --include="*.kt" '@Test' "$TEST_SRC" | wc -l)
  echo "📄 Test files: $TEST_FILES"
  echo "✅ Test methods: $TEST_METHODS"
else
  echo "⚠️  No unit test files found in $TEST_SRC"
fi

echo -e "\n🧪 Instrumented Test Summary (src/androidTest/):"
ANDROID_TEST_SRC="./src/androidTest"
if [[ -d "$ANDROID_TEST_SRC" ]]; then
  TEST_FILES=$(find "$ANDROID_TEST_SRC" -name "*.kt" | wc -l)
  TEST_METHODS=$(grep -r --include="*.kt" '@Test' "$ANDROID_TEST_SRC" | wc -l)
  echo "📄 Test files: $TEST_FILES"
  echo "✅ Test methods: $TEST_METHODS"
else
  echo "⚠️  No instrumented test files found in $ANDROID_TEST_SRC"
fi

echo -e "\n✅ Android audit script completed."
