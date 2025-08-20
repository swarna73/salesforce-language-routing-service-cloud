List<Case> testCases = [SELECT Id, Subject, Description FROM Case WHERE Subject LIKE '%Customer%' ORDER BY CreatedDate DESC LIMIT 5];

for(Case c : testCases) {
    System.debug('=== Testing: ' + c.Subject + ' ===');
    LanguageDetectionService.LanguageResult result = LanguageDetectionService.detectLanguage(c.Description);
    System.debug('Language: ' + result.language + ', Confidence: ' + result.confidence);
}
