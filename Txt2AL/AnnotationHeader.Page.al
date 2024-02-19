#pragma implicitwith disable
page 31009962 "Annotation Header"
{
    Caption = 'Annotation Header';
    DelayedInsert = true;
    PageType = Card;
    SourceTable = Annotation;
    SourceTableView = WHERE("Line Type" = CONST(Cab));

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
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = DescriptionEditable;
                }
            }
            part(SubForm; "Annotation Line")
            {
                Editable = SubFormEditable;
                SubPageLink = "School Year" = FIELD("School Year"),
                              Code = FIELD(Code);
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Annotation")
            {
                Caption = '&Annotation';
                action(List)
                {
                    Caption = 'List';
                    Image = ListPage;
                    RunObject = Page "Annotation List";
                }
                separator(Action1102059013)
                {
                }
                action("&Copy")
                {
                    Caption = '&Copy';
                    Image = Copy;

                    trigger OnAction()
                    begin
                        repCopyAnnotation.GETAnnotation(Rec.Code, Rec."School Year");
                        repCopyAnnotation.Run;
                        Clear(repCopyAnnotation);
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
        DescriptionEditable := true;
        "School YearEditable" := true;
    end;

    trigger OnOpenPage()
    begin
        ValidateEditable;
    end;

    var
        repCopyAnnotation: Report "Copy Annotations";
        [InDataSet]
        "School YearEditable": Boolean;
        [InDataSet]
        DescriptionEditable: Boolean;
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
            DescriptionEditable := false;
            SubFormEditable := false;

        end else begin
            "School YearEditable" := true;
            DescriptionEditable := true;
            SubFormEditable := true;
        end;
    end;
}

#pragma implicitwith restore

