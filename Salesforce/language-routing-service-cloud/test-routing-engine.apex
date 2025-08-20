// Test the routing engine on your existing cases
List<Case> testCases = [SELECT Id, Subject, Description, OwnerId FROM Case WHERE Subject LIKE '%Customer%' ORDER BY CreatedDate DESC LIMIT 5];

System.debug('🧪 Testing Routing Engine on ' + testCases.size() + ' cases');

for (Case c : testCases) {
    System.debug('=== Testing Case: ' + c.Subject + ' ===');
    System.debug('Description: ' + c.Description);
    System.debug('Current Owner: ' + c.OwnerId);
    
    // Test routing logic (without updating - just to see results)
    CaseLanguageRouter.RoutingResult result = CaseLanguageRouter.routeCase(c);
    
    System.debug('🎯 Routing Result: ' + result);
    System.debug('------------------------');
}

// Test getting available queues
System.debug('📋 Available Queues:');
Map<String, String> queues = CaseLanguageRouter.getAvailableQueues();
for (String queueKey : queues.keySet()) {
    System.debug('  ' + queueKey + ' -> ' + queues.get(queueKey));
}
