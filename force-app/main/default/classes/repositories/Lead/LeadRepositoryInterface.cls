public interface LeadRepositoryInterface {
    Lead getByTalentId(ID id);
    List<SObjectField> getFields();
    SObjectType getObjectType();
    SObjectField getPrimaryKey();
}
