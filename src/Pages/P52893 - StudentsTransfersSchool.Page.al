#pragma implicitwith disable
page 52893 "Students Transfers School"
{
    AutoSplitKey = true;
    Caption = 'Students Transfers School';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Students Transfers School";

    layout
    {
        area(content)
        {
            repeater(Control1102065000)
            {
                ShowCaption = false;
                field("Registration Created"; Rec."Registration Created")
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
                }
                field("School Code"; Rec."School Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Transfer; Rec.Transfer)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("School Name"; Rec."School Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Location; Rec.Location)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("E-mail"; Rec."E-mail")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(County; Rec.County)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Actual Status"; Rec."Actual Status")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Class; Rec.Class)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Class Letter"; Rec."Class Letter")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Registration Date"; Rec."Registration Date")
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
                action("&Create Registration")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Create Registration';
                    Image = NewDocument;

                    trigger OnAction()
                    begin
                        Rec.InsertRegistration;
                    end;
                }
                action("Insert &History Assessment")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Insert &History Assessment';
                    Image = InsertFromCheckJournal;

                    trigger OnAction()
                    var
                        fInsertHistoryAssessment: Page "Insert History Assessment";
                    begin
                        //Test if the student have a registration for the active year
                        //If have send the last School Year and if the the registration is in a course
                        //send the course code.
                        Rec.CalcFields("Registration Created");
                        if Rec."Registration Created" then begin
                            Clear(fInsertHistoryAssessment);
                            fInsertHistoryAssessment.GetInfo2(Rec."Schooling Year", '');
                            fInsertHistoryAssessment.GetInfo(Rec."School Year", Rec."Student Code");
                            fInsertHistoryAssessment.RunModal;
                        end;
                    end;
                }
            }
        }
    }
}

#pragma implicitwith restore

