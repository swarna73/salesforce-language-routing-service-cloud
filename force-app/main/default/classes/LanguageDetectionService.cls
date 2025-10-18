/**
 * LanguageDetectionService - Einstein Language API Integration
 * 
 * Detects the language of case text using Einstein Platform Services
 * Returns structured language detection results with confidence scores
 * 
 * @author Swarnalatha Swaminathan
 * @version 1.0
 * @since 2025-08-17
 */
public with sharing class LanguageDetectionService {
    
    // Einstein Language API Configuration
    private static final String EINSTEIN_LANGUAGE_URL = 'https://api.einstein.ai/v2/language/intent';
    private static final String DATASET_ID = 'CommunitySentiment'; // Default dataset
    private static final Decimal MINIMUM_CONFIDENCE = 0.70;
    
    /**
     * Language Detection Result wrapper class
     */
    public class LanguageDetectionResult {
        public String detectedLanguage;
        public Decimal confidence;
        public Boolean isHighConfidence;
        public String errorMessage;
        public Map<String, Decimal> allLanguages;
        
        public LanguageDetectionResult() {
            this.allLanguages = new Map<String, Decimal>();
            this.isHighConfidence = false;
        }
    }
    
    /**
     * Detect language from Case record
     * @param caseRecord The Case record to analyze
     * @return LanguageDetectionResult with detected language and confidence
     */
    public static LanguageDetectionResult detectLanguageFromCase(Case caseRecord) {
        String textToAnalyze = buildTextFromCase(caseRecord);
        return detectLanguage(textToAnalyze);
    }
    
    /**
     * Detect language from text string
     * @param textToAnalyze The text to analyze for language detection
     * @return LanguageDetectionResult with detected language and confidence
     */
    public static LanguageDetectionResult detectLanguage(String textToAnalyze) {
        LanguageDetectionResult result = new LanguageDetectionResult();
        
        // Validate input
        if (String.isBlank(textToAnalyze)) {
            result.errorMessage = 'No text provided for language detection';
            return result;
        }
        
        // For demo purposes, implement pattern-based detection
        // In production, this would integrate with Einstein Language API
        try {
            result = performLanguageDetection(textToAnalyze);
        } catch (Exception e) {
            System.debug('Language detection error: ' + e.getMessage());
            result.errorMessage = 'Language detection failed: ' + e.getMessage();
            // Fallback to English for error cases
            result.detectedLanguage = 'English';
            result.confidence = 0.50;
        }
        
        return result;
    }
    
    /**
     * Build analyzable text from Case fields
     * @param caseRecord The Case record
     * @return Combined text for analysis
     */
    private static String buildTextFromCase(Case caseRecord) {
        List<String> textParts = new List<String>();
        
        if (!String.isBlank(caseRecord.Subject)) {
            textParts.add(caseRecord.Subject);
        }
        
        if (!String.isBlank(caseRecord.Description)) {
            textParts.add(caseRecord.Description);
        }
        
        return String.join(textParts, ' ');
    }
    
    /**
     * Perform the actual language detection logic
     * This is a demo implementation - in production would use Einstein API
     */
    private static LanguageDetectionResult performLanguageDetection(String text) {
        LanguageDetectionResult result = new LanguageDetectionResult();
        
        // Pattern-based detection for demo (replace with Einstein API)
        Map<String, List<String>> languagePatterns = getLanguagePatterns();
        Map<String, Integer> languageScores = new Map<String, Integer>();
        
        String lowerText = text.toLowerCase();
        
        // Score each language based on pattern matches
        for (String language : languagePatterns.keySet()) {
            Integer score = 0;
            for (String pattern : languagePatterns.get(language)) {
                if (lowerText.contains(pattern.toLowerCase())) {
                    score += pattern.length(); // Longer patterns get higher scores
                }
            }
            if (score > 0) {
                languageScores.put(language, score);
            }
        }
        
        // Default to English if no patterns match
        if (languageScores.isEmpty()) {
            result.detectedLanguage = 'English';
            result.confidence = 0.60;
        } else {
            // Find highest scoring language
            String topLanguage = 'English';
            Integer maxScore = 0;
            Integer totalScore = 0;
            
            for (String lang : languageScores.keySet()) {
                Integer score = languageScores.get(lang);
                totalScore += score;
                if (score > maxScore) {
                    maxScore = score;
                    topLanguage = lang;
                }
            }
            
            result.detectedLanguage = topLanguage;
            // Calculate confidence as percentage of total score
            result.confidence = totalScore > 0 ? 
                Decimal.valueOf(maxScore).divide(Decimal.valueOf(totalScore), 4) : 0.60;
            
            // Store all language scores for transparency
            for (String lang : languageScores.keySet()) {
                Decimal langConfidence = totalScore > 0 ? 
                    Decimal.valueOf(languageScores.get(lang)).divide(Decimal.valueOf(totalScore), 4) : 0;
                result.allLanguages.put(lang, langConfidence);
            }
        }
        
        result.isHighConfidence = result.confidence >= MINIMUM_CONFIDENCE;
        
        return result;
    }
    
    /**
     * Language detection patterns for demo purposes
     * In production, this would be replaced by Einstein Language API
     */
    private static Map<String, List<String>> getLanguagePatterns() {
        Map<String, List<String>> patterns = new Map<String, List<String>>();
        
        // Dutch patterns
        patterns.put('Dutch', new List<String>{
            'hallo', 'dank je', 'graag', 'probleem', 'help', 'vraag', 
            'goed', 'slecht', 'werkt niet', 'ondersteuning', 'service',
            'het', 'de', 'een', 'van', 'is', 'met', 'voor', 'op'
        });
        
        // German patterns  
        patterns.put('German', new List<String>{
            'hallo', 'danke', 'bitte', 'problem', 'hilfe', 'frage',
            'gut', 'schlecht', 'funktioniert nicht', 'unterstützung',
            'der', 'die', 'das', 'und', 'ist', 'mit', 'für', 'auf'
        });
        
        // French patterns
        patterns.put('French', new List<String>{
            'bonjour', 'merci', 'problème', 'aide', 'question',
            'bon', 'mauvais', 'ne fonctionne pas', 'support',
            'le', 'la', 'les', 'de', 'et', 'est', 'avec', 'pour'
        });
        
        // Spanish patterns
        patterns.put('Spanish', new List<String>{
            'hola', 'gracias', 'problema', 'ayuda', 'pregunta',
            'bueno', 'malo', 'no funciona', 'soporte',
            'el', 'la', 'los', 'de', 'y', 'es', 'con', 'para'
        });
        
        // English patterns (default)
        patterns.put('English', new List<String>{
            'hello', 'thank you', 'thanks', 'problem', 'help', 'question',
            'good', 'bad', 'not working', 'support', 'issue',
            'the', 'and', 'is', 'with', 'for', 'on', 'to'
        });
        
        return patterns;
    }
    
    /**
     * Get Language Mapping for routing
     * @param detectedLanguage The language detected by the service
     * @return The standardized language for agent matching
     */
    public static String getRoutingLanguage(String detectedLanguage) {
        // Query Language_Mapping__c for routing configuration
        try {
            Language_Mapping__c mapping = [
                SELECT Route_to_Language__c 
                FROM Language_Mapping__c 
                WHERE Detected_Language__c = :detectedLanguage 
                LIMIT 1
            ];
            return mapping.Route_to_Language__c;
        } catch (QueryException e) {
            System.debug('No language mapping found for: ' + detectedLanguage);
            // Default fallback to English
            return 'English';
        }
    }
    
    /**
     * Batch process multiple cases for language detection
     * @param cases List of Case records to process
     * @return Map of Case ID to LanguageDetectionResult
     */
    public static Map<Id, LanguageDetectionResult> detectLanguagesForCases(List<Case> cases) {
        Map<Id, LanguageDetectionResult> results = new Map<Id, LanguageDetectionResult>();
        
        for (Case caseRecord : cases) {
            results.put(caseRecord.Id, detectLanguageFromCase(caseRecord));
        }
        
        return results;
    }
}
