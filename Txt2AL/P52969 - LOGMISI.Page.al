#pragma implicitwith disable
page 52969 "LOG MISI"
{
    Caption = 'Log MISI';
    Editable = false;
    PageType = List;
    SourceTable = "LOG MISI";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Num; Rec.Num)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Uploaded File"; Rec."Uploaded File")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Time; Rec.Time)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Moment; Rec.Moment)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Year; Rec.Year)
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
    }
}

#pragma implicitwith restore

