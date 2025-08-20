// Test with a simple string first
String testText = 'Ik heb een probleem met mijn bestelling';
System.debug('Testing: ' + testText);

// Try calling your method (adjust based on your actual method signature)
try {
    Object result = LanguageDetectionService.detectLanguage(testText);
    System.debug('Result: ' + result);
} catch (Exception e) {
    System.debug('Error: ' + e.getMessage());
}
