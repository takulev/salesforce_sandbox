public without sharing class ExternalUserService {
    //TODO: どうにかして、環境別で値を変更する
    static final ID accountId = '0010T00000QXufwQAD';
    static final ID profileId = '00e0T000000MS7RQAW';

    public User createAccount(User user, String password) {
        try {
            user.Id = Site.createExternalUser(user, accountId, password);
        } catch(Site.ExternalUserCreateException e) {
            List<String> errors = e.getDisplayMessages();
            System.debug(LoggingLevel.INFO, 'errors: ' + errors);

            for (String error : errors)  {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, error));
                Logger.db('error: ' + error);
            }

            System.debug(LoggingLevel.INFO, 'errors: ' + e.getMessage());

            return null;
        }

        return user;
    }

    public User buildUser(Talent__c talent, TalentActivity__c talentActivity) {
        User user = new User();

        user.Username = talentActivity.Email__c;
        user.LastName = talent.Name;
        user.CommunityNickname = talent.Name;
        user.Email = talentActivity.Email__c;
        user.ProfileId = profileId;

        return user;
    }
}
