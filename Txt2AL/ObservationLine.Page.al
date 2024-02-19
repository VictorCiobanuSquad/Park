#pragma implicitwith disable
page 31009923 "Observation Line"
{
    AutoSplitKey = true;
    Caption = 'Observation Line';
    PageType = ListPart;
    SourceTable = Observation;
    SourceTableView = WHERE("Line Type" = FILTER(Line));

    layout
    {
        area(content)
        {
            repeater(Control1102059000)
            {
                ShowCaption = false;
                field("Description Male"; Rec."Description Male")
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnAssistEdit()
                    begin
                        rGroupSubjects.Reset;
                        rGroupSubjects.SetRange("School Year", Rec."School Year");
                        rGroupSubjects.SetRange("Observation Code", Rec.Code);
                        rGroupSubjects.SetRange("Line No.", Rec."Line No.");
                        PAGE.Run(PAGE::"Multi Language Obs Drill", rGroupSubjects);
                    end;
                }
                field("Description Female"; Rec."Description Female")
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnAssistEdit()
                    begin
                        rGroupSubjects.Reset;
                        rGroupSubjects.SetRange("School Year", Rec."School Year");
                        rGroupSubjects.SetRange("Observation Code", Rec.Code);
                        rGroupSubjects.SetRange("Line No.", Rec."Line No.");
                        PAGE.Run(PAGE::"Multi Language Obs Drill", rGroupSubjects);
                    end;
                }
            }
        }
    }

    actions
    {
    }

    var
        rGroupSubjects: Record "Multi language observation";
        rGroupSubjectsNEW: Record "Multi language observation";
}

#pragma implicitwith restore

