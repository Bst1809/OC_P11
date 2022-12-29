public class TestDataFactory {
    public static List<Order> createOrders(Integer numAccounts, Integer numOrdersPerAccount, String ordStatus, Integer numProducts) {

        //Create a product
        Product2 product = new Product2(Name = 'Chemise Verte longue XYX', Family = 'Chemise');
        Insert product;

        //Create the PricebookEntry
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = product.Id,
            UnitPrice = 1020,
            IsActive = true
        );
        Insert pbe;

        //create a pricebook
        Id priceBookId = Test.getStandardPricebookId();

        // Create list of Accounts
        List<Account> accList = new List<Account>();
        for(Integer i=0;i<numAccounts;i++) {
            Account a = new Account(Name='TestAccount' + i);
            accList.add(a);
        }
        insert accList;  

        // For each account just inserted, add one contract
        List<Contract> contList = new List<Contract>();
        for (Integer j=0;j<numAccounts;j++) {
            Account acct = accList[j];
                contList.add(new Contract(
                                        AccountId = acct.Id, 
                                        Status = 'Draft', 
                                        StartDate = Date.today(), 
                                        ContractTerm= 1));
        }
        insert contList;
        for(Contract cont : contList) {
            cont.Status = 'Activated';
        }
        update contList;

        // For each contract just inserted, add orders
        List<Order> orderList = new List<Order>();
        for (Integer k=0;k<numAccounts;k++) {
            Contract cont = contList[k];
            for (Integer l=0;l<numOrdersPerAccount;l++) {
                Order newOrder = new Order(
                                            AccountId = cont.AccountId, 
                                            ContractId = cont.Id, 
                                            EffectiveDate = System.today(), 
                                            Status = 'Draft', 
                                            Pricebook2Id = priceBookId); 
            orderList.add(newOrder);
            }
        }
        insert orderList;

        // For each orders just inserted, add products
        List<OrderItem> itemList = new List<OrderItem>();
        for(Order newOrder : orderList) {
            OrderItem item = new OrderItem (
                                            OrderId = newOrder.Id, 
                                            PricebookEntryId = pbe.Id, 
                                            Quantity= numProducts, 
                                            UnitPrice = 110);
            itemList.add(item);
        }
        insert itemList;

        // Status of orders
        if (ordStatus != 'Draft') {
            for(Order newOrder : orderList) {
                newOrder.status = ordStatus;
            }
            update orderList;
        }
        
        return orderList;
    }

    public static List<Order> createOrdersWithoutProduct(Integer numAccounts, Integer numOrdersPerAccount, String ordStatus) {

        //Create a product
        Product2 product = new Product2(Name = 'Chemise Verte longue XYX', Family = 'Chemise');
        Insert product;

        //Create the PricebookEntry
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = product.Id,
            UnitPrice = 1020,
            IsActive = true
        );
        Insert pbe;

        //create a pricebook
        Id priceBookId = Test.getStandardPricebookId();

        // Create list of Accounts
        List<Account> accList = new List<Account>();
        for(Integer i=0;i<numAccounts;i++) {
            Account a = new Account(Name='TestAccount' + i);
            accList.add(a);
        }
        insert accList;  

        // For each account just inserted, add one contract
        List<Contract> contList = new List<Contract>();
        for (Integer j=0;j<numAccounts;j++) {
            Account acct = accList[j];
                contList.add(new Contract(
                                        AccountId = acct.Id, 
                                        Status = 'Draft', 
                                        StartDate = Date.today(), 
                                        ContractTerm= 1));
        }
        insert contList;
        for(Contract cont : contList) {
            cont.Status = 'Activated';
        }
        update contList;

        // For each contract just inserted, add orders
        List<Order> orderList = new List<Order>();
        for (Integer k=0;k<numAccounts;k++) {
            Contract cont = contList[k];
            for (Integer l=0;l<numOrdersPerAccount;l++) {
                Order newOrder = new Order(
                                            AccountId = cont.AccountId, 
                                            ContractId = cont.Id, 
                                            EffectiveDate = System.today(), 
                                            Status = 'Draft', 
                                            Pricebook2Id = priceBookId); 
            orderList.add(newOrder);
            }
        }
        insert orderList;

        // Status of orders
        if (ordStatus != 'Draft') {
            for(Order newOrder : orderList) {
                newOrder.status = ordStatus;
            }
            update orderList;
        }
        
        return orderList;
    }

    public static List<Account> createAccounts(Integer numAccounts) {
        List<Account> accList = new List<Account>();
        for(Integer i=0;i<numAccounts;i++) {
            Account a = new Account(Name='TestAccount' + i);
            accList.add(a);
        }
        insert accList;  
        return accList;
    }
}