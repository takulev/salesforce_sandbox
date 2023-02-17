public with sharing class MyBooks {
    public static void applyDiscount(Book__c[] books) {
        for (Book__c book : books) {
                System.debug(LoggingLevel.DEBUG, book);
                System.debug(LoggingLevel.DEBUG, 'テストだよ');
                book.Price__c *= 0.9;
        }
    }
}