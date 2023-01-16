public virtual class BaseRepository {
    public Dml dml;

    //TODO: 使用用途を調査
    private Object bindVar;
    private Boolean shortCircuit = false;

    protected List<SObjectField> fields {get; set;}
    protected SObjectType objectType {get; set;}

    public BaseRepository (Dml dml) {
        this.dml = dml;
    }

    // SOQL
    public virtual List<SObject> get(QueryBuilder query) {
        return this.get(new List<QueryBuilder>{ query });
    }

    public virtual List<SObject> get(List<QueryBuilder> queries) {
        String finalQuery = this.getSelectAndFrom() + this.addWheres(queries);
        return this.performQuery(finalQuery);
      }

    public virtual List<SObject> getAll() {
        return this.performQuery(this.getSelectAndFrom());
    }

    private String getSelectAndFrom() {
        return 'SELECT ' + this.addSelectFields() + '\nFROM ' + this.objectType;
    }

    private String addSelectFields() {
        Set<String> fieldStrings = new Set<String>{ 'Id' };
        for (SObjectField field : this.fields) {
          fieldStrings.add(field.getDescribe().getName());
        }
        return String.join(new List<String>(fieldStrings), ', ');
    }

    private String addWheres(List<QueryBuilder> queries) {
        List<String> wheres = new List<String>();

        for (QueryBuilder query : queries) {
          if (query.isEmpty()) {
            this.shortCircuit = true;
          } else if(this.bindVar == null) {
            this.bindVar = query.getBindVars();
          }
          wheres.add(query.toString());
        }
        return '\nWHERE ' + String.join(wheres, '\nAND');
      }

    private List<SObject> performQuery(String finalQuery) {
        System.debug('Query: \n' + finalQuery);
        if (this.bindVar != null) {
          System.debug('Bind var: ' + this.bindVar);
        }

        List<SObject> results = shortCircuit ? new List<SObject>() : Database.query(finalQuery);
        System.debug('Results: \n' + results);
        return results;
    }

    // DML
    public SObject doInsert(SObject record) {
        return this.dml.doInsert(record);
    }

    public List<SObject> doInsert(List<SObject> records) {
        return this.dml.doInsert(records);
    }

    public SObject doUpdate(SObject record) {
        return this.dml.doUpdate(record);
    }

    public List<SObject> doUpdate(List<SObject> records) {
        return this.dml.doUpdate(records);
    }

    public SObject doUpsert(SObject record) {
        return this.dml.doUpsert(record);
    }

    public List<SObject> doUpsert(List<SObject> records) {
        return this.dml.doUpsert(records);
    }

    public List<SObject> doUpsert(List<SObject> records, Schema.SObjectField field) {
        return this.dml.doUpsert(records, field);
    }

    public SObject doUndelete(SObject record) {
        return this.dml.doUnDelete(record);
    }

    public List<SObject> doUndelete(List<SObject> records) {
        return this.dml.doUndelete(records);
    }

    public void doDelete(SObject record) {
        this.dml.doDelete(record);
    }

    public void doDelete(List<SObject> records) {
        this.dml.doDelete(records);
    }

    public void doHardDelete(SObject record) {
        this.dml.doHardDelete(record);
    }

    public void doHardDelete(List<SObject> records) {
        this.dml.doHardDelete(records);
    }
}
