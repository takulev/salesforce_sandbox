/**
 * An apex page controller that supports self registration of users in communities that allow self registration
 */
// TODO: テストのassert部分を修正
@IsTest public with sharing class CommunitiesSelfRegControllerTest {
    @IsTest(SeeAllData=true)
    public static void testRegisterUser() {
        TalentActivity__c talentActivity = [SELECT Id FROM TalentActivity__c limit 1];

        CommunitiesSelfRegController controller = new CommunitiesSelfRegController(talentActivity.Id);

        PageReference result = controller.registerUser();

        System.assert(result != System.Page.CommunitiesSelfReg, '[正常系] マイページアカウント発行処理');
    }

    @IsTest(SeeAllData=true)
    public static void testIsValidPassword() {
        TalentActivity__c talentActivity = [SELECT Id FROM TalentActivity__c limit 1];

        CommunitiesSelfRegController controller = new CommunitiesSelfRegController(talentActivity.Id);
        controller.password = 'test';
        controller.confirmPassword = 'password';

        PageReference result = controller.registerUser();

        System.assert(result != System.Page.CommunitiesSelfReg, '[異常系] password, confirmPasswordの入力値が異なる処理');
    }

    @IsTest(SeeAllData=true)
    public static void testRegisterUserException() {
        Talent__c talent = [SELECT Id FROM Talent__c limit 1];

        CommunitiesSelfRegController controller = new CommunitiesSelfRegController(talent.Id);

        PageReference result = controller.registerUser();

        System.assert(System.Page.Exception != result, '[異常系] 不適切な人材活動IDテスト');
    }
}
