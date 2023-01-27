// NOTE: 現在使用されてないライブラリのコードはコメントアウト。（コメントアウトなしだと、テストコードが必要なため）
public virtual class QueryBuilder {
  private enum Operator {
    EQUALS,
    NOT_EQUALS,
    LESS_THAN,
    LESS_THAN_OR_EQUAL,
    GREATER_THAN,
    GREATER_THAN_OR_EQUAL,
    ALIKE, // LIKEは予約語のため
    NOT_LIKE
  }

  private final SObjectField field;
  private final Operator operator;
  private final List<Object> predicates;

  private Boolean isIterable = false;

  private static final String EMPTY = '\'\'';

  public static QueryBuilder equals(SObjectField field, Object predicate) {
    return equals(field, new List<Object>{ predicate });
  }

  public static QueryBuilder equals(SObjectField field, List<Object> predicates) {
    return new QueryBuilder(field, Operator.EQUALS, predicates);
  }

  // public static QueryBuilder notEquals(SObjectField field, Object predicate) {
  //   return notEquals(field, new List<Object>{ predicate });
  // }

  // public static QueryBuilder notEquals(SObjectField field, List<Object> predicates) {
  //   return new QueryBuilder(field, Operator.NOT_EQUALS, predicates);
  // }

  // public static QueryBuilder lessThan(SObjectField field, Object predicate) {
  //   return lessThan(field, new List<Object>{ predicate });
  // }

  // public static QueryBuilder lessThan(SObjectField field, List<Object> predicates) {
  //   return new QueryBuilder(field, Operator.LESS_THAN, predicates);
  // }

  // public static QueryBuilder lessThanOrEqual(SObjectField field, Object predicate) {
  //   return lessThanOrEqual(field, new List<Object>{ predicate });
  // }

  // public static QueryBuilder lessThanOrEqual(SObjectField field, List<Object> predicates) {
  //   return new QueryBuilder(field, Operator.LESS_THAN_OR_EQUAL, predicates);
  // }

  // public static QueryBuilder greaterThan(SObjectField field, Object predicate) {
  //   return greaterThan(field, new List<Object>{ predicate });
  // }

  // public static QueryBuilder greaterThan(SObjectField field, List<Object> predicates) {
  //   return new QueryBuilder(field, Operator.GREATER_THAN, predicates);
  // }

  // public static QueryBuilder greaterThanOrEqual(SObjectField field, Object predicate) {
  //   return greaterThanOrEqual(field, new List<Object>{ predicate });
  // }

  // public static QueryBuilder greaterThanOrEqual(SObjectField field, List<Object> predicates) {
  //   return new QueryBuilder(field, Operator.GREATER_THAN_OR_EQUAL, predicates);
  // }

  // // like is a reserved keyword
  // public static QueryBuilder likeQuery(SObjectField field, Object predicate) {
  //   return likeQuery(field, new List<Object>{ predicate });
  // }

  // public static QueryBuilder likeQuery(SObjectField field, List<Object> predicates) {
  //   return new QueryBuilder(field, Operator.ALIKE, predicates);
  // }

  // public static QueryBuilder notLike(SObjectField field, Object predicate) {
  //   return notLike(field, new List<Object>{ predicate });
  // }

  // public static QueryBuilder notLike(SObjectField field, List<Object> predicates) {
  //   return new QueryBuilder(field, Operator.NOT_LIKE, predicates);
  // }

  // // or is a reserved keyword
  // public static QueryBuilder orQueryBuilder(QueryBuilder innerQuery, QueryBuilder secondInnerQuery) {
  //   return orQueryBuilder(new List<QueryBuilder>{ innerQuery, secondInnerQuery });
  // }

  // public static QueryBuilder orQueryBuilder(List<QueryBuilder> innerQueries) {
  //   return new OrQueryBuilder(innerQueries);
  // }

  // private class OrQueryBuilder extends QueryBuilder {
  //   private final List<QueryBuilder> queries;
  //   private final String orDelimiter = ' OR ';

  //   public OrQueryBuilder(List<QueryBuilder> queries) {
  //     this.queries = queries;
  //   }

  //   public override String toString() {
  //     String baseString = '(';
  //     for (QueryBuilder innerQuery : this.queries) {
  //       baseString += innerQuery.toString() + this.orDelimiter;
  //     }

  //     return baseString.removeEnd(this.orDelimiter) + ')';
  //   }
  // }

  // protected QueryBuilder() {
  // }

  private QueryBuilder(SObjectField field, Operator operator, List<Object> predicates) {
    this.field = field;
    this.operator = operator;
    this.predicates = predicates;
  }

  // public List<Object> getBindVars() {
  //   return this.predicates;
  // }

  public virtual override String toString() {
    String fieldName = this.field.getDescribe().getName();
    String predicateValue = this.getPredicate(this.predicates);
    this.isIterable = this.isIterable || this.predicates.size() > 1;

    // if (this.operator == QueryBuilder.Operator.NOT_LIKE) {
    //   String endingString = ' ' + (this.isIterable ? ':bindVar' : predicateValue);
    //   // who knows why this is the format they wanted
    //   return String.format(this.getOperator(), new List<String>{ fieldName }) + endingString;
    // }

    return fieldName + ' ' + this.getOperator() + ' ' + predicateValue;
  }

  // public Boolean isEmpty() {
  //   return this.getPredicate(this.predicates) == EMPTY;
  // }

  // public Boolean equals(Object thatObject) {
  //   if (thatObject instanceof QueryBuilder) {
  //     QueryBuilder that = (QueryBuilder) thatObject;
  //     return this.toString() == that.toString();
  //   }

  //   return false;
  // }

  private String getOperator() {
    String returnVal = '';
    switch on this.operator {
      when EQUALS {
        returnVal = isIterable ? 'in' : '=';
      }
      // when NOT_EQUALS {
      //   returnVal = isIterable ? 'not in' : '!=';
      // }
      // when LESS_THAN {
      //   returnVal = '<';
      // }
      // when LESS_THAN_OR_EQUAL {
      //   returnVal = '<=';
      // }
      // when GREATER_THAN {
      //   returnVal = '>';
      // }
      // when GREATER_THAN_OR_EQUAL {
      //   returnVal = '>=';
      // }
      // when ALIKE {
      //   returnVal = 'like';
      // }
      // when NOT_LIKE {
      //   returnVal = 'not {0} like';
      // }
    }
    return returnVal;
  }

  private String getPredicate(Object predicate) {
    if (predicate == null) {
      return 'null';
    } else if (predicate instanceof Datetime) {
      // the most annoying one
      Datetime dt = (Datetime) predicate;
      return dt.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'', 'Greenwich Mean Time');
    } else if (predicate instanceof List<Object>) {
      List<Object> localPredicates = (List<Object>) predicate;
      if (localPredicates.isEmpty()) {
        return EMPTY;
      }
      List<String> innerStrings = new List<String>();
      for (Object innerPred : localPredicates) {
        // recurse for string value
        String innerString = this.getPredicate(innerPred);
        innerStrings.add(innerString);
      }
      String start = innerStrings.size() > 1 ? '(' : '';
      String ending = innerStrings.size() > 1 ? ')' : '';
      return start + String.join(innerStrings, ',') + ending;
    } else if (predicate instanceof String) {
      String input = (String) predicate;
      return '\'' + String.escapeSingleQuotes(input) + '\'';
    }

    // // it could still be a Set, which is notoriously hard to detect for
    // // due to instanceof Iterable<String> returning false for Sets, despite
    // // Set.class implementing the interface ...
    // try {
    //   Iterable<Object> objectSet = (Iterable<Object>) predicate;
    //   List<String> innerList = new List<String>();
    //   Iterator<Object> objectSetIterator = objectSet.iterator();
    //   while (objectSetIterator.hasNext()) {
    //     innerList.add(String.valueOf(objectSetIterator.next()));
    //   }
    //   this.isIterable = innerList.size() > 1;

    //   return this.getPredicate(innerList);
    // } catch (Exception ex) {
    //   // do nothing, it didn't work
    // }
    return String.valueOf(predicate);
  }
}
