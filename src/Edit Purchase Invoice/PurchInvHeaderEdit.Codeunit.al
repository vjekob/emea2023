codeunit 50102 PurchInvHeaderEdit implements IPurchInvHeaderEdit
{
    Permissions = TableData "Purch. Inv. Header" = rm;
    TableNo = "Purch. Inv. Header";

    #region Code that does not require testing

    trigger OnRun()
    var
        PurchInvHeader: Record "Purch. Inv. Header";
        This: Codeunit PurchInvHeaderEdit;
    begin
        DoEditPurchInvHeader(PurchInvHeader, Rec, This);
    end;

    internal procedure GetVendorLedgerEntry(var VendorLedgerEntry: Record "Vendor Ledger Entry"; PurchInvHeader: Record "Purch. Inv. Header"): Boolean
    begin
        if PurchInvHeader."Vendor Ledger Entry No." = 0 then
            exit(false);
        VendorLedgerEntry.ReadIsolation(IsolationLevel::UpdLock);
        exit(VendorLedgerEntry.Get(PurchInvHeader."Vendor Ledger Entry No."));
    end;

    internal procedure FindPurchInvHeader(var PurchInvHeader: Record "Purch. Inv. Header"; FromPurchInvHeader: Record "Purch. Inv. Header")
    begin
        PurchInvHeader.Copy(FromPurchInvHeader);
        PurchInvHeader.ReadIsolation(IsolationLevel::UpdLock);
        PurchInvHeader.Find();
    end;

    internal procedure ModifyPurchInvHeader(var PurchInvHeader: Record "Purch. Inv. Header"; FromPurchInvHeader: Record "Purch. Inv. Header")
    begin
        PurchInvHeader.TestField("No.", FromPurchInvHeader."No.");
        PurchInvHeader.Modify();
    end;

    internal procedure RunVendorEntryEdit(var VendorLedgerEntry: Record "Vendor Ledger Entry")
    begin
        Codeunit.Run(Codeunit::"Vend. Entry-Edit", VendorLedgerEntry);
    end;

    #endregion

    internal procedure DoEditPurchInvHeader(var PurchInvHeader: Record "Purch. Inv. Header"; var Rec: Record "Purch. Inv. Header"; Edit: Interface IPurchInvHeaderEdit)
    begin
        Edit.FindPurchInvHeader(PurchInvHeader, Rec);
        Edit.EditPurchInvHeader(PurchInvHeader, Rec);
        Edit.ModifyPurchInvHeader(PurchInvHeader, Rec);

        OnBeforePurchInvHeaderModify(PurchInvHeader, Rec);
        Rec.Copy(PurchInvHeader);

        UpdateVendorLedgerEntry(Rec, Edit);

        OnRunOnAfterPurchInvHeaderEdit(Rec);
    end;

    internal procedure EditPurchInvHeader(var PurchInvHeader: Record "Purch. Inv. Header"; FromPurchInvHeader: Record "Purch. Inv. Header")
    begin
        PurchInvHeader."Payment Reference" := FromPurchInvHeader."Payment Reference";
        PurchInvHeader."Payment Method Code" := FromPurchInvHeader."Payment Method Code";
        PurchInvHeader."Creditor No." := FromPurchInvHeader."Creditor No.";
        PurchInvHeader."Ship-to Code" := FromPurchInvHeader."Ship-to Code";
        PurchInvHeader."Posting Description" := FromPurchInvHeader."Posting Description";
    end;

    local procedure UpdateVendorLedgerEntry(PurchInvHeader: Record "Purch. Inv. Header"; Edit: Interface IPurchInvHeaderEdit)
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
    begin
        if not Edit.GetVendorLedgerEntry(VendorLedgerEntry, PurchInvHeader) then
            exit;

        Edit.EditVendorLedgerEntry(VendorLedgerEntry, PurchInvHeader);
        OnBeforeUpdateVendorLedgerEntryAfterSetValues(VendorLedgerEntry, PurchInvHeader);
        Edit.RunVendorEntryEdit(VendorLedgerEntry);
    end;

    internal procedure EditVendorLedgerEntry(var VendorLedgerEntry: Record "Vendor Ledger Entry"; PurchInvHeader: Record "Purch. Inv. Header")
    begin
        VendorLedgerEntry."Payment Method Code" := PurchInvHeader."Payment Method Code";
        VendorLedgerEntry."Payment Reference" := PurchInvHeader."Payment Reference";
        VendorLedgerEntry."Creditor No." := PurchInvHeader."Creditor No.";
        VendorLedgerEntry.Description := PurchInvHeader."Posting Description";
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePurchInvHeaderModify(var PurchInvHeader: Record "Purch. Inv. Header"; PurchInvHeaderRec: Record "Purch. Inv. Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdateVendorLedgerEntryAfterSetValues(var VendorLedgerEntry: Record "Vendor Ledger Entry"; PurchInvHeader: Record "Purch. Inv. Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnRunOnAfterPurchInvHeaderEdit(var PurchInvHeader: Record "Purch. Inv. Header")
    begin
    end;
}

