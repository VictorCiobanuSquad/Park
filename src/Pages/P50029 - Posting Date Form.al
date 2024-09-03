page 50029 "Posting Date Form"
{
    PageType = StandardDialog;
    ApplicationArea = All;
    UsageCategory = Tasks;
    Caption = 'Posting Date';

    layout
    {
        area(Content)
        {
            group(CreateOrders)
            {
                Caption = 'Orders Create';

                field(PostingDate; PostingDate)
                {
                    ApplicationArea = All;
                    Caption = 'Posting Date';
                }
            }
        }
    }

    var
        PostingDate: Date;

    procedure GetPostingDate(): Date
    begin
        EXIT(PostingDate);
    end;
}