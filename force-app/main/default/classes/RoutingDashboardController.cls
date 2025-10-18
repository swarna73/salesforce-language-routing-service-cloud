public class RoutingDashboardController {
    
    @AuraEnabled
    public static Map<String, Object> getDashboardData() {
        try {
            Map<String, Object> dashboardData = new Map<String, Object>();
            
            // Get cases from last 24 hours instead of just today
            DateTime last24Hours = DateTime.now().addHours(-24);
            
            List<Case> recentCases = [
                SELECT Id, Subject, OwnerId, Owner.Name, Owner.Type, CreatedDate, Description
                FROM Case 
                WHERE CreatedDate >= :last24Hours
                ORDER BY CreatedDate DESC
                LIMIT 100
            ];
            
            System.debug('📊 Found ' + recentCases.size() + ' cases in last 24 hours');
            
            Integer totalCases = recentCases.size();
            Integer successfulRoutings = 0;
            Map<String, Integer> queueBreakdown = new Map<String, Integer>();
            Map<String, Integer> languageBreakdown = new Map<String, Integer>();
            
            // Rest of your existing logic...
            for (Case c : recentCases) {
                if (c.OwnerId != null && String.valueOf(c.OwnerId).startsWith('00G')) {
                    successfulRoutings++;
                    String queueName = c.Owner.Name;
                    Integer count = queueBreakdown.get(queueName);
                    queueBreakdown.put(queueName, count == null ? 1 : count + 1);
                    
                    if (queueName.contains('Dutch')) {
                        Integer langCount = languageBreakdown.get('Dutch');
                        languageBreakdown.put('Dutch', langCount == null ? 1 : langCount + 1);
                    } else if (queueName.contains('German')) {
                        Integer langCount = languageBreakdown.get('German');
                        languageBreakdown.put('German', langCount == null ? 1 : langCount + 1);
                    } else if (queueName.contains('French')) {
                        Integer langCount = languageBreakdown.get('French');
                        languageBreakdown.put('French', langCount == null ? 1 : langCount + 1);
                    } else if (queueName.contains('Spanish')) {
                        Integer langCount = languageBreakdown.get('Spanish');
                        languageBreakdown.put('Spanish', langCount == null ? 1 : langCount + 1);
                    } else if (queueName.contains('English')) {
                        Integer langCount = languageBreakdown.get('English');
                        languageBreakdown.put('English', langCount == null ? 1 : langCount + 1);
                    } else if (queueName.contains('Multilingual') || queueName.contains('Overflow')) {
                        String detectedLanguage = analyzeLanguageFromDescription(c.Description);
                        Integer langCount = languageBreakdown.get(detectedLanguage);
                        languageBreakdown.put(detectedLanguage, langCount == null ? 1 : langCount + 1);
                    }
                }
            }
            
            Decimal successRate = totalCases > 0 ? (successfulRoutings * 100.0) / totalCases : 0;
            
            dashboardData.put('totalCases', totalCases);
            dashboardData.put('successfulRoutings', successfulRoutings);
            dashboardData.put('successRate', successRate);
            dashboardData.put('avgConfidence', 0.65);
            dashboardData.put('avgProcessingTime', 125.0);
            dashboardData.put('languageBreakdown', languageBreakdown);
            dashboardData.put('queueBreakdown', queueBreakdown);
            dashboardData.put('recentMetrics', new List<Object>());
            
            return dashboardData;
            
        } catch (Exception e) {
            throw new AuraHandledException('Error loading dashboard data: ' + e.getMessage());
        }
    }
    
    private static String analyzeLanguageFromDescription(String description) {
        if (String.isBlank(description)) return 'Unknown';
        
        String lowerDesc = description.toLowerCase();
        if (lowerDesc.contains('ik ') || lowerDesc.contains('het ') || lowerDesc.contains('een ')) return 'Dutch';
        else if (lowerDesc.contains('ich ') || lowerDesc.contains('der ') || lowerDesc.contains('ein ')) return 'German';
        else if (lowerDesc.contains('je ') || lowerDesc.contains('le ') || lowerDesc.contains('une ')) return 'French';
        else if (lowerDesc.contains('el ') || lowerDesc.contains('la ') || lowerDesc.contains('con ')) return 'Spanish';
        else return 'English';
    }
    
    @AuraEnabled
    public static String triggerTestRouting() {
        try {
            Case testCase = new Case(
                Subject = 'Dashboard Test - Live Routing',
                Description = 'Dit is een test case om de automatische routering te demonstreren.',
                Origin = 'Web'
            );
            
            insert testCase;
            
            Case routedCase = [SELECT Id, OwnerId, Owner.Name FROM Case WHERE Id = :testCase.Id LIMIT 1];
            return 'Test case created successfully. Routed to: ' + routedCase.Owner.Name;
            
        } catch (Exception e) {
            throw new AuraHandledException('Test routing failed: ' + e.getMessage());
        }
    }
}
