table 31009853 GeneralTable
{
    Caption = 'General Table';
    Permissions = TableData GeneralTableAspects=rimd;

    fields
    {
        field(1;"Entry No.";Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
        }
        field(2;"Update Type";Option)
        {
            Caption = 'Update Type';
            OptionCaption = ' ,Insert,Update,Delete';
            OptionMembers = " ",Insert,Update,Delete;
        }
        field(3;Company;Code[30])
        {
            Caption = 'Company';
        }
        field(4;ID;Integer)
        {
            Caption = 'ID';
        }
        field(5;"School Year";Code[20])
        {
            Caption = 'School Year';
        }
        field(6;Student;Code[20])
        {
            Caption = 'Student';
        }
        field(7;Class;Code[20])
        {
            Caption = 'Class';
            TableRelation = Class.Class;
        }
        field(8;Subject;Code[20])
        {
            Caption = 'Subject';
        }
        field(9;"Sub Subject";Code[20])
        {
            Caption = 'Sub Subject';
        }
        field(10;Moment;Code[20])
        {
            Caption = 'Moment';
        }
        field(13;Teacher;Code[20])
        {
            Caption = 'Teacher';
        }
        field(14;"Education Header";Code[20])
        {
            Caption = 'Education Head';
        }
        field(15;"Class Director";Code[20])
        {
            Caption = 'Class Director';
        }
        field(16;"Observations Group";Code[20])
        {
            Caption = 'Observations Group';
        }
        field(17;"Assement Code";Code[20])
        {
            Caption = 'Assessment Code';
        }
        field(18;"Moment Ponder";Integer)
        {
            Caption = 'Moment Ponder';
            InitValue = 1;
            MaxValue = 999999999;
            MinValue = 1;
        }
        field(19;"Subject Ponder";Integer)
        {
            Caption = 'Subject Ponder';
        }
        field(20;"Sub Subject Ponder";Integer)
        {
            Caption = 'Sub Subject Ponder';
        }
        field(21;"Option Group";Code[10])
        {
            Caption = 'Option Group';
            TableRelation = "Group Subjects".Code;
        }
        field(22;"Subject Class";Text[250])
        {
            Caption = 'Subject Class';
        }
        field(26;"Is SubSubject";Boolean)
        {
            Caption = 'Is SubSubject';
        }
        field(27;"Qualitative Eval.";Code[20])
        {
            Caption = 'Qualitative Eval.';
        }
        field(28;EvaluationType;Option)
        {
            Caption = 'Evaluation Type';
            OptionCaption = ' ,Qualitative,Quantitative,None Qualification,Mixed-Qualification';
            OptionMembers = " ",Qualitative,Quantitative,"None Qualification","Mixed-Qualification";
        }
        field(29;"Update Type 2";Option)
        {
            Caption = 'Update Type 2';
            OptionCaption = ' ,Insert,Update,Delete';
            OptionMembers = " ",Insert,Update,Delete;
        }
        field(30;GradeAuto;Text[50])
        {
            Caption = 'GradeAuto';
        }
        field(31;GradeManual;Text[50])
        {
            Caption = 'GradeManual';
        }
        field(32;HasSubSubject;Boolean)
        {
            Caption = 'HasSubSubject';
        }
        field(33;ClassDescription;Text[30])
        {
            Caption = 'ClassDescription';
        }
        field(34;SubjectDescription;Text[64])
        {
            Caption = 'SubjectDescription';
        }
        field(35;SubSubjectDescription;Text[64])
        {
            Caption = 'SubSubjectDescription';
        }
        field(37;"Interface Type WEB";Option)
        {
            Caption = 'Interface Type WEB';
            OptionCaption = 'General,Infantil';
            OptionMembers = General,Infantil;
        }
        field(38;"Responsibility Center";Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";

            trigger OnValidate()
            var
                Text0001: Label 'To change the Responsibility center first delete the registration for the active year.';
            begin
            end;
        }
        field(39;SchoolingYear;Code[10])
        {
            Caption = 'Schooling Year';
        }
        field(40;"Subject Sorting ID";Integer)
        {
            Caption = 'Subject Sorting ID';
        }
        field(41;"Large Description SS";Text[250])
        {
            Caption = 'Large Description SS';
        }
        field(43;"Entry Type";Option)
        {
            Caption = 'Entry Type';
            OptionCaption = ' ,Final Moment,Final Moment Group,Final Year,Final Year Group';
            OptionMembers = " ","Final Moment","Final Moment Group","Final Year","Final Year Group";
        }
        field(44;"Type Education";Option)
        {
            Caption = 'Type Education';
            OptionCaption = 'Simple,Multi';
            OptionMembers = Simple,Multi;
        }
        field(45;"Has Individual Plan";Boolean)
        {
            Caption = 'Has Individual Plan';
        }
        field(46;"Scholarship Reinforcement";Boolean)
        {
            Caption = 'Scholarship Reinforcement';
        }
        field(47;"Scholarship Support";Boolean)
        {
            Caption = 'Scholarship Support';
        }
        field(48;StudyPlanCode;Code[20])
        {
            Caption = 'Study Plan Code';
            TableRelation = IF ("Type Education"=FILTER(Simple)) "Study Plan Header".Code WHERE ("School Year"=FIELD("School Year"),
                                                                                                 "Schooling Year"=FIELD(SchoolingYear))
                                                                                                 ELSE IF ("Type Education"=FILTER(Multi)) "Course Header".Code;
        }
        field(49;"Original Line No.";Integer)
        {
            Caption = 'Original Line No.';
        }
        field(50;Turn;Code[20])
        {
            Caption = 'Turn';
            TableRelation = Turn.Code;
        }
        field(51;"Recuperation Grade";Decimal)
        {
            Caption = 'Recuperation Grade';
        }
        field(52;"Recuperation Qualitative Grade";Text[50])
        {
            Caption = 'Recuperation Qualitative Grade';
            CharAllowed = 'AZ';
        }
    }

    keys
    {
        key(Key1;"Entry No.")
        {
            Clustered = true;
        }
        key(Key2;"School Year",Student,Class,Subject,"Sub Subject","Is SubSubject")
        {
        }
        key(Key3;"School Year",Class,Moment)
        {
        }
        key(Key4;"School Year",Subject,Class,Moment,Company,"Responsibility Center")
        {
        }
        key(Key5;Company,Subject,"Sub Subject",Student,Moment,"Responsibility Center","Entry Type")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        //rGeneralTable.RESET;
        //IF rGeneralTable.FIND('+') THEN
        //  "Entry No." := rGeneralTable."Entry No." + 1
        //ELSE
        //  "Entry No." := 1;
    end;

    trigger OnModify()
    var
        lGeneralTableAspects: Record GeneralTableAspects;
    begin
        if "Update Type" = "Update Type"::Delete then begin
          lGeneralTableAspects.Reset;
          lGeneralTableAspects.SetRange("Study Plan Entry No.","Entry No.");
          lGeneralTableAspects.ModifyAll("Update Type","Update Type");
        end;

        if "Update Type 2" = "Update Type 2"::Delete then begin
          lGeneralTableAspects.Reset;
          lGeneralTableAspects.SetRange("Study Plan Entry No.","Entry No.");
          lGeneralTableAspects.ModifyAll("Update Type 2","Update Type 2");
        end;
    end;

    var
        rGeneralTable: Record GeneralTable;
}

