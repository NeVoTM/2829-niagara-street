# 🎨 SAIT LAYOUT RULES & DESIGN STANDARDS
## Consistent Interface Development Guidelines

## 📐 COMMAND BOX LAYOUT STANDARDS

### MANDATORY STRUCTURE:
```html
<div class="command-item" data-command="ACTUAL_COMMAND" data-tooltip="STRUCTURED_TOOLTIP">
    <div class="command-text">COMMAND_DISPLAY</div>
    <div class="command-desc">BRIEF_DESCRIPTION — Read more...</div>
</div>
```

### TOOLTIP FORMAT (MANDATORY):
```
Command: [exact command] | What this does: [clear explanation] | Why it matters: [importance/benefit] | Who should use it: [target users] | Why not use it: [when to avoid] | How to use it: [step-by-step instructions]
```

### COMMAND GROUPING:
```html
<div class="command-group" style="background: #2d2d2d; border-radius: 6px; padding: 10px; border-left: 3px solid [COLOR];">
    <div style="color: [COLOR]; font-weight: bold; margin-bottom: 8px; font-size: 12px;">[GROUP_ICON] [GROUP_TITLE]</div>
    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 8px;">
        [COMMAND_ITEMS]
    </div>
    <div style="margin-top: 6px; font-size: 10px; color: #888;">[GROUP_HINT]</div>
</div>
```

## 🎨 COLOR SCHEME STANDARDS

### TAB COLORS:
- **START (Blue):** `#3498db` - Primary entry point
- **SYSTEM (Red):** `#e74c3c` - Critical system functions  
- **ERRORS (Green):** `#27ae60` - Problem resolution
- **FILES (Orange):** `#f39c12` - File operations
- **GIT (Green):** `#27ae60` - Version control
- **DEV (Orange):** `#ff6b35` - Development tools
- **TEMP (Purple):** `#9b59b6` - Testing/temporary
- **DEBUGGING (Yellow):** `#f1c40f` - Debug lessons
- **TODO (Orange):** `#e67e22` - Task management
- **CLEAN & HEALTHY (Green):** `#27ae60` - Maintenance

### COMMAND GROUP COLORS:
- **Port Groups:** `#3498db` (Blue)
- **Sync Groups:** `#e74c3c` (Red) 
- **File Groups:** `#f39c12` (Orange)
- **Git Groups:** `#27ae60` (Green)

## 📱 RESPONSIVE SCALING RULES

### RESOLUTION-BASED SCALING:
```javascript
// Detect screen resolution and apply scaling
const screenWidth = window.screen.width;
const devicePixelRatio = window.devicePixelRatio || 1;
let scaleFactor = 1;

if (screenWidth >= 3840 && devicePixelRatio >= 2) {
    scaleFactor = 2.5;  // 4K+ high DPI
} else if (screenWidth >= 2560) {
    scaleFactor = 2;    // 1440p+
} else if (screenWidth >= 1920) {
    scaleFactor = 1.5;  // 1080p
} else {
    scaleFactor = 1;    // 1080p and below
}
```

### COPY FEEDBACK SCALING:
- Base size: 48px
- Scale with resolution: `baseSizeScaled = 48 * scaleFactor`
- Colors: Green (#27ae60) for success
- Duration: 2 seconds with fade animation

## 🔄 INTERACTION PATTERNS

### CLICK BEHAVIOR:
1. **Left Click:** Copy command + show detailed tooltip
2. **Right Click:** Show tooltip only (no copy)
3. **Hover:** Preview tooltip briefly
4. **Click Outside:** Close any open tooltips

### KEYBOARD SHORTCUTS:
- **1, 2, 3:** Quick activation (copy specific commands)
- **Ctrl+1,2,3,4,5:** Switch tabs directly
- **Esc:** Close any open modals/tooltips

## 📋 CONTENT STANDARDS

### DESCRIPTION FORMAT:
- **Brief Description:** Max 50 characters
- **Always End With:** "— Read more..."
- **Avoid:** Technical jargon in brief descriptions
- **Include:** Action verbs (Check, Fix, Open, etc.)

### TOOLTIP REQUIREMENTS:
- **Command:** Exact command string
- **What:** Clear explanation without assumptions
- **Why:** Business value and importance
- **Who:** Target user types
- **Why Not:** When to avoid using
- **How:** Step-by-step usage instructions

## 🚨 VIOLATION PREVENTION

### COMMON MISTAKES (NEVER DO):
1. **Inconsistent Colors:** Using random colors for similar elements
2. **Missing Read More:** Any command without "— Read more..." 
3. **Broken Tooltips:** Empty or malformed tooltip content
4. **Poor Grouping:** Related commands scattered across interface
5. **Scale Ignorance:** Fixed sizes that don't scale with resolution

### SYSTEMATIC CHECKS:
```powershell
# Use this pattern for validation
foreach ($commandBox in $allCommandBoxes) {
    # Check tooltip structure
    # Verify "Read more..." ending
    # Validate color consistency
    # Test scaling behavior
}
```

## 🎯 QUALITY STANDARDS

### BEFORE DEPLOYMENT:
- [ ] All command boxes have structured tooltips
- [ ] All descriptions end with "— Read more..."
- [ ] Color scheme matches tab category
- [ ] Scaling works on 1080p, 1440p, and 4K
- [ ] Grouping follows logical categories
- [ ] Keyboard shortcuts functional
- [ ] Click behaviors consistent

### TESTING CHECKLIST:
1. **Visual Test:** Open on different resolutions
2. **Interaction Test:** Click, hover, keyboard shortcuts
3. **Content Test:** All tooltips complete and accurate
4. **Group Test:** Related commands visually grouped
5. **Scale Test:** Copy feedback visible on all screens

## 🔧 IMPLEMENTATION TEMPLATE

### NEW COMMAND ADDITION:
```html
<!-- Step 1: Add to appropriate tab -->
<div class="command-item" 
     data-command="your-command-here" 
     data-tooltip="Command: your-command-here | What this does: [explanation] | Why it matters: [importance] | Who should use it: [users] | Why not use it: [avoid when] | How to use it: [instructions]">
    <div class="command-text">display-text</div>
    <div class="command-desc">Brief description — Read more...</div>
</div>

<!-- Step 2: Add to group if related commands exist -->
<!-- Step 3: Test all interaction patterns -->
<!-- Step 4: Verify scaling on multiple resolutions -->
```

**🎨 BOTTOM LINE: Consistency creates professional user experience. Follow these rules to prevent layout violations and maintain SAIT quality standards.**