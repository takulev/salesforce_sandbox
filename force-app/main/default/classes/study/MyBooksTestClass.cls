@isTest
public with sharing class MyBooksTestClass {
    @isTest
    static testMethod void validateMyBooks() {
        Book__c book = new Book__c(Name='Behind the Cloud', Price__c=100);

        // Insert book
        insert book;
        System.debug(LoggingLevel.DEBUG, 'テストだよ');

        Book__c book2 = [SELECT Price__c FROM Book__c WHERE Id = :book.Id];

        // Confirm that the price has been updated correctyly
        System.assertEquals(100, book2.Price__c);
    }
}
