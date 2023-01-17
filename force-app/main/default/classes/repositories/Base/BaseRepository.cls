public with sharing virtual class BaseRepository {
    public Dml dml;
    protected List<SObjectField> fields;
    protected SObjectType objectType;

    //TODO: 使用用途を調査
    private Object bindVar;
    private Boolean shortCircuit = false;

    //TODO: 何も設定してい場合にも、build関数で対応できるようにする
    private String limitClause;
    private String whereClause;
    private List<SObjectField> selectClause = null;

    public BaseRepository () {
        this.dml = new Dml();
        this.fields = this.getFields();
        this.objectType = this.getObjectType();
    }

    public virtual List<SObjectField> getFields () {
        return this.fields;
    }

    public virtual SObjectType getObjectType () {
        return this.objectType;
    }

    public BaseRepository setWhere(QueryBuilder query) {
        return this.setWhere(new List<QueryBuilder>{ query });
    }

    public BaseRepository setWhere(List<QueryBuilder> queries) {
        this.whereClause = this.addWheres(queries);
        return this;
    }

    public BaseRepository setLimit(Integer value) {
        this.limitClause = '\nLIMIT\n' + String.valueOf(value);
        return this;
    }

    public BaseRepository setSelector(SObjectField selector) {
        return this.setSelector(new List<SObjectField>{ selector });
    }

    public BaseRepository setSelector(List<SObjectField> selector) {
        this.selectClause = selector;
        return this;
    }

    // SOQL
    public virtual List<SObject> get(QueryBuilder query) {
        return this.get(new List<QueryBuilder>{ query });
    }

    public virtual List<SObject> get(List<QueryBuilder> queries) {
        String query = this.getSelectAndFrom() + this.addWheres(queries);

        return this.execute(query);
    }

    public virtual SObject first() {
        setLimit(1);
        String query = this.getSelectAndFrom() + this.whereClause + this.limitClause;
        return this.execute(query)[0];
    }

    public virtual List<SObject> getAll() {
        return this.execute(this.getSelectAndFrom());
    }

    private String getSelectAndFrom() {
        return 'SELECT ' + this.getSelector() + '\nFROM ' + this.objectType;
    }

    private String getSelector() {
        Set<String> selectorStrings = new Set<String>{ 'Id' };
        List<SObjectField> selectors = this.selectClause == null ? this.fields : this.selectClause;

        for (SObjectField selector : selectors) {
          selectorStrings.add(selector.getDescribe().getName());
        }

        return String.join(new List<String>(selectorStrings), ', ');
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

    private List<SObject> execute(String finalQuery) {
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
