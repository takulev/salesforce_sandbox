public with sharing class TalentActivityRepository extends BaseRepository implements TalentActivityRepositoryInterface {
    protected SObjectType objectType {
        get { return TalentActivity__c.SObjectType; }
        set;
    }

    protected final List<SObjectField> fields {
        get {
            return new List<SObjectField>{
                TalentActivity__c.Id,
                TalentActivity__c.Remarks__c
            };
        }
        set;
    }

    public TalentActivityRepository () {
        super();
    }

    public TalentActivity__c getById(ID id) {
        //TODO: オブジェクトの項目までアクセス権限を判定する場合、項目を指定する
        List<SObject> test = super.get(QueryBuilder.equals(TalentActivity__c.Id, id));

        System.debug('【テスト】getById');
        System.debug(test);

        return [
            SELECT Id, Remarks__c
            FROM TalentActivity__c
            WHERE Id = :id
            LIMIT 1
        ];
    }


    // public TalentActivity__c getById(ID id) {
    //     if(!isAccessible()) {
    //         return null;
    //     }

    //     //TODO: オブジェクトの項目までアクセス権限を判定する場合、項目を指定する
    //     return [
    //         SELECT Id, Remarks__c
    //         FROM TalentActivity__c
    //         WHERE Id = :id
    //         LIMIT 1
    //     ];
    // }

    //TODO: オブジェクトの項目までアクセス権限を判定すべきか検討する
    // private Boolean isAccessible() {
    //     return TalentActivity__c.SObjectType.getDescribe().isAccessible();
    // }
}
