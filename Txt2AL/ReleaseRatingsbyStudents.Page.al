#pragma implicitwith disable
page 31009799 "Release Ratings by Students"
{
    Caption = 'Release Ratings by Students';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    Permissions = TableData "Assessing Students" = rimd;
    SourceTable = "Registration Subjects";
    SourceTableView = SORTING("Class No.")
                      ORDER(Ascending)
                      WHERE(Status = FILTER(Subscribed));

    layout
    {
        area(content)
        {
            group(Assessment)
            {
                Caption = 'Assessment';
                field(VC1; varClass)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Class';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        rClass.Reset;
                        rClass.SetCurrentKey("School Year", "Schooling Year");
                        rClass.SetFilter("School Year", cStudentsRegistration.GetShoolYearActiveClosing);
                        if rClass.Find('-') then begin
                            if PAGE.RunModal(PAGE::"Class List", rClass) = ACTION::LookupOK then begin
                                varClass := rClass.Class;
                                VarSchoolYear := rClass."School Year";
                                varSchoolingYear := rClass."Schooling Year";
                                VarStudyPlanCode := rClass."Study Plan Code";
                                VarType := rClass.Type;
                            end;
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        rClass.Reset;
                        rClass.SetFilter("School Year", cStudentsRegistration.GetShoolYearActiveClosing);
                        rClass.SetRange(Class, varClass);
                        if rClass.Find('-') then begin
                            VarSchoolYear := rClass."School Year";
                            varSchoolingYear := rClass."Schooling Year";
                            VarStudyPlanCode := rClass."Study Plan Code";
                            VarType := rClass.Type;
                        end else
                            Error(text006);
                    end;
                }
                field(VS1; VarSubjects)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Subjects';

                    trigger OnLookup(var Text: Text): Boolean
                    begin

                        if varClass <> '' then begin
                            if VarType = VarType::Simple then begin
                                rStudyPlanLines.Reset;
                                rStudyPlanLines.SetFilter(Code, VarStudyPlanCode);
                                rStudyPlanLines.SetFilter("School Year", VarSchoolYear);
                                rStudyPlanLines.SetFilter("Schooling Year", varSchoolingYear);
                                if rStudyPlanLines.Find('-') then begin
                                    if PAGE.RunModal(PAGE::"List Subjects", rStudyPlanLines) = ACTION::LookupOK then begin
                                        VarSubjects := rStudyPlanLines."Subject Code";
                                        UpdateForm;
                                    end;
                                end;
                            end else begin

                                rCourseLines.Reset;
                                rCourseLines.SetRange(Code, VarStudyPlanCode);
                                if rCourseLines.Find('-') then begin
                                    if PAGE.RunModal(PAGE::"List Course Lines", rCourseLines) = ACTION::LookupOK then begin
                                        VarSubjects := rCourseLines."Subject Code";
                                        UpdateForm;
                                    end;
                                end;
                            end;
                            Rec.SetRange(Class, varClass);
                            Rec.SetRange("Subjects Code", VarSubjects);
                            CurrPage.Update(true);
                        end else
                            Error(text007);
                    end;

                    trigger OnValidate()
                    begin
                        if varClass <> '' then begin
                            Rec.SetRange(Class, varClass);
                            Rec.SetRange("Subjects Code", VarSubjects);
                        end else
                            Error(text007);
                        VarSubjectsC1102056012OnAfterV;
                    end;
                }
            }
            group(Control1000000002)
            {
                ShowCaption = false;
                repeater(TableBoxMoments)
                {
                    field(CN1; Rec."Class No.")
                    {
                        ApplicationArea = Basic, Suite;
                        Editable = false;
                    }
                    field(SN1; rStudents.Name)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Name';
                        Editable = false;
                    }
                    field(Txt1; vText[1])
                    {
                        ApplicationArea = Basic, Suite;
                        CaptionClass = '1,5,,' + getCaptionLabel(1);
                        Editable = Txt1Editable;

                        trigger OnLookup(var Text: Text): Boolean
                        begin

                            if vArrayMomento[1] <> '' then begin
                                vText[1] := LookupFunction(1);
                                InsertAssessment(Rec."Student Code No.", Rec."Class No.", 1, vText[1]);
                            end;
                        end;

                        trigger OnValidate()
                        begin


                            ValidateAssessmentQualitative(1, vText[1]);



                            if vArrayAssessmentType[1] = vArrayAssessmentType[1] ::"Mixed-Qualification" then begin
                                if vArrayMomento[1] <> '' then begin
                                    vText[1] := ValidateAssessmentMixed(1, vText[1]);
                                    InsertAssessment(Rec."Student Code No.", Rec."Class No.", 1, vText[1]);
                                end;

                            end else begin
                                if vArrayMomento[1] <> '' then begin
                                    vText[1] := Format(ValidateAssessmentQuant(1, vText[1]));

                                    InsertAssessment(Rec."Student Code No.", Rec."Class No.", 1, vText[1]);
                                end;
                            end;
                            vText1OnAfterValidate;
                        end;
                    }
                    field(Txt2; vText[2])
                    {
                        ApplicationArea = Basic, Suite;
                        CaptionClass = '1,5,,' + getCaptionLabel(2);
                        Editable = Txt2Editable;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            if vArrayMomento[2] <> '' then begin
                                vText[2] := LookupFunction(2);
                                InsertAssessment(Rec."Student Code No.", Rec."Class No.", 2, vText[2]);
                            end;
                        end;

                        trigger OnValidate()
                        begin

                            ValidateAssessmentQualitative(2, vText[2]);


                            if vArrayAssessmentType[2] = vArrayAssessmentType[2] ::"Mixed-Qualification" then begin
                                if vArrayMomento[2] <> '' then begin
                                    vText[2] := ValidateAssessmentMixed(2, vText[2]);
                                    InsertAssessment(Rec."Student Code No.", Rec."Class No.", 2, vText[2]);
                                end;

                            end else begin
                                if vArrayMomento[2] <> '' then begin
                                    vText[2] := Format(ValidateAssessmentQuant(2, vText[2]));
                                    InsertAssessment(Rec."Student Code No.", Rec."Class No.", 2, vText[2]);
                                end;
                            end;
                            vText2OnAfterValidate;
                        end;
                    }
                    field(Txt3; vText[3])
                    {
                        ApplicationArea = Basic, Suite;
                        CaptionClass = '1,5,,' + getCaptionLabel(3);
                        Editable = Txt3Editable;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            if vArrayMomento[3] <> '' then begin
                                vText[3] := LookupFunction(3);
                                InsertAssessment(Rec."Student Code No.", Rec."Class No.", 3, vText[3]);
                            end;
                        end;

                        trigger OnValidate()
                        begin
                            ValidateAssessmentQualitative(3, vText[3]);

                            if vArrayAssessmentType[3] = vArrayAssessmentType[3] ::"Mixed-Qualification" then begin
                                if vArrayMomento[3] <> '' then begin
                                    vText[3] := ValidateAssessmentMixed(3, vText[3]);
                                    InsertAssessment(Rec."Student Code No.", Rec."Class No.", 3, vText[3]);
                                end;

                            end else begin
                                if vArrayMomento[3] <> '' then begin
                                    vText[3] := Format(ValidateAssessmentQuant(3, vText[3]));
                                    InsertAssessment(Rec."Student Code No.", Rec."Class No.", 3, vText[3]);
                                end;

                            end;
                            vText3OnAfterValidate;
                        end;
                    }
                    field(Txt4; vText[4])
                    {
                        ApplicationArea = Basic, Suite;
                        CaptionClass = '1,5,,' + getCaptionLabel(4);
                        Editable = Txt4Editable;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            if vArrayMomento[4] <> '' then begin
                                vText[4] := LookupFunction(4);
                                InsertAssessment(Rec."Student Code No.", Rec."Class No.", 4, vText[4]);
                            end;
                        end;

                        trigger OnValidate()
                        begin
                            ValidateAssessmentQualitative(4, vText[4]);

                            if vArrayAssessmentType[4] = vArrayAssessmentType[4] ::"Mixed-Qualification" then begin
                                if vArrayMomento[4] <> '' then begin
                                    vText[4] := ValidateAssessmentMixed(1, vText[1]);
                                    InsertAssessment(Rec."Student Code No.", Rec."Class No.", 4, vText[4]);
                                end;

                            end else begin
                                if vArrayMomento[4] <> '' then begin
                                    vText[4] := Format(ValidateAssessmentQuant(4, vText[4]));
                                    InsertAssessment(Rec."Student Code No.", Rec."Class No.", 4, vText[4]);
                                end;


                            end;
                            vText4OnAfterValidate;
                        end;
                    }
                    field(Txt5; vText[5])
                    {
                        ApplicationArea = Basic, Suite;
                        CaptionClass = '1,5,,' + getCaptionLabel(5);
                        Editable = Txt5Editable;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            if vArrayMomento[5] <> '' then begin
                                vText[5] := LookupFunction(5);
                                InsertAssessment(Rec."Student Code No.", Rec."Class No.", 5, vText[5]);
                            end;
                        end;

                        trigger OnValidate()
                        begin
                            ValidateAssessmentQualitative(5, vText[5]);

                            if vArrayAssessmentType[5] = vArrayAssessmentType[5] ::"Mixed-Qualification" then begin
                                if vArrayMomento[5] <> '' then begin
                                    vText[5] := ValidateAssessmentMixed(5, vText[5]);
                                    InsertAssessment(Rec."Student Code No.", Rec."Class No.", 5, vText[5]);
                                end;

                            end else begin
                                if vArrayMomento[5] <> '' then begin
                                    vText[5] := Format(ValidateAssessmentQuant(5, vText[5]));
                                    InsertAssessment(Rec."Student Code No.", Rec."Class No.", 5, vText[5]);
                                end;
                            end;
                            vText5OnAfterValidate;
                        end;
                    }
                    field(Txt6; vText[6])
                    {
                        ApplicationArea = Basic, Suite;
                        CaptionClass = '1,5,,' + getCaptionLabel(6);
                        Editable = Txt6Editable;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            if vArrayMomento[6] <> '' then begin
                                vText[6] := LookupFunction(6);
                                InsertAssessment(Rec."Student Code No.", Rec."Class No.", 6, vText[6]);
                            end;
                        end;

                        trigger OnValidate()
                        begin
                            ValidateAssessmentQualitative(6, vText[6]);


                            if vArrayAssessmentType[6] = vArrayAssessmentType[6] ::"Mixed-Qualification" then begin
                                if vArrayMomento[6] <> '' then begin
                                    vText[6] := ValidateAssessmentMixed(6, vText[6]);
                                    InsertAssessment(Rec."Student Code No.", Rec."Class No.", 6, vText[6]);
                                end;

                            end else begin
                                if vArrayMomento[6] <> '' then begin
                                    vText[6] := Format(ValidateAssessmentQuant(6, vText[6]));
                                    InsertAssessment(Rec."Student Code No.", Rec."Class No.", 6, vText[6]);
                                end;

                            end;
                            vText6OnAfterValidate;
                        end;
                    }
                    field(Txt7; vText[7])
                    {
                        ApplicationArea = Basic, Suite;
                        CaptionClass = '1,5,,' + getCaptionLabel(7);
                        Editable = Txt7Editable;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            if vArrayMomento[7] <> '' then begin
                                vText[7] := LookupFunction(7);
                                InsertAssessment(Rec."Student Code No.", Rec."Class No.", 7, vText[7]);
                            end;
                        end;

                        trigger OnValidate()
                        begin
                            ValidateAssessmentQualitative(7, vText[7]);

                            if vArrayAssessmentType[7] = vArrayAssessmentType[7] ::"Mixed-Qualification" then begin
                                if vArrayMomento[7] <> '' then begin
                                    vText[7] := ValidateAssessmentMixed(7, vText[7]);
                                    InsertAssessment(Rec."Student Code No.", Rec."Class No.", 7, vText[7]);
                                end;

                            end else begin
                                if vArrayMomento[7] <> '' then begin
                                    vText[7] := Format(ValidateAssessmentQuant(7, vText[7]));
                                    InsertAssessment(Rec."Student Code No.", Rec."Class No.", 7, vText[7]);
                                end;
                            end;
                            vText7OnAfterValidate;
                        end;
                    }
                    field(Txt8; vText[8])
                    {
                        ApplicationArea = Basic, Suite;
                        CaptionClass = '1,5,,' + getCaptionLabel(8);
                        Editable = Txt8Editable;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            if vArrayMomento[8] <> '' then begin
                                vText[8] := LookupFunction(8);
                                InsertAssessment(Rec."Student Code No.", Rec."Class No.", 8, vText[8]);
                            end;
                        end;

                        trigger OnValidate()
                        begin
                            ValidateAssessmentQualitative(8, vText[8]);

                            if vArrayAssessmentType[8] = vArrayAssessmentType[8] ::"Mixed-Qualification" then begin
                                if vArrayMomento[8] <> '' then begin
                                    vText[8] := ValidateAssessmentMixed(8, vText[8]);
                                    InsertAssessment(Rec."Student Code No.", Rec."Class No.", 8, vText[8]);
                                end;

                            end else begin
                                if vArrayMomento[8] <> '' then begin
                                    vText[8] := Format(ValidateAssessmentQuant(8, vText[8]));
                                    InsertAssessment(Rec."Student Code No.", Rec."Class No.", 8, vText[8]);
                                end;


                            end;
                            vText8OnAfterValidate;
                        end;
                    }
                    field(Txt9; vText[9])
                    {
                        ApplicationArea = Basic, Suite;
                        CaptionClass = '1,5,,' + getCaptionLabel(9);
                        Editable = Txt9Editable;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            if vArrayMomento[9] <> '' then begin
                                vText[9] := LookupFunction(9);
                                InsertAssessment(Rec."Student Code No.", Rec."Class No.", 9, vText[9]);
                            end;
                        end;

                        trigger OnValidate()
                        begin
                            ValidateAssessmentQualitative(9, vText[9]);

                            if vArrayAssessmentType[9] = vArrayAssessmentType[9] ::"Mixed-Qualification" then begin
                                if vArrayMomento[9] <> '' then begin
                                    vText[9] := ValidateAssessmentMixed(9, vText[9]);
                                    InsertAssessment(Rec."Student Code No.", Rec."Class No.", 9, vText[9]);
                                end;

                            end else begin
                                if vArrayMomento[9] <> '' then begin
                                    vText[9] := Format(ValidateAssessmentQuant(9, vText[9]));
                                    InsertAssessment(Rec."Student Code No.", Rec."Class No.", 9, vText[9]);
                                end;
                            end;
                            vText9OnAfterValidate;
                        end;
                    }
                    field(Txt10; vText[10])
                    {
                        ApplicationArea = Basic, Suite;
                        CaptionClass = '1,5,,' + getCaptionLabel(10);
                        Editable = Txt10Editable;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            if vArrayMomento[10] <> '' then begin
                                vText[10] := LookupFunction(10);
                                InsertAssessment(Rec."Student Code No.", Rec."Class No.", 10, vText[10]);
                            end;
                        end;

                        trigger OnValidate()
                        begin
                            ValidateAssessmentQualitative(10, vText[10]);

                            if vArrayAssessmentType[10] = vArrayAssessmentType[10] ::"Mixed-Qualification" then begin
                                if vArrayMomento[10] <> '' then begin
                                    vText[10] := ValidateAssessmentMixed(10, vText[10]);
                                    InsertAssessment(Rec."Student Code No.", Rec."Class No.", 10, vText[10]);
                                end;

                            end else begin
                                if vArrayMomento[10] <> '' then begin
                                    vText[10] := Format(ValidateAssessmentQuant(10, vText[10]));
                                    InsertAssessment(Rec."Student Code No.", Rec."Class No.", 10, vText[10]);
                                end;

                            end;
                            vText10OnAfterValidate;
                        end;
                    }
                    field(Txt11; vText[11])
                    {
                        ApplicationArea = Basic, Suite;
                        CaptionClass = '1,5,,' + getCaptionLabel(11);
                        Editable = Txt11Editable;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            if vArrayMomento[11] <> '' then begin
                                vText[11] := LookupFunction(11);
                                InsertAssessment(Rec."Student Code No.", Rec."Class No.", 11, vText[11]);
                            end;
                        end;

                        trigger OnValidate()
                        begin
                            ValidateAssessmentQualitative(11, vText[11]);

                            if vArrayAssessmentType[11] = vArrayAssessmentType[11] ::"Mixed-Qualification" then begin
                                if vArrayMomento[11] <> '' then begin
                                    vText[11] := ValidateAssessmentMixed(11, vText[11]);
                                    InsertAssessment(Rec."Student Code No.", Rec."Class No.", 11, vText[11]);
                                end;

                            end else begin
                                if vArrayMomento[11] <> '' then begin
                                    vText[11] := Format(ValidateAssessmentQuant(11, vText[11]));
                                    InsertAssessment(Rec."Student Code No.", Rec."Class No.", 11, vText[11]);
                                end;
                            end;
                            vText11OnAfterValidate;
                        end;
                    }
                    field(Txt12; vText[12])
                    {
                        ApplicationArea = Basic, Suite;
                        CaptionClass = '1,5,,' + getCaptionLabel(12);
                        Editable = Txt12Editable;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            if vArrayMomento[12] <> '' then begin
                                vText[12] := LookupFunction(12);
                                InsertAssessment(Rec."Student Code No.", Rec."Class No.", 12, vText[12]);
                            end;
                        end;

                        trigger OnValidate()
                        begin
                            ValidateAssessmentQualitative(12, vText[12]);

                            if vArrayAssessmentType[12] = vArrayAssessmentType[12] ::"Mixed-Qualification" then begin
                                if vArrayMomento[12] <> '' then begin
                                    vText[12] := ValidateAssessmentMixed(12, vText[12]);
                                    InsertAssessment(Rec."Student Code No.", Rec."Class No.", 12, vText[12]);
                                end;

                            end else begin
                                if vArrayMomento[12] <> '' then begin
                                    vText[12] := Format(ValidateAssessmentQuant(12, vText[12]));
                                    InsertAssessment(Rec."Student Code No.", Rec."Class No.", 12, vText[12]);
                                end;
                            end;
                            vText12OnAfterValidate;
                        end;
                    }
                    field(Txt13; vText[13])
                    {
                        ApplicationArea = Basic, Suite;
                        CaptionClass = '1,5,,' + getCaptionLabel(13);
                        Editable = Txt13Editable;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            if vArrayMomento[13] <> '' then begin
                                vText[13] := LookupFunction(13);
                                InsertAssessment(Rec."Student Code No.", Rec."Class No.", 13, vText[13]);
                            end;
                        end;

                        trigger OnValidate()
                        begin
                            ValidateAssessmentQualitative(13, vText[13]);

                            if vArrayAssessmentType[13] = vArrayAssessmentType[13] ::"Mixed-Qualification" then begin
                                if vArrayMomento[13] <> '' then begin
                                    vText[13] := ValidateAssessmentMixed(13, vText[13]);
                                    InsertAssessment(Rec."Student Code No.", Rec."Class No.", 13, vText[13]);
                                end;

                            end else begin
                                if vArrayMomento[13] <> '' then begin
                                    vText[13] := Format(ValidateAssessmentQuant(13, vText[13]));
                                    InsertAssessment(Rec."Student Code No.", Rec."Class No.", 13, vText[13]);
                                end;

                            end;
                            vText13OnAfterValidate;
                        end;
                    }
                    field(Txt14; vText[14])
                    {
                        ApplicationArea = Basic, Suite;
                        CaptionClass = '1,5,,' + getCaptionLabel(14);
                        Editable = Txt14Editable;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            if vArrayMomento[14] <> '' then begin
                                vText[14] := LookupFunction(14);
                                InsertAssessment(Rec."Student Code No.", Rec."Class No.", 14, vText[14]);
                            end;
                        end;

                        trigger OnValidate()
                        begin
                            ValidateAssessmentQualitative(14, vText[14]);

                            if vArrayAssessmentType[14] = vArrayAssessmentType[14] ::"Mixed-Qualification" then begin
                                if vArrayMomento[14] <> '' then begin
                                    vText[14] := ValidateAssessmentMixed(14, vText[14]);
                                    InsertAssessment(Rec."Student Code No.", Rec."Class No.", 14, vText[14]);
                                end;

                            end else begin
                                if vArrayMomento[14] <> '' then begin
                                    vText[14] := Format(ValidateAssessmentQuant(14, vText[14]));
                                    InsertAssessment(Rec."Student Code No.", Rec."Class No.", 14, vText[14]);
                                end;


                            end;
                            vText14OnAfterValidate;
                        end;
                    }
                    field(Txt15; vText[15])
                    {
                        ApplicationArea = Basic, Suite;
                        CaptionClass = '1,5,,' + getCaptionLabel(15);
                        Editable = Txt15Editable;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            if vArrayMomento[15] <> '' then begin
                                vText[15] := LookupFunction(15);
                                InsertAssessment(Rec."Student Code No.", Rec."Class No.", 15, vText[15]);
                            end;
                        end;

                        trigger OnValidate()
                        begin
                            ValidateAssessmentQualitative(15, vText[15]);


                            if vArrayAssessmentType[15] = vArrayAssessmentType[15] ::"Mixed-Qualification" then begin
                                if vArrayMomento[15] <> '' then begin
                                    vText[15] := ValidateAssessmentMixed(15, vText[15]);
                                    InsertAssessment(Rec."Student Code No.", Rec."Class No.", 15, vText[15]);
                                end;

                            end else begin
                                if vArrayMomento[15] <> '' then begin
                                    vText[15] := Format(ValidateAssessmentQuant(15, vText[15]));
                                    InsertAssessment(Rec."Student Code No.", Rec."Class No.", 15, vText[15]);
                                end;


                            end;
                            vText15OnAfterValidate;
                        end;
                    }
                }
            }
            group(Control1000000000)
            {
                ShowCaption = false;
                field("Student Code No."; Rec."Student Code No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("rStudents.Name"; rStudents.Name)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(varMixedClassification; varMixedClassification)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Filter Mixed Ratings';

                    trigger OnValidate()
                    begin
                        varMixedClassificationOnPush;
                    end;
                }
                field(ExistCommentsSubjects; ExistCommentsSubjects)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Student with comments for selected subject for the Active Moment(s)';
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field(ExistCommentsGlobal; ExistCommentsGlobal)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Student with comments for the Active Moment(s)';
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
            }
            group(Criteria)
            {
                Caption = 'Criteria';
                field(VC2; varClass)
                {
                    Caption = 'Class';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        rClass.Reset;
                        rClass.SetCurrentKey("School Year", "Schooling Year");
                        rClass.SetFilter("School Year", cStudentsRegistration.GetShoolYearActiveClosing);
                        if rClass.Find('-') then begin
                            if PAGE.RunModal(PAGE::"Class List", rClass) = ACTION::LookupOK then begin
                                varClass := rClass.Class;
                                VarSchoolYear := rClass."School Year";
                                varSchoolingYear := rClass."Schooling Year";
                                VarStudyPlanCode := rClass."Study Plan Code";

                            end;
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        rClass.Reset;
                        rClass.SetFilter("School Year", cStudentsRegistration.GetShoolYearActiveClosing);
                        rClass.SetRange(Class, varClass);
                        if rClass.Find('-') then begin
                            VarSchoolYear := rClass."School Year";
                            varSchoolingYear := rClass."Schooling Year";
                            VarStudyPlanCode := rClass."Study Plan Code";
                        end else
                            Error(text006);
                    end;
                }
                field(VS2; VarSubjects)
                {
                    Caption = 'Subjects';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if varClass <> '' then begin
                            if VarType = VarType::Simple then begin
                                rStudyPlanLines.Reset;
                                rStudyPlanLines.SetFilter(Code, VarStudyPlanCode);
                                rStudyPlanLines.SetFilter("School Year", VarSchoolYear);
                                rStudyPlanLines.SetFilter("Schooling Year", varSchoolingYear);
                                if rStudyPlanLines.Find('-') then begin
                                    if PAGE.RunModal(PAGE::"List Subjects", rStudyPlanLines) = ACTION::LookupOK then begin
                                        VarSubjects := rStudyPlanLines."Subject Code";
                                        UpdateForm;
                                    end;
                                end;
                            end else begin

                                rCourseLines.Reset;
                                rCourseLines.SetRange(Code, VarStudyPlanCode);
                                if rCourseLines.Find('-') then begin
                                    if PAGE.RunModal(PAGE::"List Course Lines", rCourseLines) = ACTION::LookupOK then begin
                                        VarSubjects := rCourseLines."Subject Code";
                                        UpdateForm;
                                    end;
                                end;
                            end;
                            Rec.SetRange(Class, varClass);
                            Rec.SetRange("Subjects Code", VarSubjects);
                            CurrPage.Update(true);
                        end else
                            Error(text007);
                    end;

                    trigger OnValidate()
                    begin
                        if varClass <> '' then begin
                            Rec.SetRange(Class, varClass);
                            Rec.SetRange("Subjects Code", VarSubjects);
                        end else
                            Error(text007);
                        VarSubjectsC1110020OnAfterVali;
                    end;
                }
                field(varMomentCode; varMomentCode)
                {
                    Caption = 'Moment Code';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        rSettingRatings.Reset;
                        rSettingRatings.SetRange("School Year", VarSchoolYear);
                        rSettingRatings.SetRange("Schooling Year", varSchoolingYear);
                        rSettingRatings.SetRange("Subject Code", VarSubjects);
                        rSettingRatings.SetRange("Study Plan Code", VarStudyPlanCode);
                        rSettingRatings.SetRange(Type, rSettingRatings.Type::Header);
                        if rSettingRatings.Find('-') then
                            if PAGE.RunModal(PAGE::"Setting Ratings Subjects List", rSettingRatings) = ACTION::LookupOK then
                                varMomentCode := rSettingRatings."Moment Code";

                        GetSettingRatingsLines(varMomentCode);

                        GetSubForm;
                    end;
                }
                field(varMixedClaCriterion; varMixedClaCriterion)
                {
                    Caption = 'Filter Mixed Ratings';

                    trigger OnValidate()
                    begin

                        CurrPage.SubfomrAssessementStudents.PAGE.MixedGrade(varMixedClaCriterion);
                        CurrPage.SubfomrAssessementStudents.PAGE.FormUpdate;
                        varMixedClaCriterionOnAfterVal;
                    end;
                }
                repeater(Control1110042)
                {
                    Editable = false;
                    ShowCaption = false;
                    field(CN2; Rec."Class No.")
                    {
                    }
                    field(SN2; rStudents.Name)
                    {
                        Caption = 'Name';
                    }
                }
                part(SubfomrAssessementStudents; "Assessement Students")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Global Remarks")
            {
                Caption = '&Global Remarks';
                Image = SetupList;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    varTypeButtonEdit := true;
                    if (varClass <> '') then begin

                        fRemarksWizard.GetInformation(Rec."Student Code No.", Rec."School Year", Rec.Class, Rec."Schooling Year", Rec."Study Plan Code", '', '',
                                                    Rec."Class No.", VarType, varTypeButtonEdit);
                        fRemarksWizard.Run;
                    end;
                end;
            }
            action("&Remarks")
            {
                Caption = '&Remarks';
                Image = Setup;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    varTypeButtonEdit := true;

                    if (varClass <> '') and (VarSubjects <> '') then begin

                        fRemarksWizard.GetInformation(Rec."Student Code No.", Rec."School Year", Rec.Class, Rec."Schooling Year", Rec."Study Plan Code", Rec."Subjects Code", '',
                                                    Rec."Class No.", VarType, varTypeButtonEdit);
                        fRemarksWizard.Run;
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin

        if rStudents.Get(Rec."Student Code No.") then;

        InsertColunm;

        EditableFuction;

        ExistCommentsGlobal := UpdateCommentsVAR(true);
        ExistCommentsSubjects := UpdateCommentsVAR(false);
        OnAfterGetCurrRecord2;
    end;

    trigger OnInit()
    begin
        Txt15Editable := true;
        Txt14Editable := true;
        Txt13Editable := true;
        Txt12Editable := true;
        Txt11Editable := true;
        Txt10Editable := true;
        Txt9Editable := true;
        Txt8Editable := true;
        Txt7Editable := true;
        Txt6Editable := true;
        Txt5Editable := true;
        Txt4Editable := true;
        Txt3Editable := true;
        Txt2Editable := true;
        Txt1Editable := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        OnAfterGetCurrRecord2;
    end;

    trigger OnOpenPage()
    begin
        if cUserEducation.GetEducationFilter(UserId) <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", cUserEducation.GetEducationFilter(UserId));
            Rec.FilterGroup(0);
        end;



        Clear(varClass);
        Clear(VarSubjects);


        Rec.SetRange(Class, varClass);
        Rec.SetRange("Subjects Code", VarSubjects);


        rAssessementStudents.Reset;
        rAssessementStudents.SetRange("Moment Code", '');
        CurrPage.SubfomrAssessementStudents.PAGE.SetTableView(rAssessementStudents);

        CurrPage.SubfomrAssessementStudents.PAGE.FormUpdate;
    end;

    var
        varClass: Code[20];
        VarSubjects: Code[10];
        VarSchoolYear: Code[9];
        varSchoolingYear: Code[10];
        VarStudyPlanCode: Code[10];
        vText: array[15] of Text[250];
        varName: Text[100];
        vArrayMomento: array[15] of Text[30];
        vArrayCodMomento: array[15] of Text[30];
        vArrayType: array[15] of Option " ",Interim,Final,Test,Others;
        vArrayAssessmentType: array[15] of Option " ",Qualitative,Quantitative,"None Qualification","Mixed-Qualification";
        vArrayAssessmentCode: array[15] of Code[20];
        text001: Label 'Inserting class is mandatory.';
        text002: Label 'Insert subject is mandatory.';
        text003: Label 'Grade should be a number.';
        text004: Label 'Grade should be between %1 and %2.';
        vArrayActiveMoment: array[15] of Boolean;
        indx: Integer;
        rStudents: Record Students;
        rClass: Record Class;
        cStudentsRegistration: Codeunit "Students Registration";
        rStudyPlanLines: Record "Study Plan Lines";
        rMomentsAssessment: Record "Moments Assessment";
        rSettingRatings: Record "Setting Ratings";
        rRankGroup: Record "Rank Group";
        text005: Label 'There is no code inserted.';
        varMomentCode: Code[20];
        rAssessementStudents: Record "Assessement Students";
        LineNo: Integer;
        rRegistrationSubjects: Record "Registration Subjects";
        varClassification: Text[30];
        varMixedClassification: Boolean;
        varMixedClaCriterion: Boolean;
        text006: Label 'Class is nonexistent.';
        text007: Label 'Class must not be blank.';
        cUserEducation: Codeunit "User Education";
        ExistCommentsSubjects: Boolean;
        ExistCommentsGlobal: Boolean;
        VarType: Option Simple,Multi;
        rCourseLines: Record "Course Lines";
        varTypeButtonEdit: Boolean;
        [InDataSet]
        Txt1Editable: Boolean;
        [InDataSet]
        Txt2Editable: Boolean;
        [InDataSet]
        Txt3Editable: Boolean;
        [InDataSet]
        Txt4Editable: Boolean;
        [InDataSet]
        Txt5Editable: Boolean;
        [InDataSet]
        Txt6Editable: Boolean;
        [InDataSet]
        Txt7Editable: Boolean;
        [InDataSet]
        Txt8Editable: Boolean;
        [InDataSet]
        Txt9Editable: Boolean;
        [InDataSet]
        Txt10Editable: Boolean;
        [InDataSet]
        Txt11Editable: Boolean;
        [InDataSet]
        Txt12Editable: Boolean;
        [InDataSet]
        Txt13Editable: Boolean;
        [InDataSet]
        Txt14Editable: Boolean;
        [InDataSet]
        Txt15Editable: Boolean;
        fRemarksWizard: Page "Remarks Wizard";

    //[Scope('OnPrem')]
    procedure getCaptionLabel(label: Integer) out: Text[30]
    begin

        exit(vArrayMomento[label]);
    end;

    //[Scope('OnPrem')]
    procedure BuildMoments()
    begin


        Clear(vArrayMomento);
        Clear(vArrayCodMomento);
        Clear(vArrayType);
        indx := 0;

        rMomentsAssessment.Reset;
        rMomentsAssessment.SetCurrentKey("Schooling Year", "Sorting ID");
        rMomentsAssessment.SetRange("School Year", VarSchoolYear);
        rMomentsAssessment.SetRange("Schooling Year", varSchoolingYear);
        if rMomentsAssessment.Find('-') then begin
            repeat
                indx := indx + 1;
                vArrayMomento[indx] := rMomentsAssessment.Description;
                vArrayCodMomento[indx] := rMomentsAssessment."Moment Code";
                vArrayActiveMoment[indx] := rMomentsAssessment.Active;
                vArrayActiveMoment[indx] := false;
                vArrayType[indx] := rMomentsAssessment."Evaluation Moment";
                GetTypeAssessment(rMomentsAssessment, indx);

            until rMomentsAssessment.Next = 0;
        end;
    end;

    //[Scope('OnPrem')]
    procedure InsertAssessment(inStudentCode: Code[10]; inClassNo: Integer; inIndex: Integer; inText: Text[250])
    var
        rAssessingStudents: Record "Assessing Students";
    begin

        if not vArrayActiveMoment[inIndex] then begin
            vText[inIndex] := '';
            exit;
        end;

        if rAssessingStudents.Get(varClass, VarSchoolYear, varSchoolingYear, VarSubjects,
                                 VarStudyPlanCode, inStudentCode, vArrayCodMomento[inIndex]) then begin

            if vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::Quantitative then
                Evaluate(rAssessingStudents.Grade, inText);

            if (vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::Qualitative) then
                rAssessingStudents."Qualitative Grade" := inText;

            if (vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::"Mixed-Qualification") then begin
                if varMixedClassification then begin
                    rAssessingStudents."Qualitative Grade" := varClassification;
                    Evaluate(rAssessingStudents.Grade, inText);
                end else begin
                    if not Evaluate(rAssessingStudents.Grade, varClassification) then
                        rAssessingStudents.Grade := 0;
                    rAssessingStudents."Qualitative Grade" := inText;
                end;
            end;

            rAssessingStudents.Modify(true);

        end else begin
            rAssessingStudents.Init;
            rAssessingStudents.Class := varClass;
            rAssessingStudents."School Year" := VarSchoolYear;
            rAssessingStudents."Schooling Year" := varSchoolingYear;
            rAssessingStudents.Subject := VarSubjects;
            rAssessingStudents."Study Plan Code" := VarStudyPlanCode;
            rAssessingStudents."Student Code No." := inStudentCode;
            rAssessingStudents."Moment Code" := vArrayCodMomento[inIndex];
            rAssessingStudents."Class No." := inClassNo;
            rAssessingStudents."Evaluation Moment" := vArrayType[inIndex];
            rAssessingStudents."Type Education" := VarType;
            if vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::Qualitative then
                rAssessingStudents."Qualitative Grade" := inText;
            if vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::Quantitative then
                Evaluate(rAssessingStudents.Grade, inText);

            if vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::"Mixed-Qualification" then begin
                Evaluate(rAssessingStudents.Grade, varClassification);
                rAssessingStudents."Qualitative Grade" := inText;
            end;


            rAssessingStudents.Insert(true);

        end;
    end;

    //[Scope('OnPrem')]
    procedure GetAssessment(inStudentCode: Code[10]; inClassNo: Integer; inIndex: Integer; inText: Text[250]) Out: Text[100]
    var
        rAssessingStudents: Record "Assessing Students";
    begin


        if rAssessingStudents.Get(varClass, VarSchoolYear, varSchoolingYear, VarSubjects,
                                 VarStudyPlanCode, inStudentCode, vArrayCodMomento[inIndex]) then begin

            if (vArrayCodMomento[inIndex] = 'CIF') or
               (vArrayCodMomento[inIndex] = 'CFD') or
               (vArrayCodMomento[inIndex] = 'EXN1') or
               (vArrayCodMomento[inIndex] = 'EXN2') then
                exit(Format(rAssessingStudents.Grade));

            if vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::Quantitative then
                exit(Format(rAssessingStudents.Grade));

            if (vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::Qualitative) then
                exit(rAssessingStudents."Qualitative Grade");

            if (vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::"Mixed-Qualification") then
                if varMixedClassification then
                    exit(Format(rAssessingStudents.Grade))
                else
                    exit(rAssessingStudents."Qualitative Grade");


        end else
            exit('');
    end;

    //[Scope('OnPrem')]
    procedure InsertColunm()
    var
        i: Integer;
    begin
        i := 0;

        repeat
            i += 1;
            if vArrayMomento[i] <> '' then
                vText[i] := GetAssessment(Rec."Student Code No.", Rec."Class No.", i, vText[i]);
        until i = 15
    end;

    //[Scope('OnPrem')]
    procedure UpdateForm()
    begin
        BuildMoments;
    end;

    //[Scope('OnPrem')]
    procedure GetTypeAssessment(pMomentsAssessment: Record "Moments Assessment"; inIndex: Integer)
    begin
        rSettingRatings.Reset;
        rSettingRatings.SetRange("Moment Code", pMomentsAssessment."Moment Code");
        rSettingRatings.SetRange(Type, rSettingRatings.Type::Header);
        rSettingRatings.SetRange("School Year", VarSchoolYear);
        rSettingRatings.SetRange("Schooling Year", varSchoolingYear);
        rSettingRatings.SetRange("Subject Code", VarSubjects);
        rSettingRatings.SetRange("Study Plan Code", VarStudyPlanCode);
        if rSettingRatings.FindFirst then begin
            if rRankGroup.Get(rSettingRatings."Assessment Code") then begin
                vArrayAssessmentType[inIndex] := rRankGroup."Evaluation Type";
                vArrayAssessmentCode[inIndex] := rRankGroup.Code;
            end else begin
                Clear(vArrayAssessmentType[inIndex]);
                Clear(vArrayAssessmentCode[inIndex]);
            end;
        end else begin
            Clear(vArrayAssessmentType[inIndex]);
            Clear(vArrayAssessmentCode[inIndex]);
        end;
    end;

    //[Scope('OnPrem')]
    procedure ValidateAssessmentQualitative(InIndex: Integer; inText: Text[250]) Out: Code[20]
    var
        rClassificationLevel: Record "Classification Level";
    begin
        if vArrayAssessmentType[InIndex] = vArrayAssessmentType[InIndex] ::Qualitative then begin
            rClassificationLevel.Reset;
            rClassificationLevel.SetRange("Classification Group Code", vArrayAssessmentCode[InIndex]);
            rClassificationLevel.SetFilter("Classification Level Code", inText);
            if rClassificationLevel.FindFirst then
                exit(rClassificationLevel."Classification Level Code")
            else
                Error(text005);
        end;
    end;

    //[Scope('OnPrem')]
    procedure LookupFunction(InIndex: Integer) Out: Code[20]
    var
        rClassificationLevel: Record "Classification Level";
    begin
        if (vArrayAssessmentType[InIndex] = vArrayAssessmentType[InIndex] ::Qualitative) then begin
            rClassificationLevel.Reset;
            rClassificationLevel.SetRange("Classification Group Code", vArrayAssessmentCode[InIndex]);
            if rClassificationLevel.Find('-') then begin
                if PAGE.RunModal(PAGE::"List Grades", rClassificationLevel) = ACTION::LookupOK then
                    exit(rClassificationLevel."Classification Level Code");
            end else
                exit(vText[InIndex]);

        end;


        if (vArrayAssessmentType[InIndex] = vArrayAssessmentType[InIndex] ::"Mixed-Qualification") then begin
            rClassificationLevel.Reset;
            rClassificationLevel.SetRange("Classification Group Code", vArrayAssessmentCode[InIndex]);
            if rClassificationLevel.Find('-') then begin
                if PAGE.RunModal(PAGE::"List Grades", rClassificationLevel) = ACTION::LookupOK then begin
                    if varMixedClassification then begin
                        varClassification := rClassificationLevel."Classification Level Code";
                        exit(Format(rClassificationLevel.Value))
                    end else begin
                        varClassification := Format(rClassificationLevel.Value);
                        exit(rClassificationLevel."Classification Level Code");
                    end;

                end else
                    exit(vText[InIndex]);
            end;
        end;

        exit(vText[InIndex]);
    end;

    //[Scope('OnPrem')]
    procedure ValidateAssessmentQuant(InIndex: Integer; InClassification: Text[250]) Out: Decimal
    var
        varClasification: Decimal;
        rClassificationLevel: Record "Classification Level";
    begin
        if vArrayAssessmentType[InIndex] = vArrayAssessmentType[InIndex] ::Quantitative then begin
            if InClassification <> '' then begin
                if not Evaluate(varClasification, InClassification) then
                    Error(text003);
                rClassificationLevel.Reset;
                rClassificationLevel.SetRange("Classification Group Code", vArrayAssessmentCode[InIndex]);
                if rClassificationLevel.FindFirst then begin
                    if (rClassificationLevel."Min Value" <= varClasification) and
                        (rClassificationLevel."Max Value" >= varClasification) then
                        exit(varClasification)
                    else
                        Error(text004, rClassificationLevel."Min Value", rClassificationLevel."Max Value");
                end;
            end else
                exit(0);
        end;
    end;

    //[Scope('OnPrem')]
    procedure GetSettingRatingsLines(pMoment: Code[20])
    var
        recLAssessementStudents: Record "Assessement Students";
    begin



        rRegistrationSubjects.Reset;
        rRegistrationSubjects.SetRange("School Year", VarSchoolYear);
        rRegistrationSubjects.SetRange("Schooling Year", varSchoolingYear);
        rRegistrationSubjects.SetRange("Subjects Code", VarSubjects);
        rRegistrationSubjects.SetRange(Class, varClass);
        rRegistrationSubjects.SetRange(Status, rRegistrationSubjects.Status::Subscribed);
        if rRegistrationSubjects.Find('-') then begin
            repeat
                LineNo := 0;
                rSettingRatings.Reset;
                rSettingRatings.SetRange("Moment Code", pMoment);
                rSettingRatings.SetRange(Type, rSettingRatings.Type::Lines);
                rSettingRatings.SetRange("School Year", VarSchoolYear);
                rSettingRatings.SetRange("Schooling Year", varSchoolingYear);
                rSettingRatings.SetRange("Subject Code", VarSubjects);
                rSettingRatings.SetRange("Study Plan Code", VarStudyPlanCode);
                if rSettingRatings.Find('-') then begin
                    repeat
                        LineNo += 10000;
                        rAssessementStudents.Reset;
                        rAssessementStudents.SetRange("Moment Code", pMoment);
                        rAssessementStudents.SetRange("School Year", VarSchoolYear);
                        rAssessementStudents.SetRange(Class, varClass);
                        rAssessementStudents.SetRange("Schooling Year", varSchoolingYear);
                        rAssessementStudents.SetRange("Subject Code", VarSubjects);
                        rAssessementStudents.SetRange("Student Code No.", rRegistrationSubjects."Student Code No.");
                        rAssessementStudents.SetRange("Line No.", LineNo);
                        if rAssessementStudents.Find('-') then begin
                            rAssessementStudents."Criterion 1" := rSettingRatings."Criterion 1";
                            rAssessementStudents."Criterion 2" := rSettingRatings."Criterion 2";
                            rAssessementStudents."Criterion 3" := rSettingRatings."Criterion 3";
                            rAssessementStudents."Assessment Code" := rSettingRatings."Assessment Code";
                            rAssessementStudents."Sorting ID" := rSettingRatings."Sorting ID";
                            rAssessementStudents.Modify;
                        end else begin
                            rAssessementStudents.Init;
                            rAssessementStudents."Moment Code" := pMoment;
                            rAssessementStudents."School Year" := VarSchoolYear;
                            rAssessementStudents."Schooling Year" := varSchoolingYear;
                            rAssessementStudents."Subject Code" := VarSubjects;
                            rAssessementStudents.Class := varClass;
                            rAssessementStudents."Student Code No." := rRegistrationSubjects."Student Code No.";
                            rAssessementStudents."Study Plan Code" := Rec."Study Plan Code";
                            rAssessementStudents."Line No." := LineNo;
                            rAssessementStudents.Description := rSettingRatings.Description;
                            rAssessementStudents."Criterion 1" := rSettingRatings."Criterion 1";
                            rAssessementStudents."Criterion 2" := rSettingRatings."Criterion 2";
                            rAssessementStudents."Criterion 3" := rSettingRatings."Criterion 3";
                            rAssessementStudents."Assessment Code" := rSettingRatings."Assessment Code";
                            if rMomentsAssessment.Get(pMoment, VarSchoolYear, varSchoolingYear) then
                                rAssessementStudents."Evaluation Moment" := rMomentsAssessment."Evaluation Moment";
                            rAssessementStudents."Sorting ID" := rSettingRatings."Sorting ID";
                            rAssessementStudents.Insert;
                        end;

                    until rSettingRatings.Next = 0;
                end;
            until rRegistrationSubjects.Next = 0;
        end;
    end;

    //[Scope('OnPrem')]
    procedure GetSubForm()
    begin
        rAssessementStudents.Reset;
        rAssessementStudents.SetRange("Moment Code", varMomentCode);
        rAssessementStudents.SetRange(Class, varClass);
        rAssessementStudents.SetRange("School Year", VarSchoolYear);
        rAssessementStudents.SetRange("Schooling Year", varSchoolingYear);
        rAssessementStudents.SetRange("Subject Code", VarSubjects);
        rAssessementStudents.SetRange("Student Code No.", Rec."Student Code No.");
        CurrPage.SubfomrAssessementStudents.PAGE.SetTableView(rAssessementStudents);
        CurrPage.SubfomrAssessementStudents.PAGE.FormUpdate;
    end;

    //[Scope('OnPrem')]
    procedure ValidateAssessmentMixed(InIndex: Integer; InClassification: Text[250]) Out: Text[30]
    var
        varLocalClasification: Decimal;
        rClassificationLevelMin: Record "Classification Level";
        rClassificationLevelMax: Record "Classification Level";
        VarMinValue: Decimal;
        VarMaxValue: Decimal;
        rClassificationLevel: Record "Classification Level";
    begin
        if vArrayAssessmentType[InIndex] = vArrayAssessmentType[InIndex] ::"Mixed-Qualification" then begin
            Clear(varClassification);
            if InClassification <> '' then begin
                if Evaluate(varLocalClasification, InClassification) then begin
                    rClassificationLevelMin.Reset;
                    rClassificationLevelMin.SetCurrentKey("Id Ordination");
                    rClassificationLevelMin.Ascending(true);
                    rClassificationLevelMin.SetRange("Classification Group Code", vArrayAssessmentCode[InIndex]);
                    if rClassificationLevelMin.FindFirst then
                        VarMinValue := rClassificationLevelMin."Min Value";

                    rClassificationLevelMax.Reset;
                    rClassificationLevelMax.SetCurrentKey("Id Ordination");
                    rClassificationLevelMax.Ascending(false);
                    rClassificationLevelMax.SetRange("Classification Group Code", vArrayAssessmentCode[InIndex]);
                    if rClassificationLevelMax.FindFirst then
                        VarMaxValue := rClassificationLevelMax."Max Value";

                    if (VarMinValue <= varLocalClasification) and
                        (VarMaxValue >= varLocalClasification) then begin
                        rClassificationLevel.Reset;
                        rClassificationLevel.SetRange("Classification Group Code", vArrayAssessmentCode[InIndex]);
                        rClassificationLevel.SetRange(Value, varLocalClasification);
                        if rClassificationLevel.FindFirst then begin
                            varClassification := Format(varLocalClasification);
                            exit(rClassificationLevel."Classification Level Code");
                        end;

                        rClassificationLevel.Reset;
                        rClassificationLevel.SetRange("Classification Group Code", vArrayAssessmentCode[InIndex]);
                        if rClassificationLevel.Find('-') then begin
                            repeat
                                if (rClassificationLevel."Min Value" <= varLocalClasification) and
                                   (rClassificationLevel."Max Value" >= varLocalClasification) then begin
                                    if varMixedClassification then begin
                                        varClassification := rClassificationLevel."Classification Level Code";
                                        exit(Format(varLocalClasification));
                                    end else begin
                                        varClassification := Format(varLocalClasification);
                                        exit(rClassificationLevel."Classification Level Code");
                                    end;
                                end;
                            until rClassificationLevel.Next = 0
                        end;

                    end else
                        Error(text004, VarMinValue, VarMaxValue);
                end;
                rClassificationLevel.Reset;
                rClassificationLevel.SetRange("Classification Group Code", vArrayAssessmentCode[InIndex]);
                rClassificationLevel.SetRange("Classification Level Code", InClassification);
                if rClassificationLevel.FindFirst then begin
                    if varMixedClassification then begin
                        varClassification := rClassificationLevel."Classification Level Code";
                        exit(Format(rClassificationLevel.Value));

                    end else begin
                        varClassification := Format(rClassificationLevel.Value);
                        exit(rClassificationLevel."Classification Level Code");
                    end;
                end else
                    Error(text005);

            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure EditableFuction()
    begin
        if (vArrayMomento[1] <> '') and (vArrayActiveMoment[1] = true) then
            Txt1Editable := true
        else
            Txt1Editable := false;

        if (vArrayMomento[2] <> '') and (vArrayActiveMoment[2] = true) then
            Txt2Editable := true
        else
            Txt2Editable := false;

        if (vArrayMomento[3] <> '') and (vArrayActiveMoment[3] = true) then
            Txt3Editable := true
        else
            Txt3Editable := false;

        if (vArrayMomento[4] <> '') and (vArrayActiveMoment[4] = true) then
            Txt4Editable := true
        else
            Txt4Editable := false;

        if (vArrayMomento[5] <> '') and (vArrayActiveMoment[5] = true) then
            Txt5Editable := true
        else
            Txt5Editable := false;

        if (vArrayMomento[6] <> '') and (vArrayActiveMoment[6] = true) then
            Txt6Editable := true
        else
            Txt6Editable := false;

        if (vArrayMomento[7] <> '') and (vArrayActiveMoment[7] = true) then
            Txt7Editable := true
        else
            Txt7Editable := false;

        if (vArrayMomento[8] <> '') and (vArrayActiveMoment[8] = true) then
            Txt8Editable := true
        else
            Txt8Editable := false;

        if (vArrayMomento[9] <> '') and (vArrayActiveMoment[9] = true) then
            Txt9Editable := true
        else
            Txt9Editable := false;

        if (vArrayMomento[10] <> '') and (vArrayActiveMoment[10] = true) then
            Txt10Editable := true
        else
            Txt10Editable := false;

        if (vArrayMomento[11] <> '') and (vArrayActiveMoment[11] = true) then
            Txt11Editable := true
        else
            Txt11Editable := false;

        if (vArrayMomento[12] <> '') and (vArrayActiveMoment[12] = true) then
            Txt12Editable := true
        else
            Txt12Editable := false;

        if (vArrayMomento[13] <> '') and (vArrayActiveMoment[13] = true) then
            Txt13Editable := true
        else
            Txt13Editable := false;

        if (vArrayMomento[14] <> '') and (vArrayActiveMoment[14] = true) then
            Txt14Editable := true
        else
            Txt14Editable := false;

        if (vArrayMomento[15] <> '') and (vArrayActiveMoment[15] = true) then
            Txt15Editable := true
        else
            Txt15Editable := false;
    end;

    //[Scope('OnPrem')]
    procedure UpdateCommentsVAR(IsGlobal: Boolean) ExitValue: Boolean
    var
        l_rMomentsAssessment: Record "Moments Assessment";
        l_rRemarks: Record Remarks;
    begin
        ExitValue := false;
        l_rMomentsAssessment.Reset;
        l_rMomentsAssessment.SetCurrentKey("Schooling Year", "Sorting ID");
        l_rMomentsAssessment.SetRange("School Year", VarSchoolYear);
        l_rMomentsAssessment.SetRange("Schooling Year", varSchoolingYear);
        l_rMomentsAssessment.SetRange(Active, true);
        if l_rMomentsAssessment.Find('-') then begin
            repeat
                if not ExitValue then begin
                    l_rRemarks.Reset;
                    l_rRemarks.SetRange(Class, Rec.Class);
                    l_rRemarks.SetRange("School Year", Rec."School Year");
                    l_rRemarks.SetRange("Schooling Year", Rec."Schooling Year");
                    l_rRemarks.SetRange("Study Plan Code", Rec."Study Plan Code");
                    l_rRemarks.SetRange("Student/Teacher Code No.", Rec."Student Code No.");
                    l_rRemarks.SetRange("Moment Code", l_rMomentsAssessment."Moment Code");
                    if not IsGlobal then
                        l_rRemarks.SetRange(Subject, VarSubjects)
                    else
                        l_rRemarks.SetFilter(Subject, '%1', '');
                    if l_rRemarks.FindFirst then
                        ExitValue := true;
                end;
            until l_rMomentsAssessment.Next = 0;
        end;

        exit(ExitValue);
    end;

    local procedure VarSubjectsC1102056012OnAfterV()
    begin

        CurrPage.Update(true);
    end;

    local procedure vText1OnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure vText2OnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure vText3OnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure vText4OnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure vText5OnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure vText6OnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure vText7OnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure vText8OnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure vText9OnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure vText10OnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure vText11OnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure vText12OnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure vText13OnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure vText14OnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure vText15OnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure varMixedClaCriterionOnAfterVal()
    begin
        CurrPage.Update;
    end;

    local procedure VarSubjectsC1110020OnAfterVali()
    begin

        CurrPage.Update(true);
    end;

    local procedure OnAfterGetCurrRecord2()
    begin
        xRec := Rec;
        if varMomentCode <> '' then
            GetSubForm;
    end;

    local procedure varMixedClassificationOnPush()
    begin
        CurrPage.Update;
    end;
}

#pragma implicitwith restore

