public interface WSUserTokenRepositoryInterface {
    List<SObjectField> getFields();
    SObjectType getObjectType();
    SObjectField getPrimaryKey();
}
