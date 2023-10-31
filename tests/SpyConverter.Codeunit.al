codeunit 50142 "DEMO Spy Converter" implements IConverter
{
    var
        _invoked: Boolean;

    procedure Convert(Amount: Decimal; CurrencyCode: Code[10]; AtDate: Date): Decimal;
    begin
        _invoked := true;
    end;

    procedure IsInvoked(): Boolean
    begin
        exit(_invoked);
    end;
}
