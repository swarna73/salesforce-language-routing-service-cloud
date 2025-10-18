({
    loadDashboardData: function(component) {
        var action = component.get("c.getDashboardData");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                
                // Add display values with proper rounding
                data.successRateDisplay = Math.round(data.successRate * 10) / 10;
                data.avgConfidenceDisplay = Math.round(data.avgConfidence * 100 * 10) / 10;
                data.avgProcessingTimeDisplay = Math.round(data.avgProcessingTime);
                
                // Transform language and queue breakdown from map to array for iteration
                var languageArray = this.mapToArrayWithPercentage(data.languageBreakdown, data.totalCases);
                var queueArray = this.mapToArrayWithPercentage(data.queueBreakdown, data.totalCases);
                
                data.languageBreakdown = languageArray;
                data.queueBreakdown = queueArray;
                
                component.set("v.dashboardData", data);
                component.set("v.lastUpdated", new Date().toLocaleTimeString());
                component.set("v.isLoading", false);
                
                console.log("Dashboard data loaded:", data);
                
            } else if (state === "ERROR") {
                var errors = response.getError();
                var message = 'Unknown error';
                if (errors && errors[0] && errors[0].message) {
                    message = errors[0].message;
                }
                this.showToast("error", "Data Load Error", message);
                component.set("v.isLoading", false);
            }
        });
        
        $A.enqueueAction(action);
    },
    
    mapToArrayWithPercentage: function(mapData, total) {
        var array = [];
        if (mapData && total > 0) {
            for (var key in mapData) {
                if (mapData.hasOwnProperty(key)) {
                    var percentage = Math.round((mapData[key] / total) * 100);
                    array.push({
                        key: key,
                        value: mapData[key],
                        percentage: percentage
                    });
                }
            }
        }
        return array;
    },
    
    showToast: function(type, title, message) {
        var toastEvent = $A.get("e.force:showToast");
        if (toastEvent) {
            toastEvent.setParams({
                type: type,
                title: title,
                message: message,
                duration: 3000
            });
            toastEvent.fire();
        } else {
            console.log(type.toUpperCase() + ": " + title + " - " + message);
        }
    }
})
