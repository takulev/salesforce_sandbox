public interface AccountRepositoryInterface {
    List<SObject> getAll();
    List<SObjectField> getFields();
    SObjectType getObjectType();
    SObjectField getPrimaryKey();
}
