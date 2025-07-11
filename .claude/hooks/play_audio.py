#!/usr/bin/env python3
"""
Claude Code Stop Hook - Task Completion Announcer
Plays pre-generated audio clips when tasks are completed
"""

import sys
import subprocess
from pathlib import Path


def play_audio(audio_file):
    """Play audio file using system audio player"""
    try:
        # Use afplay on macOS
        subprocess.run(["afplay", str(audio_file)], check=True)
    except subprocess.CalledProcessError:
        print(f"Failed to play audio: {audio_file}")
    except FileNotFoundError:
        print(
            "Audio player not found. Install afplay or modify script for your system."
        )


def main():
    """Main function for Claude Code stop hook"""
    print("Stop hook triggered!")
    # Get audio directory
    audio_dir = Path(__file__).parent.parent / "audio"

    # Default to task_complete sound
    audio_file = "task_complete.mp3"

    # Override with specific sound if provided as argument
    if len(sys.argv) > 1:
        audio_file = f"{sys.argv[1]}.mp3"

    # Full path to audio file
    audio_path = audio_dir / audio_file

    # Check if audio file exists
    if not audio_path.exists():
        print(f"Audio file not found: {audio_path}")
        print("Run generate_audio_clips.py first to create audio files.")
        sys.exit(1)

    # Play the audio
    play_audio(audio_path)


main()
