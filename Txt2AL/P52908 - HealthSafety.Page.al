#pragma implicitwith disable
page 52908 "Health & Safety"
{
    Caption = 'Health & Safety';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "H&S";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(varType; varType)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Type';
                    OptionCaption = ' ,Vaccinations,Diseases,Allergies,Legal,Blood Type,Handicapped';

                    trigger OnValidate()
                    begin
                        varTypeOnAfterValidate;
                    end;
                }
            }
            repeater(Control1102059000)
            {
                ShowCaption = false;
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Code';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Description';
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Starting Date';
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Ending Date';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Rec.SetRange(Type, varType);
    end;

    var
        varType: Option " ",Vaccinations,Diseases,Allergies,Legal,"Blood Type",Handicapped;

    local procedure varTypeOnAfterValidate()
    begin
        Rec.SetRange(Type, varType);
        CurrPage.Update(false);
    end;
}

#pragma implicitwith restore

