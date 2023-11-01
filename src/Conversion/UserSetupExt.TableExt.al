tableextension 50100 "User Setup Ext" extends "User Setup"
{
    fields
    {
        field(50100; "Currency Code"; Code[10])
        {
            Caption = 'Display Currency Code';
            DataClassification = CustomerContent;
            TableRelation = Currency;
        }
    }
}
