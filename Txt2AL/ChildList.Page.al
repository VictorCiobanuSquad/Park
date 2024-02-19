#pragma implicitwith disable
page 31009909 "Child List"
{
    PageType = ListPart;
    SourceTable = "Users Family / Students";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("recStudent.""No."""; recStudent."No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Nº Aluno';
                }
                field("recStudent.Name"; recStudent.Name)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Name';
                }
                field("recStudent.Class"; recStudent.Class)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Class';
                    Visible = boolvisibleClass;
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
        recStudent.SetFilter("School Year", Rec."School Year");
        if recStudent.FindFirst then
            recStudent.CalcFields(Class);
    end;

    trigger OnOpenPage()
    begin
        recSchoolYear.Reset;
        recSchoolYear.SetRange(Status, recSchoolYear.Status::Active);
        if recSchoolYear.FindFirst then begin
            Rec.SetFilter("School Year", recSchoolYear."School Year");
            boolvisibleClass := true;
        end else begin
            boolvisibleClass := false;
            recSchoolYear.Reset;
            recSchoolYear.SetRange(Status, recSchoolYear.Status::Closing);
            if recSchoolYear.FindFirst then
                Rec.SetFilter("School Year", recSchoolYear."School Year");
        end;
    end;

    var
        recStudent: Record Students;
        recSchoolYear: Record "School Year";
        boolvisibleClass: Boolean;

    local procedure ExistChilds(pSchoolYear: Record "School Year"): Boolean
    var
        lUsersFamilyStudents: Record "Users Family / Students";
    begin
        Clear(lUsersFamilyStudents);
        lUsersFamilyStudents.SetRange("School Year", pSchoolYear."School Year");
        lUsersFamilyStudents.SetRange("Student Code No.", Rec."Student Code No.");
        if not lUsersFamilyStudents.IsEmpty then
            exit(true)
        else
            exit(false);
    end;
}

#pragma implicitwith restore

