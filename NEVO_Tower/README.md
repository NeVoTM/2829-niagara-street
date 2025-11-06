# NEVO Tower - Budget & RFQ Development
## 1580 79th Street Causeway, North Bay Village, FL 33141

**Project Type:** Mid-Rise Mixed-Use Residential  
**Status:** Budget Development Phase  
**Date:** November 5, 2025

---

## PROJECT SUMMARY

**Building Program:**
- **7 floors + rooftop** amenity level
- **108,675 GSF** / 86,940 NSF
- **50 residential units** (42 hospitality 2BR + 8 condo 3BR)
- **102 parking spaces** (EV-ready structured parking)
- **Chabad House & Mikvah** (13,125 GSF) - sold at cost
- **Rooftop amenities:** Pool, gym, common areas

**Construction Method:**
- Pour-in-place post-tensioned concrete
- Mid-rise classification (under 75 feet)
- HVHZ compliant (Miami-Dade)

**Budget Targets:**
- Land: $10,000,000 (fixed)
- Hard Costs: TBD (baseline $32.6M)
- Soft Costs: $4,000,000 (target)
- Sales Price: $1,000/SF average

---

## COMPLETED DELIVERABLES

### ✅ 1. Project Structure & Configuration
- **Folder structure:** docs, data, scripts, outputs, rfq, specs, scenarios
- **config.yaml:** Central configuration with all parameters
- **Location:** `config.yaml`

### ✅ 2. Data Parsing & Validation
- **Script:** `scripts/parse_nevo_csv.py`
- **Input:** CSV from Downloads folder
- **Outputs:**
  - `data/nevo_parsed.json` - Structured project data
  - `data/validation_report.md` - Validation summary

**Validation Results:**
- ✓ 8 floors total (7 + rooftop)
- ✓ 108,675 GSF confirmed
- ✓ 50 residential units confirmed
- ✓ 102 parking spaces confirmed
- ✓ Financial baseline: $32.6M hard / $4.89M soft / $61.7M revenue

### ✅ 3. Basis of Estimate Documentation
- **File:** `docs/basis_of_estimate.md`
- **Contents:**
  - Regional cost factors (Miami-Dade)
  - PIP concrete system specifications
  - HVHZ envelope requirements
  - MEP system assumptions
  - Parking & EV infrastructure
  - General conditions & contingencies
  - Soft cost targets breakdown

### ✅ 4. Detailed Hard Cost Model
- **Script:** `scripts/build_hard_costs.py`
- **Output:** `data/hard_costs_detail.json`
- **Method:** CSI MasterFormat divisions

**Hard Cost Summary:**
- Construction subtotal: $28,777,140
- General Conditions (9%): $2,589,943
- Overhead & Profit (10%): $3,136,708
- Contingencies (16%): $5,520,607
- **TOTAL HARD COSTS: $40,024,397 ($368.29/GSF)**

**Variance to Baseline:**
- CSV Baseline: $32,602,500 @ $300/GSF
- This Estimate: $40,024,397 @ $368.29/GSF
- Variance: +$7,421,897 (+22.8%)

**Variance Drivers:**
- Detailed CSI breakdown vs simplified baseline
- 16% total contingencies (design + construction + owner)
- GC overhead & profit explicitly included
- HVHZ premium for envelope
- EV charging infrastructure
- Higher finish allowances

### ✅ 5. Soft Cost Model
- **Script:** `scripts/build_soft_costs.py`
- **Output:** `data/soft_costs_detail.json`

**Soft Cost Summary:**
- A&E (4.5% of hard): $1,801,098
- Permits & Fees: $775,000
- Legal & Insurance: $440,000
- Marketing (2.5% of revenue): $1,236,288
- Financing: $2,706,000
- Testing & Misc: $375,000
- Developer Fee: $200,000
- **TOTAL SOFT COSTS: $7,528,703**

### ✅ 6. Financial Pro Forma
- **Script:** `scripts/build_pro_forma.py`
- **Output:** `data/pro_forma.json`
- **Report:** `EXECUTIVE_SUMMARY.md`

**Financial Results:**
- Total Development Cost: $57,553,100
  - Land: $10,000,000
  - Hard Costs: $40,024,397
  - Soft Costs: $7,528,703
- Total Revenue: $49,451,500 (~$1,000/SF avg)
- **Gross Profit: -$8,101,600**
- **Profit Margin: -16.4%**
- **Status: ⚠️ Project currently underwater**

**Feasibility Paths:**
1. Increase revenue to $1,169/SF (+17%)
2. Reduce costs to $43.3M (-25%)
3. Hybrid: +15% revenue + -12% costs = $6.1M profit

---

## IN-PROGRESS DELIVERABLES

### 🔄 5. Soft Cost Model (Target: $4M)
**Status:** To be built  
**Script:** `scripts/build_soft_costs.py`  
**Components:**
- Architecture & Engineering fees
- Permits & impact fees
- Legal, accounting, insurance
- Marketing & sales commissions
- Financing costs
- Developer fee

### 🔄 6. Financial Pro Forma
**Status:** To be built  
**Script:** `scripts/build_pro_forma.py`  
**Outputs:**
- Revenue model ($1,000/SF target)
- Unit-by-unit pricing
- Chabad/Mikvah at-cost treatment
- Profit & ROI analysis
- Sensitivity scenarios

