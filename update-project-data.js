#!/usr/bin/env node

/**
 * Project Data Integrity Update Script
 * 
 * This script reads project-data.json and updates mobile-design.html
 * to ensure all values are consistent across the project.
 * 
 * Usage: node update-project-data.js
 */

const fs = require('fs');
const path = require('path');

// Read the project data
function loadProjectData() {
    try {
        const dataPath = path.join(__dirname, 'project-data.json');
        const rawData = fs.readFileSync(dataPath, 'utf8');
        return JSON.parse(rawData);
    } catch (error) {
        console.error('Error reading project-data.json:', error.message);
        process.exit(1);
    }
}

// Read the HTML file
function loadHtmlFile() {
    try {
        const htmlPath = path.join(__dirname, 'mobile-design.html');
        return fs.readFileSync(htmlPath, 'utf8');
    } catch (error) {
        console.error('Error reading mobile-design.html:', error.message);
        process.exit(1);
    }
}

// Save the updated HTML file
function saveHtmlFile(content) {
    try {
        const htmlPath = path.join(__dirname, 'mobile-design.html');
        fs.writeFileSync(htmlPath, content, 'utf8');
        console.log('✅ mobile-design.html updated successfully');
    } catch (error) {
        console.error('Error writing mobile-design.html:', error.message);
        process.exit(1);
    }
}

// Update HTML content with data from JSON
function updateHtmlContent(html, data) {
    let updatedHtml = html;
    
    // Update financial values
    updatedHtml = updatedHtml.replace(/\$\d+M\+? projected revenue/g, `${data.financial.total_revenue}+ projected revenue`);
    updatedHtml = updatedHtml.replace(/Revenue Breakdown - \$\d+M/g, `Revenue Breakdown - ${data.financial.total_revenue}`);
    updatedHtml = updatedHtml.replace(/\$\d+\.?\d*M.*Gross Profit/g, `${data.financial.gross_profit}</span>\r\n                    <span class=\"stat-label\">Gross Profit`);
    
    // Update unit counts and labels
    updatedHtml = updatedHtml.replace(/STR Hotels?( Rooms?)?<br>/g, 'STR Hotel Rooms<br>');
    
    // Update contact information
    updatedHtml = updatedHtml.replace(/durillaprop@gmail\.com/g, data.contact.email);
    updatedHtml = updatedHtml.replace(/716-421-1210/g, data.contact.phone);
    updatedHtml = updatedHtml.replace(/Tiffany Durilla/g, data.contact.name);
    
    return updatedHtml;
}

// Validate data consistency
function validateDataConsistency(data) {
    const issues = [];
    
    // Check if revenue components add up
    const residential = parseFloat(data.units.residential.revenue.replace('$', '').replace('M', ''));
    const str = parseFloat(data.units.str_hotel_rooms.revenue.replace('$', '').replace('M', ''));
    const retail = parseFloat(data.units.retail.revenue.replace('$', '').replace('M', ''));
    const total = parseFloat(data.financial.total_revenue.replace('$', '').replace('M', ''));
    
    const calculatedTotal = residential + str + retail;
    if (Math.abs(calculatedTotal - total) > 0.1) {
        issues.push(`Revenue mismatch: Components sum to ${calculatedTotal}M but total shows ${total}M`);
    }
    
    // Check cost components
    const hardCost = parseFloat(data.costs.hard_construction.amount.replace('$', '').replace('M', ''));
    const softCost = parseFloat(data.costs.soft_costs.amount.replace('$', '').replace('M', ''));
    const totalCost = parseFloat(data.financial.development_costs.replace('$', '').replace('M', ''));
    
    const calculatedCosts = hardCost + softCost;
    if (Math.abs(calculatedCosts - totalCost) > 0.1) {
        issues.push(`Cost mismatch: Components sum to ${calculatedCosts}M but total shows ${totalCost}M`);
    }
    
    return issues;
}

// Main execution
function main() {
    console.log('🚀 Starting Project Data Integrity Update...');
    
    const projectData = loadProjectData();
    console.log('📊 Project data loaded successfully');
    
    const issues = validateDataConsistency(projectData);
    if (issues.length > 0) {
        console.log('⚠️  Data consistency issues found:');
        issues.forEach(issue => console.log(`   - ${issue}`));
    } else {
        console.log('✅ Data consistency validation passed');
    }
    
    const htmlContent = loadHtmlFile();
    console.log('📄 HTML file loaded successfully');
    
    const updatedHtml = updateHtmlContent(htmlContent, projectData);
    
    if (updatedHtml !== htmlContent) {
        saveHtmlFile(updatedHtml);
        console.log('🎉 Update completed successfully');
    } else {
        console.log('📝 No changes needed - data is already consistent');
    }
}

// Run the script
main();