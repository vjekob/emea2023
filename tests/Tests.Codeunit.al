codeunit 50140 "Test Currency Conversion"
{
    Subtype = Test;

    var
        Assert: Codeunit Assert;
        ItemPriceMgt: Codeunit "Item Price Mgt.";

    [Test]
    procedure TestUserSetupNoCurrency()
    var
        Spy: Codeunit "DEMO Spy Converter";
        ConvertedAmount, Amount : Decimal;
    begin
        // Assemble
        Amount := Random(10000) / 3.14;

        // Act
        ConvertedAmount := ItemPriceMgt.GetItemPriceInCurrency(Amount, '', 'LCY', WorkDate(), Spy);

        // Assert
        Assert.IsFalse(Spy.IsInvoked(), 'Converter must not be invoked');
        Assert.AreEqual(Amount, ConvertedAmount, 'Amount must not be converted');
    end;

    [Test]
    procedure TestUserSetupLocalCurrency()
    var
        Spy: Codeunit "DEMO Spy Converter";
        ConvertedAmount, Amount : Decimal;
    begin
        // Assemble
        Amount := Random(10000) / 3.14;

        // Act
        ConvertedAmount := ItemPriceMgt.GetItemPriceInCurrency(Amount, 'LCY', 'LCY', WorkDate(), Spy);

        // Assert
        Assert.IsFalse(Spy.IsInvoked(), 'Converter must not be invoked');
        Assert.AreEqual(Amount, ConvertedAmount, 'Amount must not be converted');
    end;

    [Test]
    procedure TestUserSetupForeignCurrency()
    var
        Stub: Codeunit "DEMO Stub Converter";
        ConvertedAmount, Amount : Decimal;
    begin
        // Assemble
        Amount := Random(10000) / 3.14;
        Stub.SetAmount(Amount);

        // Act
        ConvertedAmount := ItemPriceMgt.GetItemPriceInCurrency(Amount, 'FCY', 'LCY', WorkDate(), Stub);

        // Assert
        Assert.AreEqual(Amount, ConvertedAmount, 'Converter didn''t return the expected value');
    end;

}
