@isTest
public with sharing class OrderHandlerTest {
    @TestSetup
    static void setup(){
        TestDataFactory df = new TestDataFactory();
    }

    @isTest
    private static void orderStatusValidationTest() {
            Order orderTest = TestDataFactory.createOrdersWithoutProduct(1, 1, 'Draft')[0];
            orderTest.Status = 'Activated';
            try {
            update orderTest;
            } catch(Exception e) {}
            Order temp = [SELECT Id, status FROM Order WHERE Id =: orderTest.id LIMIT 1];     
        System.assert(temp.Status == 'Draft', 'Problem : status is not Draft');
    }

    @isTest
    private static void accountStatusIsActiveTest() {
        TestDataFactory.createOrders(1, 1, 'Draft', 1);
        Account singleAccount = [ SELECT Id, Active__c FROM Account WHERE Name LIKE 'TestAccount%' LIMIT 1 ];
        System.assertEquals(true, singleAccount.Active__c);

    }

    @isTest
    private static void accountStatusIsInactiveTest() {
        List<Order> orderTest = TestDataFactory.createOrders(1, 1, 'Draft', 1);
        delete orderTest;
        Account singleAccount = [ SELECT Id, Active__c FROM Account WHERE Name LIKE 'TestAccount%' AND Id =: orderTest[0].AccountId LIMIT 1 ];
        System.assertEquals(false, singleAccount.Active__c);

    }

    @isTest
    private static void accountStatusIsStillActiveTest() {
        List<Order> orderTest = TestDataFactory.createOrders(1, 2, 'Draft', 1);
        Order singleOrder = [SELECT Id FROM Order WHERE Account.Name LIKE 'TestAccount%' LIMIT 1 ];
        delete singleOrder;
        Account singleAccount = [ SELECT Id, Active__c FROM Account WHERE Name LIKE 'TestAccount%' AND Id =: orderTest[0].AccountId LIMIT 1 ];
        System.assertEquals(true, singleAccount.Active__c);

    }

}
