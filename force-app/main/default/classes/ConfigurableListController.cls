public with sharing class ConfigurableListController {

    @AuraEnabled
    public static string getRelatedListRecords(Id recordId, List<String> columns, String childRelationshipName){
        List<String> filteredColumns = new List<String>();
        for (String column : columns){
            if (string.isNotBlank(column)){
                filteredColumns.add(column);
            }
        }
        
        Schema.SObjectType objectName = recordId.getSobjectType();        

        String queryString = 'SELECT Id, (SELECT Id, ' + String.join(filteredColumns,', ') + ' FROM ' + childRelationshipName + 
            ') FROM ' + objectName +
            ' WHERE Id = \'' + recordId + '\'';

        List<SObject> relatedRecords = Database.query(queryString);

        return JSON.serialize(relatedRecords);
    }

    @AuraEnabled
    public static string getChildObjectInfo(Id recordId, List<String> columns){
        List<String> filteredColumns = new List<String>();
        for (String column : columns){
            if (string.isNotBlank(column)){
                filteredColumns.add(column);
            }
        }
      
        Schema.SObjectType objectName = recordId.getSobjectType(); 
        Map<String, Schema.SObjectField> objectFields = objectName.getDescribe().fields.getMap();

        List<String> fieldErrors = new List<String>();
        List<String> columnLabels = new List<String>();

        for (String field : filteredColumns) {
            if (objectFields.get(field) == null) {
                fieldErrors.add(field);
            } else {
                Schema.SObjectField objField = objectFields.get(field);
                String label = objField.getDescribe().getLabel();
                columnLabels.add(label);
            }
        }

        ConfigurableListController.ChildObjectInfoWrapper wrapper = 
            new ConfigurableListController.ChildObjectInfoWrapper(columnLabels);

        return JSON.serialize(wrapper);
    }

    

    public class ChildObjectInfoWrapper{
        public list<String> columnLabels;

        public ChildObjectInfoWrapper(List<String> columnLabels){
            this.columnLabels = columnLabels;
        }
    }

}