table 31009814 "User Group GIC"
{
    Caption = 'User Group GIC';
    DrillDownPageID = "User Group/Typology List";
    LookupPageID = "User Group/Typology List";

    fields
    {
        field(1;Type;Option)
        {
            Caption = 'Type';
            OptionCaption = 'Group,Typology';
            OptionMembers = Group,Typology;
        }
        field(2;"Code";Code[20])
        {
            Caption = 'Code';
        }
        field(3;Description;Text[30])
        {
            Caption = 'Description';
        }
        field(4;Typology;Code[20])
        {
            Caption = 'Typology';
            TableRelation = "User Group GIC".Code WHERE (Type=FILTER(Typology));
        }
        field(5;Teacher;Code[20])
        {
            Caption = 'Teacher';
            TableRelation = Teacher."No.";
        }
        field(6;Activate;Boolean)
        {
            Caption = 'Activate';
        }
        field(7;Child;Boolean)
        {
            Caption = 'Child';
        }
        field(8;"Group Defect";Boolean)
        {
            Caption = 'Group Defect';
        }
        field(9;Open;Boolean)
        {
            Caption = 'Open';
        }
        field(10;Academic;Boolean)
        {
            Caption = 'Academic';
        }
        field(11;Class;Code[20])
        {
            Caption = 'Class';
            TableRelation = Class.Class;

            trigger OnLookup()
            var
                rClass: Record Class;
                cStudentsRegistration: Codeunit "Students Registration";
            begin
                rClass.Reset;
                rClass.SetFilter("School Year",cStudentsRegistration.GetShoolYearPreActiveClosing);
                if rClass.Find('-') then begin
                   if PAGE.RunModal(PAGE::"Class List",rClass) = ACTION::LookupOK then begin
                      Class := rClass.Class;
                      "School Year" := rClass."School Year";

                   end;

                end;
            end;
        }
        field(12;"School Year";Code[9])
        {
            Caption = 'School Year';
            TableRelation = "School Year"."School Year";
        }
    }

    keys
    {
        key(Key1;Type,"Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

