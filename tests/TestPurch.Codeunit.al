codeunit 50103 "Test PurchaseInvHeaderEdit"
{
    Subtype = Test;

    var
        Assert: Codeunit Assert;
        LibraryPurchase: Codeunit "Library - Purchase";
        LibrarySales: Codeunit "Library - Sales";
        LibraryERM: Codeunit "Library - ERM";
        LibraryUtility: Codeunit "Library - Utility";

    [Test]
    procedure TestEdit()
    var
        PurchaseHeader: Record "Purchase Header";
        PurchInvHeader, PurchInvHeader2 : Record "Purch. Inv. Header";
        PaymentMethod: Record "Payment Method";
        Customer: Record Customer;
        ShipToAddress: Record "Ship-to Address";
        VendorLedgEntry: Record "Vendor Ledger Entry";
        PurchInvHeaderEdit: Codeunit PurchInvHeaderEdit;
        PostedInvoiceNo: Code[20];
    begin
        // [GIVEN] A purchase invoice
        LibraryPurchase.CreatePurchaseInvoice(PurchaseHeader);

        // [GIVEN] A customer
        LibrarySales.CreateCustomer(Customer);

        // [GIVEN] A ship-to address
        LibrarySales.CreateShipToAddress(ShipToAddress, Customer."No.");

        // [GIVEN] Purchase header is for the customer
        PurchaseHeader.Validate("Sell-to Customer No.", Customer."No.");
        PurchaseHeader.Modify(true);

        // [GIVEN] Post the invoice
        PostedInvoiceNo := LibraryPurchase.PostPurchaseDocument(PurchaseHeader, true, true);

        // [GIVEN] Posted purchase invoice header
        PurchInvHeader.Get(PostedInvoiceNo);

        // [GIVEN] A payment method
        LibraryERM.CreatePaymentMethod(PaymentMethod);

        // [GIVEN] Changing some fields
        PurchInvHeader."Payment Reference" := LibraryUtility.GenerateRandomText(50);
        PurchInvHeader."Payment Method Code" := PaymentMethod.Code;
        PurchInvHeader."Creditor No." := LibraryUtility.GenerateRandomText(20);
        PurchInvHeader."Ship-to Code" := ShipToAddress.Code;
        PurchInvHeader."Posting Description" := LibraryUtility.GenerateRandomText(100);

        // [WHEN] Running purchase invoice header edit
        PurchInvHeaderEdit.Run(PurchInvHeader);

        // [THEN] Purchase invoice record is updated
        PurchInvHeader2.Get(PostedInvoiceNo);
        Assert.AreEqual(PurchInvHeader."Payment Reference", PurchInvHeader2."Payment Reference", 'Payment Reference not updated');
        Assert.AreEqual(PurchInvHeader."Payment Method Code", PurchInvHeader2."Payment Method Code", 'Payment Method Code not updated');
        Assert.AreEqual(PurchInvHeader."Creditor No.", PurchInvHeader2."Creditor No.", 'Creditor No. not updated');
        Assert.AreEqual(PurchInvHeader."Ship-to Code", PurchInvHeader2."Ship-to Code", 'Ship-to Code not updated');
        Assert.AreEqual(PurchInvHeader."Posting Description", PurchInvHeader2."Posting Description", 'Posting Description not updated');

        // [THEN] Vendor ledger entry updated
        VendorLedgEntry.Get(PurchInvHeader2."Vendor Ledger Entry No.");
        Assert.AreEqual(PurchInvHeader2."Payment Reference", VendorLedgEntry."Payment Reference", 'Payment Reference not updated');
        Assert.AreEqual(PurchInvHeader2."Payment Method Code", VendorLedgEntry."Payment Method Code", 'Payment Method Code not updated');
        Assert.AreEqual(PurchInvHeader2."Creditor No.", VendorLedgEntry."Creditor No.", 'Creditor No. not updated');
        Assert.AreEqual(PurchInvHeader2."Posting Description", VendorLedgEntry.Description, 'Posting Description not updated');
    end;
}
