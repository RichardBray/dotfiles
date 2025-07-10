# Claude Code Hooks

## stop.py - Task Completion Audio Hook

The `stop.py` script plays audio notifications when Claude Code tasks are completed.

### Usage

The hook is automatically triggered when Claude Code stops executing. It can be configured in your `settings.json`:

```json
{
  "hooks": {
    "stop": "uv run .claude/hooks/stop.py"
  }
}
```

### Audio Files

The script plays audio files from `~/.claude/audio/`. Available sounds:

- `task_complete.mp3` (default)
- `build_complete.mp3`
- `tests_passed.mp3`
- `deployment_complete.mp3`
- `error_fixed.mp3`
- `ready.mp3`

### Custom Audio Selection

Pass a sound name as an argument to play a specific audio file:

```json
{
  "hooks": {
    "stop": "uv run .claude/hooks/stop.py build_complete"
  }
}
```

### Requirements

- **macOS**: Uses `afplay` (pre-installed)
- **Audio files**: Generated using `utils/generate_audio_clips.py`

### Troubleshooting

If audio files are missing, run:
```bash
uv run .claude/hooks/utils/generate_audio_clips.py
```

The hook will print "Stop hook triggered!" when executed and show error messages if audio files are not found.