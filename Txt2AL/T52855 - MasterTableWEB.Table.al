table 52855 MasterTableWEB
{
    Caption = 'MasterTableWEB';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
            Description = 'All';
        }
        field(2; "Table Type"; Option)
        {
            Caption = 'Table Type';
            Description = 'All';
            OptionCaption = ' ,Entity,Aspects,Rank Group,Classification Level,General Settings Assessing,Student,Moments,Observation,IncidenceType,Group Subjects,Class,TeacherClass,EntityStudent,Subjects,Turn,Annotations';
            OptionMembers = " ",Entity,Aspects,"Rank Group","Classification Level","General Settings Assessing",Student,Moments,Observation,IncidenceType,"Group Subjects",Class,TeacherClass,EntityStudent,Subjects,Turn,Annotations;
        }
        field(3; "Action Type"; Option)
        {
            Caption = 'Action Type';
            Description = 'All';
            OptionCaption = ' ,Insert,Update,Delete';
            OptionMembers = " ",Insert,Update,Delete;
        }
        field(4; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            Description = 'All';
        }
        field(5; "Posting Time"; Time)
        {
            Caption = 'Posting Time';
            Description = 'All';
        }
        field(6; Typew; Integer)
        {
            Caption = 'Type';
            Description = 'Student-Entity,TeacherClass';
        }
        field(7; Codew; Code[20])
        {
            Caption = 'Code';
            Description = 'Student-Entity-Assessment-GroupSubjects-Class,TeacherClass,Turn';
        }
        field(8; Description; Text[250])
        {
            Caption = 'Description';
            Description = 'Student-Entity-aspects-RankGroup-Moment-Observation-GroupSubjects-Class,TeacherClass,Turn';
        }
        field(9; UserID; Code[30])
        {
            Caption = 'User ID';
            Description = 'Student-Entity';
        }
        field(10; Password; Text[30])
        {
            Caption = 'Password';
            Description = 'Student-Entity';
        }
        field(11; Picture; BLOB)
        {
            Caption = 'Picture';
            Description = 'Student-Entity';
        }
        field(12; Company; Text[30])
        {
            Caption = 'Company';
            Description = 'All';
        }
        field(13; "School Year"; Code[9])
        {
            Caption = 'School Year';
            Description = 'All';
        }
        field(14; PercEvaluation; Decimal)
        {
            Caption = 'PercEvaluation';
            Description = 'Aspects';
        }
        field(15; EvaluationType; Integer)
        {
            Caption = 'EvaluationType';
            Description = 'Moment';
        }
        field(16; EvaluationTypeDescription; Text[250])
        {
            Caption = 'EvaluationTypeDescription';
            Description = 'Moment';
        }
        field(17; ClassificationGroupCode; Code[20])
        {
            Caption = 'ClassificationGroupCode';
            Description = 'Assessment';
        }
        field(18; ClassificationLevelCode; Code[20])
        {
            Caption = 'ClassificationLevelCode';
            Description = 'Assessment';
        }
        field(19; DescriptionLevel; Text[250])
        {
            Caption = 'DescriptionLevel';
            Description = 'Assessment';
        }
        field(20; MinValuew; Decimal)
        {
            Caption = 'MinValuew';
            Description = 'Assessment';
        }
        field(21; MaxValuew; Decimal)
        {
            Caption = 'MaxValuew';
            Description = 'Assessment';
        }
        field(22; Valuew; Decimal)
        {
            Caption = 'Valuew';
            Description = 'Assessment';
        }
        field(23; PrimaryKeyw; Code[10])
        {
            Caption = 'PrimaryKeyw';
            Description = 'Assessment';
        }
        field(24; AspectsMax; Integer)
        {
            Caption = 'AspectsMax';
            Description = 'OLD';
        }
        field(25; AssessingMax; Integer)
        {
            Caption = 'AssessingMax';
            Description = 'OLD';
        }
        field(26; RoundingAspects; Decimal)
        {
            Caption = 'RoundingAspects';
            Description = 'OLD';
        }
        field(27; RoundingPartial; Decimal)
        {
            Caption = 'RoundingPartial';
            Description = 'OLD';
        }
        field(28; StudentNo; Code[20])
        {
            Caption = 'StudentNo';
            Description = 'Student';
        }
        field(29; Name; Text[188])
        {
            Caption = 'Name';
            Description = 'Student-Entity';
        }
        field(30; male; Integer)
        {
            Caption = 'Male';
            Description = 'Student';
        }
        field(31; MomentCode; Code[10])
        {
            Caption = 'MomentCode';
            Description = 'Moment';
        }
        field(32; SchoolingYear; Code[10])
        {
            Caption = 'SchoolingYear';
            Description = 'All';
        }
        field(33; EvaluationMoment; Integer)
        {
            Caption = 'EvaluationMoment';
            Description = 'Moment';
        }
        field(34; Active; Boolean)
        {
            Caption = 'Active';
            Description = 'Moment';
        }
        field(35; LineNow; Integer)
        {
            Caption = 'LineNow';
            Description = 'Observations';
        }
        field(36; DescriptionMale; Text[250])
        {
            Caption = 'DescriptionMale';
            Description = 'Observations';
        }
        field(37; DescriptionFemale; Text[250])
        {
            Caption = 'DescriptionFemale';
            Description = 'Observations';
        }
        field(38; "Action Type 2"; Option)
        {
            Caption = 'Action Type 2';
            Description = 'All';
            OptionCaption = ' ,Insert,Update,Delete';
            OptionMembers = " ",Insert,Update,Delete;
        }
        field(42; IncidenceType; Option)
        {
            Caption = 'IncidenceType';
            Description = 'Incidence';
            OptionCaption = 'Default,Absence';
            OptionMembers = Default,Absence;
        }
        field(43; "Incidence Sub Type"; Code[20])
        {
            Caption = 'Incidence Sub Type';
            Description = 'Incidence';
        }
        field(44; "Incidence Code"; Code[20])
        {
            Caption = 'Incidence Code';
            Description = 'Incidence';
        }
        field(45; "Incidence Description"; Text[50])
        {
            Caption = 'Incidence Description';
            Description = 'Incidence';
        }
        field(46; "Incidence Sub Type Description"; Text[50])
        {
            Caption = 'Incidence Sub Type Description';
            Description = 'Incidence';
        }
        field(49; "Incidence Observations"; Code[20])
        {
            Caption = 'Incidence Observations';
            Description = 'Incidence';
            TableRelation = Observation.Code WHERE("Line Type" = CONST(Cab));
        }
        field(50; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            Description = 'All';
            TableRelation = "Responsibility Center";

            trigger OnValidate()
            var
                Text0001: Label 'To change the Responsibility center first delete the registration for the active year.';
            begin
            end;
        }
        field(51; Category; Option)
        {
            Caption = 'Category';
            Description = 'Incidence';
            OptionCaption = 'Class,Cantina,BUS,Schoolyard,Extra-scholar,Teacher';
            OptionMembers = Class,Cantine,BUS,Schoolyard,"Extra-scholar",Teacher;
        }
        field(52; Publish; Boolean)
        {
            Caption = 'Publish';
            Description = 'Moment';
        }
        field(53; "Sorting ID"; Integer)
        {
            Caption = 'Sorting ID';
            Description = 'Moment';
        }
        field(54; Language; Option)
        {
            Caption = 'Language';
            Description = 'Student-Entity';
            InitValue = Castilian;
            OptionCaption = ' ,Castilian,English,Euskara,Galego,Deutsch,Français,Italian,Portuguese,Catalan';
            OptionMembers = " ",Castilian,English,Euskara,Galego,Deutsch,"Français",Italian,Portuguese,Catalan;
        }
        field(55; "Interface Type WEB"; Option)
        {
            Caption = 'Interface Type WEB';
            Description = 'Class';
            OptionCaption = 'General,Infantil';
            OptionMembers = General,Infantil;
        }
        field(56; "Type Education"; Option)
        {
            Caption = 'Type Education';
            Description = 'Class';
            OptionCaption = 'Simple,Multi';
            OptionMembers = Simple,Multi;
        }
        field(57; StudyPlanCode; Code[20])
        {
            Caption = 'Study Plan Code';
            Description = 'Class';
            TableRelation = IF ("Type Education" = FILTER(Simple)) "Study Plan Header".Code WHERE("School Year" = FIELD("School Year"),
                                                                                                 "Schooling Year" = FIELD(SchoolingYear))
            ELSE IF ("Type Education" = FILTER(Multi)) "Course Header".Code;
        }
        field(58; Teacher; Code[20])
        {
            Caption = 'Teacher';
            Description = 'Class';
        }
        field(59; "Class Director"; Code[20])
        {
            Caption = 'Class Director';
            Description = 'Class';
        }
        field(60; Class; Code[20])
        {
            Caption = 'Class';
            Description = 'TeacherClass';
            TableRelation = Class.Class;
        }
        field(61; "Type Subject"; Option)
        {
            Caption = 'Subject Type';
            Description = 'TeacherClass';
            OptionCaption = ' ,Subject,Non scholar component,Non scholar hours';
            OptionMembers = " ",Subject,"Non lective Component","Non scholar hours";
        }
        field(62; "Subject Code"; Code[20])
        {
            Caption = 'Subject Code';
            Description = 'TeacherClass';
            TableRelation = IF ("Type Subject" = CONST(Subject)) Subjects.Code WHERE(Type = FILTER(Subject))
            ELSE IF ("Type Subject" = CONST("Non lective Component")) Subjects.Code WHERE(Type = FILTER("Non scholar component"))
            ELSE IF ("Type Subject" = CONST("Non scholar hours")) Subjects.Code WHERE(Type = FILTER("Non scholar hours"));

            trigger OnLookup()
            var
                rSubjects: Record Subjects;
                rStudyPlanLines: Record "Study Plan Lines";
                rCourseLines: Record "Course Lines";
                rCourseLinesTEMP: Record "Course Lines" temporary;
                rClass: Record Class;
                rStruEduCountry: Record "Structure Education Country";
                l_rStruEduCountry: Record "Structure Education Country";
                cStudentsRegistration: Codeunit "Students Registration";
            begin
            end;

            trigger OnValidate()
            var
                rStudyPlanLines: Record "Study Plan Lines";
                rCourseLines: Record "Course Lines";
            begin
            end;
        }
        field(63; "Subject Group"; Code[10])
        {
            Caption = 'Subject Group';
            Description = 'TeacherClass';
            TableRelation = "Subjects Group".Code WHERE(Type = FILTER(Subject));
        }
        field(64; "Subject Description"; Text[64])
        {
            Caption = 'Subject Description';
            Description = 'TeacherClass';
        }
        field(65; "Sub-Subject Code"; Code[20])
        {
            Caption = 'Sub-Subject Code';
            Description = 'TeacherClass';

            trigger OnLookup()
            var
                rStudyPlanSubLines: Record "Study Plan Sub-Subjects Lines";
                rStudyPlanHeader: Record "Study Plan Header";
                rCourseHeader: Record "Course Header";
            begin
            end;

            trigger OnValidate()
            var
                rStudyPlanSubLines: Record "Study Plan Sub-Subjects Lines";
                rStudyPlanHeader: Record "Study Plan Header";
                rCourseHeader: Record "Course Header";
            begin
            end;
        }
        field(66; "Sub-Subject Description"; Text[64])
        {
            Caption = 'Sub-Subject Description';
            Description = 'TeacherClass';
        }
        field(67; "Schooling Year"; Code[10])
        {
            Caption = 'Schooling Year';
            Description = 'TeacherClass';
            TableRelation = "Structure Education Country"."Schooling Year";
        }
        field(69; Turn; Code[20])
        {
            Caption = 'Turn';
            Description = 'TeacherClass';
            TableRelation = Turn.Code;
        }
        field(70; "Allow Assign Evaluations"; Boolean)
        {
            Caption = 'Assign Evaluations';
            Description = 'TeacherClass';
        }
        field(71; "Allow Calc. Final Assess."; Boolean)
        {
            Caption = 'Final Assess.';
            Description = 'TeacherClass';
        }
        field(72; "Allow Stu. Global Observations"; Boolean)
        {
            Caption = 'Student Global Observations';
            Description = 'TeacherClass';
        }
        field(73; "Allow Assign Incidence"; Boolean)
        {
            Caption = 'Assign Incidence';
            Description = 'TeacherClass';
        }
        field(74; "Allow Justify Incidence"; Boolean)
        {
            Caption = 'Justify Incidences';
            Description = 'TeacherClass';
        }
        field(75; "Allow Summary"; Boolean)
        {
            Caption = 'Summary';
            Description = 'TeacherClass';
        }
        field(76; HaveSubSubject; Boolean)
        {
            Description = 'Subjects';
        }
        field(77; "Justification Code"; Code[20])
        {
            Caption = 'Justification Code';
            Description = 'Incidence';
        }
        field(78; "Absence Status"; Option)
        {
            Caption = 'Absence Status';
            Description = 'Incidence';
            OptionCaption = 'Justified,Unjustified,Justification';
            OptionMembers = Justified,Unjustified,Justification;
        }
        field(79; "Annotation Group"; Code[20])
        {
            Caption = 'Annotation Group';
            Description = 'AnnotationsGroupClassConfig';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Table Type", MomentCode)
        {
        }
        key(Key3; "Sub-Subject Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        rMasterTableWEB: Record MasterTableWEB;
}

