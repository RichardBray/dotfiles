#!/usr/bin/env python3

import json
import sys
from pathlib import Path
from datetime import datetime


def main():
    try:
        # Read input data from stdin
        input_data = json.load(sys.stdin)

        # Extract tool_input from the input data
        tool_input = input_data.get("tool_input", {})

        # Create log entry with timestamp
        log_entry = {
            "timestamp": datetime.now().isoformat(),
            "session_id": input_data.get("session_id"),
            "tool_name": input_data.get("tool_name"),
            "command": tool_input.get("command"),
            "description": tool_input.get("description"),
        }

        # Path to the bash_commands.json file in .claude directory
        log_file = Path(__file__).parent.parent / "bash_commands.json"

        # Load existing data or create empty list
        if log_file.exists():
            with open(log_file, "r") as f:
                logs = json.load(f)
        else:
            logs = []

        # Append new log entry
        logs.append(log_entry)

        # Save back to file
        with open(log_file, "w") as f:
            json.dump(logs, f, indent=2)

        print(f"Tool input logged to {log_file}")

    except json.JSONDecodeError as e:
        print(f"Error parsing JSON input: {e}", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)


main()
