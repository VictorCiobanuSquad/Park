#pragma implicitwith disable
page 52891 "Transport Card"
{
    Caption = 'Transport Card';
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = Transport;
    SourceTableView = WHERE(Type = FILTER(Header));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Transport No."; Rec."Transport No.")
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("License plate"; Rec."License plate")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Driver; Rec.Driver)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Vendor; Rec.Vendor)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Observations; Rec.Observations)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Responsibility Center';
                }
                field("Number of Stops"; Rec."Number of Stops")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Picture; Rec.Picture)
                {
                    ApplicationArea = Basic, Suite;
                    ShowCaption = false;
                }
            }
            part("Linhas Veiculo"; "Vehicle Lines")
            {
                ApplicationArea = All;
                SubPageLink = "Transport No." = FIELD("Transport No."),
                              Type = FILTER(Lines);
            }
        }
    }

    actions
    {
    }

    var
        Text001: Label 'Do you want to replace the existing picture?';
        Text002: Label 'Do you want to delete the picture?';
}

#pragma implicitwith restore

