table 31009856 "Assessing Students Final"
{
    Caption = 'Assessing Students Final';

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
        field(4;Subject;Code[20])
        {
            Caption = 'Subject';
            TableRelation = Subjects.Code;
        }
        field(5;"Study Plan Code";Code[20])
        {
            Caption = 'Study Plan Code';
            TableRelation = IF ("Type Education"=FILTER(Simple)) "Study Plan Header".Code WHERE ("School Year"=FIELD("School Year"),
                                                                                                 "Schooling Year"=FIELD("Schooling Year"))
                                                                                                 ELSE IF ("Type Education"=FILTER(Multi)) "Course Header".Code;
        }
        field(6;"Student Code No.";Code[20])
        {
            Caption = 'Student Code No.';
            TableRelation = Students."No.";
        }
        field(7;"Class No.";Integer)
        {
            Caption = 'Class No.';
        }
        field(8;"Evaluation Moment";Option)
        {
            Caption = 'Evaluation Moment';
            OptionCaption = ' ,Interim,Final Moment,Test,Others,Final Year,CIF,EXN1,EXN2,CFD';
            OptionMembers = " ",Interim,"Final Moment",Test,Others,"Final Year",CIF,EXN1,EXN2,CFD;
        }
        field(9;"Moment Code";Code[20])
        {
            Caption = 'Moment Code';
            TableRelation = "Moments Assessment"."Moment Code" WHERE ("School Year"=FIELD("School Year"),
                                                                      "Schooling Year"=FIELD("Schooling Year"));
        }
        field(11;Grade;Decimal)
        {
            Caption = 'Grade';
        }
        field(19;"Qualitative Grade";Text[50])
        {
            Caption = 'Qualitative Grade';
            CharAllowed = 'AZ';
        }
        field(20;"Type Education";Option)
        {
            Caption = 'Type Education';
            OptionCaption = 'Simple,Multi';
            OptionMembers = Simple,Multi;
        }
        field(21;"Option Group";Code[10])
        {
            Caption = 'Subject Group';
            TableRelation = "Group Subjects".Code;

            trigger OnLookup()
            var
                rGroupSubjects: Record "Group Subjects";
            begin
                rGroupSubjects.Reset;
                rGroupSubjects.SetFilter("Schooling Year",'%1|%2',"Schooling Year",'');
                rGroupSubjects.SetFilter("Country/Region Code",cStudentsRegistration.GetCountry);
                if rGroupSubjects.Find('-') then
                   if PAGE.RunModal(0,rGroupSubjects) = ACTION::LookupOK then
                      Validate("Option Group",rGroupSubjects.Code)
            end;
        }
        field(23;"Country/Region Code";Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(24;"Sub-Subject Code";Code[20])
        {
            Caption = 'Sub-Subject Code';

            trigger OnValidate()
            var
                recHorarioProfessorLinhas: Record "Teacher Timetable Lines";
            begin
            end;
        }
        field(27;"Evaluation Type";Option)
        {
            Caption = 'Evaluation Type';
            OptionCaption = 'Final Year,Final Year Group,Final Moment,Final Moment Group,Final Cycle,Final Stage';
            OptionMembers = "Final Year","Final Year Group","Final Moment","Final Moment Group","Final Cycle","Final Stage";
        }
        field(28;"Manual Grade";Decimal)
        {
            Caption = 'Manual Grade';
        }
        field(29;"Qualitative Manual Grade";Text[50])
        {
            Caption = 'Qualitative Manual Grade';
            CharAllowed = 'AZ';
        }
        field(30;"Rule Entry No.";Integer)
        {
            Caption = 'Rules of Evaluations Entry No.';
            Description = 'Rules of Evaluation Table -> Entry no.';
        }
    }

    keys
    {
        key(Key1;"Evaluation Type",Class,"School Year","Schooling Year",Subject,"Sub-Subject Code","Moment Code","Option Group","Study Plan Code","Student Code No.","Rule Entry No.")
        {
            Clustered = true;
        }
        key(Key2;"Student Code No.","School Year","Moment Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        cInsertNAVGeneralTable.DeleteFinalAssessment(Rec);
    end;

    trigger OnInsert()
    begin
        cInsertNAVGeneralTable.InsertUpdateFinalAssessment(Rec);
    end;

    trigger OnModify()
    begin
        cInsertNAVGeneralTable.InsertUpdateFinalAssessment(Rec);
    end;

    var
        cStudentsRegistration: Codeunit "Students Registration";
        cInsertNAVGeneralTable: Codeunit InsertNAVGeneralTable;
}

