trigger MyBooksTrigger on SOBJECT (before insert) {
    Book__c[] books = Trigger.new;

    MyBooks.applyDiscount(books);
}
