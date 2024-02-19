#pragma implicitwith disable
page 31009897 "Equipment List"
{
    Caption = 'Equipment List';
    PageType = List;
    SourceTable = Equipment;
    SourceTableView = SORTING(Type, "Equipment No.", "Equipment Group", "Line No.")
                      ORDER(Ascending);

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
                    OptionCaption = ' ,Single,Group';

                    trigger OnValidate()
                    begin
                        varTypeOnAfterValidate;
                    end;
                }
            }
            repeater(Control1110000)
            {
                Editable = false;
                ShowCaption = false;
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Equipment No."; Rec."Equipment No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Equipment Group"; Rec."Equipment Group")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Equi&pment")
            {
                Caption = 'Equi&pment';
                action("&Card Equipment")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Card Equipment';
                    Image = ServiceItemWorksheet;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    begin
                        Clear(fEquipmentCard);
                        fEquipmentCard.SetRecord(Rec);
                        fEquipmentCard.RunModal;
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetRange(Type, varType);
        Rec.SetRange("Line No.", 0);
        if cUserEducation.GetEducationFilter(UserId) <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", cUserEducation.GetEducationFilter(UserId));
            Rec.FilterGroup(0);
        end;
    end;

    var
        cUserEducation: Codeunit "User Education";
        varType: Option;
        fEquipmentCard: Page "Equipment Group Card";

    //[Scope('OnPrem')]
    procedure updateForm(pType: Option)
    begin
        varType := pType;
    end;

    local procedure varTypeOnAfterValidate()
    begin
        Rec.SetRange(Type, varType);
        Rec.SetRange("Line No.", 0);
        CurrPage.Update(false);
    end;
}

#pragma implicitwith restore

