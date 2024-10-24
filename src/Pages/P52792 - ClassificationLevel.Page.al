#pragma implicitwith disable
page 52792 "Classification Level"
{
    Caption = 'Classification Level';
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "Classification Level";
    SourceTableView = SORTING("Id Ordination")
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            repeater(Control1110000)
            {
                ShowCaption = false;
                field("Classification Level Code"; Rec."Classification Level Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Description Level"; Rec."Description Level")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Short Level Description"; Rec."Short Level Description")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Id Ordination"; Rec."Id Ordination")
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnValidate()
                    begin
                        IdOrdinationOnAfterValidate;
                    end;
                }
                field("Min Value"; Rec."Min Value")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Min ValueEditable";
                }
                field("Max Value"; Rec."Max Value")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Max ValueEditable";
                }
                field(Value; Rec.Value)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = ValueEditable;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        UpdateFields;
    end;

    trigger OnInit()
    begin
        ValueEditable := true;
        "Max ValueEditable" := true;
        "Min ValueEditable" := true;
    end;

    var
        [InDataSet]
        "Min ValueEditable": Boolean;
        [InDataSet]
        "Max ValueEditable": Boolean;
        [InDataSet]
        ValueEditable: Boolean;


    procedure UpdateFields()
    var
        l_RankGroup: Record "Rank Group";
    begin
        if l_RankGroup.Get(Rec."Classification Group Code") then begin
            if l_RankGroup."Evaluation Type" = l_RankGroup."Evaluation Type"::Qualitative then begin
                "Min ValueEditable" := false;
                "Max ValueEditable" := false;
                ValueEditable := false;
            end else begin
                "Min ValueEditable" := true;
                "Max ValueEditable" := true;
                ValueEditable := true;

            end;
        end;
    end;

    local procedure IdOrdinationOnAfterValidate()
    begin
        CurrPage.Update;
    end;
}

#pragma implicitwith restore

