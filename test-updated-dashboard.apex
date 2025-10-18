System.debug('🧪 Testing updated dashboard controller...');

// Test the new dashboard data
Map<String, Object> dashboardData = RoutingDashboardController.getDashboardData();

System.debug('📊 UPDATED DASHBOARD RESULTS:');
System.debug('  Total Cases: ' + dashboardData.get('totalCases'));
System.debug('  Successful Routings: ' + dashboardData.get('successfulRoutings'));
System.debug('  Success Rate: ' + dashboardData.get('successRate') + '%');
System.debug('  Language Breakdown: ' + dashboardData.get('languageBreakdown'));
System.debug('  Queue Breakdown: ' + dashboardData.get('queueBreakdown'));

System.debug('🎉 DASHBOARD SHOULD NOW SHOW ALL YOUR CASES!');
