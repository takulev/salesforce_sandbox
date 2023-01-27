public without sharing virtual class BaseRepository {
    public Dml dml;
    protected List<SObjectField> fields;
    protected SObjectField primaryKey;
    protected SObjectType objectType;

    private String limitClause = null;
    private String sortClause = null;
    private String whereClause = null;
    private List<SObjectField> selectClause = null;

    public BaseRepository() {
        this.dml = new Dml();
        this.primaryKey = this.getPrimaryKey();
        this.fields = this.getFields();
        this.objectType = this.getObjectType();
    }
    //TODO: 下記の記事も参考にロジックを見直す
    //https://developer.salesforce.com/docs/atlas.ja-jp.pages.meta/pages/pages_dynamic_vf_globals_objecttype.htm

    public SObject first() {
        setLimit(1);

        return this.execute(this.buildQuery())[0];
    }

    public List<SObject> get() {
        return this.execute(this.buildQuery());
    }

    public virtual SObject find(ID id) {
        return this.setWhere(QueryBuilder.equals(this.primaryKey, id)).first();
    }

    public virtual List<SObjectField> getFields() {
        return this.fields;
    }

    public virtual SObjectField getPrimaryKey() {
        return this.primaryKey;
    }

    public virtual SObjectType getObjectType() {
        return this.objectType;
    }

    public BaseRepository setLimit(Integer value) {
        this.limitClause = ' LIMIT ' + String.valueOf(value);

        return this;
    }

    public BaseRepository setOrderBy(SObjectField field, String direction) {
        return this.setOrderBy(new List<SObjectField>{ field }, direction);
    }

    public BaseRepository setOrderBy(List<SObjectField> fields, String direction) {
        Set<String> sortString = new Set<String>();

        for (SObjectField field : fields) {
            sortString.add(field.getDescribe().getName());
        }

        if(direction == null) {
            //FIXME: ENUMにしたいが、ASCが予約語のため使用できないため、一旦文字列で代用。
            direction = 'ASC';

            //TODO: ENUMの代わりにException作成
        }

        this.sortClause = ' ORDER BY ' + String.join(new List<String>(sortString), ', ') + ' ' + direction;

        return this;
    }

    public BaseRepository setSelector(SObjectField selector) {
        return this.setSelector(new List<SObjectField>{ selector });
    }

    public BaseRepository setSelector(List<SObjectField> selector) {
        this.selectClause = selector;

        return this;
    }

    public BaseRepository setWhere(QueryBuilder query) {
        return this.setWhere(new List<QueryBuilder>{ query });
    }

    public BaseRepository setWhere(List<QueryBuilder> queries) {
        this.whereClause = this.addWheres(queries);

        return this;
    }

    public SObject doInsert(SObject record) {
        return this.dml.doInsert(record);
    }

    public List<SObject> doInsert(List<SObject> records) {
        return this.dml.doInsert(records);
    }

    public virtual SObject doUpdate(ID id, Map<String, Object> values) {
        SObject record = find(id);

        for (String field : values.keySet()) {
            record.put(field, values.get(field));
        }

        return this.doUpdate(record);
    }

    public virtual SObject doUpdate(SObject record) {
        return this.dml.doUpdate(record);
    }

    public virtual List<SObject> doUpdate(List<SObject> records) {
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

    private String buildQuery() {
        String queryString = 'SELECT ' + this.getSelector() + ' FROM ' + this.objectType;

        if (this.whereClause != null) {
            queryString += this.whereClause;
        }

        if (this.limitClause != null) {
            queryString += this.limitClause;
        }

        if(this.sortClause != null) {
            queryString += this.sortClause;
        }

        return queryString;
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
          wheres.add(query.toString());
        }

        return ' WHERE ' + String.join(wheres, ' AND');
      }

    private List<SObject> execute(String finalQuery) {
        System.debug(LoggingLevel.INFO, 'Query: \n' + finalQuery);

        List<SObject> results = Database.query(finalQuery);

        System.debug(LoggingLevel.INFO, 'Results: \n' + results);

        return results;
    }
}
