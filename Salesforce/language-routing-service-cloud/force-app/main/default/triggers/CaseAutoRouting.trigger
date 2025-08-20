trigger CaseAutoRouting on Case (before insert, before update) {
    if (!CaseAutoRoutingHandler.isProcessing) {
        CaseAutoRoutingHandler.handleCaseRouting(Trigger.new, Trigger.oldMap);
    }
}
