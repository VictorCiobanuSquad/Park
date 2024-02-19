#pragma implicitwith disable
page 31009763 "Subject List"
{
    Caption = 'Subject List';
    PageType = List;
    SourceTable = Subjects;

    layout
    {
        area(content)
        {
            repeater(Control1110000)
            {
                ShowCaption = false;
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Abbreviation Description"; Rec."Abbreviation Description")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
    }

    //[Scope('OnPrem')]
    procedure GetSelectionFilter(): Code[80]
    var
        Subject: Record Subjects;
        FirstSubject: Code[30];
        LastSubject: Code[30];
        SelectionFilter: Code[250];
        SubjectCount: Integer;
        More: Boolean;
    begin
        CurrPage.SetSelectionFilter(Subject);
        SubjectCount := Subject.Count;
        if SubjectCount > 0 then begin
            Subject.Find('-');
            while SubjectCount > 0 do begin
                SubjectCount := SubjectCount - 1;
                Subject.MarkedOnly(false);
                FirstSubject := Subject.Code;
                LastSubject := FirstSubject;
                More := (SubjectCount > 0);
                while More do
                    if Subject.Next = 0 then
                        More := false
                    else
                        if not Subject.Mark then
                            More := false
                        else begin
                            LastSubject := Subject.Code;
                            SubjectCount := SubjectCount - 1;
                            if SubjectCount = 0 then
                                More := false;
                        end;
                if SelectionFilter <> '' then
                    SelectionFilter := SelectionFilter + '|';
                if FirstSubject = LastSubject then
                    SelectionFilter := SelectionFilter + FirstSubject
                else
                    SelectionFilter := SelectionFilter + FirstSubject + '..' + LastSubject;
                if SubjectCount > 0 then begin
                    Subject.MarkedOnly(true);
                    Subject.Next;
                end;
            end;
        end;
        exit(SelectionFilter);
    end;
}

#pragma implicitwith restore

