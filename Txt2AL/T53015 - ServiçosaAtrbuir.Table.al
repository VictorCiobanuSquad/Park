table 53015 "Serviços a Atrbuir"
{
    // #001 SQD RTV 20201026 Ticket#NAV202000576
    //   Extended length of "Description" from 50 to 80 to match Table 52765 - "Services ET"
    // 
    //    IT001 - Park - 2018.03.28 - Atribuição multipla de serviços

    Caption = 'Services ET';
    DataCaptionFields = "No.", Description;
    DrillDownPageID = 52766;
    LookupPageID = 52766;

    fields
    {
        field(1; "User ID"; Code[20])
        {
            Caption = 'User ID';
            Editable = false;
        }
        field(2; Tipo; Option)
        {
            OptionCaption = 'Serviço,Produto';
            OptionMembers = "Serviço",Produto;
        }
        field(3; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    IF Tipo = Tipo::Serviço THEN BEGIN
                        IF rServices.GET("No.") THEN BEGIN
                            Description := rServices.Description;
                            January := rServices.January;
                            February := rServices.February;
                            March := rServices.March;
                            April := rServices.April;
                            May := rServices.May;
                            June := rServices.June;
                            July := rServices.July;
                            August := rServices.August;
                            Setember := rServices.Setember;
                            October := rServices.October;
                            November := rServices.November;
                            Dezember := rServices.December;
                        END;
                    END;
                    IF Tipo = Tipo::Produto THEN BEGIN
                        IF rItem.GET("No.") THEN BEGIN
                            Description := rItem.Description;
                            "Novo Valor" := rItem."Unit Price";
                            "Variant Code" := '';
                        END;
                    END;

                END;
            end;
        }
        field(4; Description; Text[80])
        {
            Caption = 'Description';
        }
        field(5; Quantidade; Integer)
        {
            Caption = 'Quantity';
        }
        field(6; "Novo Valor"; Decimal)
        {
            Caption = 'Periodicity';
        }
        field(8; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = IF (Tipo = CONST(Produto)) "Item Variant".Code WHERE("Item No." = FIELD("No."));
        }
        field(30; January; Boolean)
        {
            Caption = 'January';
        }
        field(31; February; Boolean)
        {
            Caption = 'February';
        }
        field(32; March; Boolean)
        {
            Caption = 'March';
        }
        field(33; April; Boolean)
        {
            Caption = 'April';
        }
        field(34; May; Boolean)
        {
            Caption = 'May';
        }
        field(35; June; Boolean)
        {
            Caption = 'June';
        }
        field(36; July; Boolean)
        {
            Caption = 'July';
        }
        field(37; August; Boolean)
        {
            Caption = 'August';
        }
        field(38; Setember; Boolean)
        {
            Caption = 'September';
        }
        field(39; October; Boolean)
        {
            Caption = 'October';
        }
        field(40; November; Boolean)
        {
            Caption = 'November';
        }
        field(41; Dezember; Boolean)
        {
            Caption = 'December';
        }
        field(60; "Service Plan Code"; Code[20])
        {
            Caption = 'Cód. Plano Serviços';
            Description = 'Park';
        }
    }

    keys
    {
        key(Key1; "User ID", Tipo, "No.", "Variant Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "User ID" := USERID;
    end;

    trigger OnModify()
    begin
        "User ID" := USERID;
    end;

    var
        Text0004: Label 'Your identification is set up to process from %1 %2 only.';
        Text0005: Label 'There are Service Plans with the selected Service. Deleting is not allowed.';
        Text0006: Label 'There are Student Service Plans with the selected Service. Deleting is not allowed.';
        rServices: Record "Services ET";
        rItem: Record Item;
}

