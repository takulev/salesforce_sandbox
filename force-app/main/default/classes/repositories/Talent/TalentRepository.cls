public with sharing class TalentRepository extends BaseRepository implements TalentRepositoryInterface {
    protected final List<SObjectField> fields {
        get {
            return new List<SObjectField>{
                this.primaryKey,
                Talent__c.Name
            };
        }
    }

    protected final SObjectType objectType { get { return Talent__c.SObjectType; } }

    protected final SObjectField primaryKey { get { return Talent__c.Id; } }

    public TalentRepository() {
        super();
    }

    public virtual Talent__c getByExternalUserId(ID id) {
        return (Talent__c) super.setWhere(QueryBuilder.equals(Talent__c.ExternalUser__c, id)).first();
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
