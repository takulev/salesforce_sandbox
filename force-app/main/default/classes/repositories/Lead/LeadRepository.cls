public with sharing class LeadRepository extends BaseRepository implements LeadRepositoryInterface {
    protected final List<SObjectField> fields {
        get {
            return new List<SObjectField>{
                this.primaryKey,
                Lead.Name,
                Lead.TalentName__c
            };
        }
    }

    protected final SObjectType objectType { get { return Lead.SObjectType; } }

    protected final SObjectField primaryKey { get { return Lead.Id; } }

    public LeadRepository() {
        super();
    }

    public virtual Lead getByTalentId(ID id) {
        return (Lead) super.setWhere(QueryBuilder.equals(Lead.TalentName__c, id)).first();
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
