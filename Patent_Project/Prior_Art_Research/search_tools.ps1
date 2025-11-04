# Patent Research Tools
# PowerShell script for automated searches and documentation

param(
    [string]$SearchTerm,
    [string]$OutputFile = "search_results.txt"
)

function Search-GooglePatents {
    param([string]$Query)
    
    Write-Host "Searching Google Patents for: $Query" -ForegroundColor Green
    $EncodedQuery = [System.Web.HttpUtility]::UrlEncode($Query)
    $GooglePatentsURL = "https://patents.google.com/?q=$EncodedQuery"
    
    Write-Output "Google Patents Search URL: $GooglePatentsURL" | Tee-Object -FilePath $OutputFile -Append
    Write-Output "Search Term: $Query" | Tee-Object -FilePath $OutputFile -Append
    Write-Output "Search Date: $(Get-Date)" | Tee-Object -FilePath $OutputFile -Append
    Write-Output "---" | Tee-Object -FilePath $OutputFile -Append
}

function Search-USPTO {
    param([string]$Query)
    
    Write-Host "Searching USPTO for: $Query" -ForegroundColor Green
    $EncodedQuery = [System.Web.HttpUtility]::UrlEncode($Query)
    $USPTOURL = "https://ppubs.uspto.gov/dirsearch-public/searches/searchAdv?query=$EncodedQuery"
    
    Write-Output "USPTO Search URL: $USPTOURL" | Tee-Object -FilePath $OutputFile -Append
    Write-Output "Search Term: $Query" | Tee-Object -FilePath $OutputFile -Append
    Write-Output "Search Date: $(Get-Date)" | Tee-Object -FilePath $OutputFile -Append
    Write-Output "---" | Tee-Object -FilePath $OutputFile -Append
}

function New-PatentAnalysisTemplate {
    param(
        [string]$PatentNumber,
        [string]$Title,
        [string]$OutputPath = ".\patent_analysis_$PatentNumber.md"
    )
    
    $Template = @"
# PATENT ANALYSIS: $PatentNumber

**Title:** $Title
**Patent Number:** $PatentNumber
**Analysis Date:** $(Get-Date -Format "yyyy-MM-dd")

## BASIC INFORMATION
- **Inventor(s):** [To be filled]
- **Assignee:** [To be filled]
- **Filing Date:** [To be filled]
- **Publication Date:** [To be filled]
- **Status:** [Active/Expired/Abandoned]
- **Patent Family:** [Related patents]

## TECHNICAL ANALYSIS

### Abstract Summary
[Paste abstract here]

### Key Claims Analysis
#### Independent Claims
[List and analyze independent claims]

#### Dependent Claims  
[List notable dependent claims]

### Technical Description
[Summarize how the invention works]

## RELEVANCE TO YOUR INVENTION

### Similarities
- [List similar features/concepts]

### Differences
- [List key differences that distinguish your invention]

### Infringement Risk Analysis
- **Risk Level:** [High/Medium/Low]
- **Specific Concerns:** [Detail any potential infringement issues]
- **Mitigation Strategies:** [How to design around if needed]

## STRATEGIC IMPLICATIONS

### Impact on Patent Strategy
[How this patent affects your filing strategy]

### Design Around Opportunities
[Ways to avoid this patent while achieving similar results]

### Licensing Considerations
[Whether licensing might be necessary or beneficial]

## ACTION ITEMS
- [ ] [Specific actions needed]
- [ ] [Follow-up research required]

---
**CONFIDENTIAL - PATENT ANALYSIS**
"@

    $Template | Out-File -FilePath $OutputPath -Encoding UTF8
    Write-Host "Patent analysis template created: $OutputPath" -ForegroundColor Yellow
}

function Start-PriorArtSearch {
    param([string[]]$SearchTerms)
    
    Write-Host "Starting Prior Art Search" -ForegroundColor Cyan
    Write-Host "=========================" -ForegroundColor Cyan
    
    # Clear previous results
    "" | Out-File -FilePath $OutputFile
    Write-Output "PRIOR ART SEARCH RESULTS" | Tee-Object -FilePath $OutputFile
    Write-Output "Generated: $(Get-Date)" | Tee-Object -FilePath $OutputFile
    Write-Output "=========================" | Tee-Object -FilePath $OutputFile
    Write-Output "" | Tee-Object -FilePath $OutputFile
    
    foreach ($Term in $SearchTerms) {
        Write-Output "SEARCH TERM: $Term" | Tee-Object -FilePath $OutputFile -Append
        Search-GooglePatents -Query $Term
        Search-USPTO -Query $Term
        Write-Output "" | Tee-Object -FilePath $OutputFile -Append
    }
    
    Write-Host "Search URLs generated. Results saved to: $OutputFile" -ForegroundColor Green
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "1. Visit the URLs to conduct manual searches" -ForegroundColor White
    Write-Host "2. Use New-PatentAnalysisTemplate for each relevant patent found" -ForegroundColor White
    Write-Host "3. Document findings in the prior art research template" -ForegroundColor White
}

# Example usage functions
function Show-Examples {
    Write-Host "`nEXAMPLE USAGE:" -ForegroundColor Cyan
    Write-Host "===============" -ForegroundColor Cyan
    Write-Host "`n1. Basic search:" -ForegroundColor Yellow
    Write-Host '   Start-PriorArtSearch -SearchTerms @("smart lock", "electronic door lock", "wireless door control")' -ForegroundColor White
    
    Write-Host "`n2. Create patent analysis:" -ForegroundColor Yellow
    Write-Host '   New-PatentAnalysisTemplate -PatentNumber "US1234567" -Title "Smart Lock System"' -ForegroundColor White
    
    Write-Host "`n3. Advanced search terms:" -ForegroundColor Yellow
    Write-Host '   $terms = @("bluetooth AND door", "smartphone AND lock", "keyless AND entry")' -ForegroundColor White
    Write-Host '   Start-PriorArtSearch -SearchTerms $terms' -ForegroundColor White
}

# Main execution
if ($SearchTerm) {
    Start-PriorArtSearch -SearchTerms @($SearchTerm)
} else {
    Show-Examples
}