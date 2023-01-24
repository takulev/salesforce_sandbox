public with sharing virtual class TalentActivityRepository extends BaseRepository implements TalentActivityRepositoryInterface {
    protected final List<SObjectField> fields {
        get {
            return new List<SObjectField>{
                this.primaryKey,
                TalentActivity__c.TalentName__c,
                TalentActivity__c.Name,
                TalentActivity__c.Email__c,
                TalentActivity__c.PhoneNumber__c
            };
        }
    }

    protected final SObjectField primaryKey { get { return Mypage__c.Id; } }

    protected final SObjectType objectType { get { return TalentActivity__c.SObjectType; } }

    public TalentActivityRepository() {
        super();
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
