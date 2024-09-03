table 52804 "Transition Rules"
{
    Caption = 'Transition Rules';
    DrillDownPageID = "Transition Rules List";
    LookupPageID = "Transition Rules List";

    fields
    {
        field(1; Level; Option)
        {
            Caption = 'Level';
            OptionCaption = 'Pre-school,1º Cycle,2º Cycle,3º Cycle,Secondary';
            OptionMembers = "Pre school","1º Cycle","2º Cycle","3º Cycle",Secondary;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; Causes; Text[250])
        {
            Caption = 'Causes';
        }
        field(4; "Validation Type"; Option)
        {
            Caption = 'Validation Type';
            OptionCaption = 'Absence,Classification';
            OptionMembers = Absence,Classification;
        }
        field(5; Rules; Option)
        {
            Caption = 'Rules';
            OptionCaption = ' ,FI>LFI,FI+LFJ>LFI+LFJ';
            OptionMembers = " ","FI>LFI","FI+LFJ>LFI+LFJ";
        }
        field(6; "Classfication Value"; Option)
        {
            Caption = 'Classfication Value';
            OptionCaption = ' ,Minimun,Negative,Positive';
            OptionMembers = " ",Minimun,Negative,Positive;
        }
        field(7; "Minimum Subject Value"; Decimal)
        {
            BlankZero = true;
            Caption = 'Minimum Subject Value';
            DecimalPlaces = 0 : 0;
        }
        field(8; "AE ENEB Code"; Code[10])
        {
            Caption = 'AE ENEB Code';
            TableRelation = "Legal Codes"."Parish/Council/District Code" WHERE(Type = FILTER(Subject),
                                                                                "Legal Code Type" = FILTER(Simple));
        }
        field(9; "Value 3"; Option)
        {
            Caption = 'Value 3';
            OptionCaption = ' ,Minimun,Negative,Positive';
            OptionMembers = " ",Minimun,Negative,Positive;
        }
        field(10; "ENEB 1 Code"; Code[10])
        {
            Caption = 'ENEB 1 Code';
            TableRelation = "Legal Codes"."Parish/Council/District Code" WHERE(Type = FILTER(Subject),
                                                                                "Legal Code Type" = FILTER(Simple));
        }
        field(11; "ENEB 1 Value"; Option)
        {
            Caption = 'ENEB 1 Value';
            OptionCaption = ' ,Minimun,Negative,Positive';
            OptionMembers = " ",Minimun,Negative,Positive;
        }
        field(12; "AND OR"; Option)
        {
            Caption = 'AND OR';
            OptionCaption = 'AND,OR';
            OptionMembers = "And","OR";
        }
        field(13; "ENEB 2 Code"; Code[10])
        {
            Caption = 'ENEB 2 Code';
            TableRelation = "Legal Codes"."Parish/Council/District Code" WHERE(Type = FILTER(Subject),
                                                                                "Legal Code Type" = FILTER(Simple));
        }
        field(14; "ENEB 2 Value"; Option)
        {
            Caption = 'ENEB 2 Value';
            OptionCaption = ' ,Minimun,Negative,Positive';
            OptionMembers = " ",Minimun,Negative,Positive;
        }
        field(15; "Not Approved"; Boolean)
        {
            Caption = 'Not Approved';
        }
        field(16; Retained; Boolean)
        {
            Caption = 'Retained';
        }
        field(17; Excluded; Boolean)
        {
            Caption = 'Excluded';
        }
        field(18; "Resume School Process"; Boolean)
        {
            Caption = 'Resume School Process';
        }
        field(19; "Exam Blocked"; Boolean)
        {
            Caption = 'Exam Blocked';
        }
        field(20; Formula; Text[250])
        {
            Caption = 'Formula';
        }
        field(21; "Maximum Absence Injustified"; Integer)
        {
            BlankZero = true;
            Caption = 'Maximum Unjustified Absence';
        }
        field(22; "Maximum Absence Justified"; Integer)
        {
            BlankZero = true;
            Caption = 'Maximum Absence Justified';
        }
    }

    keys
    {
        key(Key1; Level, "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        rTransitionRules.Reset;
        if rTransitionRules.Find('+') then
            "Line No." := rTransitionRules."Line No." + 10000
        else
            "Line No." := 10000;
    end;

    var
        rTransitionRules: Record "Transition Rules";
}

