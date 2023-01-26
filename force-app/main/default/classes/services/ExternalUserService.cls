public without sharing class ExternalUserService {
    public User buildUser(Talent__c talent, TalentActivity__c talentActivity, ID profileId) {
        User user = new User();

        user.Username = talentActivity.Email__c;
        user.LastName = talent.Name;
        user.CommunityNickname = talent.Name;
        user.Email = talentActivity.Email__c;
        user.ProfileId = profileId;

        return user;
    }

    public User createAccount(User user, ID accountId, String password) {
        try {
            user.Id = Site.createExternalUser(user, accountId, password);
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
}
