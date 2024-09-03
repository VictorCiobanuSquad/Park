#pragma implicitwith disable
page 52752 "School Year"
{
    /*
    SQD001 - HSOARES - Ticket#NAV202200410 - 20220802
        - Add confirmation message on Menu Item: Em Fecho;

    //  //IT001 - 2017.02.27 - Nova funcionalidade para o utilizador criar anos letivos
    */

    Caption = 'School Year';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "School Year";

    layout
    {
        area(content)
        {
            repeater(Control1110000)
            {
                ShowCaption = false;
                field("School Year"; Rec."School Year")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Starting Date';
                    Visible = "Starting DateVisible";
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = "Ending DateVisible";
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(bFuction)
            {
                Caption = 'F&unctions';
                Visible = bFuctionVisible;
                action("&In Preparation")
                {
                    ApplicationArea = All;
                    Caption = '&In Preparation';
                    Image = PrepaymentPost;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        Rec.ChangeStatus(1);
                    end;
                }
                action("&Active")
                {
                    ApplicationArea = All;
                    Caption = '&Active';
                    Image = Open;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        Rec.ChangeStatus(2);
                    end;
                }
                action("&Closing")
                {
                    ApplicationArea = All;
                    Caption = '&Closing';
                    Image = CloseDocument;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        Text50000: Label 'Atenção! Depois desta ação não poderá faturar o ano letivo selecionado. Pretende avançar?';
                        Text50001: Label 'Operação cancelada!';
                    begin
                        // SQD001 --> START //
                        //ChangeStatus(3);
                        IF CONFIRM(Text50000) THEN
                            Rec.ChangeStatus(3)
                        ELSE
                            MESSAGE(Text50001);
                        // STOP <-- SQD001 //
                    end;
                }
                action("Cl&osed")
                {
                    ApplicationArea = All;
                    Caption = 'Cl&osed';
                    Image = Close;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        Rec.ChangeStatus(4);
                    end;
                }
                action("Criar Novos Anos")
                {
                    ApplicationArea = All;
                    Caption = 'Criar Novos Anos';
                    Image = New;

                    trigger OnAction()
                    begin
                        //IT001 - 2017.02.27 - Nova funcionalidade para o utilizador criar anos letivos

                        rSchoolYear.Reset;
                        if rSchoolYear.FindLast then begin
                            varAnoletivo := CopyStr(rSchoolYear."School Year", 6, 4);
                            varAnoletivo := varAnoletivo + '/' + IncStr(varAnoletivo);
                            if DIALOG.Confirm(StrSubstNo(Text0001, varAnoletivo), true, varAnoletivo) then begin
                                rSchoolYearNew.Init;
                                rSchoolYearNew."School Year" := varAnoletivo;
                                rSchoolYearNew.Status := 0;
                                rSchoolYearNew.Insert;
                            end;
                        end;
                    end;
                }
            }
        }
    }

    trigger OnInit()
    begin
        "Ending DateVisible" := true;
        "Starting DateVisible" := true;
        bFuctionVisible := true;
    end;

    trigger OnOpenPage()
    begin
        if CurrPage.LookupMode then begin
            bFuctionVisible := false;
            "Starting DateVisible" := false;
            "Ending DateVisible" := false;
        end else begin
            "Starting DateVisible" := true;
            "Ending DateVisible" := true;
        end;
        bFuctionXPos := 5060
    end;

    var
        [InDataSet]
        bFuctionVisible: Boolean;
        [InDataSet]
        "Starting DateVisible": Boolean;
        [InDataSet]
        "Ending DateVisible": Boolean;
        bFuctionXPos: Integer;
        Text0001: Label 'Deseja criar o ano letivo %1 ?';
        rSchoolYear: Record "School Year";
        rSchoolYearNew: Record "School Year";
        varAnoletivo: Code[10];
}

#pragma implicitwith restore

