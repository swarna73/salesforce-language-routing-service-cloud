# 🚀 IT Access Management - Setup Instructions

## Prerequisites

1. **Node.js** (Download from [nodejs.org](https://nodejs.org/))
   - Download the LTS version (18.x or higher)
   - Run the installer with default settings
   - Verify installation: Open Command Prompt and type `node --version`

## Step 1: Create Project Folder

1. Create a new folder on your laptop: `C:\IT-Access-Management`
2. Copy your `Auth.xlsx` file into this folder

## Step 2: Create Application Files

Create the following files in your project folder:

### 📄 package.json
```json
{
  "name": "it-access-management",
  "version": "1.0.0",
  "description": "GoodHabitz IT Access Management System",
  "main": "app.js",
  "scripts": {
    "start": "node app.js",
    "dev": "nodemon app.js"
  },
  "dependencies": {
    "express": "^4.18.2",
    "xlsx": "^0.18.5"
  },
  "devDependencies": {
    "nodemon": "^3.0.1"
  },
  "keywords": ["access-management", "IT", "security", "roles"],
  "author": "IT Department",
  "license": "MIT"
}
```

### 📄 app.js
(Copy the complete server code from the Server Code artifact)

### 📁 public/index.html
1. Create a `public` folder inside your project folder
2. Create `index.html` inside the `public` folder
3. Copy the complete frontend code from the Frontend artifact

## Step 3: Configure Authorized Editors

Edit `app.js` and update the `AUTHORIZED_EDITORS` array with your 10 Windows usernames:

```javascript
const AUTHORIZED_EDITORS = [
    'john.smith',        // Replace with actual Windows usernames
    'jane.doe',          // (use lowercase)
    'it.manager',
    'admin.user',
    'your.username',
    'editor1',
    'editor2',
    'editor3',
    'editor4',
    'editor5'
];
```

**To find Windows usernames:**
- Open Command Prompt
- Type: `echo %USERNAME%`
- Use the result (in lowercase) in the array

## Step 4: Install Dependencies

1. Open Command Prompt as Administrator
2. Navigate to your project folder:
   ```cmd
   cd C:\IT-Access-Management
   ```
3. Install required packages:
   ```cmd
   npm install
   ```

## Step 5: Import Your Excel Data (First Time Only)

1. Edit `app.js` and uncomment this line (around line 315):
   ```javascript
   await importFromExcel();  // Remove the // at the beginning
   ```
2. Save the file
3. Run the application once:
   ```cmd
   npm start
   ```
4. Wait for the import to complete (you'll see console messages)
5. Stop the application (Ctrl+C)
6. **Important:** Comment out the import line again:
   ```javascript
   // await importFromExcel();  // Add // back
   ```

## Step 6: Start the Application

1. Run the application:
   ```cmd
   npm start
   ```
2. You should see output like:
   ```
   🚀 IT Access Management Started
   Local access: http://localhost:3000
   Network access: http://192.168.1.100:3000
   ```

## Step 7: Configure Windows Firewall

To allow network access from other computers:

1. Open Windows Firewall with Advanced Security
2. Click "Inbound Rules" → "New Rule"
3. Select "Port" → Next
4. Select "TCP" and enter port "3000" → Next
5. Select "Allow the connection" → Next
6. Check all profiles (Domain, Private, Public) → Next
7. Name: "IT Access Management" → Finish

## Step 8: Auto-Start (Optional)

To start the application automatically when you boot your laptop:

1. Create a batch file `start-access-management.bat`:
   ```batch
   @echo off
   cd C:\IT-Access-Management
   npm start
   ```
2. Copy this file to: `C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup`

## 🌐 Access Information

### For You (Laptop Owner):
- **Local**: http://localhost:3000
- **From your laptop**: Use the localhost URL

### For Your Team:
- **Network**: http://[YOUR-LAPTOP-IP]:3000
- Replace `[YOUR-LAPTOP-IP]` with your actual IP address shown in the console

### Finding Your IP Address:
1. Open Command Prompt
2. Type: `ipconfig`
3. Look for "IPv4 Address" under your network adapter
4. Share this IP with your team: `http://192.168.1.XXX:3000`

## 🔧 Troubleshooting

### Problem: "Port 3000 already in use"
**Solution:** Change the port in `app.js`:
```javascript
const PORT = 3001; // Change from 3000 to 3001
```

### Problem: "Cannot access from other computers"
**Solutions:**
1. Check Windows Firewall settings
2. Ensure both computers are on the same network
3. Try disabling Windows Firewall temporarily to test

### Problem: "Username not detected correctly"
**Solution:** Edit the `getWindowsUsername` function in `app.js`:
```javascript
function getWindowsUsername(req) {
    // Force return your username for testing
    return 'your.username'; // Replace with actual username
}
```

### Problem: "Excel import failed"
**Solutions:**
1. Ensure `Auth.xlsx` is in the project folder
2. Close Excel if the file is open
3. Check console for specific error messages

## 🔄 Regular Maintenance

### Updating Data:
1. Replace `Auth.xlsx` with updated version
2. Delete `access-data.json`
3. Uncomment import line in `app.js`
4. Restart application
5. Comment import line again

### Backup:
- Backup `access-data.json` regularly
- This file contains all your access rights data

### Updates:
- The application saves all changes to `access-data.json`
- Export Excel regularly for backup

## 📞 Support

If you encounter issues:
1. Check the console output for error messages
2. Verify all file paths are correct
3. Ensure Node.js is properly installed
4. Check Windows Firewall settings

## ✅ Quick Test

1. Open browser: http://localhost:3000
2. Verify your username appears correctly
3. Check if you have "Editor" or "Read Only" access
4. Test filtering and searching applications
5. If you're an editor, try adding a test application

Your IT Access Management system is now ready! 🎉