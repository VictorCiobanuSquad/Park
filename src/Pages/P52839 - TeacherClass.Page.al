#pragma implicitwith disable
page 52839 "Teacher Class"
{
    Caption = 'Teacher Class';
    PageType = ListPart;
    SourceTable = "Teacher Class";

    layout
    {
        area(content)
        {
            repeater(Control1110000)
            {
                ShowCaption = false;
                field(User; Rec.User)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Full Name"; Rec."Full Name")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Subject Code"; Rec."Subject Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Sub-Subject Code"; Rec."Sub-Subject Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Turn; Rec.Turn)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Allow Assign Evaluations"; Rec."Allow Assign Evaluations")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Allow Calc. Final Assess."; Rec."Allow Calc. Final Assess.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Allow Stu. Global Observations"; Rec."Allow Stu. Global Observations")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Allow Assign Incidence"; Rec."Allow Assign Incidence")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Allow Justify Incidence"; Rec."Allow Justify Incidence")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Allow Summary"; Rec."Allow Summary")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin

        Rec."School Year" := Rec.GetFilter("School Year");
        Rec.Class := Rec.GetFilter(Class);

        Rec."Type Subject" := Rec."Type Subject"::Subject;
        Rec."Subject Code" := Rec.GetFilter("Subject Code");
        Rec."Sub-Subject Code" := Rec.GetFilter("Sub-Subject Code");


        rSubject.Reset;
        rSubject.SetRange(rSubject.Type, rSubject.Type::Subject);
        rSubject.SetRange(rSubject.Code, Rec."Subject Code");
        if rSubject.FindFirst then begin
            Rec."Subject Description" := rSubject.Description;
            Rec."Subject Group" := rSubject.Department;
        end;

        rClass.Reset;
        rClass.SetRange(rClass.Class, Rec.Class);
        rClass.SetRange(rClass."School Year", Rec."School Year");
        if rClass.FindFirst then
            Rec."Schooling Year" := rClass."Schooling Year";
    end;

    var
        varTeachClass: Record "Teacher Class";
        rTeacher: Record Teacher;
        rClass: Record Class;
        rSubject: Record Subjects;
        rTeacherClass: Record "Teacher Class";
        vOpcao: Integer;


    procedure funcTeacherClass(parTeachClass: Record "Teacher Class")
    begin
        varTeachClass := parTeachClass;
    end;


    procedure funcUpdate()
    begin
        if Rec.Find('-') then;
        CurrPage.Update(false);
    end;


    procedure GetTeacher() Teacher: Code[20]
    begin
        exit(Rec.User);
    end;
}

#pragma implicitwith restore