### ✅ 7. Interactive Excel Budget System
**Status:** ✅ COMPLETE  
**Generator Script:** `scripts/make_interactive_workbook.py`  
**Sync Script:** `scripts/sync_from_excel.py`  
**File:** `outputs/NEVO_Interactive_Budget.xlsx`  
**Guide:** `docs/EXCEL_WORKFLOW_GUIDE.md`

**Sheets:**
- **Summary:** Executive dashboard with real-time calculations
- **Assumptions:** All editable parameters (land, rates, percentages)
- **Hard Costs:** 23 CSI divisions with editable rates ($/GSF)
- **Soft Costs:** 11 line items (some editable, some formula-driven)
- **Revenue:** Unit pricing by floor/type (editable $/SF)

**Features:**
- ✅ All formulas auto-calculate in real-time
- ✅ Yellow cells = editable inputs
- ✅ Two-way sync: Excel → Python → Reports
- ✅ Google Sheets compatible
- ✅ Automatic report generation

**Quick Start:**
```powershell
# 1. Open Excel file and edit yellow cells
start outputs\NEVO_Interactive_Budget.xlsx

# 2. Save file (Ctrl+S)

# 3. Sync changes back to Python
python scripts\sync_from_excel.py

# 4. Review generated report
code outputs\UPDATED_SUMMARY.md
```

See `docs/EXCEL_WORKFLOW_GUIDE.md` for complete instructions.

### 🔄 8. RFQ Document
**Status:** To be built  
**File:** `rfq/NEVO_Tower_RFQ.md`  
**Contents:**
- Project overview & specifications
- Scope of work by trade
- PIP concrete requirements
- Code compliance requirements
- Schedule & milestones
- Insurance & bonding
- Bid instructions
- Evaluation criteria

### 🔄 9. Construction Specifications
**Status:** To be built  
**File:** `specs/Concrete_PIP_Specs.md`  
**Contents:**
- Mix designs (5,000 psi typical)
- PT system specifications
- Formwork requirements
- Placement & curing procedures
- QC/QA protocols
- HVHZ envelope specs

### 🔄 10. Alternative Scenario (11-12 Floors)
**Status:** To be built  
**Config:** `scenarios/shorter_tower.yaml`  
**Parameters:**
- 12 floors with 9,000 SF average plates
- Synagogue/Mikvah 7,000 SF
- Adjusted unit count & parking
- Maintain $1,000/SF sales target

---

## HOW TO RUN

### Prerequisites
```powershell
# Install Python packages
pip install openpyxl xlsxwriter

# Navigate to project
cd C:\Users\17274\ME\2829-Niagara-Street\NEVO_Tower
```

### Execute Scripts in Order
```powershell
# 1. Parse CSV data
python scripts\parse_nevo_csv.py

# 2. Build hard cost model
python scripts\build_hard_costs.py

# 3. Build soft cost model (when complete)
python scripts\build_soft_costs.py

# 4. Build pro forma (when complete)
python scripts\build_pro_forma.py

# 5. Generate Excel workbook (when complete)
python scripts\make_workbook.py
```

---

## KEY FINDINGS & DECISIONS

### Hard Cost Analysis

**Optimizations to Consider:**
1. **Value Engineering PT System:** Can reduce concrete thickness further
2. **Parking Optimization:** Surface vs structured trade-off
3. **Finish Level:** Hospitality vs condo finish differential
4. **HVHZ Envelope:** Competitive bidding for glazing
5. **MEP Systems:** Mini-split vs central plant trade-off

**Risk Items:**
- Material escalation (3% annual assumed)
- Labor availability in Miami market
- HVHZ testing & approval timeline
- Site-specific conditions (geot unknown)

### Next Steps to Meet Budget Targets

**To achieve closer to $32.6M baseline:**
1. Reduce contingencies from 16% to 10-12% (design phase)
2. Value engineer finishes (target $35-45/SF vs $42-85/SF)
3. Competitive GC/sub bidding (reduce O&P from 10% to 7-8%)
4. Material buy-outs early (lock pricing)
5. Phased construction approach

**Soft Cost Target ($4M):**
- Design fees: ~$1.5M (4% of hard costs)
- Permits & fees: ~$650K
- Marketing & sales: ~$1.85M (already in baseline)
- Remainder: Legal, insurance, financing

---

## PROJECT CONTACTS

**Developer:** NEVO Development Team  
**Site Address:** 1580 79th Street Causeway, North Bay Village, FL 33141  
**Jurisdiction:** Miami-Dade County Building Department  
**Code:** Florida Building Code 8th Edition (2023)

---

## DOCUMENT CONTROL

**Version:** 1.0  
**Last Updated:** November 5, 2025  
**Prepared By:** NEVO Budget Team  
**Review Status:** Draft - Budget Authorization Phase

---

## APPENDICES

### A. Source Data
- Original CSV: `C:\Users\17274\Downloads\_NEVO TOWER 50 UNITS - Measurements 50 (1).csv`
- Parsed JSON: `data/nevo_parsed.json`
- Validation Report: `data/validation_report.md`

### B. Cost Models
- Hard Costs Detail: `data/hard_costs_detail.json`
- Soft Costs Detail: (pending)
- Pro Forma: (pending)

### C. Reference Documents
- Basis of Estimate: `docs/basis_of_estimate.md`
- Variance Analysis: `docs/variance_analysis.md` (pending)
- Construction Specs: `specs/` (pending)

### D. Deliverables
- Excel Workbook: `outputs/NEVO_Budget_RFQ.xlsx` (pending)
- RFQ Document: `rfq/NEVO_Tower_RFQ.md` (pending)

---

**END OF README**
