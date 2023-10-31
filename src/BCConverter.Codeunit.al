codeunit 50101 "BC Converter" implements IConverter
{
    procedure Convert(Amount: Decimal; CurrencyCode: Code[10]; AtDate: Date) UnitPrice: Decimal;
    var
        ExchRate: Record "Currency Exchange Rate";
    begin
        UnitPrice := ExchRate.ExchangeAmtLCYToFCY(AtDate, CurrencyCode, Amount, 1);
    end;
}
