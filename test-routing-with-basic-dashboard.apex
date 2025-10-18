System.debug('🧪 Testing routing with basic dashboard tracking...');

// Create test cases
List<Case> testCases = new List<Case>{
    new Case(
        Subject = 'Dashboard Test - Dutch Simple',
        Description = 'Ik heb een probleem met mijn bestelling.',
        Origin = 'Web'
    ),
    new Case(
        Subject = 'Dashboard Test - English Simple',  
        Description = 'I need help with my account settings.',
        Origin = 'Email'
    )
};

insert testCases;
System.debug('✅ Created ' + testCases.size() + ' test cases');

// Check dashboard data
Map<String, Object> dashboardData = RoutingDashboardController.getDashboardData();
System.debug('📊 Dashboard shows ' + dashboardData.get('totalCases') + ' total cases today');

System.debug('🎉 BASIC DASHBOARD TEST COMPLETE!');
