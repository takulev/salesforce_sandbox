public with sharing class GetAccountIdByUserId {
    @InvocableMethod(label='ログイン中のユーザーに紐付いている取引先IDを取得')
    public static List<GetAccountIdByUserIdResponse> getAccountId() {
        List<GetAccountIdByUserIdResponse> responses = new List<GetAccountIdByUserIdResponse>();
        GetAccountIdByUserIdResponse response = new GetAccountIdByUserIdResponse();

        ExternalUser__c user = (new ExternalUserRepository()).getByUserId(UserInfo.getUserId());

        response.accountId = user.Account__c;
        responses.add(response);

        return responses;
    }

    public class GetAccountIdByUserIdResponse {
        @InvocableVariable(description='取引先ID')
        public ID accountId;
    }
}
