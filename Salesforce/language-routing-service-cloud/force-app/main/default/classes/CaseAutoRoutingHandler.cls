public class CaseAutoRoutingHandler {
    
    public static Boolean isProcessing = false;
    private static final Boolean AUTO_ROUTING_ENABLED = true;
    private static final Boolean ROUTE_ON_DESCRIPTION_CHANGE = true;
    private static final Integer MIN_DESCRIPTION_LENGTH = 10;
    
    public static void handleCaseRouting(List<Case> newCases, Map<Id, Case> oldCaseMap) {
        
        if (!AUTO_ROUTING_ENABLED) {
            System.debug('🔴 Auto-routing is disabled');
            return;
        }
        
        try {
            isProcessing = true;
            
            List<Case> casesToRoute = filterCasesForRouting(newCases, oldCaseMap);
            
            if (casesToRoute.isEmpty()) {
                System.debug('📋 No cases found that need routing');
                return;
            }
            
            System.debug('🚀 Auto-routing ' + casesToRoute.size() + ' cases');
            
            List<CaseLanguageRouter.RoutingResult> results = CaseLanguageRouter.routeCases(casesToRoute);
            
            processRoutingResults(casesToRoute, results);
            
        } catch (Exception e) {
            System.debug('❌ Auto-routing error: ' + e.getMessage());
            logRoutingError(newCases, e);
            
        } finally {
            isProcessing = false;
        }
    }
    
    private static List<Case> filterCasesForRouting(List<Case> newCases, Map<Id, Case> oldCaseMap) {
        List<Case> casesToRoute = new List<Case>();
        
        for (Case newCase : newCases) {
            
            if (String.isBlank(newCase.Description) || 
                newCase.Description.length() < MIN_DESCRIPTION_LENGTH) {
                continue;
            }
            
            if (isAlreadyInLanguageQueue(newCase.OwnerId)) {
                System.debug('📋 Case ' + newCase.Id + ' already in language queue, skipping');
                continue;
            }
            
            Boolean shouldRoute = false;
            
            if (oldCaseMap == null) {
                shouldRoute = true;
                System.debug('➕ New case for routing: ' + newCase.Subject);
                
            } else if (ROUTE_ON_DESCRIPTION_CHANGE) {
                Case oldCase = oldCaseMap.get(newCase.Id);
                if (oldCase != null && newCase.Description != oldCase.Description) {
                    shouldRoute = true;
                    System.debug('✏️ Case description changed, re-routing: ' + newCase.Subject);
                }
            }
            
            if (shouldRoute) {
                casesToRoute.add(newCase);
            }
        }
        
        return casesToRoute;
    }
    
    private static Boolean isAlreadyInLanguageQueue(Id ownerId) {
        if (ownerId == null || !String.valueOf(ownerId).startsWith('00G')) {
            return false;
        }
        
        List<Group> languageQueues = [
            SELECT Id 
            FROM Group 
            WHERE Type = 'Queue' 
            AND DeveloperName IN ('Dutch_Support_Queue', 'German_Support_Queue', 
                                 'French_Support_Queue', 'Spanish_Support_Queue', 
                                 'English_Support_Queue', 'Multilingual_Overflow_Queue')
            AND Id = :ownerId
            LIMIT 1
        ];
        
        return !languageQueues.isEmpty();
    }
    
    private static void processRoutingResults(List<Case> casesToRoute, List<CaseLanguageRouter.RoutingResult> results) {
        Integer successCount = 0;
        Integer failureCount = 0;
        
        for (Integer i = 0; i < results.size(); i++) {
            CaseLanguageRouter.RoutingResult result = results[i];
            Case caseRecord = casesToRoute[i];
            
            if (result.success) {
                successCount++;
                System.debug('✅ Successfully routed case ' + caseRecord.Id + ' to ' + result.targetQueue);
                createRoutingNotification(caseRecord, result);
                
            } else {
                failureCount++;
                System.debug('❌ Failed to route case ' + caseRecord.Id + ': ' + result.errorMessage);
                handleRoutingFailure(caseRecord, result);
            }
        }
        
        System.debug('📊 Auto-routing complete: ' + successCount + ' success, ' + failureCount + ' failed');
    }
    
    private static void createRoutingNotification(Case caseRecord, CaseLanguageRouter.RoutingResult result) {
        System.debug('🔔 Notification: Case ' + caseRecord.CaseNumber + 
                    ' auto-routed to ' + result.targetQueue + 
                    ' (Language: ' + result.detectedLanguage + 
                    ', Confidence: ' + result.confidence + ')');
    }
    
    private static void handleRoutingFailure(Case caseRecord, CaseLanguageRouter.RoutingResult result) {
        System.debug('🚨 Routing failure handling for case ' + caseRecord.Id);
    }
    
    private static void logRoutingError(List<Case> cases, Exception error) {
        System.debug('🚨 Auto-routing system error:');
        System.debug('Error: ' + error.getMessage());
        System.debug('Stack trace: ' + error.getStackTraceString());
        System.debug('Affected cases: ' + cases.size());
    }
    
    public static Map<String, Object> getRoutingStats() {
        Map<String, Object> stats = new Map<String, Object>();
        
        DateTime yesterday = DateTime.now().addDays(-1);
        
        // Simplified query without Comments field filtering
        List<Case> recentlyRouted = [
            SELECT Id, Subject, OwnerId, CreatedDate
            FROM Case 
            WHERE CreatedDate >= :yesterday
            ORDER BY CreatedDate DESC
            LIMIT 100
        ];
        
        stats.put('casesLast24Hours', recentlyRouted.size());
        stats.put('autoRoutingEnabled', AUTO_ROUTING_ENABLED);
        stats.put('routeOnDescriptionChange', ROUTE_ON_DESCRIPTION_CHANGE);
        stats.put('minDescriptionLength', MIN_DESCRIPTION_LENGTH);
        
        return stats;
    }
}
