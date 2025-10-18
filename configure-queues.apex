// Get all our language queues
List<Group> languageQueues = [
    SELECT Id, DeveloperName 
    FROM Group 
    WHERE Type = 'Queue' 
    AND DeveloperName IN ('Dutch_Support_Queue', 'German_Support_Queue', 'French_Support_Queue', 'Spanish_Support_Queue', 'English_Support_Queue', 'Multilingual_Overflow_Queue')
];

System.debug('📋 Found ' + languageQueues.size() + ' language queues');

// Check which queues already support Case
List<QueueSobject> existingQueueSobjects = [
    SELECT QueueId, SobjectType 
    FROM QueueSobject 
    WHERE SobjectType = 'Case' 
    AND QueueId IN :new List<Id>(new Map<Id, Group>(languageQueues).keySet())
];

Set<Id> queuesWithCase = new Set<Id>();
for (QueueSobject qs : existingQueueSobjects) {
    queuesWithCase.add(qs.QueueId);
}

System.debug('✅ Queues already supporting Case: ' + queuesWithCase.size());

// Add Case support to queues that don't have it
List<QueueSobject> queueSobjectsToInsert = new List<QueueSobject>();

for (Group queue : languageQueues) {
    if (!queuesWithCase.contains(queue.Id)) {
        System.debug('➕ Adding Case support to: ' + queue.DeveloperName);
        queueSobjectsToInsert.add(new QueueSobject(
            QueueId = queue.Id,
            SobjectType = 'Case'
        ));
    } else {
        System.debug('✅ ' + queue.DeveloperName + ' already supports Case');
    }
}

if (!queueSobjectsToInsert.isEmpty()) {
    try {
        insert queueSobjectsToInsert;
        System.debug('🎉 Successfully added Case support to ' + queueSobjectsToInsert.size() + ' queues');
    } catch (Exception e) {
        System.debug('❌ Error adding Case support: ' + e.getMessage());
    }
} else {
    System.debug('✅ All queues already support Case objects');
}
