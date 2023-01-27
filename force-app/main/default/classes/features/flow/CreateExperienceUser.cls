public with sharing class CreateExperienceUser {
    @InvocableMethod(label='Experience Cloudユーザーの作成')
    public static void createUser(List<CreateExperienceUserRequest> request) {
        ExternalUserService userService = new ExternalUserService();

        try {
            userService.createAccount(
                request[0].talentActivityId,
                request[0].accountId,
                request[0].profileId
            );
        } catch (Exception e) {
            System.debug(Logginglevel.ERROR, e);
        }
    }

    public class CreateExperienceUserRequest {
        @InvocableVariable(description='取引先ID')
        public ID accountId;

        @InvocableVariable(description='人材活動ID')
        public ID talentActivityId;

        @InvocableVariable(description='プロファイルID')
        public ID profileId;

        //TODO: 取引先責任者が自動生成しない場合は、フローで取引先責任者を作成し、IDをAPEXへ渡す
        // @InvocableVariable(description='取引先責任者ID')
        // public ID contactId;
    }
}