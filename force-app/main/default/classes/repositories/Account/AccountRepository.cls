public with sharing class AccountRepository extends BaseRepository implements AccountRepositoryInterface {
    protected final List<SObjectField> fields {
        get {
            return new List<SObjectField>{
                this.primaryKey,
                Account.Name
            };
        }
    }

    protected final SObjectField primaryKey { get { return Account.Id; } }

    protected final SObjectType objectType { get { return Account.SObjectType; } }

    public AccountRepository () {
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

    public List<SObject> getAll() {
        return (List<Account>) super.get();
    }
}
