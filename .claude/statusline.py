#!/usr/bin/env python3
import json
import sys
import subprocess
from datetime import datetime
import os

def get_git_branch(cwd):
    """Get current git branch with error handling"""
    try:
        result = subprocess.run(
            ['git', 'symbolic-ref', '--short', 'HEAD'], 
            cwd=cwd, 
            capture_output=True, 
            text=True,
            timeout=2
        )
        if result.returncode == 0:
            return result.stdout.strip()
    except (subprocess.TimeoutExpired, FileNotFoundError):
        pass
    
    # Fallback to checking .git/HEAD file
    git_dir = os.path.join(cwd, '.git')
    if os.path.exists(git_dir):
        try:
            head_file = os.path.join(git_dir, 'HEAD')
            if os.path.exists(head_file):
                with open(head_file, 'r') as f:
                    ref = f.read().strip()
                    if ref.startswith('ref: refs/heads/'):
                        return ref.replace('ref: refs/heads/', '')
        except:
            pass
    return None

def get_project_name(cwd):
    """Get project name from directory"""
    return os.path.basename(cwd) if cwd else "unknown"

def main():
    try:
        # Read JSON input from stdin
        input_data = json.loads(sys.stdin.read())
        
        # Extract data
        cwd = input_data.get('workspace', {}).get('current_dir', '')
        model_display = input_data.get('model', {}).get('display_name', 'Unknown Model')
        output_style = input_data.get('output_style', {}).get('name', 'default')
        version = input_data.get('version', '1.0.83')  # fallback to current version
        
        # Get current time
        current_time = datetime.now().strftime("%H:%M")
        
        # Get git branch
        git_branch = get_git_branch(cwd)
        
        # Get project name
        project_name = get_project_name(cwd)
        
        # Build colorful status line with emojis
        parts = []
        
        # Time with clock emoji
        parts.append(f"\033[36m🕒 {current_time}\033[0m")
        
        # Project with folder emoji
        parts.append(f"\033[33m📁 {project_name}\033[0m")
        
        # Branch with git emoji (if available)
        if git_branch:
            parts.append(f"\033[32m🌿 {git_branch}\033[0m")
        
        # Output style with style emoji
        style_emoji = {
            'default': '⚡',
            'Explanatory': '📚',
            'Learning': '🎓',
            'Concise': '⚡',
            'Creative': '🎨'
        }.get(output_style, '⚙️')
        parts.append(f"\033[34m{style_emoji} {output_style}\033[0m")
        
        # Model with robot emoji
        parts.append(f"\033[35m🤖 {model_display}\033[0m")
        
        # Claude Code version (dynamic from input)
        parts.append(f"\033[90m📦 {version}\033[0m")
        
        # Join with pipe separators
        status_line = " \033[37m|\033[0m ".join(parts)
        
        print(status_line)
        
    except (json.JSONDecodeError, KeyError) as e:
        # Fallback status line
        print(f"\033[31m❌ Status Error\033[0m")
        
if __name__ == "__main__":
    main()