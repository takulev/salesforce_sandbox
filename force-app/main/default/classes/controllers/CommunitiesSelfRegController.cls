/**
 * An apex page controller that supports self registration of users in communities that allow self registration
 */
public class CommunitiesSelfRegController {
    /**
     * Form Field.
     */
    public String password {get; set {password = value == null ? value : value.trim(); } }
    public String confirmPassword {get; set { confirmPassword = value == null ? value : value.trim(); } }

    private ID talentActivityId;
    private WSTalentRepository talentRepository;
    private WSTalentActivityRepository talentActivityRepository;
    private ExternalUserService userService;
    private ExternalUserRepository userRepository;

    public CommunitiesSelfRegController() {
        this(
            new ExternalUserRepository(),
            new ExternalUserService(),
            (ID) ApexPages.currentPage().getParameters().get('taid'),
            new WSTalentRepository(),
            new WSTalentActivityRepository()
        );
    }

    public CommunitiesSelfRegController(
        ExternalUserRepository userRepository,
        ExternalUserService userService,
        ID talentActivityId,
        WSTalentRepository talentRepository,
        WSTalentActivityRepository talentActivityRepository
    ) {
        this.userRepository = userRepository;
        this.userService = userService;
        this.talentActivityId = talentActivityId;
        this.talentRepository = talentRepository;
        this.talentActivityRepository = talentActivityRepository;
        this.initExId();
    }

    public PageReference registerUser() {
        // TODO: 「初回ログイン管理している場合は、登録させないようにする」

        if (!isValidPassword()) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.site.passwords_dont_match);
            ApexPages.addMessage(msg);
            return null;
        }

        TalentActivity__c talentActivity = this.talentActivityRepository.getById(this.talentActivityId);
        Talent__c talent = this.talentRepository.getById(talentActivity.TalentName__c);

        User user;
        try {
            // TODO: config内でフロー名を管理
            Flow.Interview flow = Flow.Interview.createInterview('getMypageEnv', new Map<String, Object>{});
            flow.start();

            ID accountId = (ID) flow.getVariableValue('varAccountId');
            ID profileId = (ID) flow.getVariableValue('varProfileId');

            user = this.userService.createAccount(
                this.userService.buildUser(talent, talentActivity, profileId),
                accountId,
                password
            );

            this.userRepository.doInsert(new Map<String, Object>{
                'Name' => user.LastName,
                'User__c' => user.Id,
                'Talent__c' => talent.Id
            });

            // TODO: 人材活動オブジェクトに「アカウント作成後の初ログイン済み」判定項目を設ける
        } catch (Exception e) {
            PageReference page = System.Page.Exception;
            page.setRedirect(true);
            return page;
        }

        return Site.login(user.userName, password, ApexPages.currentPage().getParameters().get('startURL'));
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
