#pragma implicitwith disable
page 31009916 "Insert History Assessment"
{
    Caption = 'Insert History Assessment';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = true;
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
                field(varSchoolYear; varSchoolYear)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'School Year';
                    Editable = false;
                    TableRelation = "School Year"."School Year";

                    trigger OnValidate()
                    begin
                        Clear(Rec);
                        varSchoolYearOnAfterValidate;
                    end;
                }
                field(varSchoolingYear; varSchoolingYear)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Schooling Year';
                    TableRelation = "Structure Education Country"."Schooling Year";

                    trigger OnValidate()
                    begin
                        Clear(Rec);
                        varSchoolingYearOnAfterValidat;
                    end;
                }
                field(varCourseCode; varCourseCode)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Study Plan/Course Code';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        l_CourseHeaderTEMP: Record "Course Header" temporary;
                    begin
                        if VarType = VarType::Simple then begin
                            rStudyPlanHeader.Reset;
                            rStudyPlanHeader.SetRange("School Year", varSchoolYear);
                            rStudyPlanHeader.SetRange("Schooling Year", varSchoolingYear);
                            if rStudyPlanHeader.FindSet then;

                            if PAGE.RunModal(PAGE::"Study Plan List", rStudyPlanHeader) = ACTION::LookupOK then
                                varCourseCode := rStudyPlanHeader.Code;
                        end;
                        if VarType = VarType::Multi then begin

                            rStruEduCountry.Reset;
                            rStruEduCountry.SetRange("Schooling Year", varSchoolingYear);
                            if rStruEduCountry.FindFirst then;

                            rStruEduCountry2.Reset;
                            rStruEduCountry2.SetRange("Edu. Level", rStruEduCountry."Edu. Level");
                            rStruEduCountry2.SetRange(Level, rStruEduCountry.Level);

                            if rStruEduCountry2.FindSet then begin
                                repeat

                                    rCourseHeader.Reset;
                                    rCourseHeader.SetRange("Schooling Year Begin", rStruEduCountry2."Schooling Year");
                                    if rCourseHeader.FindSet then begin
                                        repeat
                                            l_CourseHeaderTEMP.Reset;
                                            l_CourseHeaderTEMP.SetRange(Code, rCourseHeader.Code);
                                            if not l_CourseHeaderTEMP.FindSet then begin
                                                l_CourseHeaderTEMP.Init;
                                                l_CourseHeaderTEMP.TransferFields(rCourseHeader);
                                                l_CourseHeaderTEMP.Insert;

                                            end;
                                        until rCourseHeader.Next = 0;

                                    end;
                                until rStruEduCountry2.Next = 0;
                            end;
                            l_CourseHeaderTEMP.SetRange(Code);
                            if PAGE.RunModal(PAGE::"Course List", l_CourseHeaderTEMP) = ACTION::LookupOK then
                                varCourseCode := l_CourseHeaderTEMP.Code;


                        end;
                        //GetLines;
                        //IF VarType = VarType::Multi THEN
                        //  VarStudyPlan2 := GetSubjects;

                        DeleteBuffer;
                        InsertStudents;
                        InitTempTable;
                        UpdateForm;
                        CurrPage.Update(false);
                    end;

                    trigger OnValidate()
                    begin
                        Clear(Rec);
                        varCourseCodeOnAfterValidate;
                    end;
                }
                repeater(Tablebox1)
                {
                    IndentationColumn = TextIndent;
                    IndentationControls = Text;
                    ShowAsTree = true;
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
                    field(ActualStatus; varTransitionStatus)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Actual Status';
                        OptionCaption = ' ,Registered,Transited,Not Transited,Concluded,Not Concluded,Abandonned,Registration Annulled,Tranfered,Exclusion by Incidences,Ongoing evaluation,Retained from Absences';
                        Visible = ActualStatusVisible;

                        trigger OnValidate()
                        begin
                            if Rec."Option Type" <> Rec."Option Type"::Student then
                                Error(text0014);

                            GetRegistrationAproved(true);
                            varTransitionStatusOnAfterVali;
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
                            if ((vArrayType[1] <> vArrayType[1] ::"Final Moment") and
                              (vArrayType[1] <> vArrayType[1] ::"Final Year")) and
                              ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
                              (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[1] = 0) or
                              ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[1] <> 0)) then
                                exit;

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
                            if ((vArrayType[1] <> vArrayType[1] ::"Final Moment") and
                              (vArrayType[1] <> vArrayType[1] ::"Final Year")) and
                              ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
                              (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[1] = 0) or
                              ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[1] <> 0)) then
                                vText[1] := '';


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
                            if ((vArrayType[2] <> vArrayType[2] ::"Final Moment") and
                              (vArrayType[2] <> vArrayType[2] ::"Final Year")) and
                              ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
                              (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[2] = 0) or
                              ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[2] <> 0)) then
                                exit;

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
                            if ((vArrayType[2] <> vArrayType[2] ::"Final Moment") and
                              (vArrayType[2] <> vArrayType[2] ::"Final Year")) and
                              ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
                              (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[2] = 0) or
                              ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[2] <> 0)) then
                                vText[2] := '';

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
                            if ((vArrayType[3] <> vArrayType[3] ::"Final Moment") and
                              (vArrayType[3] <> vArrayType[3] ::"Final Year")) and
                              ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
                              (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[3] = 0) or
                              ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[3] <> 0)) then
                                exit;

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
                            if ((vArrayType[3] <> vArrayType[3] ::"Final Moment") and
                              (vArrayType[3] <> vArrayType[3] ::"Final Year")) and
                              ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
                              (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[3] = 0) or
                              ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[3] <> 0)) then
                                vText[3] := '';

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
                            if ((vArrayType[4] <> vArrayType[4] ::"Final Moment") and
                              (vArrayType[4] <> vArrayType[4] ::"Final Year")) and
                              ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
                              (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[4] = 0) or
                              ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[4] <> 0)) then
                                exit;

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
                            if ((vArrayType[4] <> vArrayType[4] ::"Final Moment") and
                              (vArrayType[4] <> vArrayType[4] ::"Final Year")) and
                              ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
                              (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[4] = 0) or
                              ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[4] <> 0)) then
                                vText[4] := '';

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
                            if ((vArrayType[5] <> vArrayType[5] ::"Final Moment") and
                              (vArrayType[5] <> vArrayType[5] ::"Final Year")) and
                              ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
                              (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[5] = 0) or
                              ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[5] <> 0)) then
                                exit;

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
                            if ((vArrayType[5] <> vArrayType[5] ::"Final Moment") and
                              (vArrayType[5] <> vArrayType[5] ::"Final Year")) and
                              ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
                              (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[5] = 0) or
                              ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[5] <> 0)) then
                                vText[5] := '';

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
                            if ((vArrayType[6] <> vArrayType[6] ::"Final Moment") and
                              (vArrayType[6] <> vArrayType[6] ::"Final Year")) and
                              ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
                              (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[6] = 0) or
                              ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[6] <> 0)) then
                                exit;

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
                            if ((vArrayType[6] <> vArrayType[6] ::"Final Moment") and
                              (vArrayType[6] <> vArrayType[6] ::"Final Year")) and
                              ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
                              (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[6] = 0) or
                              ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[6] <> 0)) then
                                vText[6] := '';

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
                            if ((vArrayType[7] <> vArrayType[7] ::"Final Moment") and
                              (vArrayType[7] <> vArrayType[7] ::"Final Year")) and
                              ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
                              (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[7] = 0) or
                              ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[7] <> 0)) then
                                exit;

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
                            if ((vArrayType[7] <> vArrayType[7] ::"Final Moment") and
                              (vArrayType[7] <> vArrayType[7] ::"Final Year")) and
                              ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
                              (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[7] = 0) or
                              ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[7] <> 0)) then
                                vText[7] := '';

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
                            if ((vArrayType[8] <> vArrayType[8] ::"Final Moment") and
                              (vArrayType[8] <> vArrayType[8] ::"Final Year")) and
                              ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
                              (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[8] = 0) or
                              ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[8] <> 0)) then
                                exit;

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
                            if ((vArrayType[8] <> vArrayType[8] ::"Final Moment") and
                              (vArrayType[8] <> vArrayType[8] ::"Final Year")) and
                              ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
                              (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[8] = 0) or
                              ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[8] <> 0)) then
                                vText[8] := '';

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
                            if ((vArrayType[9] <> vArrayType[9] ::"Final Moment") and
                              (vArrayType[9] <> vArrayType[9] ::"Final Year")) and
                              ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
                              (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[9] = 0) or
                              ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[9] <> 0)) then
                                exit;

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
                            if ((vArrayType[9] <> vArrayType[9] ::"Final Moment") and
                              (vArrayType[9] <> vArrayType[9] ::"Final Year")) and
                              ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
                              (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[9] = 0) or
                              ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[9] <> 0)) then
                                vText[9] := '';

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
                            if ((vArrayType[10] <> vArrayType[10] ::"Final Moment") and
                              (vArrayType[10] <> vArrayType[10] ::"Final Year")) and
                              ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
                              (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[10] = 0) or
                              ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[10] <> 0)) then
                                exit;

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
                            if ((vArrayType[10] <> vArrayType[10] ::"Final Moment") and
                              (vArrayType[10] <> vArrayType[10] ::"Final Year")) and
                              ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
                              (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[10] = 0) or
                              ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[10] <> 0)) then
                                vText[10] := '';

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
                            if ((vArrayType[11] <> vArrayType[11] ::"Final Moment") and
                              (vArrayType[11] <> vArrayType[11] ::"Final Year")) and
                              ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
                              (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[11] = 0) or
                              ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[11] <> 0)) then
                                exit;

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
                            if ((vArrayType[11] <> vArrayType[11] ::"Final Moment") and
                             (vArrayType[11] <> vArrayType[11] ::"Final Year")) and
                             ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
                             (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[11] = 0) or
                             ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[11] <> 0)) then
                                vText[11] := '';

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
                            if ((vArrayType[12] <> vArrayType[12] ::"Final Moment") and
                              (vArrayType[12] <> vArrayType[12] ::"Final Year")) and
                              ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
                              (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[12] = 0) or
                              ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[12] <> 0)) then
                                exit;

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
                            if ((vArrayType[12] <> vArrayType[12] ::"Final Moment") and
                              (vArrayType[12] <> vArrayType[12] ::"Final Year")) and
                              ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
                              (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[12] = 0) or
                              ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[12] <> 0)) then
                                vText[12] := '';

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
                            if ((vArrayType[13] <> vArrayType[13] ::"Final Moment") and
                              (vArrayType[13] <> vArrayType[13] ::"Final Year")) and
                              ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
                              (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[13] = 0) or
                              ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[13] <> 0)) then
                                exit;

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
                            if ((vArrayType[13] <> vArrayType[13] ::"Final Moment") and
                              (vArrayType[13] <> vArrayType[13] ::"Final Year")) and
                              ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
                              (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[13] = 0) or
                              ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[13] <> 0)) then
                                vText[13] := '';

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
                            if ((vArrayType[14] <> vArrayType[14] ::"Final Moment") and
                              (vArrayType[14] <> vArrayType[14] ::"Final Year")) and
                              ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
                              (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[14] = 0) or
                              ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[14] <> 0)) then
                                exit;

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
                            if ((vArrayType[14] <> vArrayType[14] ::"Final Moment") and
                              (vArrayType[14] <> vArrayType[14] ::"Final Year")) and
                              ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
                              (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[14] = 0) or
                              ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[14] <> 0)) then
                                vText[14] := '';

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
                            if ((vArrayType[15] <> vArrayType[15] ::"Final Moment") and
                              (vArrayType[15] <> vArrayType[15] ::"Final Year")) and
                              ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
                              (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[15] = 0) or
                              ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[15] <> 0)) then
                                exit;

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
                            if ((vArrayType[15] <> vArrayType[15] ::"Final Moment") and
                              (vArrayType[15] <> vArrayType[15] ::"Final Year")) and
                              ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
                              (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[15] = 0) or
                              ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[15] <> 0)) then
                                vText[15] := '';

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
                            vText15OnAfterValidate;
                        end;
                    }
                    field(Bookterms; vTermsBook)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Term Book';
                        Editable = BooktermsEditable;

                        trigger OnValidate()
                        begin
                            InsertTerms(vTermsBook, vTermsSheet);
                        end;
                    }
                    field(SheetTerms; vTermsSheet)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Term Sheet';
                        Editable = SheetTermsEditable;

                        trigger OnValidate()
                        begin
                            InsertTerms(vTermsBook, vTermsSheet);
                        end;
                    }
                }
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
                ApplicationArea = Basic, Suite;
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
                ApplicationArea = Basic, Suite;
                Caption = '&Global Remarks';
                Image = Setup;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    l_Class: Record Class;
                begin

                    if l_Class.Get(Rec.Class, varSchoolYear) then;

                    fRemarksWizard.GetMomentInformation(varSelectedMoment);

                    varTypeButtonEdit := true;
                    fRemarksWizard.GetInformation(Rec."Student Code No.", varSchoolYear, Rec.Class, Rec."Schooling Year", l_Class."Study Plan Code", '', '',
                                                   Rec."Class No.", VarType, varTypeButtonEdit);
                    fRemarksWizard.Run;
                end;
            }
            action("&Remarks")
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Remarks';
                Image = Setup;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    l_class: Record Class;
                begin
                    if l_class.Get(Rec.Class, varSchoolYear) then;

                    Clear(fRemarksWizard);
                    fRemarksWizard.GetMomentInformation(varSelectedMoment);

                    varTypeButtonEdit := true;
                    fRemarksWizard.GetInformation(Rec."Student Code No.", varSchoolYear, Rec.Class, Rec."Schooling Year", l_class."Study Plan Code", Rec."Subject Code",
                                      Rec."Sub-Subject Code", Rec."Class No.", VarType, varTypeButtonEdit);
                    fRemarksWizard.Run;
                end;
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("E&xpand/Collapse")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'E&xpand/Collapse';
                    Image = ExpandDepositLine;

                    trigger OnAction()
                    begin
                        ToggleExpandCollapse;
                    end;
                }
                action("Expand &All")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Expand &All';
                    Image = ExpandAll;

                    trigger OnAction()
                    begin
                        ExpandAll;
                    end;
                }
                action("&Collapse All")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Collapse All';
                    Image = Close;

                    trigger OnAction()
                    begin
                        InitTempTable;
                    end;
                }
            }
            action("&Print")
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    l_vBulletimType: Option " ","Registration Sheet","bulletim Pre Primary","Bulletim Primary","Bulletim Lower Secondary","Bulletim upper Secondary";
                    l_PageBreak: Boolean;
                    l_rStructureEducationCountry: Record "Structure Education Country";
                    l_rStudents: Record Students;
                    l_rTemplates: Record Templates;
                    l_ftemplates: Page Templates;
                begin
                    Clear(l_ftemplates);
                    l_PageBreak := false;
                    l_rStructureEducationCountry.Reset;
                    l_rStructureEducationCountry.SetRange("Schooling Year", Rec."Schooling Year");
                    if l_rStructureEducationCountry.FindSet then
                        if l_rStructureEducationCountry."Edu. Level" = l_rStructureEducationCountry."Edu. Level"::"Pre-Primary Edu." then
                            l_vBulletimType := l_vBulletimType::"bulletim Pre Primary";
                    if l_rStructureEducationCountry."Edu. Level" = l_rStructureEducationCountry."Edu. Level"::"Primary Edu." then
                        l_vBulletimType := l_vBulletimType::"Bulletim Primary";
                    if l_rStructureEducationCountry."Edu. Level" = l_rStructureEducationCountry."Edu. Level"::"Lower Secondary Edu." then
                        l_vBulletimType := l_vBulletimType::"Bulletim Lower Secondary";
                    if l_rStructureEducationCountry."Edu. Level" = l_rStructureEducationCountry."Edu. Level"::"Upper Secondary Edu." then
                        l_vBulletimType := l_vBulletimType::"Bulletim upper Secondary";
                    if l_rStudents.Get(Rec."Student Code No.") then begin
                        l_rTemplates.Reset;
                        l_rTemplates.SetRange(Type, l_vBulletimType);
                        l_ftemplates.SetTableView(l_rTemplates);
                        l_ftemplates.SetFormStudents(Rec."Student Code No.", varSchoolYear, '', Rec."Schooling Year", '', l_PageBreak, '', '', l_vBulletimType,
                                                   l_rStudents."Responsibility Center", '', true);
                        l_ftemplates.LookupMode(true);
                        l_ftemplates.RunModal;
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
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

        InsertColunm;

        EditableFuction;

        ValidateActualStatus;


        GetTerms(vTermsBook, vTermsSheet);
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
        vTermsBookOnFormat;
        vTermsSheetOnFormat;
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
        SheetTermsEditable := true;
        BooktermsEditable := true;
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

    trigger OnOpenPage()
    begin
        DeleteBuffer;
        UpdateForm;
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
        varStudent: Code[20];
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
        rStudents: Record Students;
        VarFinalType: array[15] of Option " ","Final Year","Final Cycle","Final Stage";
        rAssessingStudents: Record "Assessing Students";
        VarlineNo: Integer;
        text0017: Label 'The Sorting ID for the Moment %1 School Year %2 and Schooling year %3 must be higer than 0.';
        vTermsBook: Text[10];
        vTermsSheet: Text[10];
        Text0018: Label 'There is no CFD type Moment configured.';
        Text0019: Label 'The Student must have a posted CFD assessment.';
        varCourseCode: Code[20];
        rStudyPlanHeader: Record "Study Plan Header";
        rCourseHeader: Record "Course Header";
        rStruEduCountry2: Record "Structure Education Country";
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
        Txt1Emphasize: Boolean;
        [InDataSet]
        Txt2Emphasize: Boolean;
        [InDataSet]
        Txt3Emphasize: Boolean;
        [InDataSet]
        Txt4Emphasize: Boolean;
        [InDataSet]
        Txt5Emphasize: Boolean;
        [InDataSet]
        Txt6Emphasize: Boolean;
        [InDataSet]
        Txt7Emphasize: Boolean;
        [InDataSet]
        Txt8Emphasize: Boolean;
        [InDataSet]
        Txt9Emphasize: Boolean;
        [InDataSet]
        Txt10Emphasize: Boolean;
        [InDataSet]
        Txt11Emphasize: Boolean;
        [InDataSet]
        Txt12Emphasize: Boolean;
        [InDataSet]
        Txt13Emphasize: Boolean;
        [InDataSet]
        Txt14Emphasize: Boolean;
        [InDataSet]
        Txt15Emphasize: Boolean;
        [InDataSet]
        BooktermsEditable: Boolean;
        [InDataSet]
        SheetTermsEditable: Boolean;
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
        BufferAssignAssessments.SetCurrentKey("Schooling Year");
        if OnlyRoot then
            BufferAssignAssessments.SetRange(Level, 1);
        if BufferAssignAssessments.Find('-') then
            repeat
                Rec := BufferAssignAssessments;
                Rec.Insert;
            until BufferAssignAssessments.Next = 0;

        Rec.SetCurrentKey("Schooling Year");
        if Rec.FindFirst then;
    end;

    local procedure HasChildren(ActualAssess: Record "Assign Assessments Buffer" temporary): Boolean
    var
        Assess2: Record "Assign Assessments Buffer" temporary;
    begin
        BufferAssignAssessments.Reset;
        BufferAssignAssessments.SetCurrentKey("Schooling Year");
        BufferAssignAssessments.SetRange(BufferAssignAssessments."Student Code No.", ActualAssess."Student Code No.");
        BufferAssignAssessments.SetRange("Schooling Year", ActualAssess."Schooling Year");
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
        BufferAssignAssessments.SetCurrentKey("Schooling Year");
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
    var
        varMomentCode: Code[20];
    begin
        Clear(vArrayMomento);
        Clear(vArrayCodMomento);
        Clear(vArrayType);
        indx := 0;

        rMomentsAssessment.Reset;
        rMomentsAssessment.SetRange("School Year", varSchoolYear);
        rMomentsAssessment.SetRange("Schooling Year", varSchoolingYear);
        rMomentsAssessment.SetRange("Responsibility Center", varRespCenter);
        if rMomentsAssessment.FindSet then begin
            repeat
                if rMomentsAssessment."Sorting ID" = 0 then
                    Error(text0017);
                if rMomentsAssessment."Sorting ID" > indx then
                    indx := rMomentsAssessment."Sorting ID";
                if rMomentsAssessment.Description = '' then
                    vArrayMomento[rMomentsAssessment."Sorting ID"] := rMomentsAssessment."Moment Code"
                else
                    vArrayMomento[rMomentsAssessment."Sorting ID"] := rMomentsAssessment.Description;

                varMomentCode := rMomentsAssessment."Moment Code";
                vArrayCodMomento[rMomentsAssessment."Sorting ID"] := rMomentsAssessment."Moment Code";
                vArrayType[rMomentsAssessment."Sorting ID"] := rMomentsAssessment."Evaluation Moment";
                VArrayMomActive[rMomentsAssessment."Sorting ID"] := true;
            until rMomentsAssessment.Next = 0;
        end;

        rStruEduCountry.Reset;
        rStruEduCountry.SetCurrentKey("Sorting ID");
        rStruEduCountry.SetRange("Schooling Year", Rec."Schooling Year");
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
        l_OptionGroup: Record "Group Subjects";
        rRulesEvaluations: Record "Rules of Evaluations";
    begin
        if Rec."Option Type" = Rec."Option Type"::Subjects then begin
            if VarType = 0 then begin
                Clear(vArrayAssessmentType[inIndex]);
                Clear(vArrayAssessmentCode[inIndex]);

                rStudyPlanLines.Reset;
                rStudyPlanLines.SetRange(Code, varCourseCode);
                rStudyPlanLines.SetRange("School Year", varSchoolYear);
                rStudyPlanLines.SetRange("Schooling Year", varSchoolingYear);
                rStudyPlanLines.SetRange("Subject Code", Rec."Subject Code");
                if rStudyPlanLines.FindSet then begin
                    vArrayAssessmentType[inIndex] := rStudyPlanLines."Evaluation Type";
                    vArrayAssessmentCode[inIndex] := rStudyPlanLines."Assessment Code";
                end;
            end;
            if VarType = 1 then begin
                Clear(vArrayAssessmentType[inIndex]);
                Clear(vArrayAssessmentCode[inIndex]);

                rCourseLinesTEMP.Reset;
                rCourseLinesTEMP.SetRange(Code, varCourseCode);
                rCourseLinesTEMP.SetRange("Subject Code", Rec."Subject Code");
                if rCourseLinesTEMP.FindSet then begin
                    vArrayAssessmentType[inIndex] := rCourseLinesTEMP."Evaluation Type";
                    vArrayAssessmentCode[inIndex] := rCourseLinesTEMP."Assessment Code";
                end;
            end;
        end;

        //MOMENT
        if (Rec."Option Type" = Rec."Option Type"::"Schooling Year") and (VarFinalType[inIndex] = 0) then begin
            Clear(vArrayAssessmentType[inIndex]);
            Clear(vArrayAssessmentCode[inIndex]);

            l_AssessmentConfiguration.Reset;
            l_AssessmentConfiguration.SetRange("Study Plan Code", varCourseCode);
            l_AssessmentConfiguration.SetRange("School Year", varSchoolYear);
            l_AssessmentConfiguration.SetRange(Type, VarType);
            if l_AssessmentConfiguration.FindFirst then begin
                vArrayAssessmentType[inIndex] := l_AssessmentConfiguration."PA Evaluation Type";
                vArrayAssessmentCode[inIndex] := l_AssessmentConfiguration."PA Assessment Code";
            end;

            l_AssessmentConfiguration.Reset;
            l_AssessmentConfiguration.SetRange("Study Plan Code", varStudyPlanCode);
            l_AssessmentConfiguration.SetRange("School Year", varSchoolYear);
            l_AssessmentConfiguration.SetRange(Type, VarType);
            if l_AssessmentConfiguration.FindFirst then begin
                vArrayAssessmentType[inIndex] := l_AssessmentConfiguration."FY Evaluation Type";
                vArrayAssessmentCode[inIndex] := l_AssessmentConfiguration."FY Assessment Code";
            end;
        end;

        if Rec."Option Type" = Rec."Option Type"::"Option Group" then begin
            Clear(vArrayAssessmentType[inIndex]);
            Clear(vArrayAssessmentCode[inIndex]);

            if VarType = 1 then begin
                l_OptionGroup.Reset;
                l_OptionGroup.SetRange(Code, Rec."Subject Code");
                l_OptionGroup.SetRange("Schooling Year", '');
                if l_OptionGroup.FindSet then begin
                    vArrayAssessmentType[inIndex] := l_OptionGroup."Evaluation Type";
                    vArrayAssessmentCode[inIndex] := l_OptionGroup."Assessment Code";
                end;
            end;
            if VarType = 0 then begin
                if l_OptionGroup.Get(Rec."Subject Code", varSchoolingYear) then begin
                    vArrayAssessmentType[inIndex] := l_OptionGroup."Evaluation Type";
                    vArrayAssessmentCode[inIndex] := l_OptionGroup."Assessment Code";
                end;
            end;
        end;

        if (Rec."Option Type" = Rec."Option Type"::"Schooling Year") and (VarFinalType[inIndex] <> 0) then begin

            Clear(vArrayAssessmentType[inIndex]);
            Clear(vArrayAssessmentCode[inIndex]);
            rRulesEvaluations.Reset;
            rRulesEvaluations.SetRange("Schooling Year", vArrayCodMomento[inIndex]);
            if VarFinalType[inIndex] = rRulesEvaluations."Classifications Calculations"::"Final Cycle" then
                rRulesEvaluations.SetRange("Classifications Calculations", rRulesEvaluations."Classifications Calculations"::"Final Cycle");
            if VarFinalType[inIndex] = rRulesEvaluations."Classifications Calculations"::"Final Stage" then
                rRulesEvaluations.SetRange("Classifications Calculations", rRulesEvaluations."Classifications Calculations"::"Final Stage");
            rRulesEvaluations.SetRange("Study Plan Code", varCourseCode);
            rRulesEvaluations.SetRange(Type, VarType);
            rRulesEvaluations.SetRange("School Year", varSchoolYear);
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
        l_OptionGroup: Record "Group Subjects";
        l_GradeDec: Decimal;
    begin
        GetTypeAssessment(inIndex);
        if (Rec."Option Type" = Rec."Option Type"::"Option Group") or (Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
          (VarFinalType[inIndex] <> 0) then begin
            l_FinalAssessingStudents.Reset;
            l_FinalAssessingStudents.SetRange(Class, varClass);
            l_FinalAssessingStudents.SetRange("School Year", varSchoolYear);
            l_FinalAssessingStudents.SetRange("Student Code No.", varStudent);
            if VarFinalType[inIndex] = 0 then
                l_FinalAssessingStudents.SetRange("Moment Code", vArrayCodMomento[inIndex]);
            if (vArrayType[inIndex] = vArrayType[inIndex] ::"Final Moment") or
            (vArrayType[inIndex] = vArrayType[inIndex] ::Interim) then begin

                if Rec."Option Type" = Rec."Option Type"::"Schooling Year" then
                    l_FinalAssessingStudents.SetRange("Evaluation Type", l_FinalAssessingStudents."Evaluation Type"::"Final Moment");
                if Rec."Option Type" = Rec."Option Type"::"Option Group" then begin
                    l_FinalAssessingStudents.SetRange("Evaluation Type", l_FinalAssessingStudents."Evaluation Type"::"Final Moment Group");
                    l_FinalAssessingStudents.SetRange("Option Group", Rec."Subject Code");
                end;
            end;
            if vArrayType[inIndex] = vArrayType[inIndex] ::"Final Year" then begin
                if Rec."Option Type" = Rec."Option Type"::"Schooling Year" then begin
                    l_FinalAssessingStudents.SetRange("Evaluation Type", l_FinalAssessingStudents."Evaluation Type"::"Final Year");
                    l_FinalAssessingStudents.SetRange(Subject, Rec."Subject Code");
                    l_FinalAssessingStudents.SetRange("Sub-Subject Code", Rec."Sub-Subject Code");
                end;
                if Rec."Option Type" = Rec."Option Type"::"Option Group" then begin
                    l_FinalAssessingStudents.SetRange("Evaluation Type", l_FinalAssessingStudents."Evaluation Type"::"Final Year Group");
                    l_FinalAssessingStudents.SetRange("Option Group", Rec."Subject Code");
                end;
            end;
            if VarFinalType[inIndex] = VarFinalType[inIndex] ::"Final Cycle" then begin
                l_FinalAssessingStudents.SetRange("Evaluation Type", l_FinalAssessingStudents."Evaluation Type"::"Final Cycle");
                if Rec."Option Type" = Rec."Option Type"::Subjects then begin
                    l_FinalAssessingStudents.SetRange(Subject, Rec."Subject Code");
                end;
            end;
            if VarFinalType[inIndex] = VarFinalType[inIndex] ::"Final Stage" then begin
                l_FinalAssessingStudents.SetRange("Evaluation Type", l_FinalAssessingStudents."Evaluation Type"::"Final Stage");
                if Rec."Option Type" = Rec."Option Type"::Subjects then begin
                    l_FinalAssessingStudents.SetRange(Subject, Rec."Subject Code");
                end;
            end;

            if l_FinalAssessingStudents.FindFirst then begin
                if vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::Quantitative then
                    Evaluate(l_FinalAssessingStudents.Grade, inText);

                if (vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::Qualitative) then
                    l_FinalAssessingStudents."Qualitative Grade" := inText;

                if (vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::"Mixed-Qualification") then begin
                    if varMixedClassification then begin
                        l_FinalAssessingStudents."Qualitative Grade" := varClassification;
                        if inText <> '' then
                            Evaluate(l_FinalAssessingStudents.Grade, inText)
                        else
                            l_FinalAssessingStudents.Grade := 0;
                    end else begin
                        if not Evaluate(l_FinalAssessingStudents."Manual Grade", varClassification) then
                            l_FinalAssessingStudents.Grade := 0;
                        l_FinalAssessingStudents."Qualitative Grade" := inText;
                    end;
                end;
                l_FinalAssessingStudents.Modify;
            end else begin

                ////Moment Options
                //,Interim,Final Moment,Test,Others,Final Year,CIF,EXN1,EXN2,CFD
                ////Evaluation Type Options
                //Final Year,Final Year Group,Final Moment,Final Moment Group,Final Cycle,Final Stage
                l_FinalAssessingStudents.Init;

                if (Rec."Option Type" = Rec."Option Type"::"Option Group") and (vArrayType[inIndex] = vArrayType[inIndex] ::"Final Moment") then
                    l_FinalAssessingStudents."Evaluation Type" := l_FinalAssessingStudents."Evaluation Type"::"Final Moment Group";
                if (Rec."Option Type" = Rec."Option Type"::"Option Group") and (vArrayType[inIndex] = vArrayType[inIndex] ::"Final Year") then
                    l_FinalAssessingStudents."Evaluation Type" := l_FinalAssessingStudents."Evaluation Type"::"Final Year Group";

                if (Rec."Option Type" = Rec."Option Type"::"Schooling Year") and (vArrayType[inIndex] = vArrayType[inIndex] ::"Final Moment") then
                    l_FinalAssessingStudents."Evaluation Type" := l_FinalAssessingStudents."Evaluation Type"::"Final Moment";
                if (Rec."Option Type" = Rec."Option Type"::"Schooling Year") and (vArrayType[inIndex] = vArrayType[inIndex] ::"Final Year") then
                    l_FinalAssessingStudents."Evaluation Type" := l_FinalAssessingStudents."Evaluation Type"::"Final Year";

                if VarFinalType[inIndex] = VarFinalType[inIndex] ::"Final Cycle" then begin
                    l_FinalAssessingStudents."Evaluation Type" := l_FinalAssessingStudents."Evaluation Type"::"Final Cycle";
                end;
                if VarFinalType[inIndex] = VarFinalType[inIndex] ::"Final Stage" then begin
                    l_FinalAssessingStudents."Evaluation Type" := l_FinalAssessingStudents."Evaluation Type"::"Final Stage";
                end;

                l_FinalAssessingStudents."School Year" := varSchoolYear;
                l_FinalAssessingStudents."Schooling Year" := varSchoolingYear;
                if VarFinalType[inIndex] = VarFinalType[inIndex] ::" " then
                    l_FinalAssessingStudents."Moment Code" := vArrayCodMomento[inIndex];

                if Rec."Option Type" = Rec."Option Type"::"Option Group" then
                    l_FinalAssessingStudents."Option Group" := Rec."Subject Code"
                else
                    l_FinalAssessingStudents."Option Group" := '';

                if Rec."Option Type" = Rec."Option Type"::"Schooling Year" then
                    l_FinalAssessingStudents.Subject := '';

                if (VarFinalType[inIndex] <> VarFinalType[inIndex] ::" ") and
                   (Rec."Option Type" = Rec."Option Type"::Subjects) then
                    l_FinalAssessingStudents.Subject := Rec."Subject Code"
                else
                    l_FinalAssessingStudents.Subject := '';

                l_FinalAssessingStudents."Sub-Subject Code" := '';
                l_FinalAssessingStudents."Study Plan Code" := varCourseCode;
                l_FinalAssessingStudents."Student Code No." := Rec."Student Code No.";
                l_FinalAssessingStudents."Evaluation Moment" := vArrayType[inIndex];
                if not Evaluate(l_FinalAssessingStudents.Grade, inText) then
                    l_FinalAssessingStudents.Grade := 0;

                if (l_FinalAssessingStudents."Evaluation Type" = l_FinalAssessingStudents."Evaluation Type"::"Final Moment Group")
                 or (l_FinalAssessingStudents."Evaluation Type" = l_FinalAssessingStudents."Evaluation Type"::"Final Year Group") then begin
                    if VarType = 1 then begin
                        l_OptionGroup.Reset;
                        l_OptionGroup.SetRange(Code, l_FinalAssessingStudents."Option Group");
                        l_OptionGroup.SetRange("Schooling Year", '');
                        if l_OptionGroup.FindFirst then;
                    end;
                    if VarType = 0 then
                        if l_OptionGroup.Get(l_FinalAssessingStudents."Option Group", varSchoolingYear) then;

                    if vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::Quantitative then
                        Evaluate(l_FinalAssessingStudents.Grade, inText);

                    if (vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::Qualitative) then
                        l_FinalAssessingStudents."Qualitative Grade" := inText;

                    if (vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::"Mixed-Qualification") then begin

                        if varMixedClassification then begin
                            l_FinalAssessingStudents."Qualitative Grade" := varClassification;
                            Evaluate(l_FinalAssessingStudents.Grade, inText);
                        end else begin
                            if not Evaluate(l_FinalAssessingStudents.Grade, varClassification) then
                                l_FinalAssessingStudents.Grade := 0;
                            l_FinalAssessingStudents."Qualitative Grade" := inText;
                        end;
                    end;
                end;

                l_FinalAssessingStudents."Type Education" := VarType;
                l_FinalAssessingStudents."Country/Region Code" := rStudents."Country/Region Code";

                if (l_FinalAssessingStudents."Evaluation Type" = l_FinalAssessingStudents."Evaluation Type"::"Final Moment") or
                  (l_FinalAssessingStudents."Evaluation Type" = l_FinalAssessingStudents."Evaluation Type"::"Final Year") or
                  (VarFinalType[inIndex] <> VarFinalType[inIndex] ::" ") then begin

                    if vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::Quantitative then
                        Evaluate(l_FinalAssessingStudents.Grade, inText);

                    if (vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::Qualitative) then
                        l_FinalAssessingStudents."Qualitative Grade" := inText;

                    if (vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::"Mixed-Qualification") then begin
                        if varMixedClassification then begin
                            l_FinalAssessingStudents."Qualitative Grade" := varClassification;
                            Evaluate(l_FinalAssessingStudents.Grade, inText);
                        end else begin
                            if not Evaluate(l_FinalAssessingStudents.Grade, varClassification) then
                                l_FinalAssessingStudents.Grade := 0;
                            l_FinalAssessingStudents."Qualitative Grade" := inText;
                        end;
                    end;
                end;

                if not l_FinalAssessingStudents.Insert(true) then
                    l_FinalAssessingStudents.Modify(true);
            end;
        end else begin
            rAssessingStudents.Reset;
            rAssessingStudents.SetRange("School Year", varSchoolYear);
            rAssessingStudents.SetRange("Schooling Year", varSchoolingYear);
            rAssessingStudents.SetRange(Subject, Rec."Subject Code");
            rAssessingStudents.SetRange("Sub-Subject Code", '');
            rAssessingStudents.SetRange("Student Code No.", varStudent);
            rAssessingStudents.SetRange("Moment Code", vArrayCodMomento[inIndex]);
            if rAssessingStudents.Find('-') then begin
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
                rAssessingStudents."School Year" := varSchoolYear;
                rAssessingStudents."Schooling Year" := varSchoolingYear;
                rAssessingStudents.Subject := Rec."Subject Code";
                rAssessingStudents."Study Plan Code" := varCourseCode;
                rAssessingStudents."Student Code No." := varStudent;
                rAssessingStudents."Moment Code" := vArrayCodMomento[inIndex];
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
        l_FinalAssessingStudents: Record "Assessing Students Final";
    begin
        GetRegistrationAproved(false);
        GetTypeAssessment(inIndex);
        if (Rec."Option Type" = Rec."Option Type"::"Option Group") or (Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
          ((Rec."Option Type" = Rec."Option Type"::Subjects) and (VarFinalType[inIndex] <> VarFinalType[inIndex] ::" ")) then begin

            if (Rec."Option Type" = Rec."Option Type"::"Option Group") and (vArrayType[inIndex] = vArrayType[inIndex] ::" ") then
                exit('');

            l_FinalAssessingStudents.Reset;
            l_FinalAssessingStudents.SetRange(Class, Rec.Class);
            l_FinalAssessingStudents.SetRange("School Year", varSchoolYear);
            l_FinalAssessingStudents.SetRange("Student Code No.", Rec."Student Code No.");
            l_FinalAssessingStudents.SetRange("Evaluation Moment", vArrayType[inIndex]);

            if (vArrayType[inIndex] = vArrayType[inIndex] ::"Final Moment") or
              (vArrayType[inIndex] = vArrayType[inIndex] ::Interim) then begin

                if Rec."Option Type" = Rec."Option Type"::"Schooling Year" then
                    l_FinalAssessingStudents.SetRange("Evaluation Type", l_FinalAssessingStudents."Evaluation Type"::"Final Moment");
                if Rec."Option Type" = Rec."Option Type"::"Option Group" then begin
                    l_FinalAssessingStudents.SetRange("Evaluation Type", l_FinalAssessingStudents."Evaluation Type"::"Final Moment Group");
                    l_FinalAssessingStudents.SetRange("Option Group", Rec."Subject Code");
                end;
                l_FinalAssessingStudents.SetRange("Moment Code", vArrayCodMomento[inIndex]);
            end;

            if (vArrayType[inIndex] = vArrayType[inIndex] ::"Final Year") then begin
                if Rec."Option Type" = Rec."Option Type"::"Schooling Year" then begin
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

            if Rec."Option Type" = Rec."Option Type"::"Schooling Year" then begin
                if VarFinalType[inIndex] = VarFinalType[inIndex] ::"Final Stage" then begin
                    l_FinalAssessingStudents.SetRange("Evaluation Type", l_FinalAssessingStudents."Evaluation Type"::"Final Stage");
                    l_FinalAssessingStudents.SetRange("Schooling Year", vArrayCodMomento[inIndex]);
                end;
                if VarFinalType[inIndex] = VarFinalType[inIndex] ::"Final Cycle" then begin
                    l_FinalAssessingStudents.SetRange("Evaluation Type", l_FinalAssessingStudents."Evaluation Type"::"Final Cycle");
                    l_FinalAssessingStudents.SetRange("Schooling Year", vArrayCodMomento[inIndex]);
                end;
            end;

            if Rec."Option Type" = Rec."Option Type"::Subjects then begin
                if VarFinalType[inIndex] = VarFinalType[inIndex] ::"Final Stage" then begin
                    l_FinalAssessingStudents.SetRange("Evaluation Type", l_FinalAssessingStudents."Evaluation Type"::"Final Stage");
                    l_FinalAssessingStudents.SetRange("Schooling Year", vArrayCodMomento[inIndex]);
                    l_FinalAssessingStudents.SetRange(Subject, Rec."Subject Code");
                end;
                if VarFinalType[inIndex] = VarFinalType[inIndex] ::"Final Cycle" then begin
                    l_FinalAssessingStudents.SetRange("Evaluation Type", l_FinalAssessingStudents."Evaluation Type"::"Final Cycle");
                    l_FinalAssessingStudents.SetRange("Schooling Year", vArrayCodMomento[inIndex]);
                    l_FinalAssessingStudents.SetRange(Subject, Rec."Subject Code");
                end;
            end;

            if l_FinalAssessingStudents.FindFirst then begin
                if varMixedClassification then begin
                    if l_FinalAssessingStudents.Grade <> 0 then
                        exit(Format(l_FinalAssessingStudents.Grade));
                end
                else begin
                    if l_FinalAssessingStudents."Qualitative Grade" <> '' then
                        exit(l_FinalAssessingStudents."Qualitative Grade");
                end;
            end else
                exit('');
        end;
        if (Rec."Option Type" = Rec."Option Type"::Subjects) or (Rec."Option Type" = Rec."Option Type"::"Sub-Subjects") then begin
            rAssessingStudents.Reset;
            rAssessingStudents.SetFilter(Class, Rec.Class);
            rAssessingStudents.SetFilter("School Year", varSchoolYear);
            rAssessingStudents.SetFilter("Schooling Year", Rec."Schooling Year");
            rAssessingStudents.SetFilter(Subject, Rec."Subject Code");
            rAssessingStudents.SetFilter("Sub-Subject Code", Rec."Sub-Subject Code");
            rAssessingStudents.SetFilter("Student Code No.", Rec."Student Code No.");
            rAssessingStudents.SetFilter("Moment Code", vArrayCodMomento[inIndex]);
            if rAssessingStudents.FindFirst then begin
                if (rAssessingStudents."Qualitative Grade" <> '') and (rAssessingStudents.Grade <> 0) then begin
                    if varMixedClassification then
                        if (rAssessingStudents."Recuperation Qualitative Grade" <> '') and (rAssessingStudents."Recuperation Grade" <> 0) then
                            exit(Format(rAssessingStudents."Recuperation Grade"))
                        else
                            exit(Format(rAssessingStudents.Grade))
                    else
                        if (rAssessingStudents."Recuperation Qualitative Grade" <> '') and (rAssessingStudents."Recuperation Grade" <> 0) then
                            exit(rAssessingStudents."Recuperation Qualitative Grade")
                        else
                            exit(rAssessingStudents."Qualitative Grade");
                end;
                if (rAssessingStudents."Qualitative Grade" <> '') and (rAssessingStudents.Grade = 0) then begin
                    if (rAssessingStudents."Recuperation Qualitative Grade" <> '') and (rAssessingStudents."Recuperation Grade" = 0) then
                        exit(rAssessingStudents."Recuperation Qualitative Grade")
                    else
                        exit(rAssessingStudents."Qualitative Grade");
                end;
                if (rAssessingStudents."Qualitative Grade" = '') and (rAssessingStudents.Grade <> 0) then begin
                    if (rAssessingStudents."Recuperation Qualitative Grade" = '') and (rAssessingStudents."Recuperation Grade" <> 0) then
                        exit(Format(rAssessingStudents."Recuperation Grade"))
                    else
                        exit(Format(rAssessingStudents.Grade));
                end;
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
    procedure ValidateAssessmentMixed2(InCode: Text[250]; InClassification: Decimal) Out: Text[30]
    var
        varLocalClasification: Decimal;
        rClassificationLevelMin: Record "Classification Level";
        rClassificationLevelMax: Record "Classification Level";
        VarMinValue: Decimal;
        VarMaxValue: Decimal;
        rClassificationLevel: Record "Classification Level";
    begin
        Clear(varClassification);
        if InCode <> '' then begin
            varLocalClasification := InClassification;
            if varLocalClasification <> 0 then begin
                rClassificationLevelMin.Reset;
                rClassificationLevelMin.SetCurrentKey("Id Ordination");
                rClassificationLevelMin.Ascending(true);
                rClassificationLevelMin.SetRange("Classification Group Code", InCode);
                if rClassificationLevelMin.Find('-') then
                    VarMinValue := rClassificationLevelMin."Min Value";

                rClassificationLevelMax.Reset;
                rClassificationLevelMax.SetCurrentKey("Id Ordination");
                rClassificationLevelMax.Ascending(false);
                rClassificationLevelMax.SetRange("Classification Group Code", InCode);
                if rClassificationLevelMax.Find('-') then
                    VarMaxValue := rClassificationLevelMax."Max Value";

                if (VarMinValue <= varLocalClasification) and
                  (VarMaxValue >= varLocalClasification) then begin
                    rClassificationLevel.Reset;
                    rClassificationLevel.SetRange("Classification Group Code", InCode);
                    rClassificationLevel.SetRange(Value, varLocalClasification);
                    if rClassificationLevel.FindSet(false, false) then begin
                        if varMixedClassification then begin
                            varClassification := rClassificationLevel."Classification Level Code";
                            exit(Format(varLocalClasification));
                        end else begin
                            varClassification := Format(varLocalClasification);
                            exit(rClassificationLevel."Classification Level Code");
                        end;
                    end;

                    rClassificationLevel.Reset;
                    rClassificationLevel.SetRange("Classification Group Code", InCode);
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
        end;
    end;

    //[Scope('OnPrem')]
    procedure GetNoStructureCountry(pSchoolingYear: Code[20]): Integer
    var
        rStruEduCountry: Record "Structure Education Country";
        rClass: Record Class;
        cStudentsRegistration: Codeunit "Students Registration";
    begin
        rStruEduCountry.Reset;
        rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
        rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
        if rStruEduCountry.Find('-') then begin
            repeat
                if pSchoolingYear = rStruEduCountry."Schooling Year" then
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
        l_Class: Record Class;
    begin
        ExitValue := false;
        if l_Class.Get(Rec.Class, varSchoolYear) then;
        if (Rec."Option Type" = Rec."Option Type"::Subjects) or (Rec."Option Type" = Rec."Option Type"::"Sub-Subjects") then begin
            if IsGlobal = false then begin
                l_rRemarks.Reset;
                l_rRemarks.SetRange(Class, Rec.Class);
                l_rRemarks.SetRange("School Year", varSchoolYear);
                l_rRemarks.SetRange("Schooling Year", Rec."Schooling Year");
                l_rRemarks.SetRange("Student/Teacher Code No.", Rec."Student Code No.");
                l_rRemarks.SetRange("Study Plan Code", l_Class."Study Plan Code");
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
            l_rRemarks.SetRange(Class, Rec.Class);
            l_rRemarks.SetRange("School Year", varSchoolYear);
            l_rRemarks.SetRange("Schooling Year", Rec."Schooling Year");
            l_rRemarks.SetRange("Student/Teacher Code No.", Rec."Student Code No.");
            l_rRemarks.SetRange("Moment Code", l_CodMoment);
            l_rRemarks.SetRange("Study Plan Code", l_Class."Study Plan Code");
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
        if (varClass = '') or (varSubject = '') then
            Error(Text0001);

        DeleteBuffer;

        //Get the active school year
        //**********************
        rMomentsAssess.Reset;
        rMomentsAssess.SetRange(rMomentsAssess."Responsibility Center", varRespCenter);
        rMomentsAssess.SetRange(rMomentsAssess."School Year", varSchoolYear);
        rMomentsAssess.SetRange(rMomentsAssess."Schooling Year", varSchoolingYear);
        rMomentsAssess.SetRange(rMomentsAssess.Active, true);
        if rMomentsAssess.FindFirst then begin
            varMomento := rMomentsAssess."Moment Code";
            varMomentDataEnd := rMomentsAssess."End Date";
        end;

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
                    if (rStudentSubjEntry.Find('+')) and (rStudentSubjEntry.Status = rStudentSubjEntry.Status::Subscribed) then begin
                        repeat

                            ////insert Student
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

                            ////insert Sub-Subjects
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
        LastOptionGroup: Code[20];
    begin
        DeleteBuffer;

        VarlineNo := 0;
        if VarType = VarType::Simple then begin
            BufferAssignAssessments.Reset;
            BufferAssignAssessments.SetRange("User ID", UserId);
            BufferAssignAssessments.SetRange("Student Code No.", varStudent);
            BufferAssignAssessments.SetRange("Option Type", BufferAssignAssessments."Option Type"::"Schooling Year");
            BufferAssignAssessments.SetRange("Schooling Year", varSchoolingYear);
            if not BufferAssignAssessments.FindFirst then begin

                rStudents.Get(varStudent);

                BufferAssignAssessments.Init;
                BufferAssignAssessments."User ID" := UserId;
                VarlineNo += 10000;
                BufferAssignAssessments."Line No." := VarlineNo;
                BufferAssignAssessments."Student Code No." := varStudent;
                BufferAssignAssessments.Level := 1;
                BufferAssignAssessments.Text := varSchoolingYear + ' - ' + rStudents.Name;
                BufferAssignAssessments."Option Type" := BufferAssignAssessments."Option Type"::"Schooling Year";
                BufferAssignAssessments."Schooling Year" := varSchoolingYear;
                BufferAssignAssessments.Insert;
            end;

            rStudyPlanLines.Reset;
            rStudyPlanLines.SetRange(Code, varCourseCode);
            rStudyPlanLines.SetCurrentKey("Option Group");
            if rStudyPlanLines.FindSet then begin
                repeat
                    if rStudyPlanLines."Option Group" = '' then begin
                        BufferAssignAssessments.Reset;
                        BufferAssignAssessments.Init;
                        BufferAssignAssessments."User ID" := UserId;
                        VarlineNo += 10000;
                        BufferAssignAssessments."Line No." := VarlineNo;
                        BufferAssignAssessments."Student Code No." := varStudent;
                        BufferAssignAssessments."Subject Code" := rStudyPlanLines."Subject Code";
                        BufferAssignAssessments.Text := rStudyPlanLines."Subject Description";
                        BufferAssignAssessments.Level := 2;
                        BufferAssignAssessments."Option Type" := BufferAssignAssessments."Option Type"::Subjects;
                        BufferAssignAssessments."Schooling Year" := varSchoolingYear;
                        BufferAssignAssessments.Insert;

                    end else begin
                        if LastOptionGroup <> rStudyPlanLines."Option Group" then begin
                            BufferAssignAssessments.Init;
                            BufferAssignAssessments."User ID" := UserId;
                            VarlineNo += 10000;
                            BufferAssignAssessments."Line No." := VarlineNo;
                            BufferAssignAssessments."Student Code No." := varStudent;
                            BufferAssignAssessments."Subject Code" := rStudyPlanLines."Option Group";
                            l_GroupSubjects.Reset;
                            l_GroupSubjects.SetRange(Code, rStudyPlanLines."Option Group");
                            l_GroupSubjects.SetRange("Schooling Year", varSchoolingYear);
                            if l_GroupSubjects.FindFirst then
                                BufferAssignAssessments.Text := l_GroupSubjects.Description;
                            BufferAssignAssessments.Level := 2;
                            BufferAssignAssessments."Option Type" := BufferAssignAssessments."Option Type"::"Option Group";
                            BufferAssignAssessments."Schooling Year" := varSchoolingYear;
                            BufferAssignAssessments.Insert;
                        end;

                        BufferAssignAssessments.Reset;
                        BufferAssignAssessments.Init;
                        BufferAssignAssessments."User ID" := UserId;
                        VarlineNo += 10000;
                        BufferAssignAssessments."Line No." := VarlineNo;
                        BufferAssignAssessments."Student Code No." := varStudent;
                        BufferAssignAssessments."Subject Code" := rStudyPlanLines."Subject Code";
                        BufferAssignAssessments.Text := rStudyPlanLines."Subject Description";
                        BufferAssignAssessments.Level := 3;
                        BufferAssignAssessments."Option Type" := BufferAssignAssessments."Option Type"::Subjects;
                        BufferAssignAssessments."Schooling Year" := varSchoolingYear;
                        BufferAssignAssessments.Insert;

                    end;
                    LastOptionGroup := rStudyPlanLines."Option Group";
                until rStudyPlanLines.Next = 0;
            end;
        end else begin
            rCourseLinesTEMP.DeleteAll;

            //Quadriennal
            rCourseLines.Reset;
            rCourseLines.SetRange(Code, varCourseCode);
            rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Quadriennal);
            if rCourseLines.Find('-') then begin
                repeat
                    rCourseLinesTEMP.Init;
                    rCourseLinesTEMP.TransferFields(rCourseLines);
                    rCourseLinesTEMP."Temp School Year" := varSchoolYear;
                    rCourseLinesTEMP.Insert;
                until rCourseLines.Next = 0;
            end;

            //Anual
            rCourseLines.Reset;
            rCourseLines.SetRange(Code, varCourseCode);
            rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Annual);
            rCourseLines.SetRange("Schooling Year Begin", varSchoolingYear);
            if rCourseLines.Find('-') then begin
                repeat
                    rCourseLinesTEMP.Init;
                    rCourseLinesTEMP.TransferFields(rCourseLines);
                    rCourseLinesTEMP."Temp School Year" := varSchoolYear;
                    rCourseLinesTEMP.Insert;
                until rCourseLines.Next = 0;
            end;

            //Bienal E Triennal
            rStruEduCountry.Reset;
            rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
            rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
            rStruEduCountry.SetRange("Schooling Year", varSchoolingYear);
            if rStruEduCountry.Find('-') then begin
                rCourseLines.Reset;
                rCourseLines.SetRange(Code, varCourseCode);
                rCourseLines.SetFilter("Characterise Subjects", '%1|%2', rCourseLines."Characterise Subjects"::Biennial,
                rCourseLines."Characterise Subjects"::Triennial);
                rCourseLines.SetRange("Schooling Year Begin", varSchoolingYear);
                if rCourseLines.Find('-') then begin
                    repeat
                        rCourseLinesTEMP.Init;
                        rCourseLinesTEMP.TransferFields(rCourseLines);
                        rCourseLinesTEMP."Temp School Year" := varSchoolYear;
                        rCourseLinesTEMP.Insert;
                    until rCourseLines.Next = 0;
                end;
                l_rStruEduCountry.Reset;
                l_rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
                l_rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
                l_rStruEduCountry.SetRange("Sorting ID", GetNoStructureCountry(varSchoolingYear) - 1);
                if l_rStruEduCountry.Find('-') then begin
                    rCourseLines.Reset;
                    rCourseLines.SetRange(Code, varCourseCode);
                    rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Biennial);
                    rCourseLines.SetRange("Schooling Year Begin", l_rStruEduCountry."Schooling Year");
                    if rCourseLines.Find('-') then begin
                        repeat
                            rCourseLinesTEMP.Init;
                            rCourseLinesTEMP.TransferFields(rCourseLines);
                            rCourseLinesTEMP."Temp School Year" := varSchoolYear;
                            rCourseLinesTEMP.Insert;
                        until rCourseLines.Next = 0;
                    end;
                end;
                l_rStruEduCountry.Reset;
                l_rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
                l_rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
                l_rStruEduCountry.SetRange("Sorting ID", GetNoStructureCountry(varSchoolingYear) - 2);
                if l_rStruEduCountry.Find('-') then begin
                    rCourseLines.Reset;
                    rCourseLines.SetRange(Code, varCourseCode);
                    rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Triennial);
                    rCourseLines.SetRange("Schooling Year Begin", l_rStruEduCountry."Schooling Year");
                    if rCourseLines.Find('-') then begin
                        repeat
                            rCourseLinesTEMP.Init;
                            rCourseLinesTEMP.TransferFields(rCourseLines);
                            rCourseLinesTEMP."Temp School Year" := varSchoolYear;
                            rCourseLinesTEMP.Insert;
                        until rCourseLines.Next = 0;
                    end;
                end;
                l_rStruEduCountry.Reset;
                l_rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
                l_rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
                l_rStruEduCountry.SetRange("Sorting ID", GetNoStructureCountry(varSchoolingYear) - 1);
                if l_rStruEduCountry.Find('-') then begin
                    rCourseLines.Reset;
                    rCourseLines.SetRange(Code, varCourseCode);
                    rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Triennial);
                    rCourseLines.SetRange("Schooling Year Begin", l_rStruEduCountry."Schooling Year");
                    if rCourseLines.Find('-') then begin
                        repeat
                            rCourseLinesTEMP.Init;
                            rCourseLinesTEMP.TransferFields(rCourseLines);
                            rCourseLinesTEMP."Temp School Year" := varSchoolYear;
                            rCourseLinesTEMP.Insert;
                        until rCourseLines.Next = 0;
                    end;
                end;
            end;

            rCourseLinesTEMP.Reset;
            rCourseLinesTEMP.SetCurrentKey("Option Group");
            if rCourseLinesTEMP.FindSet then begin
                BufferAssignAssessments.Reset;
                BufferAssignAssessments.SetRange("User ID", UserId);
                BufferAssignAssessments.SetRange("Student Code No.", varStudent);
                BufferAssignAssessments.SetRange("Option Type", BufferAssignAssessments."Option Type"::"Schooling Year");
                BufferAssignAssessments.SetRange("Schooling Year", varSchoolingYear);
                if not BufferAssignAssessments.FindFirst then begin
                    rStudents.Get(varStudent);

                    BufferAssignAssessments.Init;
                    BufferAssignAssessments."User ID" := UserId;
                    VarlineNo += 10000;
                    BufferAssignAssessments."Line No." := VarlineNo;
                    BufferAssignAssessments."Student Code No." := varStudent;
                    BufferAssignAssessments.Level := 1;
                    BufferAssignAssessments.Text := varSchoolingYear + ' - ' + rStudents.Name;
                    BufferAssignAssessments."Option Type" := BufferAssignAssessments."Option Type"::"Schooling Year";
                    BufferAssignAssessments."Schooling Year" := varSchoolingYear;
                    BufferAssignAssessments.Insert;
                end;

                repeat
                    if rCourseLinesTEMP."Option Group" = '' then begin
                        BufferAssignAssessments.Reset;
                        BufferAssignAssessments.Init;
                        BufferAssignAssessments."User ID" := UserId;
                        VarlineNo += 10000;
                        BufferAssignAssessments."Line No." := VarlineNo;
                        BufferAssignAssessments."Student Code No." := varStudent;
                        BufferAssignAssessments."Subject Code" := rCourseLinesTEMP."Subject Code";
                        BufferAssignAssessments.Text := rCourseLinesTEMP."Subject Description";
                        BufferAssignAssessments.Level := 2;
                        BufferAssignAssessments."Option Type" := BufferAssignAssessments."Option Type"::Subjects;
                        BufferAssignAssessments."Schooling Year" := varSchoolingYear;
                        BufferAssignAssessments.Insert;

                    end else begin
                        if LastOptionGroup <> rCourseLinesTEMP."Option Group" then begin
                            BufferAssignAssessments.Init;
                            BufferAssignAssessments."User ID" := UserId;
                            VarlineNo += 10000;
                            BufferAssignAssessments."Line No." := VarlineNo;
                            BufferAssignAssessments."Student Code No." := varStudent;
                            BufferAssignAssessments."Subject Code" := rCourseLinesTEMP."Option Group";
                            l_GroupSubjects.Reset;
                            l_GroupSubjects.SetRange(Code, rCourseLinesTEMP."Option Group");
                            l_GroupSubjects.SetRange("Schooling Year", varSchoolingYear);
                            if l_GroupSubjects.FindFirst then
                                BufferAssignAssessments.Text := l_GroupSubjects.Description;
                            BufferAssignAssessments.Level := 2;
                            BufferAssignAssessments."Option Type" := BufferAssignAssessments."Option Type"::"Option Group";
                            BufferAssignAssessments."Schooling Year" := varSchoolingYear;
                            BufferAssignAssessments.Insert;
                        end;

                        BufferAssignAssessments.Reset;
                        BufferAssignAssessments.Init;
                        BufferAssignAssessments."User ID" := UserId;
                        VarlineNo += 10000;
                        BufferAssignAssessments."Line No." := VarlineNo;
                        BufferAssignAssessments."Student Code No." := varStudent;
                        BufferAssignAssessments."Subject Code" := rCourseLinesTEMP."Subject Code";
                        BufferAssignAssessments.Text := rCourseLinesTEMP."Subject Description";
                        BufferAssignAssessments.Level := 3;
                        BufferAssignAssessments."Option Type" := BufferAssignAssessments."Option Type"::Subjects;
                        BufferAssignAssessments."Schooling Year" := varSchoolingYear;
                        BufferAssignAssessments.Insert;
                    end;
                    LastOptionGroup := rCourseLinesTEMP."Option Group";
                until rCourseLinesTEMP.Next = 0;
            end;
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
                l_Registration."Actual Status" := varTransitionStatus;
                l_Registration.Modify;
            end;
        end;
        if pInsert = false then begin
            if Rec."Option Type" = Rec."Option Type"::"Schooling Year" then begin
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
    procedure ValidateActualStatus()
    var
        lMomentsAssessment: Record "Moments Assessment";
        l_AssStudentFinal: Record "Assessing Students Final";
    begin
        lMomentsAssessment.Reset;
        lMomentsAssessment.SetRange("Moment Code", varActiveMoment);
        lMomentsAssessment.SetRange("School Year", varSchoolYear);
        lMomentsAssessment.SetRange("Schooling Year", varSchoolingYear);
        lMomentsAssessment.SetRange(Active, true);
        lMomentsAssessment.SetRange("Evaluation Moment", lMomentsAssessment."Evaluation Moment"::"Final Year");
        if lMomentsAssessment.FindFirst then begin
            l_AssStudentFinal.Reset;
            l_AssStudentFinal.SetRange("School Year", varSchoolYear);
            l_AssStudentFinal.SetRange("Schooling Year", varSchoolingYear);
            l_AssStudentFinal.SetRange(Class, varClass);
            l_AssStudentFinal.SetFilter("Evaluation Type", '%1|%2', l_AssStudentFinal."Evaluation Type"::"Final Year",
            l_AssStudentFinal."Evaluation Type"::"Final Year Group");
            if l_AssStudentFinal.FindFirst then
                ActualStatusVisible := true
            else
                ActualStatusVisible := false;
        end else
            ActualStatusVisible := false;
    end;

    //[Scope('OnPrem')]
    procedure GetInfo(pSchoolYear: Code[9]; pStudentCode: Code[20])
    begin
        varSchoolYear := pSchoolYear;
        varStudent := pStudentCode;
    end;

    //[Scope('OnPrem')]
    procedure GetInfo2(pSchoolingYear: Code[20]; pCourseCode: Code[20])
    begin
        varSchoolingYear := pSchoolingYear;
        varCourseCode := pCourseCode;
        GetType;
    end;

    //[Scope('OnPrem')]
    procedure InsertTerms(pBook: Text[10]; pSheet: Text[10])
    var
        l_AssessingStudents: Record "Assessing Students";
    begin
        rMomentsAssessment.Reset;
        rMomentsAssessment.SetRange("School Year", varSchoolYear);
        rMomentsAssessment.SetRange("Schooling Year", Rec."Schooling Year");
        rMomentsAssessment.SetRange("Responsibility Center", varRespCenter);
        rMomentsAssessment.SetRange(rMomentsAssessment."Evaluation Moment", rMomentsAssessment."Evaluation Moment"::CFD);
        if rMomentsAssessment.FindFirst then begin
            l_AssessingStudents.Reset;
            l_AssessingStudents.SetFilter(Class, Rec.Class);
            l_AssessingStudents.SetFilter("School Year", varSchoolYear);
            l_AssessingStudents.SetFilter("Schooling Year", Rec."Schooling Year");
            l_AssessingStudents.SetFilter(Subject, Rec."Subject Code");
            l_AssessingStudents.SetFilter("Sub-Subject Code", Rec."Sub-Subject Code");
            l_AssessingStudents.SetFilter("Student Code No.", Rec."Student Code No.");
            l_AssessingStudents.SetFilter("Moment Code", rMomentsAssessment."Moment Code");
            if l_AssessingStudents.FindFirst then begin
                l_AssessingStudents."Term Book" := pBook;
                l_AssessingStudents."Term Sheet" := pSheet;
                l_AssessingStudents.Modify;
            end else
                Error(Text0019);
        end else
            Error(Text0018);
    end;

    //[Scope('OnPrem')]
    procedure GetTerms(var pBookTerms: Text[10]; var pSheetTerms: Text[10])
    var
        rAssessingStudents: Record "Assessing Students";
        l_FinalAssessingStudents: Record "Assessing Students Final";
    begin
        if Rec."Option Type" = Rec."Option Type"::Subjects then begin
            rMomentsAssessment.Reset;
            rMomentsAssessment.SetRange("School Year", varSchoolYear);
            rMomentsAssessment.SetRange("Schooling Year", Rec."Schooling Year");
            rMomentsAssessment.SetRange("Responsibility Center", varRespCenter);
            rMomentsAssessment.SetRange(rMomentsAssessment."Evaluation Moment", rMomentsAssessment."Evaluation Moment"::CFD);
            if rMomentsAssessment.FindFirst then begin

                rAssessingStudents.Reset;
                rAssessingStudents.SetFilter(Class, Rec.Class);
                rAssessingStudents.SetFilter("School Year", varSchoolYear);
                rAssessingStudents.SetFilter("Schooling Year", Rec."Schooling Year");
                rAssessingStudents.SetFilter(Subject, Rec."Subject Code");
                rAssessingStudents.SetFilter("Sub-Subject Code", Rec."Sub-Subject Code");
                rAssessingStudents.SetFilter("Student Code No.", Rec."Student Code No.");
                rAssessingStudents.SetFilter("Moment Code", rMomentsAssessment."Moment Code");
                if rAssessingStudents.FindFirst then begin
                    pBookTerms := rAssessingStudents."Term Book";
                    pSheetTerms := rAssessingStudents."Term Sheet";
                end else begin
                    pBookTerms := '';
                    pSheetTerms := '';
                end;
            end;
        end else begin
            pBookTerms := '';
            pSheetTerms := '';
        end;
    end;

    //[Scope('OnPrem')]
    procedure GetType()
    begin
        rStruEduCountry.Reset;
        rStruEduCountry.SetRange("Schooling Year", varSchoolingYear);
        if rStruEduCountry.FindFirst then
            VarType := rStruEduCountry.Type;
    end;

    //[Scope('OnPrem')]
    procedure GetAssessmentEvaluation(pAssessingStudentsFinal: Record "Assessing Students Final") out: Text[50]
    var
        l_AssessConf: Record "Assessment Configuration";
    begin
        l_AssessConf.Reset;
        l_AssessConf.SetRange("School Year", pAssessingStudentsFinal."School Year");
        l_AssessConf.SetRange(Type, pAssessingStudentsFinal."Type Education");
        l_AssessConf.SetRange("Study Plan Code", pAssessingStudentsFinal."Study Plan Code");
        if l_AssessConf.FindFirst then begin
            if pAssessingStudentsFinal."Evaluation Type" = pAssessingStudentsFinal."Evaluation Type"::"Final Moment" then
                exit(ValidateAssessmentMixed2(l_AssessConf."PA Assessment Code", pAssessingStudentsFinal.Grade));

            if pAssessingStudentsFinal."Evaluation Type" = pAssessingStudentsFinal."Evaluation Type"::"Final Year" then
                exit(ValidateAssessmentMixed2(l_AssessConf."FY Assessment Code", pAssessingStudentsFinal.Grade));
        end;
    end;

    local procedure varTransitionStatusOnAfterVali()
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

    local procedure varSchoolYearOnAfterValidate()
    begin
        varSchoolingYear := '';
        varCourseCode := '';

        DeleteBuffer;
        UpdateForm;
        CurrPage.Update(false);
    end;

    local procedure varSchoolingYearOnAfterValidat()
    begin
        varCourseCode := '';

        GetType;
        DeleteBuffer;
        UpdateForm;
        CurrPage.Update(false);
    end;

    local procedure varCourseCodeOnAfterValidate()
    begin
        DeleteBuffer;
        InsertStudents;
        InitTempTable;
        UpdateForm;
        CurrPage.Update(false);
    end;

    local procedure vText1OnDeactivate()
    begin
        if ((vArrayType[1] <> vArrayType[1] ::"Final Moment") and
          (vArrayType[1] <> vArrayType[1] ::"Final Year")) and
          ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
          (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[1] = 0) or
          ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[1] <> 0)) then
            Txt1Editable := false
        else
            Txt1Editable := true;
    end;

    local procedure vText2OnDeactivate()
    begin
        if ((vArrayType[2] <> vArrayType[2] ::"Final Moment") and
          (vArrayType[2] <> vArrayType[2] ::"Final Year")) and
          ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
          (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[2] = 0) or
          ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[2] <> 0)) then
            Txt2Editable := false
        else
            Txt2Editable := true;
    end;

    local procedure vText3OnDeactivate()
    begin
        if ((vArrayType[3] <> vArrayType[3] ::"Final Moment") and
          (vArrayType[3] <> vArrayType[3] ::"Final Year")) and
          ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
          (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[3] = 0) or
          ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[3] <> 0)) then
            Txt3Editable := false
        else
            Txt3Editable := true;
    end;

    local procedure vText4OnDeactivate()
    begin
        if ((vArrayType[4] <> vArrayType[4] ::"Final Moment") and
          (vArrayType[4] <> vArrayType[4] ::"Final Year")) and
          ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
          (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[4] = 0) or
          ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[4] <> 0)) then
            Txt4Editable := false
        else
            Txt4Editable := true;
    end;

    local procedure vText5OnDeactivate()
    begin
        if ((vArrayType[5] <> vArrayType[5] ::"Final Moment") and
          (vArrayType[5] <> vArrayType[5] ::"Final Year")) and
          ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
          (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[5] = 0) or
          ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[5] <> 0)) then
            Txt5Editable := false
        else
            Txt5Editable := true;
    end;

    local procedure vText6OnDeactivate()
    begin
        if ((vArrayType[6] <> vArrayType[6] ::"Final Moment") and
          (vArrayType[6] <> vArrayType[6] ::"Final Year")) and
          ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
          (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[6] = 0) or
          ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[6] <> 0)) then
            Txt6Editable := false
        else
            Txt6Editable := true;
    end;

    local procedure vText7OnDeactivate()
    begin
        if ((vArrayType[7] <> vArrayType[7] ::"Final Moment") and
          (vArrayType[7] <> vArrayType[7] ::"Final Year")) and
          ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
          (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[7] = 0) or
          ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[7] <> 0)) then
            Txt7Editable := false
        else
            Txt7Editable := true;
    end;

    local procedure vText8OnDeactivate()
    begin
        if ((vArrayType[8] <> vArrayType[8] ::"Final Moment") and
          (vArrayType[8] <> vArrayType[8] ::"Final Year")) and
          ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
          (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[8] = 0) or
          ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[8] <> 0)) then
            Txt8Editable := false
        else
            Txt8Editable := true;
    end;

    local procedure vText9OnDeactivate()
    begin
        if ((vArrayType[9] <> vArrayType[9] ::"Final Moment") and
          (vArrayType[9] <> vArrayType[9] ::"Final Year")) and
          ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
          (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[9] = 0) or
          ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[9] <> 0)) then
            Txt9Editable := false
        else
            Txt9Editable := true;
    end;

    local procedure vText10OnDeactivate()
    begin
        if ((vArrayType[10] <> vArrayType[10] ::"Final Moment") and
          (vArrayType[10] <> vArrayType[10] ::"Final Year")) and
          ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
          (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[10] = 0) or
          ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[10] <> 0)) then
            Txt10Editable := false
        else
            Txt10Editable := true;
    end;

    local procedure vText11OnDeactivate()
    begin
        if ((vArrayType[11] <> vArrayType[11] ::"Final Moment") and
          (vArrayType[11] <> vArrayType[11] ::"Final Year")) and
          ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
          (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[11] = 0) or
          ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[11] <> 0)) then
            Txt11Editable := false
        else
            Txt11Editable := true;
    end;

    local procedure vText12OnDeactivate()
    begin
        if ((vArrayType[12] <> vArrayType[12] ::"Final Moment") and
          (vArrayType[12] <> vArrayType[12] ::"Final Year")) and
          ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
          (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[12] = 0) or
          ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[12] <> 0)) then
            Txt12Editable := false
        else
            Txt12Editable := true;
    end;

    local procedure vText13OnDeactivate()
    begin
        if ((vArrayType[13] <> vArrayType[13] ::"Final Moment") and
          (vArrayType[13] <> vArrayType[13] ::"Final Year")) and
          ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
          (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[13] = 0) or
          ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[13] <> 0)) then
            Txt13Editable := false
        else
            Txt13Editable := true;
    end;

    local procedure vText14OnDeactivate()
    begin
        if ((vArrayType[14] <> vArrayType[14] ::"Final Moment") and
          (vArrayType[14] <> vArrayType[14] ::"Final Year")) and
          ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
          (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[14] = 0) or
          ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[14] <> 0)) then
            Txt14Editable := false
        else
            Txt14Editable := true;
    end;

    local procedure vText15OnDeactivate()
    begin
        if ((vArrayType[15] <> vArrayType[15] ::"Final Moment") and
          (vArrayType[15] <> vArrayType[15] ::"Final Year")) and
          ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
          (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[15] = 0) or
          ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[15] <> 0)) then
            Txt15Editable := false
        else
            Txt15Editable := true;
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

        if ((vArrayType[1] <> vArrayType[1] ::"Final Moment") and
          (vArrayType[1] <> vArrayType[1] ::"Final Year")) and
          ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
          (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[1] = 0) or
          ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[1] <> 0)) then
            Txt1Editable := false
        else
            Txt1Editable := true;

        CurrPage.Update(false);
    end;

    local procedure vText2OnActivate()
    begin
        GetAverbamentos(vArrayCodMomento[2], varSubjects);
        ExistCommentsSubjects := UpdateCommentsVAR(false, vArrayCodMomento[2]);
        ExistCommentsGlobal := UpdateCommentsVAR(true, vArrayCodMomento[2]);
        varSelectedMoment := vArrayCodMomento[2];

        if ((vArrayType[2] <> vArrayType[2] ::"Final Moment") and
          (vArrayType[2] <> vArrayType[2] ::"Final Year")) and
          ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
          (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[2] = 0) or
          ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[2] <> 0)) then
            Txt2Editable := false
        else
            Txt2Editable := true;

        CurrPage.Update;
    end;

    local procedure vText3OnActivate()
    begin
        GetAverbamentos(vArrayCodMomento[3], varSubjects);
        ExistCommentsSubjects := UpdateCommentsVAR(false, vArrayCodMomento[3]);
        ExistCommentsGlobal := UpdateCommentsVAR(true, vArrayCodMomento[3]);
        varSelectedMoment := vArrayCodMomento[3];

        if ((vArrayType[3] <> vArrayType[3] ::"Final Moment") and
          (vArrayType[3] <> vArrayType[3] ::"Final Year")) and
          ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
          (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[3] = 0) or
          ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[3] <> 0)) then
            Txt3Editable := false
        else
            Txt3Editable := true;

        CurrPage.Update;
    end;

    local procedure vText4OnActivate()
    begin
        GetAverbamentos(vArrayCodMomento[4], varSubjects);
        ExistCommentsSubjects := UpdateCommentsVAR(false, vArrayCodMomento[4]);
        ExistCommentsGlobal := UpdateCommentsVAR(true, vArrayCodMomento[4]);
        varSelectedMoment := vArrayCodMomento[4];

        if ((vArrayType[4] <> vArrayType[4] ::"Final Moment") and
          (vArrayType[4] <> vArrayType[4] ::"Final Year")) and
          ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
          (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[4] = 0) or
          ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[4] <> 0)) then
            Txt4Editable := false
        else
            Txt4Editable := true;

        CurrPage.Update;
    end;

    local procedure vText5OnActivate()
    begin
        GetAverbamentos(vArrayCodMomento[5], varSubjects);
        ExistCommentsSubjects := UpdateCommentsVAR(false, vArrayCodMomento[5]);
        ExistCommentsGlobal := UpdateCommentsVAR(true, vArrayCodMomento[5]);
        varSelectedMoment := vArrayCodMomento[5];

        if ((vArrayType[5] <> vArrayType[5] ::"Final Moment") and
          (vArrayType[5] <> vArrayType[5] ::"Final Year")) and
          ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
          (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[5] = 0) or
          ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[5] <> 0)) then
            Txt5Editable := false
        else
            Txt5Editable := true;

        CurrPage.Update;
    end;

    local procedure vText6OnActivate()
    begin
        GetAverbamentos(vArrayCodMomento[6], varSubjects);
        ExistCommentsSubjects := UpdateCommentsVAR(false, vArrayCodMomento[6]);
        ExistCommentsGlobal := UpdateCommentsVAR(true, vArrayCodMomento[6]);
        varSelectedMoment := vArrayCodMomento[6];

        if ((vArrayType[6] <> vArrayType[6] ::"Final Moment") and
          (vArrayType[6] <> vArrayType[6] ::"Final Year")) and
          ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
          (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[6] = 0) or
          ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[6] <> 0)) then
            Txt6Editable := false
        else
            Txt6Editable := true;

        CurrPage.Update;
    end;

    local procedure vText7OnActivate()
    begin
        GetAverbamentos(vArrayCodMomento[7], varSubjects);
        ExistCommentsSubjects := UpdateCommentsVAR(false, vArrayCodMomento[7]);
        ExistCommentsGlobal := UpdateCommentsVAR(true, vArrayCodMomento[7]);
        varSelectedMoment := vArrayCodMomento[7];

        if ((vArrayType[7] <> vArrayType[7] ::"Final Moment") and
          (vArrayType[7] <> vArrayType[7] ::"Final Year")) and
          ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
          (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[7] = 0) or
          ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[7] <> 0)) then
            Txt7Editable := false
        else
            Txt7Editable := true;

        CurrPage.Update;
    end;

    local procedure vText8OnActivate()
    begin
        GetAverbamentos(vArrayCodMomento[8], varSubjects);
        ExistCommentsSubjects := UpdateCommentsVAR(false, vArrayCodMomento[8]);
        ExistCommentsGlobal := UpdateCommentsVAR(true, vArrayCodMomento[8]);
        varSelectedMoment := vArrayCodMomento[8];

        if ((vArrayType[8] <> vArrayType[8] ::"Final Moment") and
          (vArrayType[8] <> vArrayType[8] ::"Final Year")) and
          ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
          (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[8] = 0) or
          ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[8] <> 0)) then
            Txt8Editable := false
        else
            Txt8Editable := true;

        CurrPage.Update;
    end;

    local procedure vText9OnActivate()
    begin
        GetAverbamentos(vArrayCodMomento[9], varSubjects);
        ExistCommentsSubjects := UpdateCommentsVAR(false, vArrayCodMomento[9]);
        ExistCommentsGlobal := UpdateCommentsVAR(true, vArrayCodMomento[9]);
        varSelectedMoment := vArrayCodMomento[9];

        if ((vArrayType[9] <> vArrayType[9] ::"Final Moment") and
          (vArrayType[9] <> vArrayType[9] ::"Final Year")) and
          ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
          (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[9] = 0) or
          ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[9] <> 0)) then
            Txt9Editable := false
        else
            Txt9Editable := true;

        CurrPage.Update;
    end;

    local procedure vText10OnActivate()
    begin
        GetAverbamentos(vArrayCodMomento[10], varSubjects);
        ExistCommentsSubjects := UpdateCommentsVAR(false, vArrayCodMomento[10]);
        ExistCommentsGlobal := UpdateCommentsVAR(true, vArrayCodMomento[10]);
        varSelectedMoment := vArrayCodMomento[10];

        if ((vArrayType[10] <> vArrayType[10] ::"Final Moment") and
          (vArrayType[10] <> vArrayType[10] ::"Final Year")) and
          ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
          (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[10] = 0) or
          ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[10] <> 0)) then
            Txt10Editable := false
        else
            Txt10Editable := true;

        CurrPage.Update;
    end;

    local procedure vText11OnActivate()
    begin
        GetAverbamentos(vArrayCodMomento[11], varSubjects);
        ExistCommentsSubjects := UpdateCommentsVAR(false, vArrayCodMomento[11]);
        ExistCommentsGlobal := UpdateCommentsVAR(true, vArrayCodMomento[11]);
        varSelectedMoment := vArrayCodMomento[11];

        if ((vArrayType[11] <> vArrayType[11] ::"Final Moment") and
          (vArrayType[11] <> vArrayType[11] ::"Final Year")) and
          ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
          (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[11] = 0) or
          ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[11] <> 0)) then
            Txt11Editable := false
        else
            Txt11Editable := true;

        CurrPage.Update;
    end;

    local procedure vText12OnActivate()
    begin
        GetAverbamentos(vArrayCodMomento[12], varSubjects);
        ExistCommentsSubjects := UpdateCommentsVAR(false, vArrayCodMomento[12]);
        ExistCommentsGlobal := UpdateCommentsVAR(true, vArrayCodMomento[12]);
        varSelectedMoment := vArrayCodMomento[12];

        if ((vArrayType[12] <> vArrayType[12] ::"Final Moment") and
          (vArrayType[12] <> vArrayType[12] ::"Final Year")) and
          ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
          (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[12] = 0) or
          ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[12] <> 0)) then
            Txt12Editable := false
        else
            Txt12Editable := true;

        CurrPage.Update;
    end;

    local procedure vText13OnActivate()
    begin
        GetAverbamentos(vArrayCodMomento[13], varSubjects);
        ExistCommentsSubjects := UpdateCommentsVAR(false, vArrayCodMomento[13]);
        ExistCommentsGlobal := UpdateCommentsVAR(true, vArrayCodMomento[13]);
        varSelectedMoment := vArrayCodMomento[13];

        if ((vArrayType[13] <> vArrayType[13] ::"Final Moment") and
          (vArrayType[13] <> vArrayType[13] ::"Final Year")) and
          ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
          (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[13] = 0) or
          ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[13] <> 0)) then
            Txt13Editable := false
        else
            Txt13Editable := true;

        CurrPage.Update;
    end;

    local procedure vText14OnActivate()
    begin
        GetAverbamentos(vArrayCodMomento[14], varSubjects);
        ExistCommentsSubjects := UpdateCommentsVAR(false, vArrayCodMomento[14]);
        ExistCommentsGlobal := UpdateCommentsVAR(true, vArrayCodMomento[14]);
        varSelectedMoment := vArrayCodMomento[14];

        if ((vArrayType[14] <> vArrayType[14] ::"Final Moment") and
          (vArrayType[14] <> vArrayType[14] ::"Final Year")) and
          ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
          (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[14] = 0) or
          ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[14] <> 0)) then
            Txt14Editable := false
        else
            Txt14Editable := true;

        CurrPage.Update;
    end;

    local procedure vText15OnActivate()
    begin
        GetAverbamentos(vArrayCodMomento[15], varSubjects);
        ExistCommentsSubjects := UpdateCommentsVAR(false, vArrayCodMomento[15]);
        ExistCommentsGlobal := UpdateCommentsVAR(true, vArrayCodMomento[15]);
        varSelectedMoment := vArrayCodMomento[15];

        if ((vArrayType[15] <> vArrayType[15] ::"Final Moment") and
          (vArrayType[15] <> vArrayType[15] ::"Final Year")) and
          ((Rec."Option Type" = Rec."Option Type"::"Schooling Year") or
          (Rec."Option Type" = Rec."Option Type"::"Option Group")) and (VarFinalType[15] = 0) or
          ((Rec."Option Type" = Rec."Option Type"::"Option Group") and (VarFinalType[15] <> 0)) then
            Txt15Editable := false
        else
            Txt15Editable := true;

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
        if Rec."Option Type" = Rec."Option Type"::"Schooling Year" then
            Txt1Emphasize := true;
    end;

    local procedure vText2OnFormat()
    begin
        if Rec."Option Type" = Rec."Option Type"::"Schooling Year" then
            Txt2Emphasize := true;
    end;

    local procedure vText3OnFormat()
    begin
        if Rec."Option Type" = Rec."Option Type"::"Schooling Year" then
            Txt3Emphasize := true;
    end;

    local procedure vText4OnFormat()
    begin
        if Rec."Option Type" = Rec."Option Type"::"Schooling Year" then
            Txt4Emphasize := true;
    end;

    local procedure vText5OnFormat()
    begin
        if Rec."Option Type" = Rec."Option Type"::"Schooling Year" then
            Txt5Emphasize := true;
    end;

    local procedure vText6OnFormat()
    begin
        if Rec."Option Type" = Rec."Option Type"::"Schooling Year" then
            Txt6Emphasize := true;
    end;

    local procedure vText7OnFormat()
    begin
        if Rec."Option Type" = Rec."Option Type"::"Schooling Year" then
            Txt7Emphasize := true;
    end;

    local procedure vText8OnFormat()
    begin
        if Rec."Option Type" = Rec."Option Type"::"Schooling Year" then
            Txt8Emphasize := true;
    end;

    local procedure vText9OnFormat()
    begin
        if Rec."Option Type" = Rec."Option Type"::"Schooling Year" then
            Txt9Emphasize := true;
    end;

    local procedure vText10OnFormat()
    begin
        if Rec."Option Type" = Rec."Option Type"::"Schooling Year" then
            Txt10Emphasize := true;
    end;

    local procedure vText11OnFormat()
    begin
        if Rec."Option Type" = Rec."Option Type"::"Schooling Year" then
            Txt11Emphasize := true;
    end;

    local procedure vText12OnFormat()
    begin
        if Rec."Option Type" = Rec."Option Type"::"Schooling Year" then
            Txt12Emphasize := true;
    end;

    local procedure vText13OnFormat()
    begin
        if Rec."Option Type" = Rec."Option Type"::"Schooling Year" then
            Txt13Emphasize := true;
    end;

    local procedure vText14OnFormat()
    begin
        if Rec."Option Type" = Rec."Option Type"::"Schooling Year" then
            Txt14Emphasize := true;
    end;

    local procedure vText15OnFormat()
    begin
        if Rec."Option Type" = Rec."Option Type"::"Schooling Year" then
            Txt15Emphasize := true;
    end;

    local procedure vTermsBookOnFormat()
    begin
        if Rec."Option Type" = Rec."Option Type"::Subjects then
            BooktermsEditable := true
        else
            BooktermsEditable := false;
    end;

    local procedure vTermsSheetOnFormat()
    begin
        if Rec."Option Type" = Rec."Option Type"::Subjects then
            SheetTermsEditable := true
        else
            SheetTermsEditable := false;
    end;
}

#pragma implicitwith restore

