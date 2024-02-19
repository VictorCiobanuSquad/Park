#pragma implicitwith disable
pageextension 50021 "Customer Card Ext." extends "Customer Card"
{
    /*    
    IT004 - Park - 2018.01.10 - novo campo Email2 para os envios por email

    JDE_INT SQD RTV 20210628
        Added fields "JDE Payer No." and "JDE Pupil No." on new tab "JDE"
    */
    layout
    {
        addafter("PTSS End Consumer")
        {
            field("Student No."; Rec."Student No.")
            {
                ApplicationArea = All;
            }
            field("User Family No."; Rec."User Family No.")
            {
                ApplicationArea = All;
            }
        }
        addafter("E-Mail")
        {
            field("E-Mail2"; Rec."E-Mail2")
            {
                ApplicationArea = All;
            }
        }
        addafter(Statistics)
        {
            group(Diversos)
            {
                field(IBAN; Rec.IBAN)
                {
                    ApplicationArea = All;
                }
                field(NIB; Rec.NIB)
                {
                    ApplicationArea = All;
                }
                field("Referencia ADC"; Rec."Referencia ADC")
                {
                    ApplicationArea = All;
                }
                field("Débitos Directos"; Rec."Débitos Directos")
                {
                    ApplicationArea = All;
                }
                field("ID CRED"; Rec."ID CRED")
                {
                    ApplicationArea = All;
                }
                field("EAN Enviado"; Rec."EAN Enviado")
                {
                    ApplicationArea = All;
                }
                field(Capital; Rec.Capital)
                {
                    ApplicationArea = All;
                }
                field(Representante; Rec.Representante)
                {
                    ApplicationArea = All;
                }
                field("Estado Civil"; Rec."Estado Civil")
                {
                    ApplicationArea = All;
                }
                field("Matrícula Conservatória"; Rec."Matrícula Conservatória")
                {
                    ApplicationArea = All;
                }
                field("Conservatória"; Rec."Conservatória")
                {
                    ApplicationArea = All;
                }
            }
            group(JDE)
            {
                field("JDE Payer No."; Rec."JDE Payer No.")
                {
                    ApplicationArea = All;
                }
                field("JDE Pupil No."; Rec."JDE Pupil No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        addafter(Email)
        {
            action(Email2)
            {
                ApplicationArea = All;
                Caption = 'Send Email2';
                Image = Email;
                ToolTip = 'Send an email to this customer E-mail2.';

                trigger OnAction()
                var
                    TempEmailItem: Record "Email Item" temporary;
                    EmailScenario: Enum "Email Scenario";
                begin
                    TempEmailItem.AddSourceDocument(Database::Customer, Rec.SystemId);
                    TempEmailitem."Send to" := Rec."E-Mail2";
                    TempEmailItem.Send(false, EmailScenario::Default);
                end;
            }
            action(GenADC)
            {
                ApplicationArea = All;
                Caption = 'Make Phone Call';

                trigger OnAction()
                var
                    GerarADC: Page "Gerar Ref. ADC";
                begin
                    IF Rec."ID CRED" = '' THEN
                        ERROR('Não preencheu o campo %1.', Rec.FIELDCAPTION("ID CRED"));

                    CLEAR(GerarADC);
                    GerarADC.LOOKUPMODE(TRUE);
                    GerarADC.RecebeCodCliente(Rec."No.", Rec."ID CRED", Rec."Débitos Directos", '');
                    GerarADC.RUNMODAL;
                    GerarADC.GetADC(Rec."Referencia ADC");
                    Rec.MODIFY;

                    //Normatica 2012.11.22
                    Rec.VALIDATE("Referencia ADC", Rec."Referencia ADC");
                end;
            }
        }
    }
}
#pragma implicitwith restore
