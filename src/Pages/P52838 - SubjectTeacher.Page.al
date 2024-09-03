#pragma implicitwith disable
page 52838 "Subject Teacher"
{
    Caption = 'Teacher/Subject';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Study Plan Lines";

    layout
    {
        area(content)
        {
            repeater(Control1110000)
            {
                Editable = false;
                Enabled = false;
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
                field("Mandatory/Optional Type"; Rec."Mandatory/Optional Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Curriculum Type"; Rec."Curriculum Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Evaluation Type"; Rec."Evaluation Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Legal Code"; Rec."Legal Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Sub-Subject"; Rec."Sub-Subject")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sub-Subject';
                    Editable = false;
                }
            }
            part(subformTeacherClass; "Teacher Class")
            {
                ApplicationArea = All;
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
                ApplicationArea = All;
                Caption = '&Sub-Subjects Teacher';
                Enabled = false;
                Image = UserCertificate;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction()
                begin
                    Rec.CalcFields("Sub-Subject");
                    if Rec."Sub-Subject" then begin
                        rStudyPlanSubSubjects.Reset;
                        rStudyPlanSubSubjects.SetRange(Type, rStudyPlanSubSubjects.Type::"Study Plan");
                        rStudyPlanSubSubjects.SetRange(Code, Rec.Code);
                        rStudyPlanSubSubjects.SetRange("School Year", varClass."School Year");
                        rStudyPlanSubSubjects.SetRange("Subject Code", Rec."Subject Code");
                        rStudyPlanSubSubjects.SetRange("Schooling Year", varClass."Schooling Year");
                        // Se for para usar esta funcionalidade é necessario re-criar
                        // a variavel global e disponibilizar a page.
                        //NameDataTypeSubtypeLength
                        //fSubSubjectTeacherPageSub Subject Teacher
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
                    ApplicationArea = All;
                    Caption = '&Subjects Class List';
                    Image = OpportunitiesList;
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
                        fTemplates.SetFormStudents('', Rec."School Year", '', varClass."Schooling Year", varClass.Class, false, l_teacherCode, Rec."Subject Code",
                                                  rTemplates.Type::"Student Class", '', '', true);
                        fTemplates.LookupMode(true);
                        fTemplates.RunModal;
                    end;
                }
                action("Teacher Class List")
                {
                    ApplicationArea = All;
                    Caption = 'Teacher Class List';
                    Image = CustomerList;
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
        //OnAfterGetCurrRecor2;
    end;

    trigger OnInit()
    begin
        SubSubjectTeacherEnable := true;
        subformTeacherClassEnable := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        //OnAfterGetCurrRecor2;
    end;

    var
        varClass: Record Class;
        rStudyPlanSubSubjects: Record "Study Plan Sub-Subjects Lines";
        Text0001: Label 'Option only avaible for Sub-Subjects.';
        fTemplates: Page Templates;
        rTemplates: Record Templates;
        PageBreak: Boolean;
        [InDataSet]
        subformTeacherClassEnable: Boolean;
        [InDataSet]
        SubSubjectTeacherEnable: Boolean;

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
        rTeacherClass.SetRange("School Year", Rec."School Year");
        rTeacherClass.SetRange(Class, varClass.Class);
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
    end;

    local procedure OnAfterGetCurrRecor2()
    begin
        xRec := Rec;
        funFillTeacherClass;
    end;
}

#pragma implicitwith restore

