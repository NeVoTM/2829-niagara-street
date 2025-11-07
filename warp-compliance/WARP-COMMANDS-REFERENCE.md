# 🚀 WARP COMMANDS REFERENCE
## Complete List of Available Commands

**Location:** `warp-compliance/WARP-COMMANDS-REFERENCE.md`  
**Purpose:** Quick reference for all SAIT system commands  
**Last Updated:** 2025-11-07

---

## 📋 SESSION COMMANDS

### `WarpSpeed`
**Purpose:** Start of session procedure (SOS)  
**What it does:**
1. Downloads all compliance files from GitHub (enforces RULE 1.1)
2. Reads all compliance files and displays them
3. Checks TODO list and shows breakdown
4. Offers cleanup routine
5. Displays critical rules reminder
6. Shows confirmation of files read

**Usage:**
```powershell
WarpSpeed              # Standard startup
WarpSpeed -ShowPath    # Show file paths
WarpSpeed -Update      # Update mode
WarpSpeed -QuickStart  # Skip prompts
```

**When to use:** At the start of EVERY work session
### `r`
**Purpose:** Rules reminder with self-check enforcement  
**What it does:**
1. Displays critical compliance rules (RULE 1.1, 2.1, 4.1, 4.2)
2. Shows MANDATORY SELF-CHECK PROCESS
3. Instructs Warp AI to verify compliance after answering
4. Forces Warp AI to redo answer if rules violated

**Usage:**
```powershell
r    # Display rules reminder before asking question
```

**When to use:** Before EVERY task/question you give to Warp AI  
**Purpose:** Enforce rule compliance through self-checking mechanism  
**Expected flow:**
1. User types: `r`
2. User asks question
3. Warp AI runs `r` before answering
4. Warp AI provides answer
5. Warp AI runs `r` after answering to verify compliance
6. If rules violated, Warp AI redoes the answer


---

### `eos`
**Purpose:** End of Session routine  
**What it does:**
1. Commits changes to GitHub
2. Generates session documentation
3. Updates completion tracker
4. Creates TODO list for next session

**Usage:**
```powershell
eos
```

**When to use:** At the end of EVERY work session (RULE 7.2)

---

### `clean`
**Purpose:** Run profile cleanup and health check  
**What it does:**
1. Checks for duplicate files
2. Detects outdated files
3. Verifies git status
4. Checks disk space

**Usage:**
```powershell
clean
```

**When to use:** When WarpSpeed prompts, or before committing changes

---

### `rules`
**Purpose:** Display WARP MASTER RULES quick reference  
**What it does:**
- Shows the 7 most critical rules
- Displays location of full rules file

**Usage:**
```powershell
rules
```

**When to use:** Anytime you need a rule reminder

---

## 🔧 ONE-LETTER DEBUG COMMANDS

### `c` - Check System
**Purpose:** Run comprehensive system check  
**Usage:** `c`

### `p [port]` - Check Port
**Purpose:** Check if port is in use (default: 3000)  
**Usage:** 
```powershell
p          # Check port 3000
p 8080     # Check port 8080
```

### `f [file]` - Find File
**Purpose:** Locate file in system  
**Usage:** `f myfile.txt`

### `e [error]` - Check Error
**Purpose:** Analyze error message  
**Usage:** `e "Error message here"`

### `g` - Git Status
**Purpose:** Quick git status check  
**Usage:** `g`

### `n` - NPM Check
**Purpose:** Check npm status and packages  
**Usage:** `n`

### `l [issue]` - Layout Debugger
**Purpose:** Fix CSS/HTML layout issues  
**Usage:** 
```powershell
l                    # Default: border overlap
l "alignment issue"  # Specific issue
```

### `q` - Reload Shortcuts
**Purpose:** Reload QuickStart.ps1 shortcuts  
**Usage:** `q`

---

## 🎨 VISUAL INTERFACE COMMANDS

### `v` - Open Visual Interface
**Purpose:** Launch SuperDebug.html visual interface  
**What it does:**
- Opens 10-tab debugging interface in browser
- Provides visual navigation for all SAIT tools

**Usage:** `v`

**Alias:** `visual`

---

## ⚙️ SWIFTLETTER CONTROL

### `swiftoff`
**Purpose:** Disable 1-letter command shortcuts in new windows  
**Usage:** `swiftoff`

