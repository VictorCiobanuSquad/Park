
page 31009789 "Class List"
{
    Caption = 'Class List';
    CardPageID = Class;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = Class;

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
                field(Description; Rec.Description)
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
                field("Class Letter"; Rec."Class Letter")
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
    }

    trigger OnOpenPage()
    begin
        /*
        IF cUserEducation.GetEducationFilter(USERID) <> '' THEN BEGIN
          FILTERGROUP(2);
          SETRANGE("Responsibility Center",cUserEducation.GetEducationFilter(USERID));
          FILTERGROUP(0);
        END;
        */

        Clear(SchoolYear);
        SchoolYear.SetRange(Status, SchoolYear.Status::Active);
        if SchoolYear.FindFirst then
            Rec.SetRange("School Year", SchoolYear."School Year");

    end;

    var
        cUserEducation: Codeunit "User Education";
        SchoolYear: Record "School Year";

    //[Scope('OnPrem')]
    procedure GetSelectionFilter(): Code[80]
    var
        Class: Record Class;
        FirstClass: Code[30];
        LastClass: Code[30];
        SelectionFilter: Code[250];
        ClassCount: Integer;
        More: Boolean;
    begin
        CurrPage.SetSelectionFilter(Class);
        ClassCount := Class.Count;
        if ClassCount > 0 then begin
            Class.Find('-');
            while ClassCount > 0 do begin
                ClassCount := ClassCount - 1;
                Class.MarkedOnly(false);
                FirstClass := Class.Class;
                LastClass := FirstClass;
                More := (ClassCount > 0);
                while More do
                    if Class.Next = 0 then
                        More := false
                    else
                        if not Class.Mark then
                            More := false
                        else begin
                            LastClass := Class.Class;
                            ClassCount := ClassCount - 1;
                            if ClassCount = 0 then
                                More := false;
                        end;
                if SelectionFilter <> '' then
                    SelectionFilter := SelectionFilter + '|';
                if FirstClass = LastClass then
                    SelectionFilter := SelectionFilter + FirstClass
                else
                    SelectionFilter := SelectionFilter + FirstClass + '..' + LastClass;
                if ClassCount > 0 then begin
                    Class.MarkedOnly(true);
                    Class.Next;
                end;
            end;
        end;
        exit(SelectionFilter);
    end;
}


