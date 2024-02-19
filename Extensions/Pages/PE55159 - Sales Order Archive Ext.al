pageextension 55159 "Sales Order Archive Ext." extends "Sales Order Archive"
{
    layout
    {
        addbefore("Bill-to Customer No.")
        {
            field(Turma; Rec.Turma)
            {
                ApplicationArea = All;
            }
            field("Ano Escolaridade"; Rec."Ano Escolaridade")
            {
                ApplicationArea = All;
            }
        }
    }
}