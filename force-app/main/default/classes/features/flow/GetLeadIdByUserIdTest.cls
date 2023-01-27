@IsTest
public with sharing class GetLeadIdByUserIdTest {
    @IsTest(SeeAllData=true)
    public static void testGetLeadId() {
        ExternalUser__c externalUser = [SELECT Id, User__c FROM ExternalUser__c ORDER BY ID DESC limit 1];
        User user = [SELECT Id FROM User WHERE ID = :externalUser.User__c];
        Test.startTest();
            System.runAs(user){
                List<GetLeadIdByUserId.GetLeadIdByUserIdResponse> responses = GetLeadIdByUserId.getLeadId();
                System.assert(responses != null, '[正常系] リードID取得フロー');
            }
        Test.stopTest();
    }
}
