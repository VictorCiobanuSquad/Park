page 50018 "Atribuir Multiplos Serviços"
{
    /*
    IT001 - Park - 2018.03.28 - Atribuição multipla de serviços
    */
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Tasks;
    SourceTable = "Serviços a Atrbuir";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                }
                field(Tipo; Rec.Tipo)
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    begin

                        IF varRespCenter <> '' THEN BEGIN
                            IF Rec.Tipo = Rec.Tipo::Serviço THEN BEGIN
                                ServicesET.RESET;
                                ServicesET.SETRANGE(Blocked, FALSE);
                                ServicesET.SETRANGE("Subject Code", '');
                                ServicesET.SETFILTER("Responsibility Center", '%1|%2', varRespCenter, '');
                                IF ServicesET.FIND('-') THEN BEGIN
                                    IF Page.RUNMODAL(0, ServicesET) = ACTION::LookupOK THEN BEGIN
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
                                //recItem.SETFILTER("Product Group Code", '%1|%2', varRespCenter, '');
                                recItem.SETFILTER("Item Category Code", '%1|%2', varRespCenter, '');
                                IF recItem.FIND('-') THEN BEGIN
                                    IF Page.RUNMODAL(0, recItem) = ACTION::LookupOK THEN BEGIN
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
                                        Rec."No." := recItem."No.";
                                        Rec.Description := recItem.Description
                                    END;
                                END;
                            END;
                        END;
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Quantidade; Rec.Quantidade)
                {
                    ApplicationArea = All;
                }
                field(January; Rec.January)
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                }
                field(February; Rec.February)
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                }
                field(March; Rec.March)
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                }
                field(April; Rec.April)
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                }
                field(May; Rec.May)
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                }
                field(June; Rec.June)
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                }
                field(July; Rec.July)
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                }
                field(August; Rec.August)
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                }
                field(Setember; Rec.Setember)
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                }
                field(October; Rec.October)
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                }
                field(November; Rec.November)
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                }
                field(Dezember; Rec.Dezember)
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SETRANGE("User ID", USERID);
    end;

    local procedure FiltraCentResp(p_RespCenter: Code[10])
    begin
        varRespCenter := p_RespCenter;
    end;

    var
        varRespCenter: Code[10];
        ServicesET: Record "Services ET";
        recItem: Record Item;
}