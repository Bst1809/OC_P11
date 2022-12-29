global class BatchCreateCallOnAccountWithoutOrder implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext bc) {
        // To collect accounts with no order and no call to be passed to execute :
        // First get a set of Accounts with call tasks
        Set<Id> accsWithCalls = new Set<Id>();
        for (Task t : [SELECT WhatId FROM Task WHERE What.type = 'Account' AND Type = 'Call']) {
            accsWithCalls.add(t.whatId);
        }
        // Then query Accounts where Ids are neither in our accsWithCalls set nor in AccountId from Orders
        // We will then have a list of Accounts without Orders or Calls to. This is our scope. 
        return Database.getQueryLocator
        ([SELECT Id, OwnerId FROM Account WHERE Id NOT IN (SELECT AccountId FROM Order) AND Id NOT IN :accsWithCalls]);
    }

    global void execute(Database.BatchableContext bc, List<Account> scope) {
        // Add Calls to the all accounts in our scope
        TaskReminder.addTaskToAccounts(scope);
    }

    global void finish(Database.BatchableContext bc){
        // Nothing to do after the process
    }

}
