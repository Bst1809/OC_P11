trigger OrderTrigger on Order (before update, after insert, after delete) {
    if (trigger.isBefore) {
        OrderHandler.orderStatusValidation(trigger.new);
    }
    if (trigger.isAfter) {
        if (trigger.isInsert) {
            OrderHandler.accountStatusIsActive(trigger.new);
        }
        if (trigger.isDelete) {
            OrderHandler.accountStatusIsInactive(trigger.old);
        }
       
    }
}
