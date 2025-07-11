#!/usr/bin/env python3

import json
import sys

# Read input data from stdin
input_data = json.load(sys.stdin)

print(f"PreToolUse hook triggered: {input_data}", file=sys.stderr)
sys.exit(1)
