#!/bin/bash
# Validate all Helm charts in the repository

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
CHART_DIRS=$(find "$REPO_DIR" -maxdepth 1 -type d -not -path "*/\.*" -not -path "$REPO_DIR" -not -path "*/validation*" -not -path "*/apps*")

echo "===== ArgoCD Demo Charts Validation Tool ====="

# Check for required tools
echo "Checking for required tools..."
TOOLS=("helm" "yq" "kubeval")
MISSING_TOOLS=0

for tool in "${TOOLS[@]}"; do
  if ! command -v "$tool" &> /dev/null; then
    echo "❌ $tool is not installed"
    MISSING_TOOLS=1
  else
    echo "✓ $tool found"
  fi
done

if [ $MISSING_TOOLS -eq 1 ]; then
  echo "Please install missing tools and try again"
  exit 1
fi

# Validate each chart
for chart_dir in $CHART_DIRS; do
  chart_name=$(basename "$chart_dir")
  echo ""
  echo "=== Validating chart: $chart_name ==="

  # Check directory structure
  if [ ! -d "$chart_dir/templates" ]; then
    echo "❌ Missing templates directory in $chart_name"
  else
    echo "✓ Templates directory exists"
  fi

  if [ ! -f "$chart_dir/Chart.yaml" ]; then
    echo "❌ Missing Chart.yaml in $chart_name"
    continue
  else
    echo "✓ Chart.yaml exists"
  fi

  if [ ! -f "$chart_dir/values.yaml" ]; then
    echo "❌ Missing values.yaml in $chart_name"
    continue
  else
    echo "✓ Values.yaml exists"
  fi

  # Helm lint
  echo "Running helm lint..."
  if helm lint "$chart_dir"; then
    echo "✓ Helm lint passed"
  else
    echo "❌ Helm lint failed"
  fi

  # Template rendering
  echo "Rendering templates..."
  temp_file=$(mktemp)
  if helm template "$chart_dir" > "$temp_file" 2>/dev/null; then
    echo "✓ Templates render successfully"

    # Validate Kubernetes resources
    echo "Validating Kubernetes resources..."
    if kubeval --strict "$temp_file" > /dev/null; then
      echo "✓ Kubernetes validation passed"
    else
      echo "❌ Kubernetes validation failed. Details:"
      kubeval --strict "$temp_file"
    fi
  else
    echo "❌ Template rendering failed"
  fi

  rm -f "$temp_file"
done

# Validate ArgoCD application definitions
echo ""
echo "=== Validating ArgoCD application definitions ==="
for app_file in "$REPO_DIR"/apps/*.yaml; do
  app_name=$(basename "$app_file" .yaml)
  echo "Validating $app_name..."

  # Check that target path exists
  path=$(yq e '.spec.source.path' "$app_file")
  if [ -d "$REPO_DIR/$path" ]; then
    echo "✓ Target path $path exists"
  else
    echo "❌ Target path $path does not exist"
  fi
done

echo ""
echo "Validation completed!"
