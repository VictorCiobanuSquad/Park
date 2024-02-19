#pragma implicitwith disable
page 31009880 "Subject Teacher Course"
{
    Caption = 'Teacher/Subject';
    PageType = List;
    SourceTable = "Course Lines";

    layout
    {
        area(content)
        {
            repeater(Control1110000)
            {
                Editable = false;
                ShowCaption = false;
                field("Subject Code"; Rec."Subject Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Subject Description"; Rec."Subject Description")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sub-Subject"; Rec."Sub-Subject")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            part(subformTeacherClass; "Teacher Class")
            {
                Caption = 'Professores';
                Enabled = subformTeacherClassEnable;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(SubSubjectTeacher)
            {
                Caption = '&Sub-Subjects Teacher';
                Enabled = SubSubjectTeacherEnable;
                Image = UserCertificate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    if varClass.Get(Rec."Temp Class", Rec."Temp School Year") then;
                    Rec.CalcFields("Sub-Subject");
                    if Rec."Sub-Subject" then begin
                        rStudyPlanSubSubjects.Reset;
                        rStudyPlanSubSubjects.SetRange(Type, rStudyPlanSubSubjects.Type::Course);
                        rStudyPlanSubSubjects.SetRange(Code, Rec.Code);
                        //rStudyPlanSubSubjects.SETRANGE("School Year",varClass."School Year");
                        rStudyPlanSubSubjects.SetRange("Subject Code", Rec."Subject Code");
                        rStudyPlanSubSubjects.SetRange("Schooling Year", varClass."Schooling Year");


                        //    fSubSubjectTeacher.funClass(varClass);
                        //    fSubSubjectTeacher.SETTABLEVIEW(rStudyPlanSubSubjects);
                        //    fSubSubjectTeacher.RUN;
                    end else
                        Error(Text0001);
                end;
            }
            group("&Print")
            {
                Caption = '&Print';
                Image = Print;
                action("&Subjects Class List")
                {
                    Caption = '&Subjects Class List';
                    Enabled = false;
                    Image = AlternativeAddress;
                    Visible = false;

                    trigger OnAction()
                    var
                        l_teacherCode: Code[20];
                    begin
                        l_teacherCode := CurrPage.subformTeacherClass.PAGE.GetTeacher();

                        Clear(fTemplates);
                        PageBreak := true;
                        rTemplates.Reset;
                        rTemplates.SetRange(Type, rTemplates.Type::"Student Class");
                        fTemplates.SetTableView(rTemplates);
                        fTemplates.SetFormStudents('', Rec."Temp School Year", '', Rec."Schooling Year Begin", Rec."Temp Class", false, l_teacherCode, Rec."Subject Code",
                                                  rTemplates.Type::"Student Class", '', '', true);
                        fTemplates.LookupMode(true);
                        fTemplates.RunModal;
                    end;
                }
                action("Teacher Class List")
                {
                    Caption = 'Teacher Class List';
                    Image = HumanResources;
                    RunObject = Report "Teacher Class List";
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        funFillTeacherClass;
    end;

    trigger OnAfterGetRecord()
    begin
        //OnAfterGetCurrRecord;
    end;

    trigger OnInit()
    begin
        SubSubjectTeacherEnable := true;
        subformTeacherClassEnable := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        //OnAfterGetCurrRecord;
    end;

    var
        varClass: Record Class;
        rStudyPlanSubSubjects: Record "Study Plan Sub-Subjects Lines";
        Text0001: Label 'Option only available for Sub-Subjects.';
        rTemplates: Record Templates;
        PageBreak: Boolean;
        [InDataSet]
        subformTeacherClassEnable: Boolean;
        [InDataSet]
        SubSubjectTeacherEnable: Boolean;
        fTemplates: Page Templates;

    //[Scope('OnPrem')]
    procedure funClass(parClass: Record Class)
    begin
        varClass := parClass;
    end;

    //[Scope('OnPrem')]
    procedure funFillTeacherClass()
    var
        rTeacherClass: Record "Teacher Class";
    begin
        rTeacherClass.Reset;
        rTeacherClass.SetRange(rTeacherClass."User Type", rTeacherClass."User Type"::Teacher);
        rTeacherClass.SetRange("School Year", Rec."Temp School Year");
        rTeacherClass.SetRange(Class, Rec."Temp Class");
        rTeacherClass.SetRange(rTeacherClass."Type Subject", rTeacherClass."Type Subject"::Subject);
        rTeacherClass.SetRange("Subject Code", Rec."Subject Code");

        Rec.CalcFields("Sub-Subject");
        if (Rec."Sub-Subject") and (Rec."Sub-subjects for assess. only" = false) then begin
            rTeacherClass.SetFilter(rTeacherClass."Sub-Subject Code", '<>%1', '');
            subformTeacherClassEnable := false;
            SubSubjectTeacherEnable := true;
        end else begin
            subformTeacherClassEnable := true;
            SubSubjectTeacherEnable := false;
        end;

        CurrPage.subformTeacherClass.PAGE.SetTableView(rTeacherClass);
        CurrPage.subformTeacherClass.PAGE.funcUpdate;

        if varClass.Get(Rec."Temp Class", Rec."Temp School Year") then;
    end;
}

#pragma implicitwith restore

