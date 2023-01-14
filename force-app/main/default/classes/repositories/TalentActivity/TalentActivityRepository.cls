public with sharing class TalentActivityRepository implements TalentActivityRepositoryInterface {
    public TalentActivity__c getById(ID id) {
        if(!isAccessible()) {
            return null;
        }

        //TODO: オブジェクトの項目までアクセス権限を判定する場合、項目を指定する
        return [
            SELECT Id, Remarks__c
            FROM TalentActivity__c
            WHERE Id = :id
            LIMIT 1
        ];
    }

    //TODO: オブジェクトの項目までアクセス権限を判定すべきか検討する
    private Boolean isAccessible() {
        return TalentActivity__c.SObjectType.getDescribe().isAccessible();
    }
}
