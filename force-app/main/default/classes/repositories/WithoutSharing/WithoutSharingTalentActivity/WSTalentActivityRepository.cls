/**
 * Experience Cloudで認証前のユーザ照合用のクラス.
 *
 * MEMO: 共有ルールを適用できないためTalentActivityRepositoryクラスと切り離して作成.
 */
public without sharing virtual class WSTalentActivityRepository extends BaseRepository implements WShTalentActivityRepositoryInterface {
    protected final List<SObjectField> fields {
        get {
            return new List<SObjectField>{
                TalentActivity__c.Id,
                TalentActivity__c.TalentName__c,
                TalentActivity__c.Name,
                TalentActivity__c.Email__c,
                TalentActivity__c.PhoneNumber__c
            };
        }
    }

    protected final SObjectType objectType { get { return TalentActivity__c.SObjectType; } }

    public WSTalentActivityRepository () {
        super();
    }

    public override List<SObjectField> getFields () {
        return this.fields;
    }

    public override SObjectType getObjectType () {
        return this.objectType;
    }

    public virtual TalentActivity__c getById(ID id) {
        return (TalentActivity__c) super.setWhere(QueryBuilder.equals(TalentActivity__c.Id, id)).first();
    }
}
