// Final test - should work perfectly now!
List<Case> casesToRoute = [
    SELECT Id, Subject, Description, OwnerId, Comments 
    FROM Case 
    WHERE Subject LIKE '%Customer%' 
    ORDER BY CreatedDate DESC 
    LIMIT 3
];

System.debug('🚀 FINAL ROUTING TEST - All queues configured!');

// Show current state
for (Case c : casesToRoute) {
    System.debug('BEFORE: ' + c.Subject + ' → Owner: ' + c.OwnerId);
}

// ROUTE FOR REAL!
List<CaseLanguageRouter.RoutingResult> results = CaseLanguageRouter.routeCases(casesToRoute);

System.debug('🎯 ROUTING RESULTS:');
for (CaseLanguageRouter.RoutingResult result : results) {
    System.debug('✅ ' + result);
}

// Check final state
List<Case> routedCases = [SELECT Id, Subject, OwnerId, Comments FROM Case WHERE Id IN :casesToRoute];
for (Case c : routedCases) {
    System.debug('AFTER: ' + c.Subject + ' → NEW Owner: ' + c.OwnerId);
    if (String.isNotBlank(c.Comments)) {
        System.debug('  📝 Audit: ' + c.Comments);
    }
}

System.debug('🎉 INTELLIGENT LANGUAGE ROUTING COMPLETE!');
