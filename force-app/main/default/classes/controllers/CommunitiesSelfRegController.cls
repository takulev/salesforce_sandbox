/**
 * An apex page controller that supports self registration of users in communities that allow self registration
 */
public class CommunitiesSelfRegController {
    public String password { get; set {password = value == null ? value : value.trim(); } }
    public String confirmPassword { get; set { confirmPassword = value == null ? value : value.trim(); } }

    private String errorMessage;
    private WSTalentRepository talentRepository;
    private WSTalentActivityRepository talentActivityRepository;
    private WSUserTokenRepository tokenRepository;
    private ExternalUserRepository userRepository;
    private ID userTokenId;

    public CommunitiesSelfRegController() {
        this((ID) ApexPages.currentPage().getParameters().get('token'));
    }

    public CommunitiesSelfRegController(ID token) {
        this.userRepository = new ExternalUserRepository();
        this.userTokenId = token;
        this.userRepository = new ExternalUserRepository();
        this.talentRepository = new WSTalentRepository();
        this.talentActivityRepository = new WSTalentActivityRepository();
        this.tokenRepository = new WSUserTokenRepository();
        this.initExId();
    }

    public PageReference registerUser() {
        // TODO: 「初回ログイン管理している場合は、登録させないようにする」

        if (validate()) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, this.errorMessage);
            ApexPages.addMessage(msg);
            return null;
        }
        PageReference page = System.Page.Exception;
            page.setRedirect(true);
            return page;

        User user;
        try {
            UserToken__c userToken = this.tokenRepository.getById(this.userTokenId);

            TalentActivity__c talentActivity = this.talentActivityRepository.getById(userToken.TalentActivity__c);
            Talent__c talent = this.talentRepository.getById(talentActivity.TalentName__c);

            // FIXME: config内でフロー名を管理
            Flow.Interview flow = Flow.Interview.createInterview('getMypageEnv', new Map<String, Object>{});
            flow.start();

            // FIXME: 環境変数に置き換えたい
            ID profileId = (ID) flow.getVariableValue('varProfileId');

            user = this.buildUser(talent, talentActivity, profileId);
            ID userId = Site.createExternalUser(user, userToken.Account__c, password);

            ExternalUser__c externalUser = this.userRepository.doInsert(new Map<String, Object>{
                'Account__c' => userToken.Account__c,
                'Name' => user.LastName,
                'User__c' => userId
            });

            this.talentRepository.doUpdate(talent.Id, new Map<String, Object>{
                'ExternalUser__c' => externalUser.Id
            });
        } catch(Site.ExternalUserCreateException e) {
            List<String> errors = e.getDisplayMessages();
            for (String error : errors)  {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, error));
            }

            System.debug(LoggingLevel.INFO, 'Message: ' + e.getMessage());
            return null;
        } catch (Exception e) {
            PageReference page = System.Page.Exception;
            page.setRedirect(true);
            return page;
        }

        return Site.login(user.userName, password, ApexPages.currentPage().getParameters().get('startURL'));
    }

    private User buildUser(Talent__c talent, TalentActivity__c talentActivity, ID profileId) {
        User user = new User();

        user.Username = talentActivity.Email__c;
        user.LastName = talent.Name;
        user.CommunityNickname = talent.Name;
        user.Email = talentActivity.Email__c;
        user.ProfileId = profileId;

        return user;
    }

    private boolean validate() {
        return isEmptyInput() || assertPassword();
    }

    private boolean isEmptyInput() {
        Boolean isInvalid = this.password == '' || this.confirmPassword == '';
        if (isInvalid) {
            this.errorMessage = 'パスワード/確認用パスワードを入力してください';
        }

        return isInvalid;
    }

    private boolean assertPassword() {
        Boolean isInvalid = this.password != this.confirmPassword;
        if (isInvalid) {
            this.errorMessage = Label.site.passwords_dont_match;
        }

        return isInvalid;
    }

    private void initExId() {
        String expid = ApexPages.currentPage().getParameters().get('expid');
        if (expId != null) {
            Site.setExperienceId(expId);
        }
    }
}
