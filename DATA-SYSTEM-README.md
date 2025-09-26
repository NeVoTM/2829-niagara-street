# 📊 Project Data Management System

## Overview
This system provides centralized data management for the 2829 Niagara Street project, ensuring consistency across all project files and preventing data conflicts.

## Files
- `project-data.json` - Master data file containing all project values
- `update-project-data.js` - Script to validate and sync data to HTML
- `mobile-design.html` - Main project file (updated automatically)

## How to Use

### 1. Editing Data
Edit the `project-data.json` file to make changes to:
- Financial figures (revenue, costs, profits)
- Unit counts and distributions
- Contact information
- Project specifications
- Market analysis data

### 2. Updating HTML
After making changes to project-data.json, run:
```bash
node update-project-data.js
```

### 3. Validation
The script automatically validates:
- Revenue components sum to total revenue
- Cost components sum to total development cost
- Data consistency across all sections

## Data Structure

### Financial Data
```json
"financial": {
  "total_revenue": "$38M",
  "gross_profit": "$12M",
  "development_costs": "$25.7M",
  "profit_margin": "31%",
  "roi": "46%"
}
```

### Unit Distribution
```json
"units": {
  "total": 150,
  "residential": {"count": 65, "revenue": "$15.8M"},
  "str_hotel_rooms": {"count": 72, "revenue": "$15.1M"},
  "retail": {"count": 13, "revenue": "$6.5M"}
}
```

### Contact Information
```json
"contact": {
  "name": "Tiffany Durilla",
  "title": "Development Partner",
  "email": "durillaprop@gmail.com",
  "phone": "716-421-1210"
}
```

## Marketing Rules Applied
- **Revenue/Sales**: Always rounded UP for marketing appeal
- **Costs**: Kept precise for accuracy
- **Profits**: Rounded UP to nearest million

## Benefits
1. **Consistency**: Single source of truth for all data
2. **Validation**: Automatic checks prevent math errors
3. **Efficiency**: Update once, apply everywhere
4. **Maintenance**: Easy to track and modify project data
5. **Quality Control**: Built-in integrity checking

## Integration with QC Process
This data system is integrated into the Quality Control Checklist:
- Always check data integrity before deployment
- Run update script after any data changes
- Validate calculations match business rules
- Ensure marketing rounding is applied consistently

## Error Handling
The script will report:
- Data validation failures
- File access errors  
- Mathematical inconsistencies
- Missing required fields

## Future Enhancements
- Additional file format support (Excel, CSV)
- Automated deployment integration
- Historical data tracking
- Multi-project support