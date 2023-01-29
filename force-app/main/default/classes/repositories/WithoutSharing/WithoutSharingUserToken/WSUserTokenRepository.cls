/**
 * Experience Cloudで認証前のユーザ照合用のクラス.
 *
 * MEMO: 共有ルールを適用できないためUserTokenRepositoryクラスと切り離して作成.
 */
public without sharing virtual class WSUserTokenRepository extends BaseRepository implements WSUserTokenRepositoryInterface {
    protected final List<SObjectField> fields {
        get {
            return new List<SObjectField>{
                this.primaryKey,
                UserToken__c.Account__c,
                UserToken__c.TalentActivity__c
            };
        }
    }

    protected final SObjectField primaryKey { get { return UserToken__c.Id; } }

    protected final SObjectType objectType { get { return UserToken__c.SObjectType; } }

    public WSUserTokenRepository() {
        super();
    }

    public UserToken__c getById(ID id) {
        return (UserToken__c) super.find(id);
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
