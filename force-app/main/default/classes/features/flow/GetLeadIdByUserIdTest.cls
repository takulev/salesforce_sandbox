@IsTest
public with sharing class GetLeadIdByUserIdTest {
    @IsTest(SeeAllData=true)
    public static void testGetLeadId() {
        TalentActivity__c talentActivity = [SELECT Id FROM TalentActivity__c limit 1];
        CommunitiesSelfRegController controller = new CommunitiesSelfRegController(talentActivity.Id);
        controller.registerUser();

        List<GetLeadIdByUserId.GetLeadIdByUserIdResponse> responses = GetLeadIdByUserId.getLeadId();
        System.assert(responses != null, '[正常系] リードID取得フロー');
    }
}
