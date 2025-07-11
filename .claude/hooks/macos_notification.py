#!/usr/bin/env python3

import subprocess
import sys
import json

def send_notification(title, message, sound="default"):
    """Send a macOS notification using osascript"""
    try:
        # Escape quotes in the title and message
        escaped_title = title.replace('"', '\\"')
        escaped_message = message.replace('"', '\\"')
        # Try AppleScript with explicit app bundle identifier
        script = f'''
        tell application "System Events"
            display notification "{escaped_message}" with title "{escaped_title}"
        end tell
        '''
        print(f"DEBUG: Running script with System Events", file=sys.stderr)
        result = subprocess.run(['osascript', '-e', script], check=True, capture_output=True, text=True)
        print(f"DEBUG: Script executed successfully", file=sys.stderr)
    except subprocess.CalledProcessError as e:
        print(f"Failed to send notification: {e}", file=sys.stderr)
    except Exception as e:
        print(f"Error sending notification: {e}", file=sys.stderr)

def main():

    input_data = json.load(sys.stdin)
    tool_name = input_data.get("tool_name")
    
    # Create notification title and message based on tool name
    if tool_name == 'Bash':
        title = "Command Executed"
        message = "Terminal command completed"
    elif tool_name == 'Edit':
        title = "File Modified"
        message = "File has been edited"
    elif tool_name == 'Write':
        title = "File Created"
        message = "New file has been written"
    elif tool_name == 'Read':
        title = "File Accessed"
        message = "File has been read"
    elif tool_name == 'Grep':
        title = "Search Complete"
        message = "Text search finished"
    elif tool_name == 'Glob':
        title = "Pattern Match"
        message = "File pattern search completed"
    elif tool_name == 'WebFetch':
        title = "Web Request"
        message = "Web content fetched"
    elif tool_name == 'Task':
        title = "Task Complete"
        message = "Background task finished"
    else:
        title = "Claude Code Complete"
        message = "operation finished"
    
    send_notification(title, message)

main()
