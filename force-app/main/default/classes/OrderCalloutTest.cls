@IsTest
private class OrderCalloutTest {
    @TestSetup
    static void createData(){
        // retrieve record type id of person account
        Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();

        // create person account
        Account acc = new Account(
            RecordTypeId = personAccountRecordTypeId,
            FirstName = 'Max',
            LastName = 'Mustermann',
            PersonEmail = 'test@test.com'
        );
        insert acc;

        // create contract
        Contract contr = new Contract(
            AccountId = acc.Id
        );
        insert contr;

        // create order
        Order ord = new Order(
            AccountId = acc.Id,
            ContractId = contr.Id,
            Status = 'Draft',
            EffectiveDate = System.today()
        );
        insert ord;
    }

    @IsTest
    static void testCallout() {
        // set mocked API response
        Test.setMock(HttpCalloutMock.class, new OrderCalloutMock());

        List<Id> orderIds = new List<Id>();

        // query test orders
        for (Order orderItem : [SELECT Id FROM Order]) {
            orderIds.add(orderItem.Id);
        }

        Test.startTest();

        // invoke tested method
        HttpResponse response = OrderCallout.makeCallout(orderIds);

        Test.stopTest();

        // Verify response received contains fake values
        System.assert(response.getHeader('Content-Type') == 'application/json', 'Content type of the request should be of type "application/json".');
        System.assertEquals(response.getBody(), '{"recieved":"true"}', 'The body of the response is not what was expected.');
        System.assertEquals(200, response.getStatusCode(), 'The status of the response should be 200');
    }
}


