#pragma implicitwith disable
page 52846 "Candidate Selection List"
{
    Caption = 'Candidate Selection List';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Candidate Entry";
    SourceTableView = SORTING("School Year", "Sorting ID Schooling Year", "Total Points");

    layout
    {
        area(content)
        {
            repeater(Control1110000)
            {
                ShowCaption = false;
                field("Candidate No."; Rec."Candidate No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Candidate Name"; Rec."Candidate Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("School Year"; Rec."School Year")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Schooling Year"; Rec."Schooling Year")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Level; Rec.Level)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Priority; Rec.Priority)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Comments; Rec.Comments)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Conversion Date"; Rec."Conversion Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Conversion User ID"; Rec."Conversion User ID")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnClosePage()
    begin
        ClearSelections;
    end;

    trigger OnOpenPage()
    begin
        if cUserEducation.GetEducationFilter(UserId) <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", cUserEducation.GetEducationFilter(UserId));
            Rec.FilterGroup(0);
        end;


        Rec.SetFilter("School Year", cStudentsRegistration.GetShoolYear);

        //Clear all possible selctions for this user
        ClearSelections;
    end;

    var
        cUserEducation: Codeunit "User Education";
        cStudentsRegistration: Codeunit "Students Registration";

    //[Scope('OnPrem')]
    procedure ClearSelections()
    begin
        Rec.SetRange("Selection User ID", UserId);
        if Rec.Find('-') then
            repeat
                Rec.Validate(Selection, false);
                Rec.Modify;
            until Rec.Next = 0;

        Rec.SetRange("Selection User ID");
        Rec.Find('-')
    end;
}

#pragma implicitwith restore

