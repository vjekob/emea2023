codeunit 50143 "DEMO Stub Converter" implements IConverter
{
    var
        _amount: Decimal;


    procedure SetAmount(Amount: Decimal);
    begin
        _amount := Amount;
    end;

    procedure Convert(Amount: Decimal; CurrencyCode: Code[10]; AtDate: Date): Decimal;
    begin
        exit(_amount);
    end;
}
