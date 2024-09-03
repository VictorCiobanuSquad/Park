#pragma implicitwith disable
page 52829 "Rules of Evaluation Subform"
{
    Caption = 'Rules of Evaluation Subform';
    InsertAllowed = false;
    PageType = ListPart;
    RefreshOnActivate = true;
    SourceTable = "Rules of Evaluations";

    layout
    {
        area(content)
        {
            repeater(TableBox)
            {
                field("Schooling Year"; Rec."Schooling Year")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Level Group"; Rec."Level Group")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Formula; Rec.Formula)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = FormulaVisible;
                }
                field("Classifications Calculations"; Rec."Classifications Calculations")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = ClassificationsCalculationsVis;
                }
                field("Value 1"; Rec."Value 1")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = "Value 1Visible";
                }
                field("Code Value 1"; Rec."Code Value 1")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = "Code Value 1Visible";
                }
                field("Value 2"; Rec."Value 2")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = "Value 2Visible";
                }
                field("Code Value 2"; Rec."Code Value 2")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = "Code Value 2Visible";
                }
                field("Value 3"; Rec."Value 3")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = "Value 3Visible";
                }
                field("Code Value 3"; Rec."Code Value 3")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = "Code Value 3Visible";
                }
                field("Value 4"; Rec."Value 4")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = "Value 4Visible";
                }
                field("Code Value 4"; Rec."Code Value 4")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = "Code Value 4Visible";
                }
                field("Value 5"; Rec."Value 5")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = "Value 5Visible";
                }
                field("Code Value 5"; Rec."Code Value 5")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = "Code Value 5Visible";
                }
                field("Value 6"; Rec."Value 6")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = "Value 6Visible";
                }
                field("Code Value 6"; Rec."Code Value 6")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = "Code Value 6Visible";
                }
                field("Evaluation Type"; Rec."Evaluation Type")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = "Evaluation TypeVisible";
                }
                field("Assessment Code"; Rec."Assessment Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = "Assessment CodeVisible";
                }
                field("Round Method"; Rec."Round Method")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = "Round MethodVisible";
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        CurrPage.LookupMode := false;
        "Round MethodVisible" := true;
        "Assessment CodeVisible" := true;
        "Evaluation TypeVisible" := true;
        FormulaVisible := true;
        "Code Value 6Visible" := true;
        "Value 6Visible" := true;
        "Code Value 5Visible" := true;
        "Value 5Visible" := true;
        "Code Value 4Visible" := true;
        "Value 4Visible" := true;
        "Code Value 3Visible" := true;
        "Value 3Visible" := true;
        "Code Value 2Visible" := true;
        "Value 2Visible" := true;
        "Code Value 1Visible" := true;
        "Value 1Visible" := true;
        ClassificationsCalculationsVis := true;
        OKVisible := true;
        HELPVisible := true;
        CancelVisible := true;
    end;

    trigger OnOpenPage()
    begin
        if not CurrPage.LookupMode then begin
            CancelVisible := false;
            HELPVisible := false;
            OKVisible := false;
            TableBoxHeight := 6820;
            ClassificationsCalculationsVis := false;
            "Value 1Visible" := false;
            "Code Value 1Visible" := false;
            "Value 2Visible" := false;
            "Code Value 2Visible" := false;
            "Value 3Visible" := false;
            "Code Value 3Visible" := false;
            "Value 4Visible" := false;
            "Code Value 4Visible" := false;
            "Value 5Visible" := false;
            "Code Value 5Visible" := false;
            "Value 6Visible" := false;
            "Code Value 6Visible" := false;
            FormulaVisible := false;
        end else begin
            ClassificationsCalculationsVis := false;
            "Value 1Visible" := false;
            "Code Value 1Visible" := false;
            "Value 2Visible" := false;
            "Code Value 2Visible" := false;
            "Value 3Visible" := false;
            "Code Value 3Visible" := false;
            "Value 4Visible" := false;
            "Code Value 4Visible" := false;
            "Value 5Visible" := false;
            "Code Value 5Visible" := false;
            "Value 6Visible" := false;
            "Code Value 6Visible" := false;
            "Evaluation TypeVisible" := false;
            "Assessment CodeVisible" := false;
            "Round MethodVisible" := false;
            FormulaVisible := false;
        end;
    end;

    var
        [InDataSet]
        CancelVisible: Boolean;
        [InDataSet]
        HELPVisible: Boolean;
        [InDataSet]
        OKVisible: Boolean;
        [InDataSet]
        ClassificationsCalculationsVis: Boolean;
        [InDataSet]
        "Value 1Visible": Boolean;
        [InDataSet]
        "Code Value 1Visible": Boolean;
        [InDataSet]
        "Value 2Visible": Boolean;
        [InDataSet]
        "Code Value 2Visible": Boolean;
        [InDataSet]
        "Value 3Visible": Boolean;
        [InDataSet]
        "Code Value 3Visible": Boolean;
        [InDataSet]
        "Value 4Visible": Boolean;
        [InDataSet]
        "Code Value 4Visible": Boolean;
        [InDataSet]
        "Value 5Visible": Boolean;
        [InDataSet]
        "Code Value 5Visible": Boolean;
        [InDataSet]
        "Value 6Visible": Boolean;
        [InDataSet]
        "Code Value 6Visible": Boolean;
        [InDataSet]
        FormulaVisible: Boolean;
        [InDataSet]
        "Evaluation TypeVisible": Boolean;
        [InDataSet]
        "Assessment CodeVisible": Boolean;
        [InDataSet]
        "Round MethodVisible": Boolean;
        TableBoxHeight: Integer;

    //[Scope('OnPrem')]
    procedure UpdateForm()
    begin
        CurrPage.Update;
    end;
}

#pragma implicitwith restore

