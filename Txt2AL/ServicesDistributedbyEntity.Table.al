table 31009771 "Services Distributed by Entity"
{
    Caption = 'Services Distributed by Entity';

    fields
    {
        field(1;Class;Code[20])
        {
            Caption = 'Class';
            TableRelation = Class.Class;
        }
        field(2;"School Year";Code[9])
        {
            Caption = 'School Year';
            TableRelation = "School Year"."School Year";
        }
        field(3;"Schooling Year";Code[10])
        {
            Caption = 'Schooling Year';
            TableRelation = "Structure Education Country"."Schooling Year";
        }
        field(4;"Student No.";Code[20])
        {
            Caption = 'Student No.';
            TableRelation = Students."No.";
        }
        field(5;Kinship;Option)
        {
            Caption = 'Kinship';
            OptionCaption = ' ,Father,Mother,GrandFather,GrandMother,Brother,Sister,Brother in School,Uncle,Aunt,Himself,Tutor,Other';
            OptionMembers = " ",Pai,"Mãe","Avô","Avó","Irmão","Irmã","Irmão na Escola",Tio,Tia,"Próprio",Tutor,Outro;
        }
        field(6;"No.";Code[20])
        {
            Caption = 'No.';
            Editable = false;
            TableRelation = IF (Kinship=CONST("Irmão na Escola")) Students
                            ELSE IF (Kinship=CONST("Próprio")) Students
                            ELSE IF (Kinship=CONST(Pai)) "Users Family"
                            ELSE IF (Kinship=CONST("Mãe")) "Users Family"
                            ELSE IF (Kinship=CONST("Avô")) "Users Family"
                            ELSE IF (Kinship=CONST("Avó")) "Users Family"
                            ELSE IF (Kinship=CONST("Irmão")) "Users Family"
                            ELSE IF (Kinship=CONST("Irmã")) "Users Family"
                            ELSE IF (Kinship=CONST(Tio)) "Users Family"
                            ELSE IF (Kinship=CONST(Tia)) "Users Family"
                            ELSE IF (Kinship=CONST(Tutor)) "Users Family"
                            ELSE IF (Kinship=CONST(Outro)) "Users Family";
        }
        field(7;"Service Code";Code[20])
        {
            Caption = 'Service Code';
            TableRelation = IF (Type=FILTER(Service)) "Services ET"."No."
                            ELSE IF (Type=FILTER(Item)) Item."No.";
        }
        field(8;Description;Text[80])
        {
            Caption = 'Description';
        }
        field(9;"Percent %";Decimal)
        {
            Caption = 'Percent %';
            DecimalPlaces = 0:5;
            MaxValue = 100;
        }
        field(10;"Name of Associate";Text[128])
        {
            Caption = 'Name of Associate';
            Editable = false;
        }
        field(12;"Line No.";Integer)
        {
            Caption = 'Line No.';
        }
        field(13;"Description 2";Text[30])
        {
            Caption = 'Description 2';
        }
        field(14;"Customer No.";Code[20])
        {
            Caption = 'Customer No.';
            Editable = false;
            TableRelation = IF (Kinship=CONST("Próprio"),
                                Kinship=CONST("Irmão na Escola")) Customer."No." WHERE ("Student No."=FIELD("No."))
                                ELSE IF (Kinship=FILTER(<>"Próprio"),
                                         Kinship=FILTER(<>"Irmão na Escola")) Customer."No." WHERE ("User Family No."=FIELD("No."));

            trigger OnValidate()
            begin
                if (Kinship = Kinship::"Próprio") or (Kinship = Kinship::"Irmão na Escola")then begin
                  Customer.Reset;
                  Customer.SetRange("Student No.","No.");
                  if Customer.FindFirst then begin
                    "Customer No." := Customer."No.";
                  end;
                end;
                if (Kinship <> Kinship::"Próprio") or (Kinship <> Kinship::"Irmão na Escola") then begin
                  Customer.Reset;
                  Customer.SetRange("User Family No.","No.");
                  if Customer.FindFirst then begin
                    "Customer No." := Customer."No.";
                  end;
                end;
            end;
        }
        field(48;Type;Option)
        {
            Caption = 'Type';
            Editable = false;
            OptionCaption = 'Service,Item';
            OptionMembers = Service,Item;
        }
        field(1000;"User ID";Code[20])
        {
            Caption = 'User ID';
            Editable = false;
        }
        field(1001;"Last Date Modified";Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(50000;"Variant Code";Code[50])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code;
        }
    }

    keys
    {
        key(Key1;"School Year","Student No.","Line No.")
        {
            Clustered = true;
        }
        key(Key2;"Service Code","Variant Code","School Year","Schooling Year","Student No.")
        {
            SumIndexFields = "Percent %";
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Last Date Modified" := Today;
        "User ID" := UserId;
    end;

    trigger OnModify()
    begin
        "Last Date Modified" := Today;
        "User ID" := UserId;
    end;

    var
        ServicesET: Record "Services ET";
        UsersFamilyStud: Record "Users Family / Students";
        UsersFamily: Record "Users Family";
        Customer: Record Customer;
}

