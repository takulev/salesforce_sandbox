@IsTest
public with sharing class GetAccountIdByUserIdTest {
    @IsTest(SeeAllData=true)
    public static void testGetAccountId() {
        ExternalUser__c externalUser = [SELECT Id, User__c FROM ExternalUser__c ORDER BY ID DESC limit 1];
        User user = [SELECT Id FROM User WHERE ID = :externalUser.User__c];
        Test.startTest();
            System.runAs(user){
                List<GetAccountIdByUserId.GetAccountIdByUserIdResponse> responses = GetAccountIdByUserId.getAccountId();
                System.assert(responses != null, '[正常系] 取引先ID取得フロー');
            }
        Test.stopTest();
    }
}
