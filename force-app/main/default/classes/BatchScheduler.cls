public with sharing class BatchScheduler implements Schedulable {
    public void execute (SchedulableContext ctx) {
        BatchCreateCallOnAccountWithoutOrder batch = new BatchCreateCallOnAccountWithoutOrder();
        Id batchId = Database.executeBatch(batch);
    }
}
