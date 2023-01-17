public virtual class Factory {
    public ICrud Crud { get; private set; }
    public RepoFactory RepoFactory { get; private set;}

    private static Factory factory;

    //TODO: ここつかう
    @testVisible
    protected Factory() {
        this.Crud = new Crud();
        this.RepoFactory = new RepoFactory();
    }

    //TODO: 使うか微妙
    public static Factory getFactory() {
        //production code can only initialize the factory through this method
        if(factory == null) {
            factory = new Factory();
        }

        return factory;
    }

    //TODO: 使うか微妙
    //factory methods for initializing objects
    public OpportunityUpdater getOpportunityUpdater() {
        return new OpportunityUpdater(this);
    }

    @testVisible
    private Factory withMocks {
        get {
            this.Crud = new CrudMock();
            this.RepoFactory = new RepoFactoryMock();
            return this;
        }
    }
}