### `swifton`
**Purpose:** Re-enable 1-letter command shortcuts  
**Usage:** `swifton`

---

## 📝 EXTENDED DEBUG COMMANDS

### `check`
**Purpose:** Full system check (same as `c`)  
**Usage:** `check`

### `port3000`
**Purpose:** Check if port 3000 is in use  
**Usage:** `port3000`

### `port8080`
**Purpose:** Check if port 8080 is in use  
**Usage:** `port8080`

### `gitstatus`
**Purpose:** Detailed git status (same as `g`)  
**Usage:** `gitstatus`

### `npmcheck`
**Purpose:** NPM system check (same as `n`)  
**Usage:** `npmcheck`

### `fixwarp`
**Purpose:** Fix Warp-specific layout issues  
**Usage:** `fixwarp`

---

## 🗂️ COMMAND FILES LOCATION

### Primary Files:
1. **Profile:** `C:\Users\17274\Documents\PowerShell\Microsoft.PowerShell_profile.ps1`
   - Loads on every terminal start
   - Contains: WarpSpeed, eos, clean, rules, swiftoff, swifton
   - Sets environment variables for rule enforcement

2. **QuickStart.ps1:** `C:\Users\17274\ME\2829-Niagara-Street\warp-toolbox\core\QuickStart.ps1`
   - Loaded automatically by profile
   - Contains: All 1-letter commands (c, p, f, e, g, n, l, v, q)
   - Contains: Extended commands (check, port3000, gitstatus, etc.)

### Supporting Scripts:
- **WarpSpeed.ps1:** `C:\Users\17274\ME\2829-Niagara-Street\WarpSpeed.ps1`
- **EOS-Routine.ps1:** `C:\Users\17274\ME\2829-Niagara-Street\warp-toolbox\core\EOS-Routine.ps1`
- **CleanAndHealthy.ps1:** `C:\Users\17274\ME\2829-Niagara-Street\warp-toolbox\core\CleanAndHealthy.ps1`

---

## 🎯 QUICK WORKFLOW

### Start of Session:
```powershell
WarpSpeed              # Read GitHub files, check TODO, show rules
```

### During Work:
```powershell
v                      # Open visual interface
c                      # Quick system check
g                      # Check git status
rules                  # Remind yourself of rules
```

### End of Session:
```powershell
clean                  # Optional: cleanup check
eos                    # Commit, document, prepare for next session
```

---

## 🔍 HOW TO FIND COMMANDS

### View all loaded functions:
```powershell
Get-Command | Where-Object {$_.Source -eq "" -and $_.CommandType -eq "Function"} | Select-Object Name | Sort-Object Name
```

### Check if specific command exists:
```powershell
Get-Command v          # Shows command details
Get-Alias v            # Shows if it's an alias
```

### View command definition:
```powershell
(Get-Command v).Definition
```

---

## 📊 COMMAND CATEGORIES

| Category | Commands | Purpose |
|----------|----------|---------|
| **Session** | WarpSpeed, eos, clean, rules | Session management |
| **1-Letter** | c, p, f, e, g, n, l, v, q | Quick debugging |
| **Visual** | v, visual | Interface access |
| **Control** | swiftoff, swifton | Toggle shortcuts |
| **Extended** | check, port3000, gitstatus, npmcheck, fixwarp | Detailed checks |

---

## 🚨 ENVIRONMENT VARIABLES

These are set by the profile to signal rule enforcement to Warp AI:

- `$env:WARP_RULE_1_1` = "GitHub-first: Read/save GitHub BEFORE local"
- `$env:WARP_RULE_2_1` = "Use numbered references: SECTION X.X, RULE X.X"
- `$env:WARP_RULE_4_1` = "Fix ALL instances, not just one"
- `$env:WARP_RULE_4_2` = "Update cross-references in related files"
- `$env:WARP_RULES_LOADED` = "true"
- `$env:WARP_GITHUB_FIRST` = "true" (set after WarpSpeed runs)

---

## 📚 RELATED FILES

- **WARP-MASTER-RULES.md** - All 19 numbered rules
- **DEBUGGING-CHECKLIST.md** - 10 categories of solutions
- **WARP-QUESTIONS-GUIDE.md** - Question templates and defaults
- **TODO-LIST.md** - Current work tracking
- **SAIT-DIRECTORY-STRUCTURE.md** - File organization

---

**END OF COMMANDS REFERENCE**


