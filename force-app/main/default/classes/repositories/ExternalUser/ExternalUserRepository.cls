public without sharing virtual class ExternalUserRepository extends BaseRepository implements ExternalUserRepositoryInterface {
    protected final List<SObjectField> fields {
        get {
            return new List<SObjectField>{
                this.primaryKey,
                ExternalUser__c.Name,
                ExternalUser__c.Talent__c,
                ExternalUser__c.User__c
            };
        }
    }

    protected final SObjectField primaryKey { get { return ExternalUser__c.Id; } }

    protected final SObjectType objectType { get { return ExternalUser__c.SObjectType; } }

    public ExternalUserRepository() {
        super();
    }

    public virtual ExternalUser__c doInsert(Map<String, Object> values) {
        ExternalUser__c user = new ExternalUser__c();

        for (String field : values.keySet()) {
            user.put(field, values.get(field));
        }

        return (ExternalUser__c) super.doInsert(user);
    }

    public virtual ExternalUser__c getByUserId(ID id) {
        return (ExternalUser__c) super.setWhere(QueryBuilder.equals(ExternalUser__c.User__c, id)).first();
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
