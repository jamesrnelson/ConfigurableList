public with sharing class LwcRecordController {
    @AuraEnabled(cacheable=true) 
    public static List<SObject> doQuery(String soql) {
        try {
            return Database.query(soql);
        } catch (Exception ex) {
            throw new AuraHandledException('There was an error processing your request: ' + ex.getMessage() + '. Stack Trace: ' + ex.getStackTraceString()); 
        }
    }

    @AuraEnabled
    public static List<SObject> doUncachedQuery(String soql) {
        try {
            return Database.query(soql);
        } catch (Exception ex) {
            throw new AuraHandledException('There was an error processing your request: ' + ex.getMessage() + '. Stack Trace: ' + ex.getStackTraceString()); 
        }
    }

    
    @AuraEnabled
    public static string updateOpps(List<Opportunity> data){
        try {
            update data;
            return 'Success: Opportunities updated';
        } catch (Exception e) {
            throw new AuraHandledException('Error while updating opportinity records' + e.getMessage());
        }
    }

    @AuraEnabled
    public static void sendEmailOppChangeRequest(String emailBody, String toEmail, String emailSubject){

        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        String[] to = new String[] {toEmail};

        email.setToAddresses(to);
        email.setSubject(emailSubject);
        email.setHtmlBody(emailBody);
        try {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<String> getFieldPicklistValues(String objectApiName, String fieldApiName){
        List<String> picklistValues = new List<String>();
        
        try {
            //get all objects
            Map<String, Schema.sObjectType> gd = Schema.getGlobalDescribe();
            //retrieve object type
            Schema.sObjectType targetType = gd.get(objectApiName);
            //retrieve all fields on object
            Map<String, Schema.sObjectField> fieldMap = targetType.getDescribe().fields.getMap();
            //get only field being passed into method
            Schema.sObjectField targetField = fieldMap.get(fieldApiName);
            Schema.DescribeFieldResult fieldResult = targetField.getDescribe();
            //get picklist values for field
            List<Schema.PicklistEntry> allPicklistValues = fieldResult.getPicklistValues();
            for(Schema.PicklistEntry value : allPicklistValues) {
                if (value.isActive()) {
                    System.debug('value: ' + value.getLabel());
                    picklistValues.add(value.getLabel());
                }
            }
            return pickListValues;
        } catch (Exception e) {
            throw new AuraHandledException('There was an error retrieving picklist values for ' + fieldApiName + ' on the ' + objectApiName + ' object. : ' +  + e.getMessage());
        }
        
    }
    
}