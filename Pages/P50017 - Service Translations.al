page 50017 "Service Translations"
{
    /*
    //IT001 - Park  - 2017.11.17 - Nova funcionalidade de tradução de serviços
    */
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Service Translation";
    Caption = 'Service Translations';
    DataCaptionFields = "Service No.";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("Language Code"; Rec."Language Code")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }
    }
}