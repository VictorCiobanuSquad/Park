table 52762 Registration
{
    Caption = 'Registration';
    DrillDownPageID = "Students Entry";
    LookupPageID = "Students Entry";
    fields
    {
        field(1;
        "School Year";
        Code[9])
        {
            Caption = 'School Year';
            TableRelation = "School Year"."School Year";
        }
        field(2; "Student Code No."; Code[20])
        {
            Caption = 'Student Code No.';
            TableRelation = Students."No.";

            trigger OnValidate()
            begin
                if rStudents.Get("Student Code No.") then
                    Name := rStudents.Name;
            end;
        }
        field(3; "Schooling Year"; Code[10])
        {
            Caption = 'Schooling Year';
            TableRelation = "Structure Education Country"."Schooling Year";

            trigger OnValidate()
            begin
                if rCompanyInformation.Get then;

                rStruEduCountry.Reset;
                rStruEduCountry.SetRange(Country, rCompanyInformation."Country/Region Code");
                rStruEduCountry.SetRange("Schooling Year", "Schooling Year");
                if rStruEduCountry.FindFirst then begin
                    Level := rStruEduCountry.Level;
                    Type := rStruEduCountry.Type;
                end else begin
                    Level := 0;
                    Type := 0;
                end;

                if ("Schooling Year" <> xRec."Schooling Year") and (xRec."Schooling Year" <> '') then begin
                    if Confirm(Text0001, true) then begin
                        Validate("Study Plan Code", '');
                        Validate("Services Plan Code", '');
                        Validate(Course, '')
                    end else begin
                        "Schooling Year" := xRec."Schooling Year";
                        exit;
                    end;
                end;

                if rSchool.Get then begin
                    if "Schooling Year" = rSchool."ENEB Exam Schooling Year" then
                        "ENEB Student Type" := rSchool."ENEB Student Type";
                end;
            end;
        }
        field(4; Level; Option)
        {
            Caption = 'Level';
            OptionCaption = 'Pre school,1º Cycle,2º Cycle,3º Cycle,Secondary';
            OptionMembers = "Pre school","1º Cycle","2º Cycle","3º Cycle",Secondary;
        }
        field(5; "Public/Private"; Option)
        {
            Caption = 'Public/Private';
            OptionCaption = ' ,Public,Private';
            OptionMembers = " ","Público",Privado;
        }
        field(6; "School 1"; Text[128])
        {
            Caption = 'School 1';
        }
        field(7; "School 2"; Text[128])
        {
            Caption = 'School 2';
        }
        field(8; "School 3"; Text[128])
        {
            Caption = 'School 3';
        }
        field(9; "School 4"; Text[128])
        {
            Caption = 'School 4';
        }
        field(10; "Pre-primary Education"; Boolean)
        {
            Caption = 'Pre-primary Education';
        }
        field(11; "Pre School"; Text[128])
        {
            Caption = 'Pre School';
        }
        field(12; "Pre Grouping"; Text[128])
        {
            Caption = 'Pre Grouping';
        }
        field(13; "Preschool Years"; Integer)
        {
            Caption = 'Preschool Years';
        }
        field(14; "Moral Education"; Boolean)
        {
            Caption = 'Moral Education';
        }
        field(15; "Moral Education Desc."; Text[30])
        {
            Caption = 'Moral Education Desc.';
        }
        field(16; Residence; Boolean)
        {
            Caption = 'Residence';
        }
        field(17; "Contains Residence"; Boolean)
        {
            Caption = 'Residence renewal';
        }
        field(18; Benefits; Boolean)
        {
            Caption = 'Benefits';
        }
        field(19; "Contains Benefits"; Boolean)
        {
            Caption = 'Benefits renewal';
        }
        field(20; Transportation; Boolean)
        {
            Caption = 'Transportation';
        }
        field(21; "Transportation Local"; Text[30])
        {
            Caption = 'Transportation Local';
        }
        field(22; "Compulsory Edu. Amendment Req."; Option)
        {
            Caption = 'Compulsory Education Amendment Request';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,No,Yes Anticipation,Yes Advance';
            OptionMembers = " ","Não","Sim Antecipação","Sim Adiantamento";
        }
        field(23; "Need Special Education"; Boolean)
        {
            Caption = 'Need Special Education';
        }
        field(24; "Need Special Education Desc."; Text[30])
        {
            Caption = 'Need Special Education Desc.';
        }
        field(25; "Evidence Documents"; Boolean)
        {
            Caption = 'Evidence Documents';
        }
        field(26; "Evidence Description"; Text[30])
        {
            Caption = 'Evidence Description';
        }
        field(27; "Study Plan Code"; Code[20])
        {
            Caption = 'Study Plan Code';
            TableRelation = "Study Plan Header".Code WHERE("School Year" = FIELD("School Year"),
                                                            "Schooling Year" = FIELD("Schooling Year"),
                                                            "Responsibility Center" = FIELD("Responsibility Center"));

            trigger OnValidate()
            var
                l_SPSubSubsLines: Record "Study Plan Sub-Subjects Lines";
                l_StudentSubSubPlan: Record "Student Sub-Subjects Plan ";
            begin

                TestField("School Year");

                if "Study Plan Code" <> xRec."Study Plan Code" then begin
                    DeleteStudentStudyPlan;
                    DeleteSubSubjects;
                end;


                rStudyPlanLines.Reset;
                rStudyPlanLines.SetRange(Code, "Study Plan Code");
                rStudyPlanLines.SetRange("School Year", "School Year");
                rStudyPlanLines.SetRange("Schooling Year", "Schooling Year");
                if rStudyPlanLines.Find('-') then begin
                    ValidateStudentStudyPlan;
                    repeat
                        rStudentStudyPlan.Init;
                        rStudentStudyPlan."Student Code No." := "Student Code No.";
                        rStudentStudyPlan."School Year" := "School Year";
                        rStudentStudyPlan."Line No." := varLineNo;
                        rStudentStudyPlan."Schooling Year" := "Schooling Year";
                        rStudentStudyPlan."Study Plan Code" := "Study Plan Code";
                        rStudentStudyPlan.Validate("Subjects Code", rStudyPlanLines."Subject Code");
                        rStudentStudyPlan.Description := rStudyPlanLines."Subject Description";
                        if rStudyPlanLines."Mandatory/Optional Type" = rStudyPlanLines."Mandatory/Optional Type"::Required then
                            rStudentStudyPlan.Validate(Enroled, true);
                        rStudentStudyPlan."Mandatory/Optional Type" := rStudyPlanLines."Mandatory/Optional Type";
                        rStudentStudyPlan."Curriculum Type" := rStudyPlanLines."Curriculum Type";
                        rStudentStudyPlan."Option Group" := rStudyPlanLines."Option Group";
                        rStudentStudyPlan."Evaluation Type" := rStudyPlanLines."Evaluation Type";
                        rStudentStudyPlan."Responsibility Center" := rStudyPlanLines."Responsibility Center";
                        rStudentStudyPlan."Evaluation Type" := rStudyPlanLines."Evaluation Type";
                        rStudentStudyPlan."Assessment Code" := rStudyPlanLines."Assessment Code";
                        rStudentStudyPlan."Minimum Classification Level" := rStudyPlanLines."Minimum Classification Level";
                        rStudentStudyPlan."Country/Region Code" := rStudyPlanLines."Country/Region Code";
                        rStudentStudyPlan.Type := Type;
                        rStudentStudyPlan."User Id" := UserId;
                        rStudentStudyPlan.Date := WorkDate;
                        rStudentStudyPlan."Sorting ID" := rStudyPlanLines."Sorting ID";
                        rStudentStudyPlan."Sub-subjects for assess. only" := rStudyPlanLines."Sub-subjects for assess. only";
                        rStudentStudyPlan."Legal Code" := rStudyPlanLines."Legal Code";
                        rStudentStudyPlan."Continuous Assessment" := rStudyPlanLines."Continuous Assessment";
                        //Normática 2013.04.09
                        rStudentStudyPlan."Subject Excluded From Assess." := rStudyPlanLines."Subject Excluded From Assess.";
                        rStudentStudyPlan.Insert;
                        varLineNo += 10000;
                        if rStudyPlanLines.CalcFields("Sub-Subject") then begin
                            l_SPSubSubsLines.Reset;
                            l_SPSubSubsLines.SetRange(Type, l_SPSubSubsLines.Type::"Study Plan");
                            l_SPSubSubsLines.SetRange(Code, "Study Plan Code");
                            l_SPSubSubsLines.SetRange("Subject Code", rStudyPlanLines."Subject Code");
                            l_SPSubSubsLines.SetRange("Schooling Year", "Schooling Year");
                            l_SPSubSubsLines.SetRange("School Year", "School Year");
                            if l_SPSubSubsLines.Find('-') then begin
                                repeat
                                    l_StudentSubSubPlan.Init;
                                    l_StudentSubSubPlan."Student Code No." := "Student Code No.";
                                    l_StudentSubSubPlan."School Year" := "School Year";
                                    l_StudentSubSubPlan."Schooling Year" := "Schooling Year";
                                    l_StudentSubSubPlan."Subject Code" := rStudyPlanLines."Subject Code";
                                    l_StudentSubSubPlan."Subject Description" := rStudyPlanLines."Subject Description";
                                    l_StudentSubSubPlan."Sub-Subject Code" := l_SPSubSubsLines."Sub-Subject Code";
                                    l_StudentSubSubPlan."Sub-Subject Description" := l_SPSubSubsLines."Sub-Subject Description";
                                    l_StudentSubSubPlan.Code := l_SPSubSubsLines.Code;
                                    l_StudentSubSubPlan."Mandatory/Optional Type" := l_SPSubSubsLines."Mandatory/Optional Type";
                                    l_StudentSubSubPlan."Curriculum Type" := l_SPSubSubsLines."Curriculum Type";
                                    l_StudentSubSubPlan."Evaluation Type" := l_SPSubSubsLines."Evaluation Type";
                                    l_StudentSubSubPlan."Country/Region Code" := "Country/Region Code";
                                    l_StudentSubSubPlan."Responsibility Center" := l_SPSubSubsLines."Responsibility Center";
                                    l_StudentSubSubPlan."Maximum Injustified Absence" := l_SPSubSubsLines."Maximum Injustified Absence";
                                    l_StudentSubSubPlan."Assessment Code" := l_SPSubSubsLines."Assessment Code";
                                    l_StudentSubSubPlan."Minimum Classification Level" := l_SPSubSubsLines."Minimum Classification Level";
                                    l_StudentSubSubPlan."Characterise Subjects" := l_SPSubSubsLines."Characterise Subjects";
                                    l_StudentSubSubPlan."Maximum Total Absence" := l_SPSubSubsLines."Maximum Total Absence";
                                    l_StudentSubSubPlan.Type := l_StudentSubSubPlan.Type::Simple;
                                    l_StudentSubSubPlan."Line No." := rStudentStudyPlan."Line No.";
                                    l_StudentSubSubPlan."User Id" := UserId;
                                    l_StudentSubSubPlan.Date := WorkDate;
                                    l_StudentSubSubPlan."Sorting ID" := l_SPSubSubsLines."Sorting ID";

                                    l_StudentSubSubPlan.Insert;
                                until l_SPSubSubsLines.Next = 0;
                            end;
                        end;

                    until rStudyPlanLines.Next = 0;
                end;

                //Services
                rServicesPlanHead.Reset;
                rServicesPlanHead.SetRange("School Year", "School Year");
                rServicesPlanHead.SetRange("Schooling Year", "Schooling Year");
                rServicesPlanHead.SetRange("Study Plan Code", "Study Plan Code");
                if rServicesPlanHead.FindFirst then begin
                    Validate("Services Plan Code", rServicesPlanHead.Code);
                end;
                if "Study Plan Code" = '' then
                    Validate("Services Plan Code", '');
            end;
        }
        field(28; "Services Plan Code"; Code[20])
        {
            Caption = 'Services Plan Code';
            TableRelation = "Services Plan Head".Code WHERE("School Year" = FIELD("School Year"),
                                                             "Schooling Year" = FIELD("Schooling Year"));

            trigger OnValidate()
            begin
                rStudentServicePlan.Reset;
                rStudentServicePlan.SetRange("Student No.", "Student Code No.");
                rStudentServicePlan.SetRange("School Year", "School Year");
                rStudentServicePlan.SetRange("Schooling Year", "Schooling Year");
                rStudentServicePlan.SetFilter("Services Plan Code", '<>%1', '');
                if rStudentServicePlan.Find('-') then
                    rStudentServicePlan.DeleteAll;



                rServicesPlanLine.Reset;
                rServicesPlanLine.SetRange(Code, "Services Plan Code");
                rServicesPlanLine.SetRange("School Year", "School Year");
                rServicesPlanLine.SetRange("Schooling Year", "Schooling Year");
                if rServicesPlanLine.Find('-') then begin
                    varLineNo := 10000;
                    repeat
                        rStudentServicePlan.Init;
                        rStudentServicePlan."Student No." := "Student Code No.";
                        rStudentServicePlan."School Year" := "School Year";
                        rStudentServicePlan."Schooling Year" := "Schooling Year";
                        rStudentServicePlan."Service Code" := rServicesPlanLine."Service Code";
                        if rServicesPlanLine."Service Type" = rServicesPlanLine."Service Type"::Required then
                            rStudentServicePlan.Selected := true;
                        rStudentServicePlan."Service Type" := rServicesPlanLine."Service Type";
                        rStudentServicePlan.Description := rServicesPlanLine.Description;
                        rStudentServicePlan."Description 2" := rServicesPlanLine."Description 2";
                        rStudentServicePlan.Quantity := 1;
                        rStudentServicePlan.January := rServicesPlanLine.January;
                        rStudentServicePlan.February := rServicesPlanLine.February;
                        rStudentServicePlan.March := rServicesPlanLine.March;
                        rStudentServicePlan.April := rServicesPlanLine.April;
                        rStudentServicePlan.May := rServicesPlanLine.May;
                        rStudentServicePlan.June := rServicesPlanLine.June;
                        rStudentServicePlan.July := rServicesPlanLine.July;
                        rStudentServicePlan.August := rServicesPlanLine.August;
                        rStudentServicePlan.Setember := rServicesPlanLine.Setember;
                        rStudentServicePlan.October := rServicesPlanLine.October;
                        rStudentServicePlan.November := rServicesPlanLine.November;
                        rStudentServicePlan.Dezember := rServicesPlanLine.Dezember;
                        rStudentServicePlan."Line No." := varLineNo;
                        rStudentServicePlan."Services Plan Code" := "Services Plan Code";
                        rStudentServicePlan."Country/Region Code" := cStudentsRegistration.GetCountry;
                        rStudentServicePlan."Responsibility Center" := rServicesPlanLine."Responsibility Center";
                        rStudentStudyPlan."User Id" := UserId;
                        rStudentStudyPlan.Date := Date;
                        rStudentServicePlan.Insert;

                        varLineNo += 10000;
                    until rServicesPlanLine.Next = 0;
                end;


                rStudentStudyPlan.Reset;
                rStudentStudyPlan.SetRange("Student Code No.", "Student Code No.");
                rStudentStudyPlan.SetRange("School Year", "School Year");
                rStudentStudyPlan.SetRange("Responsibility Center", "Responsibility Center");
                rStudentStudyPlan.SetRange(Enroled, true);
                if rStudentStudyPlan.Find('-') then begin
                    repeat
                        if rStudentStudyPlan.Enroled then
                            rStudentStudyPlan.ValidateServicePlan(rStudentStudyPlan)
                        else
                            rStudentStudyPlan.DeleteServicePlan(rStudentStudyPlan);
                    until rStudentStudyPlan.Next = 0;
                end;



                rUsersFamilyStudents.Reset;
                rUsersFamilyStudents.SetRange("School Year", "School Year");
                rUsersFamilyStudents.SetRange("Student Code No.", "Student Code No.");
                rUsersFamilyStudents.SetRange("Paying Entity", true);
                if rUsersFamilyStudents.Find('-') then
                    cStudentServices.DistributionByEntity(rUsersFamilyStudents);
            end;
        }
        field(29; "Registration Date"; Date)
        {
            Caption = 'Registration Date';
        }
        field(30; "Special Education Benefit"; Boolean)
        {
            Caption = 'Special Education Benefit';
        }
        field(31; "Spe. Education Benefit Desc."; Boolean)
        {
            Caption = 'Spe. Education Benefit Desc.';
        }
        field(32; Class; Code[20])
        {
            Caption = 'Class';
            TableRelation = Class.Class;
        }
        field(33; "Class No."; Integer)
        {
            Caption = 'Class No.';
        }
        field(34; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = ' ,Subscribed,Transfer,Annulled';
            OptionMembers = " ",Subscribed,Transfer,Cancelled;

            trigger OnValidate()
            begin
                if (xRec.Status <> Rec.Status) and (Rec.Status = Rec.Status::Transfer) then
                    "Actual Status" := "Actual Status"::Transfered;
            end;
        }
        field(35; Selection; Boolean)
        {
            Caption = 'Selection';

            trigger OnValidate()
            begin
                "User Session" := UpperCase(UserId);
            end;
        }
        field(36; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(39; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Simple,Multi';
            OptionMembers = Simple,Multi;
        }
        field(40; Course; Code[20])
        {
            Caption = 'Course';
            TableRelation = "Course Header".Code WHERE("Responsibility Center" = FIELD("Responsibility Center"));

            trigger OnValidate()
            var
                l_rStruEduCountry: Record "Structure Education Country";
                rCourseHeader: Record "Course Header";
                l_SchoolYear: Record "School Year";
                l_SchoolYear2: Record "School Year";
            begin
                //Validate school Year
                if rCourseHeader.Get(Course) then begin
                    l_SchoolYear.Reset;
                    l_SchoolYear.SetRange("School Year", "School Year");
                    if l_SchoolYear.FindFirst then;

                    l_SchoolYear2.Reset;
                    l_SchoolYear2.SetRange("School Year", rCourseHeader."School Year Begin");
                    if l_SchoolYear2.FindFirst then;

                    if (l_SchoolYear.Status = l_SchoolYear.Status::Active) and
                           (l_SchoolYear2.Status = l_SchoolYear2.Status::Planning) then
                        Error(Text0005, l_SchoolYear2."School Year")
                end;



                //check  "Assessment Code"
                ValidateAssementCourse;

                rStudentStudyPlan.Reset;
                rStudentStudyPlan.SetRange("Student Code No.", "Student Code No.");
                rStudentStudyPlan.SetRange("School Year", "School Year");
                //rStudentStudyPlan.SETRANGE("Schooling Year","Schooling Year");
                //rStudentStudyPlan.SETRANGE("Services Plan Code","Services Plan Code");
                if rStudentStudyPlan.FindSet then begin
                    rStudentStudyPlan.DeleteAll;
                    DeleteSubSubjects;
                end;


                // Quadriennal
                varLineNo := 10000;
                rCourseLines.Reset;
                rCourseLines.SetRange(Code, Course);
                //rCourseLines.SETRANGE("Characterise Subjects",rCourseLines."Characterise Subjects"::Triennial);
                rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Quadriennal);
                if rCourseLines.Find('-') then begin
                    repeat
                        InsertSubjects(rCourseLines);
                        varLineNo += 10000;
                    until rCourseLines.Next = 0;
                end;

                //Annual
                rCourseLines.Reset;
                rCourseLines.SetRange(Code, Course);
                rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Annual);
                rCourseLines.SetRange("Schooling Year Begin", "Schooling Year");
                if rCourseLines.Find('-') then begin
                    repeat
                        InsertSubjects(rCourseLines);
                        varLineNo += 10000;
                    until rCourseLines.Next = 0;
                end;


                //Biennial

                rStruEduCountry.Reset;
                rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
                //rStruEduCountry.SETRANGE(Level,rStruEduCountry.Level::Secondary);
                rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
                rStruEduCountry.SetRange("Schooling Year", "Schooling Year");
                if rStruEduCountry.Find('-') then begin
                    rCourseLines.Reset;
                    rCourseLines.SetRange(Code, Course);
                    rCourseLines.SetFilter("Characterise Subjects", '%1|%2', rCourseLines."Characterise Subjects"::Biennial,
                                            rCourseLines."Characterise Subjects"::Triennial);
                    rCourseLines.SetRange("Schooling Year Begin", "Schooling Year");
                    if rCourseLines.Find('-') then begin
                        repeat
                            InsertSubjects(rCourseLines);
                            varLineNo += 10000;
                        until rCourseLines.Next = 0;
                    end;
                    //      ELSE BEGIN
                    l_rStruEduCountry.Reset;
                    l_rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
                    //l_rStruEduCountry.SETRANGE(Level,rStruEduCountry.Level::Secondary);
                    l_rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
                    l_rStruEduCountry.SetRange("Sorting ID", GetNoStructureCountry - 1);
                    if l_rStruEduCountry.Find('-') then begin
                        rCourseLines.Reset;
                        rCourseLines.SetRange(Code, Course);
                        rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Biennial);
                        rCourseLines.SetRange("Schooling Year Begin", l_rStruEduCountry."Schooling Year");
                        if rCourseLines.Find('-') then begin
                            repeat
                                InsertSubjects(rCourseLines);
                                varLineNo += 10000;
                            until rCourseLines.Next = 0;
                        end;
                    end;
                    l_rStruEduCountry.Reset;
                    l_rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
                    l_rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
                    l_rStruEduCountry.SetRange("Sorting ID", GetNoStructureCountry - 2);
                    if l_rStruEduCountry.Find('-') then begin
                        rCourseLines.Reset;
                        rCourseLines.SetRange(Code, Course);
                        rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Triennial);
                        rCourseLines.SetRange("Schooling Year Begin", l_rStruEduCountry."Schooling Year");
                        if rCourseLines.Find('-') then begin
                            repeat
                                InsertSubjects(rCourseLines);
                                varLineNo += 10000;
                            until rCourseLines.Next = 0;
                        end;
                    end;
                    l_rStruEduCountry.Reset;
                    l_rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
                    l_rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
                    l_rStruEduCountry.SetRange("Sorting ID", GetNoStructureCountry - 1);
                    if l_rStruEduCountry.Find('-') then begin
                        rCourseLines.Reset;
                        rCourseLines.SetRange(Code, Course);
                        rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Triennial);
                        rCourseLines.SetRange("Schooling Year Begin", l_rStruEduCountry."Schooling Year");
                        if rCourseLines.Find('-') then begin
                            repeat
                                InsertSubjects(rCourseLines);
                                varLineNo += 10000;
                            until rCourseLines.Next = 0;
                        end;
                    end;

                    //END;
                end;

                //InsertSettingRattingsCourse;

                //Services
                rServicesPlanHead.Reset;
                rServicesPlanHead.SetRange("School Year", "School Year");
                rServicesPlanHead.SetRange("Schooling Year", "Schooling Year");
                rServicesPlanHead.SetRange("Study Plan Code", Course);
                if rServicesPlanHead.FindFirst then begin
                    Validate("Services Plan Code", rServicesPlanHead.Code);
                end;
            end;
        }
        field(41; "Actual Status"; Option)
        {
            Caption = 'Actual Status';
            Editable = false;
            OptionCaption = ' ,Registered,Transited,Not Transited,Concluded,Not Concluded,Abandonned,Registration Annulled,Transfered,Exclusion by Incidences,Ongoing evaluation,Retained from Absences,School Certificate,Legal Transition';
            OptionMembers = " ",Registered,Transited,"Not Transited",Concluded,"Not Concluded",Abandonned,"Registration Annulled",Transfered,"Exclusion by Incidences","Ongoing evaluation","Retained from Absences","School Certificate","Legal Transition";

            trigger OnValidate()
            var
                rCommentLine: Record "Comment Line";
                NumLinha: Integer;
            begin
                //MISI - tenho de guardar o actual Status, sempre que este muda
                if "Actual Status" <> xRec."Actual Status" then begin
                    rCommentLine.Reset;
                    rCommentLine.SetRange(rCommentLine."Table Name", rCommentLine."Table Name"::"Actual Status");
                    rCommentLine.SetRange(rCommentLine."No.", "Student Code No.");
                    if rCommentLine.FindLast then
                        NumLinha := rCommentLine."Line No.";

                    rCommentLine.Init;
                    rCommentLine."Table Name" := rCommentLine."Table Name"::"Actual Status";
                    rCommentLine."No." := "Student Code No.";
                    rCommentLine."Line No." := NumLinha + 10000;
                    rCommentLine.Date := WorkDate;
                    rCommentLine."Actual Status" := "Actual Status";
                    rCommentLine."School Year" := "School Year";
                    rCommentLine.Insert;
                end;
            end;
        }
        field(42; "Average Evaluation"; Decimal)
        {
            BlankZero = true;
            Caption = 'Average Evaluation';
        }
        field(49; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";

            trigger OnValidate()
            var
                RespCenter: Record "Responsibility Center";
            begin
                if not cUserEducation.CheckRespCenterEducation("Responsibility Center") then
                    Error(
                      Text0004,
                      RespCenter.TableCaption, cUserEducation.GetEducationFilter(UserId));
            end;
        }
        field(50; "School Name Transfer"; Text[128])
        {
            Caption = 'School Name Transfer';
        }
        field(51; "Class Letter"; Code[2])
        {
            Caption = 'Class Letter';
        }
        field(52; "Next School Year"; Option)
        {
            Caption = 'Next School Year';
            OptionCaption = 'In School,Not in School,Processed';
            OptionMembers = "In School","Not in School",Processed;

            trigger OnValidate()
            begin
                if "Next School Year" = "Next School Year"::Processed then
                    Error(Text0009);

                if (xRec."Next School Year" = xRec."Next School Year"::Processed) and
                  ("Next School Year" = "Next School Year"::"In School") or
                  ("Next School Year" = "Next School Year"::"Not in School") then begin
                    ValidateNextSchoolYear;


                end;
            end;
        }
        field(53; "New Class Letter"; Code[2])
        {
            Caption = 'New Class Letter';
        }
        field(54; "Last Year Code"; Code[10])
        {
            Caption = 'Last Year Code';
            TableRelation = "Table MISI".Code WHERE(Type = FILTER(CodCurso));
        }
        field(55; Name; Text[128])
        {
            Caption = 'Name';
        }
        field(90; "User Session"; Code[20])
        {
            Caption = 'User Session';
            TableRelation = User;
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(1000; "User Id"; Code[20])
        {
            Caption = 'User Id';
            TableRelation = User;
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnLookup()
            var
                LoginMgt: Codeunit "User Management";
            begin
                LoginMgt.DisplayUserInformation("User Id");
            end;
        }
        field(1001; Date; Date)
        {
            Caption = 'Date';
        }
        field(75000; Destination; Option)
        {
            Caption = 'Destination';
            Description = 'MISI';
            OptionCaption = ' ,Public School,Private School,Foreign';
            OptionMembers = " ","Public School","Private School",Foreign;
        }
        field(75600; "ENEB Student Type"; Code[10])
        {
            Caption = 'ENEB Student Type';
            Description = 'ENEB';
            TableRelation = "Legal Codes"."Parish/Council/District Code" WHERE(Type = CONST(StudentType),
                                                                                "Legal Code Type" = CONST(Simple));
        }
    }

    keys
    {
        key(Key1; "Student Code No.", "School Year", "Responsibility Center")
        {
            Clustered = true;
        }
        key(Key2; "School Year", "Schooling Year", Course)
        {
        }
        key(Key3; Class, "Class No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        rRegistrationClass.Reset;
        rRegistrationClass.SetRange("Student Code No.", "Student Code No.");
        rRegistrationClass.SetRange("School Year", "School Year");
        rRegistrationClass.SetRange("Responsibility Center", "Responsibility Center");
        if rRegistrationClass.FindSet then
            Error(Text0011);


        rStudentStudyPlan.Reset;
        rStudentStudyPlan.SetRange("Student Code No.", "Student Code No.");
        rStudentStudyPlan.SetRange("School Year", "School Year");
        rStudentStudyPlan.SetRange("Responsibility Center", "Responsibility Center");
        if rStudentStudyPlan.Find('-') then
            repeat
                if rStudentStudyPlan.Status <> rStudentStudyPlan.Status::" " then
                    Error(Text0006);

                if rStudentStudyPlan.CalcFields("Sub-subject") then begin
                    rStudentSusubjPlan.Reset;
                    rStudentSusubjPlan.SetRange("Student Code No.", "Student Code No.");
                    rStudentSusubjPlan.SetRange("School Year", "School Year");
                    rStudentSusubjPlan.SetRange("Subject Code", rStudentStudyPlan."Subjects Code");
                    rStudentSusubjPlan.SetRange("Responsibility Center", "Responsibility Center");
                    rStudentSusubjPlan.DeleteAll;
                end;

                rStudentStudyPlan.Delete;

            until rStudentStudyPlan.Next = 0;


        rStudentServicePlan.Reset;
        rStudentServicePlan.SetRange("Student No.", "Student Code No.");
        rStudentServicePlan.SetRange("School Year", "School Year");
        rStudentServicePlan.SetRange("Responsibility Center", "Responsibility Center");
        rStudentServicePlan.DeleteAll;

        rStudentsNLHours.Reset;
        rStudentsNLHours.SetRange("Student Code No.", "Student Code No.");
        rStudentsNLHours.SetRange("School Year", "School Year");
        rStudentsNLHours.SetRange("Responsibility Center", "Responsibility Center");
        rStudentsNLHours.DeleteAll;
    end;

    trigger OnInsert()
    begin
        "User Id" := UserId;
        Date := Today;
        "Country/Region Code" := cStudentsRegistration.GetCountry;
        "Responsibility Center" := cStudentsRegistration.GetRespCenter(Rec);
        "Registration Date" := WorkDate;

        GetUserFamilyActiveYear;

        if rStudents.Get("Student Code No.") then
            Name := rStudents.Name;
    end;

    trigger OnModify()
    begin
        "User Id" := UserId;
        Date := Today;
    end;

    trigger OnRename()
    begin
        if xRec."Responsibility Center" <> "Responsibility Center" then begin
            rStudentStudyPlan.Reset;
            rStudentStudyPlan.SetRange("Student Code No.", "Student Code No.");
            rStudentStudyPlan.SetRange("School Year", "School Year");
            rStudentStudyPlan.ModifyAll("Responsibility Center", "Responsibility Center");
        end;
        if xRec."Responsibility Center" <> "Responsibility Center" then begin
            rStudentSusubjPlan.Reset;
            rStudentSusubjPlan.SetRange("Student Code No.", "Student Code No.");
            rStudentSusubjPlan.SetRange("School Year", "School Year");
            rStudentSusubjPlan.ModifyAll("Responsibility Center", "Responsibility Center");
        end;
    end;

    var
        rStudyPlanLines: Record "Study Plan Lines";
        rStudentStudyPlan: Record "Registration Subjects";
        varLineNo: Integer;
        rStruEduCountry: Record "Structure Education Country";
        rCompanyInformation: Record "Company Information";
        cStudentsRegistration: Codeunit "Students Registration";
        rServicesPlanHead: Record "Services Plan Head";
        rStudentServicePlan: Record "Student Service Plan";
        rServicesPlanLine: Record "Services Plan Line";
        Text0001: Label 'You are changing the Student School Year. Do you want to proceed?';
        rCourseLines: Record "Course Lines";
        rUsersFamilyStudents: Record "Users Family / Students";
        cStudentServices: Codeunit "Student Services";
        rStudents: Record Students;
        cUserEducation: Codeunit "User Education";
        Text0004: Label 'Your identification is set up to process from %1 %2 only.';
        rStudentSusubjPlan: Record "Student Sub-Subjects Plan ";
        Text0005: Label 'The selected Course is for the school year %1.';
        Text0006: Label 'The Student Registration cannot be deleted.';
        rEduConfiguration: Record "Edu. Configuration";
        Text0007: Label 'To use this option please configure the Course Setting Ratings for the subject %1.';
        Text0008: Label 'To use this option please configure the Study Plan Setting Ratings for the subject %1.';
        rStudentsNLHours: Record "Students Non Lective Hours";
        Text0009: Label 'This option is only avaible for automatic processing only.';
        Text0010: Label 'Operation cancelled by the user.';
        rRegistrationClass: Record "Registration Class";
        Text0011: Label 'The Student %1 got a line in the class %2.';
        rSchool: Record School;

    //[Scope('OnPrem')]
    procedure ValidateStudentStudyPlan()
    begin
        rStudentStudyPlan.Reset;
        rStudentStudyPlan.SetRange("Student Code No.", "Student Code No.");
        rStudentStudyPlan.SetRange("Study Plan Code", "Study Plan Code");
        rStudentStudyPlan.SetRange("School Year", "School Year");
        rStudentStudyPlan.SetRange("Schooling Year", "Schooling Year");
        if rStudentStudyPlan.Find('+') then begin
            rStudentStudyPlan.DeleteAll;
            varLineNo := 10000;
        end else
            varLineNo := 10000;
    end;

    //[Scope('OnPrem')]
    procedure DeleteStudentStudyPlan()
    begin
        rStudentStudyPlan.Reset;
        rStudentStudyPlan.SetRange("Student Code No.", "Student Code No.");
        rStudentStudyPlan.SetRange("Study Plan Code", xRec."Study Plan Code");
        rStudentStudyPlan.SetRange("School Year", "School Year");
        rStudentStudyPlan.SetRange("Schooling Year", xRec."Schooling Year");
        if rStudentStudyPlan.Find('-') then
            rStudentStudyPlan.DeleteAll(true);
    end;

    //[Scope('OnPrem')]
    procedure GetNoStructureCountry(): Integer
    begin

        rStruEduCountry.Reset;
        rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
        //rStruEduCountry.SETRANGE(Level,rStruEduCountry.Level::Secondary);
        rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
        if rStruEduCountry.Find('-') then begin
            repeat
                if "Schooling Year" = rStruEduCountry."Schooling Year" then
                    exit(rStruEduCountry."Sorting ID");
            until rStruEduCountry.Next = 0;
        end;
    end;

    //[Scope('OnPrem')]
    procedure InsertSubjects(pCourseLines: Record "Course Lines")
    var
        l_recRegSubServ: Record "Registration Subjects";
        l_SPSubSubsLines: Record "Study Plan Sub-Subjects Lines";
        l_StudentSubSubPlan: Record "Student Sub-Subjects Plan ";
    begin
        rEduConfiguration.Get;


        l_recRegSubServ.Init;
        l_recRegSubServ."Student Code No." := "Student Code No.";
        l_recRegSubServ."School Year" := "School Year";
        l_recRegSubServ."Line No." := varLineNo;
        l_recRegSubServ."Schooling Year" := "Schooling Year";
        l_recRegSubServ."Study Plan Code" := pCourseLines.Code;
        l_recRegSubServ."Subjects Code" := pCourseLines."Subject Code";
        l_recRegSubServ.Description := pCourseLines."Subject Description";
        if rEduConfiguration."Use Formation Component" then begin
            if pCourseLines."Formation Component" = pCourseLines."Formation Component"::General then
                l_recRegSubServ.Validate(Enroled, true);
        end else begin
            if pCourseLines."Mandatory/Optional Type" = pCourseLines."Mandatory/Optional Type"::Required then
                l_recRegSubServ.Validate(Enroled, true);
        end;
        l_recRegSubServ."Mandatory/Optional Type" := pCourseLines."Mandatory/Optional Type";
        l_recRegSubServ."Curriculum Type" := pCourseLines."Curriculum Type";
        l_recRegSubServ."Evaluation Type" := pCourseLines."Evaluation Type";
        l_recRegSubServ."Country/Region Code" := cStudentsRegistration.GetCountry;
        l_recRegSubServ."Responsibility Center" := pCourseLines."Responsibility Center";
        l_recRegSubServ."Maximum Injustified Absence" := pCourseLines."Maximum Unjustified Absences";
        l_recRegSubServ."Assessment Code" := pCourseLines."Assessment Code";
        l_recRegSubServ."Option Group" := pCourseLines."Option Group";
        l_recRegSubServ."Formation Component" := pCourseLines."Formation Component";
        l_recRegSubServ."Characterise Subjects" := pCourseLines."Characterise Subjects";
        l_recRegSubServ."Country/Region Code" := pCourseLines."Country/Region Code";
        l_recRegSubServ."Responsibility Center" := pCourseLines."Responsibility Center";
        l_recRegSubServ."Maximum Justified Absence" := pCourseLines."Maximum Justified Absence";
        l_recRegSubServ."Minimum Classification Level" := pCourseLines."Minimum Classification Level";
        l_recRegSubServ."User Id" := UserId;
        l_recRegSubServ.Date := WorkDate;
        l_recRegSubServ.Type := Type;
        l_recRegSubServ."Sorting ID" := pCourseLines."Sorting ID";
        l_recRegSubServ."Sub-subjects for assess. only" := pCourseLines."Sub-subjects for assess. only";
        l_recRegSubServ."Legal Code" := pCourseLines."Legal Code";
        l_recRegSubServ."Original Line No." := pCourseLines."Line No.";
        l_recRegSubServ."Continuous Assessment" := pCourseLines."Continuous Assessment";
        l_recRegSubServ.Insert;


        if pCourseLines.CalcFields("Sub-Subject") then begin
            l_SPSubSubsLines.Reset;
            l_SPSubSubsLines.SetRange(Type, l_SPSubSubsLines.Type::Course);
            l_SPSubSubsLines.SetRange(Code, pCourseLines.Code);
            l_SPSubSubsLines.SetRange("Subject Code", pCourseLines."Subject Code");
            l_SPSubSubsLines.SetRange("Schooling Year", "Schooling Year");
            l_SPSubSubsLines.SetRange("Line No.", pCourseLines."Line No.");
            if l_SPSubSubsLines.Find('-') then begin
                repeat
                    l_StudentSubSubPlan.Init;
                    l_StudentSubSubPlan."Student Code No." := "Student Code No.";
                    l_StudentSubSubPlan."School Year" := "School Year";
                    l_StudentSubSubPlan."Schooling Year" := "Schooling Year";
                    l_StudentSubSubPlan."Subject Code" := pCourseLines."Subject Code";
                    l_StudentSubSubPlan."Subject Description" := pCourseLines."Subject Description";
                    l_StudentSubSubPlan."Sub-Subject Code" := l_SPSubSubsLines."Sub-Subject Code";
                    l_StudentSubSubPlan."Sub-Subject Description" := l_SPSubSubsLines."Sub-Subject Description";
                    l_StudentSubSubPlan.Code := l_SPSubSubsLines.Code;
                    l_StudentSubSubPlan."Mandatory/Optional Type" := l_SPSubSubsLines."Mandatory/Optional Type";
                    l_StudentSubSubPlan."Curriculum Type" := l_SPSubSubsLines."Curriculum Type";
                    l_StudentSubSubPlan."Evaluation Type" := l_SPSubSubsLines."Evaluation Type";
                    l_StudentSubSubPlan."Country/Region Code" := "Country/Region Code";
                    l_StudentSubSubPlan."Responsibility Center" := l_SPSubSubsLines."Responsibility Center";
                    l_StudentSubSubPlan."Maximum Injustified Absence" := l_SPSubSubsLines."Maximum Injustified Absence";
                    l_StudentSubSubPlan."Assessment Code" := l_SPSubSubsLines."Assessment Code";
                    l_StudentSubSubPlan."Minimum Classification Level" := l_SPSubSubsLines."Minimum Classification Level";
                    l_StudentSubSubPlan."Characterise Subjects" := l_SPSubSubsLines."Characterise Subjects";
                    l_StudentSubSubPlan."Maximum Total Absence" := l_SPSubSubsLines."Maximum Total Absence";
                    l_StudentSubSubPlan.Type := l_StudentSubSubPlan.Type::Multi;
                    l_StudentSubSubPlan."Line No." := varLineNo;
                    l_StudentSubSubPlan."User Id" := UserId;
                    l_StudentSubSubPlan.Date := WorkDate;
                    l_StudentSubSubPlan."Sorting ID" := l_SPSubSubsLines."Sorting ID";
                    l_StudentSubSubPlan.Insert;
                until l_SPSubSubsLines.Next = 0;
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure ValidateAssementCourse()
    begin
        rCourseLines.Reset;
        rCourseLines.SetRange(Code, Course);
        rCourseLines.SetFilter("Evaluation Type", '<>%1', rCourseLines."Evaluation Type"::"None Qualification");
        if rCourseLines.Find('-') then begin
            repeat
                rCourseLines.TestField("Assessment Code");
            until rCourseLines.Next = 0;
        end;
    end;

    //[Scope('OnPrem')]
    procedure InsertSettingRattingsCourse()
    var
        l_recRegSubServ: Record "Registration Subjects";
    begin
        l_recRegSubServ.Reset;
        l_recRegSubServ.SetRange("Student Code No.", "Student Code No.");
        l_recRegSubServ.SetRange("School Year", "School Year");
        l_recRegSubServ.SetRange("Schooling Year", "Schooling Year");
        l_recRegSubServ.SetRange(Type, l_recRegSubServ.Type::Multi);
        l_recRegSubServ.SetRange("Study Plan Code", Course);
        if l_recRegSubServ.Find('-') then begin
            repeat
                InsertSettingRatings(l_recRegSubServ);
            until l_recRegSubServ.Next = 0;
        end;
    end;

    //[Scope('OnPrem')]
    procedure InsertSettingRatings(pRegistrationSubjects: Record "Registration Subjects")
    var
        l_rSettingRatings: Record "Setting Ratings";
        l_rMoments: Record "Moments Assessment";
        Text0001: Label 'Unable to automatically configure the moments of Evaluation for Discipline.';
        rCourseLines: Record "Course Lines";
        Text0003: Label 'There are no moments for the Academic Year %1 and schooling year %2.';
    begin
        if rStudents.Get("Student Code No.") then;


        l_rMoments.Reset;
        l_rMoments.SetRange("School Year", "School Year");
        l_rMoments.SetRange("Schooling Year", "Schooling Year");
        l_rMoments.SetRange("Responsibility Center", rStudents."Responsibility Center");
        if l_rMoments.Find('-') then begin
            repeat
                l_rSettingRatings.Reset;
                l_rSettingRatings.SetRange("Moment Code", l_rMoments."Moment Code");
                l_rSettingRatings.SetRange("School Year", "School Year");
                l_rSettingRatings.SetRange("Schooling Year", "Schooling Year");
                l_rSettingRatings.SetRange("Study Plan Code", Course);
                l_rSettingRatings.SetRange("Subject Code", pRegistrationSubjects."Subjects Code");
                l_rSettingRatings.SetRange("Responsibility Center", rStudents."Responsibility Center");
                if not l_rSettingRatings.Find('-') then begin
                    l_rSettingRatings.Init;
                    l_rSettingRatings."Moment Code" := l_rMoments."Moment Code";
                    l_rSettingRatings."School Year" := "School Year";
                    l_rSettingRatings."Schooling Year" := "Schooling Year";
                    l_rSettingRatings."Study Plan Code" := Course;
                    l_rSettingRatings."Subject Code" := pRegistrationSubjects."Subjects Code";
                    l_rSettingRatings."Responsibility Center" := rStudents."Responsibility Center";
                    rCourseLines.Reset;
                    rCourseLines.SetRange(Code, Course);
                    rCourseLines.SetRange("Subject Code", l_rSettingRatings."Subject Code");
                    if rCourseLines.FindFirst then
                        l_rSettingRatings."Assessment Code" := rCourseLines."Assessment Code";
                    l_rSettingRatings.Type := l_rSettingRatings.Type::Header;
                    l_rSettingRatings."Type Education" := l_rSettingRatings."Type Education"::Multi;
                    l_rSettingRatings.Insert;
                end else begin
                    rCourseLines.Reset;
                    rCourseLines.SetRange(Code, Course);
                    rCourseLines.SetRange("Subject Code", l_rSettingRatings."Subject Code");
                    if rCourseLines.FindFirst then
                        l_rSettingRatings."Assessment Code" := rCourseLines."Assessment Code";
                    l_rSettingRatings.Modify;
                end;
            until l_rMoments.Next = 0;
        end else
            Error(Text0003, "School Year", "Schooling Year");
    end;

    //[Scope('OnPrem')]
    procedure SubjectsAspects2(pRegistrationSubjects: Record "Registration Subjects")
    var
        rRegistrationSubjects: Record "Registration Subjects";
        rAspects: Record Aspects;
        l_rMoments: Record "Moments Assessment";
        l_rMomentsTEMP: Record "Moments Assessment" temporary;
        lSettingRatings: Record "Setting Ratings";
        int: Integer;
        tAssessment: Text[1024];
    begin
        if rStudents.Get("Student Code No.") then;

        l_rMomentsTEMP.DeleteAll;

        lSettingRatings.Reset;
        lSettingRatings.SetRange("School Year", "School Year");
        lSettingRatings.SetRange("Schooling Year", "Schooling Year");
        lSettingRatings.SetRange("Responsibility Center", rStudents."Responsibility Center");
        lSettingRatings.SetRange("Type Education", pRegistrationSubjects.Type);
        lSettingRatings.SetRange("Study Plan Code", pRegistrationSubjects."Study Plan Code");
        lSettingRatings.SetRange(Type, lSettingRatings.Type::Header);
        lSettingRatings.SetRange("Subject Code", pRegistrationSubjects."Subjects Code");
        if lSettingRatings.FindSet then begin
            repeat
                l_rMoments.Reset;
                l_rMoments.SetCurrentKey("Schooling Year", "Sorting ID");
                l_rMoments.SetRange("School Year", "School Year");
                l_rMoments.SetRange("Schooling Year", "Schooling Year");
                l_rMoments.SetRange("Responsibility Center", rStudents."Responsibility Center");
                l_rMoments.SetRange("Moment Code", lSettingRatings."Moment Code");
                if l_rMoments.Find('-') then begin
                    l_rMomentsTEMP.Init;
                    l_rMomentsTEMP.TransferFields(l_rMoments);
                    l_rMomentsTEMP.Insert;
                end;
            until lSettingRatings.Next = 0;
        end else
            if Type = Type::Simple then
                Error(Text0008, pRegistrationSubjects."Subjects Code")
            else
                Error(Text0007, pRegistrationSubjects."Subjects Code");

        l_rMomentsTEMP.Reset;
        l_rMomentsTEMP.SetRange("School Year", "School Year");
        l_rMomentsTEMP.SetRange("Schooling Year", "Schooling Year");
        l_rMomentsTEMP.SetRange("Responsibility Center", rStudents."Responsibility Center");
        if l_rMomentsTEMP.Find('-') then
            repeat
                tAssessment := tAssessment + l_rMomentsTEMP."Moment Code" + ','
            until l_rMomentsTEMP.Next = 0;

        if tAssessment <> '' then begin
            int := StrMenu(tAssessment);
            l_rMomentsTEMP.Reset;
            l_rMomentsTEMP.SetRange("School Year", "School Year");
            l_rMomentsTEMP.SetRange("Schooling Year", "Schooling Year");
            l_rMomentsTEMP.SetRange("Responsibility Center", rStudents."Responsibility Center");
            if l_rMomentsTEMP.Find('-') and (int <> 0) then
                l_rMomentsTEMP.Next := int - 1
            else
                exit;
        end;

        rAspects.Reset;
        rAspects.SetRange(Type, rAspects.Type::Student);
        rAspects.SetRange("School Year", "School Year");
        rAspects.SetRange("Type No.", "Student Code No.");
        rAspects.SetRange("Moment Code", l_rMomentsTEMP."Moment Code");
        rAspects.SetRange(Subjects, pRegistrationSubjects."Subjects Code");
        rAspects.SetRange("Responsibility Center", rStudents."Responsibility Center");
        rAspects.SetRange("Sub Subjects", '');
        if not rAspects.Find('-') then begin
            rAspects.InsertDefaultAspects2(rAspects, rAspects.Type::Student, "School Year", "Student Code No.", l_rMomentsTEMP."Moment Code",
                               "Schooling Year", pRegistrationSubjects."Subjects Code", '', pRegistrationSubjects."Evaluation Type",
                               pRegistrationSubjects."Assessment Code", rStudents."Responsibility Center");

            Commit;
        end;

        PAGE.RunModal(PAGE::Aspects, rAspects);
    end;

    //[Scope('OnPrem')]
    procedure DisplayMap()
    var
        rStudents: Record Students;
        MapPoint: Record "Online Map Setup";
        MapMgt: Codeunit "Online Map Management";
    begin
        if rStudents.Get("Student Code No.") then begin
            if MapPoint.Find('-') then
                MapMgt.MakeSelection(DATABASE::Students, rStudents.GetPosition);
        end;
    end;

    //[Scope('OnPrem')]
    procedure DeleteSubSubjects()
    var
        rStudentSubSubjectsPlan: Record "Student Sub-Subjects Plan ";
    begin

        rStudentSubSubjectsPlan.Reset;
        rStudentSubSubjectsPlan.SetRange("Student Code No.", "Student Code No.");
        rStudentSubSubjectsPlan.SetRange("School Year", "School Year");
        if "Study Plan Code" <> xRec."Study Plan Code" then
            rStudentSubSubjectsPlan.SetRange(Type, rStudentSubSubjectsPlan.Type::Simple);
        if Course <> xRec.Course then
            rStudentSubSubjectsPlan.SetRange(Type, rStudentSubSubjectsPlan.Type::Multi);
        if rStudentSubSubjectsPlan.Find('-') then
            rStudentSubSubjectsPlan.DeleteAll(true);
    end;

    //[Scope('OnPrem')]
    procedure GetUserFamilyActiveYear()
    var
        rUsersFamilyStudents: Record "Users Family / Students";
        rNEWUsersFamilyStudents: Record "Users Family / Students";
        rSchoolYear: Record "School Year";
        rSchoolYear2: Record "School Year";
    begin
        rSchoolYear.Reset;
        rSchoolYear.SetRange(Status, rSchoolYear.Status::Active);
        if rSchoolYear.FindFirst then;

        rSchoolYear2.Reset;
        rSchoolYear2.SetRange("School Year", "School Year");
        rSchoolYear2.SetRange(Status, rSchoolYear.Status::Planning);
        if rSchoolYear2.FindFirst then begin
            rUsersFamilyStudents.Reset;
            rUsersFamilyStudents.SetRange("Student Code No.", "Student Code No.");
            rUsersFamilyStudents.SetRange("School Year", rSchoolYear."School Year");
            if rUsersFamilyStudents.Find('-') then begin
                repeat
                    rNEWUsersFamilyStudents.Reset;
                    rNEWUsersFamilyStudents.SetRange("School Year", rSchoolYear2."School Year");
                    rNEWUsersFamilyStudents.SetRange("Student Code No.", "Student Code No.");
                    rNEWUsersFamilyStudents.SetRange(Kinship, rUsersFamilyStudents.Kinship);
                    if not rNEWUsersFamilyStudents.Find('-') then begin
                        rNEWUsersFamilyStudents.TransferFields(rUsersFamilyStudents);
                        rNEWUsersFamilyStudents."School Year" := rSchoolYear2."School Year";
                        rNEWUsersFamilyStudents.Insert(true);
                    end else begin
                        rNEWUsersFamilyStudents.TransferFields(rUsersFamilyStudents);
                        rNEWUsersFamilyStudents.Modify(true);
                    end;
                until rUsersFamilyStudents.Next = 0;
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure ValidateNextSchoolYear()
    var
        l_SchoolYear: Record "School Year";
        l_Registration: Record Registration;
        VarNEWschoolYear: Code[9];
        Text0001: Label 'The student already has a registration in the school year %1. Do you wish to delete?';
        l_RegistrationClass: Record "Registration Class";
    begin

        l_SchoolYear.Reset;
        if l_SchoolYear.FindSet then begin
            repeat
                if "School Year" = l_SchoolYear."School Year" then begin
                    l_SchoolYear.Next;
                    VarNEWschoolYear := l_SchoolYear."School Year";
                end;
            until l_SchoolYear.Next = 0;
        end;


        l_Registration.Reset;
        l_Registration.SetRange("Student Code No.", "Student Code No.");
        l_Registration.SetRange("School Year", VarNEWschoolYear);
        l_Registration.SetRange("Responsibility Center", "Responsibility Center");
        if l_Registration.FindSet then begin
            if Confirm(Text0001, false, VarNEWschoolYear) then begin
                l_RegistrationClass.Reset;
                l_RegistrationClass.SetRange("School Year", VarNEWschoolYear);
                l_RegistrationClass.SetRange("Student Code No.", "Student Code No.");
                l_RegistrationClass.SetRange("Responsibility Center", "Responsibility Center");
                l_RegistrationClass.SetRange("Schooling Year", l_Registration."Schooling Year");
                if l_RegistrationClass.FindSet then
                    l_RegistrationClass.Delete(true);


                l_Registration.Delete(true);
            end else
                Error(Text0010);

        end;
    end;

    //[Scope('OnPrem')]
    procedure ChekIfInvoice(): Boolean
    var
        lStudentLedgerEntry: Record "Student Ledger Entry";
    begin
        lStudentLedgerEntry.Reset;
        lStudentLedgerEntry.SetCurrentKey("Student No.", Class, "School Year", "Schooling Year", "Line No.");
        lStudentLedgerEntry.SetRange("Student No.", "Student Code No.");
        lStudentLedgerEntry.SetRange("School Year", "School Year");
        if lStudentLedgerEntry.FindFirst then
            exit(true)
        else
            exit(false);
    end;

    //[Scope('OnPrem')]
    procedure InsertStudents(pRegistration: Record Registration)
    var
        l_rRegistration: Record Registration;
        l_rRegistrationClass: Record "Registration Class";
    begin
        l_rRegistration.Reset;
        l_rRegistration.SetRange("Student Code No.", pRegistration."Student Code No.");
        l_rRegistration.SetRange("School Year", pRegistration."School Year");
        l_rRegistration.SetRange("Schooling Year", pRegistration."Schooling Year");
        if l_rRegistration.FindFirst then begin

            if pRegistration.Type = pRegistration.Type::Multi then
                l_rRegistration.Validate(Course, pRegistration.Course)
            else
                l_rRegistration.Validate("Study Plan Code", pRegistration."Study Plan Code");


            if (pRegistration."Services Plan Code" <> l_rRegistration."Services Plan Code") then
                l_rRegistration.Validate("Services Plan Code", pRegistration."Services Plan Code");

            if (l_rRegistration.Class <> pRegistration.Class) then
                l_rRegistration.Class := pRegistration.Class;

            l_rRegistration.Modify(true);

            rRegistrationClass.Reset;
            rRegistrationClass.SetRange("School Year", pRegistration."School Year");
            rRegistrationClass.SetRange("Schooling Year", pRegistration."Schooling Year");
            rRegistrationClass.SetRange("Student Code No.", pRegistration."Student Code No.");
            rRegistrationClass.SetRange(Status, rRegistrationClass.Status::" ");
            if not rRegistrationClass.FindSet then begin
                l_rRegistrationClass.Reset;
                l_rRegistrationClass.SetRange("School Year", pRegistration."School Year");
                l_rRegistrationClass.SetRange("Schooling Year", pRegistration."Schooling Year");
                l_rRegistrationClass.SetRange(Class, pRegistration.Class);
                if l_rRegistrationClass.FindLast then begin
                    rRegistrationClass.Init;
                    rRegistrationClass."Line No." := l_rRegistrationClass."Line No." + 10000;
                    rRegistrationClass."Schooling Year" := pRegistration."Schooling Year";
                    rRegistrationClass."School Year" := pRegistration."School Year";
                    rRegistrationClass.Class := pRegistration.Class;
                    if pRegistration.Type = pRegistration.Type::Multi then
                        rRegistrationClass."Study Plan Code" := pRegistration.Course
                    else
                        rRegistrationClass."Study Plan Code" := pRegistration."Study Plan Code";
                    rRegistrationClass.Type := pRegistration.Type;
                    rRegistrationClass.Validate("Student Code No.", pRegistration."Student Code No.");
                    rRegistrationClass.Insert(true);
                end else begin
                    rRegistrationClass.Init;
                    rRegistrationClass."Line No." := 10000;
                    rRegistrationClass."Schooling Year" := pRegistration."Schooling Year";
                    rRegistrationClass."School Year" := pRegistration."School Year";
                    rRegistrationClass.Class := pRegistration.Class;
                    if pRegistration.Type = pRegistration.Type::Multi then
                        rRegistrationClass."Study Plan Code" := pRegistration.Course
                    else
                        rRegistrationClass."Study Plan Code" := pRegistration."Study Plan Code";
                    rRegistrationClass.Type := pRegistration.Type;
                    rRegistrationClass.Validate("Student Code No.", pRegistration."Student Code No.");
                    rRegistrationClass.Insert(true);
                end;
            end else begin
                l_rRegistrationClass.Reset;
                l_rRegistrationClass.SetRange("School Year", pRegistration."School Year");
                l_rRegistrationClass.SetRange("Schooling Year", pRegistration."Schooling Year");
                l_rRegistrationClass.SetRange(Class, pRegistration.Class);
                if l_rRegistrationClass.FindLast then begin
                    rRegistrationClass.Delete;
                    rRegistrationClass.Init;

                    rRegistrationClass."Line No." := l_rRegistrationClass."Line No." + 10000;
                    rRegistrationClass."Schooling Year" := pRegistration."Schooling Year";
                    rRegistrationClass."School Year" := pRegistration."School Year";
                    rRegistrationClass.Class := pRegistration.Class;
                    if pRegistration.Type = pRegistration.Type::Multi then
                        rRegistrationClass."Study Plan Code" := pRegistration.Course
                    else
                        rRegistrationClass."Study Plan Code" := pRegistration."Study Plan Code";
                    rRegistrationClass.Validate("Student Code No.", pRegistration."Student Code No.");
                    rRegistrationClass.Insert;
                end;
            end;
        end;
    end;
}

