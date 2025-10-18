({
    doInit: function(component, event, helper) {
        helper.loadDashboardData(component);
    },
    
    refreshData: function(component, event, helper) {
        component.set("v.isLoading", true);
        helper.loadDashboardData(component);
    },
    
    testRouting: function(component, event, helper) {
        component.set("v.isLoading", true);
        
        var action = component.get("c.triggerTestRouting");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                helper.showToast("success", "Test Successful", result);
                
                // Refresh data after test
                setTimeout(function() {
                    helper.loadDashboardData(component);
                }, 2000);
                
            } else if (state === "ERROR") {
                var errors = response.getError();
                var message = 'Unknown error';
                if (errors && errors[0] && errors[0].message) {
                    message = errors[0].message;
                }
                helper.showToast("error", "Test Failed", message);
                component.set("v.isLoading", false);
            }
        });
        
        $A.enqueueAction(action);
    }
})
