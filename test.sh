#!/bin/bash

echo "🔍 iOS Project Dependency and Test Audit"
echo "========================================"

### 1. Auto-detect project directory (containing .xcodeproj)
PROJECT_DIR=$(find . -name "*.xcodeproj" -maxdepth 2 | head -n 1 | sed 's|/[^/]*.xcodeproj||')

if [[ -z "$PROJECT_DIR" || ! -d "$PROJECT_DIR" ]]; then
  echo "❌ Could not locate .xcodeproj directory."
  exit 1
fi

echo "📂 Project directory: $PROJECT_DIR"

### 2. Swift Imports
echo -e "\n📦 Imported Swift frameworks:"
grep -h --include="*.swift" -r '^import ' "$PROJECT_DIR/" \
  | sed 's/^import[[:space:]]*//' \
  | awk '{print $1}' \
  | sort -u

### 3. CocoaPods
echo -e "\n📦 CocoaPods dependencies:"
if [[ -f "$PROJECT_DIR/Podfile" ]]; then
  grep 'pod ' "$PROJECT_DIR/Podfile" \
    | awk '{print $2}' \
    | tr -d "'" \
    | sort -u
else
  echo "⚠️  No Podfile found."
fi

### 4. SPM: Look for Package.resolved via workspace or hidden folders
RESOLVED_FILE=$(find "$PROJECT_DIR" -name Package.resolved | head -n 1)
if [[ -z "$RESOLVED_FILE" ]]; then
  RESOLVED_FILE=$(find . -name Package.resolved | head -n 1)
fi

echo -e "\n📦 Swift Package Manager dependencies:"
if [[ -f "$RESOLVED_FILE" ]]; then
  echo "📄 Using Package.resolved at: $RESOLVED_FILE"
  grep '"repositoryURL"' "$RESOLVED_FILE" \
    | sed -E 's/.*"repositoryURL" *: *"(.*)",/\1/' \
    | sort -u
else
  echo "⚠️  Package.resolved not found. SPM may not be configured or is UI-managed."
fi

### 5. Test Summary
TEST_DIR="${PROJECT_DIR}Tests"
echo -e "\n🧪 Test summary:"
if [[ -d "$TEST_DIR" ]]; then
  TEST_FILE_COUNT=$(find "$TEST_DIR" -name "*.swift" | wc -l | awk '{print $1}')
  TEST_METHOD_COUNT=$(grep -r --include="*.swift" -E 'func test[A-Z]' "$TEST_DIR" | wc -l | awk '{print $1}')
  echo "📄 Test files: $TEST_FILE_COUNT"
  echo "✅ Test methods: $TEST_METHOD_COUNT"
else
  echo "⚠️  No test target folder found at: $TEST_DIR"
fi

echo -e "\n✅ Audit script completed."
