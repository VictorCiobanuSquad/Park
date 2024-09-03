#pragma implicitwith disable
page 52960 "Assign Assessments"
{
    Caption = 'Assign Assessments';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    Permissions = TableData "Assessing Students" = rimd,
                  TableData "Assessing Students Final" = rimd;
    SourceTable = "Assign Assessments Buffer";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(varClass; varClass)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Class';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        vPermission: Boolean;
                        tempClass: Record Class temporary;
                    begin

                        Clear(tempClass);
                        cPermissions.ClassFilter(tempClass, 1);

                        if tempClass.FindSet then begin
                            if PAGE.RunModal(PAGE::"Class List", tempClass) = ACTION::LookupOK then begin
                                varClass := tempClass.Class;
                                varSchoolYear := tempClass."School Year";
                                varSchoolingYear := tempClass."Schooling Year";
                                varStudyPlanCode := tempClass."Study Plan Code";
                                VarType := tempClass.Type;
                                varRespCenter := tempClass."Responsibility Center";
                                varSubjects := '';

                                DeleteBuffer;
                                InitTempTable;
                                CurrPage.Update(false);

                                TestMoments;

                                //Ir buscar o Codigo dos Averbamentos
                                rAssessmentConfig.Reset;
                                if tempClass.Type = tempClass.Type::Simple then
                                    rAssessmentConfig.SetRange(rAssessmentConfig."School Year", tempClass."School Year");
                                rAssessmentConfig.SetRange(rAssessmentConfig.Type, tempClass.Type);
                                rAssessmentConfig.SetRange(rAssessmentConfig."Study Plan Code", tempClass."Study Plan Code");
                                rAssessmentConfig.SetRange(rAssessmentConfig."Country/Region Code", tempClass."Country/Region Code");
                                if rAssessmentConfig.FindFirst then
                                    ActualAnnotationCode := rAssessmentConfig."Annotation Code";


                            end;
                        end else
                            Error(Text0009);
                    end;

                    trigger OnValidate()
                    begin
                        varClassOnAfterValidate;
                    end;
                }
                field(varSubjects; varSubjects)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Subjects';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        rSubject: Record Subjects;
                        TempStudyPlanLines: Record "Study Plan Lines" temporary;
                        TempCourseLines: Record "Course Lines" temporary;
                        auxSubjects: Code[10];
                    begin
                        if varClass <> '' then begin
                            auxSubjects := varSubjects;
                            if VarType = VarType::Simple then begin
                                Clear(TempStudyPlanLines);
                                cPermissions.SubjectFilter(VarType, varSchoolYear, varClass, varStudyPlanCode, varSchoolingYear,
                                                           TempStudyPlanLines, TempCourseLines, 1);
                                if TempStudyPlanLines.FindSet then begin
                                    if PAGE.RunModal(PAGE::"List Subjects", TempStudyPlanLines) = ACTION::LookupOK then begin
                                        varSubjects := TempStudyPlanLines."Subject Code";
                                        BuildMoments;
                                        TestSettingRatings;
                                        ActualObservationCode := TempStudyPlanLines.Observations;
                                        UpdateForm;
                                    end;
                                end;
                            end else begin
                                //multi
                                Clear(TempCourseLines);
                                cPermissions.SubjectFilter(VarType, varSchoolYear, varClass, varStudyPlanCode, varSchoolingYear,
                                                           TempStudyPlanLines, TempCourseLines, 1);
                                if TempCourseLines.FindSet then begin
                                    if PAGE.RunModal(PAGE::"List Course Lines", TempCourseLines) = ACTION::LookupOK then begin
                                        varSubjects := TempCourseLines."Subject Code";
                                        BuildMoments;
                                        TestSettingRatings;
                                        ActualObservationCode := TempCourseLines.Observations;
                                        UpdateForm;
                                    end;
                                end;

                            end;
                            if varSubjects <> auxSubjects then begin
                                ApplyFilter(varClass, varSubjects, varRespCenter, varSchoolYear, varSchoolingYear, varStudyPlanCode);
                                InitTempTable;
                                CurrPage.Update(false);

                            end;
                        end else
                            Error(Text0007);
                    end;

                    trigger OnValidate()
                    begin
                        varSubjectsOnAfterValidate;
                    end;
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
            }
            repeater(Tablebox1)
            {
                IndentationColumn = TextIndent;
                IndentationControls = Text;
                ShowAsTree = true;
                field("Class No."; Rec."Class No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Text; Rec.Text)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Txt1; vText[1])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(1);
                    Editable = Txt1Editable;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if VArrayMomActive[1] then begin
                            if vArrayMomento[1] <> '' then begin
                                GetTypeAssessment(1);
                                vText[1] := LookupFunction(1);
                                InsertAssessment(Rec."Student Code No.", Rec."Class No.", 1, vText[1], Rec."Sub-Subject Code");
                            end;
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        if vText[1] <> '' then begin

                            if VArrayMomActive[1] then begin
                                GetTypeAssessment(1);

                                if vArrayAssessmentType[1] = vArrayAssessmentType[1] ::Qualitative then begin
                                    ValidateAssessmentQualitative(1, vText[1]);
                                    InsertAssessment(Rec."Student Code No.", Rec."Class No.", 1, vText[1], Rec."Sub-Subject Code");
                                end;


                                if vArrayAssessmentType[1] = vArrayAssessmentType[1] ::"Mixed-Qualification" then begin
                                    if vArrayMomento[1] <> '' then begin
                                        vText[1] := ValidateAssessmentMixed(1, vText[1]);
                                        InsertAssessment(Rec."Student Code No.", Rec."Class No.", 1, vText[1], Rec."Sub-Subject Code");
                                    end;
                                end;
                                if vArrayAssessmentType[1] = vArrayAssessmentType[1] ::Quantitative then begin
                                    if vArrayMomento[1] <> '' then begin
                                        vText[1] := Format(ValidateAssessmentQuant(1, vText[1]));
                                        InsertAssessment(Rec."Student Code No.", Rec."Class No.", 1, vText[1], Rec."Sub-Subject Code");
                                    end;
                                end;
                            end;

                        end else
                            Rec.DeleteAssessignStudents(varClass, varSubjects, varRespCenter, varSchoolYear, varSchoolingYear, varStudyPlanCode,
                                                    Rec."Student Code No.", vArrayCodMomento[1], Rec."Sub-Subject Code");
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
                        if VArrayMomActive[2] then begin
                            if vArrayMomento[2] <> '' then begin
                                GetTypeAssessment(2);
                                vText[2] := LookupFunction(2);
                                InsertAssessment(Rec."Student Code No.", Rec."Class No.", 2, vText[2], Rec."Sub-Subject Code");
                            end;
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        if vText[2] <> '' then begin

                            if VArrayMomActive[2] then begin
                                GetTypeAssessment(2);

                                if vArrayAssessmentType[2] = vArrayAssessmentType[2] ::Qualitative then begin
                                    ValidateAssessmentQualitative(2, vText[2]);
                                    InsertAssessment(Rec."Student Code No.", Rec."Class No.", 2, vText[2], Rec."Sub-Subject Code");
                                end;


                                if vArrayAssessmentType[2] = vArrayAssessmentType[2] ::"Mixed-Qualification" then begin
                                    if vArrayMomento[2] <> '' then begin
                                        vText[2] := ValidateAssessmentMixed(2, vText[2]);
                                        InsertAssessment(Rec."Student Code No.", Rec."Class No.", 2, vText[2], Rec."Sub-Subject Code");
                                    end;
                                end;
                                if vArrayAssessmentType[2] = vArrayAssessmentType[2] ::Quantitative then begin
                                    if vArrayMomento[2] <> '' then begin
                                        vText[2] := Format(ValidateAssessmentQuant(2, vText[2]));
                                        InsertAssessment(Rec."Student Code No.", Rec."Class No.", 2, vText[2], Rec."Sub-Subject Code");
                                    end;
                                end;
                            end;

                        end else
                            Rec.DeleteAssessignStudents(varClass, varSubjects, varRespCenter, varSchoolYear, varSchoolingYear, varStudyPlanCode,
                                                    Rec."Student Code No.", vArrayCodMomento[2], Rec."Sub-Subject Code");
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
                        if VArrayMomActive[3] then begin
                            if vArrayMomento[3] <> '' then begin
                                GetTypeAssessment(3);
                                vText[3] := LookupFunction(3);
                                InsertAssessment(Rec."Student Code No.", Rec."Class No.", 3, vText[3], Rec."Sub-Subject Code");
                            end;
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        if vText[3] <> '' then begin

                            if VArrayMomActive[3] then begin
                                GetTypeAssessment(3);

                                if vArrayAssessmentType[3] = vArrayAssessmentType[3] ::Qualitative then begin
                                    ValidateAssessmentQualitative(3, vText[3]);
                                    InsertAssessment(Rec."Student Code No.", Rec."Class No.", 3, vText[3], Rec."Sub-Subject Code");
                                end;


                                if vArrayAssessmentType[3] = vArrayAssessmentType[3] ::"Mixed-Qualification" then begin
                                    if vArrayMomento[3] <> '' then begin
                                        vText[3] := ValidateAssessmentMixed(3, vText[3]);
                                        InsertAssessment(Rec."Student Code No.", Rec."Class No.", 3, vText[3], Rec."Sub-Subject Code");
                                    end;
                                end;
                                if vArrayAssessmentType[3] = vArrayAssessmentType[3] ::Quantitative then begin
                                    if vArrayMomento[3] <> '' then begin
                                        vText[3] := Format(ValidateAssessmentQuant(3, vText[3]));
                                        InsertAssessment(Rec."Student Code No.", Rec."Class No.", 3, vText[3], Rec."Sub-Subject Code");
                                    end;
                                end;
                            end;

                        end else
                            Rec.DeleteAssessignStudents(varClass, varSubjects, varRespCenter, varSchoolYear, varSchoolingYear, varStudyPlanCode,
                                                    Rec."Student Code No.", vArrayCodMomento[3], Rec."Sub-Subject Code");
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
                        if VArrayMomActive[4] then begin
                            if vArrayMomento[4] <> '' then begin
                                GetTypeAssessment(4);
                                vText[4] := LookupFunction(4);
                                InsertAssessment(Rec."Student Code No.", Rec."Class No.", 4, vText[4], Rec."Sub-Subject Code");
                            end;
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        if vText[4] <> '' then begin

                            if VArrayMomActive[4] then begin
                                GetTypeAssessment(4);

                                if vArrayAssessmentType[4] = vArrayAssessmentType[4] ::Qualitative then begin
                                    ValidateAssessmentQualitative(4, vText[4]);
                                    InsertAssessment(Rec."Student Code No.", Rec."Class No.", 4, vText[4], Rec."Sub-Subject Code");
                                end;


                                if vArrayAssessmentType[4] = vArrayAssessmentType[4] ::"Mixed-Qualification" then begin
                                    if vArrayMomento[4] <> '' then begin
                                        vText[4] := ValidateAssessmentMixed(4, vText[4]);
                                        InsertAssessment(Rec."Student Code No.", Rec."Class No.", 4, vText[4], Rec."Sub-Subject Code");
                                    end;
                                end;
                                if vArrayAssessmentType[4] = vArrayAssessmentType[4] ::Quantitative then begin
                                    if vArrayMomento[4] <> '' then begin
                                        vText[4] := Format(ValidateAssessmentQuant(4, vText[4]));
                                        InsertAssessment(Rec."Student Code No.", Rec."Class No.", 4, vText[4], Rec."Sub-Subject Code");
                                    end;
                                end;
                            end;

                        end else
                            Rec.DeleteAssessignStudents(varClass, varSubjects, varRespCenter, varSchoolYear, varSchoolingYear, varStudyPlanCode,
                                                    Rec."Student Code No.", vArrayCodMomento[4], Rec."Sub-Subject Code");
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
                        if VArrayMomActive[5] then begin
                            if vArrayMomento[5] <> '' then begin
                                GetTypeAssessment(5);
                                vText[5] := LookupFunction(5);
                                InsertAssessment(Rec."Student Code No.", Rec."Class No.", 5, vText[5], Rec."Sub-Subject Code");
                            end;
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        if vText[5] <> '' then begin


                            if VArrayMomActive[5] then begin
                                GetTypeAssessment(5);

                                if vArrayAssessmentType[5] = vArrayAssessmentType[5] ::Qualitative then begin
                                    ValidateAssessmentQualitative(5, vText[5]);
                                    InsertAssessment(Rec."Student Code No.", Rec."Class No.", 5, vText[5], Rec."Sub-Subject Code");
                                end;


                                if vArrayAssessmentType[5] = vArrayAssessmentType[5] ::"Mixed-Qualification" then begin
                                    if vArrayMomento[5] <> '' then begin
                                        vText[5] := ValidateAssessmentMixed(5, vText[5]);
                                        InsertAssessment(Rec."Student Code No.", Rec."Class No.", 5, vText[5], Rec."Sub-Subject Code");
                                    end;
                                end;
                                if vArrayAssessmentType[5] = vArrayAssessmentType[5] ::Quantitative then begin
                                    if vArrayMomento[5] <> '' then begin
                                        vText[5] := Format(ValidateAssessmentQuant(5, vText[5]));
                                        InsertAssessment(Rec."Student Code No.", Rec."Class No.", 5, vText[5], Rec."Sub-Subject Code");
                                    end;
                                end;
                            end;

                        end else
                            Rec.DeleteAssessignStudents(varClass, varSubjects, varRespCenter, varSchoolYear, varSchoolingYear, varStudyPlanCode,
                                                    Rec."Student Code No.", vArrayCodMomento[5], Rec."Sub-Subject Code");
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
                        if VArrayMomActive[6] then begin
                            if vArrayMomento[6] <> '' then begin
                                GetTypeAssessment(6);
                                vText[6] := LookupFunction(6);
                                InsertAssessment(Rec."Student Code No.", Rec."Class No.", 6, vText[6], Rec."Sub-Subject Code");
                            end;
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        if vText[6] <> '' then begin


                            if VArrayMomActive[6] then begin
                                GetTypeAssessment(6);

                                if vArrayAssessmentType[6] = vArrayAssessmentType[6] ::Qualitative then begin
                                    ValidateAssessmentQualitative(6, vText[6]);
                                    InsertAssessment(Rec."Student Code No.", Rec."Class No.", 6, vText[6], Rec."Sub-Subject Code");
                                end;


                                if vArrayAssessmentType[6] = vArrayAssessmentType[6] ::"Mixed-Qualification" then begin
                                    if vArrayMomento[6] <> '' then begin
                                        vText[6] := ValidateAssessmentMixed(6, vText[6]);
                                        InsertAssessment(Rec."Student Code No.", Rec."Class No.", 6, vText[6], Rec."Sub-Subject Code");
                                    end;
                                end;
                                if vArrayAssessmentType[6] = vArrayAssessmentType[6] ::Quantitative then begin
                                    if vArrayMomento[6] <> '' then begin
                                        vText[6] := Format(ValidateAssessmentQuant(6, vText[6]));
                                        InsertAssessment(Rec."Student Code No.", Rec."Class No.", 6, vText[6], Rec."Sub-Subject Code");
                                    end;
                                end;
                            end;

                        end else
                            Rec.DeleteAssessignStudents(varClass, varSubjects, varRespCenter, varSchoolYear, varSchoolingYear, varStudyPlanCode,
                                                    Rec."Student Code No.", vArrayCodMomento[6], Rec."Sub-Subject Code");
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
                        if VArrayMomActive[7] then begin
                            if vArrayMomento[7] <> '' then begin
                                GetTypeAssessment(7);
                                vText[7] := LookupFunction(7);
                                InsertAssessment(Rec."Student Code No.", Rec."Class No.", 7, vText[7], Rec."Sub-Subject Code");
                            end;
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        if vText[7] <> '' then begin


                            if VArrayMomActive[7] then begin
                                GetTypeAssessment(7);

                                if vArrayAssessmentType[7] = vArrayAssessmentType[7] ::Qualitative then begin
                                    ValidateAssessmentQualitative(7, vText[7]);
                                    InsertAssessment(Rec."Student Code No.", Rec."Class No.", 7, vText[7], Rec."Sub-Subject Code");
                                end;


                                if vArrayAssessmentType[7] = vArrayAssessmentType[7] ::"Mixed-Qualification" then begin
                                    if vArrayMomento[7] <> '' then begin
                                        vText[7] := ValidateAssessmentMixed(7, vText[7]);
                                        InsertAssessment(Rec."Student Code No.", Rec."Class No.", 7, vText[7], Rec."Sub-Subject Code");
                                    end;
                                end;
                                if vArrayAssessmentType[7] = vArrayAssessmentType[7] ::Quantitative then begin
                                    if vArrayMomento[7] <> '' then begin
                                        vText[7] := Format(ValidateAssessmentQuant(7, vText[7]));
                                        InsertAssessment(Rec."Student Code No.", Rec."Class No.", 7, vText[7], Rec."Sub-Subject Code");
                                    end;
                                end;
                            end;

                        end else
                            Rec.DeleteAssessignStudents(varClass, varSubjects, varRespCenter, varSchoolYear, varSchoolingYear, varStudyPlanCode,
                                                    Rec."Student Code No.", vArrayCodMomento[7], Rec."Sub-Subject Code");
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
                        if VArrayMomActive[8] then begin
                            if vArrayMomento[8] <> '' then begin
                                GetTypeAssessment(8);
                                vText[8] := LookupFunction(8);
                                InsertAssessment(Rec."Student Code No.", Rec."Class No.", 8, vText[8], Rec."Sub-Subject Code");
                            end;
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        if vText[8] <> '' then begin


                            if VArrayMomActive[8] then begin
                                GetTypeAssessment(8);

                                if vArrayAssessmentType[8] = vArrayAssessmentType[8] ::Qualitative then begin
                                    ValidateAssessmentQualitative(8, vText[8]);
                                    InsertAssessment(Rec."Student Code No.", Rec."Class No.", 8, vText[8], Rec."Sub-Subject Code");
                                end;


                                if vArrayAssessmentType[8] = vArrayAssessmentType[8] ::"Mixed-Qualification" then begin
                                    if vArrayMomento[8] <> '' then begin
                                        vText[8] := ValidateAssessmentMixed(8, vText[8]);
                                        InsertAssessment(Rec."Student Code No.", Rec."Class No.", 8, vText[8], Rec."Sub-Subject Code");
                                    end;
                                end;
                                if vArrayAssessmentType[8] = vArrayAssessmentType[8] ::Quantitative then begin
                                    if vArrayMomento[8] <> '' then begin
                                        vText[8] := Format(ValidateAssessmentQuant(8, vText[8]));
                                        InsertAssessment(Rec."Student Code No.", Rec."Class No.", 8, vText[8], Rec."Sub-Subject Code");
                                    end;
                                end;
                            end;

                        end else
                            Rec.DeleteAssessignStudents(varClass, varSubjects, varRespCenter, varSchoolYear, varSchoolingYear, varStudyPlanCode,
                                                    Rec."Student Code No.", vArrayCodMomento[8], Rec."Sub-Subject Code");
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
                        if VArrayMomActive[9] then begin
                            if vArrayMomento[9] <> '' then begin
                                GetTypeAssessment(9);
                                vText[9] := LookupFunction(9);
                                InsertAssessment(Rec."Student Code No.", Rec."Class No.", 9, vText[9], Rec."Sub-Subject Code");
                            end;
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        if vText[9] <> '' then begin

                            if VArrayMomActive[9] then begin
                                GetTypeAssessment(9);

                                if vArrayAssessmentType[9] = vArrayAssessmentType[9] ::Qualitative then begin
                                    ValidateAssessmentQualitative(9, vText[9]);
                                    InsertAssessment(Rec."Student Code No.", Rec."Class No.", 9, vText[9], Rec."Sub-Subject Code");
                                end;


                                if vArrayAssessmentType[9] = vArrayAssessmentType[9] ::"Mixed-Qualification" then begin
                                    if vArrayMomento[9] <> '' then begin
                                        vText[9] := ValidateAssessmentMixed(9, vText[9]);
                                        InsertAssessment(Rec."Student Code No.", Rec."Class No.", 9, vText[9], Rec."Sub-Subject Code");
                                    end;
                                end;
                                if vArrayAssessmentType[9] = vArrayAssessmentType[9] ::Quantitative then begin
                                    if vArrayMomento[9] <> '' then begin
                                        vText[9] := Format(ValidateAssessmentQuant(9, vText[9]));
                                        InsertAssessment(Rec."Student Code No.", Rec."Class No.", 9, vText[9], Rec."Sub-Subject Code");
                                    end;
                                end;
                            end;

                        end else
                            Rec.DeleteAssessignStudents(varClass, varSubjects, varRespCenter, varSchoolYear, varSchoolingYear, varStudyPlanCode,
                                                    Rec."Student Code No.", vArrayCodMomento[9], Rec."Sub-Subject Code");
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
                        if VArrayMomActive[10] then begin
                            if vArrayMomento[10] <> '' then begin
                                GetTypeAssessment(10);
                                vText[10] := LookupFunction(10);
                                InsertAssessment(Rec."Student Code No.", Rec."Class No.", 10, vText[10], Rec."Sub-Subject Code");
                            end;
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        if vText[10] <> '' then begin


                            if VArrayMomActive[10] then begin
                                GetTypeAssessment(10);

                                if vArrayAssessmentType[10] = vArrayAssessmentType[10] ::Qualitative then begin
                                    ValidateAssessmentQualitative(10, vText[10]);
                                    InsertAssessment(Rec."Student Code No.", Rec."Class No.", 10, vText[10], Rec."Sub-Subject Code");
                                end;


                                if vArrayAssessmentType[10] = vArrayAssessmentType[10] ::"Mixed-Qualification" then begin
                                    if vArrayMomento[10] <> '' then begin
                                        vText[10] := ValidateAssessmentMixed(10, vText[10]);
                                        InsertAssessment(Rec."Student Code No.", Rec."Class No.", 10, vText[10], Rec."Sub-Subject Code");
                                    end;
                                end;
                                if vArrayAssessmentType[10] = vArrayAssessmentType[10] ::Quantitative then begin
                                    if vArrayMomento[10] <> '' then begin
                                        vText[10] := Format(ValidateAssessmentQuant(10, vText[10]));
                                        InsertAssessment(Rec."Student Code No.", Rec."Class No.", 10, vText[10], Rec."Sub-Subject Code");
                                    end;
                                end;
                            end;

                        end else
                            Rec.DeleteAssessignStudents(varClass, varSubjects, varRespCenter, varSchoolYear, varSchoolingYear, varStudyPlanCode,
                                                    Rec."Student Code No.", vArrayCodMomento[10], Rec."Sub-Subject Code");
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
                        if VArrayMomActive[11] then begin
                            if vArrayMomento[11] <> '' then begin
                                GetTypeAssessment(11);
                                vText[11] := LookupFunction(11);
                                InsertAssessment(Rec."Student Code No.", Rec."Class No.", 11, vText[11], Rec."Sub-Subject Code");
                            end;
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        if vText[11] <> '' then begin


                            if VArrayMomActive[11] then begin
                                GetTypeAssessment(11);

                                if vArrayAssessmentType[11] = vArrayAssessmentType[11] ::Qualitative then begin
                                    ValidateAssessmentQualitative(11, vText[11]);
                                    InsertAssessment(Rec."Student Code No.", Rec."Class No.", 11, vText[11], Rec."Sub-Subject Code");
                                end;


                                if vArrayAssessmentType[11] = vArrayAssessmentType[11] ::"Mixed-Qualification" then begin
                                    if vArrayMomento[11] <> '' then begin
                                        vText[11] := ValidateAssessmentMixed(11, vText[11]);
                                        InsertAssessment(Rec."Student Code No.", Rec."Class No.", 11, vText[11], Rec."Sub-Subject Code");
                                    end;
                                end;
                                if vArrayAssessmentType[11] = vArrayAssessmentType[11] ::Quantitative then begin
                                    if vArrayMomento[11] <> '' then begin
                                        vText[11] := Format(ValidateAssessmentQuant(11, vText[11]));
                                        InsertAssessment(Rec."Student Code No.", Rec."Class No.", 11, vText[11], Rec."Sub-Subject Code");
                                    end;
                                end;
                            end;

                        end else
                            Rec.DeleteAssessignStudents(varClass, varSubjects, varRespCenter, varSchoolYear, varSchoolingYear, varStudyPlanCode,
                                                    Rec."Student Code No.", vArrayCodMomento[11], Rec."Sub-Subject Code");
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
                        if VArrayMomActive[12] then begin
                            if vArrayMomento[12] <> '' then begin
                                GetTypeAssessment(12);
                                vText[12] := LookupFunction(12);
                                InsertAssessment(Rec."Student Code No.", Rec."Class No.", 12, vText[12], Rec."Sub-Subject Code");
                            end;
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        if vText[12] <> '' then begin

                            if VArrayMomActive[12] then begin
                                GetTypeAssessment(12);

                                if vArrayAssessmentType[12] = vArrayAssessmentType[12] ::Qualitative then begin
                                    ValidateAssessmentQualitative(12, vText[12]);
                                    InsertAssessment(Rec."Student Code No.", Rec."Class No.", 12, vText[12], Rec."Sub-Subject Code");
                                end;


                                if vArrayAssessmentType[12] = vArrayAssessmentType[12] ::"Mixed-Qualification" then begin
                                    if vArrayMomento[12] <> '' then begin
                                        vText[12] := ValidateAssessmentMixed(12, vText[12]);
                                        InsertAssessment(Rec."Student Code No.", Rec."Class No.", 12, vText[12], Rec."Sub-Subject Code");
                                    end;
                                end;
                                if vArrayAssessmentType[12] = vArrayAssessmentType[12] ::Quantitative then begin
                                    if vArrayMomento[12] <> '' then begin
                                        vText[12] := Format(ValidateAssessmentQuant(12, vText[12]));
                                        InsertAssessment(Rec."Student Code No.", Rec."Class No.", 12, vText[12], Rec."Sub-Subject Code");
                                    end;
                                end;
                            end;

                        end else
                            Rec.DeleteAssessignStudents(varClass, varSubjects, varRespCenter, varSchoolYear, varSchoolingYear, varStudyPlanCode,
                                                    Rec."Student Code No.", vArrayCodMomento[12], Rec."Sub-Subject Code");
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
                        if VArrayMomActive[13] then begin
                            if vArrayMomento[13] <> '' then begin
                                GetTypeAssessment(13);
                                vText[13] := LookupFunction(13);
                                InsertAssessment(Rec."Student Code No.", Rec."Class No.", 13, vText[13], Rec."Sub-Subject Code");
                            end;
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        if vText[13] <> '' then begin


                            if VArrayMomActive[13] then begin
                                GetTypeAssessment(13);

                                if vArrayAssessmentType[13] = vArrayAssessmentType[13] ::Qualitative then begin
                                    ValidateAssessmentQualitative(13, vText[13]);
                                    InsertAssessment(Rec."Student Code No.", Rec."Class No.", 13, vText[13], Rec."Sub-Subject Code");
                                end;


                                if vArrayAssessmentType[13] = vArrayAssessmentType[13] ::"Mixed-Qualification" then begin
                                    if vArrayMomento[13] <> '' then begin
                                        vText[13] := ValidateAssessmentMixed(13, vText[13]);
                                        InsertAssessment(Rec."Student Code No.", Rec."Class No.", 13, vText[13], Rec."Sub-Subject Code");
                                    end;
                                end;
                                if vArrayAssessmentType[13] = vArrayAssessmentType[13] ::Quantitative then begin
                                    if vArrayMomento[13] <> '' then begin
                                        vText[13] := Format(ValidateAssessmentQuant(13, vText[13]));
                                        InsertAssessment(Rec."Student Code No.", Rec."Class No.", 13, vText[13], Rec."Sub-Subject Code");
                                    end;
                                end;
                            end;

                        end else
                            Rec.DeleteAssessignStudents(varClass, varSubjects, varRespCenter, varSchoolYear, varSchoolingYear, varStudyPlanCode,
                                                    Rec."Student Code No.", vArrayCodMomento[13], Rec."Sub-Subject Code");
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
                        if VArrayMomActive[14] then begin
                            if vArrayMomento[14] <> '' then begin
                                GetTypeAssessment(14);
                                vText[14] := LookupFunction(14);
                                InsertAssessment(Rec."Student Code No.", Rec."Class No.", 14, vText[14], Rec."Sub-Subject Code");
                            end;
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        if vText[14] <> '' then begin

                            if VArrayMomActive[14] then begin
                                GetTypeAssessment(14);

                                if vArrayAssessmentType[14] = vArrayAssessmentType[14] ::Qualitative then begin
                                    ValidateAssessmentQualitative(14, vText[14]);
                                    InsertAssessment(Rec."Student Code No.", Rec."Class No.", 14, vText[14], Rec."Sub-Subject Code");
                                end;


                                if vArrayAssessmentType[14] = vArrayAssessmentType[14] ::"Mixed-Qualification" then begin
                                    if vArrayMomento[14] <> '' then begin
                                        vText[14] := ValidateAssessmentMixed(14, vText[14]);
                                        InsertAssessment(Rec."Student Code No.", Rec."Class No.", 14, vText[14], Rec."Sub-Subject Code");
                                    end;
                                end;
                                if vArrayAssessmentType[14] = vArrayAssessmentType[14] ::Quantitative then begin
                                    if vArrayMomento[14] <> '' then begin
                                        vText[14] := Format(ValidateAssessmentQuant(14, vText[14]));
                                        InsertAssessment(Rec."Student Code No.", Rec."Class No.", 14, vText[14], Rec."Sub-Subject Code");
                                    end;
                                end;
                            end;

                        end else
                            Rec.DeleteAssessignStudents(varClass, varSubjects, varRespCenter, varSchoolYear, varSchoolingYear, varStudyPlanCode,
                                                    Rec."Student Code No.", vArrayCodMomento[14], Rec."Sub-Subject Code");
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
                        if VArrayMomActive[15] then begin
                            if vArrayMomento[15] <> '' then begin
                                GetTypeAssessment(15);
                                vText[15] := LookupFunction(15);
                                InsertAssessment(Rec."Student Code No.", Rec."Class No.", 15, vText[15], Rec."Sub-Subject Code");
                            end;
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        if vText[15] <> '' then begin

                            if VArrayMomActive[15] then begin
                                GetTypeAssessment(15);

                                if vArrayAssessmentType[15] = vArrayAssessmentType[15] ::Qualitative then begin
                                    ValidateAssessmentQualitative(15, vText[15]);
                                    InsertAssessment(Rec."Student Code No.", Rec."Class No.", 15, vText[15], Rec."Sub-Subject Code");
                                end;


                                if vArrayAssessmentType[15] = vArrayAssessmentType[15] ::"Mixed-Qualification" then begin
                                    if vArrayMomento[15] <> '' then begin
                                        vText[15] := ValidateAssessmentMixed(15, vText[15]);
                                        InsertAssessment(Rec."Student Code No.", Rec."Class No.", 15, vText[15], Rec."Sub-Subject Code");
                                    end;
                                end;
                                if vArrayAssessmentType[15] = vArrayAssessmentType[15] ::Quantitative then begin
                                    if vArrayMomento[15] <> '' then begin
                                        vText[15] := Format(ValidateAssessmentQuant(15, vText[15]));
                                        InsertAssessment(Rec."Student Code No.", Rec."Class No.", 15, vText[15], Rec."Sub-Subject Code");
                                    end;
                                end;
                            end;

                        end else
                            Rec.DeleteAssessignStudents(varClass, varSubjects, varRespCenter, varSchoolYear, varSchoolingYear, varStudyPlanCode,
                                                    Rec."Student Code No.", vArrayCodMomento[15], Rec."Sub-Subject Code");
                        vText15OnAfterValidate;
                    end;
                }
            }
            group(Control1000000000)
            {
                ShowCaption = false;
                field(varAverbamentos; varAverbamentos)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(ExistCommentsSubjects; ExistCommentsSubjects)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Student with comments for selected subject for the selected moment';
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field(ExistCommentsGlobal; ExistCommentsGlobal)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Student with comments for the selected moment';
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Annotation")
            {
                ApplicationArea = All;
                Caption = '&Annotation';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    if Rec.Level = 1 then begin
                        varTypeButtonEdit := true;
                        if (varClass <> '') and (varSubjects <> '') then begin

                            Clear(fAnnotationWizard);

                            fAnnotationWizard.GetAnnotationCode(ActualAnnotationCode);
                            fAnnotationWizard.GetMomentInformation(varSelectedMoment);

                            if varSelectedMoment = varActiveMoment then
                                varTypeButtonEdit := true
                            else
                                varTypeButtonEdit := false;

                            fAnnotationWizard.GetInformation(Rec."Student Code No.", varSchoolYear, varClass, varSchoolingYear, varStudyPlanCode, varSubjects, '',
                                                         Rec."Class No.", VarType, varTypeButtonEdit);
                            fAnnotationWizard.Run;
                        end;

                    end;
                end;
            }
            action("&Global Remarks")
            {
                ApplicationArea = All;
                Caption = '&Global Remarks';
                Image = SetupList;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin


                    if Rec.Level = 1 then begin

                        if cPermissions.AllowGlobalObs(varClass, varSchoolYear, varSchoolingYear) then begin
                            varTypeButtonEdit := true;
                            if (varClass <> '') then begin
                                fRemarksWizard.GetMomentInformation(varSelectedMoment);

                                if varSelectedMoment = varActiveMoment then
                                    varTypeButtonEdit := true
                                else
                                    varTypeButtonEdit := false;
                                fRemarksWizard.GetInformation(Rec."Student Code No.", varSchoolYear, varClass, varSchoolingYear, varStudyPlanCode, '', '',
                                                             Rec."Class No.", VarType, varTypeButtonEdit);
                                fRemarksWizard.Run;
                            end;
                        end else
                            Message(Text0009);
                    end;
                end;
            }
            action("&Remarks")
            {
                ApplicationArea = All;
                Caption = '&Remarks';
                Image = Setup;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    if Rec.Level = 1 then begin
                        varTypeButtonEdit := true;
                        if (varClass <> '') and (varSubjects <> '') then begin

                            Clear(fRemarksWizard);
                            fRemarksWizard.GetObservationCode(ActualObservationCode);
                            fRemarksWizard.GetMomentInformation(varSelectedMoment);

                            if varSelectedMoment = varActiveMoment then
                                varTypeButtonEdit := true
                            else
                                varTypeButtonEdit := false;
                            fRemarksWizard.GetInformation(Rec."Student Code No.", varSchoolYear, varClass, varSchoolingYear, varStudyPlanCode, varSubjects, '',
                                                         Rec."Class No.", VarType, varTypeButtonEdit);
                            fRemarksWizard.Run;
                        end;

                    end;
                end;
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("E&xpand/Collapse")
                {
                    ApplicationArea = All;
                    Caption = 'E&xpand/Collapse';
                    Image = ExpandDepositLine;

                    trigger OnAction()
                    begin
                        ToggleExpandCollapse;
                    end;
                }
                action("Expand &All")
                {
                    ApplicationArea = All;
                    Caption = 'Expand &All';
                    Image = ExpandAll;

                    trigger OnAction()
                    begin
                        ExpandAll;
                    end;
                }
                action("&Collapse All")
                {
                    ApplicationArea = All;
                    Caption = '&Collapse All';
                    Image = Close;

                    trigger OnAction()
                    begin
                        InitTempTable;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        TextIndent := 0;

        if IsExpanded(Rec) then
            ActualExpansionStatus := 1
        else
            if HasChildren(Rec) then
                ActualExpansionStatus := 0
            else
                ActualExpansionStatus := 2;


        InsertColunm;
        TextOnFormat;
        vText1OnFormat;
        vText2OnFormat;
        vText3OnFormat;
        vText4OnFormat;
        vText5OnFormat;
        vText6OnFormat;
        vText7OnFormat;
        vText8OnFormat;
        vText9OnFormat;
        vText10OnFormat;
        vText11OnFormat;
        vText12OnFormat;
        vText13OnFormat;
        vText14OnFormat;
        vText15OnFormat;
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

    var
        BufferAssignAssessments: Record "Assign Assessments Buffer" temporary;
        rStudyPlanLines: Record "Study Plan Lines";
        rSettingRatings: Record "Setting Ratings";
        rSettingRatingsSubSubjects: Record "Setting Ratings Sub-Subjects";
        rRankGroup: Record "Rank Group";
        cStudentsRegistration: Codeunit "Students Registration";
        rMomentsAssessment: Record "Moments Assessment";
        rCourseLinesTEMP: Record "Course Lines" temporary;
        rCourseLines: Record "Course Lines";
        rStruEduCountry: Record "Structure Education Country";
        l_rStruEduCountry: Record "Structure Education Country";
        cUserEducation: Codeunit "User Education";
        rAssessmentConfig: Record "Assessment Configuration";
        cPermissions: Codeunit Permissions;
        ActualExpansionStatus: Integer;
        varClass: Code[20];
        varSubjects: Code[10];
        varSchoolYear: Code[9];
        varSchoolingYear: Code[10];
        varStudyPlanCode: Code[20];
        varRespCenter: Code[10];
        vText: array[15] of Text[250];
        vArrayMomento: array[15] of Text[30];
        vArrayCodMomento: array[15] of Text[30];
        vArrayType: array[15] of Option " ",Interim,"Final Moment",Test,Others,"Final Year",CIF,EXN1,EXN2,CFD;
        VArrayMomActive: array[15] of Boolean;
        vArrayAssessmentType: array[15] of Option " ",Qualitative,Quantitative,"None Qualification","Mixed-Qualification";
        vArrayAssessmentCode: array[15] of Code[20];
        indx: Integer;
        VarType: Option Simple,Multi;
        varMixedClassification: Boolean;
        varClassification: Text[30];
        Text0003: Label 'Grade should be a Number';
        Text0004: Label 'Grade should be between %1 and %2.';
        Text0005: Label 'There is no code inserted';
        Text0007: Label 'Class must not be blank.';
        varTypeButtonEdit: Boolean;
        ActualObservationCode: Code[20];
        varActiveMoment: Code[10];
        varSelectedMoment: Code[10];
        ActualAnnotationCode: Code[20];
        varAverbamentos: Text[250];
        Text0008: Label 'Annotations:';
        ExistCommentsSubjects: Boolean;
        ExistCommentsGlobal: Boolean;
        Text0009: Label 'You don''t have permissions.';
        Text0010: Label 'To set evaluations you need to set the Setting Moments for this school year(s).';
        Text0011: Label 'There should be an active moment.';
        Text0012: Label 'There are no Setting Ratings for the selected moment.';
        text0013: Label 'Class non-existent.';
        [InDataSet]
        TextEmphasize: Boolean;
        [InDataSet]
        TextIndent: Integer;
        [InDataSet]
        Txt1Editable: Boolean;
        [InDataSet]
        Txt1Emphasize: Boolean;
        [InDataSet]
        Txt2Editable: Boolean;
        [InDataSet]
        Txt2Emphasize: Boolean;
        [InDataSet]
        Txt3Editable: Boolean;
        [InDataSet]
        Txt3Emphasize: Boolean;
        [InDataSet]
        Txt4Editable: Boolean;
        [InDataSet]
        Txt4Emphasize: Boolean;
        [InDataSet]
        Txt5Editable: Boolean;
        [InDataSet]
        Txt5Emphasize: Boolean;
        [InDataSet]
        Txt6Editable: Boolean;
        [InDataSet]
        Txt6Emphasize: Boolean;
        [InDataSet]
        Txt7Editable: Boolean;
        [InDataSet]
        Txt7Emphasize: Boolean;
        [InDataSet]
        Txt8Editable: Boolean;
        [InDataSet]
        Txt8Emphasize: Boolean;
        [InDataSet]
        Txt9Editable: Boolean;
        [InDataSet]
        Txt9Emphasize: Boolean;
        [InDataSet]
        Txt10Editable: Boolean;
        [InDataSet]
        Txt10Emphasize: Boolean;
        [InDataSet]
        Txt11Editable: Boolean;
        [InDataSet]
        Txt11Emphasize: Boolean;
        [InDataSet]
        Txt12Editable: Boolean;
        [InDataSet]
        Txt12Emphasize: Boolean;
        [InDataSet]
        Txt13Editable: Boolean;
        [InDataSet]
        Txt13Emphasize: Boolean;
        [InDataSet]
        Txt14Editable: Boolean;
        [InDataSet]
        Txt14Emphasize: Boolean;
        [InDataSet]
        Txt15Editable: Boolean;
        [InDataSet]
        Txt15Emphasize: Boolean;
        fAnnotationWizard: Page "Annotation Wizard";
        fRemarksWizard: Page "Remarks Wizard";

    local procedure InitTempTable()
    begin
        CopyAssessToTemp(true);
    end;

    local procedure ExpandAll()
    begin
        CopyAssessToTemp(false);
    end;

    local procedure CopyAssessToTemp(OnlyRoot: Boolean)
    begin

        Rec.Reset;
        Rec.DeleteAll;

        BufferAssignAssessments.Reset;
        if OnlyRoot then
            BufferAssignAssessments.SetRange(Level, 1);
        if BufferAssignAssessments.Find('-') then
            repeat
                Rec := BufferAssignAssessments;
                Rec.Insert;
            until BufferAssignAssessments.Next = 0;

        if Rec.FindFirst then;
    end;

    local procedure HasChildren(ActualAssess: Record "Assign Assessments Buffer" temporary): Boolean
    var
        Assess2: Record "Assign Assessments Buffer" temporary;
    begin

        BufferAssignAssessments.Reset;
        BufferAssignAssessments.SetRange(BufferAssignAssessments."Student Code No.", ActualAssess."Student Code No.");
        BufferAssignAssessments.SetRange(BufferAssignAssessments."Class No.", ActualAssess."Class No.");
        BufferAssignAssessments.SetRange(BufferAssignAssessments."Subject Code", ActualAssess."Subject Code");
        if BufferAssignAssessments.FindLast then begin
            exit(BufferAssignAssessments.Level > ActualAssess.Level);
        end;
    end;

    local procedure IsExpanded(ActualAssess: Record "Assign Assessments Buffer" temporary): Boolean
    var
        xAssess: Record "Assign Assessments Buffer" temporary;
        Found: Boolean;
    begin

        xAssess := Rec;
        Rec := ActualAssess;
        Found := (Rec.Next <> 0);
        if Found then
            Found := (Rec.Level > ActualAssess.Level);
        Rec := xAssess;
        exit(Found);
    end;

    local procedure ToggleExpandCollapse()
    var
        Assess: Record "Assign Assessments Buffer" temporary;
        xAssess: Record "Assign Assessments Buffer" temporary;
    begin

        BufferAssignAssessments.Reset;
        if BufferAssignAssessments.Find('-') then
            repeat
                Assess.Init;
                Assess.TransferFields(BufferAssignAssessments);
                Assess.Insert;
            until BufferAssignAssessments.Next = 0;

        xAssess := Rec;
        if ActualExpansionStatus = 0 then begin // Has children, but not expanded
            Assess.SetRange(Level, Rec.Level, Rec.Level + 1);
            Assess := Rec;
            if Assess.Next <> 0 then
                repeat
                    if Assess.Level > xAssess.Level then begin
                        Rec := Assess;
                        if Rec.Insert then;
                    end;
                until (Assess.Next = 0) or (Assess.Level = xAssess.Level);
        end else
            if ActualExpansionStatus = 1 then begin // Has children and is already expanded
                while (Rec.Next <> 0) and (Rec.Level > xAssess.Level) do
                    Rec.Delete;
            end;
        Rec := xAssess;
        CurrPage.Update;
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
        rMomentsAssessment.SetRange("School Year", varSchoolYear);
        rMomentsAssessment.SetRange("Schooling Year", varSchoolingYear);
        rMomentsAssessment.SetRange("Responsibility Center", varRespCenter);
        if rMomentsAssessment.Find('-') then begin
            repeat
                indx := indx + 1;
                if rMomentsAssessment.Description = '' then
                    vArrayMomento[indx] := rMomentsAssessment."Moment Code"
                else
                    vArrayMomento[indx] := rMomentsAssessment.Description;
                vArrayCodMomento[indx] := rMomentsAssessment."Moment Code";
                vArrayType[indx] := rMomentsAssessment."Evaluation Moment";
                VArrayMomActive[indx] := rMomentsAssessment.Active;
                if rMomentsAssessment.Active = true then
                    varActiveMoment := rMomentsAssessment."Moment Code";
            until rMomentsAssessment.Next = 0;
        end;
    end;

    //[Scope('OnPrem')]
    procedure UpdateForm()
    begin
        BuildMoments;
    end;

    //[Scope('OnPrem')]
    procedure getCaptionLabel(label: Integer) out: Text[30]
    begin

        exit(vArrayMomento[label]);
    end;

    //[Scope('OnPrem')]
    procedure GetTypeAssessment(inIndex: Integer)
    begin
        if Rec.Level = 1 then begin
            rSettingRatings.Reset;
            rSettingRatings.SetRange("Moment Code", vArrayCodMomento[inIndex]);
            rSettingRatings.SetRange(Type, rSettingRatings.Type::Header);
            rSettingRatings.SetRange("School Year", varSchoolYear);
            rSettingRatings.SetRange("Schooling Year", varSchoolingYear);
            rSettingRatings.SetRange("Subject Code", varSubjects);
            rSettingRatings.SetRange("Study Plan Code", varStudyPlanCode);
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
        if Rec.Level = 2 then begin
            rSettingRatingsSubSubjects.Reset;
            rSettingRatingsSubSubjects.SetRange("Moment Code", vArrayCodMomento[inIndex]);
            rSettingRatingsSubSubjects.SetRange(Type, rSettingRatings.Type::Header);
            rSettingRatingsSubSubjects.SetRange("School Year", varSchoolYear);
            rSettingRatingsSubSubjects.SetRange("Schooling Year", varSchoolingYear);
            rSettingRatingsSubSubjects.SetRange("Subject Code", varSubjects);
            rSettingRatingsSubSubjects.SetRange("Study Plan Code", varStudyPlanCode);
            rSettingRatingsSubSubjects.SetRange("Sub-Subject Code", Rec."Sub-Subject Code");
            if rSettingRatingsSubSubjects.FindFirst then begin
                if rRankGroup.Get(rSettingRatingsSubSubjects."Assessment Code") then begin
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

        if (vArrayAssessmentType[InIndex] = vArrayAssessmentType[InIndex] ::Quantitative) then begin
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
    procedure InsertAssessment(inStudentCode: Code[20]; inClassNo: Integer; inIndex: Integer; inText: Text[250]; inSubSubjCode: Code[20])
    var
        rAssessingStudents: Record "Assessing Students";
    begin
        //2013.01.16 - Normatica - acrescentei o IF porque se fizermos cancelar, a aplicação n deve fazer nada
        if inText <> '' then begin
            rAssessingStudents.Reset;
            rAssessingStudents.SetRange("School Year", varSchoolYear);
            rAssessingStudents.SetRange("Schooling Year", varSchoolingYear);
            rAssessingStudents.SetRange(Subject, varSubjects);
            rAssessingStudents.SetRange("Sub-Subject Code", inSubSubjCode);
            rAssessingStudents.SetRange("Study Plan Code", varStudyPlanCode);
            rAssessingStudents.SetRange("Student Code No.", inStudentCode);
            rAssessingStudents.SetRange("Moment Code", vArrayCodMomento[inIndex]);
            if rAssessingStudents.Find('-') then begin

                if vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::Quantitative then
                    Evaluate(rAssessingStudents.Grade, inText);

                if (vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::Qualitative) then
                    rAssessingStudents."Qualitative Grade" := inText;

                if (vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::"Mixed-Qualification") then begin
                    if varMixedClassification then begin
                        rAssessingStudents."Qualitative Grade" := varClassification;
                        if inText <> '' then
                            Evaluate(rAssessingStudents.Grade, inText)
                        else
                            rAssessingStudents.Grade := 0;
                    end else begin
                        /*
                        IF NOT EVALUATE(rAssessingStudents.Grade,varClassification) THEN
                           rAssessingStudents.Grade := 0;
                        rAssessingStudents."Qualitative Grade" := inText;
                        */
                        //2013.01.07 - Normatica-  usam Mistas mas não com esse sentido, logo não pode limpar a grade
                        if Evaluate(rAssessingStudents.Grade, inText) then;
                        rAssessingStudents."Qualitative Grade" := inText;

                    end;
                end;

                rAssessingStudents.Modify(true);

            end else begin
                rAssessingStudents.Init;
                rAssessingStudents.Class := varClass;
                rAssessingStudents."School Year" := varSchoolYear;
                rAssessingStudents."Schooling Year" := varSchoolingYear;
                rAssessingStudents.Subject := varSubjects;
                rAssessingStudents."Sub-Subject Code" := inSubSubjCode;
                rAssessingStudents."Study Plan Code" := varStudyPlanCode;
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
                    if varMixedClassification then begin
                        Evaluate(rAssessingStudents.Grade, inText);
                        rAssessingStudents."Qualitative Grade" := varClassification;
                    end else begin
                        Evaluate(rAssessingStudents.Grade, varClassification);
                        rAssessingStudents."Qualitative Grade" := inText;
                    end;
                end;


                rAssessingStudents.Insert(true);

            end;
        end;

    end;

    //[Scope('OnPrem')]
    procedure GetAssessment(inStudentCode: Code[20]; inClassNo: Integer; inIndex: Integer; inText: Text[250]; inSubSubjCode: Code[20]) Out: Text[100]
    var
        rAssessingStudents: Record "Assessing Students";
    begin
        GetTypeAssessment(inIndex);

        rAssessingStudents.Reset;
        rAssessingStudents.SetRange("School Year", varSchoolYear);
        rAssessingStudents.SetRange("Schooling Year", varSchoolingYear);
        rAssessingStudents.SetRange(Subject, varSubjects);
        rAssessingStudents.SetRange("Sub-Subject Code", inSubSubjCode);
        rAssessingStudents.SetRange("Study Plan Code", varStudyPlanCode);
        rAssessingStudents.SetRange("Student Code No.", inStudentCode);
        rAssessingStudents.SetRange("Moment Code", vArrayCodMomento[inIndex]);
        if rAssessingStudents.Find('-') then begin
            /*
            IF (vArrayCodMomento[inIndex] = 'CIF') OR
               (vArrayCodMomento[inIndex] = 'CFD') OR
               (vArrayCodMomento[inIndex] = 'EXN1') OR
               (vArrayCodMomento[inIndex] = 'EXN2') THEN
               EXIT(FORMAT(rAssessingStudents."Recuperation Grade"));
            */
            if vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::Quantitative then
                if rAssessingStudents.Grade <> 0 then
                    exit(Format(rAssessingStudents.Grade))
                else
                    exit(Format(rAssessingStudents.Grade));

            if (vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::Qualitative) then
                if rAssessingStudents."Qualitative Grade" <> '' then
                    exit(rAssessingStudents."Qualitative Grade")
                else
                    exit(rAssessingStudents."Qualitative Grade");

            if (vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::"Mixed-Qualification") then
                if varMixedClassification then begin
                    if rAssessingStudents.Grade <> 0 then
                        exit(Format(rAssessingStudents.Grade))
                    else
                        exit(Format(rAssessingStudents.Grade))
                end
                else begin
                    if rAssessingStudents."Qualitative Grade" <> '' then
                        exit(rAssessingStudents."Qualitative Grade")
                    else
                        exit(rAssessingStudents."Qualitative Grade");
                end;


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
                vText[i] := GetAssessment(Rec."Student Code No.", Rec."Class No.", i, vText[i], Rec."Sub-Subject Code");
        until i = 15
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
            if rClassificationLevel.FindSet(false, false) then
                exit(rClassificationLevel."Classification Level Code")
            else
                Error(Text0005);
        end;
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
                    Error(Text0003);
                rClassificationLevel.Reset;
                rClassificationLevel.SetRange("Classification Group Code", vArrayAssessmentCode[InIndex]);
                rClassificationLevel.SetFilter("Classification Level Code", InClassification);
                if rClassificationLevel.FindFirst then begin
                    if (rClassificationLevel."Min Value" <= varClasification) and
                        (rClassificationLevel."Max Value" >= varClasification) then
                        exit(varClasification)
                    else
                        Error(Text0004, rClassificationLevel."Min Value", rClassificationLevel."Max Value");
                end;
            end else
                exit(0);
        end;
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
                    rClassificationLevelMin.SetFilter("Classification Level Code", InClassification);
                    if rClassificationLevelMin.Find('-') then
                        VarMinValue := rClassificationLevelMin."Min Value";

                    rClassificationLevelMax.Reset;
                    rClassificationLevelMax.SetCurrentKey("Id Ordination");
                    rClassificationLevelMax.Ascending(false);
                    rClassificationLevelMax.SetRange("Classification Group Code", vArrayAssessmentCode[InIndex]);
                    rClassificationLevelMax.SetFilter("Classification Level Code", InClassification);
                    if rClassificationLevelMax.Find('-') then
                        VarMaxValue := rClassificationLevelMax."Max Value";

                    if (VarMinValue <= varLocalClasification) and
                        (VarMaxValue >= varLocalClasification) then begin
                        rClassificationLevel.Reset;
                        rClassificationLevel.SetRange("Classification Group Code", vArrayAssessmentCode[InIndex]);
                        rClassificationLevel.SetRange(Value, varLocalClasification);
                        if rClassificationLevel.FindSet(false, false) then begin
                            if varMixedClassification then begin
                                varClassification := rClassificationLevel."Classification Level Code";
                                exit(Format(varLocalClasification));
                            end else begin
                                varClassification := Format(varLocalClasification);
                                exit(rClassificationLevel."Classification Level Code");
                            end;
                            //varClassification := FORMAT(varLocalClasification);
                            //EXIT(rClassificationLevel."Classification Level Code");
                        end;

                        rClassificationLevel.Reset;
                        rClassificationLevel.SetRange("Classification Group Code", vArrayAssessmentCode[InIndex]);
                        rClassificationLevel.SetFilter("Classification Level Code", InClassification);
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
                        Error(Text0004, VarMinValue, VarMaxValue);
                end;
                rClassificationLevel.Reset;
                rClassificationLevel.SetRange("Classification Group Code", vArrayAssessmentCode[InIndex]);
                rClassificationLevel.SetRange("Classification Level Code", InClassification);
                if rClassificationLevel.FindSet(false, false) then begin
                    if varMixedClassification then begin
                        varClassification := rClassificationLevel."Classification Level Code";
                        exit(Format(rClassificationLevel.Value));

                    end else begin
                        varClassification := Format(rClassificationLevel.Value);
                        exit(rClassificationLevel."Classification Level Code");
                    end;
                end else
                    Error(Text0005);

            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure GetNoStructureCountry(pClass: Code[20]; pSchoolYear: Code[9]): Integer
    var
        rStruEduCountry: Record "Structure Education Country";
        rClass: Record Class;
        cStudentsRegistration: Codeunit "Students Registration";
    begin
        if rClass.Get(pClass, pSchoolYear) then;

        rStruEduCountry.Reset;
        rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
        //rStruEduCountry.SETRANGE(Level,rStruEduCountry.Level::Secondary);
        rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
        if rStruEduCountry.Find('-') then begin
            repeat
                if rClass."Schooling Year" = rStruEduCountry."Schooling Year" then
                    exit(rStruEduCountry."Sorting ID");
            until rStruEduCountry.Next = 0;
        end;
    end;

    //[Scope('OnPrem')]
    procedure GetAverbamentos(InMomentCode: Code[10]; InSubject: Code[10])
    var
        l_rRemarks: Record Remarks;
    begin
        Clear(varAverbamentos);
        l_rRemarks.Reset;
        l_rRemarks.SetRange(Class, varClass);
        l_rRemarks.SetRange("School Year", varSchoolYear);
        l_rRemarks.SetRange("Schooling Year", varSchoolingYear);
        l_rRemarks.SetRange("Study Plan Code", varStudyPlanCode);
        l_rRemarks.SetRange(Subject, InSubject);
        l_rRemarks.SetRange("Student/Teacher Code No.", Rec."Student Code No.");
        l_rRemarks.SetRange("Moment Code", InMomentCode);
        l_rRemarks.SetRange(l_rRemarks."Type Remark", l_rRemarks."Type Remark"::Annotation);
        if l_rRemarks.Find('-') then begin
            varAverbamentos := Text0008 + ' ';
            repeat
                varAverbamentos := varAverbamentos + l_rRemarks."Annotation Code" + '; ';
            until l_rRemarks.Next = 0;
        end;
    end;

    //[Scope('OnPrem')]
    procedure UpdateCommentsVAR(IsGlobal: Boolean; l_CodMoment: Code[10]) ExitValue: Boolean
    var
        l_rRemarks: Record Remarks;
    begin
        ExitValue := false;

        l_rRemarks.Reset;
        l_rRemarks.SetRange(Class, varClass);
        l_rRemarks.SetRange("School Year", varSchoolYear);
        l_rRemarks.SetRange("Schooling Year", varSchoolingYear);
        l_rRemarks.SetRange("Study Plan Code", varStudyPlanCode);
        l_rRemarks.SetRange("Student/Teacher Code No.", Rec."Student Code No.");
        l_rRemarks.SetRange("Moment Code", l_CodMoment);
        l_rRemarks.SetRange("Type Remark", l_rRemarks."Type Remark"::Assessment);
        if not IsGlobal then
            l_rRemarks.SetRange(Subject, varSubjects)
        else
            l_rRemarks.SetRange(Subject, '');
        if l_rRemarks.Find('-') then
            ExitValue := true;

        exit(ExitValue);
    end;

    //[Scope('OnPrem')]
    procedure TestMoments()
    begin
        rMomentsAssessment.Reset;
        rMomentsAssessment.SetCurrentKey("Schooling Year", "Sorting ID");
        rMomentsAssessment.SetRange("School Year", varSchoolYear);
        rMomentsAssessment.SetRange("Schooling Year", varSchoolingYear);
        rMomentsAssessment.SetRange("Responsibility Center", varRespCenter);
        rMomentsAssessment.SetRange(rMomentsAssessment.Active, true);
        if not rMomentsAssessment.FindFirst then begin
            rMomentsAssessment.SetRange(rMomentsAssessment.Active);
            if not rMomentsAssessment.FindFirst then begin
                varClass := '';
                Error(Text0010);
            end else begin
                varClass := '';
                Error(Text0011);
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure TestSettingRatings()
    var
        lSettingRatings: Record "Setting Ratings";
    begin
        lSettingRatings.Reset;
        lSettingRatings.SetRange(lSettingRatings."Moment Code", varActiveMoment);
        lSettingRatings.SetRange(lSettingRatings."School Year", varSchoolYear);
        lSettingRatings.SetRange(lSettingRatings."Schooling Year", varSchoolingYear);
        lSettingRatings.SetRange(lSettingRatings."Study Plan Code", varStudyPlanCode);
        lSettingRatings.SetRange(lSettingRatings."Subject Code", varSubjects);
        lSettingRatings.SetRange(lSettingRatings.Type, rSettingRatings.Type::Header);
        lSettingRatings.SetRange(lSettingRatings."Type Education", VarType);
        if not lSettingRatings.FindFirst then begin
            varSubjects := '';
            Error(Text0012);
        end;
    end;

    //[Scope('OnPrem')]
    procedure ApplyFilter(varClass: Code[20]; varSubject: Code[10]; varRespCenter: Code[10]; varSchoolYear: Code[9]; varSchoolingYear: Code[10]; varStudyPlanCode: Code[20])
    var
        rRegistrationSubject: Record "Registration Subjects";
        rSettingRatingsSubSubjects: Record "Setting Ratings Sub-Subjects";
        rStudent: Record Students;
        rMomentsAssess: Record "Moments Assessment";
        rStudentSubjEntry: Record "Student Subjects Entry";
        rRegistrationClassEntry: Record "Registration Class Entry";
        varStudent: Code[20];
        varMomento: Code[10];
        varMomentDataEnd: Date;
        auxStudent: Code[20];
        Text0001: Label 'You must fill the Class and Subject fields.';
    begin

        if (varClass = '') or (varSubject = '') then Error(Text0001);

        DeleteBuffer;

        //Saber o Periodo Ativo
        //**********************
        rMomentsAssess.Reset;
        rMomentsAssess.SetRange(rMomentsAssess."Responsibility Center", varRespCenter);
        rMomentsAssess.SetRange(rMomentsAssess."School Year", varSchoolYear);
        rMomentsAssess.SetRange(rMomentsAssess."Schooling Year", varSchoolingYear);
        rMomentsAssess.SetRange(rMomentsAssess.Active, true);
        if rMomentsAssess.FindSet then begin
            varMomento := rMomentsAssess."Moment Code";
            varMomentDataEnd := rMomentsAssess."End Date";
        end;




        //Inserir os dados na tabela - nova forma para que apresente os dados à data de fim do periodo
        //**************************

        Clear(auxStudent);
        rRegistrationClassEntry.Reset;
        rRegistrationClassEntry.SetRange(rRegistrationClassEntry.Class, varClass);
        rRegistrationClassEntry.SetRange(rRegistrationClassEntry."School Year", varSchoolYear);
        rRegistrationClassEntry.SetRange(rRegistrationClassEntry."Schooling Year", varSchoolingYear);
        rRegistrationClassEntry.SetRange(rRegistrationClassEntry."Responsibility Center", varRespCenter);
        rRegistrationClassEntry.SetFilter(rRegistrationClassEntry."Status Date", '<=%1', varMomentDataEnd);
        rRegistrationClassEntry.SetRange(rRegistrationClassEntry.Status, rRegistrationClassEntry.Status::Subscribed);
        rRegistrationClassEntry.SetRange(rRegistrationClassEntry.Active, true);
        if rRegistrationClassEntry.Find('-') then begin
            repeat
                if auxStudent <> rRegistrationClassEntry."Student Code No." then begin

                    auxStudent := rRegistrationClassEntry."Student Code No.";
                    varStudent := rRegistrationClassEntry."Student Code No.";

                    rStudentSubjEntry.Reset;
                    rStudentSubjEntry.SetRange(rStudentSubjEntry.Class, varClass);
                    rStudentSubjEntry.SetRange(rStudentSubjEntry."Student Code No.", rRegistrationClassEntry."Student Code No.");
                    rStudentSubjEntry.SetRange(rStudentSubjEntry."School Year", varSchoolYear);
                    rStudentSubjEntry.SetRange(rStudentSubjEntry."Schooling Year", varSchoolingYear);
                    rStudentSubjEntry.SetRange(rStudentSubjEntry."Subjects Code", varSubject);
                    rStudentSubjEntry.SetFilter(rStudentSubjEntry."Status Date", '<=%1', varMomentDataEnd);
                    rStudentSubjEntry.SetRange(rStudentSubjEntry.Status, rStudentSubjEntry.Status::Subscribed);
                    if rStudentSubjEntry.FindFirst then begin

                        ////Insere nome Aluno
                        BufferAssignAssessments.Reset;
                        BufferAssignAssessments.Init;
                        BufferAssignAssessments."User ID" := UserId;
                        BufferAssignAssessments."Line No." := BufferAssignAssessments."Line No." + 10000;
                        BufferAssignAssessments."Student Code No." := rStudentSubjEntry."Student Code No.";
                        BufferAssignAssessments."Class No." := rStudentSubjEntry."Class No.";
                        if rStudent.Get(rStudentSubjEntry."Student Code No.") then begin
                            BufferAssignAssessments.Text := rStudent.Name;
                        end;
                        BufferAssignAssessments."Subject Code" := varSubject;
                        BufferAssignAssessments.Level := 1;
                        BufferAssignAssessments.Insert;

                        ////Inserir Sub-disciplinas
                        rSettingRatingsSubSubjects.Reset;

                        rSettingRatingsSubSubjects.SetCurrentKey(rSettingRatingsSubSubjects."School Year",
                        rSettingRatingsSubSubjects."Schooling Year", rSettingRatingsSubSubjects."Study Plan Code",
                        rSettingRatingsSubSubjects."Subject Code", rSettingRatingsSubSubjects."Sorting ID");
                        rSettingRatingsSubSubjects.SetRange(rSettingRatingsSubSubjects."Responsibility Center", varRespCenter);
                        rSettingRatingsSubSubjects.SetRange(rSettingRatingsSubSubjects."School Year", varSchoolYear);
                        rSettingRatingsSubSubjects.SetRange(rSettingRatingsSubSubjects."Schooling Year", varSchoolingYear);
                        rSettingRatingsSubSubjects.SetRange(rSettingRatingsSubSubjects."Study Plan Code", varStudyPlanCode);
                        rSettingRatingsSubSubjects.SetRange(rSettingRatingsSubSubjects."Subject Code", varSubject);
                        rSettingRatingsSubSubjects.SetRange(rSettingRatingsSubSubjects."Moment Code", varMomento);
                        if rSettingRatingsSubSubjects.FindSet(false) then begin
                            repeat
                                BufferAssignAssessments.Reset;
                                BufferAssignAssessments.Init;
                                BufferAssignAssessments."User ID" := UserId;
                                BufferAssignAssessments."Line No." := BufferAssignAssessments."Line No." + 10000;
                                BufferAssignAssessments."Student Code No." := rStudentSubjEntry."Student Code No.";
                                BufferAssignAssessments."Class No." := rStudentSubjEntry."Class No.";
                                BufferAssignAssessments."Subject Code" := varSubject;
                                BufferAssignAssessments."Sub-Subject Code" := rSettingRatingsSubSubjects."Sub-Subject Code";
                                BufferAssignAssessments.Text := rSettingRatingsSubSubjects."Sub-Subject Description";
                                BufferAssignAssessments.Level := 2;
                                BufferAssignAssessments.Insert;
                            until rSettingRatingsSubSubjects.Next = 0;
                        end;
                    end;
                end;
            until rRegistrationClassEntry.Next = 0;
        end;
    end;

    //[Scope('OnPrem')]
    procedure DeleteBuffer()
    begin
        BufferAssignAssessments.Reset;
        BufferAssignAssessments.DeleteAll;
    end;

    //[Scope('OnPrem')]
    procedure ImputAssessment(InIndex: Integer; inText: Text[250]) Out: Code[20]
    var
        rClassificationLevel: Record "Classification Level";
    begin
        if vArrayAssessmentType[InIndex] = vArrayAssessmentType[InIndex] ::Qualitative then begin
            rClassificationLevel.Reset;
            rClassificationLevel.SetRange("Classification Group Code", vArrayAssessmentCode[InIndex]);
            rClassificationLevel.SetFilter("Classification Level Code", '%1', inText + '*');
            if rClassificationLevel.FindFirst then
                exit(rClassificationLevel."Classification Level Code")
        end;
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

    local procedure varSubjectsOnAfterValidate()
    var
        TempStudyPlanLines: Record "Study Plan Lines" temporary;
        TempCourseLines: Record "Course Lines" temporary;
    begin
        if varClass <> '' then begin

            if varSubjects <> '' then begin
                if VarType = VarType::Simple then begin
                    Clear(TempStudyPlanLines);
                    cPermissions.SubjectFilter(VarType, varSchoolYear, varClass, varStudyPlanCode, varSchoolingYear,
                                               TempStudyPlanLines, TempCourseLines, 1);

                    TempStudyPlanLines.SetRange(TempStudyPlanLines.Code, varStudyPlanCode);
                    TempStudyPlanLines.SetRange(TempStudyPlanLines."School Year", varSchoolYear);
                    TempStudyPlanLines.SetRange(TempStudyPlanLines."Schooling Year", varSchoolingYear);
                    TempStudyPlanLines.SetRange(TempStudyPlanLines."Subject Code", varSubjects);
                    if TempStudyPlanLines.FindFirst then begin
                        varSubjects := TempStudyPlanLines."Subject Code";

                        BuildMoments;
                        TestSettingRatings;
                        ActualObservationCode := TempStudyPlanLines.Observations;
                        UpdateForm;
                    end else
                        Error(Text0009);

                end else begin
                    Clear(TempCourseLines);
                    cPermissions.SubjectFilter(VarType, varSchoolYear, varClass, varStudyPlanCode, varSchoolingYear,
                                               TempStudyPlanLines, TempCourseLines, 1);


                    TempCourseLines.SetRange(TempCourseLines.Code, varStudyPlanCode);
                    TempCourseLines.SetRange(TempCourseLines."Temp School Year", varSchoolYear);
                    TempCourseLines.SetRange(TempCourseLines."Schooling Year Begin", varSchoolingYear);
                    TempCourseLines.SetRange(TempCourseLines."Subject Code", varSubjects);
                    if TempCourseLines.FindFirst then begin
                        varSubjects := TempCourseLines."Subject Code";
                        BuildMoments;
                        TestSettingRatings;
                        ActualObservationCode := TempCourseLines.Observations;
                        UpdateForm;
                    end else
                        Error(Text0009);

                end;
            end;
            ApplyFilter(varClass, varSubjects, varRespCenter, varSchoolYear, varSchoolingYear, varStudyPlanCode);
            InitTempTable;
            CurrPage.Update(false);

        end else
            Error(Text0007);
    end;

    local procedure varClassOnAfterValidate()
    var
        tempClass: Record Class temporary;
    begin
        if varClass <> '' then begin
            Clear(tempClass);
            cPermissions.ClassFilter(tempClass, 1);

            tempClass.SetFilter(tempClass."School Year", cStudentsRegistration.GetShoolYearActiveClosing);
            tempClass.SetRange(tempClass.Class, varClass);
            if tempClass.FindFirst then begin
                varClass := tempClass.Class;
                varSchoolYear := tempClass."School Year";
                varSchoolingYear := tempClass."Schooling Year";
                varStudyPlanCode := tempClass."Study Plan Code";
                VarType := tempClass.Type;
                varRespCenter := tempClass."Responsibility Center";
                varSubjects := '';

                DeleteBuffer;
                InitTempTable;
                CurrPage.Update(false);
                TestMoments;

                //Ir buscar o Codigo dos Averbamentos
                rAssessmentConfig.Reset;
                if tempClass.Type = tempClass.Type::Simple then
                    rAssessmentConfig.SetRange(rAssessmentConfig."School Year", tempClass."School Year");
                rAssessmentConfig.SetRange(rAssessmentConfig.Type, tempClass.Type);
                rAssessmentConfig.SetRange(rAssessmentConfig."Study Plan Code", tempClass."Study Plan Code");
                rAssessmentConfig.SetRange(rAssessmentConfig."Country/Region Code", tempClass."Country/Region Code");
                if rAssessmentConfig.FindFirst then
                    ActualAnnotationCode := rAssessmentConfig."Annotation Code";

            end else
                Error(Text0009);
        end else
            Error(text0013);
    end;

    local procedure ClassNoOnActivate()
    begin
        GetAverbamentos('', varSubjects);
        ExistCommentsSubjects := UpdateCommentsVAR(false, '');
        ExistCommentsGlobal := UpdateCommentsVAR(true, '');
    end;

    local procedure TextOnActivate()
    begin
        GetAverbamentos('', varSubjects);
        ExistCommentsSubjects := UpdateCommentsVAR(false, '');
        ExistCommentsGlobal := UpdateCommentsVAR(true, '');
    end;

    local procedure vText1OnActivate()
    begin

        GetAverbamentos(vArrayCodMomento[1], varSubjects);
        ExistCommentsSubjects := UpdateCommentsVAR(false, vArrayCodMomento[1]);
        ExistCommentsGlobal := UpdateCommentsVAR(true, vArrayCodMomento[1]);
        varSelectedMoment := vArrayCodMomento[1];
        CurrPage.Update;
    end;

    local procedure vText2OnActivate()
    begin

        GetAverbamentos(vArrayCodMomento[2], varSubjects);
        ExistCommentsSubjects := UpdateCommentsVAR(false, vArrayCodMomento[2]);
        ExistCommentsGlobal := UpdateCommentsVAR(true, vArrayCodMomento[2]);
        varSelectedMoment := vArrayCodMomento[2];
        CurrPage.Update;
    end;

    local procedure vText3OnActivate()
    begin

        GetAverbamentos(vArrayCodMomento[3], varSubjects);
        ExistCommentsSubjects := UpdateCommentsVAR(false, vArrayCodMomento[3]);
        ExistCommentsGlobal := UpdateCommentsVAR(true, vArrayCodMomento[3]);
        varSelectedMoment := vArrayCodMomento[3];
        CurrPage.Update;
    end;

    local procedure vText4OnActivate()
    begin
        GetAverbamentos(vArrayCodMomento[4], varSubjects);
        ExistCommentsSubjects := UpdateCommentsVAR(false, vArrayCodMomento[4]);
        ExistCommentsGlobal := UpdateCommentsVAR(true, vArrayCodMomento[4]);
        varSelectedMoment := vArrayCodMomento[4];
        CurrPage.Update;
    end;

    local procedure vText5OnActivate()
    begin
        GetAverbamentos(vArrayCodMomento[5], varSubjects);
        ExistCommentsSubjects := UpdateCommentsVAR(false, vArrayCodMomento[5]);
        ExistCommentsGlobal := UpdateCommentsVAR(true, vArrayCodMomento[5]);
        varSelectedMoment := vArrayCodMomento[5];
        CurrPage.Update;
    end;

    local procedure vText6OnActivate()
    begin
        GetAverbamentos(vArrayCodMomento[6], varSubjects);
        ExistCommentsSubjects := UpdateCommentsVAR(false, vArrayCodMomento[6]);
        ExistCommentsGlobal := UpdateCommentsVAR(true, vArrayCodMomento[6]);
        varSelectedMoment := vArrayCodMomento[6];
        CurrPage.Update;
    end;

    local procedure vText7OnActivate()
    begin
        GetAverbamentos(vArrayCodMomento[7], varSubjects);
        ExistCommentsSubjects := UpdateCommentsVAR(false, vArrayCodMomento[7]);
        ExistCommentsGlobal := UpdateCommentsVAR(true, vArrayCodMomento[7]);
        varSelectedMoment := vArrayCodMomento[7];
        CurrPage.Update;
    end;

    local procedure vText8OnActivate()
    begin
        GetAverbamentos(vArrayCodMomento[8], varSubjects);
        ExistCommentsSubjects := UpdateCommentsVAR(false, vArrayCodMomento[8]);
        ExistCommentsGlobal := UpdateCommentsVAR(true, vArrayCodMomento[8]);
        varSelectedMoment := vArrayCodMomento[8];
        CurrPage.Update;
    end;

    local procedure vText9OnActivate()
    begin
        GetAverbamentos(vArrayCodMomento[9], varSubjects);
        ExistCommentsSubjects := UpdateCommentsVAR(false, vArrayCodMomento[9]);
        ExistCommentsGlobal := UpdateCommentsVAR(true, vArrayCodMomento[9]);
        varSelectedMoment := vArrayCodMomento[9];
        CurrPage.Update;
    end;

    local procedure vText10OnActivate()
    begin
        GetAverbamentos(vArrayCodMomento[10], varSubjects);
        ExistCommentsSubjects := UpdateCommentsVAR(false, vArrayCodMomento[10]);
        ExistCommentsGlobal := UpdateCommentsVAR(true, vArrayCodMomento[10]);
        varSelectedMoment := vArrayCodMomento[10];
        CurrPage.Update;
    end;

    local procedure vText11OnActivate()
    begin
        GetAverbamentos(vArrayCodMomento[11], varSubjects);
        ExistCommentsSubjects := UpdateCommentsVAR(false, vArrayCodMomento[11]);
        ExistCommentsGlobal := UpdateCommentsVAR(true, vArrayCodMomento[11]);
        varSelectedMoment := vArrayCodMomento[11];
        CurrPage.Update;
    end;

    local procedure vText12OnActivate()
    begin
        GetAverbamentos(vArrayCodMomento[12], varSubjects);
        ExistCommentsSubjects := UpdateCommentsVAR(false, vArrayCodMomento[12]);
        ExistCommentsGlobal := UpdateCommentsVAR(true, vArrayCodMomento[12]);
        varSelectedMoment := vArrayCodMomento[12];
        CurrPage.Update;
    end;

    local procedure vText13OnActivate()
    begin
        GetAverbamentos(vArrayCodMomento[13], varSubjects);
        ExistCommentsSubjects := UpdateCommentsVAR(false, vArrayCodMomento[13]);
        ExistCommentsGlobal := UpdateCommentsVAR(true, vArrayCodMomento[13]);
        varSelectedMoment := vArrayCodMomento[13];
        CurrPage.Update;
    end;

    local procedure vText14OnActivate()
    begin
        GetAverbamentos(vArrayCodMomento[14], varSubjects);
        ExistCommentsSubjects := UpdateCommentsVAR(false, vArrayCodMomento[14]);
        ExistCommentsGlobal := UpdateCommentsVAR(true, vArrayCodMomento[14]);
        varSelectedMoment := vArrayCodMomento[14];
        CurrPage.Update;
    end;

    local procedure vText15OnActivate()
    begin
        GetAverbamentos(vArrayCodMomento[15], varSubjects);
        ExistCommentsSubjects := UpdateCommentsVAR(false, vArrayCodMomento[15]);
        ExistCommentsGlobal := UpdateCommentsVAR(true, vArrayCodMomento[15]);
        varSelectedMoment := vArrayCodMomento[15];
        CurrPage.Update;
    end;

    local procedure vText1OnAfterInput(var Text: Text[1024])
    begin
        Text := UpperCase(Text);

        if Text <> '' then
            if VArrayMomActive[1] then begin
                GetTypeAssessment(1);
                if vArrayAssessmentType[1] = vArrayAssessmentType[1] ::Qualitative then
                    Text := ImputAssessment(1, Text);
            end;
    end;

    local procedure vText2OnAfterInput(var Text: Text[1024])
    begin
        Text := UpperCase(Text);

        if Text <> '' then
            if VArrayMomActive[2] then begin
                GetTypeAssessment(2);
                if vArrayAssessmentType[2] = vArrayAssessmentType[2] ::Qualitative then
                    Text := ImputAssessment(2, Text);
            end;
    end;

    local procedure vText3OnAfterInput(var Text: Text[1024])
    begin
        Text := UpperCase(Text);

        if Text <> '' then
            if VArrayMomActive[3] then begin
                GetTypeAssessment(3);
                if vArrayAssessmentType[3] = vArrayAssessmentType[3] ::Qualitative then
                    Text := ImputAssessment(3, Text);
            end;
    end;

    local procedure vText4OnAfterInput(var Text: Text[1024])
    begin
        Text := UpperCase(Text);

        if Text <> '' then
            if VArrayMomActive[4] then begin
                GetTypeAssessment(4);
                if vArrayAssessmentType[4] = vArrayAssessmentType[4] ::Qualitative then
                    Text := ImputAssessment(4, Text);
            end;
    end;

    local procedure vText5OnAfterInput(var Text: Text[1024])
    begin
        Text := UpperCase(Text);

        if Text <> '' then
            if VArrayMomActive[5] then begin
                GetTypeAssessment(5);
                if vArrayAssessmentType[5] = vArrayAssessmentType[5] ::Qualitative then
                    Text := ImputAssessment(5, Text);
            end;
    end;

    local procedure vText6OnAfterInput(var Text: Text[1024])
    begin
        Text := UpperCase(Text);

        if Text <> '' then
            if VArrayMomActive[6] then begin
                GetTypeAssessment(6);
                if vArrayAssessmentType[6] = vArrayAssessmentType[6] ::Qualitative then
                    Text := ImputAssessment(6, Text);
            end;
    end;

    local procedure vText7OnAfterInput(var Text: Text[1024])
    begin
        Text := UpperCase(Text);

        if Text <> '' then
            if VArrayMomActive[7] then begin
                GetTypeAssessment(7);
                if vArrayAssessmentType[7] = vArrayAssessmentType[7] ::Qualitative then
                    Text := ImputAssessment(7, Text);
            end;
    end;

    local procedure vText8OnAfterInput(var Text: Text[1024])
    begin
        Text := UpperCase(Text);

        if Text <> '' then
            if VArrayMomActive[8] then begin
                GetTypeAssessment(8);
                if vArrayAssessmentType[8] = vArrayAssessmentType[8] ::Qualitative then
                    Text := ImputAssessment(8, Text);
            end;
    end;

    local procedure vText9OnAfterInput(var Text: Text[1024])
    begin
        Text := UpperCase(Text);

        if Text <> '' then
            if VArrayMomActive[9] then begin
                GetTypeAssessment(9);
                if vArrayAssessmentType[9] = vArrayAssessmentType[9] ::Qualitative then
                    Text := ImputAssessment(9, Text);
            end;
    end;

    local procedure vText10OnAfterInput(var Text: Text[1024])
    begin
        Text := UpperCase(Text);

        if Text <> '' then
            if VArrayMomActive[10] then begin
                GetTypeAssessment(10);
                if vArrayAssessmentType[10] = vArrayAssessmentType[10] ::Qualitative then
                    Text := ImputAssessment(10, Text);
            end;
    end;

    local procedure vText11OnAfterInput(var Text: Text[1024])
    begin
        Text := UpperCase(Text);

        if Text <> '' then
            if VArrayMomActive[11] then begin
                GetTypeAssessment(11);
                if vArrayAssessmentType[11] = vArrayAssessmentType[11] ::Qualitative then
                    Text := ImputAssessment(11, Text);
            end;
    end;

    local procedure vText12OnAfterInput(var Text: Text[1024])
    begin
        Text := UpperCase(Text);

        if Text <> '' then
            if VArrayMomActive[12] then begin
                GetTypeAssessment(12);
                if vArrayAssessmentType[12] = vArrayAssessmentType[12] ::Qualitative then
                    Text := ImputAssessment(12, Text);
            end;
    end;

    local procedure vText13OnAfterInput(var Text: Text[1024])
    begin
        Text := UpperCase(Text);

        if Text <> '' then
            if VArrayMomActive[13] then begin
                GetTypeAssessment(13);
                if vArrayAssessmentType[13] = vArrayAssessmentType[13] ::Qualitative then
                    Text := ImputAssessment(13, Text);
            end;
    end;

    local procedure vText14OnAfterInput(var Text: Text[1024])
    begin
        Text := UpperCase(Text);

        if Text <> '' then
            if VArrayMomActive[14] then begin
                GetTypeAssessment(14);
                if vArrayAssessmentType[14] = vArrayAssessmentType[14] ::Qualitative then
                    Text := ImputAssessment(14, Text);
            end;
    end;

    local procedure vText15OnAfterInput(var Text: Text[1024])
    begin
        Text := UpperCase(Text);

        if Text <> '' then
            if VArrayMomActive[15] then begin
                GetTypeAssessment(15);
                if vArrayAssessmentType[15] = vArrayAssessmentType[15] ::Qualitative then
                    Text := ImputAssessment(15, Text);
            end;
    end;

    local procedure ActualExpansionStatusOnPush()
    begin
        ToggleExpandCollapse;
    end;

    local procedure varMixedClassificationOnPush()
    begin
        CurrPage.Update;
    end;

    local procedure TextOnFormat()
    begin
        TextIndent := Rec.Level;

        if Rec.Level <> 2 then
            TextEmphasize := true;
    end;

    local procedure vText1OnFormat()
    begin
        if VArrayMomActive[1] = false then
            Txt1Editable := false
        else
            Txt1Editable := true;

        if Rec.Level <> 2 then
            Txt1Emphasize := true;
    end;

    local procedure vText2OnFormat()
    begin
        if VArrayMomActive[2] = false then
            Txt2Editable := false
        else
            Txt2Editable := true;

        if Rec.Level <> 2 then
            Txt2Emphasize := true;
    end;

    local procedure vText3OnFormat()
    begin
        if VArrayMomActive[3] = false then
            Txt3Editable := false
        else
            Txt3Editable := true;

        if Rec.Level <> 2 then
            Txt3Emphasize := true;
    end;

    local procedure vText4OnFormat()
    begin
        if VArrayMomActive[4] = false then
            Txt4Editable := false
        else
            Txt4Editable := true;

        if Rec.Level <> 2 then
            Txt4Emphasize := true;
    end;

    local procedure vText5OnFormat()
    begin
        if VArrayMomActive[5] = false then
            Txt5Editable := false
        else
            Txt5Editable := true;

        if Rec.Level <> 2 then
            Txt5Emphasize := true;
    end;

    local procedure vText6OnFormat()
    begin
        if VArrayMomActive[6] = false then
            Txt6Editable := false
        else
            Txt6Editable := true;

        if Rec.Level <> 2 then
            Txt6Emphasize := true;
    end;

    local procedure vText7OnFormat()
    begin
        if VArrayMomActive[7] = false then
            Txt7Editable := false
        else
            Txt7Editable := true;

        if Rec.Level <> 2 then
            Txt7Emphasize := true;
    end;

    local procedure vText8OnFormat()
    begin
        if VArrayMomActive[8] = false then
            Txt8Editable := false
        else
            Txt8Editable := true;

        if Rec.Level <> 2 then
            Txt8Emphasize := true;
    end;

    local procedure vText9OnFormat()
    begin
        if VArrayMomActive[9] = false then
            Txt9Editable := false
        else
            Txt9Editable := true;

        if Rec.Level <> 2 then
            Txt9Emphasize := true;
    end;

    local procedure vText10OnFormat()
    begin
        if VArrayMomActive[10] = false then
            Txt10Editable := false
        else
            Txt10Editable := true;

        if Rec.Level <> 2 then
            Txt10Emphasize := true;
    end;

    local procedure vText11OnFormat()
    begin
        if VArrayMomActive[11] = false then
            Txt11Editable := false
        else
            Txt11Editable := true;

        if Rec.Level <> 2 then
            Txt11Emphasize := true;
    end;

    local procedure vText12OnFormat()
    begin
        if VArrayMomActive[12] = false then
            Txt12Editable := false
        else
            Txt12Editable := true;

        if Rec.Level <> 2 then
            Txt12Emphasize := true;
    end;

    local procedure vText13OnFormat()
    begin
        if VArrayMomActive[13] = false then
            Txt13Editable := false
        else
            Txt13Editable := true;

        if Rec.Level <> 2 then
            Txt13Emphasize := true;
    end;

    local procedure vText14OnFormat()
    begin
        if VArrayMomActive[14] = false then
            Txt14Editable := false
        else
            Txt14Editable := true;

        if Rec.Level <> 2 then
            Txt14Emphasize := true;
    end;

    local procedure vText15OnFormat()
    begin
        if VArrayMomActive[15] = false then
            Txt15Editable := false
        else
            Txt15Editable := true;

        if Rec.Level <> 2 then
            Txt15Emphasize := true;

        Rec.SetCurrentKey("Class No.");//Normatica 2012.07.08
    end;
}

#pragma implicitwith restore

