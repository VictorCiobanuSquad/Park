#pragma implicitwith disable
page 52907 "Registration Class Entry"
{
    // IT001 - Novo botão "Ver matrícula" - 11-09-2018
    //         - Possibilidade de consultar as matrículas em histórico

    Caption = 'Registration Class Entry';
    Editable = false;
    PageType = List;
    SourceTable = "Registration Class Entry";

    layout
    {
        area(content)
        {
            repeater(Control1110000)
            {
                ShowCaption = false;
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Class; Rec.Class)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("School Year"; Rec."School Year")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Schooling Year"; Rec."Schooling Year")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Schooling Year';
                }
                field("Student Code No."; Rec."Student Code No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Class No."; Rec."Class No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Class No.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Status Date"; Rec."Status Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("School Name"; Rec."School Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Transfer Class"; Rec."Transfer Class")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Study Plan Code"; Rec."Study Plan Code")
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
                action("&Subjects Entry")
                {
                    ApplicationArea = All;
                    Caption = '&Subjects Entry';
                    Image = ContactPerson;
                    RunObject = Page "Student Subjects Entry";
                    RunPageLink = "Student Code No." = FIELD("Student Code No."),
                                  "School Year" = FIELD("School Year"),
                                  Class = FIELD(Class);
                }
                action("Show Registration")
                {
                    ApplicationArea = All;
                    Caption = 'Show Registration';
                    Image = ViewSourceDocumentLine;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        pageRegist: Page Registration;
                        Registration: Record Registration;
                    begin
                        //IT001,sn
                        Clear(pageRegist);
                        Registration.Reset;
                        Registration.SetRange("Student Code No.", Rec."Student Code No.");
                        Registration.SetRange("School Year", Rec."School Year");
                        if Registration.FindFirst then begin
                            pageRegist.SetTableView(Registration);
                            pageRegist.Editable(false);
                            pageRegist.RunModal;
                        end;
                        //IT001,en
                    end;
                }
            }
        }
    }
}

#pragma implicitwith restore

