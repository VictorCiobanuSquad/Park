#pragma implicitwith disable
page 31009866 Course
{
    Caption = 'Course Card';
    PageType = Card;
    SourceTable = "Course Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Code"; Rec.Code)
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
                field("Schooling Year Begin"; Rec."Schooling Year Begin")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("School Year Begin"; Rec."School Year Begin")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sub-subjects for assess. only"; Rec."Sub-subjects for assess. only")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            part(subform; "Course Lines")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = Code = FIELD(Code);
            }
            group(Legal)
            {
                Caption = 'Legal';
                field("Course Type"; Rec."Course Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Course Name"; Rec."Course Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Course Name2"; Rec."Course Name2")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Course Code"; Rec."Course Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Course Description"; Rec."Course Description")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Legal Code"; Rec."Legal Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("ENES Description"; Rec."ENES Description")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Course")
            {
                Caption = '&Course';
                Image = CustomerGroup;
                action("Ass&essment Configuration")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Ass&essment Configuration';
                    Image = Evaluate;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Assessment Configuration List";
                    RunPageLink = "Study Plan Code" = FIELD(Code),
                                  "Country/Region Code" = FIELD("Country/Region Code");
                    RunPageView = SORTING("School Year", Type, "Study Plan Code", "Country/Region Code")
                                  WHERE(Type = CONST(Multi));
                }
            }
        }
        area(processing)
        {
            action("&Copy")
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Copy';
                Image = Copy;

                trigger OnAction()
                begin
                    RepCopyCoursePlan.GetCoursePlanNo(Rec.Code);
                    RepCopyCoursePlan.RunModal;
                    Clear(RepCopyCoursePlan);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        OnAfterGetCurrRecord2;
    end;

    trigger OnInit()
    begin
        "Maximum Total AbsenceVisible" := true;
        txtM2Visible := true;
        MaximumUnjustifiedAbsenceVisib := true;
        txtM1Visible := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        OnAfterGetCurrRecord2;
    end;

    var
        RepCopyCoursePlan: Report "Copy Course Plan";
        [InDataSet]
        txtM1Visible: Boolean;
        [InDataSet]
        MaximumUnjustifiedAbsenceVisib: Boolean;
        [InDataSet]
        txtM2Visible: Boolean;
        [InDataSet]
        "Maximum Total AbsenceVisible": Boolean;

    //[Scope('OnPrem')]
    procedure VisibleFields()
    var
        rStructureEducationCountry: Record "Structure Education Country";
    begin
        rStructureEducationCountry.Reset;
        rStructureEducationCountry.SetRange(Country, Rec."Country/Region Code");
        rStructureEducationCountry.SetRange("Schooling Year", Rec."Schooling Year Begin");
        if rStructureEducationCountry.FindFirst then begin
            if rStructureEducationCountry."Absence Type" = rStructureEducationCountry."Absence Type"::Daily then begin
                txtM1Visible := true;
                MaximumUnjustifiedAbsenceVisib := true;
                txtM2Visible := true;
                "Maximum Total AbsenceVisible" := true;
            end else begin
                txtM1Visible := false;
                MaximumUnjustifiedAbsenceVisib := false;
                txtM2Visible := false;
                "Maximum Total AbsenceVisible" := false;
            end;
        end;
    end;

    local procedure OnAfterGetCurrRecord2()
    begin
        xRec := Rec;
        VisibleFields;
    end;
}

#pragma implicitwith restore

