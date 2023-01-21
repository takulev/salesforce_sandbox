public without sharing class ExternalUserService {
    //TODO: どうにかして、環境別で値を変更する
    static final ID accountId = '0010T00000QXufwQAD';
    static final ID profileId = '00e0T000000MS7RQAW';

    private WSTalentRepository talentRepository;
    private WSTalentActivityRepository talentActivityRepository;

    public ExternalUserService() {
        this.talentRepository = new WSTalentRepository();
        this.talentActivityRepository = new WSTalentActivityRepository();
    }

    public User createAccount(ID talentActivityId, String password) {
        TalentActivity__c talentActivity = this.talentActivityRepository.getById(talentActivityId);
        Talent__c talent = this.talentRepository.getById(talentActivity.TalentName__c);
        User user = this.buildUser(talent, talentActivity);

        String userId = '';
        try {
            userId = Site.createExternalUser(user, accountId, password);
        } catch(Site.ExternalUserCreateException e) {
            List<String> errors = e.getDisplayMessages();
            System.debug(LoggingLevel.INFO, 'errors: ' + errors);

            for (String error : errors)  {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, error));
            }

            System.debug(LoggingLevel.INFO, 'errors: ' + e.getMessage());

            return null;
        }

        return user;
    }

    private User buildUser(Talent__c talent, TalentActivity__c talentActivity) {
        User user = new User();

        user.Username = talentActivity.Email__c;
        user.LastName = talent.Name;
        user.CommunityNickname = talent.Name;
        user.Email = talentActivity.Email__c;
        user.ProfileId = profileId;

        return user;
    }
}
