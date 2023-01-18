public with sharing class ExternalUserService {
    public String firstName {get; set;}
    public String lastName {get; set;}
    public String email {get; set;}
    public String password {get; set {password = value == null ? value : value.trim(); } }

    private TalentRepository talentRepository;
    private TalentActivityRepository talentActivityRepository;

    public ExternalUserService() {
        this.talentRepository = new TalentRepository();
        this.talentActivityRepository = new TalentActivityRepository();
    }

    public void createAccount(ID talentActivityId, ID accountId, ID profileId) {
        TalentActivity__c talentActivity = this.talentActivityRepository.getById(talentActivityId);
        Talent__c talent = this.talentRepository.getById(talentActivity.TalentName__c);
        User user = this.buildUser(talent, talentActivity, profileId);

        System.debug(LoggingLevel.INFO, 'talentActivity: ' + talentActivity);
        System.debug(LoggingLevel.INFO, 'talent: ' + talent);
        System.debug(LoggingLevel.INFO, 'user: ' + user);

        try {
            String userId = Site.createExternalUser(user, accountId, this.password);

            // 人材活動オブジェクトにuserIdを保存

        } catch(Site.ExternalUserCreateException e) {
            List<String> errors = e.getDisplayMessages();

            //TODO: 調査
            for (String error : errors)  {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, error));
            }

            System.debug(e.getMessage());
        }
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
