public with sharing class CreateExperienceUser {
    // public String firstName {get; set;}
    // public String lastName {get; set;}
    // public String email {get; set;}
    // static final String DEFAULT_PASSWORD_VALUE = null;

    @InvocableMethod(label='Experience Cloudユーザーの作成')
    public static void createUser(List<CreateExperienceUserRequest> request) {
        TalentActivity__c talentActivity;
        //TODO: DIでも実現可能か
        // Repository repository = new Repository('プロパティだあああ');

        System.debug('try~catch: a040T000005Jzl5QAC');
        talentActivity = [SELECT Id, Remarks__c FROM TalentActivity__c WHERE Id = :request[0].talentActivityId LIMIT 1];
        System.debug(talentActivity);

        System.debug('【デバッグ】talentActivityRepository');
        TalentActivityRepository talentActivityRepository = new TalentActivityRepository();
        System.debug(talentActivityRepository);


        // try {
        //     talentActivity = repository.talentActivityRepository.getById(request[0].talentActivityId);
        //     System.debug('【debug】talentActivity');
        //     System.debug(LoggingLevel.INFO, talentActivity);
        // } catch (Exception e) {
        //     System.debug(Logginglevel.ERROR, e);
        // }
    }

    public class CreateExperienceUserRequest {
        @InvocableVariable(description='取引先ID')
        public ID accountId;

        @InvocableVariable(description='取引先責任者ID')
        public ID contactId;

        @InvocableVariable(description='人材活動ID')
        public ID talentActivityId;
    }

    public class Repository {
        public TalentActivityRepository talentActivityRepository;

        public Repository(String props) {
            this.talentActivityRepository = new TalentActivityRepository();
        }
    }
}
