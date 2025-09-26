# 2829 Niagara Street - GitHub Pages Deployment Guide

## Quick Deploy Command

```powershell
.\deploy-to-github.ps1 -GitHubUsername "YOUR-USERNAME" -PersonalAccessToken "YOUR-TOKEN"
```

## Step-by-Step Setup

### 1. Get GitHub Personal Access Token
- Go to: https://github.com/settings/tokens
- Click "Generate new token (classic)"
- Name it: "2829 Niagara Street Deployment"
- Select scopes: `repo`, `workflow`
- Copy the token (save it securely!)

### 2. Run Deployment Script
```powershell
# Navigate to project folder
cd "C:\Users\17274\ME\2829-Niagara-Street"

# Run deployment (replace with your actual username and token)
.\deploy-to-github.ps1 -GitHubUsername "your-github-username" -PersonalAccessToken "ghp_xxxxxxxxxxxx"
```

### 3. Enable GitHub Pages
After script runs:
1. Go to the repository URL shown in output
2. Click "Settings" tab
3. Scroll to "Pages" section
4. Source: "Deploy from a branch"
5. Branch: "main"
6. Folder: "/ (root)"
7. Save

### 4. Access Live Site
- **URL**: `https://your-username.github.io/2829-niagara-street/`
- **Wait Time**: 5-10 minutes for first deployment
- **SSL**: May take additional time to activate

## What Gets Deployed

✅ **Files Included:**
- `index.html` - Main multi-page portal
- `2829-dashboard.html` - Alternative dashboard
- `README.md` - Project documentation
- `_config.yml` - GitHub Pages configuration
- `.nojekyll` - Bypass Jekyll processing

✅ **Features Ready:**
- Google Drive video integration (no local files needed)
- All partner contact buttons work
- Mobile responsive design
- Professional gradient theme
- 6-tab navigation system

## Troubleshooting

**Pages not loading?**
- Check GitHub Pages settings
- Wait 10 minutes, then hard refresh
- Check repository is public

**Video not working?**
- Google Drive link is public (anyone with link)
- Should open in new tab when clicked

**Contact buttons not working?**
- Email links should open default email client
- Phone links should work on mobile devices

## Repository Structure

```
2829-niagara-street/
├── index.html          # Main portal (6 tabs)
├── 2829-dashboard.html # Alternative dashboard  
├── README.md           # Project documentation
├── _config.yml         # GitHub Pages config
└── .nojekyll          # Bypass Jekyll
```

## Future Updates

To update the live site:
1. Make changes to local files
2. Run `.\deploy-to-github.ps1` again with same credentials
3. Changes appear in ~5 minutes

---

**Contact**: Tiffany Durilla - durillaprop@gmail.com - 716-421-1210  
**Project**: Revolutionary MMM Development Model  
**Location**: 2829 Niagara Street, Tonawanda, NY