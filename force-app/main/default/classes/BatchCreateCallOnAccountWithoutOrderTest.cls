@isTest
public with sharing class BatchCreateCallOnAccountWithoutOrderTest {
    @TestSetup
    static void setup(){
        TestDataFactory df = new TestDataFactory();
    }
    @isTest
    static void testBatchAddTaskToAccounts(){
        // Create Account with Orders
        TestDataFactory.createOrders(10, 10, 'Activated', 1);
        List<Account> accsWithOrders = [SELECT Id FROM Account WHERE Name LIKE 'TestAccount%'];
        // Create Accounts without Orders and without calls
        List<Account> accsWithoutCalls = TestDataFactory.createAccounts(10);
        // Execute the batch
        Test.startTest();
        BatchCreateCallOnAccountWithoutOrder batch = new BatchCreateCallOnAccountWithoutOrder();
        Id batchId = Database.executeBatch(batch);
        Test.stopTest();
        // Create the list of tasks with ID from accsWithoutCalls Accounts
        // The size of this list should be 10 as 10 accounts were created
        List<Task> updatedAccsWithNewCalls = [SELECT Id FROM Task WHERE WhatId IN:accsWithoutCalls ];
        // Create the list of tasks with ID from accsWithOrders Accounts
        // The size of this list should be 0 as they had orders attached and should not be processed
        List<Task> updatedAccsWithoutCalls = [SELECT Id FROM Task WHERE WhatId IN:accsWithOrders ];
        // Assertions check 
        System.assertEquals(10, updatedAccsWithNewCalls.size());
        System.assertEquals(0, updatedAccsWithoutCalls.size());

    }

    @isTest
    static void testBatchAddTaskTo200Accounts(){
        // testBatchAddTaskToAccounts processed with 200 Accounts created with 1 order each
        TestDataFactory.createOrders(200, 1, 'Activated', 1);
        List<Account> accsWithOrders = [SELECT Id FROM Account WHERE Name LIKE 'TestAccount%'];
        List<Account> accsWithoutCalls = TestDataFactory.createAccounts(200);
        Test.startTest();
        BatchCreateCallOnAccountWithoutOrder batch = new BatchCreateCallOnAccountWithoutOrder();
        Id batchId = Database.executeBatch(batch);
        Test.stopTest();
        List<Task> updatedAccsWithCalls = [SELECT Id FROM Task WHERE WhatId IN:accsWithoutCalls ];
        List<Task> updatedAccsWithoutCalls = [SELECT Id FROM Task WHERE WhatId IN:accsWithOrders ];
        System.assertEquals(200, updatedAccsWithCalls.size());
        System.assertEquals(0, updatedAccsWithoutCalls.size());
    }
}
