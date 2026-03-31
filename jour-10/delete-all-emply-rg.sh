#!/bin/bash
# Azure Empty Resource Group Cleaner
# Filters by subscription and optional location, then deletes empty RGs

echo "========================================"
echo " Azure Empty Resource Group Cleaner"
echo "========================================"

# Prompt for parameters
read -p "Enter Subscription ID: " SUBSCRIPTION_ID
if [ -z "$SUBSCRIPTION_ID" ]; then
    echo "Error: Subscription ID is required."
    exit 1
fi

read -p "Enter Location/Region (optional, press Enter to skip): " LOCATION

# Set the subscription
echo "Setting subscription to $SUBSCRIPTION_ID..."
az account set --subscription "$SUBSCRIPTION_ID" || { echo "Failed to set subscription. Check your login and ID."; exit 1; }

echo "Fetching resource groups..."

# Build query for resource groups (filter by location if provided)
if [ -n "$LOCATION" ]; then
    RG_QUERY="[?location=='$LOCATION']"
    echo "Filtering resource groups in location: $LOCATION"
else
    RG_QUERY="[]"
    echo "No location filter applied (all regions)."
fi

# Get list of resource group names
RESOURCE_GROUPS=$(az group list --query "$RG_QUERY[].name" -o tsv)

if [ -z "$RESOURCE_GROUPS" ]; then
    echo "No resource groups found in this subscription (with the applied filter)."
    exit 0
fi

EMPTY_RGS=()

echo -e "\nChecking for empty resource groups...\n"

for RG in $RESOURCE_GROUPS; do
    # Count resources in the RG
    RESOURCES=$(az resource list --resource-group "$RG" --query "length([])" -o tsv 2>/dev/null)
    
    if [ "$RESOURCES" -eq "0" ] || [ -z "$RESOURCES" ]; then
        EMPTY_RGS+=("$RG")
        echo "✓ Empty: $RG"
    else
        echo "  Not empty ($RESOURCES resources): $RG"
    fi
done

if [ ${#EMPTY_RGS[@]} -eq 0 ]; then
    echo -e "\nNo empty resource groups found."
    exit 0
fi

echo -e "\nFound ${#EMPTY_RGS[@]} empty resource group(s):"
printf ' - %s\n' "${EMPTY_RGS[@]}"

# Ask for deletion mode
echo -e "\nWhat would you like to do?"
echo "1) Delete all empty RGs (with --yes --no-wait)"
echo "2) Confirm each deletion individually (safer)"
read -p "Enter choice (1 or 2): " CHOICE

if [ "$CHOICE" = "1" ]; then
    echo -e "\nDeleting all empty resource groups (asynchronous)..."
    for RG in "${EMPTY_RGS[@]}"; do
        echo "Deleting: $RG"
        az group delete --name "$RG" --yes --no-wait
    done
    echo "Deletion commands issued for all empty RGs."
else
    echo -e "\nConfirming each deletion..."
    for RG in "${EMPTY_RGS[@]}"; do
        read -p "Delete resource group '$RG'? (y/N): " CONFIRM
        if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
            echo "Deleting: $RG"
            az group delete --name "$RG" --yes --no-wait
        else
            echo "Skipped: $RG"
        fi
    done
fi

echo -e "\nScript completed. Note: Deletions with --no-wait run in the background."
echo "You can check status in the Azure Portal or with 'az group list'."
