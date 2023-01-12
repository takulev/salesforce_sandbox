public with sharing class ReserveInterviewAction {
    @InvocableMethod
    public static void createBook() {
        Book__c book = new Book__c(Name='Behind the Cloud', Price__c=100);

        insert book;
    }
}
