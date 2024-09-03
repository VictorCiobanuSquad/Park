#pragma implicitwith disable
page 52757 Teacher
{
    // IT001-CPA
    //       - Disponibilização do campo:
    //         - "Last Name"

    Caption = 'Teacher Card';
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = Teacher;


    layout
    {
        area(content)
        {
            group(Control1102065000)
            {
                Caption = 'Teacher';
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field("Salutation Code"; Rec."Salutation Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Last Name"; Rec."Last Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("E-mail"; Rec."E-mail")
                {
                    ApplicationArea = Basic, Suite;
                    ExtendedDatatype = EMail;
                }
                field(Picture; Rec.Picture)
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group(General)
            {
                Caption = 'General';
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
                    Caption = 'Post Code/City';
                }
                field(Location; Rec.Location)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Parish/Council/District Code"; Rec."Parish/Council/District Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Town; Rec.Town)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(County; Rec.County)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(District; Rec.District)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Sex; Rec.Sex)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Incidence Type"; Rec."Incidence Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Daily Equity Absences"; Rec."Daily Equity Absences")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("NAV User Id"; Rec."NAV User Id")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic, Suite;
                }
                group(Identification)
                {
                    Caption = 'Identification';
                    field("Marital Status"; Rec."Marital Status")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Doc. Type Id"; Rec."Doc. Type Id")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Doc. Number Id"; Rec."Doc. Number Id")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Archive of Identification"; Rec."Archive of Identification")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Date Validity"; Rec."Date Validity")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Date Issuance"; Rec."Date Issuance")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("VAT Registration No."; Rec."VAT Registration No.")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field(NISS; Rec.NISS)
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
                field("Birth Date"; Rec."Birth Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Naturalness Code"; Rec."Naturalness Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Birth Place"; Rec."Birth Place")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Nationality Code"; Rec."Nationality Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Nationality; Rec.Nationality)
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            part(SubAbsence; "Teacher Incidences")
            {
                ApplicationArea = All;
                Caption = 'Faltas';
                SubPageLink = "Student/Teacher Code No." = FIELD("No.");
                SubPageView = SORTING("Timetable Code", "School Year", "Study Plan", Class, Day, Type, "Line No. Timetable", "Incidence Type", "Incidence Code", Category, "Subcategory Code", "Student/Teacher", "Student/Teacher Code No.", "Responsibility Center", "Line No.")
                              ORDER(Ascending);
            }
            group(Communication)
            {
                Caption = 'Communication';
                field("E-mail2"; Rec."E-mail")
                {
                    ApplicationArea = Basic, Suite;
                    ExtendedDatatype = EMail;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = Basic, Suite;
                    ExtendedDatatype = PhoneNo;
                }
                field("Mobile Phone"; Rec."Mobile Phone")
                {
                    ApplicationArea = Basic, Suite;
                    ExtendedDatatype = PhoneNo;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Teacher)
            {
                Caption = 'Te&acher';
                action("Teacher Department")
                {
                    ApplicationArea = All;
                    Caption = 'Teacher Department';
                    Image = Departments;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Teacher Subjects Group";
                    RunPageLink = Type = CONST(Teacher),
                                  "Teacher No." = FIELD("No.");
                    RunPageView = SORTING(Type, Code, "Teacher No.");
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        setSubformAbsence;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        l_rEduConfiguration: Record "Edu. Configuration";
    begin
        if l_rEduConfiguration.Get then
            Rec."Daily Equity Absences" := l_rEduConfiguration."Daily Equity Absences";
    end;

    var
        rSchoolYear: Record "School Year";
        rAbsence: Record Absence;
        Text004: Label 'Successfully imported.';
        Text005: Label 'Import Files';
        Attachment: Record "Attached Documents";
        FileMgt: Codeunit "File Management";
        Link: Text;

    //[Scope('OnPrem')]
    procedure setSubformAbsence()
    begin
        rSchoolYear.Reset;
        rSchoolYear.SetRange(Status, rSchoolYear.Status::Active);
        if rSchoolYear.Find('-') then;

        rAbsence.Reset;
        rAbsence.SetRange("Student/Teacher", rAbsence."Student/Teacher"::Teacher);
        rAbsence.SetRange("School Year", rSchoolYear."School Year");
        rAbsence.SetRange("Student/Teacher Code No.", Rec."No.");
        if rAbsence.Find('-') then
            CurrPage.SubAbsence.PAGE.SetTableView(rAbsence);
    end;
}

#pragma implicitwith restore

