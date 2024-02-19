#pragma implicitwith disable
page 31009904 Category
{
    Caption = 'Category';
    DelayedInsert = true;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Sub Type";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(varOption; varOption)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Category';
                    OptionCaption = 'Class,Cantine,BUS,Schoolyard,Extra-scholar,Teacher';

                    trigger OnValidate()
                    begin
                        varOptionOnAfterValidate;
                    end;
                }
            }
            repeater(Control1110000)
            {
                ShowCaption = false;
                field("Subcategory Code"; Rec."Subcategory Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
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
        Rec.SetRange(Category, varOption);
    end;

    var
        varOption: Option Class,Cantine,BUS,Schoolyard,"Extra-scholar",Teacher;

    local procedure varOptionOnAfterValidate()
    begin
        Rec.SetRange(Category, varOption);
        CurrPage.Update(false);
    end;
}

#pragma implicitwith restore

