codeunit 50144 MockPurchInvHeaderEdit implements IPurchInvHeaderEdit
{
    procedure FindPurchInvHeader(var PurchInvHeader: Record "Purch. Inv. Header"; FromPurchInvHeader: Record "Purch. Inv. Header");
    begin
        // Nothing to do
    end;

    procedure EditPurchInvHeader(var PurchInvHeader: Record "Purch. Inv. Header"; FromPurchInvHeader: Record "Purch. Inv. Header");
    begin
        // Nothing to do
    end;

    var
        _purchInvHeaderModified: Boolean;

    procedure IsPurchInvHeaderModified(): Boolean
    begin
        exit(_purchInvHeaderModified);
    end;

    procedure ModifyPurchInvHeader(var PurchInvHeader: Record "Purch. Inv. Header"; FromPurchInvHeader: Record "Purch. Inv. Header");
    begin
        _purchInvHeaderModified := true;
    end;

    var
        _hasVendorLedgerEntry: Boolean;

    procedure SetHasVendorLedgerEntry(value: Boolean)
    begin
        _hasVendorLedgerEntry := value;
    end;

    procedure GetVendorLedgerEntry(var VendorLedgerEntry: Record "Vendor Ledger Entry"; PurchInvHeader: Record "Purch. Inv. Header"): Boolean;
    begin
        exit(_hasVendorLedgerEntry);
    end;

    var
        _editVendorLedgerEntryCalled: Boolean;

    procedure IsEditVendorLedgerEntryCalled(): Boolean
    begin
        exit(_editVendorLedgerEntryCalled);
    end;

    procedure EditVendorLedgerEntry(var VendorLedgerEntry: Record "Vendor Ledger Entry"; PurchInvHeader: Record "Purch. Inv. Header");
    begin
        _editVendorLedgerEntryCalled := true;
    end;

    var
        _vendorEntryEditCalled: Boolean;

    procedure IsVendorEntryEditCalled(): Boolean
    begin
        exit(_vendorEntryEditCalled);
    end;

    procedure RunVendorEntryEdit(var VendorLedgerEntry: Record "Vendor Ledger Entry");
    begin
        _vendorEntryEditCalled := true;
    end;
}