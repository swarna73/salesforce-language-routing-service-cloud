// LIVE ROUTING - Actually update cases in your org!
List<Case> casesToRoute = [
    SELECT Id, Subject, Description, OwnerId, Comments 
    FROM Case 
    WHERE Subject LIKE '%Customer%' 
    AND OwnerId = '005gK000005OLI9QAO'  // Your user ID
    ORDER BY CreatedDate DESC 
    LIMIT 3
];

System.debug('🚀 LIVE ROUTING - Processing ' + casesToRoute.size() + ' cases for REAL!');

// Show before state
for (Case c : casesToRoute) {
    System.debug('BEFORE: ' + c.Subject + ' → Owner: ' + c.OwnerId);
}

// ACTUALLY ROUTE AND UPDATE!
List<CaseLanguageRouter.RoutingResult> results = CaseLanguageRouter.routeCases(casesToRoute);

System.debug('🎯 ROUTING COMPLETED!');
for (CaseLanguageRouter.RoutingResult result : results) {
    System.debug('✅ Result: ' + result);
}

// Show after state
List<Case> routedCases = [SELECT Id, Subject, OwnerId, Comments FROM Case WHERE Id IN :casesToRoute];
for (Case c : routedCases) {
    System.debug('AFTER: ' + c.Subject + ' → NEW Owner: ' + c.OwnerId);
    if (String.isNotBlank(c.Comments)) {
        System.debug('  📝 Audit Trail: ' + c.Comments);
    }
}

System.debug('🎉 LIVE ROUTING COMPLETE!');
