#pragma implicitwith disable
page 31009937 "Aspects Sub"
{
    AutoSplitKey = true;
    Caption = 'Aspects';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = Aspects;

    layout
    {
        area(content)
        {
            repeater(Control1102059000)
            {
                ShowCaption = false;
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Type No."; Rec."Type No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("School Year"; Rec."School Year")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("% Evaluation"; Rec."% Evaluation")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Schooling Year"; Rec."Schooling Year")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Moment Code"; Rec."Moment Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Evaluation Type"; Rec."Evaluation Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Assessment Code"; Rec."Assessment Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Subjects; Rec.Subjects)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Sub Subjects"; Rec."Sub Subjects")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Not to WEB"; Rec."Not to WEB")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = "Not to WEBVisible";
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        VisibleNotWEB;
    end;

    trigger OnInit()
    begin
        "Not to WEBVisible" := true;
    end;

    var
        VarType: Option Simple,Multi;
        [InDataSet]
        "Not to WEBVisible": Boolean;

    //[Scope('OnPrem')]
    procedure GetType(pType: Option Simple,Multi)
    begin
        VarType := pType;
    end;

    //[Scope('OnPrem')]
    procedure FormUpdate()
    begin
        CurrPage.Update(false);
    end;

    //[Scope('OnPrem')]
    procedure VisibleNotWEB()
    begin
        if Rec."Sub Subjects" <> '' then
            "Not to WEBVisible" := false
        else
            "Not to WEBVisible" := true;
    end;
}

#pragma implicitwith restore

