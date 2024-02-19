pageextension 50370 "Bank Account Card Ext." extends "Bank Account Card"
{
    layout
    {
        addafter("PTSS CCC No.")
        {
            field(Sign1Name; Rec.Sign1Name)
            {
                ApplicationArea = All;
            }
            field(Sign2Name; Rec.Sign2Name)
            {
                ApplicationArea = All;
            }
            group(Transfers)
            {
                Caption = 'Transfer';

                field("Nome Diário Recebimentos"; Rec."Nome Diário Recebimentos")
                {
                    ApplicationArea = All;
                }
                field("Nome Secção Diário Rec."; Rec."Nome Secção Diário Rec.")
                {
                    ApplicationArea = All;
                }
                field("Conta Clientes Diário Rec."; Rec."Conta Clientes Diário Rec.")
                {
                    ApplicationArea = All;
                }
                field("Cod. Fluxo-Caixa"; Rec."Cod. Fluxo-Caixa")
                {
                    ApplicationArea = All;
                }
                field("Bank Entity"; Rec."Bank Entity")
                {
                    ApplicationArea = All;
                }
            }
            group(Config)
            {
                Caption = 'Configurations';

                field("Caminho Ficheiro PS2"; Rec."Caminho Ficheiro PS2")
                {
                    ApplicationArea = All;
                }
                field("Código Tipo Operação"; Rec."Código Tipo Operação")
                {
                    ApplicationArea = All;
                }
                field("Referencia Ficheiro PS2"; Rec."Referencia Ficheiro PS2")
                {
                    ApplicationArea = All;
                }
                field("Nome Diário PS2"; Rec."Nome Diário PS2")
                {
                    ApplicationArea = All;
                }
                field("Nome Secção PS2"; Rec."Nome Secção PS2")
                {
                    ApplicationArea = All;
                }
                field("Caminho Ficheiro EAN"; Rec."Caminho Ficheiro EAN")
                {
                    ApplicationArea = All;
                }
                field("ID CRED"; Rec."ID CRED")
                {
                    ApplicationArea = All;
                }
                field("Débitos Directos"; Rec."Débitos Directos")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}