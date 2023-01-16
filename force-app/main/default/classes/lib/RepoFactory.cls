// MEMO: このクラスが自分が想定しているリポジトリに当たりそう
public virtual class RepoFactory {
    public virtual IRepository getOppRepo() {
        List<SObjectField> queryFields = new List<SObjectField>{
            Opportunity.IsWon,
            Opportunity.StageName
            //etc ...
        };
        return new Repository(Opportunity.SObjectType, queryFields);
    }

    // TODO：ここは使う
    public virtual IRepository getOppLineItemRepo() {
        List<SObjectField> queryFields = new List<SObjectField>{
            OpportunityLineItem.Description,
            OpportunityLineItem.OpportunityId
            //etc
        };
        return new Repository(OpportunityLineItem.SObjectType, queryFields);
    }
   
    //etc
}
