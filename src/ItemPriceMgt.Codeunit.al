codeunit 50100 "Item Price Mgt."
{
    procedure GetItemPriceInCurrency(ItemNo: Code[20]) UnitPrice: Decimal
    var
        Item: Record Item;
        UserSetup: Record "User Setup";
        GLSetup: Record "General Ledger Setup";
        ExchRate: Record "Currency Exchange Rate";
    begin
        Item.Get(ItemNo);
        UnitPrice := Item."Unit Price";

        if not UserSetup.Get(UserId) then
            exit;

        if UserSetup."Currency Code" = '' then
            exit;

        GLSetup.Get();
        if GLSetup."LCY Code" = UserSetup."Currency Code" then
            exit;

        UnitPrice := ExchRate.ExchangeAmtLCYToFCY(WorkDate(), UserSetup."Currency Code", UnitPrice, 1);
    end;
}
