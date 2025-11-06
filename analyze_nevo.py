import csv
import openpyxl
from openpyxl.styles import Font, PatternFill, Alignment, Border, Side
from datetime import datetime

# Read CSV data
csv_file = r'C:\Users\17274\Downloads\_NEVO TOWER 50 UNITS - Measurements 50 (1).csv'

print('='*100)
print('NEVO TOWER - CURRENT DESIGN (7 FLOORS + ROOFTOP)')
print('='*100)
print()

# Parse the data
floors_data = []
with open(csv_file, 'r') as f:
    reader = csv.DictReader(f)
    for row in reader:
        floors_data.append(row)

# Display summary
for floor in floors_data:
    print(f"Floor {floor['Floor #']:10} | {floor['USE']:45} | Units: {floor['Units per Floor']:3} | GSF: {floor['Floor Plate GSF']:10}")

print()
print('='*100)
print('SUMMARY FROM FILE:')
total_row = floors_data[-1]
print(f"Total GSF: {total_row['Floor Plate GSF']}")
print(f"Total NSF: {total_row['Floor Plate NSF']}")
print(f"Hard Cost: {total_row['Total Floor Cost']}")
print(f"Soft Cost: {total_row['Soft Cost']}")
print(f"Total Revenue: {total_row['Total Floor Sale']}")
print(f"Gross Profit: {total_row['Gross Profit']}")
print(f"GP%: {total_row['GP %']}")
print('='*100)

# Count residential units
res_units = 0
for floor in floors_data[:-1]:  # Exclude total row
    if 'Residential' in floor['USE']:
        units = floor['Units per Floor']
        if units.isdigit():
            res_units += int(units)

print(f"\nTotal Residential Units: {res_units}")
print(f"Parking Spaces: 102 (Floors 2-3)")
print(f"Chabad/Mikvah: 13,125 GSF (Floor 1)")

