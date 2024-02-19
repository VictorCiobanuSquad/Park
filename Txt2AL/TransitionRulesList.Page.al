#pragma implicitwith disable
page 31009871 "Transition Rules List"
{
    Caption = 'Transition Rules List';
    Editable = false;
    PageType = ListPart;
    SourceTable = "Transition Rules";

    layout
    {
        area(content)
        {
            repeater(Control1102065000)
            {
                ShowCaption = false;
                field(Causes; Rec.Causes)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Resume School Process"; Rec."Resume School Process")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Maximum Absence Injustified"; Rec."Maximum Absence Injustified")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Maximum Absence Justified"; Rec."Maximum Absence Justified")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        OkVisible := true;
        helpVisible := true;
        CancelVisible := true;
    end;

    trigger OnOpenPage()
    begin
        if not CurrPage.LookupMode then begin
            CancelVisible := false;
            helpVisible := false;
            OkVisible := false;
        end else begin
            CancelVisible := true;
            helpVisible := true;
            OkVisible := true;
        end;
    end;

    var
        [InDataSet]
        CancelVisible: Boolean;
        [InDataSet]
        helpVisible: Boolean;
        [InDataSet]
        OkVisible: Boolean;

    //[Scope('OnPrem')]
    procedure UpdateForm()
    begin
        CurrPage.Update;
    end;
}

#pragma implicitwith restore

