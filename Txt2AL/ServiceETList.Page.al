#pragma implicitwith disable
page 31009766 "Service ET List"
{
    Caption = 'Service List';
    CardPageID = "Service ET";
    PageType = List;
    SourceTable = "Services ET";

    layout
    {
        area(content)
        {
            repeater(Control1110000)
            {
                Editable = false;
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Search Description"; Rec."Search Description")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Subsidy; Rec.Subsidy)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Subsidy Type"; Rec."Subsidy Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Service Disc. Group"; Rec."Service Disc. Group")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Allow Invoice Disc."; Rec."Allow Invoice Disc.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Gen. Serv. Posting Group"; Rec."Gen. Serv. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("VAT Serv. Posting Group"; Rec."VAT Serv. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("IRS Declaration Code"; Rec."IRS Declaration Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("IRS Declaration Description"; Rec."IRS Declaration Description")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Service Depending Other"; Rec."Service Depending Other")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Service Depending Code"; Rec."Service Depending Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Percent %"; Rec."Percent %")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Unit Price Purchase"; Rec."Unit Price Purchase")
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
        if cUserEducation.GetEducationFilter(UserId) <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", cUserEducation.GetEducationFilter(UserId));
            Rec.FilterGroup(0);
        end;
    end;

    var
        cUserEducation: Codeunit "User Education";

    //[Scope('OnPrem')]
    procedure GetSelectionFilter(): Code[80]
    var
        Item: Record "Services ET";
        FirstItem: Code[30];
        LastItem: Code[30];
        SelectionFilter: Code[250];
        ItemCount: Integer;
        More: Boolean;
    begin
        CurrPage.SetSelectionFilter(Item);
        ItemCount := Item.Count;
        if ItemCount > 0 then begin
            Item.Find('-');
            while ItemCount > 0 do begin
                ItemCount := ItemCount - 1;
                Item.MarkedOnly(false);
                FirstItem := Item."No.";
                LastItem := FirstItem;
                More := (ItemCount > 0);
                while More do
                    if Item.Next = 0 then
                        More := false
                    else
                        if not Item.Mark then
                            More := false
                        else begin
                            LastItem := Item."No.";
                            ItemCount := ItemCount - 1;
                            if ItemCount = 0 then
                                More := false;
                        end;
                if SelectionFilter <> '' then
                    SelectionFilter := SelectionFilter + '|';
                if FirstItem = LastItem then
                    SelectionFilter := SelectionFilter + FirstItem
                else
                    SelectionFilter := SelectionFilter + FirstItem + '..' + LastItem;
                if ItemCount > 0 then begin
                    Item.MarkedOnly(true);
                    Item.Next;
                end;
            end;
        end;
        exit(SelectionFilter);
    end;
}

#pragma implicitwith restore

