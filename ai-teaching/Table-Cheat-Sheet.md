# Table Alignment Cheat Sheet
*For when you barely remember your kids' names* 😄

## 🎯 Simple Rules

### Problem: Things don't line up
**Solution**: More tables!

### Problem: Labels and values messy  
**Solution**: Nested table (table inside table)

## 📝 Magic Words for AI

**"Create nested table for alignment"** 
- Means: Put a small table inside a table cell
- Result: Perfect label/value alignment

**"Use separate tables for each section"**
- Means: Don't try to fit everything in one table
- Result: Each section aligns independently

**"Remove hardcoded form values"**
- Means: Don't put value="2025-01-15" in date fields
- Result: Prints what user selected, not hardcoded date

## 🎮 Copy/Paste Solutions

### Nested Table for Invoice Details:
```html
<table>
  <tr>
    <td>
      <table>
        <tr>
          <td style="text-align: right;">Invoice #:</td>
          <td style="text-align: left; padding-left: 8px;">INV-001</td>
        </tr>
        <tr>
          <td style="text-align: right;">Date:</td>
          <td style="text-align: left; padding-left: 8px;">Today's Date</td>
        </tr>
      </table>
    </td>
  </tr>
</table>
```

**That's it!** Table inside table = perfect alignment 🎯