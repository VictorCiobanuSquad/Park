#pragma implicitwith disable
page 52899 "Equipment Group Card"
{
    Caption = 'Equipment Group Card';
    PageType = Card;
    SourceTable = Equipment;
    SourceTableView = SORTING(Type, "Equipment No.", "Equipment Group", "Line No.")
                      WHERE("Line No." = CONST(0));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Equipment No."; Rec."Equipment No.")
                {
                    ApplicationArea = Basic, Suite;
                    AssistEdit = true;
                    Visible = "Equipment No.Visible";

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field("Equipment Group"; Rec."Equipment Group")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = "Equipment GroupVisible";

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
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
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Responsibility Center';
                }
            }
            part("Equipment Group Lines"; "Equipment Group Lines")
            {
                ApplicationArea = All;
                SubPageLink = "Line No." = FILTER(<> 0),
                              "Equipment Group" = FIELD("Equipment Group"),
                              Type = CONST(Single);
                Visible = "Equipment Group LinesVisible";
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Equi&pment Group")
            {
                Caption = 'Equi&pment Group';
                Image = TeamSales;
                action("&List")
                {
                    ApplicationArea = All;
                    Caption = '&List';
                    Image = List;
                    ShortCutKey = 'Shift+Ctrl+L';

                    trigger OnAction()
                    begin
                        PAGE.Run(PAGE::"Equipment List");
                    end;
                }
            }
        }
    }

    trigger OnInit()
    begin
        "Equipment No.Visible" := true;
        "Equipment Group LinesVisible" := true;
        "Equipment GroupVisible" := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := vFilter;
    end;

    trigger OnOpenPage()
    begin
        Filters(Rec.Type);
    end;

    var
        vFilter: Option " ",Single,Group;
        [InDataSet]
        "Equipment GroupVisible": Boolean;
        [InDataSet]
        "Equipment Group LinesVisible": Boolean;
        [InDataSet]
        "Equipment No.Visible": Boolean;
        GeneralHeight: Integer;

    //[Scope('OnPrem')]
    procedure Filters(pfilter: Option " ",Single,Group)
    begin

        if pfilter = pfilter::Single then begin
            vFilter := pfilter;
            "Equipment GroupVisible" := false;
            "Equipment Group LinesVisible" := false;
            "Equipment No.Visible" := true;
            GeneralHeight := 7590;
        end;
        if pfilter = pfilter::Group then begin
            vFilter := pfilter;
            "Equipment GroupVisible" := true;
            "Equipment Group LinesVisible" := true;
            "Equipment No.Visible" := false;
            GeneralHeight := 3630;
        end;
    end;
}

#pragma implicitwith restore

