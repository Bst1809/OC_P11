public with sharing class OrderHandler {

    public static void orderStatusValidation (List<Order> ordersList) {
        // Iterate over triggered orders and add error when both conditions are met.
        // Number_Of_Products__c is a custom rollup field that counts products in orders.
        for (Order newOrder : ordersList) {
            if (newOrder.status == 'Activated' && newOrder.Number_Of_Products__c == 0) {
                newOrder.addError('Bastien says : add some products');
            }
        }
    }

    public static void accountStatusIsActive (List<Order> ordersList) {
        // Place the Ids of the accounts concerned by the trigger in a Set
        set<Id> setAccountIds = new set<Id>();
        for (Order newOrder : ordersList) {
            setAccountIds.add(newOrder.AccountId);
        }
        // Create a list of a Accounts that matches the previous Set of Ids
        List<Account> accList = [ SELECT Id, Active__c, 
                                (SELECT Id, AccountId FROM Orders) 
                                FROM Account WHERE Id IN : setAccountIds ];

        // Iterate over this account list and set Active__c status to true  
        for(Account accToUpdate : accList){
                accToUpdate.Active__c = true;
            }
        // Update list of Accounts
        update accList;  
    }

    public static void accountStatusIsInactive (List<Order> ordersList) {

        // Get the Ids of the accounts concerned by the trigger with a for loop
        set<Id> setAccountIds = new set<Id>();
        for (Order newOrder : ordersList) {
            setAccountIds.add(newOrder.AccountId);
        }
        // Create a list of a Accounts that matches the previous setAccountIds set
        // AND has no orders
        List<Account> accList = [ SELECT Id, Active__c 
                                FROM Account WHERE Id IN : setAccountIds 
                                AND Id NOT IN (SELECT AccountId From Order)];

         // Iterate over this account list and set Active__c status to true  
        for(Account accToUpdate : accList){
            accToUpdate.Active__c = false;
        }
        update accList; 
    }

}

