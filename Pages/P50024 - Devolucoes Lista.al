page 50024 "Devolucoes Lista"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Devolucoes Cab";
    Caption = 'Lista de Devoluções';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Pick; Rec.Pick)
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Invoice No."; Rec."Invoice No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Card)
            {
                ApplicationArea = All;
                Caption = 'Ficha';
                ShortcutKey = 'Shift+F5';
                RunObject = page "Devolucoes Ficha Cab";
                RunPageLink = "No." = FIELD("No.");
            }
            action(MarkAll)
            {
                ApplicationArea = All;
                Caption = 'Mark All';

                trigger OnAction()
                begin
                    Rec.SelectAll();
                end;
            }
            action(UnmarkAll)
            {
                ApplicationArea = All;
                Caption = 'Unmark selection';

                trigger OnAction()
                begin
                    Rec.UnSelectAll();
                end;
            }
            action(Create)
            {
                ApplicationArea = All;
                Caption = 'Create Mark Returns';

                trigger OnAction()
                var
                    MarkReturns: Integer;
                    Text001: Label 'Has mark %1 document(s). Want to create Returns?';
                    Text002: Label 'Not have selected documents!';
                    Text003: Label 'Selecionou %1 documentos. Deseja criar as Devoluções?';
                begin
                    MarkReturns := Rec.CountMarkReturns;
                    IF MarkReturns > 0 THEN BEGIN
                        IF MarkReturns = 1 THEN BEGIN
                            IF CONFIRM(STRSUBSTNO(Text003, MarkReturns, TRUE)) THEN
                                Rec.PickReturnCreate;
                        END ELSE BEGIN
                            IF CONFIRM(STRSUBSTNO(Text001, MarkReturns, TRUE)) THEN
                                Rec.PickReturnCreate;
                        END;
                    END ELSE
                        MESSAGE(Text002);
                end;
            }
        }
    }
}