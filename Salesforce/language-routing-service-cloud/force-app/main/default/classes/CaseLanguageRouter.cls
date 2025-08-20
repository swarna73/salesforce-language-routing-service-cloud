/**
 * CaseLanguageRouter - Intelligent case routing based on language detection
 * Routes cases to appropriate language-specific queues
 */
public class CaseLanguageRouter {
    
    // Queue mapping - Language to Queue Developer Name
    private static final Map<String, String> LANGUAGE_TO_QUEUE = new Map<String, String>{
        'Dutch' => 'Dutch_Support_Queue',
        'German' => 'German_Support_Queue', 
        'French' => 'French_Support_Queue',
        'Spanish' => 'Spanish_Support_Queue',
        'English' => 'English_Support_Queue'
    };
    
    // Fallback queue for undetected languages or low confidence
    private static final String FALLBACK_QUEUE = 'Multilingual_Overflow_Queue';
    
    // Minimum confidence threshold for auto-routing
    private static final Decimal CONFIDENCE_THRESHOLD = 0.50;
    
    /**
     * Route a single case based on language detection
     * @param caseRecord - The case to route
     * @return RoutingResult - Result of the routing attempt
     */
    public static RoutingResult routeCase(Case caseRecord) {
        try {
            // Detect language from case description
            Object detectionResult = LanguageDetectionService.detectLanguage(caseRecord.Description);
            
            // Parse the detection result (adjust based on your actual structure)
            String detectedLanguage = parseDetectedLanguage(detectionResult);
            Decimal confidence = parseConfidence(detectionResult);
            
            System.debug('🧠 Language Detection - Language: ' + detectedLanguage + ', Confidence: ' + confidence);
            
            // Determine target queue
            String targetQueueName = determineTargetQueue(detectedLanguage, confidence);
            
            // Get queue ID
            Id queueId = getQueueId(targetQueueName);
            
            if (queueId != null) {
                // Update case owner to queue
                caseRecord.OwnerId = queueId;
                
                // Add routing metadata to case
                caseRecord.Comments = (caseRecord.Comments != null ? caseRecord.Comments + '\\n' : '') + 
                    '🤖 Auto-routed to ' + targetQueueName + ' (Language: ' + detectedLanguage + ', Confidence: ' + confidence + ')';
                
                return new RoutingResult(true, targetQueueName, detectedLanguage, confidence, null);
            } else {
                return new RoutingResult(false, null, detectedLanguage, confidence, 'Queue not found: ' + targetQueueName);
            }
            
        } catch (Exception e) {
            System.debug('❌ Routing Error: ' + e.getMessage());
            return new RoutingResult(false, null, null, null, e.getMessage());
        }
    }
    
    /**
     * Route multiple cases in bulk
     * @param cases - List of cases to route
     * @return List<RoutingResult> - Results for each case
     */
    public static List<RoutingResult> routeCases(List<Case> cases) {
        List<RoutingResult> results = new List<RoutingResult>();
        List<Case> casesToUpdate = new List<Case>();
        
        for (Case caseRecord : cases) {
            if (String.isNotBlank(caseRecord.Description)) {
                RoutingResult result = routeCase(caseRecord);
                results.add(result);
                
                if (result.success) {
                    casesToUpdate.add(caseRecord);
                }
            } else {
                results.add(new RoutingResult(false, null, null, null, 'No description provided'));
            }
        }
        
        // Bulk update cases
        if (!casesToUpdate.isEmpty()) {
            try {
                update casesToUpdate;
                System.debug('✅ Successfully routed ' + casesToUpdate.size() + ' cases');
            } catch (Exception e) {
                System.debug('❌ Bulk update error: ' + e.getMessage());
                // Mark all as failed
                for (RoutingResult result : results) {
                    if (result.success) {
                        result.success = false;
                        result.errorMessage = 'Bulk update failed: ' + e.getMessage();
                    }
                }
            }
        }
        
        return results;
    }
    
