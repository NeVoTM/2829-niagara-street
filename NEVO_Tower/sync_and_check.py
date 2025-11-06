"""
ONE COMMAND TO DO EVERYTHING
Run this after editing Excel file
"""

import subprocess
import json
import os

print("\n" + "="*60)
print("🔄 SYNCING EXCEL → PYTHON")
print("="*60 + "\n")

# Run the sync
result = subprocess.run(['python', 'scripts/sync_from_excel.py'], 
                       capture_output=False, text=True)

if result.returncode != 0:
    print("\n❌ SYNC FAILED!")
    exit(1)

print("\n" + "="*60)
print("📊 YOUR UPDATED NUMBERS")
print("="*60)

# Show the results
try:
    with open('data/pro_forma.json', 'r') as f:
        data = json.load(f)
    
    print(f"\n💰 TOTAL COST:     ${data['costs']['total']:,.0f}")
    print(f"💵 TOTAL REVENUE:  ${data['revenue']['total']:,.0f}")
    print(f"📈 PROFIT:         ${data['profitability']['gross_profit']:,.0f}")
    print(f"📊 MARGIN:         {data['profitability']['profit_margin']:.1%}")
    
    if data['profitability']['gross_profit'] > 0:
        print("\n✅ PROJECT IS PROFITABLE!")
    else:
        print("\n⚠️  PROJECT IS UNDERWATER")
    
    print("\n" + "="*60)
    print("✅ SYNC COMPLETE - JSON FILES UPDATED")
    print("="*60)
    
    # Open the summary report
    print("\n📄 Opening detailed report...")
    os.system('code outputs\\UPDATED_SUMMARY.md')
    
except Exception as e:
    print(f"\n❌ Error reading results: {e}")

print("\n✨ Done! Check the opened file for full details.\n")
