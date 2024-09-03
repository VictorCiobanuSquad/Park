table 52823 "Assessment Configuration"
{
    Caption = 'Assessment Configuration';
    LookupPageID = "Assessment Configuration List";

    fields
    {
        field(1; "School Year"; Code[9])
        {
            Caption = 'School Year';
            TableRelation = "School Year"."School Year";
        }
        field(3; "Study Plan Code"; Code[20])
        {
            Caption = 'Study Plan/Course Code';
            TableRelation = IF (Type = FILTER(Simple)) "Study Plan Header".Code WHERE("School Year" = FIELD("School Year"))
            ELSE
            IF (Type = FILTER(Multi)) "Course Header".Code;

            trigger OnValidate()
            begin
                /*
                IF rStudyPlanHeader.GET("Study Plan Code") THEN BEGIN
                   "School Year":=  rStudyPlanHeader."School Year";
                    "Schooling Year" := rStudyPlanHeader."Schooling Year";
                END ELSE BEGIN
                   "School Year":=  '';
                   "Schooling Year" := '';
                END;
                 */

            end;
        }
        field(4; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Simple,Multi';
            OptionMembers = Simple,Multi;
        }
        field(5; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(6; "PA Subjects Classification"; Option)
        {
            Caption = 'Subjects Classification';
            Description = 'Periodic Assessent';
            OptionCaption = 'Sub-Subject (Vertical) ,Subject (Vertical)';
            OptionMembers = "Sub-Subject (Vertical) ","Subject (Horizontal)";
        }
        field(7; "PA Subject Round Method"; Decimal)
        {
            Caption = 'Subject Round Method';
            DecimalPlaces = 1 : 3;
            Description = 'Periodic Assessent';
            InitValue = 0.01;
            MaxValue = 1;
        }
        field(8; "PA Group Sub. Classification"; Option)
        {
            Caption = 'Group Sub. Classification';
            Description = 'Periodic Assessent';
            OptionCaption = 'Sub-Subject (Vertical) ,Subject (Vertical)';
            OptionMembers = "Sub-Subject (Vertical) ","Subject (Vertical)";
        }
        field(9; "PA Group Sub. Round Method"; Decimal)
        {
            Caption = 'Group Sub. Round Method';
            DecimalPlaces = 1 : 3;
            Description = 'Periodic Assessent';
            InitValue = 0.01;
            MaxValue = 1;
        }
        field(10; "PA Final Classification"; Option)
        {
            Caption = 'Final Classification';
            Description = 'Periodic Assessent';
            OptionCaption = 'Group (Vertical),Sub-Subject (Vertical),Subject (Vertical)';
            OptionMembers = "Group (Vertical)","Sub-Subject (Vertical)","Subject (Vertical)";
        }
        field(11; "PA Final Round Method"; Decimal)
        {
            Caption = 'Final Round Method';
            DecimalPlaces = 1 : 3;
            Description = 'Periodic Assessent';
            InitValue = 0.01;
            MaxValue = 1;
        }
        field(12; "FY Sub Subjects Classification"; Option)
        {
            Caption = 'Sub Subjects Classification';
            Description = 'Final Year';
            OptionCaption = 'Sub-Subject (Horizontal)';
            OptionMembers = "Sub-Subject (Horizontal)";
        }
        field(13; "FY Sub Subject Round Method"; Decimal)
        {
            Caption = 'Sub Subject Round Method';
            DecimalPlaces = 1 : 3;
            Description = 'Final Year';
            InitValue = 0.01;
            MaxValue = 1;
        }
        field(14; "FY Subjects Classification"; Option)
        {
            Caption = 'Subjects Classification';
            Description = 'Final Year';
            OptionCaption = 'Sub-Subject (Vertical) ,Subject (Horizontal)';
            OptionMembers = "Sub-Subject (Vertical) ","Subject (Horizontal)";
        }
        field(15; "FY Subject Round Method"; Decimal)
        {
            Caption = 'Subject Round Method';
            DecimalPlaces = 1 : 3;
            Description = 'Final Year';
            InitValue = 0.01;
            MaxValue = 1;
        }
        field(16; "FY Group Sub. Classification"; Option)
        {
            Caption = 'Group Sub. Classification';
            Description = 'Final Year';
            OptionCaption = 'Group (Horizontal),Sub-Subject (Vertical) ,Subject (Vertical)';
            OptionMembers = "Group (Horizontal)","Sub-Subject (Vertical) ","Subject (Vertical)";
        }
        field(17; "FY Group Sub. Round Method"; Decimal)
        {
            Caption = 'Group Sub. Round Method';
            DecimalPlaces = 1 : 3;
            Description = 'Final Year';
            InitValue = 0.01;
            MaxValue = 1;
        }
        field(18; "FY Final Classification"; Option)
        {
            Caption = 'Final Classification';
            Description = 'Final Year';
            OptionCaption = 'Final (Horizontal),Group (Horizontal),Sub-Subject (Vertical),Subject (Vertical)';
            OptionMembers = "Final (Horizontal)","Group (Horizontal)","Sub-Subject (Vertical)","Subject (Vertical)";
        }
        field(19; "FY Final Round Method"; Decimal)
        {
            Caption = 'Final Round Method';
            DecimalPlaces = 1 : 3;
            Description = 'Final Year';
            InitValue = 0.01;
            MaxValue = 1;
        }
        field(20; "FL Sub Subjects Classification"; Option)
        {
            Caption = 'Sub Subjects Classification';
            Description = 'Final Level';
            OptionCaption = 'Sub-Subject (Horizontal)';
            OptionMembers = "Sub-Subject (Horizontal)";
        }
        field(21; "FL Sub Subject Round Method"; Decimal)
        {
            Caption = 'Sub Subject Round Method';
            DecimalPlaces = 1 : 3;
            Description = 'Final Level';
            InitValue = 0.01;
            MaxValue = 1;
        }
        field(22; "FL Subjects Classification"; Option)
        {
            Caption = 'Subjects Classification';
            Description = 'Final Level';
            OptionCaption = 'Sub-Subject (Vertical) ,Subject (Vertical)';
            OptionMembers = "Sub-Subject (Vertical) ","Subject (Vertical)";
        }
        field(23; "FL Subject Round Method"; Decimal)
        {
            Caption = 'Subject Round Method';
            DecimalPlaces = 1 : 3;
            Description = 'Final Level';
            InitValue = 0.01;
            MaxValue = 1;
        }
        field(24; "FL Group Sub. Classification"; Option)
        {
            Caption = 'Group Sub. Classification';
            Description = 'Final Level';
            OptionCaption = 'Group (Horizontal),Sub-Subject (Vertical) ,Subject (Vertical)';
            OptionMembers = "Group (Horizontal)","Sub-Subject (Vertical) ","Subject (Vertical)";
        }
        field(25; "FL Group Sub. Round Method"; Decimal)
        {
            Caption = 'Group Sub. Round Method';
            DecimalPlaces = 1 : 3;
            Description = 'Final Level';
            InitValue = 0.01;
            MaxValue = 1;
        }
        field(26; "FL Final Classification"; Option)
        {
            Caption = 'Final Classification';
            Description = 'Final Level';
            OptionCaption = 'Final (Vertical),Group (Horizontal),Sub-Subject (Vertical),Subject (Vertical)';
            OptionMembers = "Final (Vertical)","Group (Horizontal)","Sub-Subject (Vertical)","Subject (Vertical)";
        }
        field(27; "FL Final Round Method"; Decimal)
        {
            Caption = 'Final Round Method';
            DecimalPlaces = 1 : 3;
            Description = 'Final Level';
            InitValue = 0.01;
            MaxValue = 1;
        }
        field(28; "PA Evaluation Type"; Option)
        {
            Caption = 'Evaluation Type';
            Description = 'Periodic Assessent';
            OptionCaption = ' ,Qualitative,Quantitative,None Qualification,Mixed-Qualification';
            OptionMembers = " ",Qualitative,Quantitative,"None Qualification","Mixed-Qualification";

            trigger OnValidate()
            begin
                if "PA Evaluation Type" <> xRec."PA Evaluation Type" then
                    Validate("PA Assessment Code", '');
            end;
        }
        field(29; "PA Assessment Code"; Code[20])
        {
            Caption = 'Assessment Code';
            Description = 'Periodic Assessent';
            TableRelation = "Rank Group".Code WHERE("Evaluation Type" = FIELD("PA Evaluation Type"));
        }
        field(30; "PA Min Classification Level"; Code[20])
        {
            Caption = 'Minimum Classification Level';
            TableRelation = "Classification Level"."Classification Level Code" WHERE("Classification Group Code" = FIELD("PA Assessment Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                l_TempValue: Decimal;
            begin
                if rRankGroup.Get("PA Assessment Code") then begin
                    if (rRankGroup."Evaluation Type" = rRankGroup."Evaluation Type"::Qualitative) or
                       (rRankGroup."Evaluation Type" = rRankGroup."Evaluation Type"::"Mixed-Qualification") then begin
                        rClassificationLevel.Reset;
                        rClassificationLevel.SetRange("Classification Group Code", "PA Assessment Code");
                        rClassificationLevel.SetRange("Classification Level Code", "PA Min Classification Level");
                        if not rClassificationLevel.Find('-') then
                            Error(Text0001);

                    end;
                    if (rRankGroup."Evaluation Type" = rRankGroup."Evaluation Type"::Quantitative) then begin
                        rClassificationLevel.Reset;
                        rClassificationLevel.SetRange("Classification Group Code", "PA Assessment Code");
                        if rClassificationLevel.Find('-') then begin
                            Evaluate(l_TempValue, "PA Min Classification Level");
                            if (l_TempValue < rClassificationLevel."Min Value") or
                               (l_TempValue > rClassificationLevel."Max Value") then
                                Error(Text0002, rClassificationLevel."Min Value", rClassificationLevel."Max Value");
                        end;
                    end;

                end;
            end;
        }
        field(31; "FY Evaluation Type"; Option)
        {
            Caption = 'Evaluation Type';
            Description = 'Final Year';
            OptionCaption = ' ,Qualitative,Quantitative,None Qualification,Mixed-Qualification';
            OptionMembers = " ",Qualitative,Quantitative,"None Qualification","Mixed-Qualification";

            trigger OnValidate()
            begin
                if "FY Evaluation Type" <> xRec."FY Evaluation Type" then
                    Validate("FY Assessment Code", '');
            end;
        }
        field(32; "FY Assessment Code"; Code[20])
        {
            Caption = 'Assessment Code';
            Description = 'Final Year';
            TableRelation = "Rank Group".Code WHERE("Evaluation Type" = FIELD("FY Evaluation Type"));
        }
        field(33; "FY Min Classification Level"; Code[20])
        {
            Caption = 'Minimum Classification Level';
            TableRelation = "Classification Level"."Classification Level Code" WHERE("Classification Group Code" = FIELD("FY Assessment Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                l_TempValue: Decimal;
            begin
                if rRankGroup.Get("FY Assessment Code") then begin
                    if (rRankGroup."Evaluation Type" = rRankGroup."Evaluation Type"::Qualitative) or
                       (rRankGroup."Evaluation Type" = rRankGroup."Evaluation Type"::"Mixed-Qualification") then begin
                        rClassificationLevel.Reset;
                        rClassificationLevel.SetRange("Classification Group Code", "FY Assessment Code");
                        rClassificationLevel.SetRange("Classification Level Code", "FY Min Classification Level");
                        if not rClassificationLevel.Find('-') then
                            Error(Text0001);

                    end;
                    if (rRankGroup."Evaluation Type" = rRankGroup."Evaluation Type"::Quantitative) then begin
                        rClassificationLevel.Reset;
                        rClassificationLevel.SetRange("Classification Group Code", "FY Assessment Code");
                        if rClassificationLevel.Find('-') then begin
                            Evaluate(l_TempValue, "FY Min Classification Level");
                            if (l_TempValue < rClassificationLevel."Min Value") or
                               (l_TempValue > rClassificationLevel."Max Value") then
                                Error(Text0002, rClassificationLevel."Min Value", rClassificationLevel."Max Value");
                        end;
                    end;

                end;
            end;
        }
        field(34; "FL Evaluation Type"; Option)
        {
            Caption = 'Evaluation Type';
            Description = 'Final Level';
            OptionCaption = ' ,Qualitative,Quantitative,None Qualification,Mixed-Qualification';
            OptionMembers = " ",Qualitative,Quantitative,"None Qualification","Mixed-Qualification";

            trigger OnValidate()
            begin
                if "FL Evaluation Type" <> xRec."FL Evaluation Type" then
                    Validate("FL Assessment Code", '');
            end;
        }
        field(35; "FL Assessment Code"; Code[20])
        {
            Caption = 'Assessment Code';
            Description = 'Final Level';
            TableRelation = "Rank Group".Code WHERE("Evaluation Type" = FIELD("FL Evaluation Type"));
        }
        field(36; "FL Min Classification Level"; Code[20])
        {
            Caption = 'Minimum Classification Level';
            TableRelation = "Classification Level"."Classification Level Code" WHERE("Classification Group Code" = FIELD("FL Assessment Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                l_TempValue: Decimal;
            begin
                if rRankGroup.Get("FL Assessment Code") then begin
                    if (rRankGroup."Evaluation Type" = rRankGroup."Evaluation Type"::Qualitative) or
                       (rRankGroup."Evaluation Type" = rRankGroup."Evaluation Type"::"Mixed-Qualification") then begin
                        rClassificationLevel.Reset;
                        rClassificationLevel.SetRange("Classification Group Code", "FL Assessment Code");
                        rClassificationLevel.SetRange("Classification Level Code", "FL Min Classification Level");
                        if not rClassificationLevel.Find('-') then
                            Error(Text0001);

                    end;
                    if (rRankGroup."Evaluation Type" = rRankGroup."Evaluation Type"::Quantitative) then begin
                        rClassificationLevel.Reset;
                        rClassificationLevel.SetRange("Classification Group Code", "FL Assessment Code");
                        if rClassificationLevel.Find('-') then begin
                            Evaluate(l_TempValue, "FL Min Classification Level");
                            if (l_TempValue < rClassificationLevel."Min Value") or
                               (l_TempValue > rClassificationLevel."Max Value") then
                                Error(Text0002, rClassificationLevel."Min Value", rClassificationLevel."Max Value");
                        end;
                    end;

                end;
            end;
        }
        field(37; "Annotation Code"; Code[10])
        {
            Caption = 'Annotation Cod.';
            TableRelation = Annotation.Code WHERE("Line Type" = CONST(Cab));
        }
        field(38; "Use Evaluation Rules"; Boolean)
        {
            Caption = 'Use Evaluation Rules';

            trigger OnValidate()
            begin
                if "Use Evaluation Rules" then begin
                    if "Level Group" <> xRec."Level Group" then
                        DeleteRules;
                    TestField("School Year");
                    InsertRules;
                end else
                    DeleteRules;
            end;
        }
        field(39; "Level Group"; Code[10])
        {
            Caption = 'Level Group';
            Description = 'Level Group Rules Of Evaluation';

            trigger OnLookup()
            var
                l_rRulesofEvaluations: Record "Rules of Evaluations";
            begin
            end;

            trigger OnValidate()
            var
                l_RulesEvaluations: Record "Rules of Evaluations";
            begin
                l_RulesEvaluations.Reset;
                l_RulesEvaluations.SetRange("Study Plan Code", '');
                l_RulesEvaluations.SetFilter("Level Group", "Level Group");
                if not l_RulesEvaluations.FindFirst then
                    Error(Text0001);

                if ("Level Group" <> xRec."Level Group") and "Use Evaluation Rules" then begin
                    DeleteRules;
                    TestField("School Year");
                    InsertRules;
                end else begin
                    if ("Level Group" <> xRec."Level Group") or not "Use Evaluation Rules" then
                        DeleteRules;
                end;
            end;
        }
    }

    keys
    {
        key(Key1; "School Year", Type, "Study Plan Code", "Country/Region Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnModify()
    begin
        if "Annotation Code" <> xRec."Annotation Code" then
            cInsertNAVMasterTable.ModifyAnnotationsConf(Rec, xRec);
    end;

    var
        rClassificationLevel: Record "Classification Level";
        rRankGroup: Record "Rank Group";
        Text0001: Label 'You must specify a valid code.';
        Text0002: Label 'The value must be between %1 and %2.';
        cInsertNAVMasterTable: Codeunit InsertNAVMasterTable;

    //[Scope('OnPrem')]
    procedure InsertRules()
    var
        l_CourseHeader: Record "Course Header";
        l_RulesEvaluations: Record "Rules of Evaluations";
        l_StructureEduCountry: Record "Structure Education Country";
        l_StructureEduCountry2: Record "Structure Education Country";
        l_RulesEvalInsert: Record "Rules of Evaluations";
        l_StudyPlanHeader: Record "Study Plan Header";
    begin
        if Type = Type::Simple then begin
            if l_StudyPlanHeader.Get("Study Plan Code") then;
            l_RulesEvaluations.Reset;
            l_RulesEvaluations.SetRange("Schooling Year", l_StudyPlanHeader."Schooling Year");
            l_RulesEvaluations.SetRange("Characterise Subjects", l_RulesEvaluations."Characterise Subjects"::" ");
            l_RulesEvaluations.SetRange("Study Plan Code", '');
            l_RulesEvaluations.SetRange("Level Group", "Level Group");
            if l_RulesEvaluations.FindSet then begin
                repeat
                    l_RulesEvalInsert.Init;
                    l_RulesEvalInsert.TransferFields(l_RulesEvaluations);
                    l_RulesEvalInsert."Entry No." := GetLastNo;
                    l_RulesEvalInsert.Type := l_RulesEvalInsert.Type::Simple;
                    l_RulesEvalInsert."Study Plan Code" := "Study Plan Code";
                    l_RulesEvalInsert."School Year" := "School Year";
                    l_RulesEvalInsert.Insert;
                until l_RulesEvaluations.Next = 0;

            end;
        end;

        if Type = Type::Multi then begin
            if l_CourseHeader.Get("Study Plan Code") then;

            l_StructureEduCountry.Reset;
            l_StructureEduCountry.SetRange("Schooling Year", l_CourseHeader."Schooling Year Begin");
            if l_StructureEduCountry.FindFirst then;

            l_StructureEduCountry2.Reset;
            l_StructureEduCountry2.SetCurrentKey("Sorting ID");
            l_StructureEduCountry2.SetRange(Level, l_StructureEduCountry.Level);
            l_StructureEduCountry2.SetRange("Edu. Level", l_StructureEduCountry."Edu. Level");
            if l_StructureEduCountry2.Find('-') then begin
                repeat
                    l_RulesEvaluations.Reset;
                    l_RulesEvaluations.SetRange("Schooling Year", l_StructureEduCountry2."Schooling Year");
                    l_RulesEvaluations.SetRange("Characterise Subjects", l_RulesEvaluations."Characterise Subjects"::" ");
                    l_RulesEvaluations.SetRange("Study Plan Code", '');
                    l_RulesEvaluations.SetRange("Level Group", "Level Group");
                    if l_RulesEvaluations.FindSet then begin
                        repeat
                            l_RulesEvalInsert.Init;
                            l_RulesEvalInsert.TransferFields(l_RulesEvaluations);
                            l_RulesEvalInsert."Entry No." := GetLastNo;
                            l_RulesEvalInsert.Type := l_RulesEvalInsert.Type::Multi;
                            l_RulesEvalInsert."Study Plan Code" := "Study Plan Code";
                            l_RulesEvalInsert."School Year" := "School Year";
                            l_RulesEvalInsert.Insert;
                        until l_RulesEvaluations.Next = 0;

                    end;
                until l_StructureEduCountry2.Next = 0;

            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure DeleteRules()
    var
        l_RulesEvaluations: Record "Rules of Evaluations";
    begin
        l_RulesEvaluations.Reset;
        l_RulesEvaluations.SetRange(Type, Type);
        l_RulesEvaluations.SetRange("Study Plan Code", "Study Plan Code");
        l_RulesEvaluations.SetRange("School Year", "School Year");
        l_RulesEvaluations.DeleteAll;
    end;

    //[Scope('OnPrem')]
    procedure GetLastNo(): Integer
    var
        l_RulesEvaluations: Record "Rules of Evaluations";
    begin
        l_RulesEvaluations.Reset;
        if l_RulesEvaluations.FindLast then
            exit(l_RulesEvaluations."Entry No." + 1)
        else
            exit(1);
    end;
}

