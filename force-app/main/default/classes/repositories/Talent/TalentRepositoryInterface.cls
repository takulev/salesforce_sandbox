public interface TalentRepositoryInterface {
    List<SObjectField> getFields();
    SObjectType getObjectType();
    SObjectField getPrimaryKey();
}
