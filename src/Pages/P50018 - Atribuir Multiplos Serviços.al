#pragma implicitwith disable
page 50018 "Atribuir Multiplos Serviços"
{
    /*
    IT001 - Park - 2018.03.28 - Atribuição multipla de serviços
    */
    //Caption = 'Atribuição multipla de serviços';
    PageType = ListPart;
    SourceTable = "Serviços a Atrbuir";
    layout
    {
        area(Content)
        {
            repeater(Control1000000026)
            {
                ShowCaption = false;
                field("User ID"; Rec."User ID")
                {

                }
                field(Tipo; Rec.Tipo)
                {

                }
                field(NoAux; NoAux)
                {
                    Caption = 'Nº.';

                    trigger OnValidate()

                    begin
                        Rec.Validate("No.", NoAux);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        l_PageServiceAT: page "Service ET List 2";
                    begin
                        IF varRespCenter <> '' THEN BEGIN
                            IF Rec.Tipo = Rec.Tipo::Serviço THEN BEGIN
                                ServicesET.RESET;
                                ServicesET.SETRANGE(Blocked, FALSE);
                                ServicesET.SETRANGE("Subject Code", '');
                                ServicesET.SETFILTER("Responsibility Center", '%1|%2', varRespCenter, '');
                                IF ServicesET.FIND('-') THEN BEGIN
                                    IF PAGE.RUNMODAL(0, ServicesET) = ACTION::LookupOK THEN BEGIN
                                        NoAux := ServicesET."No.";
                                        Rec."No." := ServicesET."No.";
                                        Rec.Description := ServicesET.Description;
                                        Rec.January := ServicesET.January;
                                        Rec.February := ServicesET.February;
                                        Rec.March := ServicesET.March;
                                        Rec.April := ServicesET.April;
                                        Rec.May := ServicesET.May;
                                        Rec.June := ServicesET.June;
                                        Rec.July := ServicesET.July;
                                        Rec.August := ServicesET.August;
                                        Rec.Setember := ServicesET.Setember;
                                        Rec.October := ServicesET.October;
                                        Rec.November := ServicesET.November;
                                        Rec.Dezember := ServicesET.December;

                                    END;
                                END;
                            END ELSE BEGIN
                                recItem.RESET;
                                recItem.SETRANGE(Blocked, FALSE);
                                recItem.SETFILTER("Item Category Code", '%1|%2', varRespCenter, '');
                                IF recItem.FIND('-') THEN BEGIN
                                    IF PAGE.RUNMODAL(0, recItem) = ACTION::LookupOK THEN BEGIN
                                        NoAux := ServicesET."No.";
                                        Rec."No." := recItem."No.";
                                        Rec.Description := recItem.Description;
                                    END;
                                END;
                            END;
                        END ELSE BEGIN
                            IF Rec.Tipo = Rec.Tipo::Serviço THEN BEGIN
                                ServicesET.RESET;
                                ServicesET.SETRANGE(Blocked, FALSE);
                                ServicesET.SETRANGE("Subject Code", '');
                                IF ServicesET.FIND('-') THEN BEGIN
                                    IF Page.RUNMODAL(0, ServicesET) = ACTION::LookupOK THEN BEGIN
                                        NoAux := ServicesET."No.";
                                        Rec."No." := ServicesET."No.";
                                        Rec.Description := ServicesET.Description;
                                        Rec.January := ServicesET.January;
                                        Rec.February := ServicesET.February;
                                        Rec.March := ServicesET.March;
                                        Rec.April := ServicesET.April;
                                        Rec.May := ServicesET.May;
                                        Rec.June := ServicesET.June;
                                        Rec.July := ServicesET.July;
                                        Rec.August := ServicesET.August;
                                        Rec.Setember := ServicesET.Setember;
                                        Rec.October := ServicesET.October;
                                        Rec.November := ServicesET.November;
                                        Rec.Dezember := ServicesET.December;

                                    END;
                                END;
                            END ELSE BEGIN
                                recItem.RESET;
                                recItem.SETRANGE(Blocked, FALSE);
                                IF recItem.FIND('-') THEN BEGIN
                                    IF Page.RUNMODAL(0, recItem) = ACTION::LookupOK THEN BEGIN
                                        NoAux := ServicesET."No.";
                                        Rec."No." := recItem."No.";
                                        Rec.Description := recItem.Description
                                    END;
                                END;
                            END;
                        END;
                    END;
                }
                field(Description; Rec.Description)
                {


                }
                field(Quantidade; Rec.Quantidade)
                {

                }
                field(January; Rec.January)
                {

                }
                field(February; Rec.February)
                {

                }
                field(March; Rec.March)
                {

                }
                field(April; Rec.April)
                {

                }
                field(May; Rec.May)
                {

                }
                field(June; Rec.June)
                {

                }
                field(July; Rec.July)
                {

                }
                field(August; Rec.August)
                {
                }
                field(Setember; Rec.Setember)
                {
                }
                field(October; Rec.October)
                {
                }
                field(November; Rec.November)
                {
                }
                field(Dezember; Rec.Dezember)
                {
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SETRANGE("User ID", USERID);
    end;

    trigger OnAfterGetRecord()
    begin
        if NoAux <> Rec."No." then
            NoAux := Rec."No.";
    end;

    trigger OnInit()
    begin
        Clear(NoAux);
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        NoAux := Rec."No.";
    end;

    trigger OnModifyRecord(): Boolean
    begin
        if Rec."No." <> xRec."No." then
            NoAux := Rec."No.";
    end;

    procedure FiltraCentResp(p_RespCenter: Code[10])
    begin
        varRespCenter := p_RespCenter;
    end;

    var
        varRespCenter: Code[10];
        ServicesET: Record "Services ET";
        recItem: Record Item;

        NoAux: Code[20];

}
#pragma implicitwith restore
