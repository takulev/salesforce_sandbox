public without sharing class WSTalentRepository extends BaseRepository implements WSTalentRepositoryInterface {
    protected final List<SObjectField> fields {
        get {
            return new List<SObjectField>{
                this.primaryKey,
                Talent__c.Name
            };
        }
    }

    protected final SObjectField primaryKey { get { return Mypage__c.Id; } }

    protected final SObjectType objectType { get { return Talent__c.SObjectType; } }

    public WSTalentRepository() {
        super();
    }

    public Talent__c getById(ID id) {
        return (Talent__c) super.find(id);
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
