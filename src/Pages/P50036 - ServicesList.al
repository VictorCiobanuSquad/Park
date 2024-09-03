page 50036 "Services List"
{
    Caption = '';
    PageType = ListPart;
    SourceTable = Registration;
    InsertAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Control1000000026)
            {
                ShowCaption = false;
                field(Selection; Rec.Selection)
                {
                }
                field("Student Code No."; Rec."Student Code No.")
                {
                    Editable = false;
                }
                field(Name; Rec.Name)
                {
                    Editable = false;
                }
                field(Class; Rec.Class)
                {
                    Editable = false;
                }
                field("Class No."; Rec."Class No.")
                {
                    Editable = false;
                }
            }
        }
    }
}
