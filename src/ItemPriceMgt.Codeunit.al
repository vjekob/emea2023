codeunit 50100 "Item Price Mgt."
{
    procedure GetItemPriceInCurrency(ItemNo: Code[20]) UnitPrice: Decimal
    var
        Item: Record Item;
        UserSetup: Record "User Setup";
        GLSetup: Record "General Ledger Setup";
        Converter: Codeunit "BC Converter";
    begin
        Item.Get(ItemNo);
        UserSetup.Get(UserId);
        GLSetup.Get();
        UnitPrice := GetItemPriceInCurrency(Item."Unit Price", UserSetup."Currency Code", GLSetup."LCY Code", WorkDate(), Converter);
    end;

    internal procedure GetItemPriceInCurrency(UnitPrice: Decimal; UserCurrencyCode: Code[10]; LCYCode: Code[10]; AtDate: Date; Converter: Interface IConverter): Decimal
    begin
        if UserCurrencyCode = '' then
            exit(UnitPrice);

        if LCYCode = UserCurrencyCode then
            exit(UnitPrice);

        exit(Converter.Convert(UnitPrice, UserCurrencyCode, AtDate));
    end;
}
