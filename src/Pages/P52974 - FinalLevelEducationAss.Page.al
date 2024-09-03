#pragma implicitwith disable
page 52974 "Final Level Education Ass."
{
    Caption = 'Final Level Education Ass.';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
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


                        rClass.Reset;
                        rClass.SetFilter("School Year", cStudentsRegistration.GetShoolYearActiveClosing);
                        if rClass.FindSet then begin
                            if PAGE.RunModal(PAGE::"Class List", rClass) = ACTION::LookupOK then begin
                                varClass := rClass.Class;
                                varSchoolYear := rClass."School Year";
                                varSchoolingYear := rClass."Schooling Year";
                                varStudyPlanCode := rClass."Study Plan Code";
                                VarType := rClass.Type;
                                varRespCenter := rClass."Responsibility Center";

                                DeleteBuffer;
                                UpdateForm;
                                InsertStudents;
                                InitTempTable;
                                CurrPage.Update(false);

                                /*
                                //Ir buscar o Codigo dos Averbamentos
                                rAssessmentConfig.RESET;
                                IF tempClass.Type = tempClass.Type::Simple THEN
                                  rAssessmentConfig.SETRANGE(rAssessmentConfig."School Year",tempClass."School Year");
                                rAssessmentConfig.SETRANGE(rAssessmentConfig.Type,tempClass.Type);
                                rAssessmentConfig.SETRANGE(rAssessmentConfig."Study Plan Code",tempClass."Study Plan Code");
                                rAssessmentConfig.SETRANGE(rAssessmentConfig."Country/Region Code",tempClass."Country/Region Code");
                                IF rAssessmentConfig.FINDFIRST THEN
                                   ActualAnnotationCode := rAssessmentConfig."Annotation Code";
                                */

                            end;
                        end;

                    end;

                    trigger OnValidate()
                    var
                        tempClass: Record Class temporary;
                    begin

                        if varClass <> '' then begin
                            rClass.Reset;
                            rClass.SetFilter("School Year", cStudentsRegistration.GetShoolYearActiveClosing);
                            rClass.SetRange(Class, varClass);
                            if rClass.FindFirst then begin
                                varClass := rClass.Class;
                                varSchoolYear := rClass."School Year";
                                varSchoolingYear := rClass."Schooling Year";
                                varStudyPlanCode := rClass."Study Plan Code";
                                VarType := rClass.Type;
                                varRespCenter := rClass."Responsibility Center";

                                DeleteBuffer;
                                UpdateForm;
                                InsertStudents;
                                InitTempTable;

                                /*
                                 //Ir buscar o Codigo dos Averbamentos
                                 rAssessmentConfig.RESET;
                                 IF tempClass.Type = tempClass.Type::Simple THEN
                                   rAssessmentConfig.SETRANGE(rAssessmentConfig."School Year",tempClass."School Year");
                                 rAssessmentConfig.SETRANGE(rAssessmentConfig.Type,tempClass.Type);
                                 rAssessmentConfig.SETRANGE(rAssessmentConfig."Study Plan Code",tempClass."Study Plan Code");
                                 rAssessmentConfig.SETRANGE(rAssessmentConfig."Country/Region Code",tempClass."Country/Region Code");
                                 IF rAssessmentConfig.FINDFIRST THEN
                                    ActualAnnotationCode := rAssessmentConfig."Annotation Code";
                                */
                            end //ELSE
                            //ERROR(Text0009);
                        end else
                            Error(text0013);
                        varClassOnAfterValidate;

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
                    Editable = false;
                }
                field("Student Code No."; Rec."Student Code No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Option Type"; Rec."Option Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Schooling Year"; Rec."Schooling Year")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Subject Code"; Rec."Subject Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Sub-Subject Code"; Rec."Sub-Subject Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Text; Rec.Text)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Txt1; vText[1])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(1);
                    Editable = Txt1Editable;
                    Visible = Txt1Visible;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if VarFinalType[1] <> VarFinalType::"Final Year" then begin
                            GetTypeAssessment(1);
                            vText[1] := LookupFunction(1);
                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 1, vText[1], Rec."Sub-Subject Code");
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        if vText[1] <> '' then begin
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
                    Visible = Txt2Visible;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if VarFinalType[2] <> VarFinalType::"Final Year" then begin
                            GetTypeAssessment(2);
                            vText[2] := LookupFunction(2);
                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 2, vText[2], Rec."Sub-Subject Code");
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        if vText[2] <> '' then begin

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
                    Visible = Txt3Visible;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if VarFinalType[3] <> VarFinalType::"Final Year" then begin
                            GetTypeAssessment(3);
                            vText[3] := LookupFunction(3);
                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 3, vText[3], Rec."Sub-Subject Code");
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        if vText[3] <> '' then begin

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
                    Visible = Txt4Visible;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if VarFinalType[4] <> VarFinalType::"Final Year" then begin
                            GetTypeAssessment(4);
                            vText[4] := LookupFunction(4);
                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 4, vText[4], Rec."Sub-Subject Code");
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        if vText[4] <> '' then begin

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
                    Visible = Txt5Visible;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if VarFinalType[5] <> VarFinalType::"Final Year" then begin
                            GetTypeAssessment(5);
                            vText[5] := LookupFunction(5);
                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 5, vText[5], Rec."Sub-Subject Code");
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        if vText[5] <> '' then begin
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
                    Visible = Txt6Visible;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if VarFinalType[6] <> VarFinalType::"Final Year" then begin
                            GetTypeAssessment(6);
                            vText[6] := LookupFunction(6);
                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 6, vText[6], Rec."Sub-Subject Code");
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        if vText[6] <> '' then begin
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
                    Visible = Txt7Visible;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if VarFinalType[7] <> VarFinalType::"Final Year" then begin
                            GetTypeAssessment(7);
                            vText[7] := LookupFunction(7);
                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 7, vText[7], Rec."Sub-Subject Code");
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        if vText[7] <> '' then begin
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
                    Visible = Txt8Visible;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if VarFinalType[8] <> VarFinalType::"Final Year" then begin
                            GetTypeAssessment(8);
                            vText[8] := LookupFunction(8);
                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 8, vText[8], Rec."Sub-Subject Code");
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        if vText[8] <> '' then begin
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
                    Visible = Txt9Visible;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if VarFinalType[9] <> VarFinalType::"Final Year" then begin
                            GetTypeAssessment(9);
                            vText[9] := LookupFunction(9);
                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 9, vText[9], Rec."Sub-Subject Code");
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        if vText[9] <> '' then begin
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
                    Visible = Txt10Visible;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if VarFinalType[10] <> VarFinalType::"Final Year" then begin
                            GetTypeAssessment(10);
                            vText[10] := LookupFunction(10);
                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 10, vText[10], Rec."Sub-Subject Code");
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        if vText[10] <> '' then begin
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
                    Visible = Txt11Visible;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if VarFinalType[11] <> VarFinalType::"Final Year" then begin
                            GetTypeAssessment(11);
                            vText[11] := LookupFunction(11);
                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 11, vText[11], Rec."Sub-Subject Code");
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        if vText[11] <> '' then begin
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
                    Visible = Txt12Visible;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if VarFinalType[12] <> VarFinalType::"Final Year" then begin
                            GetTypeAssessment(12);
                            vText[12] := LookupFunction(12);
                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 12, vText[12], Rec."Sub-Subject Code");
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        if vText[12] <> '' then begin

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
                    Visible = Txt13Visible;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if VarFinalType[13] <> VarFinalType::"Final Year" then begin
                            GetTypeAssessment(13);
                            vText[13] := LookupFunction(13);
                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 13, vText[13], Rec."Sub-Subject Code");
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        if vText[13] <> '' then begin
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
                    Visible = Txt14Visible;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if VarFinalType[14] <> VarFinalType::"Final Year" then begin
                            GetTypeAssessment(14);
                            vText[14] := LookupFunction(14);
                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 14, vText[14], Rec."Sub-Subject Code");
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        if vText[14] <> '' then begin

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
                    Visible = Txt15Visible;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if VarFinalType[15] <> VarFinalType::"Final Year" then begin
                            GetTypeAssessment(15);
                            vText[15] := LookupFunction(15);
                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 15, vText[15], Rec."Sub-Subject Code");
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        if vText[15] <> '' then begin

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

                        end else
                            Rec.DeleteAssessignStudents(varClass, varSubjects, varRespCenter, varSchoolYear, varSchoolingYear, varStudyPlanCode,
                                                    Rec."Student Code No.", vArrayCodMomento[15], Rec."Sub-Subject Code");
                        vText15OnAfterValidate;
                    end;
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
                Visible = false;

                trigger OnAction()
                begin
                    if Rec.Level = 1 then begin
                        varTypeButtonEdit := true;
                        if (varClass <> '') and (varSubjects <> '') then begin

                            Clear(fAnnotationWizard);

                            fAnnotationWizard.GetAnnotationCode(ActualAnnotationCode);
                            fAnnotationWizard.GetMomentInformation(varSelectedMoment);

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
                Visible = false;

                trigger OnAction()
                begin


                    if Rec.Level = 1 then begin

                        //IF cPermissions.AllowGlobalObs(varClass,varSchoolYear,varSchoolingYear) THEN BEGIN
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
                        //END ELSE
                        //  MESSAGE(Text0009);
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
                Visible = false;

                trigger OnAction()
                begin
                    varTypeButtonEdit := true;
                    if (varClass <> '') then begin

                        Clear(fRemarksWizard);
                        fRemarksWizard.GetObservationCode(ActualObservationCode);
                        fRemarksWizard.GetMomentInformation(varSelectedMoment);

                        varTypeButtonEdit := false;
                        fRemarksWizard.GetInformation(Rec."Student Code No.", varSchoolYear, varClass, varSchoolingYear, varStudyPlanCode, Rec."Subject Code",
                                          Rec."Sub-Subject Code", Rec."Class No.", VarType, varTypeButtonEdit);
                        fRemarksWizard.Run;
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
                ActualExpansionStatus := 2
            else
                ActualExpansionStatus := 0;

        InsertColunm;

        EditableFuction;
        ClassNoOnFormat;
        StudentCodeNoOnFormat;
        OptionTypeOnFormat;
        SubjectCodeOnFormat;
        SubSubjectCodeOnFormat;
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
        Txt15Visible := true;
        Txt14Visible := true;
        Txt13Visible := true;
        Txt12Visible := true;
        Txt11Visible := true;
        Txt10Visible := true;
        Txt9Visible := true;
        Txt8Visible := true;
        Txt7Visible := true;
        Txt6Visible := true;
        Txt5Visible := true;
        Txt4Visible := true;
        Txt3Visible := true;
        Txt2Visible := true;
        Txt1Visible := true;
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
        rStruEduCountry: Record "Structure Education Country";
        rStruEduCountry2: Record "Structure Education Country";
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
        rRegistration: Record Registration;
        rClass: Record Class;
        varTransitionStatus: Option " ",Registered,Transited,"Not Transited",Concluded,"Not Concluded",Abandonned,"Registration Annulled",Tranfered,"Exclusion by Incidences","Ongoing evaluation","Retained from Absences";
        text0014: Label 'To change the option the option type must be student.';
        text0015: Label 'The student has been processed for the next school year.';
        VarFinalType: array[15] of Option " ","Final Year","Final Cycle","Final Stage";
        rCourseLinesTEMP: Record "Course Lines" temporary;
        rCourseLinesTEMP2: Record "Course Lines" temporary;
        rCourseLines: Record "Course Lines";
        rAssessingStudents: Record "Assessing Students";
        rAssessingStudentsTEMP: Record "Assessing Students" temporary;
        VarlineNo: Integer;
        Window: Dialog;
        text0016: Label 'Student  \@1@@@@@@@@@@@@@@@@@@@@@\';
        Nreg: Integer;
        countReg: Integer;
        text0017: Label 'Subjects  \@2@@@@@@@@@@@@@@@@@@@@@\';
        text0018: Label 'Previous Schooling year  \@3@@@@@@@@@@@@@@@@@@@@@\';
        [InDataSet]
        "Class No.Emphasize": Boolean;
        [InDataSet]
        "Student Code No.Emphasize": Boolean;
        [InDataSet]
        "Option TypeEmphasize": Boolean;
        [InDataSet]
        "Subject CodeEmphasize": Boolean;
        [InDataSet]
        "Sub-Subject CodeEmphasize": Boolean;
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
        [InDataSet]
        Txt1Visible: Boolean;
        [InDataSet]
        Txt2Visible: Boolean;
        [InDataSet]
        Txt3Visible: Boolean;
        [InDataSet]
        Txt4Visible: Boolean;
        [InDataSet]
        Txt5Visible: Boolean;
        [InDataSet]
        Txt6Visible: Boolean;
        [InDataSet]
        Txt7Visible: Boolean;
        [InDataSet]
        Txt8Visible: Boolean;
        [InDataSet]
        Txt9Visible: Boolean;
        [InDataSet]
        Txt10Visible: Boolean;
        [InDataSet]
        Txt11Visible: Boolean;
        [InDataSet]
        Txt12Visible: Boolean;
        [InDataSet]
        Txt13Visible: Boolean;
        [InDataSet]
        Txt14Visible: Boolean;
        [InDataSet]
        Txt15Visible: Boolean;
        fRemarksWizard: Page "Remarks Wizard";
        fAnnotationWizard: Page "Annotation Wizard";

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

        Rec.SetCurrentKey("Class No.");
        if Rec.FindFirst then;
    end;

    local procedure HasChildren(ActualAssess: Record "Assign Assessments Buffer" temporary): Boolean
    var
        Assess2: Record "Assign Assessments Buffer" temporary;
    begin

        BufferAssignAssessments.Reset;
        BufferAssignAssessments.SetRange(BufferAssignAssessments."Student Code No.", ActualAssess."Student Code No.");
        BufferAssignAssessments.SetRange(BufferAssignAssessments."Class No.", ActualAssess."Class No.");
        if (ActualAssess."Option Type" = ActualAssess."Option Type"::Subjects) then
            BufferAssignAssessments.SetRange(BufferAssignAssessments."Subject Code", ActualAssess."Subject Code");
        if (ActualAssess."Option Type" = ActualAssess."Option Type"::"Sub-Subjects") then
            BufferAssignAssessments.SetRange(BufferAssignAssessments."Sub-Subject Code", ActualAssess."Sub-Subject Code");
        if (ActualAssess."Option Type" = ActualAssess."Option Type"::"Schooling Year") then
            BufferAssignAssessments.SetRange(BufferAssignAssessments."Schooling Year", ActualAssess."Schooling Year");
        if BufferAssignAssessments.FindLast then begin
            exit(BufferAssignAssessments.Level <= ActualAssess.Level);
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
        if (ActualExpansionStatus = 0) then begin // Has children, but not expanded
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

        rStruEduCountry.Reset;
        rStruEduCountry.SetRange("Schooling Year", varSchoolingYear);
        if rStruEduCountry.FindFirst then;


        rStruEduCountry2.Reset;
        rStruEduCountry2.SetCurrentKey("Sorting ID");
        rStruEduCountry2.SetRange(Country, rStruEduCountry.Country);
        rStruEduCountry2.SetRange("Edu. Level", rStruEduCountry."Edu. Level");
        if rStruEduCountry2.FindSet then begin
            repeat
                if rStruEduCountry2."Schooling Year" <> varSchoolingYear then begin
                    indx := indx + 1;
                    vArrayCodMomento[indx] := rStruEduCountry2."Schooling Year";
                    vArrayMomento[indx] := rStruEduCountry2."Schooling Year";
                    VarFinalType[indx] := VarFinalType::"Final Year";
                    if rStruEduCountry2."Final Cycle Caption" <> '' then begin
                        indx := indx + 1;
                        vArrayCodMomento[indx] := rStruEduCountry2."Schooling Year";
                        vArrayMomento[indx] := rStruEduCountry2."Final Cycle Caption";
                        VarFinalType[indx] := VarFinalType::"Final Cycle";
                    end;
                    if rStruEduCountry2."Final Stage Caption" <> '' then begin
                        indx := indx + 1;
                        vArrayCodMomento[indx] := rStruEduCountry2."Schooling Year";
                        vArrayMomento[indx] := rStruEduCountry2."Final Stage Caption";
                        VarFinalType[indx] := VarFinalType::"Final Stage";
                    end;
                end else begin
                    indx := indx + 1;
                    vArrayCodMomento[indx] := rStruEduCountry2."Schooling Year";
                    vArrayMomento[indx] := rStruEduCountry2."Schooling Year";
                    VarFinalType[indx] := VarFinalType::"Final Year";
                    if rStruEduCountry2."Final Cycle Caption" <> '' then begin
                        indx := indx + 1;
                        vArrayCodMomento[indx] := rStruEduCountry2."Schooling Year";
                        vArrayMomento[indx] := rStruEduCountry2."Final Cycle Caption";
                        VarFinalType[indx] := VarFinalType::"Final Cycle";
                    end;
                    if rStruEduCountry2."Final Stage Caption" <> '' then begin
                        indx := indx + 1;
                        vArrayCodMomento[indx] := rStruEduCountry2."Schooling Year";
                        vArrayMomento[indx] := rStruEduCountry2."Final Stage Caption";
                        VarFinalType[indx] := VarFinalType::"Final Stage";
                    end;
                    exit;
                end;
            until rStruEduCountry2.Next = 0;
        end;
    end;

    //[Scope('OnPrem')]
    procedure UpdateForm()
    begin
        BuildMoments;
    end;

    //[Scope('OnPrem')]
    procedure EditableFuction()
    begin
        if (vArrayCodMomento[1] <> '') then
            Txt1Visible := true
        else
            Txt1Visible := false;

        if (vArrayCodMomento[2] <> '') then
            Txt2Visible := true
        else
            Txt2Visible := false;

        if (vArrayCodMomento[3] <> '') then
            Txt3Visible := true
        else
            Txt3Visible := false;

        if (vArrayCodMomento[4] <> '') then
            Txt4Visible := true
        else
            Txt4Visible := false;

        if (vArrayCodMomento[5] <> '') then
            Txt5Visible := true
        else
            Txt5Visible := false;

        if (vArrayCodMomento[6] <> '') then
            Txt6Visible := true
        else
            Txt6Visible := false;

        if (vArrayCodMomento[7] <> '') then
            Txt7Visible := true
        else
            Txt7Visible := false;

        if (vArrayCodMomento[8] <> '') then
            Txt8Visible := true
        else
            Txt8Visible := false;

        if (vArrayCodMomento[9] <> '') then
            Txt9Visible := true
        else
            Txt9Visible := false;

        if (vArrayCodMomento[10] <> '') then
            Txt10Visible := true
        else
            Txt10Visible := false;

        if (vArrayCodMomento[11] <> '') then
            Txt11Visible := true
        else
            Txt11Visible := false;

        if (vArrayCodMomento[12] <> '') then
            Txt12Visible := true
        else
            Txt12Visible := false;

        if (vArrayCodMomento[13] <> '') then
            Txt13Visible := true
        else
            Txt13Visible := false;

        if (vArrayCodMomento[14] <> '') then
            Txt14Visible := true
        else
            Txt14Visible := false;

        if (vArrayCodMomento[15] <> '') then
            Txt15Visible := true
        else
            Txt15Visible := false;
    end;

    //[Scope('OnPrem')]
    procedure getCaptionLabel(label: Integer) out: Text[30]
    begin

        exit(vArrayMomento[label]);
    end;

    //[Scope('OnPrem')]
    procedure GetTypeAssessment(inIndex: Integer)
    var
        rRulesEvaluations: Record "Rules of Evaluations";
    begin

        if Rec."Option Type" = Rec."Option Type"::Student then begin
            rRulesEvaluations.Reset;
            rRulesEvaluations.SetRange("Schooling Year", vArrayCodMomento[inIndex]);
            rRulesEvaluations.SetRange("Classifications Calculations", rRulesEvaluations."Classifications Calculations"::"Final Cycle");
            if rRulesEvaluations.FindFirst then begin
                if rRankGroup.Get(rRulesEvaluations."Assessment Code") then begin
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
        rRulesEvaluations: Record "Rules of Evaluations";
    begin
        rRulesEvaluations.Reset;
        rRulesEvaluations.SetRange("Schooling Year", vArrayCodMomento[InIndex]);
        rRulesEvaluations.SetRange("Classifications Calculations", rRulesEvaluations."Classifications Calculations"::"Final Cycle");
        if rRulesEvaluations.FindFirst then;


        if rRulesEvaluations."Evaluation Type" = rRulesEvaluations."Evaluation Type"::Qualitative then begin
            rClassificationLevel.Reset;
            rClassificationLevel.SetRange("Classification Group Code", rRulesEvaluations."Assessment Code");
            if rClassificationLevel.Find('-') then begin
                if PAGE.RunModal(PAGE::"List Grades", rClassificationLevel) = ACTION::LookupOK then
                    exit(rClassificationLevel."Classification Level Code");
            end else
                exit(vText[InIndex]);
        end;

        if (rRulesEvaluations."Evaluation Type" = rRulesEvaluations."Evaluation Type"::"Mixed-Qualification") then begin
            rClassificationLevel.Reset;
            rClassificationLevel.SetRange("Classification Group Code", rRulesEvaluations."Assessment Code");
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
        rAssessingStudentsFinal: Record "Assessing Students Final";
        l_Registration: Record Registration;
    begin
        l_Registration.Reset;
        l_Registration.SetRange("Student Code No.", Rec."Student Code No.");
        l_Registration.SetRange("Schooling Year", vArrayCodMomento[inIndex]);
        l_Registration.SetRange(Status, l_Registration.Status::Subscribed);
        if l_Registration.FindLast then;


        if Rec."Option Type" = Rec."Option Type"::Student then begin
            rAssessingStudentsFinal.Reset;
            rAssessingStudentsFinal.SetRange("School Year", l_Registration."School Year");
            if VarFinalType[inIndex] = VarFinalType::"Final Cycle" then
                rAssessingStudentsFinal.SetRange("Evaluation Type", rAssessingStudentsFinal."Evaluation Type"::"Final Cycle");
            if VarFinalType[inIndex] = VarFinalType::"Final Stage" then
                rAssessingStudentsFinal.SetRange("Evaluation Type", rAssessingStudentsFinal."Evaluation Type"::"Final Stage");
            rAssessingStudentsFinal.SetRange("Schooling Year", vArrayCodMomento[inIndex]);
            rAssessingStudentsFinal.SetRange(Subject, Rec."Subject Code");
            rAssessingStudentsFinal.SetRange("Sub-Subject Code", Rec."Sub-Subject Code");
            if l_Registration."Study Plan Code" <> '' then begin
                rAssessingStudentsFinal.SetRange("Study Plan Code", l_Registration."Study Plan Code");
                rAssessingStudentsFinal.SetRange("Type Education", rAssessingStudentsFinal."Type Education"::Simple);
            end;
            if l_Registration.Course <> '' then begin
                rAssessingStudentsFinal.SetRange("Study Plan Code", l_Registration.Course);
                rAssessingStudentsFinal.SetRange("Type Education", rAssessingStudentsFinal."Type Education"::Multi);
            end;
            rAssessingStudentsFinal.SetRange("Student Code No.", inStudentCode);
            if rAssessingStudentsFinal.FindFirst then begin

                if vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::Quantitative then
                    Evaluate(rAssessingStudentsFinal.Grade, inText);

                if (vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::Qualitative) then
                    rAssessingStudentsFinal."Qualitative Grade" := inText;

                if (vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::"Mixed-Qualification") then begin
                    if varMixedClassification then begin
                        rAssessingStudentsFinal."Qualitative Grade" := varClassification;
                        if inText <> '' then
                            Evaluate(rAssessingStudentsFinal.Grade, inText)
                        else
                            rAssessingStudentsFinal.Grade := 0;
                    end else begin
                        if not Evaluate(rAssessingStudentsFinal.Grade, varClassification) then
                            rAssessingStudentsFinal.Grade := 0;
                        rAssessingStudentsFinal."Qualitative Grade" := inText;
                    end;
                end;

                rAssessingStudentsFinal.Modify(true);
            end else begin
                rAssessingStudentsFinal.Init;
                rAssessingStudentsFinal.Class := l_Registration.Class;
                rAssessingStudentsFinal."School Year" := l_Registration."School Year";
                rAssessingStudentsFinal."Schooling Year" := vArrayCodMomento[inIndex];
                if l_Registration."Study Plan Code" <> '' then begin
                    rAssessingStudentsFinal."Study Plan Code" := l_Registration."Study Plan Code";
                    rAssessingStudentsFinal."Type Education" := rAssessingStudentsFinal."Type Education"::Simple;
                end;
                if l_Registration.Course <> '' then begin
                    rAssessingStudentsFinal."Study Plan Code" := l_Registration.Course;
                    rAssessingStudentsFinal."Type Education" := rAssessingStudentsFinal."Type Education"::Multi;
                end;
                rAssessingStudentsFinal."Country/Region Code" := l_Registration."Country/Region Code";
                rAssessingStudentsFinal."Student Code No." := inStudentCode;
                rAssessingStudentsFinal."Class No." := l_Registration."Class No.";
                if VarFinalType[inIndex] = VarFinalType::"Final Cycle" then
                    rAssessingStudentsFinal."Evaluation Type" := rAssessingStudentsFinal."Evaluation Type"::"Final Cycle";
                if VarFinalType[inIndex] = VarFinalType::"Final Stage" then
                    rAssessingStudentsFinal."Evaluation Type" := rAssessingStudentsFinal."Evaluation Type"::"Final Stage";


                if vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::Qualitative then
                    rAssessingStudentsFinal."Qualitative Grade" := inText;

                if vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::Quantitative then
                    Evaluate(rAssessingStudentsFinal.Grade, inText);

                if vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::"Mixed-Qualification" then begin
                    if varMixedClassification then begin
                        Evaluate(rAssessingStudentsFinal.Grade, inText);
                        rAssessingStudentsFinal."Qualitative Grade" := varClassification;
                    end else begin
                        Evaluate(rAssessingStudentsFinal.Grade, varClassification);
                        rAssessingStudentsFinal."Qualitative Grade" := inText;
                    end;
                end;
                rAssessingStudentsFinal.Insert(true);
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure GetAssessment(inStudentCode: Code[20]; inClassNo: Integer; inIndex: Integer; inText: Text[250]; inSubSubjCode: Code[20]) Out: Text[100]
    var
        rAssessingStudents: Record "Assessing Students";
        l_FinalAssessingStudents: Record "Assessing Students Final";
    begin
        GetRegistrationAproved(false);
        if (Rec."Option Type" = Rec."Option Type"::"Option Group") or (Rec."Option Type" = Rec."Option Type"::Student) or
          (Rec."Option Type" = Rec."Option Type"::Subjects) then begin
            GetTypeAssessment(inIndex);
            l_FinalAssessingStudents.Reset;
            l_FinalAssessingStudents.SetRange("Student Code No.", Rec."Student Code No.");
            l_FinalAssessingStudents.SetRange("Schooling Year", vArrayCodMomento[inIndex]);
            if (Rec."Option Type" = Rec."Option Type"::Subjects) or (Rec."Option Type" = Rec."Option Type"::"Option Group") then begin
                if (Rec."Option Type" = Rec."Option Type"::Student) or (Rec."Option Type" = Rec."Option Type"::"Option Group") then
                    if VarFinalType[inIndex] = VarFinalType[inIndex] ::"Final Year" then
                        l_FinalAssessingStudents.SetRange("Evaluation Type", l_FinalAssessingStudents."Evaluation Type"::"Final Year");
                if VarFinalType[inIndex] = VarFinalType[inIndex] ::"Final Stage" then
                    l_FinalAssessingStudents.SetRange("Evaluation Type", l_FinalAssessingStudents."Evaluation Type"::"Final Stage");
                if VarFinalType[inIndex] = VarFinalType[inIndex] ::"Final Cycle" then
                    l_FinalAssessingStudents.SetRange("Evaluation Type", l_FinalAssessingStudents."Evaluation Type"::"Final Cycle");
                if Rec."Option Type" <> Rec."Option Type"::"Option Group" then
                    l_FinalAssessingStudents.SetRange(Subject, Rec."Subject Code");
                l_FinalAssessingStudents.SetRange("Sub-Subject Code", Rec."Sub-Subject Code");
            end;
            if Rec."Option Type" = Rec."Option Type"::"Option Group" then begin
                l_FinalAssessingStudents.SetRange("Evaluation Type", l_FinalAssessingStudents."Evaluation Type"::"Final Year Group");
                l_FinalAssessingStudents.SetRange("Option Group", Rec."Subject Code");
            end;
            if (vArrayCodMomento[inIndex] <> Rec."Schooling Year") and (Rec."Option Type" <> Rec."Option Type"::Student) then
                exit('');
            if l_FinalAssessingStudents.FindFirst then begin
                if varMixedClassification then begin
                    if l_FinalAssessingStudents."Manual Grade" <> 0 then
                        exit(Format(l_FinalAssessingStudents."Manual Grade"))
                    else
                        exit(Format(l_FinalAssessingStudents.Grade));
                end else begin
                    if l_FinalAssessingStudents."Qualitative Manual Grade" <> '' then
                        exit(Format(l_FinalAssessingStudents."Manual Grade"))
                    else
                        exit(Format(l_FinalAssessingStudents."Qualitative Grade"));
                end;
            end else
                if (VarFinalType[inIndex] = VarFinalType::"Final Year") and (vArrayCodMomento[inIndex] = Rec."Schooling Year") then begin
                    GetTypeAssessment(inIndex);
                    rAssessingStudents.Reset;
                    rAssessingStudents.SetRange("Schooling Year", vArrayCodMomento[inIndex]);
                    rAssessingStudents.SetRange(Subject, Rec."Subject Code");
                    rAssessingStudents.SetRange("Sub-Subject Code", Rec."Sub-Subject Code");
                    rAssessingStudents.SetRange("Student Code No.", Rec."Student Code No.");
                    rAssessingStudents.SetRange("Evaluation Moment", rAssessingStudents."Evaluation Moment"::"Final Year");
                    if rAssessingStudents.FindFirst then begin
                        if varMixedClassification then begin
                            if rAssessingStudents."Recuperation Grade" <> 0 then
                                exit(Format(rAssessingStudents."Recuperation Grade"))
                            else begin
                                if rAssessingStudents.Grade <> 0 then
                                    exit(Format(rAssessingStudents.Grade))
                                else
                                    exit(Format(rAssessingStudents."Grade Calc"));
                            end;
                        end
                        else begin
                            if rAssessingStudents."Recuperation Qualitative Grade" <> '' then
                                exit(rAssessingStudents."Recuperation Qualitative Grade")
                            else
                                exit(rAssessingStudents."Qualitative Grade");
                        end;

                    end else
                        exit('');
                end else
                    exit('');
        end;
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
                    if rClassificationLevelMin.Find('-') then
                        VarMinValue := rClassificationLevelMin."Min Value";

                    rClassificationLevelMax.Reset;
                    rClassificationLevelMax.SetCurrentKey("Id Ordination");
                    rClassificationLevelMax.Ascending(false);
                    rClassificationLevelMax.SetRange("Classification Group Code", vArrayAssessmentCode[InIndex]);
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
        if not IsGlobal then begin
            if (Rec."Option Type" = Rec."Option Type"::Subjects) or (Rec."Option Type" = Rec."Option Type"::"Sub-Subjects") then begin
                l_rRemarks.SetRange(Subject, Rec."Subject Code");
                l_rRemarks.SetRange("Sub-subject", Rec."Sub-Subject Code");
            end;
        end else
            l_rRemarks.SetRange(Subject, '');
        if l_rRemarks.FindFirst then
            ExitValue := true;

        exit(ExitValue);
    end;

    //[Scope('OnPrem')]
    procedure TestSettingRatings()
    var
        lSettingRatings: Record "Setting Ratings";
    begin
        lSettingRatings.Reset;
        //lSettingRatings.SETRANGE(lSettingRatings."Moment Code",varActiveMoment);
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
    procedure DeleteBuffer()
    begin
        BufferAssignAssessments.Reset;
        BufferAssignAssessments.DeleteAll;
    end;

    //[Scope('OnPrem')]
    procedure InsertStudents()
    var
        l_Students: Record Students;
        l_RegistrationSubjects: Record "Registration Subjects";
        l_StudentSubSubjects: Record "Student Sub-Subjects Plan ";
        l_RegistrationSubjects2: Record "Registration Subjects";
        l_GroupSubjects: Record "Group Subjects";
        flag: Boolean;
        l_nrs: Integer;
        Count_RS: Integer;
    begin
        DeleteBuffer;

        VarlineNo := 0;

        rRegistration.Reset;
        rRegistration.SetCurrentKey(Class, "Class No.");
        rRegistration.SetRange(Class, varClass);
        rRegistration.SetRange("Responsibility Center", varRespCenter);
        rRegistration.SetRange("Schooling Year", varSchoolingYear);
        rRegistration.SetRange("School Year", varSchoolYear);
        rRegistration.SetRange(Status, rRegistration.Status::Subscribed);
        if rRegistration.FindSet then begin
            Window.Open(text0016 + text0017 + text0018);
            Nreg := rRegistration.Count;
            repeat
                countReg += 1;
                Window.Update(1, Round(countReg / Nreg * 10000, 1));


                BufferAssignAssessments.Reset;
                BufferAssignAssessments.Init;
                BufferAssignAssessments."User ID" := UserId;
                VarlineNo += 10000;
                BufferAssignAssessments."Line No." := VarlineNo;
                BufferAssignAssessments."Student Code No." := rRegistration."Student Code No.";
                BufferAssignAssessments."Class No." := rRegistration."Class No.";
                if l_Students.Get(rRegistration."Student Code No.") then begin
                    BufferAssignAssessments.Text := l_Students.Name;
                end;
                BufferAssignAssessments."Subject Code" := '';
                BufferAssignAssessments.Level := 1;
                BufferAssignAssessments."Option Type" := BufferAssignAssessments."Option Type"::Student;
                BufferAssignAssessments.Insert;


                for indx := 1 to 15 do begin
                    if VarFinalType[indx] = VarFinalType::"Final Year" then begin

                        BufferAssignAssessments.Reset;
                        BufferAssignAssessments.SetRange("Student Code No.", rRegistration."Student Code No.");
                        BufferAssignAssessments.SetRange("Schooling Year", vArrayCodMomento[indx]);
                        if not BufferAssignAssessments.FindSet then begin
                            BufferAssignAssessments.Init;
                            BufferAssignAssessments."User ID" := UserId;
                            VarlineNo += 10000;
                            BufferAssignAssessments."Line No." := VarlineNo;
                            BufferAssignAssessments."Student Code No." := rRegistration."Student Code No.";
                            BufferAssignAssessments."Class No." := rRegistration."Class No.";
                            BufferAssignAssessments."Subject Code" := '';
                            BufferAssignAssessments.Level := 2;
                            BufferAssignAssessments."Option Type" := BufferAssignAssessments."Option Type"::"Schooling Year";
                            BufferAssignAssessments."Schooling Year" := vArrayCodMomento[indx];
                            BufferAssignAssessments.Insert;
                        end;

                        l_RegistrationSubjects.Reset;
                        l_RegistrationSubjects.SetCurrentKey("Student Code No.", "Option Group", "Sorting ID");
                        l_RegistrationSubjects.SetRange("Student Code No.", rRegistration."Student Code No.");
                        l_RegistrationSubjects.SetRange("Schooling Year", vArrayCodMomento[indx]);
                        l_RegistrationSubjects.SetRange(Status, l_RegistrationSubjects.Status::Subscribed);
                        l_RegistrationSubjects.SetRange("Responsibility Center", rRegistration."Responsibility Center");
                        l_RegistrationSubjects.SetFilter("Evaluation Type", '<>%1', l_RegistrationSubjects."Evaluation Type"::"None Qualification");
                        if l_RegistrationSubjects.FindSet then begin
                            l_nrs := l_RegistrationSubjects.Count;
                            flag := true;
                            repeat
                                Count_RS += 1;
                                Window.Update(2, Round(Count_RS / l_nrs * 10000, 1));

                                if (l_RegistrationSubjects."Option Group" = '') and (flag) then begin
                                    flag := false;
                                    l_RegistrationSubjects2.Reset;
                                    l_RegistrationSubjects2.SetCurrentKey("Student Code No.", "Option Group", "Sorting ID");
                                    l_RegistrationSubjects2.SetRange("Student Code No.", rRegistration."Student Code No.");
                                    l_RegistrationSubjects2.SetRange("Schooling Year", vArrayCodMomento[indx]);
                                    l_RegistrationSubjects2.SetRange("Option Group", l_RegistrationSubjects."Option Group");
                                    l_RegistrationSubjects2.SetRange(Status, l_RegistrationSubjects2.Status::Subscribed);
                                    l_RegistrationSubjects2.SetRange("Responsibility Center", rRegistration."Responsibility Center");
                                    l_RegistrationSubjects2.SetFilter("Evaluation Type", '<>%1',
                                    l_RegistrationSubjects2."Evaluation Type"::"None Qualification");
                                    if l_RegistrationSubjects2.FindSet then begin
                                        repeat
                                            BufferAssignAssessments.Reset;
                                            BufferAssignAssessments.Init;
                                            BufferAssignAssessments."User ID" := UserId;
                                            VarlineNo += 10000;
                                            BufferAssignAssessments."Line No." := VarlineNo;
                                            BufferAssignAssessments."Student Code No." := l_RegistrationSubjects."Student Code No.";
                                            BufferAssignAssessments."Class No." := rRegistration."Class No.";
                                            BufferAssignAssessments."Subject Code" := l_RegistrationSubjects2."Subjects Code";
                                            BufferAssignAssessments.Text := l_RegistrationSubjects2.Description;
                                            BufferAssignAssessments.Level := 3;
                                            BufferAssignAssessments."Option Type" := BufferAssignAssessments."Option Type"::Subjects;
                                            BufferAssignAssessments."Schooling Year" := vArrayCodMomento[indx];
                                            BufferAssignAssessments.Insert;

                                            l_RegistrationSubjects2.CalcFields("Sub-subject");

                                            if l_RegistrationSubjects2."Sub-subject" then begin
                                                l_StudentSubSubjects.Reset;
                                                l_StudentSubSubjects.SetRange("Student Code No.", rRegistration."Student Code No.");
                                                l_StudentSubSubjects.SetRange("Subject Code", l_RegistrationSubjects2."Subjects Code");
                                                l_StudentSubSubjects.SetRange("Schooling Year", vArrayCodMomento[indx]);
                                                l_StudentSubSubjects.SetRange("Responsibility Center", rRegistration."Responsibility Center");
                                                l_StudentSubSubjects.SetRange(Type, l_RegistrationSubjects2.Type);
                                                l_StudentSubSubjects.SetFilter("Evaluation Type", '<>%1',
                                                l_StudentSubSubjects."Evaluation Type"::"None Qualification");
                                                if l_StudentSubSubjects.FindSet then begin
                                                    repeat
                                                        BufferAssignAssessments.Reset;
                                                        BufferAssignAssessments.Init;
                                                        BufferAssignAssessments."User ID" := UserId;
                                                        VarlineNo += 10000;
                                                        BufferAssignAssessments."Line No." := VarlineNo;
                                                        BufferAssignAssessments."Student Code No." := rRegistration."Student Code No.";
                                                        BufferAssignAssessments."Class No." := rRegistration."Class No.";
                                                        BufferAssignAssessments."Subject Code" := l_StudentSubSubjects."Subject Code";
                                                        BufferAssignAssessments."Sub-Subject Code" := l_StudentSubSubjects."Sub-Subject Code";
                                                        BufferAssignAssessments.Text := l_StudentSubSubjects."Sub-Subject Description";
                                                        BufferAssignAssessments.Level := 4;
                                                        BufferAssignAssessments."Option Type" := BufferAssignAssessments."Option Type"::"Sub-Subjects";
                                                        BufferAssignAssessments."Schooling Year" := vArrayCodMomento[indx];
                                                        BufferAssignAssessments.Insert;

                                                    until l_StudentSubSubjects.Next = 0;
                                                end;
                                            end;
                                        until l_RegistrationSubjects2.Next = 0;
                                    end;


                                end else begin
                                    BufferAssignAssessments.Reset;
                                    BufferAssignAssessments.SetRange("Student Code No.", rRegistration."Student Code No.");
                                    //BufferAssignAssessments.SETRANGE("Class No.",l_RegistrationSubjects."Class No.");
                                    BufferAssignAssessments.SetRange("Schooling Year", vArrayCodMomento[indx]);
                                    BufferAssignAssessments.SetFilter("Subject Code", l_RegistrationSubjects."Option Group");
                                    if not BufferAssignAssessments.FindFirst then begin

                                        BufferAssignAssessments.Init;
                                        BufferAssignAssessments."User ID" := UserId;
                                        VarlineNo += 10000;
                                        BufferAssignAssessments."Line No." := VarlineNo;
                                        BufferAssignAssessments."Student Code No." := l_RegistrationSubjects."Student Code No.";
                                        BufferAssignAssessments."Class No." := rRegistration."Class No.";
                                        BufferAssignAssessments."Subject Code" := l_RegistrationSubjects."Option Group";
                                        l_GroupSubjects.Reset;
                                        l_GroupSubjects.SetRange(Code, l_RegistrationSubjects."Option Group");
                                        if l_RegistrationSubjects.Type = l_RegistrationSubjects.Type::Simple then
                                            l_GroupSubjects.SetRange("Schooling Year", l_RegistrationSubjects."Schooling Year")
                                        else
                                            l_GroupSubjects.SetRange("Schooling Year", '');
                                        if l_GroupSubjects.FindFirst then
                                            BufferAssignAssessments.Text := l_GroupSubjects.Description;
                                        BufferAssignAssessments.Level := 3;
                                        BufferAssignAssessments."Option Type" := BufferAssignAssessments."Option Type"::"Option Group";
                                        BufferAssignAssessments."Schooling Year" := vArrayCodMomento[indx];
                                        BufferAssignAssessments.Insert;

                                        l_RegistrationSubjects2.Reset;
                                        l_RegistrationSubjects2.SetCurrentKey("Student Code No.", "Option Group", "Sorting ID");
                                        l_RegistrationSubjects2.SetRange("Student Code No.", rRegistration."Student Code No.");
                                        l_RegistrationSubjects2.SetRange("Schooling Year", vArrayCodMomento[indx]);
                                        l_RegistrationSubjects2.SetRange("Option Group", l_RegistrationSubjects."Option Group");
                                        l_RegistrationSubjects2.SetRange(Status, l_RegistrationSubjects2.Status::Subscribed);
                                        l_RegistrationSubjects2.SetRange("Responsibility Center", rRegistration."Responsibility Center");
                                        l_RegistrationSubjects2.SetFilter("Evaluation Type", '<>%1',
                                        l_RegistrationSubjects2."Evaluation Type"::"None Qualification");
                                        if l_RegistrationSubjects2.FindSet then begin
                                            repeat
                                                BufferAssignAssessments.Reset;
                                                BufferAssignAssessments.Init;
                                                BufferAssignAssessments."User ID" := UserId;
                                                VarlineNo += 10000;
                                                BufferAssignAssessments."Line No." := VarlineNo;
                                                BufferAssignAssessments."Student Code No." := l_RegistrationSubjects."Student Code No.";
                                                BufferAssignAssessments."Class No." := rRegistration."Class No.";
                                                BufferAssignAssessments."Subject Code" := l_RegistrationSubjects2."Subjects Code";
                                                BufferAssignAssessments.Text := l_RegistrationSubjects2.Description;
                                                BufferAssignAssessments.Level := 4;
                                                BufferAssignAssessments."Option Type" := BufferAssignAssessments."Option Type"::Subjects;
                                                BufferAssignAssessments."Schooling Year" := vArrayCodMomento[indx];
                                                BufferAssignAssessments.Insert;

                                                l_RegistrationSubjects2.CalcFields("Sub-subject");

                                                if l_RegistrationSubjects2."Sub-subject" then begin
                                                    l_StudentSubSubjects.Reset;
                                                    l_StudentSubSubjects.SetRange("Student Code No.", rRegistration."Student Code No.");
                                                    l_StudentSubSubjects.SetRange("Subject Code", l_RegistrationSubjects2."Subjects Code");
                                                    l_StudentSubSubjects.SetRange("Schooling Year", rRegistration."Schooling Year");
                                                    l_StudentSubSubjects.SetRange("Responsibility Center", rRegistration."Responsibility Center");
                                                    l_StudentSubSubjects.SetRange(Type, l_RegistrationSubjects2.Type);
                                                    l_StudentSubSubjects.SetFilter("Evaluation Type", '<>%1',
                                                    l_StudentSubSubjects."Evaluation Type"::"None Qualification");
                                                    if l_StudentSubSubjects.FindSet then begin
                                                        repeat
                                                            BufferAssignAssessments.Reset;
                                                            BufferAssignAssessments.Init;
                                                            BufferAssignAssessments."User ID" := UserId;
                                                            VarlineNo += 10000;
                                                            BufferAssignAssessments."Line No." := VarlineNo;
                                                            BufferAssignAssessments."Student Code No." := rRegistration."Student Code No.";
                                                            BufferAssignAssessments."Class No." := rRegistration."Class No.";
                                                            BufferAssignAssessments."Subject Code" := l_StudentSubSubjects."Subject Code";
                                                            BufferAssignAssessments."Sub-Subject Code" := l_StudentSubSubjects."Sub-Subject Code";
                                                            BufferAssignAssessments.Text := l_StudentSubSubjects."Sub-Subject Description";
                                                            BufferAssignAssessments.Level := 5;
                                                            BufferAssignAssessments."Option Type" := BufferAssignAssessments."Option Type"::"Sub-Subjects";
                                                            BufferAssignAssessments."Schooling Year" := vArrayCodMomento[indx];
                                                            BufferAssignAssessments.Insert;

                                                        until l_StudentSubSubjects.Next = 0;
                                                    end;
                                                end;
                                            until l_RegistrationSubjects2.Next = 0;
                                        end;
                                    end;
                                end;
                            until l_RegistrationSubjects.Next = 0;
                        end else begin
                            GetMultiplePE(rRegistration."Student Code No.", vArrayCodMomento[indx]);
                            GetStudyPlan(rRegistration."Class No.", rRegistration."Student Code No.");
                        end;
                    end;
                end;//END FOR
            until rRegistration.Next = 0;
        end;
        Window.Close;
    end;

    //[Scope('OnPrem')]
    procedure GetRegistrationAproved(pInsert: Boolean)
    var
        l_Registration: Record Registration;
    begin
        //pInsert = True  insert in the registration
        //pInsert = False get the field
        if pInsert then begin
            l_Registration.Reset;
            l_Registration.SetRange("School Year", varSchoolYear);
            l_Registration.SetRange("Student Code No.", Rec."Student Code No.");
            l_Registration.SetRange(Class, varClass);
            l_Registration.SetRange("Responsibility Center", varRespCenter);
            if l_Registration.FindFirst then begin
                if l_Registration."Next School Year" <> l_Registration."Next School Year"::"In School" then
                    Error(text0015);
                l_Registration."Actual Status" := varTransitionStatus;
                l_Registration.Modify;
            end;
        end;
        if pInsert = false then begin
            if Rec."Option Type" = Rec."Option Type"::Student then begin
                l_Registration.Reset;
                l_Registration.SetRange("School Year", varSchoolYear);
                l_Registration.SetRange("Student Code No.", Rec."Student Code No.");
                l_Registration.SetRange("Responsibility Center", varRespCenter);
                l_Registration.SetRange(Class, varClass);
                if l_Registration.FindFirst then
                    varTransitionStatus := l_Registration."Actual Status";
            end else
                varTransitionStatus := varTransitionStatus::" ";
        end;
    end;

    //[Scope('OnPrem')]
    procedure GetMultiplePE(pStudentCode: Code[20]; pSchoolingYear: Code[10])
    var
        i: Integer;
    begin
        rAssessingStudents.Reset;
        rAssessingStudents.SetRange("Student Code No.", pStudentCode);
        rAssessingStudents.SetRange("Schooling Year", pSchoolingYear);
        rAssessingStudents.SetRange(Class, '');
        rAssessingStudents.SetRange("Evaluation Moment", rAssessingStudents."Evaluation Moment"::"Final Year");
        if rAssessingStudents.FindSet then begin
            repeat
                rAssessingStudentsTEMP.Reset;
                rAssessingStudentsTEMP.SetRange("School Year", rAssessingStudents."School Year");
                rAssessingStudentsTEMP.SetRange("Student Code No.", pStudentCode);
                rAssessingStudentsTEMP.SetRange("Schooling Year", rAssessingStudents."Schooling Year");
                rAssessingStudentsTEMP.SetRange("Study Plan Code", rAssessingStudents."Study Plan Code");
                rAssessingStudentsTEMP.SetRange("Type Education", rAssessingStudents."Type Education");
                if not rAssessingStudentsTEMP.FindFirst then begin
                    rAssessingStudentsTEMP.Init;
                    rAssessingStudentsTEMP.TransferFields(rAssessingStudents);
                    rAssessingStudentsTEMP.Insert;
                end;
            until rAssessingStudents.Next = 0;
        end;
    end;

    //[Scope('OnPrem')]
    procedure GetStudyPlan(pClassNo: Integer; pStudentCode: Code[20])
    var
        l_StudyPlanLines: Record "Study Plan Lines";
        l_StudyPlanLines2: Record "Study Plan Lines";
        l_GroupSubjects: Record "Group Subjects";
        NregSP: Integer;
        countRegSP: Integer;
    begin
        rAssessingStudentsTEMP.Reset;
        rAssessingStudentsTEMP.SetRange("Student Code No.", pStudentCode);
        if rAssessingStudentsTEMP.FindSet then begin
            repeat
                if rAssessingStudentsTEMP."Type Education" = rAssessingStudentsTEMP."Type Education"::Simple then begin
                    l_StudyPlanLines.Reset;
                    l_StudyPlanLines.SetCurrentKey("Option Group", "Sorting ID");
                    l_StudyPlanLines.SetRange(Code, rAssessingStudentsTEMP."Study Plan Code");
                    if l_StudyPlanLines.FindSet then begin
                        BufferAssignAssessments.Reset;
                        BufferAssignAssessments.SetRange("User ID", UserId);
                        BufferAssignAssessments.SetRange("Student Code No.", rAssessingStudentsTEMP."Student Code No.");
                        BufferAssignAssessments.SetRange("Option Type", BufferAssignAssessments."Option Type"::"Schooling Year");
                        BufferAssignAssessments.SetRange("Schooling Year", rAssessingStudentsTEMP."Schooling Year");
                        if not BufferAssignAssessments.FindFirst then begin

                            BufferAssignAssessments.Init;
                            BufferAssignAssessments."User ID" := UserId;
                            VarlineNo += 10000;
                            BufferAssignAssessments."Line No." := VarlineNo;
                            BufferAssignAssessments."Student Code No." := rAssessingStudentsTEMP."Student Code No.";
                            BufferAssignAssessments.Level := 2;
                            BufferAssignAssessments."Option Type" := BufferAssignAssessments."Option Type"::"Schooling Year";
                            BufferAssignAssessments."Schooling Year" := rAssessingStudentsTEMP."Schooling Year";
                            //BufferAssignAssessments.Class := rRegistration.Class;
                            BufferAssignAssessments."Class No." := pClassNo;
                            BufferAssignAssessments.Insert;
                        end;
                        NregSP := l_StudyPlanLines.Count;
                        repeat
                            countRegSP += 1;
                            Window.Update(3, Round(countRegSP / NregSP * 10000, 1));

                            if l_StudyPlanLines."Option Group" = '' then begin

                                if HasGrade(l_StudyPlanLines."School Year", l_StudyPlanLines."Schooling Year", rAssessingStudentsTEMP."Student Code No.",
                                  l_StudyPlanLines."Subject Code", l_StudyPlanLines.Code) then begin
                                    BufferAssignAssessments.Reset;
                                    BufferAssignAssessments.Init;
                                    BufferAssignAssessments."User ID" := UserId;
                                    VarlineNo += 10000;
                                    BufferAssignAssessments."Line No." := VarlineNo;
                                    BufferAssignAssessments."Student Code No." := rAssessingStudentsTEMP."Student Code No.";
                                    BufferAssignAssessments."Class No." := pClassNo;
                                    BufferAssignAssessments."Subject Code" := l_StudyPlanLines."Subject Code";
                                    BufferAssignAssessments.Text := l_StudyPlanLines."Subject Description";
                                    BufferAssignAssessments.Level := 3;

                                    BufferAssignAssessments."Option Type" := BufferAssignAssessments."Option Type"::Subjects;
                                    BufferAssignAssessments."Schooling Year" := l_StudyPlanLines."Schooling Year";
                                    //BufferAssignAssessments.Class := l_RegistrationSubjects.Class;
                                    BufferAssignAssessments.Insert;
                                end;
                            end else begin
                                //OPTION GROUP
                                BufferAssignAssessments.Reset;
                                BufferAssignAssessments.SetRange("Student Code No.", rAssessingStudentsTEMP."Student Code No.");
                                BufferAssignAssessments.SetRange("Schooling Year", rAssessingStudentsTEMP."Schooling Year");
                                BufferAssignAssessments.SetFilter("Subject Code", l_StudyPlanLines."Option Group");

                                if not BufferAssignAssessments.FindFirst then begin

                                    BufferAssignAssessments.Init;
                                    BufferAssignAssessments."User ID" := UserId;
                                    VarlineNo += 10000;
                                    BufferAssignAssessments."Line No." := VarlineNo;
                                    BufferAssignAssessments."Student Code No." := rAssessingStudentsTEMP."Student Code No.";
                                    BufferAssignAssessments."Class No." := pClassNo;
                                    BufferAssignAssessments."Subject Code" := l_StudyPlanLines."Option Group";
                                    l_GroupSubjects.Reset;
                                    l_GroupSubjects.SetRange(Code, l_StudyPlanLines."Option Group");
                                    if rAssessingStudentsTEMP."Type Education" = rAssessingStudentsTEMP."Type Education"::Simple then
                                        l_GroupSubjects.SetRange("Schooling Year", l_StudyPlanLines."Schooling Year")
                                    else
                                        l_GroupSubjects.SetRange("Schooling Year", '');
                                    if l_GroupSubjects.FindFirst then
                                        BufferAssignAssessments.Text := l_GroupSubjects.Description;
                                    BufferAssignAssessments.Level := 3;
                                    BufferAssignAssessments."Option Type" := BufferAssignAssessments."Option Type"::"Option Group";
                                    BufferAssignAssessments."Schooling Year" := l_StudyPlanLines."Schooling Year";
                                    //BufferAssignAssessments.Class := l_RegistrationSubjects.Class;

                                    BufferAssignAssessments.Insert;

                                    l_StudyPlanLines2.Reset;
                                    l_StudyPlanLines2.SetCurrentKey("Option Group", "Sorting ID");
                                    l_StudyPlanLines2.SetRange("School Year", l_StudyPlanLines."School Year");
                                    l_StudyPlanLines2.SetRange("Schooling Year", l_StudyPlanLines."Schooling Year");
                                    l_StudyPlanLines2.SetRange(Code, l_StudyPlanLines.Code);
                                    l_StudyPlanLines2.SetRange("Option Group", l_StudyPlanLines."Option Group");
                                    if l_StudyPlanLines2.FindSet then begin
                                        repeat
                                            if HasGrade(l_StudyPlanLines2."School Year", l_StudyPlanLines2."Schooling Year",
                                                     rAssessingStudentsTEMP."Student Code No.",
                                                     l_StudyPlanLines2."Subject Code", l_StudyPlanLines2.Code) then begin

                                                BufferAssignAssessments.Reset;
                                                BufferAssignAssessments.Init;
                                                BufferAssignAssessments."User ID" := UserId;
                                                VarlineNo += 10000;
                                                BufferAssignAssessments."Line No." := VarlineNo;
                                                BufferAssignAssessments."Student Code No." := rAssessingStudentsTEMP."Student Code No.";
                                                BufferAssignAssessments."Class No." := pClassNo;
                                                BufferAssignAssessments."Subject Code" := l_StudyPlanLines2."Subject Code";
                                                BufferAssignAssessments.Text := l_StudyPlanLines2."Subject Description";
                                                BufferAssignAssessments.Level := 4;
                                                BufferAssignAssessments."Option Type" := BufferAssignAssessments."Option Type"::Subjects;
                                                BufferAssignAssessments."Schooling Year" := l_StudyPlanLines2."Schooling Year";
                                                //BufferAssignAssessments.Class := l_RegistrationSubjects2.Class;
                                                BufferAssignAssessments.Insert;
                                            end;
                                        until l_StudyPlanLines2.Next = 0;
                                    end;
                                end;
                            end;
                        until l_StudyPlanLines.Next = 0;

                    end;
                end;
                if rAssessingStudentsTEMP."Type Education" = rAssessingStudentsTEMP."Type Education"::Multi then begin
                    ValidateCourse(rAssessingStudentsTEMP);

                    rCourseLinesTEMP.Reset;
                    rCourseLinesTEMP.SetCurrentKey("Option Group", "Sorting ID");
                    if rCourseLinesTEMP.FindSet then begin
                        BufferAssignAssessments.Reset;
                        BufferAssignAssessments.SetRange("User ID", UserId);
                        BufferAssignAssessments.SetRange("Student Code No.", rAssessingStudentsTEMP."Student Code No.");
                        BufferAssignAssessments.SetRange("Option Type", BufferAssignAssessments."Option Type"::"Schooling Year");
                        BufferAssignAssessments.SetRange("Schooling Year", rAssessingStudentsTEMP."Schooling Year");
                        if not BufferAssignAssessments.FindFirst then begin

                            BufferAssignAssessments.Init;
                            BufferAssignAssessments."User ID" := UserId;
                            VarlineNo += 10000;
                            BufferAssignAssessments."Line No." := VarlineNo;
                            BufferAssignAssessments."Student Code No." := rAssessingStudentsTEMP."Student Code No.";
                            BufferAssignAssessments.Level := 2;
                            BufferAssignAssessments."Option Type" := BufferAssignAssessments."Option Type"::"Schooling Year";
                            BufferAssignAssessments."Schooling Year" := rAssessingStudentsTEMP."Schooling Year";
                            //BufferAssignAssessments.Class := ;
                            BufferAssignAssessments."Class No." := pClassNo;
                            BufferAssignAssessments.Insert;
                        end;
                        NregSP := rCourseLinesTEMP.Count;
                        repeat
                            countRegSP += 1;
                            Window.Update(3, Round(countRegSP / NregSP * 10000, 1));

                            if rCourseLinesTEMP."Option Group" = '' then begin

                                if HasGrade(rAssessingStudentsTEMP."School Year", rAssessingStudentsTEMP."Schooling Year",
                                          rAssessingStudentsTEMP."Student Code No.",
                                          rCourseLinesTEMP."Subject Code", rCourseLinesTEMP.Code) then begin

                                    BufferAssignAssessments.Init;
                                    BufferAssignAssessments."User ID" := UserId;
                                    VarlineNo += 10000;
                                    BufferAssignAssessments."Line No." := VarlineNo;
                                    BufferAssignAssessments."Student Code No." := rAssessingStudentsTEMP."Student Code No.";
                                    BufferAssignAssessments."Class No." := pClassNo;
                                    BufferAssignAssessments."Subject Code" := rCourseLinesTEMP."Subject Code";
                                    BufferAssignAssessments.Text := rCourseLinesTEMP."Subject Description";
                                    BufferAssignAssessments.Level := 3;

                                    BufferAssignAssessments."Option Type" := BufferAssignAssessments."Option Type"::Subjects;
                                    BufferAssignAssessments."Schooling Year" := rAssessingStudentsTEMP."Schooling Year";
                                    //BufferAssignAssessments.Class := ;
                                    BufferAssignAssessments.Insert;
                                end;
                            end else begin
                                //OPTION GROUP
                                BufferAssignAssessments.Reset;
                                BufferAssignAssessments.SetRange("Student Code No.", rAssessingStudentsTEMP."Student Code No.");
                                BufferAssignAssessments.SetRange("Schooling Year", rAssessingStudentsTEMP."Schooling Year");
                                BufferAssignAssessments.SetFilter("Subject Code", rCourseLinesTEMP."Option Group");

                                if not BufferAssignAssessments.FindFirst then begin

                                    BufferAssignAssessments.Init;
                                    BufferAssignAssessments."User ID" := UserId;
                                    VarlineNo += 10000;
                                    BufferAssignAssessments."Line No." := VarlineNo;
                                    BufferAssignAssessments."Student Code No." := rAssessingStudentsTEMP."Student Code No.";
                                    BufferAssignAssessments."Class No." := pClassNo;
                                    BufferAssignAssessments."Subject Code" := rCourseLinesTEMP."Option Group";
                                    l_GroupSubjects.Reset;
                                    l_GroupSubjects.SetRange(Code, rCourseLinesTEMP."Option Group");
                                    if rAssessingStudentsTEMP."Type Education" = rAssessingStudentsTEMP."Type Education"::Simple then
                                        l_GroupSubjects.SetRange("Schooling Year", rAssessingStudentsTEMP."Schooling Year")
                                    else
                                        l_GroupSubjects.SetRange("Schooling Year", '');
                                    if l_GroupSubjects.FindFirst then
                                        BufferAssignAssessments.Text := l_GroupSubjects.Description;
                                    BufferAssignAssessments.Level := 3;
                                    BufferAssignAssessments."Option Type" := BufferAssignAssessments."Option Type"::"Option Group";
                                    BufferAssignAssessments."Schooling Year" := rAssessingStudentsTEMP."Schooling Year";
                                    //BufferAssignAssessments.Class := l_RegistrationSubjects.Class;
                                    BufferAssignAssessments.Insert;

                                    rCourseLinesTEMP2.Reset;
                                    rCourseLinesTEMP2.SetCurrentKey("Option Group", "Sorting ID");
                                    rCourseLinesTEMP2.SetRange(Code, rCourseLinesTEMP.Code);
                                    rCourseLinesTEMP2.SetRange("Option Group", rCourseLinesTEMP."Option Group");
                                    if rCourseLinesTEMP2.FindSet then begin
                                        repeat
                                            if HasGrade(rAssessingStudentsTEMP."School Year", rAssessingStudentsTEMP."Schooling Year",
                                                      rAssessingStudentsTEMP."Student Code No.",
                                                      rCourseLinesTEMP2."Subject Code", rCourseLinesTEMP2.Code) then begin

                                                BufferAssignAssessments.Reset;
                                                BufferAssignAssessments.Init;
                                                BufferAssignAssessments."User ID" := UserId;
                                                VarlineNo += 10000;
                                                BufferAssignAssessments."Line No." := VarlineNo;
                                                BufferAssignAssessments."Student Code No." := rAssessingStudentsTEMP."Student Code No.";
                                                BufferAssignAssessments."Class No." := pClassNo;
                                                BufferAssignAssessments."Subject Code" := rCourseLinesTEMP2."Subject Code";
                                                BufferAssignAssessments.Text := rCourseLinesTEMP2."Subject Description";
                                                BufferAssignAssessments.Level := 4;
                                                BufferAssignAssessments."Option Type" := BufferAssignAssessments."Option Type"::Subjects;
                                                BufferAssignAssessments."Schooling Year" := rAssessingStudentsTEMP."Schooling Year";
                                                //BufferAssignAssessments.Class := l_RegistrationSubjects2.Class;
                                                BufferAssignAssessments.Insert;
                                            end;
                                        until rCourseLinesTEMP2.Next = 0;
                                    end;
                                end;
                            end;
                        until rCourseLinesTEMP.Next = 0;

                    end;
                end;
            until rAssessingStudentsTEMP.Next = 0;
        end;
    end;

    //[Scope('OnPrem')]
    procedure ValidateCourse(pAssessingStudents: Record "Assessing Students")
    var
        l_VarLineNo: Integer;
    begin
        rCourseLinesTEMP.Reset;
        rCourseLinesTEMP.DeleteAll;
        rCourseLinesTEMP2.Reset;
        rCourseLinesTEMP2.DeleteAll;

        // Quadriennal
        rCourseLines.Reset;
        rCourseLines.SetRange(Code, pAssessingStudents."Study Plan Code");
        rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Quadriennal);
        if rCourseLines.FindSet then begin
            repeat
                InsertSubjects(rCourseLines);
            until rCourseLines.Next = 0;
        end;

        //Annual
        rCourseLines.Reset;
        rCourseLines.SetRange(Code, pAssessingStudents."Study Plan Code");
        rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Annual);
        rCourseLines.SetRange("Schooling Year Begin", pAssessingStudents."Schooling Year");
        if rCourseLines.FindSet then begin
            repeat
                InsertSubjects(rCourseLines);
            until rCourseLines.Next = 0;
        end;


        //Biennial

        rStruEduCountry.Reset;
        rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
        rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
        rStruEduCountry.SetRange("Schooling Year", pAssessingStudents."Schooling Year");
        if rStruEduCountry.FindSet then begin
            rCourseLines.Reset;
            rCourseLines.SetRange(Code, pAssessingStudents."Study Plan Code");
            rCourseLines.SetFilter("Characterise Subjects", '%1|%2', rCourseLines."Characterise Subjects"::Biennial,
                                    rCourseLines."Characterise Subjects"::Triennial);
            rCourseLines.SetRange("Schooling Year Begin", pAssessingStudents."Schooling Year");
            if rCourseLines.FindSet then begin
                repeat
                    InsertSubjects(rCourseLines);
                until rCourseLines.Next = 0;
            end;
            l_rStruEduCountry.Reset;
            l_rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
            l_rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
            l_rStruEduCountry.SetRange("Sorting ID", GetNoStructureCountry2(pAssessingStudents."Schooling Year") - 1);
            if l_rStruEduCountry.FindSet then begin
                rCourseLines.Reset;
                rCourseLines.SetRange(Code, pAssessingStudents."Study Plan Code");
                rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Biennial);
                rCourseLines.SetRange("Schooling Year Begin", l_rStruEduCountry."Schooling Year");
                if rCourseLines.FindSet then begin
                    repeat
                        InsertSubjects(rCourseLines);
                    until rCourseLines.Next = 0;
                end;
            end;
            l_rStruEduCountry.Reset;
            l_rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
            l_rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
            l_rStruEduCountry.SetRange("Sorting ID", GetNoStructureCountry2(pAssessingStudents."Schooling Year") - 2);
            if l_rStruEduCountry.FindSet then begin
                rCourseLines.Reset;
                rCourseLines.SetRange(Code, pAssessingStudents."Study Plan Code");
                rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Triennial);
                rCourseLines.SetRange("Schooling Year Begin", l_rStruEduCountry."Schooling Year");
                if rCourseLines.FindSet then begin
                    repeat
                        InsertSubjects(rCourseLines);
                    until rCourseLines.Next = 0;
                end;
            end;
            l_rStruEduCountry.Reset;
            l_rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
            l_rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
            l_rStruEduCountry.SetRange("Sorting ID", GetNoStructureCountry2(pAssessingStudents."Schooling Year") - 1);
            if l_rStruEduCountry.FindSet then begin
                rCourseLines.Reset;
                rCourseLines.SetRange(Code, pAssessingStudents."Study Plan Code");
                rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Triennial);
                rCourseLines.SetRange("Schooling Year Begin", l_rStruEduCountry."Schooling Year");
                if rCourseLines.FindSet then begin
                    repeat
                        InsertSubjects(rCourseLines);
                    until rCourseLines.Next = 0;
                end;
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure GetNoStructureCountry2(pSchoolingYear: Code[10]): Integer
    begin

        rStruEduCountry.Reset;
        rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
        rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
        if rStruEduCountry.FindSet then begin
            repeat
                if pSchoolingYear = rStruEduCountry."Schooling Year" then
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
        rCourseLinesTEMP.Init;
        rCourseLinesTEMP.TransferFields(pCourseLines);
        rCourseLinesTEMP.Insert;

        rCourseLinesTEMP2.Init;
        rCourseLinesTEMP2.TransferFields(pCourseLines);
        rCourseLinesTEMP2.Insert;
    end;

    //[Scope('OnPrem')]
    procedure HasGrade(pSchoolYear: Code[9]; pSchoolingYear: Code[10]; pStudentCode: Code[20]; pSubjectCode: Code[10]; pStudyPlanCode: Code[20]): Boolean
    var
        l_pAssessingStudents: Record "Assessing Students";
    begin
        l_pAssessingStudents.Reset;
        l_pAssessingStudents.SetRange("Student Code No.", pStudentCode);
        l_pAssessingStudents.SetRange("School Year", pSchoolYear);
        l_pAssessingStudents.SetRange("Schooling Year", pSchoolingYear);
        l_pAssessingStudents.SetRange(Subject, pSubjectCode);
        l_pAssessingStudents.SetRange("Study Plan Code", pStudyPlanCode);
        if l_pAssessingStudents.FindFirst then
            exit(true)
        else
            exit(false);
    end;

    local procedure varClassOnAfterValidate()
    begin

        CurrPage.Update(false);
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

    local procedure vText1OnAfterInput(var Text: Text[1024])
    begin
        Text := UpperCase(Text);
    end;

    local procedure vText2OnAfterInput(var Text: Text[1024])
    begin
        Text := UpperCase(Text);
    end;

    local procedure vText3OnAfterInput(var Text: Text[1024])
    begin
        Text := UpperCase(Text);
    end;

    local procedure vText4OnAfterInput(var Text: Text[1024])
    begin
        Text := UpperCase(Text);
    end;

    local procedure vText5OnAfterInput(var Text: Text[1024])
    begin
        Text := UpperCase(Text);
    end;

    local procedure vText6OnAfterInput(var Text: Text[1024])
    begin
        Text := UpperCase(Text);
    end;

    local procedure vText7OnAfterInput(var Text: Text[1024])
    begin
        Text := UpperCase(Text);
    end;

    local procedure vText8OnAfterInput(var Text: Text[1024])
    begin
        Text := UpperCase(Text);
    end;

    local procedure vText9OnAfterInput(var Text: Text[1024])
    begin
        Text := UpperCase(Text);
    end;

    local procedure vText10OnAfterInput(var Text: Text[1024])
    begin
        Text := UpperCase(Text);
    end;

    local procedure vText11OnAfterInput(var Text: Text[1024])
    begin
        Text := UpperCase(Text);
    end;

    local procedure vText12OnAfterInput(var Text: Text[1024])
    begin
        Text := UpperCase(Text);
    end;

    local procedure vText13OnAfterInput(var Text: Text[1024])
    begin
        Text := UpperCase(Text);
    end;

    local procedure vText14OnAfterInput(var Text: Text[1024])
    begin
        Text := UpperCase(Text);
    end;

    local procedure vText15OnAfterInput(var Text: Text[1024])
    begin
        Text := UpperCase(Text);
    end;

    local procedure varMixedClassificationOnPush()
    begin
        CurrPage.Update;
    end;

    local procedure ActualExpansionStatusOnPush()
    begin
        ToggleExpandCollapse;
    end;

    local procedure ClassNoOnFormat()
    begin
        if Rec."Option Type" = Rec."Option Type"::Student then
            "Class No.Emphasize" := true;
    end;

    local procedure StudentCodeNoOnFormat()
    begin
        if Rec."Option Type" = Rec."Option Type"::Student then
            "Student Code No.Emphasize" := true;
    end;

    local procedure OptionTypeOnFormat()
    begin
        if Rec."Option Type" = Rec."Option Type"::Student then
            "Option TypeEmphasize" := true;
    end;

    local procedure SubjectCodeOnFormat()
    begin
        if Rec."Option Type" = Rec."Option Type"::Student then
            "Subject CodeEmphasize" := true;
    end;

    local procedure SubSubjectCodeOnFormat()
    begin
        if Rec."Option Type" = Rec."Option Type"::Student then
            "Sub-Subject CodeEmphasize" := true;
    end;

    local procedure TextOnFormat()
    begin
        TextIndent := Rec.Level;

        if Rec."Option Type" = Rec."Option Type"::Student then
            TextEmphasize := true;
    end;

    local procedure vText1OnFormat()
    begin
        if VarFinalType[1] = VarFinalType::"Final Year" then
            Txt1Editable := false
        else
            Txt1Editable := true;

        if Rec."Option Type" = Rec."Option Type"::Student then
            Txt1Emphasize := true;
    end;

    local procedure vText2OnFormat()
    begin
        if VarFinalType[2] = VarFinalType::"Final Year" then
            Txt2Editable := false
        else
            Txt2Editable := true;

        if Rec."Option Type" = Rec."Option Type"::Student then
            Txt2Emphasize := true;
    end;

    local procedure vText3OnFormat()
    begin
        if VarFinalType[3] = VarFinalType::"Final Year" then
            Txt3Editable := false
        else
            Txt3Editable := true;


        if Rec."Option Type" = Rec."Option Type"::Student then
            Txt3Emphasize := true;
    end;

    local procedure vText4OnFormat()
    begin
        if VarFinalType[4] = VarFinalType::"Final Year" then
            Txt4Editable := false
        else
            Txt4Editable := true;

        if Rec."Option Type" = Rec."Option Type"::Student then
            Txt4Emphasize := true;
    end;

    local procedure vText5OnFormat()
    begin
        if VarFinalType[5] = VarFinalType::"Final Year" then
            Txt5Editable := false
        else
            Txt5Editable := true;

        if Rec."Option Type" = Rec."Option Type"::Student then
            Txt5Emphasize := true;
    end;

    local procedure vText6OnFormat()
    begin
        if VarFinalType[6] = VarFinalType::"Final Year" then
            Txt6Editable := false
        else
            Txt6Editable := true;

        if Rec."Option Type" = Rec."Option Type"::Student then
            Txt6Emphasize := true;
    end;

    local procedure vText7OnFormat()
    begin
        if VarFinalType[7] = VarFinalType::"Final Year" then
            Txt7Editable := false
        else
            Txt7Editable := true;

        if Rec."Option Type" = Rec."Option Type"::Student then
            Txt7Emphasize := true;
    end;

    local procedure vText8OnFormat()
    begin
        if VarFinalType[8] = VarFinalType::"Final Year" then
            Txt8Editable := false
        else
            Txt8Editable := true;

        if Rec."Option Type" = Rec."Option Type"::Student then
            Txt8Emphasize := true;
    end;

    local procedure vText9OnFormat()
    begin
        if VarFinalType[9] = VarFinalType::"Final Year" then
            Txt9Editable := false
        else
            Txt9Editable := true;

        if Rec."Option Type" = Rec."Option Type"::Student then
            Txt9Emphasize := true;
    end;

    local procedure vText10OnFormat()
    begin
        if VarFinalType[10] = VarFinalType::"Final Year" then
            Txt10Editable := false
        else
            Txt10Editable := true;

        if Rec."Option Type" = Rec."Option Type"::Student then
            Txt10Emphasize := true;
    end;

    local procedure vText11OnFormat()
    begin
        if VarFinalType[11] = VarFinalType::"Final Year" then
            Txt11Editable := false
        else
            Txt11Editable := true;

        if Rec."Option Type" = Rec."Option Type"::Student then
            Txt11Emphasize := true;
    end;

    local procedure vText12OnFormat()
    begin
        if VarFinalType[12] = VarFinalType::"Final Year" then
            Txt12Editable := false
        else
            Txt12Editable := true;

        if Rec."Option Type" = Rec."Option Type"::Student then
            Txt12Emphasize := true;
    end;

    local procedure vText13OnFormat()
    begin
        if VarFinalType[13] = VarFinalType::"Final Year" then
            Txt13Editable := false
        else
            Txt13Editable := true;

        if Rec."Option Type" = Rec."Option Type"::Student then
            Txt13Emphasize := true;
    end;

    local procedure vText14OnFormat()
    begin
        if VarFinalType[14] = VarFinalType::"Final Year" then
            Txt14Editable := false
        else
            Txt14Editable := true;

        if Rec."Option Type" = Rec."Option Type"::Student then
            Txt14Emphasize := true;
    end;

    local procedure vText15OnFormat()
    begin
        if VarFinalType[15] = VarFinalType::"Final Year" then
            Txt15Editable := false
        else
            Txt15Editable := true;

        if Rec."Option Type" = Rec."Option Type"::Student then
            Txt15Emphasize := true;
    end;
}

#pragma implicitwith restore

