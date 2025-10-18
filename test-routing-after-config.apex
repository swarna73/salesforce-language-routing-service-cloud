// Test routing after queue configuration
List<Case> testCase = [
    SELECT Id, Subject, Description, OwnerId, Comments 
    FROM Case 
    WHERE Subject = 'English Customer Request' 
    LIMIT 1
];

if (!testCase.isEmpty()) {
    System.debug('🧪 Testing single case routing after queue config...');
    
    CaseLanguageRouter.RoutingResult result = CaseLanguageRouter.routeCase(testCase[0]);
    System.debug('🎯 Result: ' + result);
    
    if (result.success) {
        try {
            update testCase[0];
            System.debug('✅ SUCCESS! Case routed and updated');
            
            // Check the result
            Case updatedCase = [SELECT Id, Subject, OwnerId, Comments FROM Case WHERE Id = :testCase[0].Id];
            System.debug('📋 Updated Case Owner: ' + updatedCase.OwnerId);
            System.debug('📝 Comments: ' + updatedCase.Comments);
        } catch (Exception e) {
            System.debug('❌ Update error: ' + e.getMessage());
        }
    }
}
