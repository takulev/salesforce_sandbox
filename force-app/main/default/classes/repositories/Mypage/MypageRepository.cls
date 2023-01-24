public with sharing virtual class MypageRepository extends BaseRepository implements MypageRepositoryInterface {
    protected final List<SObjectField> fields {
        get {
            return new List<SObjectField>{
                this.primaryKey,
                Mypage__c.Name,
                Mypage__c.Talent__c,
                Mypage__c.User__c
            };
        }
    }

    protected final SObjectField primaryKey { get { return Mypage__c.Id; } }

    protected final SObjectType objectType { get { return Mypage__c.SObjectType; } }

    public MypageRepository () {
        super();
    }

    public override List<SObjectField> getFields () {
        return this.fields;
    }

    public override SObjectField getPrimaryKey () {
        return this.primaryKey;
    }

    public override SObjectType getObjectType () {
        return this.objectType;
    }

    public virtual Mypage__c getByTalentId(ID id) {
        return (Mypage__c) super.setWhere(QueryBuilder.equals(Mypage__c.Talent__c, id)).first();
    }
}
