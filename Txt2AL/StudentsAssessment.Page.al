
page 31009919 "Students Assessment"
{
    Caption = 'Students Assessment';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
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
                field(varClass; varClass)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Class';

                    trigger OnLookup(var Text: Text): Boolean
                    begin

                        rClass.Reset;
                        rClass.SetFilter("School Year", cStudentsRegistration.GetShoolYearActiveClosing);
                        if cUserEducation.GetEducationFilter(UserId) <> '' then
                            rClass.SetRange("Responsibility Center", cUserEducation.GetEducationFilter(UserId));
                        if rClass.Find('-') then begin
                            if PAGE.RunModal(PAGE::"Class List", rClass) = ACTION::LookupOK then begin
                                Clear(varActiveMoment);
                                Clear(VarSubjects);
                                varClass := rClass.Class;
                                VarSchoolYear := rClass."School Year";
                                varSchoolingYear := rClass."Schooling Year";
                                VarStudyPlanCode := rClass."Study Plan Code";
                                VarType := rClass.Type;

                                rMomentsAssessment.Reset;
                                rMomentsAssessment.SetRange("School Year", VarSchoolYear);
                                rMomentsAssessment.SetRange("Schooling Year", varSchoolingYear);
                                rMomentsAssessment.SetRange("Responsibility Center", cUserEducation.GetEducationFilter(UserId));
                                if not rMomentsAssessment.FindFirst then
                                    Error(text010);

                                rMomentsAssessment.Reset;
                                rMomentsAssessment.SetRange("School Year", VarSchoolYear);
                                rMomentsAssessment.SetRange("Schooling Year", varSchoolingYear);
                                rMomentsAssessment.SetRange(Active, true);
                                rMomentsAssessment.SetRange("Responsibility Center", rClass."Responsibility Center");
                                if rMomentsAssessment.FindFirst then begin
                                    varActiveMoment := rMomentsAssessment."Moment Code";
                                    varEvaluationType := rMomentsAssessment."Evaluation Moment";
                                end else
                                    Error(text008);
                            end;
                        end;
                        UpdateForm;
                        Rec.SetRange(Class, varClass);
                        Rec.SetRange("Subjects Code", VarSubjects);
                        CurrPage.Update(false);
                    end;

                    trigger OnValidate()
                    begin
                        Clear(varActiveMoment);
                        Clear(VarSubjects);
                        if varClass <> '' then begin
                            rClass.Reset;
                            rClass.SetFilter("School Year", cStudentsRegistration.GetShoolYearActiveClosing);
                            rClass.SetRange(Class, varClass);
                            if rClass.FindFirst then begin
                                VarSchoolYear := rClass."School Year";
                                varSchoolingYear := rClass."Schooling Year";
                                VarStudyPlanCode := rClass."Study Plan Code";
                                VarType := rClass.Type;

                                rMomentsAssessment.Reset;
                                rMomentsAssessment.SetRange("School Year", VarSchoolYear);
                                rMomentsAssessment.SetRange("Schooling Year", varSchoolingYear);
                                rMomentsAssessment.SetRange("Responsibility Center", cUserEducation.GetEducationFilter(UserId));
                                if not rMomentsAssessment.FindFirst then
                                    Error(text010);


                                rMomentsAssessment.Reset;
                                rMomentsAssessment.SetRange("School Year", VarSchoolYear);
                                rMomentsAssessment.SetRange("Schooling Year", varSchoolingYear);
                                rMomentsAssessment.SetRange(Active, true);
                                rMomentsAssessment.SetRange("Responsibility Center", cUserEducation.GetEducationFilter(UserId));
                                if rMomentsAssessment.FindFirst then begin
                                    varActiveMoment := rMomentsAssessment."Moment Code";
                                    varEvaluationType := rMomentsAssessment."Evaluation Moment";
                                end else
                                    Error(text008);

                            end else
                                Error(text006);
                        end;
                        Rec.SetRange(Class, varClass);
                        Rec.SetRange("Subjects Code", VarSubjects);
                        varClassOnAfterValidate;
                    end;
                }
                field(VarSubjects; VarSubjects)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Subjects';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        rCourseLinesTEMP: Record "Course Lines" temporary;
                        l_rStruEduCountry: Record "Structure Education Country";
                        rStruEduCountry: Record "Structure Education Country";
                    begin

                        if varClass <> '' then begin
                            if VarType = VarType::Simple then begin
                                rStudyPlanLines.Reset;
                                rStudyPlanLines.SetFilter(Code, VarStudyPlanCode);
                                rStudyPlanLines.SetFilter("School Year", VarSchoolYear);
                                rStudyPlanLines.SetFilter("Schooling Year", varSchoolingYear);
                                rStudyPlanLines.SetFilter("Evaluation Type", '<>%1', rStudyPlanLines."Evaluation Type"::"None Qualification");
                                if cUserEducation.GetEducationFilter(UserId) <> '' then
                                    rStudyPlanLines.SetRange("Responsibility Center", cUserEducation.GetEducationFilter(UserId));
                                if rStudyPlanLines.Find('-') then begin
                                    if PAGE.RunModal(PAGE::"List Subjects", rStudyPlanLines) = ACTION::LookupOK then begin
                                        VarSubjects := rStudyPlanLines."Subject Code";
                                        UpdateForm;
                                    end;
                                end;
                            end else begin
                                rCourseLinesTEMP.Reset;
                                rCourseLinesTEMP.DeleteAll;

                                // Quadriennal
                                rCourseLines.Reset;
                                rCourseLines.SetRange(Code, VarStudyPlanCode);
                                rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Quadriennal);
                                if rCourseLines.Find('-') then begin
                                    repeat
                                        rCourseLinesTEMP.Init;
                                        rCourseLinesTEMP.TransferFields(rCourseLines);
                                        rCourseLinesTEMP.Insert;
                                    until rCourseLines.Next = 0;
                                end;

                                //Annual
                                rCourseLines.Reset;
                                rCourseLines.SetRange(Code, VarStudyPlanCode);
                                rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Annual);
                                rCourseLines.SetRange("Schooling Year Begin", varSchoolingYear);
                                if rCourseLines.Find('-') then begin
                                    repeat
                                        rCourseLinesTEMP.Init;
                                        rCourseLinesTEMP.TransferFields(rCourseLines);
                                        rCourseLinesTEMP.Insert;
                                    until rCourseLines.Next = 0;
                                end;

                                //Biennial
                                rStruEduCountry.Reset;
                                rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
                                rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
                                rStruEduCountry.SetRange("Schooling Year", varSchoolingYear);
                                if rStruEduCountry.Find('-') then begin
                                    rCourseLines.Reset;
                                    rCourseLines.SetRange(Code, VarStudyPlanCode);
                                    rCourseLines.SetFilter("Characterise Subjects", '%1|%2', rCourseLines."Characterise Subjects"::Biennial,
                                                            rCourseLines."Characterise Subjects"::Triennial);
                                    rCourseLines.SetRange("Schooling Year Begin", varSchoolingYear);
                                    if rCourseLines.Find('-') then begin
                                        repeat
                                            rCourseLinesTEMP.Init;
                                            rCourseLinesTEMP.TransferFields(rCourseLines);
                                            rCourseLinesTEMP.Insert;
                                        until rCourseLines.Next = 0;
                                    end;
                                    l_rStruEduCountry.Reset;
                                    l_rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
                                    l_rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
                                    l_rStruEduCountry.SetRange("Sorting ID", GetNoStructureCountry(varClass, VarSchoolYear) - 1);
                                    if l_rStruEduCountry.Find('-') then begin
                                        rCourseLines.Reset;
                                        rCourseLines.SetRange(Code, VarStudyPlanCode);
                                        rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Biennial);
                                        rCourseLines.SetRange("Schooling Year Begin", l_rStruEduCountry."Schooling Year");
                                        if rCourseLines.Find('-') then begin
                                            repeat
                                                rCourseLinesTEMP.Init;
                                                rCourseLinesTEMP.TransferFields(rCourseLines);
                                                rCourseLinesTEMP.Insert;
                                            until rCourseLines.Next = 0;
                                        end;
                                    end;
                                    l_rStruEduCountry.Reset;
                                    l_rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
                                    l_rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
                                    l_rStruEduCountry.SetRange("Sorting ID", GetNoStructureCountry(varClass, VarSchoolYear) - 2);
                                    if l_rStruEduCountry.Find('-') then begin
                                        rCourseLines.Reset;
                                        rCourseLines.SetRange(Code, VarStudyPlanCode);
                                        rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Triennial);
                                        rCourseLines.SetRange("Schooling Year Begin", l_rStruEduCountry."Schooling Year");
                                        if rCourseLines.Find('-') then begin
                                            repeat
                                                rCourseLinesTEMP.Init;
                                                rCourseLinesTEMP.TransferFields(rCourseLines);
                                                rCourseLinesTEMP.Insert;
                                            until rCourseLines.Next = 0;
                                        end;
                                    end;
                                    l_rStruEduCountry.Reset;
                                    l_rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
                                    l_rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
                                    l_rStruEduCountry.SetRange("Sorting ID", GetNoStructureCountry(varClass, VarSchoolYear) - 1);
                                    if l_rStruEduCountry.Find('-') then begin
                                        rCourseLines.Reset;
                                        rCourseLines.SetRange(Code, VarStudyPlanCode);
                                        rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Triennial);
                                        rCourseLines.SetRange("Schooling Year Begin", l_rStruEduCountry."Schooling Year");
                                        if rCourseLines.Find('-') then begin
                                            repeat
                                                rCourseLinesTEMP.Init;
                                                rCourseLinesTEMP.TransferFields(rCourseLines);
                                                rCourseLinesTEMP.Insert;
                                            until rCourseLines.Next = 0;
                                        end;
                                    end;
                                end;


                                rCourseLinesTEMP.Reset;
                                rCourseLinesTEMP.SetFilter("Evaluation Type", '<>%1', rCourseLinesTEMP."Evaluation Type"::"None Qualification");
                                if rCourseLinesTEMP.Find('-') then begin
                                    if PAGE.RunModal(PAGE::"List Course Lines", rCourseLinesTEMP) = ACTION::LookupOK then begin
                                        VarSubjects := rCourseLinesTEMP."Subject Code";
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
                        VarSubjectsOnAfterValidate;
                    end;
                }
            }
            repeater(TableBoxMoments)
            {
                field("Class No."; Rec."Class No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("rStudents.Name"; rStudents.Name)
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
                    Visible = Txt1Visible;

                    trigger OnLookup(var Text: Text): Boolean
                    begin

                        if vArraySubject[1] <> '' then begin
                            vText[1] := LookupFunction(1);
                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 1, vText[1]);
                        end;
                    end;

                    trigger OnValidate()
                    begin

                        if vArrayAssessmentType[1] = vArrayAssessmentType[1] ::Qualitative then begin
                            ValidateAssessmentQualitative(1, vText[1]);

                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 1, vText[1]);
                        end;


                        if vArrayAssessmentType[1] = vArrayAssessmentType[1] ::"Mixed-Qualification" then begin
                            vText[1] := ValidateAssessmentMixed(1, vText[1]);
                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 1, vText[1]);
                        end;
                        if vArrayAssessmentType[1] = vArrayAssessmentType[1] ::Quantitative then begin
                            vText[1] := Format(ValidateAssessmentQuant(1, vText[1]));

                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 1, vText[1]);
                        end;
                        vText1OnAfterValidate;
                    end;
                }
                field(Txt2; vText[2])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(2);
                    Visible = Txt2Visible;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if vArraySubject[2] <> '' then begin
                            vText[2] := LookupFunction(2);
                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 2, vText[2]);
                        end;
                    end;

                    trigger OnValidate()
                    begin

                        if vArrayAssessmentType[2] = vArrayAssessmentType[2] ::Qualitative then begin
                            ValidateAssessmentQualitative(2, vText[2]);

                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 2, vText[2]);
                        end;


                        if vArrayAssessmentType[2] = vArrayAssessmentType[2] ::"Mixed-Qualification" then begin
                            vText[2] := ValidateAssessmentMixed(2, vText[2]);
                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 2, vText[2]);
                        end;
                        if vArrayAssessmentType[2] = vArrayAssessmentType[2] ::Quantitative then begin
                            vText[2] := Format(ValidateAssessmentQuant(2, vText[2]));

                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 2, vText[2]);
                        end;
                        vText2OnAfterValidate;
                    end;
                }
                field(Txt3; vText[3])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(3);
                    Visible = Txt3Visible;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if vArraySubject[3] <> '' then begin
                            vText[3] := LookupFunction(3);
                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 3, vText[3]);
                        end;
                    end;

                    trigger OnValidate()
                    begin

                        if vArrayAssessmentType[3] = vArrayAssessmentType[3] ::Qualitative then begin
                            ValidateAssessmentQualitative(3, vText[3]);

                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 3, vText[3]);
                        end;


                        if vArrayAssessmentType[3] = vArrayAssessmentType[3] ::"Mixed-Qualification" then begin
                            vText[3] := ValidateAssessmentMixed(3, vText[3]);
                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 3, vText[3]);
                        end;
                        if vArrayAssessmentType[3] = vArrayAssessmentType[3] ::Quantitative then begin
                            vText[3] := Format(ValidateAssessmentQuant(3, vText[3]));

                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 3, vText[3]);
                        end;
                        vText3OnAfterValidate;
                    end;
                }
                field(Txt4; vText[4])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(4);
                    Visible = Txt4Visible;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if vArraySubject[4] <> '' then begin
                            vText[4] := LookupFunction(4);
                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 4, vText[4]);
                        end;
                    end;

                    trigger OnValidate()
                    begin

                        if vArrayAssessmentType[4] = vArrayAssessmentType[4] ::Qualitative then begin
                            ValidateAssessmentQualitative(4, vText[4]);

                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 4, vText[4]);
                        end;


                        if vArrayAssessmentType[4] = vArrayAssessmentType[4] ::"Mixed-Qualification" then begin
                            vText[4] := ValidateAssessmentMixed(4, vText[4]);
                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 4, vText[4]);
                        end;
                        if vArrayAssessmentType[4] = vArrayAssessmentType[4] ::Quantitative then begin
                            vText[4] := Format(ValidateAssessmentQuant(4, vText[4]));

                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 4, vText[4]);
                        end;
                        vText4OnAfterValidate;
                    end;
                }
                field(Txt5; vText[5])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(5);
                    Visible = Txt5Visible;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if vArraySubject[5] <> '' then begin
                            vText[5] := LookupFunction(5);
                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 5, vText[5]);
                        end;
                    end;

                    trigger OnValidate()
                    begin

                        if vArrayAssessmentType[5] = vArrayAssessmentType[5] ::Qualitative then begin
                            ValidateAssessmentQualitative(5, vText[5]);

                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 5, vText[5]);
                        end;


                        if vArrayAssessmentType[5] = vArrayAssessmentType[5] ::"Mixed-Qualification" then begin
                            vText[5] := ValidateAssessmentMixed(5, vText[5]);
                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 5, vText[5]);
                        end;
                        if vArrayAssessmentType[5] = vArrayAssessmentType[5] ::Quantitative then begin
                            vText[5] := Format(ValidateAssessmentQuant(5, vText[5]));

                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 5, vText[5]);
                        end;
                        vText5OnAfterValidate;
                    end;
                }
                field(Txt6; vText[6])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(6);
                    Visible = Txt6Visible;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if vArraySubject[6] <> '' then begin
                            vText[6] := LookupFunction(6);
                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 6, vText[6]);
                        end;
                    end;

                    trigger OnValidate()
                    begin

                        if vArrayAssessmentType[6] = vArrayAssessmentType[6] ::Qualitative then begin
                            ValidateAssessmentQualitative(6, vText[6]);

                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 6, vText[6]);
                        end;


                        if vArrayAssessmentType[6] = vArrayAssessmentType[6] ::"Mixed-Qualification" then begin
                            vText[6] := ValidateAssessmentMixed(6, vText[6]);
                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 6, vText[6]);
                        end;
                        if vArrayAssessmentType[6] = vArrayAssessmentType[6] ::Quantitative then begin
                            vText[6] := Format(ValidateAssessmentQuant(6, vText[6]));

                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 6, vText[6]);
                        end;
                        vText6OnAfterValidate;
                    end;
                }
                field(Txt7; vText[7])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(7);
                    Visible = Txt7Visible;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if vArraySubject[7] <> '' then begin
                            vText[7] := LookupFunction(7);
                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 7, vText[7]);
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        if vArrayAssessmentType[7] = vArrayAssessmentType[7] ::Qualitative then begin
                            ValidateAssessmentQualitative(7, vText[7]);

                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 7, vText[7]);
                        end;


                        if vArrayAssessmentType[7] = vArrayAssessmentType[7] ::"Mixed-Qualification" then begin
                            vText[7] := ValidateAssessmentMixed(7, vText[7]);
                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 7, vText[7]);
                        end;
                        if vArrayAssessmentType[7] = vArrayAssessmentType[7] ::Quantitative then begin
                            vText[7] := Format(ValidateAssessmentQuant(7, vText[7]));

                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 7, vText[7]);
                        end;
                        vText7OnAfterValidate;
                    end;
                }
                field(Txt8; vText[8])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(8);
                    Visible = Txt8Visible;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if vArraySubject[8] <> '' then begin
                            vText[8] := LookupFunction(8);
                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 8, vText[8]);
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        if vArrayAssessmentType[8] = vArrayAssessmentType[8] ::Qualitative then begin
                            ValidateAssessmentQualitative(8, vText[8]);

                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 8, vText[8]);
                        end;


                        if vArrayAssessmentType[8] = vArrayAssessmentType[8] ::"Mixed-Qualification" then begin
                            vText[8] := ValidateAssessmentMixed(8, vText[8]);
                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 8, vText[8]);
                        end;
                        if vArrayAssessmentType[8] = vArrayAssessmentType[8] ::Quantitative then begin
                            vText[8] := Format(ValidateAssessmentQuant(8, vText[8]));

                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 8, vText[8]);
                        end;
                        vText8OnAfterValidate;
                    end;
                }
                field(Txt9; vText[9])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(9);
                    Visible = Txt9Visible;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if vArraySubject[9] <> '' then begin
                            vText[9] := LookupFunction(9);
                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 9, vText[9]);
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        if vArrayAssessmentType[9] = vArrayAssessmentType[9] ::Qualitative then begin
                            ValidateAssessmentQualitative(9, vText[9]);

                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 9, vText[9]);
                        end;


                        if vArrayAssessmentType[9] = vArrayAssessmentType[9] ::"Mixed-Qualification" then begin
                            vText[9] := ValidateAssessmentMixed(9, vText[9]);
                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 9, vText[9]);
                        end;
                        if vArrayAssessmentType[9] = vArrayAssessmentType[9] ::Quantitative then begin
                            vText[9] := Format(ValidateAssessmentQuant(9, vText[9]));

                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 9, vText[9]);
                        end;
                        vText9OnAfterValidate;
                    end;
                }
                field(Txt10; vText[10])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(10);
                    Visible = Txt10Visible;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if vArraySubject[10] <> '' then begin
                            vText[10] := LookupFunction(10);
                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 10, vText[10]);
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        if vArrayAssessmentType[10] = vArrayAssessmentType[10] ::Qualitative then begin
                            ValidateAssessmentQualitative(10, vText[10]);

                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 10, vText[10]);
                        end;


                        if vArrayAssessmentType[10] = vArrayAssessmentType[10] ::"Mixed-Qualification" then begin
                            vText[10] := ValidateAssessmentMixed(10, vText[10]);
                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 10, vText[10]);
                        end;
                        if vArrayAssessmentType[10] = vArrayAssessmentType[10] ::Quantitative then begin
                            vText[10] := Format(ValidateAssessmentQuant(10, vText[10]));

                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 10, vText[10]);
                        end;
                        vText10OnAfterValidate;
                    end;
                }
                field(Txt11; vText[11])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(11);
                    Visible = Txt11Visible;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if vArraySubject[11] <> '' then begin
                            vText[11] := LookupFunction(11);
                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 11, vText[11]);
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        if vArrayAssessmentType[11] = vArrayAssessmentType[11] ::Qualitative then begin
                            ValidateAssessmentQualitative(11, vText[11]);

                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 11, vText[11]);
                        end;


                        if vArrayAssessmentType[11] = vArrayAssessmentType[11] ::"Mixed-Qualification" then begin
                            if vArraySubject[11] <> '' then begin
                                vText[11] := ValidateAssessmentMixed(11, vText[11]);
                                InsertAssessment(Rec."Student Code No.", Rec."Class No.", 11, vText[11]);
                            end;

                        end else begin
                            if vArraySubject[11] <> '' then begin
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
                    Visible = Txt12Visible;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if vArraySubject[12] <> '' then begin
                            vText[12] := LookupFunction(12);
                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 12, vText[12]);
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        if vArrayAssessmentType[12] = vArrayAssessmentType[12] ::Qualitative then begin
                            ValidateAssessmentQualitative(12, vText[12]);

                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 12, vText[12]);
                        end;


                        if vArrayAssessmentType[12] = vArrayAssessmentType[12] ::"Mixed-Qualification" then begin
                            vText[12] := ValidateAssessmentMixed(12, vText[12]);
                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 12, vText[12]);
                        end;
                        if vArrayAssessmentType[12] = vArrayAssessmentType[12] ::Quantitative then begin
                            vText[12] := Format(ValidateAssessmentQuant(12, vText[12]));

                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 12, vText[12]);
                        end;
                        vText12OnAfterValidate;
                    end;
                }
                field(Txt13; vText[13])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(13);
                    Visible = Txt13Visible;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if vArraySubject[13] <> '' then begin
                            vText[13] := LookupFunction(13);
                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 13, vText[13]);
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        if vArrayAssessmentType[13] = vArrayAssessmentType[13] ::Qualitative then begin
                            ValidateAssessmentQualitative(13, vText[13]);

                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 13, vText[13]);
                        end;


                        if vArrayAssessmentType[13] = vArrayAssessmentType[13] ::"Mixed-Qualification" then begin
                            vText[13] := ValidateAssessmentMixed(13, vText[13]);
                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 13, vText[13]);
                        end;
                        if vArrayAssessmentType[13] = vArrayAssessmentType[13] ::Quantitative then begin
                            vText[13] := Format(ValidateAssessmentQuant(13, vText[13]));

                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 13, vText[13]);
                        end;
                        vText13OnAfterValidate;
                    end;
                }
                field(Txt14; vText[14])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(14);
                    Visible = Txt14Visible;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if vArraySubject[14] <> '' then begin
                            vText[14] := LookupFunction(14);
                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 14, vText[14]);
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        if vArrayAssessmentType[14] = vArrayAssessmentType[14] ::Qualitative then begin
                            ValidateAssessmentQualitative(14, vText[14]);

                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 14, vText[14]);
                        end;


                        if vArrayAssessmentType[14] = vArrayAssessmentType[14] ::"Mixed-Qualification" then begin
                            vText[14] := ValidateAssessmentMixed(14, vText[14]);
                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 14, vText[14]);
                        end;
                        if vArrayAssessmentType[14] = vArrayAssessmentType[14] ::Quantitative then begin
                            vText[14] := Format(ValidateAssessmentQuant(14, vText[14]));

                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 14, vText[14]);
                        end;
                        vText14OnAfterValidate;
                    end;
                }
                field(Txt15; vText[15])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(15);
                    Visible = Txt15Visible;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if vArraySubject[15] <> '' then begin
                            vText[15] := LookupFunction(15);
                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 15, vText[15]);
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        if vArrayAssessmentType[15] = vArrayAssessmentType[15] ::Qualitative then begin
                            ValidateAssessmentQualitative(15, vText[15]);

                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 15, vText[15]);
                        end;


                        if vArrayAssessmentType[15] = vArrayAssessmentType[15] ::"Mixed-Qualification" then begin
                            vText[15] := ValidateAssessmentMixed(15, vText[15]);
                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 15, vText[15]);
                        end;
                        if vArrayAssessmentType[15] = vArrayAssessmentType[15] ::Quantitative then begin
                            vText[15] := Format(ValidateAssessmentQuant(15, vText[15]));

                            InsertAssessment(Rec."Student Code No.", Rec."Class No.", 15, vText[15]);
                        end;
                        vText15OnAfterValidate;
                    end;
                }
                field(HasIndividualPlan1; HasIndividualPlan)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Has Individual Plan';
                    Editable = HasIndividualPlan1Editable;
                    Visible = HasIndividualPlan1Visible;

                    trigger OnValidate()
                    begin
                        InsertIndividualPlan(Rec."Student Code No.", HasIndividualPlan, 1);
                    end;
                }
                field(ScholarshipReinforcement1; ScholarshipReinforcement)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Scholarship Reinforcement';
                    Visible = ScholarshipReinforcement1Visib;

                    trigger OnValidate()
                    begin
                        InsertIndividualPlan(Rec."Student Code No.", ScholarshipReinforcement, 2);
                    end;
                }
                field(ScholarshipSupport1; ScholarshipSupport)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Scholarship Support';
                    Visible = ScholarshipSupport1Visible;

                    trigger OnValidate()
                    begin
                        InsertIndividualPlan(Rec."Student Code No.", ScholarshipSupport, 3);
                    end;
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
                field(Control1102056050; rStudents.Name)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(varActiveMoment; varActiveMoment)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Active Moment';
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
                field(ActualObservationCode; ActualObservationCode)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Observations';
                    Editable = false;
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
                Image = Setup;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    varTypeButtonEdit := true;
                    if (varClass <> '') then begin
                        Clear(fRemarksWizard);
                        fRemarksWizard.GetMomentInformation(varActiveMoment);
                        fRemarksWizard.GetInformation(Rec."Student Code No.", Rec."School Year", Rec.Class, Rec."Schooling Year", Rec."Study Plan Code", '',
                                                    '', Rec."Class No.", VarType, varTypeButtonEdit);
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
                        Clear(fRemarksWizard);
                        fRemarksWizard.GetObservationCode(ActualObservationCode);
                        fRemarksWizard.GetMomentInformation(varActiveMoment);
                        if ActualIsSubSubject then
                            fRemarksWizard.GetInformation(Rec."Student Code No.", Rec."School Year", Rec.Class, Rec."Schooling Year", Rec."Study Plan Code", Rec."Subjects Code",
                                                      ActualSubSubject, Rec."Class No.", VarType, varTypeButtonEdit)
                        else
                            fRemarksWizard.GetInformation(Rec."Student Code No.", Rec."School Year", Rec.Class, Rec."Schooling Year", Rec."Study Plan Code", Rec."Subjects Code",
                                                      '', Rec."Class No.", VarType, varTypeButtonEdit);

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

        HasIndividualPlan1Editable := HasClassification;
    end;

    trigger OnInit()
    begin
        Txt1Editable := true;
        HasIndividualPlan1Visible := true;
        ScholarshipSupport1Visible := true;
        ScholarshipReinforcement1Visib := true;
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
        HasIndividualPlan1Editable := true;
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
    end;

    var
        varClass: Code[20];
        VarSubjects: Code[10];
        VarSchoolYear: Code[9];
        varSchoolingYear: Code[10];
        VarStudyPlanCode: Code[20];
        vText: array[15] of Text[250];
        vArraySubject: array[15] of Text[30];
        vArrayAssessmentType: array[15] of Option " ",Qualitative,Quantitative,"None Qualification","Mixed-Qualification";
        vArrayAssessmentCode: array[15] of Code[20];
        text001: Label 'Inserting Class is Mandatory.';
        text002: Label 'Inserting Subject is Mandatory.';
        text003: Label 'Grade should be a Number';
        text004: Label 'Grade should be between %1 and %2.';
        vArraySubSubjects: array[15] of Boolean;
        vArrayObservationCode: array[15] of Code[20];
        indx: Integer;
        rStudents: Record Students;
        rClass: Record Class;
        cStudentsRegistration: Codeunit "Students Registration";
        rStudyPlanLines: Record "Study Plan Lines";
        rMomentsAssessment: Record "Moments Assessment";
        rSettingRatings: Record "Setting Ratings";
        rRankGroup: Record "Rank Group";
        text005: Label 'There is no code inserted';
        rStructureEducationCountry: Record "Structure Education Country";
        varMomentCode: Code[20];
        LineNo: Integer;
        varClassification: Text[30];
        varMixedClassification: Boolean;
        varMixedClaCriterion: Boolean;
        text006: Label 'Class non-existent.';
        text007: Label 'Class must not be blank.';
        cUserEducation: Codeunit "User Education";
        ExistCommentsSubjects: Boolean;
        ExistCommentsGlobal: Boolean;
        VarType: Option Simple,Multi;
        rCourseLines: Record "Course Lines";
        varTypeButtonEdit: Boolean;
        varActiveMoment: Code[10];
        varEvaluationType: Integer;
        text008: Label 'There should be an active moment.';
        cCalcEvaluations: Codeunit "Calc. Evaluations";
        ActualObservationCode: Code[20];
        ActualSubSubject: Code[20];
        ActualIsSubSubject: Boolean;
        HasIndividualPlan: Boolean;
        text009: Label 'Please select a column with a subject';
        ScholarshipReinforcement: Boolean;
        ScholarshipSupport: Boolean;
        text010: Label 'To set evaluations you need to set the Setting Moments for this school year(s).';
        [InDataSet]
        HasIndividualPlan1Editable: Boolean;
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
        ScholarshipReinforcement1Visib: Boolean;
        [InDataSet]
        ScholarshipSupport1Visible: Boolean;
        [InDataSet]
        HasIndividualPlan1Visible: Boolean;
        [InDataSet]
        Txt1Editable: Boolean;
        fRemarksWizard: Page "Remarks Wizard";

    //[Scope('OnPrem')]
    procedure getCaptionLabel(label: Integer) out: Text[30]
    begin

        exit(vArraySubject[label]);
    end;

    //[Scope('OnPrem')]
    procedure BuildMoments()
    var
        rStudySubSubjects: Record "Study Plan Sub-Subjects Lines";
        L_SRSSubjects: Record "Setting Ratings Sub-Subjects";
    begin


        Clear(vArraySubject);
        Clear(vArrayAssessmentType);
        Clear(vArrayAssessmentCode);
        Clear(vArraySubSubjects);
        indx := 0;

        rMomentsAssessment.Reset;
        rMomentsAssessment.SetRange("School Year", VarSchoolYear);
        rMomentsAssessment.SetRange("Schooling Year", varSchoolingYear);
        rMomentsAssessment.SetRange(Active, true);
        if rMomentsAssessment.FindFirst then;


        if VarType = VarType::Simple then begin
            rStudyPlanLines.Reset;
            rStudyPlanLines.SetRange(Code, VarStudyPlanCode);
            rStudyPlanLines.SetRange("School Year", VarSchoolYear);
            rStudyPlanLines.SetRange("Schooling Year", varSchoolingYear);
            rStudyPlanLines.SetRange("Subject Code", VarSubjects);
            if rStudyPlanLines.Find('-') then begin
                rSettingRatings.Reset;
                rSettingRatings.SetRange("Moment Code", rMomentsAssessment."Moment Code");
                rSettingRatings.SetRange("School Year", VarSchoolYear);
                rSettingRatings.SetRange("Schooling Year", varSchoolingYear);
                rSettingRatings.SetRange("Study Plan Code", VarStudyPlanCode);
                rSettingRatings.SetRange("Subject Code", rStudyPlanLines."Subject Code");
                if rSettingRatings.FindFirst then begin
                    indx := indx + 1;
                    vArraySubject[indx] := rStudyPlanLines."Subject Code";
                    vArrayAssessmentType[indx] := rStudyPlanLines."Evaluation Type";
                    vArrayAssessmentCode[indx] := rStudyPlanLines."Assessment Code";
                    vArrayObservationCode[indx] := rStudyPlanLines.Observations;
                end;
                if rStudyPlanLines.CalcFields("Sub-Subject") then begin

                    rStudySubSubjects.Reset;
                    rStudySubSubjects.SetRange(Type, rStudySubSubjects.Type::"Study Plan");
                    rStudySubSubjects.SetRange(Code, rStudyPlanLines.Code);
                    rStudySubSubjects.SetRange("Schooling Year", rStudyPlanLines."Schooling Year");
                    rStudySubSubjects.SetRange("Subject Code", rStudyPlanLines."Subject Code");
                    rStudySubSubjects.SetRange("School Year", rStudyPlanLines."School Year");
                    if rStudySubSubjects.Find('-') then begin
                        repeat
                            L_SRSSubjects.Reset;
                            L_SRSSubjects.SetRange("Moment Code", rMomentsAssessment."Moment Code");
                            L_SRSSubjects.SetRange("School Year", VarSchoolYear);
                            L_SRSSubjects.SetRange("Schooling Year", varSchoolingYear);
                            L_SRSSubjects.SetRange("Study Plan Code", VarStudyPlanCode);
                            L_SRSSubjects.SetRange("Subject Code", rStudySubSubjects."Subject Code");
                            L_SRSSubjects.SetRange("Sub-Subject Code", rStudySubSubjects."Sub-Subject Code");
                            L_SRSSubjects.SetRange("Type Education", L_SRSSubjects."Type Education"::Simple);
                            if L_SRSSubjects.FindFirst then begin
                                indx := indx + 1;
                                vArraySubject[indx] := rStudySubSubjects."Sub-Subject Code";
                                vArrayAssessmentType[indx] := rStudySubSubjects."Evaluation Type";
                                vArrayAssessmentCode[indx] := rStudySubSubjects."Assessment Code";
                                vArrayObservationCode[indx] := rStudySubSubjects.Observations;
                                vArraySubSubjects[indx] := true;

                            end;
                        until rStudySubSubjects.Next = 0;
                    end;
                end;
            end;
        end else begin
            rCourseLines.Reset;
            rCourseLines.SetRange(Code, VarStudyPlanCode);
            rCourseLines.SetRange("Subject Code", VarSubjects);
            if rCourseLines.Find('-') then begin
                rSettingRatings.Reset;
                rSettingRatings.SetRange("Moment Code", rMomentsAssessment."Moment Code");
                rSettingRatings.SetRange("School Year", VarSchoolYear);
                rSettingRatings.SetRange("Schooling Year", varSchoolingYear);
                rSettingRatings.SetRange("Study Plan Code", VarStudyPlanCode);
                rSettingRatings.SetRange("Subject Code", rCourseLines."Subject Code");
                if rSettingRatings.FindFirst then begin
                    indx := indx + 1;
                    vArraySubject[indx] := rCourseLines."Subject Code";
                    vArrayAssessmentType[indx] := rCourseLines."Evaluation Type";
                    vArrayAssessmentCode[indx] := rCourseLines."Assessment Code";
                    vArrayObservationCode[indx] := rCourseLines.Observations;
                end;
                if rCourseLines.CalcFields("Sub-Subject") then begin
                    rStudySubSubjects.Reset;
                    rStudySubSubjects.SetRange(Type, rStudySubSubjects.Type::Course);
                    rStudySubSubjects.SetRange(Code, rCourseLines.Code);
                    rStudySubSubjects.SetRange("Schooling Year", varSchoolingYear);
                    rStudySubSubjects.SetRange("Subject Code", rCourseLines."Subject Code");
                    if rStudySubSubjects.Find('-') then begin
                        repeat
                            L_SRSSubjects.Reset;
                            L_SRSSubjects.SetRange("Moment Code", rMomentsAssessment."Moment Code");
                            L_SRSSubjects.SetRange("School Year", VarSchoolYear);
                            L_SRSSubjects.SetRange("Schooling Year", varSchoolingYear);
                            L_SRSSubjects.SetRange("Study Plan Code", VarStudyPlanCode);
                            L_SRSSubjects.SetRange("Subject Code", rStudySubSubjects."Subject Code");
                            L_SRSSubjects.SetRange("Sub-Subject Code", rStudySubSubjects."Sub-Subject Code");
                            L_SRSSubjects.SetRange("Type Education", L_SRSSubjects."Type Education"::Multi);
                            if L_SRSSubjects.FindFirst then begin

                                indx := indx + 1;
                                vArraySubject[indx] := rStudySubSubjects."Sub-Subject Code";
                                vArrayAssessmentType[indx] := rStudySubSubjects."Evaluation Type";
                                vArrayAssessmentCode[indx] := rStudySubSubjects."Assessment Code";
                                vArraySubSubjects[indx] := true;
                                vArrayObservationCode[indx] := rStudySubSubjects.Observations;
                            end;
                        until rStudySubSubjects.Next = 0;
                    end;
                end;

            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure InsertAssessment(inStudentCode: Code[20]; inClassNo: Integer; inIndex: Integer; inText: Text[250])
    var
        rAssessingStudents: Record "Assessing Students";
    begin

        if vArraySubSubjects[inIndex] then begin
            rAssessingStudents.Reset;
            rAssessingStudents.SetRange("School Year", VarSchoolYear);
            rAssessingStudents.SetRange("Schooling Year", varSchoolingYear);
            rAssessingStudents.SetRange(Class, varClass);
            rAssessingStudents.SetRange(Subject, VarSubjects);
            rAssessingStudents.SetRange("Sub-Subject Code", vArraySubject[inIndex]);
            //rAssessingStudents.SETRANGE("Study Plan Code",VarStudyPlanCode);
            rAssessingStudents.SetRange("Student Code No.", inStudentCode);
            rAssessingStudents.SetRange("Moment Code", varActiveMoment);
            if rAssessingStudents.Find('-') then begin
                //IF rAssessingStudents.GET(varClass,VarSchoolYear,varSchoolingYear,VarSubjects,vArraySubject[inIndex],
                //                      VarStudyPlanCode,inStudentCode,varActiveMoment) THEN BEGIN
                //validate sub subject
                cCalcEvaluations.ValidateSubSettingRatting(rAssessingStudents);

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
                        if not Evaluate(rAssessingStudents.Grade, varClassification) then
                            rAssessingStudents.Grade := 0;
                        rAssessingStudents."Qualitative Grade" := inText;
                    end;

                end;
                rAssessingStudents."Has Individual Plan" := GetSpecialPlan(inStudentCode, 1);
                rAssessingStudents."Scholarship Reinforcement" := GetSpecialPlan(inStudentCode, 2);
                rAssessingStudents."Scholarship Support" := GetSpecialPlan(inStudentCode, 3);
                rAssessingStudents.Modify(true);
                // Calc Grade
                if (vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::Quantitative) or
                   (vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::"Mixed-Qualification") then
                    cCalcEvaluations.CalcSubSubject(rAssessingStudents, vArrayAssessmentCode[1]);

            end else begin
                rAssessingStudents.Init;
                rAssessingStudents.Class := varClass;
                rAssessingStudents."School Year" := VarSchoolYear;
                rAssessingStudents."Schooling Year" := varSchoolingYear;
                rAssessingStudents.Subject := VarSubjects;
                rAssessingStudents."Sub-Subject Code" := vArraySubject[inIndex];
                rAssessingStudents."Study Plan Code" := VarStudyPlanCode;
                rAssessingStudents."Student Code No." := inStudentCode;
                rAssessingStudents."Moment Code" := varActiveMoment;
                rAssessingStudents."Class No." := inClassNo;
                rAssessingStudents."Evaluation Moment" := varEvaluationType;
                rAssessingStudents."Type Education" := VarType;
                rAssessingStudents."Has Individual Plan" := GetSpecialPlan(inStudentCode, 1);
                rAssessingStudents."Scholarship Reinforcement" := GetSpecialPlan(inStudentCode, 2);
                rAssessingStudents."Scholarship Support" := GetSpecialPlan(inStudentCode, 3);
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
                //validate sub subject
                cCalcEvaluations.ValidateSubSettingRatting(rAssessingStudents);

                rAssessingStudents.Insert(true);
                // Calc Grade
                if (vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::Quantitative) or
                   (vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::"Mixed-Qualification") then
                    cCalcEvaluations.CalcSubSubject(rAssessingStudents, vArrayAssessmentCode[1]);

            end;
        end;

        if vArraySubSubjects[inIndex] = false then begin
            rAssessingStudents.Reset;
            rAssessingStudents.SetRange(Class, varClass);
            rAssessingStudents.SetRange("School Year", VarSchoolYear);
            rAssessingStudents.SetRange("Schooling Year", varSchoolingYear);
            rAssessingStudents.SetRange(Subject, VarSubjects);
            rAssessingStudents.SetRange("Sub-Subject Code", '');
            //rAssessingStudents.SETRANGE("Study Plan Code",VarStudyPlanCode);
            rAssessingStudents.SetRange("Student Code No.", inStudentCode);
            rAssessingStudents.SetRange("Moment Code", varActiveMoment);
            if rAssessingStudents.Find('-') then begin
                //IF rAssessingStudents.GET(varClass,VarSchoolYear,varSchoolingYear,VarSubjects,'',
                //                      VarStudyPlanCode,inStudentCode,varActiveMoment) THEN BEGIN
                //validate sub subject
                cCalcEvaluations.ValidateSettingRatting(rAssessingStudents);

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
                // Calc Grade
                if (vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::Quantitative) or
                   (vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::"Mixed-Qualification") then
                    cCalcEvaluations.CalcSubSubject(rAssessingStudents, vArrayAssessmentCode[1]);

            end else begin
                rAssessingStudents.Init;
                rAssessingStudents.Class := varClass;
                rAssessingStudents."School Year" := VarSchoolYear;
                rAssessingStudents."Schooling Year" := varSchoolingYear;
                rAssessingStudents.Subject := VarSubjects;
                rAssessingStudents."Study Plan Code" := VarStudyPlanCode;
                rAssessingStudents."Student Code No." := inStudentCode;
                rAssessingStudents."Moment Code" := varActiveMoment;
                rAssessingStudents."Class No." := inClassNo;
                rAssessingStudents."Evaluation Moment" := varEvaluationType;
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
                //validate sub subject
                cCalcEvaluations.ValidateSettingRatting(rAssessingStudents);

                rAssessingStudents.Insert(true);
                // Calc Grade
                if (vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::Quantitative) or
                   (vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::"Mixed-Qualification") then
                    cCalcEvaluations.CalcSubSubject(rAssessingStudents, vArrayAssessmentCode[1]);

            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure InsertIndividualPlan(inStudentCode: Code[20]; inValue: Boolean; InType: Integer)
    var
        rAssessingStudents: Record "Assessing Students";
    begin
        rAssessingStudents.Reset;
        //rAssessingStudents.SETRANGE(Class,varClass);
        rAssessingStudents.SetRange("School Year", VarSchoolYear);
        rAssessingStudents.SetRange("Schooling Year", varSchoolingYear);
        rAssessingStudents.SetRange(Subject, VarSubjects);
        rAssessingStudents.SetRange("Moment Code", varActiveMoment);
        rAssessingStudents.SetRange("Student Code No.", inStudentCode);
        if rAssessingStudents.Find('-') then begin
            case InType of
                1:
                    rAssessingStudents.ModifyAll("Has Individual Plan", inValue, true);
                2:
                    rAssessingStudents.ModifyAll("Scholarship Reinforcement", inValue, true);
                3:
                    rAssessingStudents.ModifyAll("Scholarship Support", inValue, true);
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure GetAssessment(inStudentCode: Code[20]; inClassNo: Integer; inIndex: Integer; inText: Text[250]) Out: Text[100]
    var
        rAssessingStudents: Record "Assessing Students";
    begin

        if vArraySubSubjects[inIndex] then begin
            rAssessingStudents.Reset;
            rAssessingStudents.SetRange(Class, varClass);
            rAssessingStudents.SetRange("School Year", VarSchoolYear);
            rAssessingStudents.SetRange("Schooling Year", varSchoolingYear);
            rAssessingStudents.SetRange(Subject, VarSubjects);
            rAssessingStudents.SetRange("Sub-Subject Code", vArraySubject[inIndex]);
            //rAssessingStudents.SETRANGE("Study Plan Code",VarStudyPlanCode);
            rAssessingStudents.SetRange("Student Code No.", inStudentCode);
            rAssessingStudents.SetRange("Moment Code", varActiveMoment);
            if rAssessingStudents.Find('-') then begin

                //IF rAssessingStudents.GET(varClass,VarSchoolYear,varSchoolingYear,VarSubjects,vArraySubject[inIndex],
                //                         VarStudyPlanCode,inStudentCode,varActiveMoment) THEN BEGIN

                if vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::Quantitative then
                    if rAssessingStudents.Grade = 0 then
                        exit('')
                    else
                        exit(Format(rAssessingStudents.Grade));

                if (vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::Qualitative) then
                    exit(rAssessingStudents."Qualitative Grade");

                if (vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::"Mixed-Qualification") then
                    if varMixedClassification then begin
                        if rAssessingStudents.Grade = 0 then
                            exit('')
                        else
                            exit(Format(rAssessingStudents.Grade))
                    end else
                        exit(rAssessingStudents."Qualitative Grade");


            end else
                exit('');
        end;
        if vArraySubSubjects[inIndex] = false then begin
            rAssessingStudents.Reset;
            rAssessingStudents.SetRange(Class, varClass);
            rAssessingStudents.SetRange("School Year", VarSchoolYear);
            rAssessingStudents.SetRange("Schooling Year", varSchoolingYear);
            rAssessingStudents.SetRange(Subject, VarSubjects);
            rAssessingStudents.SetRange("Sub-Subject Code", '');
            //rAssessingStudents.SETRANGE("Study Plan Code",VarStudyPlanCode);
            rAssessingStudents.SetRange("Student Code No.", inStudentCode);
            rAssessingStudents.SetRange("Moment Code", varActiveMoment);
            if rAssessingStudents.Find('-') then begin
                if vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::Quantitative then
                    if rAssessingStudents.Grade = 0 then
                        exit('')
                    else
                        exit(Format(rAssessingStudents.Grade));
                if (vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::Qualitative) then
                    exit(rAssessingStudents."Qualitative Grade");
                if (vArrayAssessmentType[inIndex] = vArrayAssessmentType[inIndex] ::"Mixed-Qualification") then
                    if varMixedClassification then begin
                        if rAssessingStudents.Grade = 0 then
                            exit('')
                        else
                            exit(Format(rAssessingStudents.Grade))
                    end else
                        exit(rAssessingStudents."Qualitative Grade");
            end else
                exit('');
        end;
    end;

    //[Scope('OnPrem')]
    procedure GetSpecialPlan(inStudentCode: Code[20]; InType: Integer): Boolean
    var
        rAssessingStudents: Record "Assessing Students";
    begin
        rAssessingStudents.Reset;
        rAssessingStudents.SetRange(Class, varClass);
        rAssessingStudents.SetRange("School Year", VarSchoolYear);
        rAssessingStudents.SetRange("Schooling Year", varSchoolingYear);
        rAssessingStudents.SetRange(Subject, VarSubjects);
        rAssessingStudents.SetRange("Moment Code", varActiveMoment);
        rAssessingStudents.SetRange("Student Code No.", inStudentCode);
        if rAssessingStudents.Find('-') then begin
            case InType of
                1:
                    exit(rAssessingStudents."Has Individual Plan");
                2:
                    exit(rAssessingStudents."Scholarship Reinforcement");
                3:
                    exit(rAssessingStudents."Scholarship Support");
            end;
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
            if vArraySubject[i] <> '' then
                vText[i] := GetAssessment(Rec."Student Code No.", Rec."Class No.", i, vText[i]);
            HasIndividualPlan := GetSpecialPlan(Rec."Student Code No.", 1);
            ScholarshipReinforcement := GetSpecialPlan(Rec."Student Code No.", 2);
            ScholarshipSupport := GetSpecialPlan(Rec."Student Code No.", 3);

        until i = 15;
    end;

    //[Scope('OnPrem')]
    procedure UpdateForm()
    begin
        BuildMoments;
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
            if rClassificationLevel.Find('-') then
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
                rClassificationLevel.SetFilter("Min Value", '<=%1', varClasification);
                rClassificationLevel.SetFilter("Max Value", '>=%1', varClasification);
                if not rClassificationLevel.Find('-') then
                    Error(text004, rClassificationLevel."Min Value", rClassificationLevel."Max Value")
                else
                    exit(varClasification);

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
                        Error(text004, VarMinValue, VarMaxValue);
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
                    Error(text005);

            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure EditableFuction()
    begin
        if (vArrayAssessmentType[1] <> vArrayAssessmentType[1] ::Qualitative) then begin
            if (vArraySubSubjects[2] = true) then
                Txt1Editable := false
            else
                Txt1Editable := true;
        end;

        if (vArraySubject[1] <> '') then
            Txt1Visible := true
        else
            Txt1Visible := false;

        if (vArraySubject[2] <> '') then
            Txt2Visible := true
        else
            Txt2Visible := false;

        if (vArraySubject[3] <> '') then
            Txt3Visible := true
        else
            Txt3Visible := false;

        if (vArraySubject[4] <> '') then
            Txt4Visible := true
        else
            Txt4Visible := false;

        if (vArraySubject[5] <> '') then
            Txt5Visible := true
        else
            Txt5Visible := false;

        if (vArraySubject[6] <> '') then
            Txt6Visible := true
        else
            Txt6Visible := false;

        if (vArraySubject[7] <> '') then
            Txt7Visible := true
        else
            Txt7Visible := false;

        if (vArraySubject[8] <> '') then
            Txt8Visible := true
        else
            Txt8Visible := false;

        if (vArraySubject[9] <> '') then
            Txt9Visible := true
        else
            Txt9Visible := false;

        if (vArraySubject[10] <> '') then
            Txt10Visible := true
        else
            Txt10Visible := false;

        if (vArraySubject[11] <> '') then
            Txt11Visible := true
        else
            Txt11Visible := false;

        if (vArraySubject[12] <> '') then
            Txt12Visible := true
        else
            Txt12Visible := false;

        if (vArraySubject[13] <> '') then
            Txt13Visible := true
        else
            Txt13Visible := false;

        if (vArraySubject[14] <> '') then
            Txt14Visible := true
        else
            Txt14Visible := false;

        if (vArraySubject[15] <> '') then
            Txt15Visible := true
        else
            Txt15Visible := false;


        rStructureEducationCountry.Reset;
        rStructureEducationCountry.SetRange(Country, rClass."Country/Region Code");
        rStructureEducationCountry.SetRange("Schooling Year", rClass."Schooling Year");
        if rStructureEducationCountry.Find('-') then begin
            if (rStructureEducationCountry."Edu. Level" = rStructureEducationCountry."Edu. Level"::"Pre-Primary Edu.") or
              (rStructureEducationCountry."Edu. Level" = rStructureEducationCountry."Edu. Level"::"Primary Edu.") then begin
                ScholarshipReinforcement1Visib := true;
                ScholarshipSupport1Visible := true;
                HasIndividualPlan1Visible := true;
            end else begin
                ScholarshipReinforcement1Visib := false;
                ScholarshipSupport1Visible := false;
                HasIndividualPlan1Visible := true;
            end;
        end;
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
                    if not IsGlobal then begin
                        l_rRemarks.SetRange(Subject, VarSubjects);
                        if ActualIsSubSubject then
                            l_rRemarks.SetRange("Sub-subject", ActualSubSubject)
                        else
                            l_rRemarks.SetRange("Sub-subject", '');
                    end else begin
                        l_rRemarks.SetRange(Subject, '');
                        l_rRemarks.SetRange("Sub-subject", '');
                    end;
                    if l_rRemarks.Find('-') then
                        ExitValue := true;
                end;
            until l_rMomentsAssessment.Next = 0;
        end;

        exit(ExitValue);
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
    procedure HasClassification(): Boolean
    var
        rAssessingStudents: Record "Assessing Students";
    begin
        rAssessingStudents.Reset;
        rAssessingStudents.SetRange(Class, varClass);
        rAssessingStudents.SetRange("School Year", VarSchoolYear);
        rAssessingStudents.SetRange("Schooling Year", varSchoolingYear);
        rAssessingStudents.SetRange(Subject, VarSubjects);
        rAssessingStudents.SetRange("Moment Code", varActiveMoment);
        if rAssessingStudents.Find('-') then
            exit(true)
        else
            exit(false);
    end;

    local procedure VarSubjectsOnAfterValidate()
    begin
        UpdateForm;
        CurrPage.Update(true);
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

    local procedure vText1OnActivate()
    begin
        ActualObservationCode := vArrayObservationCode[1];
        ActualSubSubject := vArraySubject[1];
        ActualIsSubSubject := vArraySubSubjects[1];
        ExistCommentsSubjects := UpdateCommentsVAR(false);
        CurrPage.Update(false);
    end;

    local procedure vText2OnActivate()
    begin
        ActualObservationCode := vArrayObservationCode[2];
        ActualSubSubject := vArraySubject[2];
        ActualIsSubSubject := vArraySubSubjects[2];
        ExistCommentsSubjects := UpdateCommentsVAR(false);
        CurrPage.Update(false);
    end;

    local procedure vText3OnActivate()
    begin
        ActualObservationCode := vArrayObservationCode[3];
        ActualSubSubject := vArraySubject[3];
        ActualIsSubSubject := vArraySubSubjects[3];
        ExistCommentsSubjects := UpdateCommentsVAR(false);
        CurrPage.Update(false);
    end;

    local procedure vText4OnActivate()
    begin
        ActualObservationCode := vArrayObservationCode[4];
        ActualSubSubject := vArraySubject[4];
        ActualIsSubSubject := vArraySubSubjects[4];
        ExistCommentsSubjects := UpdateCommentsVAR(false);
        CurrPage.Update(false);
    end;

    local procedure vText5OnActivate()
    begin
        ActualObservationCode := vArrayObservationCode[5];
        ActualSubSubject := vArraySubject[5];
        ActualIsSubSubject := vArraySubSubjects[5];
        ExistCommentsSubjects := UpdateCommentsVAR(false);
        CurrPage.Update(false);
    end;

    local procedure vText6OnActivate()
    begin
        ActualObservationCode := vArrayObservationCode[6];
        ActualSubSubject := vArraySubject[6];
        ActualIsSubSubject := vArraySubSubjects[6];
        ExistCommentsSubjects := UpdateCommentsVAR(false);
        CurrPage.Update(false);
    end;

    local procedure vText7OnActivate()
    begin
        ActualObservationCode := vArrayObservationCode[7];
        ActualSubSubject := vArraySubject[7];
        ActualIsSubSubject := vArraySubSubjects[7];
        ExistCommentsSubjects := UpdateCommentsVAR(false);
        CurrPage.Update(false);
    end;

    local procedure vText8OnActivate()
    begin
        ActualObservationCode := vArrayObservationCode[8];
        ActualSubSubject := vArraySubject[8];
        ActualIsSubSubject := vArraySubSubjects[8];
        ExistCommentsSubjects := UpdateCommentsVAR(false);
        CurrPage.Update(false);
    end;

    local procedure vText9OnActivate()
    begin
        ActualObservationCode := vArrayObservationCode[9];
        ActualSubSubject := vArraySubject[9];
        ActualIsSubSubject := vArraySubSubjects[9];
        ExistCommentsSubjects := UpdateCommentsVAR(false);
        CurrPage.Update(false);
    end;

    local procedure vText10OnActivate()
    begin
        ActualObservationCode := vArrayObservationCode[10];
        ActualSubSubject := vArraySubject[10];
        ActualIsSubSubject := vArraySubSubjects[10];
        ExistCommentsSubjects := UpdateCommentsVAR(false);
        CurrPage.Update(false);
    end;

    local procedure vText11OnActivate()
    begin
        ActualObservationCode := vArrayObservationCode[11];
        ActualSubSubject := vArraySubject[11];
        ActualIsSubSubject := vArraySubSubjects[11];
        ExistCommentsSubjects := UpdateCommentsVAR(false);
        CurrPage.Update(false);
    end;

    local procedure vText12OnActivate()
    begin
        ActualObservationCode := vArrayObservationCode[12];
        ActualSubSubject := vArraySubject[12];
        ActualIsSubSubject := vArraySubSubjects[12];
        ExistCommentsSubjects := UpdateCommentsVAR(false);
        CurrPage.Update(false);
    end;

    local procedure vText13OnActivate()
    begin
        ActualObservationCode := vArrayObservationCode[13];
        ActualSubSubject := vArraySubject[13];
        ActualIsSubSubject := vArraySubSubjects[13];
        ExistCommentsSubjects := UpdateCommentsVAR(false);
        CurrPage.Update(false);
    end;

    local procedure vText14OnActivate()
    begin
        ActualObservationCode := vArrayObservationCode[14];
        ActualSubSubject := vArraySubject[14];
        ActualIsSubSubject := vArraySubSubjects[14];
        ExistCommentsSubjects := UpdateCommentsVAR(false);
        CurrPage.Update(false);
    end;

    local procedure vText15OnActivate()
    begin
        ActualObservationCode := vArrayObservationCode[15];
        ActualSubSubject := vArraySubject[15];
        ActualIsSubSubject := vArraySubSubjects[15];
        ExistCommentsSubjects := UpdateCommentsVAR(false);
        CurrPage.Update(false);
    end;

    local procedure varMixedClassificationOnPush()
    begin
        CurrPage.Update;
    end;
}

