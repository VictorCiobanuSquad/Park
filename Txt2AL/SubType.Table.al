table 31009809 "Sub Type"
{
    Caption = 'Sub Type';
    DrillDownPageID = "Subtype Config";
    LookupPageID = "Subtype Config";
    Permissions = TableData Absence=rimd,
                  TableData "WEB Absence"=rimd;

    fields
    {
        field(1;Category;Option)
        {
            Caption = 'Category';
            OptionCaption = 'Class,Cantine,BUS,Schoolyard,Extra-scholar,Teacher';
            OptionMembers = Class,Cantine,BUS,Schoolyard,"Extra-scholar",Teacher;
        }
        field(2;"Subcategory Code";Code[20])
        {
            Caption = 'Subcategory Code';
            NotBlank = true;
        }
        field(3;Description;Text[50])
        {
            Caption = 'Subcategory Description';
        }
    }

    keys
    {
        key(Key1;Category,"Subcategory Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin

        rIncidenceType.Reset;
        rIncidenceType.SetRange(Category,Category);
        rIncidenceType.SetRange("Subcategory Code","Subcategory Code");
        if rIncidenceType.FindFirst then
          Error(text001);
    end;

    var
        rIncidenceType: Record "Incidence Type";
        text001: Label 'Sub-Type already in use!';
}

