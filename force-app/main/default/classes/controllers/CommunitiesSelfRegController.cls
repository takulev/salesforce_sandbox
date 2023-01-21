/**
 * An apex page controller that supports self registration of users in communities that allow self registration
 */
public class CommunitiesSelfRegController {
    /**
     * Form Field.
     */
    public String password {get; set {password = value == null ? value : value.trim(); } }
    public String confirmPassword {get; set { confirmPassword = value == null ? value : value.trim(); } }
    public String communityNickname {get; set { communityNickname = value == null ? value : value.trim(); } }

    private ID talentActivityId;
    private ExternalUserService userService;

    public CommunitiesSelfRegController() {
        this.userService = new ExternalUserService();
        this.talentActivityId = (ID) ApexPages.currentPage().getParameters().get('taid');
        this.initExId();
    }

    public PageReference registerUser() {
        if (!isValidPassword()) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.site.passwords_dont_match);
            ApexPages.addMessage(msg);
            return null;
        }

        User user = this.userService.createAccount(
            this.talentActivityId,
            password
        );

        // TODO: 人材活動オブジェクトに「アカウント作成後の初ログイン済み」判定項目を設ける

        // TODO: 人材活動オブジェクトにuserIdを保存

        // TODO: 「初回ログイン管理している場合は、登録させないようにする」

        if (user != null) {
            if (password != null && password.length() > 1) {
                return Site.login(user.userName, password, ApexPages.currentPage().getParameters().get('startURL'));
            }
            else {
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
