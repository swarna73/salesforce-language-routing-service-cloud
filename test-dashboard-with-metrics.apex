System.debug('🧪 Testing dashboard with metrics collection...');

// Create test cases that will generate metrics
List<Case> testCases = new List<Case>{
    new Case(
        Subject = 'Dashboard Test - Dutch',
        Description = 'Ik heb een probleem met mijn bestelling. Kunnen jullie mij helpen?',
        Origin = 'Web'
    ),
    new Case(
        Subject = 'Dashboard Test - English',  
        Description = 'I need immediate help with my account and billing information.',
        Origin = 'Email'
    ),
    new Case(
        Subject = 'Dashboard Test - Spanish',
        Description = 'Necesito ayuda urgente con mi pedido. No encuentro la información.',
        Origin = 'Phone'
    )
};

insert testCases;

System.debug('✅ Created ' + testCases.size() + ' test cases with metrics');

// Wait a moment then check dashboard data
System.debug('📊 Getting dashboard data...');
Map<String, Object> dashboardData = RoutingDashboardController.getDashboardData();

System.debug('Dashboard Results:');
System.debug('  Total Cases: ' + dashboardData.get('totalCases'));
System.debug('  Success Rate: ' + dashboardData.get('successRate') + '%');
System.debug('  Avg Confidence: ' + dashboardData.get('avgConfidence'));
System.debug('  Avg Processing Time: ' + dashboardData.get('avgProcessingTime') + 'ms');

System.debug('🎉 DASHBOARD TEST COMPLETE!');
