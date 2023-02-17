public interface ExternalUserRepositoryInterface {
    ExternalUser__c getByUserId(ID id);
    List<SObjectField> getFields();
    SObjectType getObjectType();
    SObjectField getPrimaryKey();
}
