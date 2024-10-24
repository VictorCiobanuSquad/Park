#pragma implicitwith disable
page 52938 "Class Aspects Study Lines"
{
    Caption = 'Class Aspects Study Lines';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Study Plan Lines";

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
                    Caption = 'Sub-Subject';
                    Editable = false;
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
                    ApplicationArea = Basic, Suite;
                    Caption = '&Aspects';

                    trigger OnAction()
                    begin
                        Rec.SubjectsAspects2(vSchoolYear, vSchoolingYear, vClass);
                    end;
                }
                action("&Sub-Subjects Aspects")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Sub-Subjects Aspects';

                    trigger OnAction()
                    var
                        rSPSubSubLines: Record "Study Plan Sub-Subjects Lines";
                        fClassSubSubjectsLines: Page "Class Sub-Subjects Lines";
                    begin
                        if Rec."Sub-Subject" then begin
                            rSPSubSubLines.Reset;
                            rSPSubSubLines.SetRange(Type, rSPSubSubLines.Type::"Study Plan");
                            rSPSubSubLines.SetRange(Code, Rec.Code);
                            rSPSubSubLines.SetRange("Subject Code", Rec."Subject Code");

                            fClassSubSubjectsLines.GetClass(vClass, vSchoolingYear, vSchoolYear);
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


    procedure GetClass(pClass: Code[20]; pSchoolYear: Code[9]; pSchoolingYear: Code[10])
    begin
        vClass := pClass;
        vSchoolYear := pSchoolYear;
        vSchoolingYear := pSchoolingYear;
    end;
}

#pragma implicitwith restore

