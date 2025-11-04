# 🔧 Debug Toolbox - Where Rubber Meets Steel

## Philosophy
- **Simple is always better**
- **Start small and grow**  
- **Solve real problems NOW**

## Quick Start

```powershell
# Test everything works
.\test-debug.ps1

# Show debug menu
.\DebugToolbox.ps1

# Quick system check
.\DebugToolbox.ps1 check
```

## Main Commands

| Command | Description | Example |
|---------|-------------|---------|
| `check` | System health check | `.\DebugToolbox.ps1 check` |
| `error` | Find solution for error | `.\DebugToolbox.ps1 error "Cannot find module"` |
| `port` | Check what's using a port | `.\DebugToolbox.ps1 port 3000` |
| `file` | File detective | `.\DebugToolbox.ps1 file README.md` |
| `git` | Git status check | `.\DebugToolbox.ps1 git` |
| `npm` | Node/NPM check | `.\DebugToolbox.ps1 npm` |

## Shortcuts (after loading aliases)

```powershell
# Load shortcuts
. .\debug-aliases.ps1

# Use shortcuts
d check          # System check
d port 8080      # Port check  
d error "..."    # Error lookup
dcheck           # Quick system check
dgit             # Git status
```

## Integration

The debug toolbox integrates with:
- **Main Menu** (`.\menu.ps1`) - Shows debug commands
- **FastAccess** (`.\FastAccess.ps1`) - Includes debug shortcuts
- **Error Patterns** (`error-patterns.json`) - Expandable error database

## Error Patterns

The toolbox recognizes these common errors:
- Cannot find path
- Access denied  
- Port already in use
- Module not found
- Git errors
- npm ERR!
- PowerShell execution policy

## Growth Plan

**Phase 1 (Current):** Basic debugging tools that work
**Phase 2 (Future):** Smart error learning and AI suggestions  
**Phase 3 (Future):** Visual dashboard and advanced diagnostics

## Files

- `DebugToolbox.ps1` - Main debugging script
- `debug-aliases.ps1` - Quick shortcuts
- `error-patterns.json` - Error database
- `test-debug.ps1` - Test runner
- `DEBUG-README.md` - This file

## Usage Examples

```powershell
# System acting slow?
.\DebugToolbox.ps1 check

# Can't start your app on port 3000?
.\DebugToolbox.ps1 port 3000

# Getting a weird error message?
.\DebugToolbox.ps1 error "your error message here"

# File missing or corrupted?
.\DebugToolbox.ps1 file path/to/your/file.txt

# Git acting up?
.\DebugToolbox.ps1 git

# npm install failing?
.\DebugToolbox.ps1 npm
```

**Remember: Simple is always better. These tools solve 80% of debugging problems with 20% of the complexity.**