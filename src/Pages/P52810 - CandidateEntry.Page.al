#pragma implicitwith disable
page 52810 "Candidate Entry"
{
    AutoSplitKey = true;
    Caption = 'Candidate Entry';
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "Candidate Entry";

    layout
    {
        area(content)
        {
            repeater(Control1110000)
            {
                ShowCaption = false;
                field("School Year"; Rec."School Year")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Schooling Year"; Rec."Schooling Year")
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnValidate()
                    var
                        l_rCandidateEntry: Record "Candidate Entry";
                    begin
                        l_rCandidateEntry.Reset;
                        l_rCandidateEntry.SetRange(l_rCandidateEntry."Candidate No.", Rec."Candidate No.");
                        l_rCandidateEntry.SetRange(l_rCandidateEntry."School Year", Rec."School Year");
                        l_rCandidateEntry.SetRange(l_rCandidateEntry."Schooling Year", Rec."Schooling Year");
                        if l_rCandidateEntry.FindFirst then
                            Error(Text0001);
                    end;
                }
                field(Level; Rec.Level)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Priority; Rec.Priority)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Priority Points"; Rec."Priority Points")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Average Test Points"; Rec."Average Test Points")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Other Points"; Rec."Other Points")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Total Points"; Rec."Total Points")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Accepted; Rec.Accepted)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Excluding; Rec.Excluding)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Comments; Rec.Comments)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Conversion User ID"; Rec."Conversion User ID")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Conversion Date"; Rec."Conversion Date")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        //Normatica
        if rCandidate.Get(Rec."Candidate No.") then
            Rec."Candidate Name" := rCandidate.Name;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        cStudentsRegistration: Codeunit "Students Registration";
    begin
        Rec."Country/Region Code" := cStudentsRegistration.GetCountry;
    end;

    trigger OnOpenPage()
    begin
        if cUserEducation.GetEducationFilter(UserId) <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", cUserEducation.GetEducationFilter(UserId));
            Rec.FilterGroup(0);
        end;
    end;

    var
        cUserEducation: Codeunit "User Education";
        Text0001: Label 'The Candidate already has a candidature for this schooling year.';
        rCandidate: Record Candidate;

    //[Scope('OnPrem')]
    procedure FormCreateTest()
    begin
        Rec.CreateTest(Rec);
    end;

    //[Scope('OnPrem')]
    procedure FormOpenTest()
    begin
        Rec.OpenTest(Rec);
    end;
}

#pragma implicitwith restore

