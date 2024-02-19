#pragma implicitwith disable
page 31009922 "Observation Header"
{
    Caption = 'Observation Header';
    PageType = Card;
    SourceTable = Observation;
    SourceTableView = WHERE("Line Type" = FILTER(Cab));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("School Year"; Rec."School Year")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "School YearEditable";
                }
                field(Descripton; Rec.Descripton)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = DescriptonEditable;
                }
            }
            part(SubForm; "Observation Line")
            {
                ApplicationArea = Basic, Suite;
                Editable = SubFormEditable;
                SubPageLink = "Observation Type" = FIELD("Observation Type"),
                              "School Year" = FIELD("School Year"),
                              Code = FIELD(Code);
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Observations")
            {
                Caption = '&Observations';
                separator(Action1102059013)
                {
                }
                action("&Copy")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Copy';
                    Image = Copy;

                    trigger OnAction()
                    begin
                        repCopyObservation.GETObservation(Rec.Code, Rec."School Year");
                        repCopyObservation.Run;
                        Clear(repCopyObservation);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        ValidateEditable;
    end;

    trigger OnInit()
    begin
        SubFormEditable := true;
        DescriptonEditable := true;
        "School YearEditable" := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "School YearEditable" := true;
        DescriptonEditable := true;
    end;

    trigger OnOpenPage()
    begin
        ValidateEditable;
    end;

    var
        repCopyObservation: Report "Copy Observations";
        [InDataSet]
        "School YearEditable": Boolean;
        [InDataSet]
        DescriptonEditable: Boolean;
        [InDataSet]
        SubFormEditable: Boolean;

    //[Scope('OnPrem')]
    procedure ValidateEditable()
    var
        l_SchoolYear: Record "School Year";
    begin
        l_SchoolYear.Reset;
        l_SchoolYear.SetRange("School Year", Rec."School Year");
        if l_SchoolYear.FindSet then;

        if (l_SchoolYear.Status = l_SchoolYear.Status::Closed) or (l_SchoolYear.Status = l_SchoolYear.Status::Closing) then begin
            "School YearEditable" := false;
            DescriptonEditable := false;
            SubFormEditable := false;
        end else begin
            "School YearEditable" := true;
            DescriptonEditable := true;
            SubFormEditable := true;
        end;
    end;
}

#pragma implicitwith restore

