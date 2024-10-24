#pragma implicitwith disable
page 52939 "Class Aspects Course"
{
    Caption = 'Class Aspects Course';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Course Lines";

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
                field("Sub-Subject"; Rec."Sub-Subject")
                {
                    ApplicationArea = Basic, Suite;
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
                    ApplicationArea = All;
                    Caption = '&Aspects';

                    trigger OnAction()
                    begin
                        if rClass.Get(Rec."Temp Class", Rec."Temp School Year") then;

                        Rec.SubjectsAspects2(Rec."Temp School Year", rClass."Schooling Year", Rec."Temp Class");
                    end;
                }
                action("&Sub-Subjects Aspects")
                {
                    ApplicationArea = All;
                    Caption = '&Sub-Subjects Aspects';

                    trigger OnAction()
                    var
                        rSPSubSubLines: Record "Study Plan Sub-Subjects Lines";
                        fClassSubSubjectsLines: Page "Class Sub-Subjects Lines";
                    begin
                        if Rec."Sub-Subject" then begin
                            if rClass.Get(Rec."Temp Class", Rec."Temp School Year") then;

                            rSPSubSubLines.Reset;
                            rSPSubSubLines.SetRange(Type, rSPSubSubLines.Type::Course);
                            rSPSubSubLines.SetRange(Code, Rec.Code);
                            rSPSubSubLines.SetRange("Schooling Year", rClass."Schooling Year");
                            rSPSubSubLines.SetRange("Subject Code", Rec."Subject Code");

                            fClassSubSubjectsLines.GetClass(rClass.Class, rClass."Schooling Year", rClass."School Year");
                            fClassSubSubjectsLines.SetTableView(rSPSubSubLines);
                            fClassSubSubjectsLines.RunModal;
                        end;
                    end;
                }
            }
        }
    }

    var
        vClass: Code[20];
        vSchoolYear: Code[9];
        vSchoolingYear: Code[10];
        rClass: Record Class;


    procedure GetClass(pClass: Code[20]; pSchoolYear: Code[9]; pSchoolingYear: Code[10])
    begin
        vClass := pClass;
        vSchoolYear := pSchoolYear;
        vSchoolingYear := pSchoolingYear;
    end;
}

#pragma implicitwith restore

