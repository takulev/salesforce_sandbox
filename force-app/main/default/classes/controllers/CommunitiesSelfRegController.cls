/**
 * An apex page controller that supports self registration of users in communities that allow self registration
 */
public class CommunitiesSelfRegController {
    public String password { get; set {password = value == null ? value : value.trim(); } }
    public String confirmPassword { get; set { confirmPassword = value == null ? value : value.trim(); } }
    public String timezone { get { return timezone; } set; }
    public List<SelectOption> timezones {
        get {
            List<SelectOption> options = new List<SelectOption>();
            for (String value: TIMEZONE_MATER.keySet()) {
                options.add(new SelectOption(value, TIMEZONE_MATER.get(value)));
            }

            return options;
        }
    }

    private String defaultTimezoneKey = 'Asia/Tokyo';
    private String errorMessage;
    private WSTalentRepository talentRepository;
    private WSTalentActivityRepository talentActivityRepository;
    private WSUserTokenRepository tokenRepository;
    private ExternalUserRepository userRepository;
    private ID userTokenId;

    final Map<String, String> TIMEZONE_MATER = new Map<String, String>{
        'Asia/Tokyo' => '（GMT+09:00）Asia/Tokyo',
        'America/Mexico_City' => '（GMT-06:00）America/Mexico_City'
    };

    public CommunitiesSelfRegController() {
        this((ID) ApexPages.currentPage().getParameters().get('token'));
    }

    public CommunitiesSelfRegController(ID token) {
        this.timezone = defaultTimezoneKey;
        this.talentActivityRepository = new WSTalentActivityRepository();
        this.talentRepository = new WSTalentRepository();
        this.tokenRepository = new WSUserTokenRepository();
        this.userRepository = new ExternalUserRepository();
        this.userTokenId = token;
        this.userRepository = new ExternalUserRepository();
        this.initExId();
    }

    public PageReference registerUser() {
        if (validate()) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, this.errorMessage);
            ApexPages.addMessage(msg);
            return null;
        }

        if(this.userTokenId == null) {
            PageReference page = System.Page.ExpiredException;
            page.setRedirect(true);
            return page;
        }

        UserToken__c userToken = this.tokenRepository.getById(this.userTokenId);
        if(userToken.VerifiedDateTime__c != null) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, '既に登録されています。');
            ApexPages.addMessage(msg);
            return null;
        }

        if(Datetime.now() >= userToken.ExpiredDatetime__c) {
            PageReference page = System.Page.ExpiredException;
            page.setRedirect(true);
            return page;
        }

        TalentActivity__c talentActivity = this.talentActivityRepository.getById(userToken.TalentActivity__c);
        Talent__c talent = this.talentRepository.getById(talentActivity.TalentName__c);

        User user;
        try {
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

            this.tokenRepository.doUpdate(userToken.Id, new Map<String, Object>{
                'VerifiedDateTime__c' => Datetime.now()
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
        user.TimeZoneSidKey = this.timezone;

        return user;
    }

    private Boolean validate() {
        return isEmptyInput() || isValidPassword() || assertPassword() || containsTimezone();
    }

    private Boolean containsTimezone() {
        Boolean isInvalid = !TIMEZONE_MATER.containsKey(this.timezone);
        if(isInvalid) {
            this.errorMessage = '適切な値を選択してください';
        }

        return isInvalid;
    }

    private Boolean isEmptyInput() {
        Boolean isInvalid = this.password == '' || this.confirmPassword == '' || this.timezone == '';
        if (isInvalid) {
            this.errorMessage = '空欄の項目があります。項目を入力してください';
        }

        return isInvalid;
    }

    private Boolean isValidPassword() {
        String regex = '^(?=.*[a-zA-Z])(?=.*[0-9]).{8,}$';
        Pattern pattern = Pattern.compile(regex);

        Matcher matcher = pattern.matcher(this.password);
        Boolean isInvalid = ! matcher.matches();
        if (isInvalid) {
            this.errorMessage = '半角英字・半角数字の両方を含む / 8文字以上を入力してください';
        }

        return isInvalid;
    }

    private Boolean assertPassword() {
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
