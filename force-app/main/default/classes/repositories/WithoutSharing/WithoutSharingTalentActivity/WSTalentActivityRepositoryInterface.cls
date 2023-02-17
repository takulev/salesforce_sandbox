public interface WSTalentActivityRepositoryInterface {
    List<SObjectField> getFields();
    SObjectType getObjectType();
    SObjectField getPrimaryKey();
}
