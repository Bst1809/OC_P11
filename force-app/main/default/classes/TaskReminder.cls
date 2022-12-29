public with sharing class TaskReminder {
    public static void addTaskToAccounts(List<Account> accList) {
        List<Task> tskList = new List<Task>();
        for(Account a : accList) {
                Task tsk = new Task();
                tsk.subject = 'Call';
                tsk.Status = 'Open';
                tsk.Priority = 'Normal';
                tsk.WhatId = a.Id;
                tsk.OwnerId = a.OwnerId;
                tskList.add(tsk);
        }
        if (tskList!=null && tskList.size() > 0) {
            insert tskList;
            }
    }
}
