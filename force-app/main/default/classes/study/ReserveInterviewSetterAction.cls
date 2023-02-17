global class ReserveInterviewSetterAction {
    @InvocableMethod(label='値段セット関数' description='テスト値段をセットする関数')
    global static List<PriceOutput> getPrice() {
        List<PriceOutput> result = new List<PriceOutput>();
        PriceOutput output = new PriceOutput();
        output.testPrice = 99999;
        result.add(output);

        return result;
    }

    global class PriceOutput {
        @InvocableVariable(description='テスト値段')
        global Integer testPrice;
    }
}
