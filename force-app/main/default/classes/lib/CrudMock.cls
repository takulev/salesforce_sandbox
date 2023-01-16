public virtual class CrudMock extends Crud {
    private static List<SObject> insertedRecords = new List<SObject>();
    private static List<SObject> upsertedRecords = new List<SObject>();
    private static List<SObject> updatedRecords = new List<SObject>();
    private static List<SObject> deletedRecords = new List<SObject>();
    private static List<SObject> undeletedRecords = new List<SObject>();

    private static CrudMock thisCrudMock;

    @testVisible
    private static CrudMock getMock() {
        if(thisCrudMock == null) {
            thisCrudMock = new CrudMock();
        }

        return thisCrudMock;
    }

    // DML
    public override List<SObject> doInsert(List<SObject> recordList) {
        TestingUtils.generateIds(recordList);
        insertedRecords.addAll(recordList);
        return recordList;
    }

    public override List<SObject> doUpdate(List<SObject> recordList) {
        updatedRecords.addAll(recordList);
        return recordList;
    }

    public override List<SObject> doUpsert(List<SObject> recordList) {
        TestingUtils.generateIds(recordList);
        upsertedRecords.addAll(recordList);
        return recordList;
    }
    public override List<SObject> doUpsert(List<SObject> recordList, Schema.SObjectField field) {
        return this.doUpsert(recordList);
    }

    public override List<SObject> doUndelete(List<SObject> recordList) {
        undeletedRecords.addAll(recordList);
        return recordList;
    }

    public override void doDelete(List<SObject> recordList) {
        if(recordList != null && recordList.isEmpty() == false) {
            deletedRecords.addAll(recordList);
        }
    }

    public override void doHardDelete(List<SObject> recordList) { this.doDelete(recordList); }

    public static RecordsWrapper Inserted {
        get {
            return new RecordsWrapper(insertedRecords);
        }
    }

    public static RecordsWrapper Upserted {
        get {
            return new RecordsWrapper(upsertedRecords);
        }
    }

    public static RecordsWrapper Updated {
        get {
            return new RecordsWrapper(updatedRecords);
        }
    }

    public static RecordsWrapper Deleted {
        get {
            return new RecordsWrapper(deletedRecords);
        }
    }

    public static RecordsWrapper Undeleted {
        get {
            return new RecordsWrapper(undeletedRecords);
        }
    }

    //TODO: ここのオブジェクトを直接指定している部分をどうするか
    // Mockだからテストで使っているケースが多い
    public class RecordsWrapper {
        List<SObject> recordList;
        RecordsWrapper(List<SObject> recordList) {
            this.recordList = recordList;
        }

        public RecordsWrapper ofType(Schema.SObjectType sObjectType) {
            return new RecordsWrapper(this.getRecordsMatchingType(recordList, sObjectType));
        }

        public RecordsWrapper Accounts { get { return this.ofType(Schema.Account.SObjectType); }}

        public RecordsWrapper Leads { get { return this.ofType(Schema.Lead.SObjectType); }}

        public RecordsWrapper Contacts { get { return this.ofType(Schema.Contact.SObjectType); }}

        public RecordsWrapper Opportunities { get { return this.ofType(Schema.Opportunity.SObjectType); }}

        public RecordsWrapper Tasks { get { return this.ofType(Schema.Task.SObjectType); }}

        public List<SObject> Records { get { return recordList; }}

        public Boolean hasId(Id recordId) {
            Boolean exists = false;
            for(SObject record : this.recordList) {
                if(record.Id == recordId) {
                    exists = true;
                }
            }
            return exists;
        }

        public Boolean hasId(Id whatId, SObjectField idField) {
            Boolean exists = false;
            for(SObject record : this.recordList) {
                if((Id)record.get(idField) == whatId) {
                    exists = true;
                }
            }
            return exists;
        }

        public Integer size() {
            return this.recordList.size();
        }

        public SObject singleOrDefault {
            get {
                if(recordList.size() > 1) {
                    throw new InvalidOperationException();
                }
                return recordList.size() == 0 ? null : recordList[0];
            }
        }

         public SObject firstOrDefault {
            get {
                if(recordList.size() > 0) {
                    return recordList[0];
                }
                return null;
            }
        }

        private List<SObject> getRecordsMatchingType(List<SObject> records, Schema.SObjectType sObjectType) {
        List<SObject> matchingRecords = new List<SObject>();
        for (SObject record : records) {
            if(record.getSObjectType() == sObjectType) {
                matchingRecords.add(record);
            }
        }
        return matchingRecords;
    }
    }

    public class InvalidOperationException extends Exception {}
}
