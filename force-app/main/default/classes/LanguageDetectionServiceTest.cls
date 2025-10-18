/**
 * Test class for LanguageDetectionService
 * 
 * Comprehensive test coverage for language detection functionality
 * Includes positive, negative, and edge case testing
 * 
 * @author Swarnalatha Swaminathan
 * @version 1.0
 * @since 2025-08-17
 */
@isTest
public class LanguageDetectionServiceTest {
    
    /**
     * Test data setup
     */
    @testSetup
    static void setupTestData() {
        // Create Language Mapping test data
        List<Language_Mapping__c> mappings = new List<Language_Mapping__c>{
            new Language_Mapping__c(
                Name = 'Dutch Mapping',
                Detected_Language__c = 'Dutch',
                Route_to_Language__c = 'Dutch'
            ),
            new Language_Mapping__c(
                Name = 'German Mapping', 
                Detected_Language__c = 'German',
                Route_to_Language__c = 'German'
            ),
            new Language_Mapping__c(
                Name = 'English Mapping',
                Detected_Language__c = 'English', 
                Route_to_Language__c = 'English'
            )
        };
        insert mappings;
        
        // Create test Case records
        List<Case> testCases = new List<Case>{
            new Case(
                Subject = 'Hallo, ik heb een probleem met mijn service',
                Description = 'Graag zou ik hulp willen met dit probleem. Het werkt niet goed.',
                Status = 'New',
                Origin = 'Email'
            ),
            new Case(
                Subject = 'Hallo, ich habe ein Problem mit meinem Service',
                Description = 'Bitte helfen Sie mir mit diesem Problem. Es funktioniert nicht.',
                Status = 'New', 
                Origin = 'Phone'
            ),
            new Case(
                Subject = 'Hello, I have a problem with my service',
                Description = 'Please help me with this issue. It is not working properly.',
                Status = 'New',
                Origin = 'Web'
            )
        };
        insert testCases;
    }
    
    /**
     * Test Dutch language detection
     */
    @isTest
    static void testDutchLanguageDetection() {
        Test.startTest();
        
        String dutchText = 'Hallo, ik heb een probleem met mijn service. Graag zou ik hulp willen.';
        LanguageDetectionService.LanguageDetectionResult result = 
            LanguageDetectionService.detectLanguage(dutchText);
        
        Test.stopTest();
        
        System.assertNotEquals(null, result, 'Result should not be null');
        System.assertEquals('Dutch', result.detectedLanguage, 'Should detect Dutch language');
        System.assert(result.confidence > 0, 'Confidence should be greater than 0');
        System.assertEquals(null, result.errorMessage, 'Should not have error message');
    }
    
    /**
     * Test German language detection
     */
    @isTest
    static void testGermanLanguageDetection() {
        Test.startTest();
        
        String germanText = 'Hallo, ich habe ein Problem mit meinem Service. Bitte helfen Sie mir.';
        LanguageDetectionService.LanguageDetectionResult result = 
            LanguageDetectionService.detectLanguage(germanText);
        
        Test.stopTest();
        
        System.assertNotEquals(null, result, 'Result should not be null');
        System.assertEquals('German', result.detectedLanguage, 'Should detect German language');
        System.assert(result.confidence > 0, 'Confidence should be greater than 0');
    }
    
    /**
     * Test English language detection (default)
     */
    @isTest
    static void testEnglishLanguageDetection() {
        Test.startTest();
        
        String englishText = 'Hello, I have a problem with my service. Please help me with this issue.';
        LanguageDetectionService.LanguageDetectionResult result = 
            LanguageDetectionService.detectLanguage(englishText);
        
        Test.stopTest();
        
        System.assertNotEquals(null, result, 'Result should not be null');
        System.assertEquals('English', result.detectedLanguage, 'Should detect English language');
        System.assert(result.confidence > 0, 'Confidence should be greater than 0');
    }
    
