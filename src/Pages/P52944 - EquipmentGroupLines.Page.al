#pragma implicitwith disable
page 52944 "Equipment Group Lines"
{
    AutoSplitKey = true;
    Caption = 'Equipment Group Lines';
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = Equipment;

    layout
    {
        area(content)
        {
            repeater(Control1102059000)
            {
                ShowCaption = false;
                field("Equipment No."; Rec."Equipment No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'No.';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        rEquipment.Reset;
                        rEquipment.SetRange(Type, rEquipment.Type::Single);
                        rEquipment.SetRange("Responsibility Center", Rec."Responsibility Center");
                        if rEquipment.Find('-') then begin
                            Clear(fEquipmentList);
                            fEquipmentList.updateForm(rEquipment.Type::Single);
                            fEquipmentList.LookupMode(true);
                            fEquipmentList.SetTableView(rEquipment);
                            fEquipmentList.RunModal;
                            fEquipmentList.GetRecord(rEquipment);
                            Rec."Equipment No." := rEquipment."Equipment No.";
                            Rec.Description := rEquipment.Description;
                        end;
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Description';
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
    }

    var
        rEquipment: Record Equipment;
        fEquipmentList: Page "Equipment List";
}

#pragma implicitwith restore

