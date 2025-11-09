#!/bin/bash

# Function to get or create labeled space
get_or_create_space() {
    local label=$1
    local space_index=$(yabai -m query --spaces | jq -r ".[] | select(.label == \"$label\") | .index" | head -1)

    if [ -z "$space_index" ]; then
        # Space doesn't exist, find first unlabeled space or create one
        local unlabeled_index=$(yabai -m query --spaces | jq -r '.[] | select(.label == "") | .index' | head -1)
        if [ -n "$unlabeled_index" ]; then
            # Use existing unlabeled space
            space_index=$unlabeled_index
        else
            # No unlabeled spaces, create new one
            yabai -m space --create 2>/dev/null
            space_index=$(yabai -m query --spaces | jq -r '.[] | select(.label == "") | .index' | head -1)
        fi
        # Label the space
        [ -n "$space_index" ] && yabai -m space "$space_index" --label "$label" 2>/dev/null
    fi

    echo "$space_index"
}

# Ensure all 4 labeled spaces exist
CHAT_INDEX=$(get_or_create_space "chat")
TERM_INDEX=$(get_or_create_space "term")
WEB_INDEX=$(get_or_create_space "web")
MISC_INDEX=$(get_or_create_space "misc")

# Clean up any unlabeled spaces (keep only our 4 labeled ones)
yabai -m query --spaces | jq -r '.[] | select(.label == "") | .index' | sort -rn | while read space_index; do
    yabai -m space "$space_index" --destroy 2>/dev/null
done

# Get display count
COUNT=$(yabai -m query --displays | jq 'length')

if [ "$COUNT" -ge 3 ]; then
    # docked mode - move labeled spaces to appropriate displays
    [ -n "$CHAT_INDEX" ] && yabai -m space "$CHAT_INDEX" --display 1 2>/dev/null
    [ -n "$TERM_INDEX" ] && yabai -m space "$TERM_INDEX" --display 2 2>/dev/null
    [ -n "$WEB_INDEX" ] && yabai -m space "$WEB_INDEX" --display 3 2>/dev/null
    [ -n "$MISC_INDEX" ] && yabai -m space "$MISC_INDEX" --display 1 2>/dev/null
else
    # laptop mode - move all labeled spaces to display 1
    [ -n "$CHAT_INDEX" ] && yabai -m space "$CHAT_INDEX" --display 1 2>/dev/null
    [ -n "$TERM_INDEX" ] && yabai -m space "$TERM_INDEX" --display 1 2>/dev/null
    [ -n "$WEB_INDEX" ] && yabai -m space "$WEB_INDEX" --display 1 2>/dev/null
    [ -n "$MISC_INDEX" ] && yabai -m space "$MISC_INDEX" --display 1 2>/dev/null
fi
