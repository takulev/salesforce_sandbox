public interface MypageRepositoryInterface {
    Mypage__c getByUserId(ID id);
    List<SObjectField> getFields();
    SObjectType getObjectType();
    SObjectField getPrimaryKey();
}
