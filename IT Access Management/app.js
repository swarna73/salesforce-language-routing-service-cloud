const express = require('express');
const fs = require('fs').promises;
const path = require('path');
const os = require('os');
const XLSX = require('xlsx');

const app = express();
const PORT = 3000;

// Middleware
app.use(express.json());
app.use(express.static('public'));
app.use(express.urlencoded({ extended: true }));

// Configuration - Edit these usernames to match your 10 editors
const AUTHORIZED_EDITORS = [
    'administrator',
    'admin', 
    'it.manager',
    'system.admin',
    'john.doe',
    'jane.smith',
    // Add your 10 Windows usernames here (lowercase)
    'swarnalathaswaminathan',
    'user2', 
    'user3',
    'user4'
];

// Get Windows username from request
function getWindowsUsername(req) {
    // Try different methods to get Windows username
    const username = req.headers['x-user'] || 
                    req.headers['remote-user'] || 
                    process.env.USERNAME || 
                    process.env.USER || 
                    os.userInfo().username;
    
    return username ? username.toLowerCase() : null;
}

// Check if user can edit
function canEdit(username) {
    return AUTHORIZED_EDITORS.includes(username?.toLowerCase());
}

// Data storage
let accessData = {
    metadata: {
        title: "GoodHabitz IT Access Management",
        lastUpdated: new Date().toISOString(),
        totalApplications: 0,
        totalRoles: 0
    },
    accessLevels: {
        'A': { label: 'Administrator', color: '#ff8d86', description: 'Full administrative access' },
        'E': { label: 'Standard Access', color: '#fbd664', description: 'Regular user access' },
        'N': { label: 'No Access', color: '#a8d08f', description: 'No access granted' },
        'O': { label: 'Limited Access', color: '#9dc3e6', description: 'Limited/country-specific access' }
    },
    departments: [],
    jobTitles: [],
    applications: []
};

// Load data from JSON file
async function loadData() {
    try {
        const data = await fs.readFile('access-data.json', 'utf8');
        accessData = JSON.parse(data);
        console.log(`Loaded ${accessData.applications.length} applications and ${accessData.jobTitles.length} job titles`);
    } catch (error) {
        console.log('No existing data file found, using default structure');
        // If no file exists, you can populate with sample data or import from Excel
    }
}

// Save data to JSON file
async function saveData() {
    try {
        accessData.metadata.lastUpdated = new Date().toISOString();
        await fs.writeFile('access-data.json', JSON.stringify(accessData, null, 2));
        console.log('Data saved successfully');
    } catch (error) {
        console.error('Error saving data:', error);
    }
}

// Import data from Excel file (run once to import your existing data)
/*
async function importFromExcel() {
    try {
        const workbook = XLSX.readFile('Auth.xlsx');
        
        // Parse Primary Applications
        const primarySheet = workbook.Sheets['2. Primary Applications'];
        const primaryData = XLSX.utils.sheet_to_json(primarySheet, { header: 1, defval: '' });
        
        // Extract job titles (starting from column 14)
        const departmentRow = primaryData[4];
        const jobTitleRow = primaryData[6];
        const jobTitles = [];
        
        for (let i = 14; i < jobTitleRow.length; i++) {
            const title = jobTitleRow[i];
            const department = departmentRow[i] || '';
            
            if (title && title.trim().length > 0) {
                jobTitles.push({
                    title: title.trim(),
                    department: department.trim()
                });
            }
        }
        
        // Extract applications
        const applications = [];
        
        // Primary applications
        for (let i = 7; i < primaryData.length; i++) {
            const row = primaryData[i];
            const appName = row[0];
            
            if (appName && typeof appName === 'string' && appName.trim().length > 0) {
                const app = {
                    id: applications.length + 1,
                    name: appName.trim(),
                    owner: row[1] || '',
                    lastVerified: row[2] || '',
                    category: 'Primary Applications',
                    access: {}
                };
                
                // Map access levels
                jobTitles.forEach((jobTitle, idx) => {
                    const accessLevel = row[14 + idx];
                    if (accessLevel) {
                        app.access[jobTitle.title] = accessLevel.toString().trim();
                    }
                });
                
                applications.push(app);
            }
        }
        
        // Supporting applications
        const supportingSheet = workbook.Sheets['3. Supporting Applications'];
        const supportingData = XLSX.utils.sheet_to_json(supportingSheet, { header: 1, defval: '' });
        
        for (let i = 6; i < supportingData.length; i++) {
            const row = supportingData[i];
            const appName = row[0];
            
            if (appName && typeof appName === 'string' && appName.trim().length > 0 && 
                !appName.includes('Supporting applications')) {
                
                const app = {
                    id: applications.length + 1,
                    name: appName.trim(),
                    adminType: row[1] || '',
                    creditCard: row[2] || '',
                    owner: row[3] || '',
                    lastVerified: row[4] || '',
                    category: 'Supporting Applications',
                    access: {}
                };
                
                // Map access levels
                jobTitles.forEach((jobTitle, idx) => {
                    const accessLevel = row[14 + idx];
                    if (accessLevel) {
                        app.access[jobTitle.title] = accessLevel.toString().trim();
                    }
                });
                
                applications.push(app);
            }
        }
        
        // Update global data
        accessData.jobTitles = jobTitles;
        accessData.applications = applications;
        accessData.departments = [...new Set(jobTitles.map(jt => jt.department).filter(d => d.length > 0))];
        accessData.metadata.totalApplications = applications.length;
        accessData.metadata.totalRoles = jobTitles.length;
        
        await saveData();
        console.log(`Imported ${applications.length} applications and ${jobTitles.length} job titles from Excel`);
        
    } catch (error) {
        console.error('Error importing from Excel:', error);
    }
}*/

