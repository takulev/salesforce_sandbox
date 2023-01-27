public with sharing class GetLeadIdByUserId {
    @InvocableMethod(label='ログイン中のユーザーに紐付いているリードIDを取得')
    public static List<GetLeadIdByUserIdResponse> getLeadId() {
        List<GetLeadIdByUserIdResponse> responses = new List<GetLeadIdByUserIdResponse>();
        GetLeadIdByUserIdResponse response = new GetLeadIdByUserIdResponse();

        ExternalUser__c user = (new ExternalUserRepository()).getByUserId(UserInfo.getUserId());
        Talent__c talent = (new TalentRepository()).getByExternalUserId(user.Id);
        Lead lead = (new LeadRepository()).getByTalentId(talent.Id);

        response.leadId = lead.Id;
        responses.add(response);

        return responses;
    }

    public class GetLeadIdByUserIdResponse {
        @InvocableVariable(description='リードID')
        public ID leadId;
    }
}
