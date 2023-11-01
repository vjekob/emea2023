codeunit 50141 "Test PurchaseInvHeaderEdit"
{
    Subtype = Test;

    var
        Assert: Codeunit Assert;
        LibraryPurchase: Codeunit "Library - Purchase";
        LibrarySales: Codeunit "Library - Sales";
        LibraryERM: Codeunit "Library - ERM";
        LibraryUtility: Codeunit "Library - Utility";

    [Test]
    procedure TestEditPurchInvHeader()
    var
        PurchInvHeader, PurchInvHeader2 : Record "Purch. Inv. Header";
        PurchInvHeaderEdit: Codeunit PurchInvHeaderEdit;
    begin
        // Assemble
        PurchInvHeader."Payment Reference" := LibraryUtility.GenerateRandomText(50);
        PurchInvHeader."Payment Method Code" := LibraryUtility.GenerateRandomText(10);
        PurchInvHeader."Creditor No." := LibraryUtility.GenerateRandomText(20);
        PurchInvHeader."Ship-to Code" := LibraryUtility.GenerateRandomText(10);
        PurchInvHeader."Posting Description" := LibraryUtility.GenerateRandomText(100);

        // Act
        PurchInvHeaderEdit.EditPurchInvHeader(PurchInvHeader2, PurchInvHeader);

        // Assert
        Assert.AreEqual(PurchInvHeader."Payment Reference", PurchInvHeader2."Payment Reference", 'Payment Reference not updated');
        Assert.AreEqual(PurchInvHeader."Payment Method Code", PurchInvHeader2."Payment Method Code", 'Payment Method Code not updated');
        Assert.AreEqual(PurchInvHeader."Creditor No.", PurchInvHeader2."Creditor No.", 'Creditor No. not updated');
        Assert.AreEqual(PurchInvHeader."Ship-to Code", PurchInvHeader2."Ship-to Code", 'Ship-to Code not updated');
        Assert.AreEqual(PurchInvHeader."Posting Description", PurchInvHeader2."Posting Description", 'Posting Description not updated');
    end;

    [Test]
    procedure TestEditVendorLedgEntry()
    var
        PurchInvHeader: Record "Purch. Inv. Header";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        PurchInvHeaderEdit: Codeunit PurchInvHeaderEdit;
    begin
        // Assemble
        PurchInvHeader."Payment Reference" := LibraryUtility.GenerateRandomText(50);
        PurchInvHeader."Payment Method Code" := LibraryUtility.GenerateRandomText(10);
        PurchInvHeader."Creditor No." := LibraryUtility.GenerateRandomText(20);
        PurchInvHeader."Ship-to Code" := LibraryUtility.GenerateRandomText(10);
        PurchInvHeader."Posting Description" := LibraryUtility.GenerateRandomText(100);

        // Act
        PurchInvHeaderEdit.EditVendorLedgerEntry(VendorLedgerEntry, PurchInvHeader);

        // Assert
        Assert.AreEqual(PurchInvHeader."Payment Reference", VendorLedgerEntry."Payment Reference", 'Payment Reference not updated');
        Assert.AreEqual(PurchInvHeader."Payment Method Code", VendorLedgerEntry."Payment Method Code", 'Payment Method Code not updated');
        Assert.AreEqual(PurchInvHeader."Creditor No.", VendorLedgerEntry."Creditor No.", 'Creditor No. not updated');
        Assert.AreEqual(PurchInvHeader."Posting Description", VendorLedgerEntry.Description, 'Posting Description not updated');
    end;

    [Test]
    procedure TestNoVendorLedgerEntry()
    var
        PurchInvHeader, PurchInvHeader2 : Record "Purch. Inv. Header";
        MockEdit: Codeunit MockPurchInvHeaderEdit;
        PurchInvHeaderEdit: Codeunit PurchInvHeaderEdit;
    begin
        // Act
        PurchInvHeaderEdit.DoEditPurchInvHeader(PurchInvHeader, PurchInvHeader2, MockEdit);

        // Assert
        Assert.IsTrue(MockEdit.IsPurchInvHeaderModified(), 'Purch. Inv. Header not modified');
        Assert.IsFalse(MockEdit.IsVendorEntryEditCalled(), 'Vendor Ledger Entry should not be modified');
        Assert.IsFalse(MockEdit.IsVendorEntryEditCalled(), 'Vendor edit should not be run');
    end;

    [Test]
    procedure TestWithVendorLedgerEntry()
    var
        PurchInvHeader, PurchInvHeader2 : Record "Purch. Inv. Header";
        MockEdit: Codeunit MockPurchInvHeaderEdit;
        PurchInvHeaderEdit: Codeunit PurchInvHeaderEdit;
    begin
        // Assemble
        MockEdit.SetHasVendorLedgerEntry(true);

        // Act
        PurchInvHeaderEdit.DoEditPurchInvHeader(PurchInvHeader, PurchInvHeader2, MockEdit);

        // Assert
        Assert.IsTrue(MockEdit.IsPurchInvHeaderModified(), 'Purch. Inv. Header not modified');
        Assert.IsTrue(MockEdit.IsVendorEntryEditCalled(), 'Vendor edit should be run');
        Assert.IsTrue(MockEdit.IsVendorEntryEditCalled(), 'Vendor Ledger Entry should be modified');
    end;

}
