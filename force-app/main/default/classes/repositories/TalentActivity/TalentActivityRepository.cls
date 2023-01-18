public with sharing class TalentActivityRepository extends BaseRepository implements TalentActivityRepositoryInterface {
    protected final List<SObjectField> fields {
        get {
            return new List<SObjectField>{
                TalentActivity__c.Id,
                TalentActivity__c.TalentName__c,
                TalentActivity__c.Name,
                TalentActivity__c.Email__c,
                TalentActivity__c.PhoneNumber__c
            };
        }
    }

    protected final SObjectType objectType { get { return TalentActivity__c.SObjectType; } }

    public TalentActivityRepository () {
        super();
    }

    public override List<SObjectField> getFields () {
        return this.fields;
    }

    public override SObjectType getObjectType () {
        return this.objectType;
    }

    public TalentActivity__c getById(ID id) {
        return (TalentActivity__c) super.setWhere(QueryBuilder.equals(TalentActivity__c.Id, id)).first();
    }

    //TODO: オブジェクトの項目までアクセス権限を判定すべきか検討する
    // private Boolean isAccessible() {
    //     return TalentActivity__c.SObjectType.getDescribe().isAccessible();
    // }
}
