// Test with Comments field included
List<Case> testCases = [SELECT Id, Subject, Description, OwnerId, Comments FROM Case WHERE Subject LIKE '%Customer%' ORDER BY CreatedDate DESC LIMIT 3];

System.debug('🧪 Testing Fixed Routing Engine on ' + testCases.size() + ' cases');

for (Case c : testCases) {
    System.debug('=== Testing Case: ' + c.Subject + ' ===');
    
    // Test routing logic
    CaseLanguageRouter.RoutingResult result = CaseLanguageRouter.routeCase(c);
    
    System.debug('🎯 Routing Result: ' + result);
    System.debug('------------------------');
}
