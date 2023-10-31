interface IConverter
{
    procedure Convert(Amount: Decimal; CurrencyCode: Code[10]; AtDate: Date): Decimal;
}