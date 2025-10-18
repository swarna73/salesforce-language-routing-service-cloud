// Simple auto-routing test
System.debug('🧪 Testing AUTOMATIC case routing...');

Case newTestCase = new Case(
    Subject = 'Auto Test - Dutch',
    Description = 'Ik heb een probleem met mijn bestelling en kan geen hulp vinden.',
    Origin = 'Web'
);

System.debug('📝 Creating test case...');
insert newTestCase;

System.debug('🔍 Checking result...');
Case routedCase = [SELECT Id, Subject, OwnerId, Owner.Name FROM Case WHERE Id = :newTestCase.Id];
System.debug('✅ Case Owner: ' + routedCase.OwnerId + ' (' + routedCase.Owner.Name + ')');

System.debug('🎉 AUTO-ROUTING TEST COMPLETE!');
