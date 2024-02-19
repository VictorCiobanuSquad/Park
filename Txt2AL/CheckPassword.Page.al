page 31009981 CheckPassword
{
    PageType = Card;

    layout
    {
        area(content)
        {
            field(Password; Password)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Password';
                ExtendedDatatype = Masked;
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        CurrPage.LookupMode := true;
    end;

    var
        Password: Text[30];

    //[Scope('OnPrem')]
    procedure CheckPassword() ePassword: Text[30]
    begin
        exit(Password);
    end;

    local procedure OnTimer()
    begin
        CurrPage.Close;
    end;
}

