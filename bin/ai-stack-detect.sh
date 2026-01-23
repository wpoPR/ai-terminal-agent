#!/bin/bash
# ai-stack-detect.sh - Automated stack detection for AI Terminal Agent
#
# Usage:
#   ai-stack-detect                      # Detect all, pick best match
#   ai-stack-detect --filter=frontend    # Only check frontend stacks
#   ai-stack-detect --filter=backend     # Only check backend stacks
#   ai-stack-detect --path=./frontend    # Detect in specific directory
#
# Output: Creates .ai-context/stack-config.md

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
RULES_FILE="${HOME}/.ai-workspace/config/stack-rules.json"
OUTPUT_DIR=".ai-context"
OUTPUT_FILE="${OUTPUT_DIR}/stack-config.md"

# Parse arguments
FILTER=""
TARGET_PATH="."

for arg in "$@"; do
  case $arg in
    --filter=*)
      FILTER="${arg#*=}"
      shift
      ;;
    --path=*)
      TARGET_PATH="${arg#*=}"
      shift
      ;;
    --help|-h)
      echo "Usage: ai-stack-detect [--filter=<profile>] [--path=<directory>]"
      echo ""
      echo "Options:"
      echo "  --filter=<profile>  Only check stacks for this profile"
      echo "                      (frontend, backend, mobile, fullstack, devops, data, ai-ml, research)"
      echo "  --path=<directory>  Target directory (default: current)"
      echo ""
      echo "Examples:"
      echo "  ai-stack-detect                    # Detect all stacks"
      echo "  ai-stack-detect --filter=frontend  # Only frontend stacks"
      echo "  ai-stack-detect --path=./backend   # Detect in backend/"
      exit 0
      ;;
  esac
done

# Change to target directory if specified
if [[ "$TARGET_PATH" != "." ]]; then
  cd "$TARGET_PATH" || { echo -e "${RED}Error: Cannot access $TARGET_PATH${NC}"; exit 1; }
fi

# Check if rules file exists
if [[ ! -f "$RULES_FILE" ]]; then
  echo -e "${RED}Error: Stack rules not found at $RULES_FILE${NC}"
  echo "Run 'ai-install' or check your installation."
  exit 1
fi

