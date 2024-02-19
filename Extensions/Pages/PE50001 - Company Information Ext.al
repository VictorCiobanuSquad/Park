#pragma implicitwith disable
pageextension 50001 "Company Information Ext." extends "Company Information"
{
    /*   
    JDE_INT SQD RTV 20210628
        Added field "JDE Entity Number"
    */
    layout
    {
        addafter(Picture)
        {
            field(Picture2; Rec.Picture2)
            {
                ApplicationArea = All;
                Caption = 'Stamp';
            }
        }
        addafter("PTSS SAFT-PT Company Customer ID")
        {
            field("JDE Entity Number"; Rec."JDE Entity Number")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}
#pragma implicitwith restore
