#pragma implicitwith disable
page 52781 "SubForm Student Services Plan"
{
    // //IT001 - ET: 2016.09.19 - Foi eliminado o campo Use Student Unit Price
    // //Caso o Aluno tenha um preço diferente basta preencher o novo preço na atribuição dos serviços

    AutoSplitKey = true;
    Caption = 'Student Services Plan';
    DelayedInsert = true;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Student Service Plan";
    SourceTableView = SORTING("Student No.", Selected)
                      ORDER(Descending);

    layout
    {
        area(content)
        {
            repeater(Control1102059000)
            {
                ShowCaption = false;
                field("Student No."; Rec."Student No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Selected; Rec.Selected)
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnValidate()
                    begin
                        SelectedOnAfterValidate;
                    end;
                }
                field("Service Code"; Rec."Service Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Student Unit Price"; Rec."Student Unit Price")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Service Type"; Rec."Service Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(January; Rec.January)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(February; Rec.February)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'February';
                }
                field(March; Rec.March)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(April; Rec.April)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(May; Rec.May)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(June; Rec.June)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(July; Rec.July)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(August; Rec.August)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Setember; Rec.Setember)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(October; Rec.October)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(November; Rec.November)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Dezember; Rec.Dezember)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'December';
                }
                field("Schooling Year"; Rec."Schooling Year")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        //Não acho que se deva poder editar o campo e mudar o preço
        /*
        IF GetUseStudentUnitPrice THEN BEGIN
           "Student Unit PriceEditable" := TRUE;
        END ELSE BEGIN
           "Student Unit PriceEditable" := FALSE;
        END;
        */

    end;

    trigger OnInit()
    begin
        //Não acho que se deva poder editar o campo e mudar o preço
        //"Student Unit PriceEditable" := TRUE;
    end;

    var
        [InDataSet]
        "Student Unit PriceEditable": Boolean;

    local procedure SelectedOnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure StudentUnitPriceOnActivate()
    begin
    end;
}

#pragma implicitwith restore

