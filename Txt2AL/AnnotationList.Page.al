#pragma implicitwith disable
page 31009961 "Annotation List"
{
    Caption = 'Annotation List';
    CardPageID = "Annotation Header";
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = Annotation;
    SourceTableView = WHERE("Line Type" = CONST(Cab));

    layout
    {
        area(content)
        {
            repeater(Control1102059000)
            {
                Editable = false;
                ShowCaption = false;
                field("School Year"; Rec."School Year")
                {
                    ApplicationArea = Basic, Suite;
                }
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
            group(AnnotationFuncion)
            {
                Caption = '&Annotation';
                action("&Card")
                {
                    Caption = '&Card';
                    Image = EditLines;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    begin
                        PAGE.Run(PAGE::"Annotation Header", Rec);
                    end;
                }
            }
        }
    }

    var
        rSchoolYear: Record "School Year";
        FilterText: Text[100];
        cUserEducation: Codeunit "User Education";
}

#pragma implicitwith restore

