public with sharing class AccountRepository extends BaseRepository implements AccountRepositoryInterface {
    protected final List<SObjectField> fields {
        get {
            return new List<SObjectField>{
                Account.Id,
                Account.Name
            };
        }
    }

    protected final SObjectType objectType { get { return Account.SObjectType; } }

    public AccountRepository () {
        super();
    }

    public override List<SObjectField> getFields () {
        return this.fields;
    }

    public override SObjectType getObjectType () {
        return this.objectType;
    }

    public List<SObject> getAll() {
        return (List<Account>) super.get();
    }

    public Account getById(ID id) {
        return (Account) super.setWhere(QueryBuilder.equals(Account.Id, id)).first();
    }

    //TODO: オブジェクトの項目までアクセス権限を判定すべきか検討する
    // private Boolean isAccessible() {
    //     return Account.SObjectType.getDescribe().isAccessible();
    // }
}
