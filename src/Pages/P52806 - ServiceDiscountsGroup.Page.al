
page 52806 "Service Discounts Group"
{
    Caption = 'Service Discounts Group';
    PageType = List;
    SourceTable = "Service Discount Group";

    layout
    {
        area(content)
        {
            repeater(Control1101490000)
            {
                ShowCaption = false;
                field("Code"; Rec.Code)
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
        area(navigation)
        {
            group("Service &Disc. Groups")
            {
                Caption = 'Service &Disc. Groups';
                Image = CalculateDiscount;
                action("Invoice &Line Discounts")
                {
                    ApplicationArea = All;
                    Caption = 'Invoice &Line Discounts';
                    Image = LineDiscount;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Sales Line Discounts ET";
                    RunPageLink = Code = FIELD(Code);
                }
            }
        }
    }


    procedure GetSelectionFilter(): Code[80]
    var
        ItemDiscGr: Record "Service Discount Group";
        FirstItemDiscGr: Code[30];
        LastItemDiscGr: Code[30];
        SelectionFilter: Code[250];
        ItemDiscGrCount: Integer;
        More: Boolean;
    begin
        CurrPage.SetSelectionFilter(ItemDiscGr);
        ItemDiscGrCount := ItemDiscGr.Count;
        if ItemDiscGrCount > 0 then begin
            ItemDiscGr.Find('-');
            while ItemDiscGrCount > 0 do begin
                ItemDiscGrCount := ItemDiscGrCount - 1;
                ItemDiscGr.MarkedOnly(false);
                FirstItemDiscGr := ItemDiscGr.Code;
                LastItemDiscGr := FirstItemDiscGr;
                More := (ItemDiscGrCount > 0);
                while More do
                    if ItemDiscGr.Next = 0 then
                        More := false
                    else
                        if not ItemDiscGr.Mark then
                            More := false
                        else begin
                            LastItemDiscGr := ItemDiscGr.Code;
                            ItemDiscGrCount := ItemDiscGrCount - 1;
                            if ItemDiscGrCount = 0 then
                                More := false;
                        end;
                if SelectionFilter <> '' then
                    SelectionFilter := SelectionFilter + '|';
                if FirstItemDiscGr = LastItemDiscGr then
                    SelectionFilter := SelectionFilter + FirstItemDiscGr
                else
                    SelectionFilter := SelectionFilter + FirstItemDiscGr + '..' + LastItemDiscGr;
                if ItemDiscGrCount > 0 then begin
                    ItemDiscGr.MarkedOnly(true);
                    ItemDiscGr.Next;
                end;
            end;
        end;
        exit(SelectionFilter);
    end;
}

#pragma implicitwith restore

