#pragma implicitwith disable
page 31009926 "Student Sub-Subjects Plan"
{
    Caption = 'Student Sub-Subjects Plan';
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Student Sub-Subjects Plan ";

    layout
    {
        area(content)
        {
            repeater(Control1102059000)
            {
                ShowCaption = false;
                field("Subject Code"; Rec."Subject Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Subject Description"; Rec."Subject Description")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Sub-Subject Code"; Rec."Sub-Subject Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Sub-Subject Description"; Rec."Sub-Subject Description")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Turn; Rec.Turn)
                {
                    ApplicationArea = Basic, Suite;
                    Enabled = TurnEnable;
                    Visible = TurnVisible;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("&Aspects")
                {
                    Caption = '&Aspects';
                    Image = Relationship;

                    trigger OnAction()
                    begin
                        Rec.SubjectsAspects2;
                    end;
                }
            }
        }
    }

    trigger OnInit()
    begin
        TurnEnable := true;
        TurnVisible := true;
    end;

    trigger OnOpenPage()
    begin
        rStudyPlanHeader.Reset;
        if rStudyPlanHeader.Get(Rec.Code) then begin
            if rStudyPlanHeader."Sub-subjects for assess. only" then begin
                TurnEnable := false;
                TurnVisible := false;
            end else begin
                TurnEnable := true;
                TurnVisible := true;
            end;
        end;

        rCourseHeader.Reset;
        if rCourseHeader.Get(Rec.Code) then begin
            if rCourseHeader."Sub-subjects for assess. only" then begin
                TurnEnable := false;
                TurnVisible := false;
            end else begin
                TurnEnable := true;
                TurnVisible := true;
            end;
        end;
    end;

    var
        rStudyPlanHeader: Record "Study Plan Header";
        rCourseHeader: Record "Course Header";
        [InDataSet]
        TurnVisible: Boolean;
        [InDataSet]
        TurnEnable: Boolean;
}

#pragma implicitwith restore

