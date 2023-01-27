/**
 * An apex page controller that supports self registration of users in communities that allow self registration
 */
public class CommunitiesSelfRegController {
    /**
     * Form Field.
     */
    public String password { get; set {password = value == null ? value : value.trim(); } }
    public String confirmPassword { get; set { confirmPassword = value == null ? value : value.trim(); } }

    private ID talentActivityId;
    private WSTalentRepository talentRepository;
    private WSTalentActivityRepository talentActivityRepository;
    private ExternalUserRepository userRepository;

    public CommunitiesSelfRegController() {
        this((ID) ApexPages.currentPage().getParameters().get('taid'));
    }

    public CommunitiesSelfRegController(ID talentActivityId) {
        this.userRepository = new ExternalUserRepository();
        this.talentActivityId = talentActivityId;
        this.talentRepository = new WSTalentRepository();
        this.talentActivityRepository = new WSTalentActivityRepository();
        this.initExId();
    }

    public PageReference registerUser() {
        // TODO: 「初回ログイン管理している場合は、登録させないようにする」

        if (!isValidPassword()) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.site.passwords_dont_match);
            ApexPages.addMessage(msg);
            return null;
        }

        User user;
        try {
            TalentActivity__c talentActivity = this.talentActivityRepository.getById(this.talentActivityId);
            Talent__c talent = this.talentRepository.getById(talentActivity.TalentName__c);

            // TODO: config内でフロー名を管理
            Flow.Interview flow = Flow.Interview.createInterview('getMypageEnv', new Map<String, Object>{});
            flow.start();

            // FIXME: 環境変数に置き換えたい
            ID accountId = (ID) flow.getVariableValue('varAccountId');
            ID profileId = (ID) flow.getVariableValue('varProfileId');

            user = this.buildUser(talent, talentActivity, profileId);
            user.Id = Site.createExternalUser(user, accountId, password);

            this.userRepository.doInsert(new Map<String, Object>{
                'Name' => user.LastName,
                'User__c' => user.Id,
                'Talent__c' => talent.Id
            });

            // TODO: 人材活動オブジェクトに「アカウント作成後の初ログイン済み」判定項目を設ける
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

    private boolean isValidPassword() {
        return password == confirmPassword;
    }

    private void initExId() {
        String expid = ApexPages.currentPage().getParameters().get('expid');
        if (expId != null) {
            Site.setExperienceId(expId);
        }
    }
}
