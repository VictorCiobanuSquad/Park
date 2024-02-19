#pragma implicitwith disable
page 31009787 "Registration Entry"
{
    Caption = 'Registration Entry';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = Registration;

    layout
    {
        area(content)
        {
            repeater(Control1110000)
            {
                Editable = false;
                ShowCaption = false;
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
                field("Class Letter"; Rec."Class Letter")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Study Plan Code"; Rec."Study Plan Code")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Study Plan Code';
                }
                field(Course; Rec.Course)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Course';
                }
                field("Services Plan Code"; Rec."Services Plan Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Student Code No."; Rec."Student Code No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(StudentName; GetStudentName)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Name';
                }
                field(Status; Rec.Status)
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
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = ServiceSetup;
                action("&Student Card")
                {
                    Caption = '&Student Card';
                    Image = User;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Student Card";
                    RunPageLink = "No." = FIELD("Student Code No.");
                    RunPageView = SORTING("No.");
                    ShortCutKey = 'Shift+Ctrl+L';
                }
                action("Student &Registration")
                {
                    Caption = 'Student &Registration';
                    Image = Document;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page Registration;
                    RunPageLink = "School Year" = FIELD("School Year"),
                                  "Student Code No." = FIELD("Student Code No.");
                    ShortCutKey = 'Shift+F7';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if cUserEducation.GetEducationFilter(UserId) <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", cUserEducation.GetEducationFilter(UserId));
            Rec.FilterGroup(0);
        end;
        FilterForm;
    end;

    var
        FilterType: Option Active,Planning;
        cUserEducation: Codeunit "User Education";

    //[Scope('OnPrem')]
    procedure FilterForm()
    var
        rSchoolYear: Record "School Year";
    begin
        rSchoolYear.Reset;
        if FilterType = FilterType::Planning then
            rSchoolYear.SetRange(Status, rSchoolYear.Status::Planning)
        else
            rSchoolYear.SetRange(Status, rSchoolYear.Status::Active);
        if rSchoolYear.FindFirst then begin
            Rec.FilterGroup(2);
            Rec.SetRange("School Year", rSchoolYear."School Year");
            Rec.FilterGroup(0);

            CurrPage.Update(false);
        end;
    end;

    //[Scope('OnPrem')]
    procedure GetStudentName(): Text[200]
    var
        rStudent: Record Students;
    begin
        rStudent.Get(Rec."Student Code No.");
        exit(rStudent.Name);
    end;

    local procedure FilterTypeOnAfterValidate()
    begin
        FilterForm;
    end;
}

#pragma implicitwith restore

