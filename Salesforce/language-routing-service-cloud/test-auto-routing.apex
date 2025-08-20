// Test automatic routing by creating new cases
System.debug('🧪 Testing AUTOMATIC case routing...');

// Create test cases - they should be auto-routed by the trigger!
List<Case> newTestCases = new List<Case>{
    new Case(
        Subject = 'Auto Test - Dutch Issue',
        Description = 'Ik heb een probleem met mijn nieuwe bestelling en weet niet wat ik moet doen.',
        Origin = 'Web'
    ),
    new Case(
        Subject = 'Auto Test - German Problem', 
        Description = 'Ich brauche sofortige Hilfe mit meinem defekten Produkt. Es funktioniert überhaupt nicht.',
        Origin = 'Email'
    ),
    new Case(
        Subject = 'Auto Test - English Request',
        Description = 'I need immediate assistance with my account settings and billing information.',
        Origin = 'Phone'
    )
};

// Insert cases - trigger should automatically route them!
insert newTestCases;

System.debug('✅ Created ' + newTestCases.size() + ' test cases');

// Wait a moment then check the results
System.debug('🔍 Checking auto-routing results...');

List<Case> routedCases = [
    SELECT Id, Subject, OwnerId, Comments, Owner.Name 
    FROM Case 
    WHERE Id IN :newTestCases 
];

for (Case c : routedCases) {
    System.debug('📋 Case: ' + c.Subject);
    System.debug('  Owner: ' + c.OwnerId + ' (' + c.Owner.Name + ')');
    System.debug('  Comments: ' + c.Comments);
    System.debug('  ---');
}

// Get routing statistics
Map<String, Object> stats = CaseAutoRoutingHandler.getRoutingStats();
System.debug('📊 Routing Stats: ' + stats);

System.debug('🎉 AUTOMATIC ROUTING TEST COMPLETE!');
