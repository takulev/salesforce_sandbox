public with sharing class ExternalUserService {
    static final ID accountId = '0010T00000QXufwQAD';
    static final ID profileId = '00e0T000000MS7RQAW';

    private TalentRepository talentRepository;
    private TalentActivityRepository talentActivityRepository;

    public ExternalUserService() {
        this.talentRepository = new TalentRepository();
        this.talentActivityRepository = new TalentActivityRepository();
    }

    public String createAccount(ID talentActivityId, String password) {
        TalentActivity__c talentActivity = this.talentActivityRepository.getById(talentActivityId);
        Talent__c talent = this.talentRepository.getById(talentActivity.TalentName__c);
        User user = this.buildUser(talent, talentActivity, profileId);

        System.debug(LoggingLevel.INFO, 'talentActivity: ' + talentActivity);
        System.debug(LoggingLevel.INFO, 'talent: ' + talent);
        System.debug(LoggingLevel.INFO, 'user: ' + user);

        String userId = '';
        try {
            System.debug(LoggingLevel.INFO, 'createExternalUser: ' + user);
            userId = Site.createExternalUser(user, accountId, password);
            System.debug(LoggingLevel.INFO, 'createExternalUser: ' + userId);

            // 人材活動オブジェクトにuserIdを保存

        } catch(Site.ExternalUserCreateException e) {
            List<String> errors = e.getDisplayMessages();
            System.debug(LoggingLevel.INFO, 'errors: ' + errors);

            //TODO: 調査
            for (String error : errors)  {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, error));
            }

            System.debug(LoggingLevel.INFO, 'errors: ' + e.getMessage());
        }

        return userId;
    }

    private User buildUser(Talent__c talent, TalentActivity__c talentActivity, ID profileId) {
        User user = new User();

        user.Username = talent.Name;
        user.LastName = talent.Name;
        user.CommunityNickname = talent.Name;
        user.Email = 'takuya.nakamatsu+'+Datetime.now().format('yyyyMMddHMS')+'@leverages.jp';

        //TODO: コメントアウト外す
        // user.Email = talentActivity.Email__c;
        user.ProfileId = profileId;

        return user;
    }
}
