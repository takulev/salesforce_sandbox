@isTest
public with sharing class CreateExperienceUserTest {
    @isTest
    static void validateCreateExperienceCloudUser() {
        List<TalentActivity__c> testers = [SELECT Id FROM TalentActivity__c];

        TalentActivityRepository talentActivityRepository = new TalentActivityRepository();
        TalentActivity__c talentActivity = talentActivityRepository.getById(testers[0].Id);

        System.assertEquals(talentActivity.id, testers[0].Id);
    }
}
