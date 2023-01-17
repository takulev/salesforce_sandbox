public with sharing class CreateExperienceUser {
    // public String firstName {get; set;}
    // public String lastName {get; set;}
    // public String email {get; set;}
    // static final String DEFAULT_PASSWORD_VALUE = null;

    @InvocableMethod(label='Experience Cloudユーザーの作成')
    public static void createUser(List<CreateExperienceUserRequest> request) {
        TalentActivity__c talentActivity;
        TalentActivityRepository talentActivityRepository = new TalentActivityRepository();

        try {
            talentActivity = talentActivityRepository.getById(request[0].talentActivityId);
            System.debug('【debug】talentActivity');
            System.debug(LoggingLevel.INFO, talentActivity);


            // TODO: service層に、マイページのサービスクラスを作成する。そのクラスからアカウント発行を行う
        } catch (Exception e) {
            System.debug(Logginglevel.ERROR, e);
        }
    }

    public class CreateExperienceUserRequest {
        @InvocableVariable(description='取引先ID')
        public ID accountId;

        @InvocableVariable(description='取引先責任者ID')
        public ID contactId;

        @InvocableVariable(description='人材活動ID')
        public ID talentActivityId;
    }
}
