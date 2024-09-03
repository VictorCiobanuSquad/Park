page 50000 "Text Input"
{
    PageType = StandardDialog;
    ApplicationArea = All;
    UsageCategory = Tasks;

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(Display; InfoText)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = '';
                }
                field(Name; TextInput)
                {
                    ApplicationArea = All;
                    Editable = true;
                    Caption = '';
                }
            }
        }
    }
    var
        TextInput: Text;
        InfoText: Text;

    procedure SetDisplayText(Input: Text)
    begin
        InfoText := Input;
    end;

    procedure GetInputText(): Text
    begin
        exit(TextInput);
    end;
}