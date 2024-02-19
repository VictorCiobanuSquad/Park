#pragma implicitwith disable
page 31009827 "Incidence List"
{
    Caption = 'Incidence List';
    PageType = List;
    SourceTable = "Incidence Type";

    layout
    {
        area(content)
        {
            repeater(Control1102065000)
            {
                Editable = false;
                ShowCaption = false;
                field("Incidence Code"; Rec."Incidence Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = "Incidence CodeVisible";
                }
                field("Justification Code"; Rec."Justification Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = "Justification CodeVisible";
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("School Year"; Rec."School Year")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Schooling Year"; Rec."Schooling Year")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field(Category; Rec.Category)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Subcategory Code"; Rec."Subcategory Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = "Subcategory CodeVisible";
                }
                field("Subcategory Description"; Rec."Subcategory Description")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = "Subcategory DescriptionVisible";
                }
                field("Incidence Type"; Rec."Incidence Type")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        "Subcategory DescriptionVisible" := true;
        "Subcategory CodeVisible" := true;
        "Justification CodeVisible" := true;
        "Incidence CodeVisible" := true;
    end;

    trigger OnOpenPage()
    begin
        if Rec."Absence Status" = Rec."Absence Status"::Justification then begin
            "Incidence CodeVisible" := false;
            "Justification CodeVisible" := true;
            "Subcategory CodeVisible" := false;
            "Subcategory DescriptionVisible" := false;
        end else begin
            "Incidence CodeVisible" := true;
            "Justification CodeVisible" := false;
        end;
    end;

    var
        [InDataSet]
        "Incidence CodeVisible": Boolean;
        [InDataSet]
        "Justification CodeVisible": Boolean;
        [InDataSet]
        "Subcategory CodeVisible": Boolean;
        [InDataSet]
        "Subcategory DescriptionVisible": Boolean;
}

#pragma implicitwith restore