// API Routes

// Get current user info
app.get('/api/user', (req, res) => {
    const username = getWindowsUsername(req);
    res.json({
        username: username,
        canEdit: canEdit(username),
        timestamp: new Date().toISOString()
    });
});

// Get all data
app.get('/api/data', (req, res) => {
    res.json(accessData);
});

// Get applications with optional filtering
app.get('/api/applications', (req, res) => {
    let { category, search, role } = req.query;
    let filteredApps = [...accessData.applications];
    
    if (category && category !== 'all') {
        filteredApps = filteredApps.filter(app => app.category === category);
    }
    
    if (search) {
        const searchLower = search.toLowerCase();
        filteredApps = filteredApps.filter(app => 
            app.name.toLowerCase().includes(searchLower) ||
            app.owner.toLowerCase().includes(searchLower)
        );
    }
    
    if (role) {
        filteredApps = filteredApps.filter(app => 
            app.access[role] && app.access[role] !== 'N'
        );
    }
    
    res.json(filteredApps);
});

// Get access for specific role
app.get('/api/role/:roleName', (req, res) => {
    const roleName = decodeURIComponent(req.params.roleName);
    const roleAccess = accessData.applications.map(app => ({
        application: app.name,
        category: app.category,
        access: app.access[roleName] || 'N',
        owner: app.owner,
        lastVerified: app.lastVerified
    })).filter(item => item.access !== 'N');
    
    res.json({
        role: roleName,
        department: accessData.jobTitles.find(jt => jt.title === roleName)?.department || '',
        access: roleAccess
    });
});

// Update application access (requires authorization)
app.put('/api/applications/:id', async (req, res) => {
    const username = getWindowsUsername(req);
    
    if (!canEdit(username)) {
        return res.status(403).json({ error: 'Unauthorized to edit' });
    }
    
    const appId = parseInt(req.params.id);
    const updates = req.body;
    
    const appIndex = accessData.applications.findIndex(app => app.id === appId);
    if (appIndex === -1) {
        return res.status(404).json({ error: 'Application not found' });
    }
    
    // Update application
    if (updates.name) accessData.applications[appIndex].name = updates.name;
    if (updates.owner) accessData.applications[appIndex].owner = updates.owner;
    if (updates.access) accessData.applications[appIndex].access = updates.access;
    
    await saveData();
    
    res.json({
        success: true,
        application: accessData.applications[appIndex],
        updatedBy: username,
        timestamp: new Date().toISOString()
    });
});

// Add new application (requires authorization)
app.post('/api/applications', async (req, res) => {
    const username = getWindowsUsername(req);
    
    if (!canEdit(username)) {
        return res.status(403).json({ error: 'Unauthorized to edit' });
    }
    
    const { name, owner, category, access } = req.body;
    
    const newApp = {
        id: Math.max(...accessData.applications.map(app => app.id), 0) + 1,
        name: name,
        owner: owner || '',
        category: category || 'Supporting Applications',
        lastVerified: new Date().toISOString().split('T')[0],
        access: access || {}
    };
    
    accessData.applications.push(newApp);
    accessData.metadata.totalApplications = accessData.applications.length;
    
    await saveData();
    
    res.json({
        success: true,
        application: newApp,
        createdBy: username,
        timestamp: new Date().toISOString()
    });
});

// Export to Excel
app.get('/api/export', (req, res) => {
    try {
        const wb = XLSX.utils.book_new();
        
        // Create applications sheet
        const appsData = accessData.applications.map(app => {
            const row = {
                'Application Name': app.name,
                'Owner': app.owner,
                'Category': app.category,
                'Last Verified': app.lastVerified
            };
            
            // Add access columns
            accessData.jobTitles.forEach(jobTitle => {
                row[jobTitle.title] = app.access[jobTitle.title] || 'N';
            });
            
            return row;
        });
        
        const ws = XLSX.utils.json_to_sheet(appsData);
        XLSX.utils.book_append_sheet(wb, ws, 'Applications');
        
        // Write to buffer
        const buffer = XLSX.write(wb, { type: 'buffer', bookType: 'xlsx' });
        
        res.setHeader('Content-Disposition', 'attachment; filename=access-matrix-export.xlsx');
        res.setHeader('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
        res.send(buffer);
        
    } catch (error) {
        console.error('Export error:', error);
        res.status(500).json({ error: 'Export failed' });
    }
});

// Main page
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// Initialize and start server
async function start() {
    await loadData();
    
    // Uncomment the next line ONLY on first run to import your Excel data
    // await importFromExcel();
    
    app.listen(PORT, '0.0.0.0', () => {
        const networkInterfaces = os.networkInterfaces();
        const addresses = [];
        
        Object.keys(networkInterfaces).forEach(interfaceName => {
            networkInterfaces[interfaceName].forEach(interface => {
                if (interface.family === 'IPv4' && !interface.internal) {
                    addresses.push(interface.address);
                }
            });
        });
        
        console.log('=================================');
        console.log('🚀 IT Access Management Started');
        console.log('=================================');
        console.log(`Local access: http://localhost:${PORT}`);
        if (addresses.length > 0) {
            console.log(`Network access: http://${addresses[0]}:${PORT}`);
        }
        console.log(`Authorized editors: ${AUTHORIZED_EDITORS.length}`);
        console.log(`Applications loaded: ${accessData.applications.length}`);
        console.log(`Job titles loaded: ${accessData.jobTitles.length}`);
        console.log('=================================');
    });
}

start().catch(console.error);