# JSON parsing strategy
parse_json() {
  local file="$1"
  local query="$2"
  
  if command -v jq &> /dev/null; then
    jq -r "$query" "$file" 2>/dev/null
  elif command -v python3 &> /dev/null; then
    python3 -c "
import json
import sys
with open('$file') as f:
    data = json.load(f)
    result = eval('data$query'.replace('.', \"['\").replace('[', \"']['\").rstrip(\"'\") + \"]\")
    if isinstance(result, list):
        for item in result:
            print(item)
    else:
        print(result)
" 2>/dev/null
  else
    echo -e "${YELLOW}Warning: jq or python3 not found. Limited detection.${NC}"
    return 1
  fi
}

# Get all rule IDs
get_rule_ids() {
  if command -v jq &> /dev/null; then
    jq -r '.rules[].id' "$RULES_FILE"
  elif command -v python3 &> /dev/null; then
    python3 -c "
import json
with open('$RULES_FILE') as f:
    data = json.load(f)
    for rule in data['rules']:
        print(rule['id'])
"
  fi
}

# Get rule property
get_rule_property() {
  local rule_id="$1"
  local property="$2"
  
  if command -v jq &> /dev/null; then
    jq -r ".rules[] | select(.id == \"$rule_id\") | .$property" "$RULES_FILE"
  elif command -v python3 &> /dev/null; then
    python3 -c "
import json
with open('$RULES_FILE') as f:
    data = json.load(f)
    for rule in data['rules']:
        if rule['id'] == '$rule_id':
            val = rule.get('$property')
            if isinstance(val, dict):
                import json as j
                print(j.dumps(val))
            elif isinstance(val, list):
                print(' '.join(val))
            else:
                print(val if val else '')
            break
"
  fi
}

# Check if rule matches profile filter
matches_filter() {
  local rule_id="$1"
  
  if [[ -z "$FILTER" ]]; then
    return 0
  fi
  
  local profiles
  profiles=$(get_rule_property "$rule_id" "profiles")
  
  if echo "$profiles" | grep -qw "$FILTER"; then
    return 0
  fi
  return 1
}

# Check if file exists (supports glob patterns and searches subdirectories)
check_files_exist() {
  local files="$1"
  
  # Common subdirectories to search
  local search_dirs=("." "src" "app" "lib" "packages" "backend" "frontend" "server" "client")
  
  for file in $files; do
    # Check in root and common subdirectories
    for dir in "${search_dirs[@]}"; do
      local check_path="$dir/$file"
      [[ "$dir" == "." ]] && check_path="$file"
      
      # Handle glob patterns
      if [[ "$file" == *"*"* ]]; then
        if ls $check_path 1>/dev/null 2>&1; then
          return 0
        fi
      elif [[ -f "$check_path" ]]; then
        return 0
      fi
    done
    
    # Also try find for deeper nested files (limited depth for performance)
    if [[ "$file" == *"*"* ]]; then
      # Convert glob to find pattern
      local pattern="${file//\*/}"
      if find . -maxdepth 3 -name "*${pattern}*" -type f 2>/dev/null | head -1 | grep -q .; then
        return 0
      fi
    fi
  done
  return 1
}

# Check if file contains string
file_contains() {
  local file="$1"
  local search="$2"
  
  if [[ -f "$file" ]]; then
    grep -q "$search" "$file" 2>/dev/null
    return $?
  fi
  return 1
}

# Detect stack
detect_stack() {
  local detected_id=""
  local detected_name=""
  
  for rule_id in $(get_rule_ids); do
    # Check profile filter
    if ! matches_filter "$rule_id"; then
      continue
    fi
    
    # Get detection config
    local detect_files
    detect_files=$(get_rule_property "$rule_id" "detect" | python3 -c "
import json, sys
try:
    data = json.loads(sys.stdin.read())
    print(' '.join(data.get('files', [])))
except:
    pass
" 2>/dev/null)
    
    # Check if detection files exist
    if ! check_files_exist "$detect_files"; then
      continue
    fi
    
    # Check contains conditions
    local contains
    contains=$(get_rule_property "$rule_id" "detect" | python3 -c "
import json, sys
try:
    data = json.loads(sys.stdin.read())
    contains = data.get('contains', {})
    for file, searches in contains.items():
        for s in searches:
            print(f'{file}:{s}')
except:
    pass
" 2>/dev/null)
    
    local all_contains_match=true
    if [[ -n "$contains" ]]; then
      while IFS= read -r check; do
        local check_file="${check%%:*}"
        local check_string="${check#*:}"
        if [[ -n "$check_file" ]] && [[ -n "$check_string" ]]; then
          if ! file_contains "$check_file" "$check_string"; then
            all_contains_match=false
            break
          fi
        fi
      done <<< "$contains"
    fi
    
    if $all_contains_match; then
      detected_id="$rule_id"
      detected_name=$(get_rule_property "$rule_id" "name")
      break
    fi
  done
  
  echo "$detected_id|$detected_name"
}

# Generate stack-config.md
generate_config() {
  local rule_id="$1"
  local rule_name="$2"
  
  # Get all properties
  local test_cmd lint_cmd build_cmd typecheck_cmd test_coverage_cmd
  local lines_per_function lines_per_file params_per_function
  
  # Commands
  test_cmd=$(get_rule_property "$rule_id" "commands" | python3 -c "import json,sys; d=json.loads(sys.stdin.read()); print(d.get('test',''))" 2>/dev/null)
  test_coverage_cmd=$(get_rule_property "$rule_id" "commands" | python3 -c "import json,sys; d=json.loads(sys.stdin.read()); print(d.get('test_coverage',''))" 2>/dev/null)
  lint_cmd=$(get_rule_property "$rule_id" "commands" | python3 -c "import json,sys; d=json.loads(sys.stdin.read()); print(d.get('lint',''))" 2>/dev/null)
  build_cmd=$(get_rule_property "$rule_id" "commands" | python3 -c "import json,sys; d=json.loads(sys.stdin.read()); print(d.get('build',''))" 2>/dev/null)
  typecheck_cmd=$(get_rule_property "$rule_id" "commands" | python3 -c "import json,sys; d=json.loads(sys.stdin.read()); print(d.get('typecheck',''))" 2>/dev/null)
  
  # Limits
  lines_per_function=$(get_rule_property "$rule_id" "limits" | python3 -c "import json,sys; d=json.loads(sys.stdin.read()); print(d.get('lines_per_function',30))" 2>/dev/null)
  lines_per_file=$(get_rule_property "$rule_id" "limits" | python3 -c "import json,sys; d=json.loads(sys.stdin.read()); print(d.get('lines_per_file',300))" 2>/dev/null)
  params_per_function=$(get_rule_property "$rule_id" "limits" | python3 -c "import json,sys; d=json.loads(sys.stdin.read()); print(d.get('params_per_function',4))" 2>/dev/null)
  
  # Create output directory
  mkdir -p "$OUTPUT_DIR"
  
  # Generate markdown
  cat > "$OUTPUT_FILE" << EOF
# Stack Configuration

*Auto-detected by ai-stack-detect*
*Profile: ${FILTER:-auto}*
*Detected: $(date +%Y-%m-%d)*

## Stack

| Component | Value |
|-----------|-------|
| Stack ID | ${rule_id} |
| Name | ${rule_name} |
| Filter | ${FILTER:-none} |

## Commands

| Action | Command |
|--------|---------|
| Test | ${test_cmd:-⚠️ NOT CONFIGURED} |
| Test Coverage | ${test_coverage_cmd:-N/A} |
| Lint | ${lint_cmd:-N/A} |
| Build | ${build_cmd:-N/A} |
| Typecheck | ${typecheck_cmd:-N/A} |

## Quality Limits

| Metric | Limit |
|--------|-------|
| Lines per function | ${lines_per_function} |
| Lines per file | ${lines_per_file} |
| Params per function | ${params_per_function} |

---

*Generated by AI Terminal Agent*
EOF
}

# Main execution
main() {
  echo -e "${BLUE}🔍 Detecting project stack...${NC}"
  
  if [[ -n "$FILTER" ]]; then
    echo -e "   Filter: ${YELLOW}${FILTER}${NC}"
  fi
  
  if [[ "$TARGET_PATH" != "." ]]; then
    echo -e "   Path: ${YELLOW}${TARGET_PATH}${NC}"
  fi
  
  echo ""
  
  # Detect
  local result
  result=$(detect_stack)
  
  local detected_id="${result%%|*}"
  local detected_name="${result#*|}"
  
  if [[ -z "$detected_id" ]]; then
    echo -e "${YELLOW}⚠️  No stack detected${NC}"
    
    # Check if running interactively (terminal attached)
    if [[ -t 0 ]]; then
      echo ""
      echo "Available stacks:"
      echo ""
      
      # List available stacks with numbers
      local i=1
      local stack_ids=()
      for rule_id in $(get_rule_ids); do
        local name
        name=$(get_rule_property "$rule_id" "name")
        printf "  %2d. %-20s (%s)\n" $i "$name" "$rule_id"
        stack_ids+=("$rule_id")
        ((i++))
      done
      
      echo ""
      echo "   0. Skip (create minimal config)"
      echo ""
      read -p "Select stack [0-$((i-1))]: " choice
      
      if [[ "$choice" =~ ^[0-9]+$ ]] && [[ "$choice" -gt 0 ]] && [[ "$choice" -lt "$i" ]]; then
        detected_id="${stack_ids[$((choice-1))]}"
        detected_name=$(get_rule_property "$detected_id" "name")
        echo ""
        echo -e "${GREEN}✓ Selected: $detected_name${NC}"
        
        # Generate config with selected stack
        generate_config "$detected_id" "$detected_name"
        exit 0
      fi
    else
      # Non-interactive mode
      if [[ -n "$FILTER" ]]; then
        echo "   Try without --filter or check if project files exist."
      else
        echo "   Project may use an unsupported stack."
        echo "   You can add custom rules to: $RULES_FILE"
      fi
    fi
    
    # Create minimal config (when skipped or non-interactive)
    mkdir -p "$OUTPUT_DIR"
    cat > "$OUTPUT_FILE" << EOF
# Stack Configuration

*Auto-detected by ai-stack-detect*
*Profile: ${FILTER:-auto}*
*Detected: $(date +%Y-%m-%d)*

## Stack

| Component | Value |
|-----------|-------|
| Stack ID | unknown |
| Name | Unknown/Custom |
| Filter | ${FILTER:-none} |

## Commands

| Action | Command |
|--------|---------|
| Test | ⚠️ NOT CONFIGURED |
| Lint | ⚠️ NOT CONFIGURED |
| Build | ⚠️ NOT CONFIGURED |

## Quality Limits

| Metric | Limit |
|--------|-------|
| Lines per function | 30 |
| Lines per file | 300 |
| Params per function | 4 |

---

*⚠️ Stack not detected. Configure manually or add rules to stack-rules.json*
EOF
    
    echo -e "   Created minimal config at ${OUTPUT_FILE}"
    exit 0
  fi
  
  # Generate config
  generate_config "$detected_id" "$detected_name"
  
  echo -e "${GREEN}✓ Stack detected: ${detected_name}${NC}"
  
  # Check for test command
  local test_cmd
  test_cmd=$(get_rule_property "$detected_id" "commands" | python3 -c "import json,sys; d=json.loads(sys.stdin.read()); print(d.get('test',''))" 2>/dev/null)
  
  if [[ -z "$test_cmd" ]]; then
    echo -e "${YELLOW}⚠️  No test command configured for this stack${NC}"
    echo "   TDD workflow will be limited."
  fi
  
  echo -e "   Config saved to: ${BLUE}${OUTPUT_FILE}${NC}"
}

main "$@"
