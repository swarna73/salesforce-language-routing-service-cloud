System.debug('🧪 Testing RoutingDashboardController...');

// Test getting dashboard data
Map<String, Object> dashboardData = RoutingDashboardController.getDashboardData();

System.debug('✅ Dashboard Data Retrieved:');
System.debug('  Total Cases: ' + dashboardData.get('totalCases'));
System.debug('  Success Rate: ' + dashboardData.get('successRate') + '%');
System.debug('  Queue Breakdown: ' + dashboardData.get('queueBreakdown'));

System.debug('🎉 CONTROLLER TEST COMPLETE!');
