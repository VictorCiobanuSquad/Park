#pragma implicitwith disable
page 52818 "Candidate Selection"
{
    Caption = 'Candidate Selection';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Candidate Entry";
    SourceTableView = SORTING("School Year", "Sorting ID Schooling Year", "Total Points")
                      ORDER(Descending)
                      WHERE("Conversion User ID" = FILTER(''),
                            Excluding = FILTER(false));

    layout
    {
        area(content)
        {
            field(vSchoolYear; vSchoolYear)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'School Year';
                TableRelation = "School Year"."School Year" WHERE(Status = FILTER(Planning | Active));

                trigger OnValidate()
                begin
                    vSchoolYearOnAfterValidate;
                end;
            }
            field(vSchoolingYear; vSchoolingYear)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Schooling Year';
                TableRelation = "Structure Education Country"."Schooling Year";

                trigger OnValidate()
                begin
                    vSchoolingYearOnAfterValidate;
                end;
            }
            repeater(Control1110000)
            {
                ShowCaption = false;
                field(Selection; Rec.Selection)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Candidate No."; Rec."Candidate No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Candidate Name"; Rec."Candidate Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Priority; Rec.Priority)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Average Test Points"; Rec."Average Test Points")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Other Points"; Rec."Other Points")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Total Points"; Rec."Total Points")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Accepted; Rec.Accepted)
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnValidate()
                    begin
                        AcceptedOnPush;
                    end;
                }
                field(Excluding; Rec.Excluding)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Comments; Rec.Comments)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Schooling Year"; Rec."Schooling Year")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
            }
            field(vTotalCandidaturas; vTotalCandidaturas)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Candidates';
                Enabled = false;
            }
            field(vTotalAceites; vTotalAceites)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Accepted';
                Enabled = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Create Students")
            {
                Caption = '&Create Students';
                Image = ServiceSetup;
                action(Create)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Create';
                    Image = NewCustomer;
                    Promoted = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        Rec.CreateStudent;
                    end;
                }
            }
        }
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

        rSchoolYear.Reset;
        rSchoolYear.SetRange(Status, rSchoolYear.Status::Active);
        if rSchoolYear.FindFirst then
            SchoolYearFilter := rSchoolYear."School Year";

        rSchoolYear.Reset;
        rSchoolYear.SetRange(Status, rSchoolYear.Status::Planning);
        if rSchoolYear.FindFirst then
            if SchoolYearFilter <> '' then
                SchoolYearFilter := SchoolYearFilter + '|' + rSchoolYear."School Year"
            else
                SchoolYearFilter := rSchoolYear."School Year";

        Rec.SetFilter("School Year", SchoolYearFilter);


        //Clear all possible selctions for this user
        ClearSelections;

        CalcTotals;
    end;

    var
        rSchoolYear: Record "School Year";
        rCandidateEntry: Record "Candidate Entry";
        SchoolYearFilter: Text[250];
        cUserEducation: Codeunit "User Education";
        vSchoolYear: Code[9];
        vSchoolingYear: Code[10];
        vTotalCandidaturas: Integer;
        vTotalAceites: Integer;

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
    end;

    //[Scope('OnPrem')]
    procedure CalcTotals()
    begin
        vTotalCandidaturas := Rec.Count;
        rCandidateEntry.Reset;
        rCandidateEntry.CopyFilters(Rec);
        rCandidateEntry.SetRange(rCandidateEntry.Accepted, true);
        vTotalAceites := rCandidateEntry.Count;
    end;

    local procedure vSchoolYearOnAfterValidate()
    begin
        if vSchoolYear <> '' then
            Rec.SetRange("School Year", vSchoolYear);

        CalcTotals;
        CurrPage.Update;
    end;

    local procedure vSchoolingYearOnAfterValidate()
    begin
        if vSchoolingYear <> '' then
            Rec.SetRange("Schooling Year", vSchoolingYear);

        CalcTotals;
        CurrPage.Update;
    end;

    local procedure OnDeactivateForm()
    begin
        Rec.Reset;
    end;

    local procedure AcceptedOnPush()
    begin
        CalcTotals;
        CurrPage.Update;
    end;
}

#pragma implicitwith restore