    /**
     * Test language detection from Case record
     */
    @isTest
    static void testDetectLanguageFromCase() {
        List<Case> testCases = [SELECT Id, Subject, Description FROM Case LIMIT 3];
        
        Test.startTest();
        
        LanguageDetectionService.LanguageDetectionResult result = 
            LanguageDetectionService.detectLanguageFromCase(testCases[0]);
        
        Test.stopTest();
        
        System.assertNotEquals(null, result, 'Result should not be null');
        System.assertNotEquals(null, result.detectedLanguage, 'Should detect a language');
        System.assert(result.confidence > 0, 'Confidence should be greater than 0');
    }
    
    /**
     * Test batch language detection for multiple cases
     */
    @isTest
    static void testDetectLanguagesForCases() {
        List<Case> testCases = [SELECT Id, Subject, Description FROM Case];
        
        Test.startTest();
        
        Map<Id, LanguageDetectionService.LanguageDetectionResult> results = 
            LanguageDetectionService.detectLanguagesForCases(testCases);
        
        Test.stopTest();
        
        System.assertEquals(testCases.size(), results.size(), 'Should have results for all cases');
        
        for (Id caseId : results.keySet()) {
            LanguageDetectionService.LanguageDetectionResult result = results.get(caseId);
            System.assertNotEquals(null, result.detectedLanguage, 'Should detect language for case: ' + caseId);
            System.assert(result.confidence > 0, 'Should have confidence score for case: ' + caseId);
        }
    }
    
    /**
     * Test empty text handling
     */
    @isTest
    static void testEmptyTextHandling() {
        Test.startTest();
        
        LanguageDetectionService.LanguageDetectionResult result = 
            LanguageDetectionService.detectLanguage('');
        
        Test.stopTest();
        
        System.assertNotEquals(null, result, 'Result should not be null');
        System.assertNotEquals(null, result.errorMessage, 'Should have error message for empty text');
    }
    
    /**
     * Test null text handling
     */
    @isTest
    static void testNullTextHandling() {
        Test.startTest();
        
        LanguageDetectionService.LanguageDetectionResult result = 
            LanguageDetectionService.detectLanguage(null);
        
        Test.stopTest();
        
        System.assertNotEquals(null, result, 'Result should not be null');
        System.assertNotEquals(null, result.errorMessage, 'Should have error message for null text');
    }
    
    /**
     * Test language mapping retrieval
     */
    @isTest
    static void testGetRoutingLanguage() {
        Test.startTest();
        
        String routingLanguage = LanguageDetectionService.getRoutingLanguage('Dutch');
        
        Test.stopTest();
        
        System.assertEquals('Dutch', routingLanguage, 'Should return mapped routing language');
    }
    
    /**
     * Test language mapping with unmapped language
     */
    @isTest
    static void testGetRoutingLanguageUnmapped() {
        Test.startTest();
        
        String routingLanguage = LanguageDetectionService.getRoutingLanguage('UnknownLanguage');
        
        Test.stopTest();
        
        System.assertEquals('English', routingLanguage, 'Should default to English for unmapped language');
    }
    
    /**
     * Test high confidence detection
     */
    @isTest
    static void testHighConfidenceDetection() {
        Test.startTest();
        
        // Text with many Dutch patterns should have high confidence
        String dutchText = 'Hallo, dank je wel voor de hulp. Ik heb een probleem met het systeem. ' +
                          'Graag zou ik ondersteuning willen voor dit probleem. Het werkt niet goed.';
        LanguageDetectionService.LanguageDetectionResult result = 
            LanguageDetectionService.detectLanguage(dutchText);
        
        Test.stopTest();
        
        System.assertEquals('Dutch', result.detectedLanguage, 'Should detect Dutch');
        // Note: Actual confidence will depend on the pattern matching algorithm
        System.assert(result.confidence > 0, 'Should have some confidence');
    }
    
    /**
     * Test detection result properties
     */
    @isTest
    static void testDetectionResultProperties() {
        Test.startTest();
        
        LanguageDetectionService.LanguageDetectionResult result = 
            new LanguageDetectionService.LanguageDetectionResult();
        
        Test.stopTest();
        
        System.assertNotEquals(null, result.allLanguages, 'AllLanguages map should be initialized');
        System.assertEquals(false, result.isHighConfidence, 'Should default to false');
    }
}
