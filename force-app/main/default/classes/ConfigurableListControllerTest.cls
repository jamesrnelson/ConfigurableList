@IsTest
private class ConfigurableListControllerTest {
    @IsTest
    static void testCanLoadRelatedRecords(){
        Account account = new Account(Name='Main Test Account');
        insert account;

        List<Contact> contacts = new List<Contact>();

        for(Integer i = 0; i < 10; i++) {
            Contact contact = new Contact(AccountId=account.Id, LastName = 'TestContact' + i);
            contacts.add(contact);
        }

        insert contacts;

        List<String> columnsToRetrieve = new List<String>{'Name', 'CreatedDate'};
        String relationshipName = 'Contacts';

        String retrievedAccountWithcontacts;
        Test.startTest();
            retrievedAccountWithcontacts =
                ConfigurableListController.getRelatedListRecords(account.Id, columnsToRetrieve, relationshipName);
        Test.stopTest();
        
        List<Object> parsedAccount = (List<Object>)JSON.deserializeUntyped(retrievedAccountWithcontacts);
        Map<String,Object> parsedcontactsMap = (Map<String,Object>)parsedAccount[0];
        Map<String,Object> parsedcontactsListMap = (Map<String,Object>)parsedcontactsMap.get('Contacts');
        List<Object> parsedcontactsList = (List<Object>)parsedcontactsListMap.get('records');
        System.assertEquals(1, parsedAccount.size());
        System.assertEquals(10, parsedcontactsList.size());
    }

    @IsTest
    static void testRetrievesColumnLabels(){
        Account account = new Account(Name='Main Test Account');
        insert account;

        Contact contact = new Contact(AccountId=account.Id,  LastName = 'TestContact1');
        insert contact;

        List<String> columnsToRetrieve = new List<String>{'Name', 'CreatedDate'};
        String response;
        Test.startTest();
            response = ConfigurableListController.getChildObjectInfo(contact.Id, columnsToRetrieve);
        Test.stopTest();

        ConfigurableListController.ChildObjectInfoWrapper columnLabels =
            (ConfigurableListController.ChildObjectInfoWrapper)JSON.deserialize(
                response,
                ConfigurableListController.ChildObjectInfoWrapper.class
            );

        System.assertEquals(2, columnLabels.columnLabels.size());
        System.assertEquals('Created Date', columnLabels.columnLabels[1]);
    }
}