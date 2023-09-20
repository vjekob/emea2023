codeunit 50140 "Test Currency Conversion"
{
    Subtype = Test;

    var
        Assert: Codeunit Assert;
        LibraryInventory: Codeunit "Library - Inventory";
        LibraryERM: Codeunit "Library - ERM";

    // Shared Fixtures
    var
        Item: Record Item;
        LocalCurrency: Record Currency;
        ForeignCurrency: Record Currency;
        CurrencyExchRate: Record "Currency Exchange Rate";

    var
        ItemPriceMgt: Codeunit "Item Price Mgt.";

    [Test]
    procedure TestUserSetupNoCurrency()
    var
        UserSetup: Record "User Setup";
        UnitPrice: Decimal;
    begin
        // [SCENARIO] When the user is configured with no currency, converted price is equal to unit price
        Initialize();

        // [GIVEN] User setup with local currency
        InitializeUserSetup(UserSetup);
        UserSetup.Validate("Currency Code", '');
        UserSetup.Modify();

        // [GIVEN] An item (shared fixture)

        // [WHEN] The user converts the price
        UnitPrice := ItemPriceMgt.GetItemPriceInCurrency(Item."No.");

        // [THEN] The price must be equal to the unit price
        Assert.AreEqual(Item."Unit Price", UnitPrice, 'The price must be equal to the unit price');
    end;

    [Test]
    procedure TestUserSetupForeignCurrency()
    var
        UserSetup: Record "User Setup";
        UnitPrice: Decimal;
    begin
        // [SCENARIO] When the user is configured with foreign currency, converted price is correctly converted
        Initialize();

        // [GIVEN] User setup with foreign currency
        InitializeUserSetup(UserSetup);
        UserSetup.Validate("Currency Code", ForeignCurrency.Code);
        UserSetup.Modify();

        // [GIVEN] An item (shared fixture)

        // [WHEN] The user converts the price
        UnitPrice := ItemPriceMgt.GetItemPriceInCurrency(Item."No.");

        // [THEN] The price must be equal to the unit price
        Assert.AreEqual(Item."Unit Price" * 10, UnitPrice, 'The price must not be equal to the unit price');
    end;

    local procedure InitializeUserSetup(var UserSetup: Record "User Setup")
    begin
        if UserSetup.Get(UserId) then
            exit;

        UserSetup."User ID" := UserId;
        UserSetup.Insert();
    end;

    #region initialization

    var
        IsInitialized: Boolean;

    local procedure InitializeFreshFixtures()
    var
        ExchRate: Record "Currency Exchange Rate";
    begin
        LibraryERM.CreateCurrency(ForeignCurrency);
        LibraryERM.CreateExchangeRate(ForeignCurrency.Code, WorkDate(), 10, 1);
        ExchRate.Get(ForeignCurrency.Code, WorkDate());
        ExchRate."Fix Exchange Rate Amount" := ExchRate."Fix Exchange Rate Amount"::Both;
        ExchRate.Modify();
    end;

    local procedure InitializeSharedFixtures()
    var
        GLSetup: Record "General Ledger Setup";
    begin
        LibraryInventory.CreateItem(Item);
        Item."Unit Price" := 10;
        Item.Modify();

        LibraryERM.CreateCurrency(LocalCurrency);
        if not GLSetup.Get() then
            GLSetup.Insert();
        GLSetup."LCY Code" := LocalCurrency.Code;
        GLSetup.Modify();
    end;

    local procedure Initialize()
    var
        LibraryTestInitialize: Codeunit "Library - Test Initialize";
    begin
        LibraryTestInitialize.OnTestInitialize(Codeunit::"Test Currency Conversion");

        InitializeFreshFixtures();

        if IsInitialized then
            exit;

        LibraryTestInitialize.OnBeforeTestSuiteInitialize(Codeunit::"Test Currency Conversion");

        InitializeSharedFixtures();

        IsInitialized := true;
        Commit();
        LibraryTestInitialize.OnAfterTestSuiteInitialize(Codeunit::"Test Currency Conversion");
    end;

    #endregion

}
