#pragma implicitwith disable
page 52779 "SubForm Giving Services"
{
    Caption = 'SubForm Giving Services';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Registration Class";
    SourceTableView = SORTING(Class, "School Year", "Schooling Year", "Study Plan Code", "Student Code No.", Type, "Line No.")
                      ORDER(Ascending)
                      WHERE(Status = FILTER(Subscribed));

    layout
    {
        area(content)
        {
            repeater(Control1102059000)
            {
                ShowCaption = false;
                field(Selection; Rec.Selection)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Student Code No."; Rec."Student Code No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Class No."; Rec."Class No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }


    procedure UpdateForm()
    begin
        CurrPage.Update;
    end;


    procedure SelectRecords(inBoolean: Boolean)
    begin
    end;
}

#pragma implicitwith restore

