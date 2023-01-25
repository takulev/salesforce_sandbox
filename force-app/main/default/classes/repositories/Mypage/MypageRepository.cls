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

    public MypageRepository() {
        super();
    }

    public virtual Mypage__c doInsert(Map<String, Object> values) {
        Mypage__c mypage = new Mypage__c();

        for (String field : values.keySet()) {
            mypage.put(field, values.get(field));
        }

        return (Mypage__c) super.doInsert(mypage);
    }

    public virtual Mypage__c getByUserId(ID id) {
        return (Mypage__c) super.setWhere(QueryBuilder.equals(Mypage__c.User__c, id)).first();
    }

    public override List<SObjectField> getFields() {
        return this.fields;
    }

    public override SObjectType getObjectType() {
        return this.objectType;
    }

    public override SObjectField getPrimaryKey() {
        return this.primaryKey;
    }
}
