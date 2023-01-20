public without sharing class ExternalUserService {
    static final ID accountId = '0010T00000QXufwQAD';
    static final ID profileId = '00e0T000000MS7RQAW';

    private WSTalentRepository talentRepository;
    private WSTalentActivityRepository talentActivityRepository;

    public ExternalUserService() {
        this.talentRepository = new WSTalentRepository();
        this.talentActivityRepository = new WSTalentActivityRepository();
    }

    public String createAccount(ID talentActivityId, String password, String email) {
        TalentActivity__c talentActivity = this.talentActivityRepository.getById(talentActivityId);
        Talent__c talent = this.talentRepository.getById(talentActivity.TalentName__c);
        User user = this.buildUser(talent, talentActivity, email);

        String userId = '';

        System.debug(LoggingLevel.INFO, 'talentActivity: ' + talentActivity);
        System.debug(LoggingLevel.INFO, 'talent: ' + talent);
        // System.debug(LoggingLevel.INFO, 'user: ' + user);

        try {
            System.debug(LoggingLevel.INFO, 'createExternalUser user: ' + user);
            // userId = Site.createExternalUser(user, accountId, password);
            userId = Site.createExternalUser(user, accountId);
            System.debug(LoggingLevel.INFO, 'createExternalUser userId: ' + userId);

            // 人材活動オブジェクトにuserIdを保存

        } catch(Site.ExternalUserCreateException e) {
            List<String> errors = e.getDisplayMessages();
            System.debug(LoggingLevel.INFO, 'errors: ' + errors);
            Logger.db('errors: ' + errors);

            //TODO: 調査
            for (String error : errors)  {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, error));
                Logger.db('error: ' + error);
            }

            System.debug(LoggingLevel.INFO, 'errors: ' + e.getMessage());
        }

        return userId;
    }

    // private User buildUser(Talent__c talent, TalentActivity__c talentActivity, ID profileId) {
    private User buildUser(Talent__c talent, TalentActivity__c talentActivity, String email) {
        User user = new User();

        user.Username = email;
        user.LastName = talent.Name;
        user.CommunityNickname = talent.Name;
        user.Email = email;

        //TODO: コメントアウト外す
        // user.Email = 'takuya.nakamatsu+'+Datetime.now().format('yyyyMMddHMS')+'@leverages.jp';
        // user.Email = talentActivity.Email__c;
        user.ProfileId = profileId;

        return user;
    }
}
