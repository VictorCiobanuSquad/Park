page 50021 "Encomendas Lista"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Encomendas Cab";
    Caption = 'Lista de Encomendas';
    InsertAllowed = false;
    DeleteAllowed = false;

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
                field("Users Family Customer No."; Rec."Users Family Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Bill-to Customer Name"; Rec."Bill-to Customer Name")
                {
                    ApplicationArea = All;
                }
                field("Order Date"; Rec."Order Date")
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
                RunObject = page "Encomendas Ficha Cab";
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
                Caption = 'Create Mark Orders';

                trigger OnAction()
                var
                    MarkOrders: Integer;
                    PostingDateForm: Page "Posting Date Form";
                    NewPostingDate: Date;
                    Text001: Label 'Mark %1 document. Create a order?';
                    Text002: Label 'Not have selected documents!';
                    Text003: Label 'Selecionou %1 documentos. Deseja criar as encomendas?';
                    Text004: Label 'Posting Date cannot be empty!.';
                begin
                    MarkOrders := Rec.CountMarkOrders;
                    IF MarkOrders > 0 THEN BEGIN
                        IF MarkOrders = 1 THEN BEGIN
                            IF CONFIRM(STRSUBSTNO(Text001, MarkOrders, TRUE)) THEN
                                CLEAR(PostingDateForm);
                            PostingDateForm.RUNMODAL;
                            NewPostingDate := PostingDateForm.GetPostingDate;
                            IF NewPostingDate <> 0D THEN BEGIN
                                Rec.PickOrderCreate(NewPostingDate);
                            END ELSE
                                MESSAGE(Text004);
                        END ELSE BEGIN
                            IF CONFIRM(STRSUBSTNO(Text003, MarkOrders, TRUE)) THEN
                                CLEAR(PostingDateForm);
                            PostingDateForm.RUNMODAL;
                            NewPostingDate := PostingDateForm.GetPostingDate;
                            IF NewPostingDate <> 0D THEN BEGIN
                                Rec.PickOrderCreate(NewPostingDate);
                            END ELSE
                                MESSAGE(Text004);
                        END;
                    END ELSE
                        MESSAGE(Text002);
                end;
            }
        }
    }
}