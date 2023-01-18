public interface AccountRepositoryInterface {
    List<SObject> getAll();
    Account getById(ID id);
}
