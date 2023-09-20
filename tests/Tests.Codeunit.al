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
    procedure TestNoItem()
    var
        UserSetup: Record "User Setup";
        UnitPrice: Decimal;
    begin
        // [SCENARIO] When invalid item is specified, conversion must fail
        Initialize();

        // [GIVEN] No item
        Item.Delete();

        // [WHEN] The user converts the price
        asserterror UnitPrice := ItemPriceMgt.GetItemPriceInCurrency(Item."No.");

        // [THEN] The price must be equal to the unit price
        Assert.ExpectedErrorCode('NotFound');
    end;

    [Test]
    procedure TestNoUserSetup()
    var
        UserSetup: Record "User Setup";
        UnitPrice: Decimal;
    begin
        // [SCENARIO] When there is no user setup, converted price is equal to unit price
        Initialize();

        // [GIVEN] No user setup
        if UserSetup.Get(UserId) then
            UserSetup.Delete();

        // [GIVEN] An item (shared fixture)

        // [WHEN] The user converts the price
        UnitPrice := ItemPriceMgt.GetItemPriceInCurrency(Item."No.");

        // [THEN] The price must be equal to the unit price
        Assert.AreEqual(Item."Unit Price", UnitPrice, 'The price must be equal to the unit price');
    end;

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
    procedure TestNoGLSetup()
    var
        GLSetup: Record "General Ledger Setup";
        UserSetup: Record "User Setup";
        UnitPrice: Decimal;
    begin
        // [SCENARIO] When there is no General Ledger Setup, conversion must fail
        Initialize();

        // [GIVEN] User setup with foreign currency
        InitializeUserSetup(UserSetup);
        UserSetup.Validate("Currency Code", ForeignCurrency.Code);
        UserSetup.Modify();

        // [GIVEN] An item (shared fixture)

        // [GIVEN] No General Ledger Setup
        GLSetup.Delete();

        // [GIVEN] Invalid currency specified - currency does not exist
        ForeignCurrency.Delete(true);

        // [WHEN] The user converts the price
        asserterror UnitPrice := ItemPriceMgt.GetItemPriceInCurrency(Item."No.");

        // [THEN] The price must be equal to the unit price
        Assert.ExpectedErrorCode('NotFound');
    end;

    [Test]
    procedure TestUserSetupLocalCurrency()
    var
        UserSetup: Record "User Setup";
        UnitPrice: Decimal;
    begin
        // [SCENARIO] When the user is configured with local currency, converted price is equal to unit price
        Initialize();

        // [GIVEN] User setup with local currency
        InitializeUserSetup(UserSetup);
        UserSetup.Validate("Currency Code", LocalCurrency.Code);
        UserSetup.Modify();

        // [GIVEN] An item (shared fixture)

        // [WHEN] The user converts the price
        UnitPrice := ItemPriceMgt.GetItemPriceInCurrency(Item."No.");

        // [THEN] The price must be equal to the unit price
        Assert.AreEqual(Item."Unit Price", UnitPrice, 'The price must be equal to the unit price');
    end;

    [Test]
    procedure TestUserSetupForeignCurrencyInvalid()
    var
        UserSetup: Record "User Setup";
        UnitPrice: Decimal;
    begin
        // [SCENARIO] When the user is configured with invalid foreign currency, conversion fails
        Initialize();

        // [GIVEN] User setup with foreign currency
        InitializeUserSetup(UserSetup);
        UserSetup.Validate("Currency Code", ForeignCurrency.Code);
        UserSetup.Modify();

        // [GIVEN] An item (shared fixture)

        // [GIVEN] Invalid currency specified - currency does not exist
        ForeignCurrency.Delete(true);

        // [WHEN] The user converts the price
        asserterror UnitPrice := ItemPriceMgt.GetItemPriceInCurrency(Item."No.");

        // [THEN] The price must be equal to the unit price
        Assert.ExpectedErrorCode('DB:NothingInsideFilter');
    end;

    [Test]
    procedure TestUserSetupForeignCurrencyNoExchangeRate()
    var
        UserSetup: Record "User Setup";
        UnitPrice: Decimal;
        ExchRate: Record "Currency Exchange Rate";
    begin
        // [SCENARIO] When the user is configured with foreign currency, but there is no exchange rate, conversion must fail
        Initialize();

        // [GIVEN] User setup with foreign currency
        InitializeUserSetup(UserSetup);
        UserSetup.Validate("Currency Code", ForeignCurrency.Code);
        UserSetup.Modify();

        // [GIVEN] An item (shared fixture)

        // [GIVEN] No exchange rate
        ExchRate.SetRange("Currency Code");
        ExchRate.DeleteAll();

        // [WHEN] The user converts the price
        asserterror UnitPrice := ItemPriceMgt.GetItemPriceInCurrency(Item."No.");

        // [THEN] The price must be equal to the unit price
        Assert.ExpectedErrorCode('DB:NothingInsideFilter');
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
