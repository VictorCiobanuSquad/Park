#pragma implicitwith disable
page 52913 "Registration Archive"
{
    Caption = 'Registration Archive';
    Editable = false;
    PageType = Card;
    SourceTable = Registration;

    layout
    {
        area(content)
        {
            group(Registration)
            {
                Caption = 'Registration';
                field("Student Code No."; Rec."Student Code No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("School Year"; Rec."School Year")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Schooling Year"; Rec."Schooling Year")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Schooling YearEditable";

                    trigger OnValidate()
                    begin
                        SchoolingYearOnAfterValidate;
                    end;
                }
                field("Registration Date"; Rec."Registration Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Next School Year"; Rec."Next School Year")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Study Plan Code"; Rec."Study Plan Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Study Plan CodeEditable";

                    trigger OnValidate()
                    begin
                        StudyPlanCodeOnAfterValidate;
                    end;
                }
                field(Course; Rec.Course)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = CourseEditable;

                    trigger OnValidate()
                    begin
                        CourseOnAfterValidate;
                    end;
                }
                field("Services Plan Code"; Rec."Services Plan Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Services Plan CodeEditable";

                    trigger OnValidate()
                    begin
                        ServicesPlanCodeOnAfterValidat;
                    end;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Class; Rec.Class)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Class Letter"; Rec."Class Letter")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Class No."; Rec."Class No.")
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Actual Status"; Rec."Actual Status")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group(General)
            {
                Caption = 'General';
                part(Control1110007; "Student Registration")
                {
                    ApplicationArea = All;
                    SubPageLink = "No." = FIELD("Student Code No.");
                }
                group("Situation prior to entry into the School")
                {
                    Caption = 'Situation prior to entry into the School';
                    field("Pre-primary Education"; Rec."Pre-primary Education")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Pre School"; Rec."Pre School")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Pre Grouping"; Rec."Pre Grouping")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Preschool Years"; Rec."Preschool Years")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Pre School Years';
                    }
                }
                group("Special Education Situations")
                {
                    Caption = 'Special Education Situations';
                    field("Compulsory Edu. Amendment Req."; Rec."Compulsory Edu. Amendment Req.")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Need Special Education"; Rec."Need Special Education")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Evidence Documents"; Rec."Evidence Documents")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
                field("Need Special Education Desc."; Rec."Need Special Education Desc.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Evidence Description"; Rec."Evidence Description")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            part(Associados; "Reg.Family/Students")
            {
                ApplicationArea = All;
                Caption = 'Associados';
                SubPageLink = "School Year" = FIELD("School Year"),
                              "Student Code No." = FIELD("Student Code No.");
            }
            group(Others)
            {
                Caption = 'Others';
                group("School Social Action")
                {
                    Caption = 'School Social Action';
                    field(Residence; Rec.Residence)
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Contains Residence"; Rec."Contains Residence")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field(Benefits; Rec.Benefits)
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Contains Benefits"; Rec."Contains Benefits")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field(Transportation; Rec.Transportation)
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Transportation Local"; Rec."Transportation Local")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
            }
            part(SubFormstudentsSubjects; "Student Study Plan")
            {
                ApplicationArea = All;
                Caption = 'Plano Estudos';
                SubPageLink = "Student Code No." = FIELD("Student Code No."),
                              "School Year" = FIELD("School Year");
            }
            part("Plano Serviços"; "SubForm Student Services Plan")
            {
                ApplicationArea = All;
                Caption = 'Plano Serviços';
                SubPageLink = "Student No." = FIELD("Student Code No."),
                              "School Year" = FIELD("School Year"),
                              "Schooling Year" = FIELD("Schooling Year");
            }
            part("Transporte & Cantina"; "Students Non Lective Hours")
            {
                ApplicationArea = All;
                Caption = 'Transporte & Cantina';
                SubPageLink = "School Year" = FIELD("School Year"),
                              "Student Code No." = FIELD("Student Code No."),
                              "Responsibility Center" = FIELD("Responsibility Center");
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        feditavel;
    end;

    trigger OnInit()
    begin
        CourseEditable := true;
        "Schooling YearEditable" := true;
        "Services Plan CodeEditable" := true;
        "Study Plan CodeEditable" := true;
    end;

    var
        Text0001: Label 'Student is enroled in a class to the subject %1';
        Text0002: Label 'Option only for Course';
        Text0003: Label 'You can only create aspects if the student %1 is Subscribed';
        Text0004: Label 'You can only create aspects if the student %1 is Enroled.';
        Text0005: Label 'You can only open the Sub Subjects if the Student %1 is Enroled';
        rServicesPlanHead: Record "Services Plan Head";
        [InDataSet]
        "Study Plan CodeEditable": Boolean;
        [InDataSet]
        "Services Plan CodeEditable": Boolean;
        [InDataSet]
        "Schooling YearEditable": Boolean;
        [InDataSet]
        CourseEditable: Boolean;

    //[Scope('OnPrem')]
    procedure feditavel()
    begin
        if Rec.Status <> Rec.Status::" " then begin
            "Study Plan CodeEditable" := false;
            "Services Plan CodeEditable" := false;
            "Schooling YearEditable" := false;
            CourseEditable := false;
            exit;
        end;

        if Rec.Type = Rec.Type::Simple then begin
            CourseEditable := false;
            "Study Plan CodeEditable" := true;
        end;

        if Rec.Type = Rec.Type::Multi then begin
            CourseEditable := true;
            "Study Plan CodeEditable" := false;
        end;
    end;

    local procedure StudyPlanCodeOnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure ServicesPlanCodeOnAfterValidat()
    begin
        CurrPage.Update;
    end;

    local procedure SchoolingYearOnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure CourseOnAfterValidate()
    begin
        CurrPage.Update;
    end;
}

#pragma implicitwith restore

