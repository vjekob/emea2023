interface IPurchInvHeaderEdit
{
    Access = Internal;

    procedure FindPurchInvHeader(var PurchInvHeader: Record "Purch. Inv. Header"; FromPurchInvHeader: Record "Purch. Inv. Header");
    procedure EditPurchInvHeader(var PurchInvHeader: Record "Purch. Inv. Header"; FromPurchInvHeader: Record "Purch. Inv. Header");
    procedure ModifyPurchInvHeader(var PurchInvHeader: Record "Purch. Inv. Header"; FromPurchInvHeader: Record "Purch. Inv. Header");

    procedure GetVendorLedgerEntry(var VendorLedgerEntry: Record "Vendor Ledger Entry"; PurchInvHeader: Record "Purch. Inv. Header"): Boolean;
    procedure EditVendorLedgerEntry(var VendorLedgerEntry: Record "Vendor Ledger Entry"; PurchInvHeader: Record "Purch. Inv. Header");
    procedure RunVendorEntryEdit(var VendorLedgerEntry: Record "Vendor Ledger Entry");
}
