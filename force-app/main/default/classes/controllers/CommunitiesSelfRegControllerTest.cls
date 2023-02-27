/**
 * An apex page controller that supports self registration of users in communities that allow self registration
 */
// TODO: テストのassert部分を修正
@IsTest public with sharing class CommunitiesSelfRegControllerTest {
    @IsTest(SeeAllData=true)
    public static void testRegisterUser() {
        UserToken__c token = [SELECT Id FROM UserToken__c limit 1];

        CommunitiesSelfRegController controller = new CommunitiesSelfRegController(token.Id);
        controller.password = 'test12345';
        controller.confirmPassword = 'test12345';

        PageReference result = controller.registerUser();

        System.assert(result != System.Page.CommunitiesSelfReg, '[正常系] マイページアカウント発行処理');
    }

    @IsTest(SeeAllData=true)
    public static void testIsValidPassword() {
        UserToken__c token = [SELECT Id FROM UserToken__c limit 1];

        CommunitiesSelfRegController controller = new CommunitiesSelfRegController(token.Id);
        controller.password = 'test';
        controller.confirmPassword = 'password';

        PageReference result = controller.registerUser();

        System.assert(result != System.Page.CommunitiesSelfReg, '[異常系] password, confirmPasswordの入力値が異なる処理');
    }

    @IsTest(SeeAllData=true)
    public static void testRegisterUserExceptionNonConstructor() {
        CommunitiesSelfRegController controller = new CommunitiesSelfRegController();
        controller.password = 'test12345';
        controller.confirmPassword = 'test12345';
        PageReference result = controller.registerUser();

        System.assert(result != System.Page.CommunitiesSelfReg, '[正常系] マイページアカウント発行処理');
    }
}
