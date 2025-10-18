List<Case> testCases = [SELECT Id, Subject, Description FROM Case WHERE Subject LIKE '%Customer%' ORDER BY CreatedDate DESC LIMIT 5];

for(Case c : testCases) {
    System.debug('=== Testing: ' + c.Subject + ' ===');
    System.debug('Description: ' + c.Description);
    
    Object result = LanguageDetectionService.detectLanguage(c.Description);
    System.debug('🧠 Detection Result: ' + result);
    System.debug('------------------------');
}
