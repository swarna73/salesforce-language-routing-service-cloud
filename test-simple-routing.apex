System.debug('🧪 Testing simplified routing...');

// Create just a few test cases to verify it works
List<Case> simpleCases = new List<Case>{
    new Case(
        Subject = 'Simple Dutch Test',
        Description = 'Ik heb een eenvoudig probleem met mijn account en kan niet inloggen.',
        Origin = 'Web'
    ),
    new Case(
        Subject = 'Simple English Test',
        Description = 'I need help with my account settings and password reset.',
        Origin = 'Email'
    )
};

insert simpleCases;
System.debug('✅ Created simple test cases');

// Check results
List<Case> routedCases = [SELECT Id, Subject, OwnerId, Owner.Name FROM Case WHERE Id IN :simpleCases];
for (Case c : routedCases) {
    System.debug('📋 ' + c.Subject + ' → ' + c.Owner.Name);
}

System.debug('🎉 SIMPLE ROUTING TEST COMPLETE!');
