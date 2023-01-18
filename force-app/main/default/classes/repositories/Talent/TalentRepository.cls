public with sharing class TalentRepository extends BaseRepository implements TalentRepositoryInterface {
    protected final List<SObjectField> fields {
        get {
            return new List<SObjectField>{
                Talent__c.Id,
                Talent__c.Name
            };
        }
    }

    protected final SObjectType objectType { get { return Talent__c.SObjectType; } }

    public TalentRepository () {
        super();
    }

    public override List<SObjectField> getFields () {
        return this.fields;
    }

    public override SObjectType getObjectType () {
        return this.objectType;
    }

    public Talent__c getById(ID id) {
        return (Talent__c) super.setWhere(QueryBuilder.equals(Talent__c.Id, id)).first();
    }

    //TODO: オブジェクトの項目までアクセス権限を判定すべきか検討する
    // private Boolean isAccessible() {
    //     return Talent__c.SObjectType.getDescribe().isAccessible();
    // }
}
