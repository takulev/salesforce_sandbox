/**
 * An apex page controller that supports self registration of users in communities that allow self registration
 */
public class CommunitiesSelfRegController {
    /**
     * Form Field.
     */
    public String password {get; set {password = value == null ? value : value.trim(); } }
    public String confirmPassword {get; set { confirmPassword = value == null ? value : value.trim(); } }

    private ExternalUserRepository userRepository;
    private ID talentActivityId;
    private WSTalentRepository talentRepository;
    private WSTalentActivityRepository talentActivityRepository;
    private ExternalUserService userService;

    public CommunitiesSelfRegController() {
        this.userRepository = new ExternalUserRepository();
        this.userService = new ExternalUserService();
        this.talentActivityId = (ID) ApexPages.currentPage().getParameters().get('taid');
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

        TalentActivity__c talentActivity = this.talentActivityRepository.getById(this.talentActivityId);
        Talent__c talent = this.talentRepository.getById(talentActivity.TalentName__c);

        User user = this.userService.createAccount(
            this.userService.buildUser(talent, talentActivity),
            password
        );

        this.userRepository.doInsert(new Map<String, Object>{
            'Name' => user.LastName,
            'User__c' => user.Id,
            'Talent__c' => talent.Id
        });

        // TODO: 人材活動オブジェクトに「アカウント作成後の初ログイン済み」判定項目を設ける

        if (user != null) {
            if (password != null && password.length() > 1) {
                return Site.login(user.userName, password, ApexPages.currentPage().getParameters().get('startURL'));
            } else {
                PageReference page = System.Page.CommunitiesSelfRegConfirm;
                page.setRedirect(true);
                return page;
            }
        }

        return null;
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
