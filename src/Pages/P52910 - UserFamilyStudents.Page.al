#pragma implicitwith disable
page 52910 "User Family - Students"
{
    Caption = 'User Family - Students';
    PageType = List;
    SourceTable = "Users Family / Students";
    SourceTableView = WHERE(Kinship = FILTER(<> Himself));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Kinship; Rec.Kinship)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Mobile Phone"; Rec."Mobile Phone")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("E-mail"; Rec."E-mail")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Student Code No."; Rec."Student Code No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("recStudent.Name"; recStudent.Name)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Student Name';
                }
                field("recStudent.Class"; recStudent.Class)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Class';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        recStudent.Reset;
        recStudent.SetRange("No.", Rec."Student Code No.");
        if recStudent.FindFirst then
            recStudent.CalcFields(Class);
    end;

    trigger OnOpenPage()
    begin
        recSchoolYear.Reset;
        recSchoolYear.SetRange(Status, recSchoolYear.Status::Active);
        if recSchoolYear.FindFirst then
            Rec.SetFilter("School Year", recSchoolYear."School Year");
    end;

    var
        recStudent: Record Students;
        recSchoolYear: Record "School Year";
}

#pragma implicitwith restore

