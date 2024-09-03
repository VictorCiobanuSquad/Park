#pragma implicitwith disable
page 52968 "Final Assessments"
{
    Caption = 'Final Assessments';
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

                                DeleteBuffer;
                                TestMoments;
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
                        end else
                            Error(Text0009);

                    end;

                    trigger OnValidate()
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


                                DeleteBuffer;

                                TestMoments;



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
                            end;
                        end else
                            Error(text0013);
                        varClassOnAfterValidate;

                    end;
                }
                field(varActiveMoment; varActiveMoment)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Active Moment';
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if varSchoolingYear = '' then
                            exit;
                        rMomentsAssessment.Reset;
                        rMomentsAssessment.SetRange("Schooling Year", varSchoolingYear);
                        rMomentsAssessment.SetRange("School Year", varSchoolYear);
                        rMomentsAssessment.SetRange("Responsibility Center", rClass."Responsibility Center");
                        if rMomentsAssessment.FindSet then;
                        PAGE.RunModal(0, rMomentsAssessment);
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
                field(SCN1; Rec."Student Code No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Option Type"; Rec."Option Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    OptionCaption = 'Student,Subjects,Option Group,Sub-Subjects,Schooling Year,Rules of Evaluations';
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
                field(ActualStatus; varTransitionStatus)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Actual Status';
                    OptionCaption = ' ,Registered,Transited,Not Transited,Concluded,Not Concluded,Abandonned,Registration Annulled,Transfered,Exclusion by Incidences,Ongoing evaluation,Retained from Absences,School Certificate,Legal Transition ';
                    Visible = ActualStatusVisible;

                    trigger OnValidate()
                    begin
                        if Rec."Option Type" <> Rec."Option Type"::Student then
                            Error(text0014);

                        GetRegistrationAproved(true);
                        varTransitionStatusOnAfterVali;
                    end;
                }
                field(AttendanceSituation; varAttendanceSituation[1])
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Attendance Situation';
                    Editable = AttendanceSituationEditable;
                    OptionCaption = ' ,Approved,Admitted to Exam,Registration cancellation,Excluded by Incidences,Failure,Excluded before 3rd period,Failed before 3rd period,Annulled after deadline ';
                    Visible = AttendanceSituationVisible;

                    trigger OnValidate()
                    begin
                        rRegistrationSubejcts.Reset;
                        rRegistrationSubejcts.SetRange("Student Code No.", Rec."Student Code No.");
                        rRegistrationSubejcts.SetRange("Schooling Year", varSchoolingYear);
                        rRegistrationSubejcts.SetRange(Class, varClass);
                        rRegistrationSubejcts.SetRange("School Year", varSchoolYear);
                        rRegistrationSubejcts.SetRange("Subjects Code", Rec."Subject Code");
                        if rRegistrationSubejcts.FindFirst then
                            rRegistrationSubejcts."Attendance Situation" := varAttendanceSituation[1];
                        rRegistrationSubejcts.Modify;
                        varAttendanceSituation1OnAfter;
                    end;
                }
                field(Txt1; vText[1])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(1);
                    Editable = Txt1Editable;
                    Visible = Txt1Visible;

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
                        //IF vText[1] <> '' THEN BEGIN

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

                        //END ELSE
                        //  DeleteAssessignStudents(varClass,varSubjects,varRespCenter,varSchoolYear,varSchoolingYear,varStudyPlanCode,
                        //                          "Student Code No.",vArrayCodMomento[1],"Sub-Subject Code");
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
                        //IF vText[2] <> '' THEN BEGIN

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

                        //END ELSE
                        //  DeleteAssessignStudents(varClass,varSubjects,varRespCenter,varSchoolYear,varSchoolingYear,varStudyPlanCode,
                        //                          "Student Code No.",vArrayCodMomento[2],"Sub-Subject Code");
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
                        //IF vText[3] <> '' THEN BEGIN

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

                        //END ELSE
                        //  DeleteAssessignStudents(varClass,varSubjects,varRespCenter,varSchoolYear,varSchoolingYear,varStudyPlanCode,
                        //                          "Student Code No.",vArrayCodMomento[3],"Sub-Subject Code");
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
                        //IF vText[4] <> '' THEN BEGIN

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

                        //END ELSE
                        //  DeleteAssessignStudents(varClass,varSubjects,varRespCenter,varSchoolYear,varSchoolingYear,varStudyPlanCode,
                        //                          "Student Code No.",vArrayCodMomento[4],"Sub-Subject Code");
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
                        //IF vText[5] <> '' THEN BEGIN


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

                        //END ELSE
                        //  DeleteAssessignStudents(varClass,varSubjects,varRespCenter,varSchoolYear,varSchoolingYear,varStudyPlanCode,
                        //                          "Student Code No.",vArrayCodMomento[5],"Sub-Subject Code");
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
                        //IF vText[6] <> '' THEN BEGIN


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

                        //END ELSE
                        //  DeleteAssessignStudents(varClass,varSubjects,varRespCenter,varSchoolYear,varSchoolingYear,varStudyPlanCode,
                        //                          "Student Code No.",vArrayCodMomento[6],"Sub-Subject Code");
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
                        //IF vText[7] <> '' THEN BEGIN


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

                        ///END ELSE
                        //  DeleteAssessignStudents(varClass,varSubjects,varRespCenter,varSchoolYear,varSchoolingYear,varStudyPlanCode,
                        //                          "Student Code No.",vArrayCodMomento[7],"Sub-Subject Code");
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
                        //IF vText[8] <> '' THEN BEGIN


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

                        //END ELSE
                        //  DeleteAssessignStudents(varClass,varSubjects,varRespCenter,varSchoolYear,varSchoolingYear,varStudyPlanCode,
                        //                          "Student Code No.",vArrayCodMomento[8],"Sub-Subject Code");
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
                        //IF vText[9] <> '' THEN BEGIN

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

                        //END ELSE
                        //  DeleteAssessignStudents(varClass,varSubjects,varRespCenter,varSchoolYear,varSchoolingYear,varStudyPlanCode,
                        //                          "Student Code No.",vArrayCodMomento[9],"Sub-Subject Code");
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
                        //IF vText[10] <> '' THEN BEGIN


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

                        //END ELSE
                        //  DeleteAssessignStudents(varClass,varSubjects,varRespCenter,varSchoolYear,varSchoolingYear,varStudyPlanCode,
                        //                          "Student Code No.",vArrayCodMomento[10],"Sub-Subject Code");
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
                        //IF vText[11] <> '' THEN BEGIN


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

                        //END ELSE
                        //  DeleteAssessignStudents(varClass,varSubjects,varRespCenter,varSchoolYear,varSchoolingYear,varStudyPlanCode,
                        //                          "Student Code No.",vArrayCodMomento[11],"Sub-Subject Code");
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
                        //IF vText[12] <> '' THEN BEGIN

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

                        //END ELSE
                        //  DeleteAssessignStudents(varClass,varSubjects,varRespCenter,varSchoolYear,varSchoolingYear,varStudyPlanCode,
                        //                          "Student Code No.",vArrayCodMomento[12],"Sub-Subject Code");
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
                        //IF vText[13] <> '' THEN BEGIN


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

                        //END ELSE
                        //  DeleteAssessignStudents(varClass,varSubjects,varRespCenter,varSchoolYear,varSchoolingYear,varStudyPlanCode,
                        //                          "Student Code No.",vArrayCodMomento[13],"Sub-Subject Code");
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
                        //IF vText[14] <> '' THEN BEGIN

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

                        //END ELSE
                        //  DeleteAssessignStudents(varClass,varSubjects,varRespCenter,varSchoolYear,varSchoolingYear,varStudyPlanCode,
                        //                          "Student Code No.",vArrayCodMomento[14],"Sub-Subject Code");
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
                        //IF vText[15] <> '' THEN BEGIN

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

                        //END ELSE
                        //  DeleteAssessignStudents(varClass,varSubjects,varRespCenter,varSchoolYear,varSchoolingYear,varStudyPlanCode,
                        //                          "Student Code No.",vArrayCodMomento[15],"Sub-Subject Code");
                        vText15OnAfterValidate;
                    end;
                }
            }
            group(Control1000000000)
            {
                ShowCaption = false;
                field(SCN2; Rec."Student Code No.")
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
                    Caption = 'Student with comments for selected subject for the selected moment';
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field(varAverbamentos; varAverbamentos)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
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
                Image = Text;
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
                    varTypeButtonEdit := true;
                    if (varClass <> '') then begin

                        Clear(fRemarksWizard);
                        fRemarksWizard.GetObservationCode(ActualObservationCode);
                        fRemarksWizard.GetMomentInformation(varSelectedMoment);

                        if (Rec."Option Type" = Rec."Option Type"::Subjects) or (Rec."Option Type" = Rec."Option Type"::"Sub-Subjects") then
                            varTypeButtonEdit := false
                        else
                            varTypeButtonEdit := true;
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
                separator(Action1102065061)
                {
                }
                action("&Update Assessment from WEB")
                {
                    ApplicationArea = All;
                    Caption = '&Update Assessment from WEB';
                    Image = UpdateDescription;
                    Visible = false;

                    trigger OnAction()
                    begin
                        WebToNAVUpdate;
                    end;
                }
                action("Calc. &Moment Assessment")
                {
                    ApplicationArea = All;
                    Caption = 'Calc. &Moment Assessment';
                    Image = CalculateSalesTax;
                    Visible = false;

                    trigger OnAction()
                    begin
                        CalcAssessments;
                    end;
                }
                action("C&alc. Final Year Moment Assessment")
                {
                    ApplicationArea = All;
                    Caption = 'C&alc. Final Year Moment Assessment';
                    Image = CalculateSimulation;
                    Visible = false;

                    trigger OnAction()
                    begin
                        CalcFinalAssessments;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        lMomentsAssessment: Record "Moments Assessment";
    begin
        TextIndent := 0;
        if rStudents.Get(Rec."Student Code No.") then;


        if IsExpanded(Rec) then
            ActualExpansionStatus := 1
        else
            if HasChildren(Rec) then
                ActualExpansionStatus := 2
            else
                ActualExpansionStatus := 0;

        rRegistrationSubejcts.Reset;
        rRegistrationSubejcts.SetRange("Student Code No.", Rec."Student Code No.");
        rRegistrationSubejcts.SetRange("Schooling Year", varSchoolingYear);
        rRegistrationSubejcts.SetRange(Class, varClass);
        rRegistrationSubejcts.SetRange("School Year", varSchoolYear);
        rRegistrationSubejcts.SetRange("Subjects Code", Rec."Subject Code");
        if rRegistrationSubejcts.FindFirst then
            varAttendanceSituation[1] := rRegistrationSubejcts."Attendance Situation"
        else
            varAttendanceSituation[1] := 0;

        if Rec."Option Type" <> Rec."Option Type"::Subjects then
            varAttendanceSituation[1] := 0;


        lMomentsAssessment.Reset;
        lMomentsAssessment.SetRange("Moment Code", varActiveMoment);
        lMomentsAssessment.SetRange("School Year", varSchoolYear);
        lMomentsAssessment.SetRange("Schooling Year", varSchoolingYear);
        lMomentsAssessment.SetRange(Active, true);
        lMomentsAssessment.SetRange("Evaluation Moment", lMomentsAssessment."Evaluation Moment"::"Final Year");
        if lMomentsAssessment.FindFirst then
            AttendanceSituationVisible := true
        else
            AttendanceSituationVisible := false;




        InsertColunm;

        EditableFuction;

        ValidateActualStatus;
        OnAfterGetCurrRecord2;
        ClassNoOnFormat;
        StudentCodeNoC1102065003OnForm;
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
        ActualStatusVisible := true;
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
        AttendanceSituationEditable := true;
        AttendanceSituationVisible := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        OnAfterGetCurrRecord2;
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
        rRegistration: Record Registration;
        rClass: Record Class;
        varTransitionStatus: Option " ",Registered,Transited,"Not Transited",Concluded,"Not Concluded",Abandonned,"Registration Annulled",Tranfered,"Exclusion by Incidences","Ongoing evaluation","Retained from Absences","School Certificate","Legal Transition";
        text0014: Label 'To change the option the option type must be student.';
        text0015: Label 'The student has been processed for the next school year.';
        text001: Label 'Class is Mandatory.';
        text008: Label 'Moment Code is Mandatory.';
        text009: Label 'School Year is Mandatory.';
        text012: Label 'You can only calculate the Final Year Moment type assessment.';
        text013: Label 'Processing Final Evaluation\@2@@@@@@@@@@@@@@@@@@@@\Student No.\#1####################';
        text014: Label 'Processing Moment Assessent\@2@@@@@@@@@@@@@@@@@@@@\Student No.\#1####################';
        text015: Label 'To set evaluations you need to set the Setting Moments for this school year(s).';
        text010: Label 'First you must run the calc function. ';
        text011: Label 'The Active Moment must be of Final Year type.';
        text0016: Label 'Option available only for students and option group .';
        varAttendanceSituation: array[1] of Option " ",AP,AE,AM,EF,RF,E0,R0,A1;
        rStudents: Record Students;
        rRegistrationSubejcts: Record "Registration Subjects";
        VarFinalType: array[15] of Option " ","Final Year","Final Cycle","Final Stage";
        [InDataSet]
        AttendanceSituationVisible: Boolean;
        [InDataSet]
        AttendanceSituationEditable: Boolean;
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
        [InDataSet]
        ActualStatusVisible: Boolean;
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


        rStruEduCountry.Reset;
        rStruEduCountry.SetCurrentKey("Sorting ID");
        rStruEduCountry.SetRange("Schooling Year", varSchoolingYear);
        if rStruEduCountry.FindSet then begin
            if rStruEduCountry."Final Cycle Caption" <> '' then begin
                indx := indx + 1;
                vArrayCodMomento[indx] := rStruEduCountry."Schooling Year";
                vArrayMomento[indx] := rStruEduCountry."Final Cycle Caption";
                VarFinalType[indx] := VarFinalType::"Final Cycle";
                VArrayMomActive[indx] := true;
            end;
            if rStruEduCountry."Final Stage Caption" <> '' then begin
                indx := indx + 1;
                vArrayCodMomento[indx] := rStruEduCountry."Schooling Year";
                vArrayMomento[indx] := rStruEduCountry."Final Stage Caption";
                VarFinalType[indx] := VarFinalType::"Final Stage";
                VArrayMomActive[indx] := true;
            end;
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
        l_AssessmentConfiguration: Record "Assessment Configuration";
    begin

        if Rec."Option Type" = Rec."Option Type"::Subjects then begin
            rSettingRatings.Reset;
            rSettingRatings.SetRange("Moment Code", vArrayCodMomento[inIndex]);
            rSettingRatings.SetRange(Type, rSettingRatings.Type::Header);
            rSettingRatings.SetRange("School Year", varSchoolYear);
            rSettingRatings.SetRange("Schooling Year", varSchoolingYear);
            rSettingRatings.SetRange("Subject Code", Rec."Subject Code");
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
        if Rec."Option Type" = Rec."Option Type"::"Sub-Subjects" then begin
            rSettingRatingsSubSubjects.Reset;
            rSettingRatingsSubSubjects.SetRange("Moment Code", vArrayCodMomento[inIndex]);
            rSettingRatingsSubSubjects.SetRange(Type, rSettingRatings.Type::Header);
            rSettingRatingsSubSubjects.SetRange("School Year", varSchoolYear);
            rSettingRatingsSubSubjects.SetRange("Schooling Year", varSchoolingYear);
            rSettingRatingsSubSubjects.SetRange("Subject Code", Rec."Subject Code");
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


        //MOMENT
        if (Rec."Option Type" = Rec."Option Type"::Student) or (Rec."Option Type" = Rec."Option Type"::"Option Group") then begin
            if (vArrayType[inIndex] = vArrayType[inIndex] ::"Final Moment") or
              (vArrayType[inIndex] = vArrayType[inIndex] ::Interim) or
              (vArrayType[inIndex] = vArrayType[inIndex] ::EXN1) then begin

                l_AssessmentConfiguration.Reset;
                l_AssessmentConfiguration.SetRange("Study Plan Code", varStudyPlanCode);
                if VarType = VarType::Simple then
                    l_AssessmentConfiguration.SetRange("School Year", varSchoolYear);
                l_AssessmentConfiguration.SetRange(Type, VarType);
                if l_AssessmentConfiguration.FindFirst then begin
                    vArrayAssessmentType[inIndex] := l_AssessmentConfiguration."PA Evaluation Type";
                    vArrayAssessmentCode[inIndex] := l_AssessmentConfiguration."PA Assessment Code";
                end;
            end;
            if (vArrayType[inIndex] = vArrayType[inIndex] ::"Final Year") then begin
                l_AssessmentConfiguration.Reset;
                l_AssessmentConfiguration.SetRange("Study Plan Code", varStudyPlanCode);
                if VarType = VarType::Simple then
                    l_AssessmentConfiguration.SetRange("School Year", varSchoolYear);
                l_AssessmentConfiguration.SetRange(Type, VarType);
                if l_AssessmentConfiguration.FindFirst then begin
                    vArrayAssessmentType[inIndex] := l_AssessmentConfiguration."FY Evaluation Type";
                    vArrayAssessmentCode[inIndex] := l_AssessmentConfiguration."FY Assessment Code";
                end;
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
        l_FinalAssessingStudents: Record "Assessing Students Final";
    begin
        GetTypeAssessment(inIndex);

        if (Rec."Option Type" = Rec."Option Type"::"Option Group") or (Rec."Option Type" = Rec."Option Type"::Student) then begin
            if (vArrayType[inIndex] <> vArrayType[inIndex] ::" ") and (VarFinalType[inIndex] = VarFinalType[inIndex] ::" ") then begin
                l_FinalAssessingStudents.Reset;
                l_FinalAssessingStudents.SetRange(Class, varClass);
                l_FinalAssessingStudents.SetRange("School Year", varSchoolYear);
                l_FinalAssessingStudents.SetRange("Student Code No.", Rec."Student Code No.");

                if (vArrayType[inIndex] = vArrayType[inIndex] ::"Final Moment") or
                (vArrayType[inIndex] = vArrayType[inIndex] ::Interim) or
                (vArrayType[inIndex] = vArrayType[inIndex] ::EXN1) then begin
                    if Rec."Option Type" = Rec."Option Type"::Student then
                        l_FinalAssessingStudents.SetRange("Evaluation Type", l_FinalAssessingStudents."Evaluation Type"::"Final Moment");
                    if Rec."Option Type" = Rec."Option Type"::"Option Group" then begin
                        l_FinalAssessingStudents.SetRange("Evaluation Type", l_FinalAssessingStudents."Evaluation Type"::"Final Moment Group");
                        l_FinalAssessingStudents.SetRange("Option Group", Rec."Subject Code");
                    end;
                    l_FinalAssessingStudents.SetRange("Moment Code", vArrayCodMomento[inIndex]);
                end;

                if (vArrayType[inIndex] = vArrayType[inIndex] ::"Final Year") or (vArrayType[inIndex] = vArrayType[inIndex] ::EXN1) or
                  (vArrayType[inIndex] = vArrayType[inIndex] ::EXN2) then begin
                    if Rec."Option Type" = Rec."Option Type"::Student then begin
                        l_FinalAssessingStudents.SetRange("Evaluation Type", l_FinalAssessingStudents."Evaluation Type"::"Final Year");
                        l_FinalAssessingStudents.SetRange(Subject, Rec."Subject Code");
                        l_FinalAssessingStudents.SetRange("Sub-Subject Code", Rec."Sub-Subject Code");
                    end;
                    if Rec."Option Type" = Rec."Option Type"::"Option Group" then begin
                        l_FinalAssessingStudents.SetRange("Evaluation Type", l_FinalAssessingStudents."Evaluation Type"::"Final Year Group");
                        l_FinalAssessingStudents.SetRange("Option Group", Rec."Subject Code");
                    end;
                    l_FinalAssessingStudents.SetRange("Moment Code", vArrayCodMomento[inIndex]);
                end;

                if l_FinalAssessingStudents.FindSet then begin
                    repeat
                        if vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::Quantitative then
                            Evaluate(l_FinalAssessingStudents."Manual Grade", inText);

                        if (vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::Qualitative) then
                            l_FinalAssessingStudents."Qualitative Manual Grade" := inText;

                        if (vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::"Mixed-Qualification") then begin
                            if varMixedClassification then begin
                                l_FinalAssessingStudents."Qualitative Manual Grade" := varClassification;
                                if inText <> '' then
                                    Evaluate(l_FinalAssessingStudents."Manual Grade", inText)
                                else
                                    l_FinalAssessingStudents."Manual Grade" := 0;
                            end else begin
                                if not Evaluate(l_FinalAssessingStudents."Manual Grade", varClassification) then
                                    l_FinalAssessingStudents."Manual Grade" := 0;
                                l_FinalAssessingStudents."Qualitative Manual Grade" := inText;
                            end;
                        end;

                        l_FinalAssessingStudents.Modify;
                    until l_FinalAssessingStudents.Next = 0;
                end else begin
                    //ERROR(text010);
                    if vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::"Mixed-Qualification" then begin
                        if (inText = '') and (varClassification = '') then
                            exit;
                    end;
                    l_FinalAssessingStudents.Init;
                    if vArrayType[inIndex] = vArrayType[inIndex] ::"Final Year" then
                        if Rec."Option Type" = Rec."Option Type"::Student then begin
                            l_FinalAssessingStudents."Evaluation Type" := l_FinalAssessingStudents."Evaluation Type"::"Final Year";
                            l_FinalAssessingStudents."Moment Code" := vArrayCodMomento[inIndex];
                        end;

                    if vArrayType[inIndex] = vArrayType[inIndex] ::"Final Moment" then
                        if Rec."Option Type" = Rec."Option Type"::"Option Group" then begin
                            l_FinalAssessingStudents."Evaluation Type" := l_FinalAssessingStudents."Evaluation Type"::"Final Moment Group";
                            l_FinalAssessingStudents."Moment Code" := vArrayCodMomento[inIndex];
                            l_FinalAssessingStudents."Option Group" := Rec."Subject Code";

                        end;

                    if vArrayType[inIndex] = vArrayType[inIndex] ::"Final Year" then
                        if Rec."Option Type" = Rec."Option Type"::"Option Group" then begin
                            l_FinalAssessingStudents."Evaluation Type" := l_FinalAssessingStudents."Evaluation Type"::"Final Year Group";
                            l_FinalAssessingStudents."Moment Code" := vArrayCodMomento[inIndex];
                        end;
                    if Rec."Option Type" = Rec."Option Type"::Student then begin
                        if VarFinalType[inIndex] = VarFinalType[inIndex] ::"Final Stage" then
                            l_FinalAssessingStudents."Evaluation Type" := l_FinalAssessingStudents."Evaluation Type"::"Final Stage";
                        if VarFinalType[inIndex] = VarFinalType[inIndex] ::"Final Cycle" then
                            l_FinalAssessingStudents."Evaluation Type" := l_FinalAssessingStudents."Evaluation Type"::"Final Cycle";
                    end;

                    l_FinalAssessingStudents."Evaluation Moment" := vArrayType[inIndex];

                    l_FinalAssessingStudents.Class := varClass;
                    l_FinalAssessingStudents."School Year" := varSchoolYear;
                    l_FinalAssessingStudents."Schooling Year" := varSchoolingYear;
                    l_FinalAssessingStudents."Study Plan Code" := varStudyPlanCode;
                    l_FinalAssessingStudents."Type Education" := VarType;
                    l_FinalAssessingStudents."Student Code No." := Rec."Student Code No.";
                    l_FinalAssessingStudents."Country/Region Code" := cStudentsRegistration.GetCountry;
                    if vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::Qualitative then
                        l_FinalAssessingStudents."Qualitative Manual Grade" := inText;

                    if vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::Quantitative then
                        Evaluate(l_FinalAssessingStudents."Manual Grade", inText);

                    if vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::"Mixed-Qualification" then begin
                        if varMixedClassification then begin
                            Evaluate(l_FinalAssessingStudents."Manual Grade", inText);
                            l_FinalAssessingStudents."Qualitative Manual Grade" := varClassification;
                        end else begin
                            Evaluate(l_FinalAssessingStudents."Manual Grade", varClassification);
                            l_FinalAssessingStudents."Qualitative Manual Grade" := inText;
                        end;
                    end;


                    l_FinalAssessingStudents.Insert;
                end;
            end else begin
                //final cycle
                if VarFinalType[inIndex] = VarFinalType[inIndex] ::"Final Stage" then begin
                    l_FinalAssessingStudents.Reset;
                    l_FinalAssessingStudents.SetRange(Class, varClass);
                    l_FinalAssessingStudents.SetRange("School Year", varSchoolYear);
                    l_FinalAssessingStudents.SetRange("Student Code No.", Rec."Student Code No.");
                    l_FinalAssessingStudents.SetRange("Evaluation Type", l_FinalAssessingStudents."Evaluation Type"::"Final Stage");
                    l_FinalAssessingStudents.SetRange("Schooling Year", vArrayCodMomento[inIndex]);
                    l_FinalAssessingStudents.SetRange(Subject, Rec."Subject Code");
                end;
                if VarFinalType[inIndex] = VarFinalType[inIndex] ::"Final Cycle" then begin
                    l_FinalAssessingStudents.Reset;
                    l_FinalAssessingStudents.SetRange(Class, varClass);
                    l_FinalAssessingStudents.SetRange("School Year", varSchoolYear);
                    l_FinalAssessingStudents.SetRange("Student Code No.", Rec."Student Code No.");
                    l_FinalAssessingStudents.SetRange("Evaluation Type", l_FinalAssessingStudents."Evaluation Type"::"Final Cycle");
                    l_FinalAssessingStudents.SetRange("Schooling Year", vArrayCodMomento[inIndex]);
                    l_FinalAssessingStudents.SetRange(Subject, Rec."Subject Code");
                end;
                if l_FinalAssessingStudents.FindFirst then begin
                    if vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::Quantitative then
                        Evaluate(l_FinalAssessingStudents."Manual Grade", inText);

                    if (vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::Qualitative) then
                        l_FinalAssessingStudents."Qualitative Manual Grade" := inText;

                    if (vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::"Mixed-Qualification") then begin
                        if varMixedClassification then begin
                            l_FinalAssessingStudents."Qualitative Manual Grade" := varClassification;
                            if inText <> '' then
                                Evaluate(l_FinalAssessingStudents."Manual Grade", inText)
                            else
                                l_FinalAssessingStudents."Manual Grade" := 0;
                        end else begin
                            if not Evaluate(l_FinalAssessingStudents."Manual Grade", varClassification) then
                                l_FinalAssessingStudents."Manual Grade" := 0;
                            l_FinalAssessingStudents."Qualitative Manual Grade" := inText;
                        end;
                    end;

                    l_FinalAssessingStudents.Modify;

                end else begin
                    l_FinalAssessingStudents.Init;
                    if Rec."Option Type" = Rec."Option Type"::Student then begin
                        if VarFinalType[inIndex] = VarFinalType[inIndex] ::"Final Stage" then
                            l_FinalAssessingStudents."Evaluation Type" := l_FinalAssessingStudents."Evaluation Type"::"Final Stage";
                        if VarFinalType[inIndex] = VarFinalType[inIndex] ::"Final Cycle" then
                            l_FinalAssessingStudents."Evaluation Type" := l_FinalAssessingStudents."Evaluation Type"::"Final Cycle";
                    end;

                    l_FinalAssessingStudents.Class := varClass;
                    l_FinalAssessingStudents."School Year" := varSchoolYear;
                    l_FinalAssessingStudents."Schooling Year" := varSchoolingYear;
                    l_FinalAssessingStudents."Study Plan Code" := varStudyPlanCode;
                    l_FinalAssessingStudents."Type Education" := VarType;
                    l_FinalAssessingStudents."Student Code No." := Rec."Student Code No.";
                    l_FinalAssessingStudents."Country/Region Code" := cStudentsRegistration.GetCountry;
                    if vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::Qualitative then
                        l_FinalAssessingStudents."Qualitative Manual Grade" := inText;

                    if vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::Quantitative then
                        Evaluate(l_FinalAssessingStudents."Manual Grade", inText);

                    if vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::"Mixed-Qualification" then begin
                        if varMixedClassification then begin
                            Evaluate(l_FinalAssessingStudents."Manual Grade", inText);
                            l_FinalAssessingStudents."Qualitative Manual Grade" := varClassification;
                        end else begin
                            Evaluate(l_FinalAssessingStudents."Manual Grade", varClassification);
                            l_FinalAssessingStudents."Qualitative Manual Grade" := inText;
                        end;
                    end;


                    l_FinalAssessingStudents.Insert;

                end;
            end;
        end else
            Error(text0016);

        /*
        rAssessingStudents.RESET;
        rAssessingStudents.SETRANGE("School Year",varSchoolYear);
        rAssessingStudents.SETRANGE("Schooling Year",varSchoolingYear);
        rAssessingStudents.SETRANGE(Subject,varSubjects);
        rAssessingStudents.SETRANGE("Sub-Subject Code",inSubSubjCode);
        rAssessingStudents.SETRANGE("Study Plan Code",varStudyPlanCode);
        rAssessingStudents.SETRANGE("Student Code No.",inStudentCode);
        rAssessingStudents.SETRANGE("Moment Code",vArrayCodMomento[inIndex]);
        IF rAssessingStudents.FIND('-') THEN BEGIN
        
           IF vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex]::Quantitative THEN
              EVALUATE(rAssessingStudents.Grade,inText);
        
           IF (vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex]::Qualitative) THEN
              rAssessingStudents."Qualitative Grade" := inText;
        
           IF (vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex]::"Mixed-Qualification") THEN BEGIN
              IF varMixedClassification THEN BEGIN
                 rAssessingStudents."Qualitative Grade" :=varClassification;
                 IF inText <> '' THEN
                   EVALUATE(rAssessingStudents.Grade,inText)
                 ELSE
                   rAssessingStudents.Grade := 0;
              END ELSE BEGIN
                 IF NOT EVALUATE(rAssessingStudents.Grade,varClassification) THEN
                    rAssessingStudents.Grade := 0;
                 rAssessingStudents."Qualitative Grade" := inText;
              END;
           END;
        
           rAssessingStudents.MODIFY(TRUE);
        
        END ELSE BEGIN
           rAssessingStudents.INIT;
           rAssessingStudents.Class := varClass;
           rAssessingStudents."School Year":= varSchoolYear;
           rAssessingStudents."Schooling Year":= varSchoolingYear;
           rAssessingStudents.Subject:= varSubjects;
           rAssessingStudents."Sub-Subject Code" := inSubSubjCode;
           rAssessingStudents."Study Plan Code" := varStudyPlanCode;
           rAssessingStudents."Student Code No." := inStudentCode;
           rAssessingStudents."Moment Code" := vArrayCodMomento[inIndex];
           rAssessingStudents."Class No.":= inClassNo;
           rAssessingStudents."Evaluation Moment" := vArrayType[inIndex];
           rAssessingStudents."Type Education" := VarType;
        
           IF vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex]::Qualitative THEN
              rAssessingStudents."Qualitative Grade" := inText;
        
           IF vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex]::Quantitative THEN
              EVALUATE(rAssessingStudents.Grade,inText);
        
           IF vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex]::"Mixed-Qualification" THEN BEGIN
             IF varMixedClassification THEN BEGIN
               EVALUATE(rAssessingStudents.Grade,inText);
               rAssessingStudents."Qualitative Grade" := varClassification;
             END ELSE BEGIN
               EVALUATE(rAssessingStudents.Grade,varClassification);
               rAssessingStudents."Qualitative Grade" := inText;
             END;
           END;
        
        
           rAssessingStudents.INSERT(TRUE);
        
        END;
         */

    end;

    //[Scope('OnPrem')]
    procedure GetAssessment(inStudentCode: Code[20]; inClassNo: Integer; inIndex: Integer; inText: Text[250]; inSubSubjCode: Code[20]) Out: Text[100]
    var
        rAssessingStudents: Record "Assessing Students";
        l_FinalAssessingStudents: Record "Assessing Students Final";
    begin
        GetRegistrationAproved(false);
        GetTypeAssessment(inIndex);

        if (Rec."Option Type" = Rec."Option Type"::"Option Group") or (Rec."Option Type" = Rec."Option Type"::Student) then begin

            if (vArrayType[inIndex] = vArrayType[inIndex] ::CIF) or (vArrayType[inIndex] = vArrayType[inIndex] ::CFD) then
                exit('');

            if (vArrayType[inIndex] <> vArrayType[inIndex] ::" ") and (VarFinalType[inIndex] = VarFinalType[inIndex] ::" ") then begin
                l_FinalAssessingStudents.Reset;
                l_FinalAssessingStudents.SetRange(Class, varClass);
                l_FinalAssessingStudents.SetRange("School Year", varSchoolYear);
                l_FinalAssessingStudents.SetRange("Student Code No.", Rec."Student Code No.");

                if (vArrayType[inIndex] = vArrayType[inIndex] ::"Final Moment") or
                (vArrayType[inIndex] = vArrayType[inIndex] ::Interim) or
                (vArrayType[inIndex] = vArrayType[inIndex] ::EXN1) then begin
                    if Rec."Option Type" = Rec."Option Type"::Student then
                        l_FinalAssessingStudents.SetRange("Evaluation Type", l_FinalAssessingStudents."Evaluation Type"::"Final Moment");
                    if Rec."Option Type" = Rec."Option Type"::"Option Group" then begin
                        l_FinalAssessingStudents.SetRange("Evaluation Type", l_FinalAssessingStudents."Evaluation Type"::"Final Moment Group");
                        l_FinalAssessingStudents.SetRange("Option Group", Rec."Subject Code");
                    end;
                    l_FinalAssessingStudents.SetRange("Moment Code", vArrayCodMomento[inIndex]);
                end;

                if (vArrayType[inIndex] = vArrayType[inIndex] ::"Final Year") or (vArrayType[inIndex] = vArrayType[inIndex] ::EXN1) or
                   (vArrayType[inIndex] = vArrayType[inIndex] ::EXN2) then begin
                    if Rec."Option Type" = Rec."Option Type"::Student then begin
                        l_FinalAssessingStudents.SetRange("Evaluation Type", l_FinalAssessingStudents."Evaluation Type"::"Final Year");
                        l_FinalAssessingStudents.SetRange(Subject, Rec."Subject Code");
                        l_FinalAssessingStudents.SetRange("Sub-Subject Code", Rec."Sub-Subject Code");
                    end;
                    if Rec."Option Type" = Rec."Option Type"::"Option Group" then begin
                        l_FinalAssessingStudents.SetRange("Evaluation Type", l_FinalAssessingStudents."Evaluation Type"::"Final Year Group");
                        l_FinalAssessingStudents.SetRange("Option Group", Rec."Subject Code");
                    end;
                    l_FinalAssessingStudents.SetRange("Moment Code", vArrayCodMomento[inIndex]);
                end;

                if l_FinalAssessingStudents.FindSet then begin
                    repeat

                        if Rec."Option Type" <> Rec."Option Type"::Student then begin
                            if (VarFinalType[inIndex] = VarFinalType[inIndex] ::"Final Stage")
                               or (VarFinalType[inIndex] = VarFinalType[inIndex] ::"Final Cycle") then
                                if not (l_FinalAssessingStudents."Evaluation Type" = l_FinalAssessingStudents."Evaluation Type"::"Final Cycle") or
                                    not (l_FinalAssessingStudents."Evaluation Type" = l_FinalAssessingStudents."Evaluation Type"::"Final Stage") then
                                    exit('');
                        end;

                        if vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::Quantitative then
                            if l_FinalAssessingStudents."Manual Grade" <> 0 then
                                exit(Format(l_FinalAssessingStudents."Manual Grade"))
                            else
                                exit(Format(l_FinalAssessingStudents.Grade));

                        if (vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::Qualitative) then
                            if l_FinalAssessingStudents."Qualitative Manual Grade" <> '' then
                                exit(l_FinalAssessingStudents."Qualitative Manual Grade")
                            else
                                exit(l_FinalAssessingStudents."Qualitative Grade");

                        if (vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::"Mixed-Qualification") then
                            if varMixedClassification then begin
                                if l_FinalAssessingStudents."Manual Grade" <> 0 then
                                    exit(Format(l_FinalAssessingStudents."Manual Grade"))
                                else
                                    exit(Format(l_FinalAssessingStudents.Grade))

                            end else begin
                                if l_FinalAssessingStudents."Qualitative Manual Grade" <> '' then
                                    exit(l_FinalAssessingStudents."Qualitative Manual Grade")
                                else
                                    exit(l_FinalAssessingStudents."Qualitative Grade");
                            end;
                    until l_FinalAssessingStudents.Next = 0;
                end else
                    exit('');
            end;
        end;

        if (Rec."Option Type" = Rec."Option Type"::Subjects) or (Rec."Option Type" = Rec."Option Type"::"Sub-Subjects") then begin
            rAssessingStudents.Reset;
            rAssessingStudents.SetRange("School Year", varSchoolYear);
            rAssessingStudents.SetRange("Schooling Year", varSchoolingYear);
            rAssessingStudents.SetRange(Subject, Rec."Subject Code");
            rAssessingStudents.SetRange("Sub-Subject Code", Rec."Sub-Subject Code");
            //rAssessingStudents.SETRANGE("Study Plan Code",varStudyPlanCode);
            rAssessingStudents.SetRange("Student Code No.", Rec."Student Code No.");
            rAssessingStudents.SetRange("Moment Code", vArrayCodMomento[inIndex]);
            if rAssessingStudents.FindFirst then begin
                if vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::Quantitative then
                    if rAssessingStudents."Recuperation Grade" <> 0 then
                        exit(Format(rAssessingStudents."Recuperation Grade"))
                    else
                        if rAssessingStudents.Grade <> 0 then
                            exit(Format(rAssessingStudents.Grade))
                        else
                            exit(Format(rAssessingStudents."Grade Calc"));

                if (vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::Qualitative) then
                    if rAssessingStudents."Recuperation Qualitative Grade" <> '' then
                        exit(rAssessingStudents."Recuperation Qualitative Grade")
                    else
                        if rAssessingStudents."Qualitative Grade" <> '' then
                            exit(rAssessingStudents."Qualitative Grade")
                        else
                            exit(rAssessingStudents."Qualitative Grade Calc");

                if (vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::"Mixed-Qualification") then
                    if varMixedClassification then begin
                        if rAssessingStudents."Recuperation Grade" <> 0 then
                            exit(Format(rAssessingStudents."Recuperation Grade"))
                        else
                            if rAssessingStudents.Grade <> 0 then
                                exit(Format(rAssessingStudents.Grade))
                            else
                                exit(Format(rAssessingStudents."Grade Calc"));
                    end else begin
                        if rAssessingStudents."Recuperation Qualitative Grade" <> '' then
                            exit(rAssessingStudents."Recuperation Qualitative Grade")
                        else
                            if rAssessingStudents."Qualitative Grade" <> '' then
                                exit(rAssessingStudents."Qualitative Grade")
                            else
                                exit(rAssessingStudents."Qualitative Grade Calc");

                    end;

                /*END ELSE
                 IF (VarFinalType[inIndex] = VarFinalType[inIndex]::"Final Stage") OR
                   (VarFinalType[inIndex] = VarFinalType[inIndex]::"Final Cycle") THEN BEGIN
                   IF VarFinalType[inIndex] = VarFinalType[inIndex]::"Final Stage" THEN BEGIN
                     l_FinalAssessingStudents.RESET;
                     l_FinalAssessingStudents.SETRANGE(Class,varClass);
                     l_FinalAssessingStudents.SETRANGE("School Year",varSchoolYear);
                     l_FinalAssessingStudents.SETRANGE("Student Code No.","Student Code No.");
                     l_FinalAssessingStudents.SETRANGE("Evaluation Type",l_FinalAssessingStudents."Evaluation Type"::"Final Stage");
                     l_FinalAssessingStudents.SETRANGE("Schooling Year",vArrayCodMomento[inIndex]);
                     l_FinalAssessingStudents.SETRANGE(Subject,"Subject Code");
                     l_FinalAssessingStudents.SETRANGE("Rule Entry No.",inRuleNo);
                   END;
                   IF VarFinalType[inIndex] = VarFinalType[inIndex]::"Final Cycle" THEN BEGIN
                     l_FinalAssessingStudents.RESET;
                     l_FinalAssessingStudents.SETRANGE(Class,varClass);
                     l_FinalAssessingStudents.SETRANGE("School Year",varSchoolYear);
                     l_FinalAssessingStudents.SETRANGE("Student Code No.","Student Code No.");
                     l_FinalAssessingStudents.SETRANGE("Evaluation Type",l_FinalAssessingStudents."Evaluation Type"::"Final Cycle");
                     l_FinalAssessingStudents.SETRANGE("Schooling Year",vArrayCodMomento[inIndex]);
                     l_FinalAssessingStudents.SETRANGE(Subject,"Subject Code");
                     l_FinalAssessingStudents.SETRANGE("Rule Entry No.",inRuleNo);
                   END;
                   IF l_FinalAssessingStudents.FINDFIRST THEN BEGIN
                     IF varMixedClassification THEN BEGIN
                        IF l_FinalAssessingStudents."Manual Grade" <> 0 THEN
                           EXIT(FORMAT(l_FinalAssessingStudents."Manual Grade"))
                        ELSE
                           EXIT(FORMAT(l_FinalAssessingStudents.Grade))
                     END
                     ELSE BEGIN
                        IF l_FinalAssessingStudents."Qualitative Manual Grade" <> '' THEN
                           EXIT(l_FinalAssessingStudents."Qualitative Manual Grade")
                        ELSE
                           EXIT(l_FinalAssessingStudents."Qualitative Grade");
                     END;

                   END ELSE
                      EXIT('');*/
            end else
                exit('');
        end;


        if Rec."Option Type" = Rec."Option Type"::Student then begin
            if VarFinalType[inIndex] = VarFinalType[inIndex] ::"Final Stage" then begin
                l_FinalAssessingStudents.Reset;
                l_FinalAssessingStudents.SetRange(Class, varClass);
                l_FinalAssessingStudents.SetRange("School Year", varSchoolYear);
                l_FinalAssessingStudents.SetRange("Student Code No.", Rec."Student Code No.");
                l_FinalAssessingStudents.SetRange("Evaluation Type", l_FinalAssessingStudents."Evaluation Type"::"Final Stage");
                l_FinalAssessingStudents.SetRange("Schooling Year", vArrayCodMomento[inIndex]);
                l_FinalAssessingStudents.SetRange(Subject, Rec."Subject Code");
                //l_FinalAssessingStudents.SETRANGE("Rule Entry No.",inRuleNo);
            end;
            if VarFinalType[inIndex] = VarFinalType[inIndex] ::"Final Cycle" then begin
                l_FinalAssessingStudents.Reset;
                l_FinalAssessingStudents.SetRange(Class, varClass);
                l_FinalAssessingStudents.SetRange("School Year", varSchoolYear);
                l_FinalAssessingStudents.SetRange("Student Code No.", Rec."Student Code No.");
                l_FinalAssessingStudents.SetRange("Evaluation Type", l_FinalAssessingStudents."Evaluation Type"::"Final Cycle");
                l_FinalAssessingStudents.SetRange("Schooling Year", vArrayCodMomento[inIndex]);
                l_FinalAssessingStudents.SetRange(Subject, Rec."Subject Code");
                //l_FinalAssessingStudents.SETRANGE("Rule Entry No.",inRuleNo);
            end;
            if l_FinalAssessingStudents.FindFirst then begin
                if varMixedClassification then begin
                    if l_FinalAssessingStudents."Manual Grade" <> 0 then
                        exit(Format(l_FinalAssessingStudents."Manual Grade"))
                    else
                        exit(Format(l_FinalAssessingStudents.Grade))
                end
                else begin
                    if l_FinalAssessingStudents."Qualitative Manual Grade" <> '' then
                        exit(l_FinalAssessingStudents."Qualitative Manual Grade")
                    else
                        exit(l_FinalAssessingStudents."Qualitative Grade");
                end;

            end else
                exit('');
        end;
        /*if "Option Type" = "Option Type"::"5" then begin
            if VarFinalType[inIndex] = VarFinalType[inIndex] ::"Final Stage" then begin
                l_FinalAssessingStudents.Reset;
                l_FinalAssessingStudents.SetRange(Class, varClass);
                l_FinalAssessingStudents.SetRange("School Year", varSchoolYear);
                l_FinalAssessingStudents.SetRange("Student Code No.", "Student Code No.");
                l_FinalAssessingStudents.SetRange("Evaluation Type", l_FinalAssessingStudents."Evaluation Type"::"Final Stage");
                l_FinalAssessingStudents.SetRange("Schooling Year", vArrayCodMomento[inIndex]);
                l_FinalAssessingStudents.SetRange(Subject, '');
                //l_FinalAssessingStudents.SETRANGE("Rule Entry No.",inRuleNo);
                if l_FinalAssessingStudents.FindFirst then begin
                    if varMixedClassification then begin
                        if l_FinalAssessingStudents."Manual Grade" <> 0 then
                            exit(Format(l_FinalAssessingStudents."Manual Grade"))
                        else
                            exit(Format(l_FinalAssessingStudents.Grade))
                    end
                    else begin
                        if l_FinalAssessingStudents."Qualitative Manual Grade" <> '' then
                            exit(l_FinalAssessingStudents."Qualitative Manual Grade")
                        else
                            exit(l_FinalAssessingStudents."Qualitative Grade");
                    end;
                end else
                    exit('');
            end;
            if VarFinalType[inIndex] = VarFinalType[inIndex] ::"Final Cycle" then begin
                l_FinalAssessingStudents.Reset;
                l_FinalAssessingStudents.SetRange(Class, varClass);
                l_FinalAssessingStudents.SetRange("School Year", varSchoolYear);
                l_FinalAssessingStudents.SetRange("Student Code No.", "Student Code No.");
                l_FinalAssessingStudents.SetRange("Evaluation Type", l_FinalAssessingStudents."Evaluation Type"::"Final Cycle");
                l_FinalAssessingStudents.SetRange("Schooling Year", vArrayCodMomento[inIndex]);
                l_FinalAssessingStudents.SetRange(Subject, '');
                //l_FinalAssessingStudents.SETRANGE("Rule Entry No.",inRuleNo);
                if l_FinalAssessingStudents.FindFirst then begin
                    if varMixedClassification then begin
                        if l_FinalAssessingStudents."Manual Grade" <> 0 then
                            exit(Format(l_FinalAssessingStudents."Manual Grade"))
                        else
                            exit(Format(l_FinalAssessingStudents.Grade))
                    end
                    else begin
                        if l_FinalAssessingStudents."Qualitative Manual Grade" <> '' then
                            exit(l_FinalAssessingStudents."Qualitative Manual Grade")
                        else
                            exit(l_FinalAssessingStudents."Qualitative Grade");
                    end;
                end else
                    exit('');
            end;
        end;*/


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
                rClassificationLevel.SetFilter("Min Value", '<=%1', varClasification);
                rClassificationLevel.SetFilter("Max Value", '>=%1', varClasification);
                if rClassificationLevel.FindFirst then
                    exit(varClasification)
                else
                    Error(Text0004, rClassificationLevel."Min Value", rClassificationLevel."Max Value");
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

        if (Rec."Option Type" = Rec."Option Type"::Subjects) or (Rec."Option Type" = Rec."Option Type"::"Sub-Subjects") then begin
            if IsGlobal = false then begin
                l_rRemarks.Reset;
                l_rRemarks.SetRange(Class, varClass);
                l_rRemarks.SetRange("School Year", varSchoolYear);
                l_rRemarks.SetRange("Schooling Year", varSchoolingYear);
                l_rRemarks.SetRange("Study Plan Code", varStudyPlanCode);
                l_rRemarks.SetRange("Student/Teacher Code No.", Rec."Student Code No.");
                l_rRemarks.SetRange("Moment Code", l_CodMoment);
                l_rRemarks.SetRange("Type Remark", l_rRemarks."Type Remark"::Assessment);
                l_rRemarks.SetRange(Subject, Rec."Subject Code");
                l_rRemarks.SetRange("Sub-subject", Rec."Sub-Subject Code");
                if l_rRemarks.FindFirst then
                    ExitValue := true;
            end;
        end;
        if IsGlobal = true then begin
            l_rRemarks.Reset;
            l_rRemarks.SetRange(Class, varClass);
            l_rRemarks.SetRange("School Year", varSchoolYear);
            l_rRemarks.SetRange("Schooling Year", varSchoolingYear);
            l_rRemarks.SetRange("Study Plan Code", varStudyPlanCode);
            l_rRemarks.SetRange("Student/Teacher Code No.", Rec."Student Code No.");
            l_rRemarks.SetRange("Moment Code", l_CodMoment);
            l_rRemarks.SetRange("Type Remark", l_rRemarks."Type Remark"::Assessment);
            l_rRemarks.SetRange(Subject, '');
            l_rRemarks.SetRange("Sub-subject", '');
            if l_rRemarks.FindFirst then
                ExitValue := true;

        end;
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
    procedure ApplyFilter(varClass: Code[20]; varSubject: Code[10]; varRespCenter: Code[10]; varSchoolYear: Code[9]; varSchoolingYear: Code[10]; varStudyPlanCode: Code[10])
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
        auxStudent: Integer;
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

        /*
        //Inserir os dados na tabela
        //**************************
        
        rRegistrationSubject.RESET;
        rRegistrationSubject.SETCURRENTKEY(rRegistrationSubject."Class No.");
        rRegistrationSubject.SETRANGE(rRegistrationSubject."Responsibility Center",varRespCenter);
        rRegistrationSubject.SETRANGE(rRegistrationSubject."School Year",varSchoolYear);
        rRegistrationSubject.SETRANGE(rRegistrationSubject."Schooling Year",varSchoolingYear);
        rRegistrationSubject.SETRANGE(rRegistrationSubject.Class,varClass);
        rRegistrationSubject.SETRANGE(rRegistrationSubject."Subjects Code",varSubject);
        rRegistrationSubject.SETRANGE(rRegistrationSubject.Status,1);
        IF rRegistrationSubject.FINDSET(FALSE) THEN BEGIN
          REPEAT
            IF varStudent <> rRegistrationSubject."Student Code No." THEN BEGIN
              varStudent := rRegistrationSubject."Student Code No.";
        
              message('Insere aluno');
        
              ////Insere nome Aluno
              TempAssignAssessments.RESET;
              TempAssignAssessments.INIT;
              TempAssignAssessments."User ID" := USERID;
              TempAssignAssessments."Line No." := TempAssignAssessments."Line No." + 10000;
              TempAssignAssessments."Student Code No." := rRegistrationSubject."Student Code No.";
              TempAssignAssessments."Class No." := rRegistrationSubject."Class No.";
              IF rStudent.GET(rRegistrationSubject."Student Code No.") THEN BEGIN
                TempAssignAssessments.Text := rStudent."Full Name";
              END;
              TempAssignAssessments."Subject Code" := varSubject;
              TempAssignAssessments.Level := 1;
              TempAssignAssessments.INSERT;
        
              ////Inserir Sub-disciplinas
              rSettingRatingsSubSubjects.RESET;
        
              rSettingRatingsSubSubjects.SETCURRENTKEY(rSettingRatingsSubSubjects."School Year",
              rSettingRatingsSubSubjects."Schooling Year",rSettingRatingsSubSubjects."Study Plan Code",
              rSettingRatingsSubSubjects."Subject Code",rSettingRatingsSubSubjects."Sorting ID");
              rSettingRatingsSubSubjects.SETRANGE(rSettingRatingsSubSubjects."Responsibility Center",varRespCenter);
              rSettingRatingsSubSubjects.SETRANGE(rSettingRatingsSubSubjects."School Year",varSchoolYear);
              rSettingRatingsSubSubjects.SETRANGE(rSettingRatingsSubSubjects."Schooling Year",varSchoolingYear);
              rSettingRatingsSubSubjects.SETRANGE(rSettingRatingsSubSubjects."Subject Code",rRegistrationSubject."Subjects Code");
              rSettingRatingsSubSubjects.SETRANGE(rSettingRatingsSubSubjects."Moment Code",varMomento);
              IF rSettingRatingsSubSubjects.FINDSET(FALSE) THEN BEGIN
                REPEAT
                  message('Insere subdisciplinas');
                  TempAssignAssessments.RESET;
                  TempAssignAssessments.INIT;
                  TempAssignAssessments."User ID" := USERID;
                  TempAssignAssessments."Line No." := TempAssignAssessments."Line No." + 10000;
                  TempAssignAssessments."Student Code No." := rRegistrationSubject."Student Code No.";
                  TempAssignAssessments."Class No." := rRegistrationSubject."Class No.";
                  TempAssignAssessments."Subject Code" := varSubject;
                  TempAssignAssessments."Sub-Subject Code" := rSettingRatingsSubSubjects."Sub-Subject Code";
                  TempAssignAssessments.Text := rSettingRatingsSubSubjects."Sub-Subject Description";
                  TempAssignAssessments.Level := 2;
                  TempAssignAssessments.INSERT;
                UNTIL rSettingRatingsSubSubjects.NEXT=0;
              END;
        
        
            END;
          UNTIL rRegistrationSubject.NEXT = 0;
        END;
         */



        //Inserir os dados na tabela - nova forma para que apresente os dados à data de fim do periodo
        //**************************

        Clear(auxStudent);
        rRegistrationClassEntry.Reset;
        rRegistrationClassEntry.SetCurrentKey("School Year", "Schooling Year", Class, "Class No.", "Status Date");
        rRegistrationClassEntry.SetRange(rRegistrationClassEntry.Class, varClass);
        rRegistrationClassEntry.SetRange(rRegistrationClassEntry."School Year", varSchoolYear);
        rRegistrationClassEntry.SetRange(rRegistrationClassEntry."Schooling Year", varSchoolingYear);
        rRegistrationClassEntry.SetRange(rRegistrationClassEntry."Responsibility Center", varRespCenter);
        rRegistrationClassEntry.SetFilter(rRegistrationClassEntry."Status Date", '<=%1', varMomentDataEnd);
        rRegistrationClassEntry.SetRange(rRegistrationClassEntry.Status, rRegistrationClassEntry.Status::Subscribed);
        if rRegistrationClassEntry.Find('-') then begin
            repeat
                if auxStudent <> rRegistrationClassEntry."Class No." then begin

                    auxStudent := rRegistrationClassEntry."Class No.";
                    varStudent := rRegistrationClassEntry."Student Code No.";

                    rStudentSubjEntry.Reset;
                    rStudentSubjEntry.SetCurrentKey("School Year", "Schooling Year", Class, "Class No.", "Subjects Code", "Status Date");
                    rStudentSubjEntry.SetRange(rStudentSubjEntry.Class, varClass);
                    rStudentSubjEntry.SetRange(rStudentSubjEntry."Student Code No.", rRegistrationClassEntry."Student Code No.");
                    rStudentSubjEntry.SetRange(rStudentSubjEntry."School Year", varSchoolYear);
                    rStudentSubjEntry.SetRange(rStudentSubjEntry."Schooling Year", varSchoolingYear);
                    rStudentSubjEntry.SetRange(rStudentSubjEntry."Subjects Code", varSubject);
                    rStudentSubjEntry.SetFilter(rStudentSubjEntry."Status Date", '<=%1', varMomentDataEnd);
                    rStudentSubjEntry.SetFilter(rStudentSubjEntry."Evaluation Type", '<>%1',
                      rStudentSubjEntry."Evaluation Type"::"None Qualification");
                    if (rStudentSubjEntry.Find('+')) and (rStudentSubjEntry.Status = rStudentSubjEntry.Status::Subscribed) then begin
                        repeat

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
                        until rStudentSubjEntry.Next = 0;
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
    procedure InsertStudents()
    var
        l_Students: Record Students;
        l_RegistrationSubjects: Record "Registration Subjects";
        l_StudentSubSubjects: Record "Student Sub-Subjects Plan ";
        l_RegistrationSubjects2: Record "Registration Subjects";
        l_GroupSubjects: Record "Group Subjects";
        l_rulesofEval: Record "Rules of Evaluations";
        VarlineNo: Integer;
        flag: Boolean;
        l_rClass: Record Class;
        i: Integer;
        k: Integer;
    begin
        DeleteBuffer;

        VarlineNo := 0;

        rRegistration.Reset;
        rRegistration.SetRange(Class, varClass);
        rRegistration.SetRange("Responsibility Center", varRespCenter);
        rRegistration.SetRange("Schooling Year", varSchoolingYear);
        rRegistration.SetRange("School Year", varSchoolYear);
        rRegistration.SetRange(Status, rRegistration.Status::Subscribed);
        if rRegistration.FindSet then begin
            repeat
                flag := true;
                //Clear(i);
                //Clear(k);
                //if l_rClass.Get(varClass, varSchoolYear) then begin
                k := CheckRules(varSchoolYear, varSchoolingYear, l_rClass."Study Plan Code");

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

                /*if k <> 0 then begin
                    i += 1;
                    l_rulesofEval.Reset;
                    l_rulesofEval.SetRange("Schooling Year", varSchoolingYear);
                    l_rulesofEval.SetRange("School Year", varSchoolYear);
                    l_rulesofEval.SetRange("Study Plan Code", l_rClass."Study Plan Code");
                    l_rulesofEval.SetRange("Rule Type", l_rulesofEval."Rule Type"::Student);
                    l_rulesofEval.SetRange("Classifications Calculations", l_rulesofEval."Classifications Calculations"::"Final Stage");
                    if l_rulesofEval.FindSet then
                        repeat
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
                            BufferAssignAssessments.Level := 2;
                            BufferAssignAssessments."Option Type" := BufferAssignAssessments."Option Type"::"5";
                            //BufferAssignAssessments."Rule Entry No." := l_rulesofEval."Entry No.";
                            BufferAssignAssessments.Insert;
                        until l_rulesofEval.Next = 0;
                end;
            end else begin
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
            end;*/
                l_RegistrationSubjects.Reset;
                l_RegistrationSubjects.SetCurrentKey("Student Code No.", "Option Group", "Sorting ID");
                l_RegistrationSubjects.SetRange("Student Code No.", rRegistration."Student Code No.");
                l_RegistrationSubjects.SetRange("School Year", rRegistration."School Year");
                l_RegistrationSubjects.SetRange("Schooling Year", rRegistration."Schooling Year");
                l_RegistrationSubjects.SetRange(Class, rRegistration.Class);
                l_RegistrationSubjects.SetRange(Status, l_RegistrationSubjects.Status::Subscribed);
                l_RegistrationSubjects.SetRange("Responsibility Center", rRegistration."Responsibility Center");
                l_RegistrationSubjects.SetFilter("Evaluation Type", '<>%1', l_RegistrationSubjects."Evaluation Type"::"None Qualification");
                if l_RegistrationSubjects.FindSet then begin
                    repeat
                        if (l_RegistrationSubjects."Option Group" = '') and (flag) then begin
                            flag := false;
                            l_RegistrationSubjects2.Reset;
                            l_RegistrationSubjects2.SetCurrentKey("Student Code No.", "Option Group", "Sorting ID");
                            l_RegistrationSubjects2.SetRange("Student Code No.", rRegistration."Student Code No.");
                            l_RegistrationSubjects2.SetRange("School Year", rRegistration."School Year");
                            l_RegistrationSubjects2.SetRange("Schooling Year", rRegistration."Schooling Year");
                            l_RegistrationSubjects2.SetRange("Option Group", l_RegistrationSubjects."Option Group");
                            l_RegistrationSubjects2.SetRange(Class, rRegistration.Class);
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
                                    BufferAssignAssessments."Class No." := l_RegistrationSubjects2."Class No.";
                                    BufferAssignAssessments."Subject Code" := l_RegistrationSubjects2."Subjects Code";
                                    BufferAssignAssessments.Text := l_RegistrationSubjects2.Description;
                                    BufferAssignAssessments.Level := 2;
                                    BufferAssignAssessments."Option Type" := BufferAssignAssessments."Option Type"::Subjects;
                                    BufferAssignAssessments.Insert;

                                    l_RegistrationSubjects2.CalcFields("Sub-subject");

                                    if l_RegistrationSubjects2."Sub-subject" then begin
                                        l_StudentSubSubjects.Reset;
                                        l_StudentSubSubjects.SetRange("Student Code No.", rRegistration."Student Code No.");
                                        l_StudentSubSubjects.SetRange("School Year", rRegistration."School Year");
                                        l_StudentSubSubjects.SetRange("Subject Code", l_RegistrationSubjects2."Subjects Code");
                                        l_StudentSubSubjects.SetRange(Code, l_RegistrationSubjects."Study Plan Code");
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
                                                BufferAssignAssessments."Class No." := l_RegistrationSubjects."Class No.";
                                                BufferAssignAssessments."Subject Code" := l_StudentSubSubjects."Subject Code";
                                                BufferAssignAssessments."Sub-Subject Code" := l_StudentSubSubjects."Sub-Subject Code";
                                                BufferAssignAssessments.Text := l_StudentSubSubjects."Sub-Subject Description";
                                                BufferAssignAssessments.Level := 3;
                                                BufferAssignAssessments."Option Type" := BufferAssignAssessments."Option Type"::"Sub-Subjects";
                                                BufferAssignAssessments.Insert;

                                            until l_StudentSubSubjects.Next = 0;
                                        end;
                                    end;
                                until l_RegistrationSubjects2.Next = 0;
                            end;


                        end else begin
                            BufferAssignAssessments.Reset;
                            BufferAssignAssessments.SetRange("Student Code No.", l_RegistrationSubjects."Student Code No.");
                            BufferAssignAssessments.SetRange("Class No.", l_RegistrationSubjects."Class No.");
                            BufferAssignAssessments.SetFilter("Subject Code", l_RegistrationSubjects."Option Group");
                            if not BufferAssignAssessments.FindFirst then begin

                                BufferAssignAssessments.Init;
                                BufferAssignAssessments."User ID" := UserId;
                                VarlineNo += 10000;
                                BufferAssignAssessments."Line No." := VarlineNo;
                                BufferAssignAssessments."Student Code No." := l_RegistrationSubjects."Student Code No.";
                                BufferAssignAssessments."Class No." := l_RegistrationSubjects."Class No.";
                                BufferAssignAssessments."Subject Code" := l_RegistrationSubjects."Option Group";
                                l_GroupSubjects.Reset;
                                l_GroupSubjects.SetRange(Code, l_RegistrationSubjects."Option Group");
                                if l_RegistrationSubjects.Type = l_RegistrationSubjects.Type::Simple then
                                    l_GroupSubjects.SetRange("Schooling Year", l_RegistrationSubjects."Schooling Year")
                                else
                                    l_GroupSubjects.SetRange("Schooling Year", '');
                                if l_GroupSubjects.FindFirst then
                                    BufferAssignAssessments.Text := l_GroupSubjects.Description;
                                BufferAssignAssessments.Level := 2;
                                BufferAssignAssessments."Option Type" := BufferAssignAssessments."Option Type"::"Option Group";
                                BufferAssignAssessments.Insert;

                                l_RegistrationSubjects2.Reset;
                                l_RegistrationSubjects2.SetCurrentKey("Student Code No.", "Option Group", "Sorting ID");
                                l_RegistrationSubjects2.SetRange("Student Code No.", rRegistration."Student Code No.");
                                l_RegistrationSubjects2.SetRange("School Year", rRegistration."School Year");
                                l_RegistrationSubjects2.SetRange("Schooling Year", rRegistration."Schooling Year");
                                l_RegistrationSubjects2.SetRange("Option Group", l_RegistrationSubjects."Option Group");
                                l_RegistrationSubjects2.SetRange(Class, rRegistration.Class);
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
                                        BufferAssignAssessments."Class No." := l_RegistrationSubjects2."Class No.";
                                        BufferAssignAssessments."Subject Code" := l_RegistrationSubjects2."Subjects Code";
                                        BufferAssignAssessments.Text := l_RegistrationSubjects2.Description;
                                        BufferAssignAssessments.Level := 3;
                                        BufferAssignAssessments."Option Type" := BufferAssignAssessments."Option Type"::Subjects;
                                        BufferAssignAssessments.Insert;

                                        l_RegistrationSubjects2.CalcFields("Sub-subject");

                                        if l_RegistrationSubjects2."Sub-subject" then begin
                                            l_StudentSubSubjects.Reset;
                                            l_StudentSubSubjects.SetRange("Student Code No.", rRegistration."Student Code No.");
                                            l_StudentSubSubjects.SetRange("School Year", rRegistration."School Year");
                                            l_StudentSubSubjects.SetRange("Subject Code", l_RegistrationSubjects2."Subjects Code");
                                            l_StudentSubSubjects.SetRange(Code, l_RegistrationSubjects."Study Plan Code");
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
                                                    BufferAssignAssessments."Class No." := l_RegistrationSubjects."Class No.";
                                                    BufferAssignAssessments."Subject Code" := l_StudentSubSubjects."Subject Code";
                                                    BufferAssignAssessments."Sub-Subject Code" := l_StudentSubSubjects."Sub-Subject Code";
                                                    BufferAssignAssessments.Text := l_StudentSubSubjects."Sub-Subject Description";
                                                    BufferAssignAssessments.Level := 4;
                                                    BufferAssignAssessments."Option Type" := BufferAssignAssessments."Option Type"::"Sub-Subjects";
                                                    BufferAssignAssessments.Insert;

                                                until l_StudentSubSubjects.Next = 0;
                                            end;
                                        end;
                                    until l_RegistrationSubjects2.Next = 0;
                                end;
                            end;
                        end;
                    until l_RegistrationSubjects.Next = 0;
                end;
            until rRegistration.Next = 0;
        end;

        //for students with subjects of past years
        l_RegistrationSubjects.Reset;
        l_RegistrationSubjects.SetCurrentKey("Student Code No.", "Option Group", "Sorting ID");
        l_RegistrationSubjects.SetRange("School Year", varSchoolYear);
        l_RegistrationSubjects.SetRange("Schooling Year", varSchoolingYear);
        l_RegistrationSubjects.SetRange(Class, varClass);
        l_RegistrationSubjects.SetRange(Status, l_RegistrationSubjects.Status::Subscribed);
        l_RegistrationSubjects.SetRange("Responsibility Center", varRespCenter);
        l_RegistrationSubjects.SetFilter("Evaluation Type", '<>%1', l_RegistrationSubjects."Evaluation Type"::"None Qualification");
        if l_RegistrationSubjects.FindSet then begin
            repeat
                BufferAssignAssessments.Reset;
                BufferAssignAssessments.SetRange("Student Code No.", l_RegistrationSubjects."Student Code No.");
                if not BufferAssignAssessments.FindFirst then begin
                    l_RegistrationSubjects2.Reset;
                    l_RegistrationSubjects2.SetRange("Student Code No.", l_RegistrationSubjects."Student Code No.");
                    l_RegistrationSubjects2.SetRange("School Year", varSchoolYear);
                    l_RegistrationSubjects2.SetRange(Class, varClass);
                    l_RegistrationSubjects2.SetFilter("Evaluation Type", '<>%1', l_RegistrationSubjects2."Evaluation Type"::"None Qualification");
                    if l_RegistrationSubjects2.FindSet then begin
                        BufferAssignAssessments.Reset;
                        BufferAssignAssessments.Init;
                        BufferAssignAssessments."User ID" := UserId;
                        VarlineNo += 10000;
                        BufferAssignAssessments."Line No." := VarlineNo;
                        BufferAssignAssessments."Student Code No." := l_RegistrationSubjects2."Student Code No.";
                        BufferAssignAssessments."Class No." := l_RegistrationSubjects2."Class No.";
                        if l_Students.Get(l_RegistrationSubjects2."Student Code No.") then begin
                            BufferAssignAssessments.Text := l_Students.Name;
                        end;
                        BufferAssignAssessments."Subject Code" := '';
                        BufferAssignAssessments.Level := 1;
                        BufferAssignAssessments."Option Type" := BufferAssignAssessments."Option Type"::Student;
                        BufferAssignAssessments.Insert;
                        repeat
                            BufferAssignAssessments.Reset;
                            BufferAssignAssessments.Init;
                            BufferAssignAssessments."User ID" := UserId;
                            VarlineNo += 10000;
                            BufferAssignAssessments."Line No." := VarlineNo;
                            BufferAssignAssessments."Student Code No." := l_RegistrationSubjects2."Student Code No.";
                            BufferAssignAssessments."Class No." := l_RegistrationSubjects2."Class No.";
                            BufferAssignAssessments."Subject Code" := l_RegistrationSubjects2."Subjects Code";
                            BufferAssignAssessments.Text := l_RegistrationSubjects2.Description;
                            BufferAssignAssessments.Level := 2;
                            BufferAssignAssessments."Option Type" := BufferAssignAssessments."Option Type"::Subjects;
                            BufferAssignAssessments.Insert;


                            l_RegistrationSubjects2.CalcFields("Sub-subject");

                            if l_RegistrationSubjects2."Sub-subject" then begin
                                l_StudentSubSubjects.Reset;
                                l_StudentSubSubjects.SetRange("Student Code No.", l_RegistrationSubjects2."Student Code No.");
                                l_StudentSubSubjects.SetRange("School Year", l_RegistrationSubjects2."School Year");
                                l_StudentSubSubjects.SetRange("Subject Code", l_RegistrationSubjects2."Subjects Code");
                                l_StudentSubSubjects.SetRange(Code, l_RegistrationSubjects2."Study Plan Code");
                                l_StudentSubSubjects.SetRange("Schooling Year", l_RegistrationSubjects2."Schooling Year");
                                l_StudentSubSubjects.SetRange("Responsibility Center", l_RegistrationSubjects2."Responsibility Center");
                                l_StudentSubSubjects.SetRange(Type, l_RegistrationSubjects2.Type);
                                l_StudentSubSubjects.SetFilter("Evaluation Type", '<>%1', l_StudentSubSubjects."Evaluation Type"::"None Qualification");
                                if l_StudentSubSubjects.FindSet then begin
                                    repeat
                                        BufferAssignAssessments.Reset;
                                        BufferAssignAssessments.Init;
                                        BufferAssignAssessments."User ID" := UserId;
                                        VarlineNo += 10000;
                                        BufferAssignAssessments."Line No." := VarlineNo;
                                        BufferAssignAssessments."Student Code No." := l_RegistrationSubjects2."Student Code No.";
                                        BufferAssignAssessments."Class No." := l_RegistrationSubjects2."Class No.";
                                        BufferAssignAssessments."Subject Code" := l_StudentSubSubjects."Subject Code";
                                        BufferAssignAssessments."Sub-Subject Code" := l_StudentSubSubjects."Sub-Subject Code";
                                        BufferAssignAssessments.Text := l_StudentSubSubjects."Sub-Subject Description";
                                        BufferAssignAssessments.Level := 3;
                                        BufferAssignAssessments."Option Type" := BufferAssignAssessments."Option Type"::"Sub-Subjects";
                                        BufferAssignAssessments.Insert;

                                    until l_StudentSubSubjects.Next = 0;
                                end;
                            end;

                        until l_RegistrationSubjects2.Next = 0;
                    end;
                end;
            until l_RegistrationSubjects.Next = 0;

        end;
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
                l_Registration.Validate(l_Registration."Actual Status", varTransitionStatus);
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
    procedure CalcAssessments()
    var
        lRegistrationClass: Record "Registration Class";
        CalcEvaluation: Codeunit "Calc. Evaluation";
        lMomentsAssessment: Record "Moments Assessment";
        nReg: Integer;
        CountReg: Integer;
        Window: Dialog;
    begin
        if varClass = '' then
            Error(text001);

        if varSchoolYear = '' then
            Error(text009);

        if varActiveMoment = '' then
            Error(text008);

        lMomentsAssessment.Reset;
        lMomentsAssessment.SetRange("Moment Code", varActiveMoment);
        lMomentsAssessment.SetRange("School Year", varSchoolYear);
        lMomentsAssessment.SetRange("Schooling Year", varSchoolingYear);
        lMomentsAssessment.SetRange(Active, true);
        if not lMomentsAssessment.FindSet or
          (lMomentsAssessment."Evaluation Moment" = lMomentsAssessment."Evaluation Moment"::"Final Year") then
            Error(text012);

        lRegistrationClass.Reset;
        lRegistrationClass.SetRange("School Year", varSchoolYear);
        lRegistrationClass.SetRange(Class, varClass);
        lRegistrationClass.SetRange("Schooling Year", varSchoolingYear);
        if lRegistrationClass.FindSet then begin
            Window.Open(text014);
            nReg := lRegistrationClass.Count;
            CountReg := 0;
            repeat
                CountReg += 1;
                Window.Update(1, lRegistrationClass."Student Code No.");
                Window.Update(2, Round(CountReg / nReg * 10000, 1));

                // Calc recuperation Moments
                lMomentsAssessment.Reset;
                lMomentsAssessment.SetFilter("Moment Code", '<>%1', varActiveMoment);
                lMomentsAssessment.SetRange("School Year", varSchoolYear);
                lMomentsAssessment.SetRange("Schooling Year", varSchoolingYear);
                lMomentsAssessment.SetRange(Recuperation, true);
                if lMomentsAssessment.FindSet or
                  (lMomentsAssessment."Evaluation Moment" <> lMomentsAssessment."Evaluation Moment"::"Final Year") then begin
                    repeat
                        CalcEvaluation.CalcFinalMoment(varClass,
                                                      varSchoolYear,
                                                      lMomentsAssessment."Moment Code",
                                                      lRegistrationClass."Student Code No.");
                    until lMomentsAssessment.Next = 0;
                end;

                //Calc Active Moments
                CalcEvaluation.CalcFinalMoment(varClass,
                                              varSchoolYear,
                                              varActiveMoment,
                                              lRegistrationClass."Student Code No.");

            until lRegistrationClass.Next = 0;
            Window.Close;
        end;
    end;

    //[Scope('OnPrem')]
    procedure CalcFinalAssessments()
    var
        lRegistrationClass: Record "Registration Class";
        CalcEvaluation: Codeunit "Calc. Evaluation";
        lMomentsAssessment: Record "Moments Assessment";
        lMomentsAssessment2: Record "Moments Assessment";
        nReg: Integer;
        CountReg: Integer;
        Window: Dialog;
    begin
        if varClass = '' then
            Error(text001);

        if varSchoolYear = '' then
            Error(text009);

        if varActiveMoment = '' then
            Error(text008);

        lMomentsAssessment.Reset;
        lMomentsAssessment.SetRange("Moment Code", varActiveMoment);
        lMomentsAssessment.SetRange("School Year", varSchoolYear);
        lMomentsAssessment.SetRange("Schooling Year", varSchoolingYear);
        lMomentsAssessment.SetRange(Active, true);
        if not lMomentsAssessment.FindSet then
            if (lMomentsAssessment."Evaluation Moment" <> lMomentsAssessment."Evaluation Moment"::"Final Year") and
              (lMomentsAssessment."Evaluation Moment" <> lMomentsAssessment."Evaluation Moment"::CIF) and
              (lMomentsAssessment."Evaluation Moment" <> lMomentsAssessment."Evaluation Moment"::CFD) then
                Error(text011);

        lRegistrationClass.Reset;
        lRegistrationClass.SetRange("School Year", varSchoolYear);
        lRegistrationClass.SetRange(Class, varClass);
        if lRegistrationClass.FindSet then begin
            Window.Open(text013);
            nReg := lRegistrationClass.Count;
            CountReg := 0;
            repeat
                CountReg += 1;
                Window.Update(1, lRegistrationClass."Student Code No.");
                Window.Update(2, Round(CountReg / nReg * 10000, 1));
                // Calc recuperation Moments
                lMomentsAssessment2.Reset;
                lMomentsAssessment2.SetFilter("Evaluation Moment", '<>%1', lMomentsAssessment2."Evaluation Moment"::"Final Year");
                lMomentsAssessment2.SetFilter("Moment Code", '<>%1', varActiveMoment);
                lMomentsAssessment2.SetRange("School Year", varSchoolYear);
                lMomentsAssessment2.SetRange("Schooling Year", varSchoolingYear);
                lMomentsAssessment2.SetRange(Recuperation, true);
                if lMomentsAssessment2.FindSet then begin
                    repeat
                        CalcEvaluation.CalcFinalMoment(varClass,
                                                      varSchoolYear,
                                                      lMomentsAssessment2."Moment Code",
                                                      lRegistrationClass."Student Code No.");
                    until lMomentsAssessment2.Next = 0;
                end;


                CalcEvaluation.CalcFinalYear(varClass, varSchoolYear, varActiveMoment, lRegistrationClass."Student Code No.",
                  lMomentsAssessment."Evaluation Moment");

            until lRegistrationClass.Next = 0;
            Window.Close;
        end;
    end;

    //[Scope('OnPrem')]
    procedure WebToNAVUpdate()
    var
        CalcEvaluations: Codeunit "Calc. Evaluation";
    begin
    end;

    //[Scope('OnPrem')]
    procedure ValidateActualStatus()
    var
        lMomentsAssessment: Record "Moments Assessment";
        l_AssStudent: Record "Assessing Students";
    begin

        lMomentsAssessment.Reset;
        lMomentsAssessment.SetRange("Moment Code", varActiveMoment);
        lMomentsAssessment.SetRange("School Year", varSchoolYear);
        lMomentsAssessment.SetRange("Schooling Year", varSchoolingYear);
        lMomentsAssessment.SetRange(Active, true);
        lMomentsAssessment.SetRange("Evaluation Moment", lMomentsAssessment."Evaluation Moment"::"Final Year");
        if lMomentsAssessment.FindFirst then begin
            l_AssStudent.Reset;
            l_AssStudent.SetRange("School Year", varSchoolYear);
            l_AssStudent.SetRange("Schooling Year", varSchoolingYear);
            l_AssStudent.SetRange(Class, varClass);
            l_AssStudent.SetRange("Evaluation Moment", l_AssStudent."Evaluation Moment"::"Final Year");
            if l_AssStudent.FindFirst then begin
                ActualStatusVisible := true;
            end else
                ActualStatusVisible := false;
        end else
            ActualStatusVisible := false;
    end;

    //[Scope('OnPrem')]
    procedure CheckRules(pSchoolYear: Code[20]; pSchoolingYear: Code[20]; pStudyPlanCode: Code[20]): Integer
    var
        l_rulesofEval: Record "Rules of Evaluations";
    begin
        l_rulesofEval.Reset;
        l_rulesofEval.SetRange("Schooling Year", pSchoolingYear);
        l_rulesofEval.SetRange("School Year", pSchoolYear);
        l_rulesofEval.SetRange("Study Plan Code", pStudyPlanCode);
        l_rulesofEval.SetRange("Rule Type", l_rulesofEval."Rule Type"::Student);
        l_rulesofEval.SetRange("Classifications Calculations", l_rulesofEval."Classifications Calculations"::"Final Stage");
        if l_rulesofEval.FindSet then
            exit(l_rulesofEval.Count);
    end;

    local procedure varClassOnAfterValidate()
    begin
        UpdateForm;
        CurrPage.Update(false);
    end;

    local procedure varTransitionStatusOnAfterVali()
    begin
        CurrPage.Update(false);
    end;

    local procedure varAttendanceSituation1OnAfter()
    begin
        CurrPage.Update;
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

    local procedure OnAfterGetCurrRecord2()
    begin
        xRec := Rec;
        if Rec."Option Type" = Rec."Option Type"::Subjects then
            AttendanceSituationEditable := true
        else begin
            AttendanceSituationEditable := false;
            varAttendanceSituation[1] := 0;
        end;
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

    local procedure varAttendanceSituation1OnActiv()
    begin
        rRegistrationSubejcts.Reset;
        rRegistrationSubejcts.SetRange("Student Code No.", Rec."Student Code No.");
        rRegistrationSubejcts.SetRange("Schooling Year", varSchoolingYear);
        rRegistrationSubejcts.SetRange(Class, varClass);
        rRegistrationSubejcts.SetRange("School Year", varSchoolYear);
        rRegistrationSubejcts.SetRange("Subjects Code", Rec."Subject Code");
        if rRegistrationSubejcts.FindFirst then
            varAttendanceSituation[1] := rRegistrationSubejcts."Attendance Situation"
        else
            varAttendanceSituation[1] := 0;

        if Rec."Option Type" = Rec."Option Type"::Subjects then begin
            AttendanceSituationEditable := false;
        end else begin
            AttendanceSituationEditable := true;
            varAttendanceSituation[1] := 0;
        end;
        CurrPage.Update;
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

    local procedure StudentCodeNoC1102065003OnForm()
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
        if VArrayMomActive[1] = false then
            Txt1Editable := false
        else
            Txt1Editable := true;

        if Rec."Option Type" = Rec."Option Type"::Student then
            Txt1Emphasize := true;
    end;

    local procedure vText2OnFormat()
    begin
        if VArrayMomActive[2] = false then
            Txt2Editable := false
        else
            Txt2Editable := true;

        if Rec."Option Type" = Rec."Option Type"::Student then
            Txt2Emphasize := true;
    end;

    local procedure vText3OnFormat()
    begin
        if VArrayMomActive[3] = false then
            Txt3Editable := false
        else
            Txt3Editable := true;


        if Rec."Option Type" = Rec."Option Type"::Student then
            Txt3Emphasize := true;
    end;

    local procedure vText4OnFormat()
    begin
        if VArrayMomActive[4] = false then
            Txt4Editable := false
        else
            Txt4Editable := true;

        if Rec."Option Type" = Rec."Option Type"::Student then
            Txt4Emphasize := true;
    end;

    local procedure vText5OnFormat()
    begin
        if VArrayMomActive[5] = false then
            Txt5Editable := false
        else
            Txt5Editable := true;

        if Rec."Option Type" = Rec."Option Type"::Student then
            Txt5Emphasize := true;
    end;

    local procedure vText6OnFormat()
    begin
        if VArrayMomActive[6] = false then
            Txt6Editable := false
        else
            Txt6Editable := true;

        if Rec."Option Type" = Rec."Option Type"::Student then
            Txt6Emphasize := true;
    end;

    local procedure vText7OnFormat()
    begin
        if VArrayMomActive[7] = false then
            Txt7Editable := false
        else
            Txt7Editable := true;

        if Rec."Option Type" = Rec."Option Type"::Student then
            Txt7Emphasize := true;
    end;

    local procedure vText8OnFormat()
    begin
        if VArrayMomActive[8] = false then
            Txt8Editable := false
        else
            Txt8Editable := true;

        if Rec."Option Type" = Rec."Option Type"::Student then
            Txt8Emphasize := true;
    end;

    local procedure vText9OnFormat()
    begin
        if VArrayMomActive[9] = false then
            Txt9Editable := false
        else
            Txt9Editable := true;

        if Rec."Option Type" = Rec."Option Type"::Student then
            Txt9Emphasize := true;
    end;

    local procedure vText10OnFormat()
    begin
        if VArrayMomActive[10] = false then
            Txt10Editable := false
        else
            Txt10Editable := true;

        if Rec."Option Type" = Rec."Option Type"::Student then
            Txt10Emphasize := true;
    end;

    local procedure vText11OnFormat()
    begin
        if VArrayMomActive[11] = false then
            Txt11Editable := false
        else
            Txt11Editable := true;

        if Rec."Option Type" = Rec."Option Type"::Student then
            Txt11Emphasize := true;
    end;

    local procedure vText12OnFormat()
    begin
        if VArrayMomActive[12] = false then
            Txt12Editable := false
        else
            Txt12Editable := true;

        if Rec."Option Type" = Rec."Option Type"::Student then
            Txt12Emphasize := true;
    end;

    local procedure vText13OnFormat()
    begin
        if VArrayMomActive[13] = false then
            Txt13Editable := false
        else
            Txt13Editable := true;

        if Rec."Option Type" = Rec."Option Type"::Student then
            Txt13Emphasize := true;
    end;

    local procedure vText14OnFormat()
    begin
        if VArrayMomActive[14] = false then
            Txt14Editable := false
        else
            Txt14Editable := true;

        if Rec."Option Type" = Rec."Option Type"::Student then
            Txt14Emphasize := true;
    end;

    local procedure vText15OnFormat()
    begin
        if VArrayMomActive[15] = false then
            Txt15Editable := false
        else
            Txt15Editable := true;

        if Rec."Option Type" = Rec."Option Type"::Student then
            Txt15Emphasize := true;
    end;
}

#pragma implicitwith restore

