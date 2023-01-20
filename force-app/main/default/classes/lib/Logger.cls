public class Logger {
    public static void info(String content) {
        System.debug(Logginglevel.INFO, 'Logger Class');
        System.debug(Logginglevel.INFO, content);
    }

    /**
     * DBの
     */
    public static void db(String content) {
        System.debug(Logginglevel.INFO, 'Logger Class');
        System.debug(Logginglevel.INFO, content);

        Book__c book = new Book__c(Name='debug'+Datetime.now().format('yyyyMMddHMS'), Debug__c=content);

        insert book;
    }
}
