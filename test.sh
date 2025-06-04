#!/bin/bash

# Update this if your project folder has a different name
PROJECT_DIR="InvestorExperience"
WORKSPACE_DIR="${PROJECT_DIR}.xcworkspace"
RESOLVED_FILE="$WORKSPACE_DIR/xcshareddata/swiftpm/Package.resolved"

echo "📁 Scanning project: $PROJECT_DIR"

### Swift Imports
echo -e "\n📦 Imported Swift frameworks:"
grep -h --include="*.swift" -r '^import ' "$PROJECT_DIR/" \
  | sed 's/^import[[:space:]]*//' \
  | awk '{print $1}' \
  | sort -u

### CocoaPods
echo -e "\n📦 CocoaPods dependencies:"
if [[ -f "$PROJECT_DIR/Podfile" ]]; then
  grep 'pod ' "$PROJECT_DIR/Podfile" \
    | awk '{print $2}' \
    | tr -d "'" \
    | sort -u
else
  echo "⚠️  No Podfile found."
fi

### Swift Package Manager (SPM) via Package.resolved
echo -e "\n📦 Swift Package Manager dependencies:"
if [[ -f "$RESOLVED_FILE" ]]; then
  grep '"repositoryURL"' "$RESOLVED_FILE" \
    | sed -E 's/.*"repositoryURL" *: *"(.*)",/\1/' \
    | sort -u
else
  echo "⚠️  No Package.swift or Package.resolved found (SPM via Xcode UI only)."
fi

### Optional: Basic Test Coverage Summary
TEST_DIR="${PROJECT_DIR}Tests"
if [[ -d "$TEST_DIR" ]]; then
  echo -e "\n🧪 Test summary:"
  find "$TEST_DIR" -name "*.swift" | wc -l | awk '{print "📄 Test files:", $1}'
  grep -r --include="*.swift" -E 'func test[A-Z]' "$TEST_DIR" \
    | wc -l | awk '{print "✅ Test methods:", $1}'
else
  echo -e "\n⚠️  No test target folder found at: $TEST_DIR"
fi

echo -e "\n✅ Script completed."
