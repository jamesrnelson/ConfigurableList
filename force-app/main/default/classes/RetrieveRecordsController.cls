public with sharing class RetrieveRecordsController {
    @AuraEnabled
    public static string doQuery(String soql) {
        return JSON.serialize(Database.query(soql));
    }

    @AuraEnabled(cacheable=true)
    public static Boolean doesUserHavePermission(Id userId, String permissionName) {
        Set<Id> permissionSetIds = new Set<Id>();
        for (SetupEntityAccess access : [
            SELECT ParentId 
            FROM SetupEntityAccess 
            WHERE SetupEntityId IN (
                SELECT Id 
                FROM CustomPermission 
                WHERE DeveloperName = :permissionName
            )
        ]) {
            permissionSetIds.add(access.ParentId);
        }

        Map<Id,User> userIds = new Map<Id,User> ([
            SELECT Id, Username FROM User WHERE Id IN (
                SELECT AssigneeId FROM PermissionSetAssignment
                WHERE PermissionSetId IN :permissionSetIds
            )
        ]);
        
        Boolean hasAccess = userIds.containsKey(userId);
        return hasAccess;
    }
}