    /**
     * Parse detected language from LanguageDetectionService result
     */
    private static String parseDetectedLanguage(Object detectionResult) {
        // Parse based on your LanguageDetectionService output format
        String resultStr = String.valueOf(detectionResult);
        
        // Extract detectedLanguage from the result string
        if (resultStr.contains('detectedLanguage=')) {
            String[] parts = resultStr.split('detectedLanguage=');
            if (parts.size() > 1) {
                String languagePart = parts[1].split(',')[0].trim();
                return languagePart;
            }
        }
        
        return 'Unknown';
    }
    
    /**
     * Parse confidence score from LanguageDetectionService result
     */
    private static Decimal parseConfidence(Object detectionResult) {
        String resultStr = String.valueOf(detectionResult);
        
        // Extract confidence from the result string
        if (resultStr.contains('confidence=')) {
            String[] parts = resultStr.split('confidence=');
            if (parts.size() > 1) {
                String confidencePart = parts[1].split(',')[0].trim();
                try {
                    return Decimal.valueOf(confidencePart);
                } catch (Exception e) {
                    System.debug('Error parsing confidence: ' + e.getMessage());
                }
            }
        }
        
        return 0.0;
    }
    
    /**
     * Determine target queue based on language and confidence
     */
    private static String determineTargetQueue(String detectedLanguage, Decimal confidence) {
        // Check confidence threshold
        if (confidence < CONFIDENCE_THRESHOLD) {
            System.debug('⚠️ Low confidence (' + confidence + '), routing to fallback queue');
            return FALLBACK_QUEUE;
        }
        
        // Check if we have a queue for this language
        if (LANGUAGE_TO_QUEUE.containsKey(detectedLanguage)) {
            return LANGUAGE_TO_QUEUE.get(detectedLanguage);
        }
        
        // Fallback for unknown languages
        System.debug('⚠️ Unknown language (' + detectedLanguage + '), routing to fallback queue');
        return FALLBACK_QUEUE;
    }
    
    /**
     * Get queue ID by developer name
     */
    private static Id getQueueId(String queueDeveloperName) {
        try {
            List<Group> queues = [
                SELECT Id, DeveloperName 
                FROM Group 
                WHERE Type = 'Queue' AND DeveloperName = :queueDeveloperName 
                LIMIT 1
            ];
            
            if (!queues.isEmpty()) {
                return queues[0].Id;
            }
        } catch (Exception e) {
            System.debug('Error finding queue: ' + e.getMessage());
        }
        
        return null;
    }
    
    /**
     * Get all available language queues
     */
    public static Map<String, String> getAvailableQueues() {
        Map<String, String> queueInfo = new Map<String, String>();
        
        List<String> queueNames = new List<String>(LANGUAGE_TO_QUEUE.values());
        queueNames.add(FALLBACK_QUEUE);
        
        List<Group> queues = [
            SELECT Id, Name, DeveloperName 
            FROM Group 
            WHERE Type = 'Queue' AND DeveloperName IN :queueNames
        ];
        
        for (Group queue : queues) {
            queueInfo.put(queue.DeveloperName, queue.Name + ' (' + queue.Id + ')');
        }
        
        return queueInfo;
    }
    
    /**
     * Result wrapper class
     */
    public class RoutingResult {
        public Boolean success;
        public String targetQueue;
        public String detectedLanguage;
        public Decimal confidence;
        public String errorMessage;
        
        public RoutingResult(Boolean success, String targetQueue, String detectedLanguage, Decimal confidence, String errorMessage) {
            this.success = success;
            this.targetQueue = targetQueue;
            this.detectedLanguage = detectedLanguage;
            this.confidence = confidence;
            this.errorMessage = errorMessage;
        }
        
        public override String toString() {
            return 'RoutingResult[success=' + success + 
                   ', queue=' + targetQueue + 
                   ', language=' + detectedLanguage + 
                   ', confidence=' + confidence + 
                   ', error=' + errorMessage + ']';
        }
    }
}
