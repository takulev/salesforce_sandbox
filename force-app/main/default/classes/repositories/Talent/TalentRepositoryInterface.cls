public interface TalentRepositoryInterface {
    Talent__c getByExternalUserId(ID id);
    List<SObjectField> getFields();
    SObjectType getObjectType();
    SObjectField getPrimaryKey();
}
