@IsTest
private class GetRecordsControllerTest {
    @IsTest
    static void testCanGetRecords(){
        String NAME_TO_VERIFY = 'Anonymous Contact';

        Contact con = new Contact(LastName=NAME_TO_VERIFY);
        insert con;

        String query = 'SELECT Id, Name FROM Contact WHERE Name= \'' + NAME_TO_VERIFY + '\'';
        String jsonResponse;
        Test.startTest();
            jsonResponse = GetRecordsController.doQuery(query);
        Test.stopTest();
        
        List<Object> parsedContact = (List<Object>)JSON.deserializeUntyped(jsonResponse);
        Map<String,Object> parsedContactMap = (Map<String,Object>)parsedContact[0];
        System.assertEquals(1, parsedContact.size(), 'We expect to Get records based on the soql query');
        System.assertEquals(NAME_TO_VERIFY, parsedContactMap.get('Name'), 'We expect to have values for fields in the query');
    }

    static testmethod void test_GetPermissionsAccess()  {
        User u1 = new User(
                ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
                LastName = 'TestUser1',
                Email = 'testuseremail@email.com',
                Username = 'testuseremail@email.com.dki1' + System.currentTimeMillis(),
                CompanyName = 'TEST',
                Title = 'title',
                Alias = 'alias',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US'
        );
        insert u1;
        PermissionSet permSet = [SELECT Id, Name FROM PermissionSet WHERE Name='Configurable_List_User_Permission_Set' LIMIT 1];
        CustomPermission developerLwc = [SELECT Id, DeveloperName FROM CustomPermission WHERE DeveloperName = 'Configurable_List_User' LIMIT 1];
        PermissionSetAssignment permSetAssignment = new PermissionSetAssignment(AssigneeId = u1.Id, PermissionSetId = permSet.Id);
        insert permSetAssignment;
        Boolean hasAccess;
        Test.startTest();
        hasAccess = GetRecordsController.doesUserHavePermission(u1.Id, 'Configurable_List_User');
        Test.stopTest();
        System.assertEquals(true, hasAccess, 'We expect the user to have the custom permission once the permission set has been assigned.');
    }
}