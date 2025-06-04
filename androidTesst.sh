#!/bin/bash

# Title
echo "🔍 Android Project Dependency and Test Audit"
echo "==========================================="
echo ""

# 1. List dependencies from Gradle files
echo "📦 Dependencies (from Gradle files)"
echo "-----------------------------------"

for file in $(find . -name "build.gradle*" -type f); do
    echo "🔹 $file"
    grep -E "^\s*(implementation|api|compileOnly|testImplementation|androidTestImplementation|kapt|classpath)" "$file" || echo "  (No dependencies found)"
    echo ""
done

# 2. List and count unit tests
echo "🧪 Unit Test Summary (src/test/)"
echo "-------------------------------"
find ./src/test -type f \( -name "*Test.kt" -o -name "*Test.java" \)
unit_count=$(find ./src/test -type f \( -name "*Test.kt" -o -name "*Test.java" \) | wc -l)
echo "🔢 Unit test file count: $unit_count"
echo ""

# 3. List and count instrumented tests
echo "🧪 Instrumented Test Summary (src/androidTest/)"
echo "---------------------------------------------"
find ./src/androidTest -type f \( -name "*Test.kt" -o -name "*Test.java" \)
instr_count=$(find ./src/androidTest -type f \( -name "*Test.kt" -o -name "*Test.java" \) | wc -l)
echo "🔢 Instrumented test file count: $instr_count"
echo ""

# 4. Extract all import statements from Kotlin/Java files
echo "📥 Import Statements in Codebase"
echo "-------------------------------"
find ./src -type f \( -name "*.kt" -o -name "*.java" \) -exec grep -h "^import " {} \; | sort | uniq
echo ""

# 5. Completion
echo "✅ Audit script completed."