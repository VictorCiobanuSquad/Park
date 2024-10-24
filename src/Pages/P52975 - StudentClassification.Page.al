#pragma implicitwith disable
page 52975 "Student Classification"
{
    Caption = 'Student Classification';
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
                field(varSchoolYear; varSchoolYear)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'School Year';
                    TableRelation = "School Year"."School Year";

                    trigger OnValidate()
                    begin
                        Clear(Rec);
                        varSchoolYearOnAfterValidate;
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
                field("Student Code No."; Rec."Student Code No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("rStudents.Name"; rStudents.Name)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Enabled = false;
                }
            }
            repeater(Tablebox1)
            {
                IndentationColumn = TextIndent;
                IndentationControls = Class;
                ShowAsTree = true;
                field(Class; Rec.Class)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Class No."; Rec."Class No.")
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

                    trigger OnValidate()
                    begin
                        vText1OnAfterValidate;
                    end;
                }
                field(Txt2; vText[2])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(2);
                    Editable = Txt2Editable;
                    Visible = Txt2Visible;

                    trigger OnValidate()
                    begin
                        vText2OnAfterValidate;
                    end;
                }
                field(Txt3; vText[3])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(3);
                    Editable = Txt3Editable;
                    Visible = Txt3Visible;

                    trigger OnValidate()
                    begin
                        vText3OnAfterValidate;
                    end;
                }
                field(Txt4; vText[4])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(4);
                    Editable = Txt4Editable;
                    Visible = Txt4Visible;

                    trigger OnValidate()
                    begin
                        vText4OnAfterValidate;
                    end;
                }
                field(Txt5; vText[5])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(5);
                    Editable = Txt5Editable;
                    Visible = Txt5Visible;

                    trigger OnValidate()
                    begin
                        vText5OnAfterValidate;
                    end;
                }
                field(Txt6; vText[6])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(6);
                    Editable = Txt6Editable;
                    Visible = Txt6Visible;

                    trigger OnValidate()
                    begin
                        vText6OnAfterValidate;
                    end;
                }
                field(Txt7; vText[7])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(7);
                    Editable = Txt7Editable;
                    Visible = Txt7Visible;

                    trigger OnValidate()
                    begin
                        vText7OnAfterValidate;
                    end;
                }
                field(Txt8; vText[8])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(8);
                    Editable = Txt8Editable;
                    Visible = Txt8Visible;

                    trigger OnValidate()
                    begin
                        vText8OnAfterValidate;
                    end;
                }
                field(Txt9; vText[9])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(9);
                    Editable = Txt9Editable;
                    Visible = Txt9Visible;

                    trigger OnValidate()
                    begin
                        vText9OnAfterValidate;
                    end;
                }
                field(Txt10; vText[10])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(10);
                    Editable = Txt10Editable;
                    Visible = Txt10Visible;

                    trigger OnValidate()
                    begin
                        vText10OnAfterValidate;
                    end;
                }
                field(Txt11; vText[11])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(11);
                    Editable = Txt11Editable;
                    Visible = Txt11Visible;

                    trigger OnValidate()
                    begin
                        vText11OnAfterValidate;
                    end;
                }
                field(Txt12; vText[12])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(12);
                    Editable = Txt12Editable;
                    Visible = Txt12Visible;

                    trigger OnValidate()
                    begin
                        vText12OnAfterValidate;
                    end;
                }
                field(Txt13; vText[13])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(13);
                    Editable = Txt13Editable;
                    Visible = Txt13Visible;

                    trigger OnValidate()
                    begin
                        vText13OnAfterValidate;
                    end;
                }
                field(Txt14; vText[14])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(14);
                    Editable = Txt14Editable;
                    Visible = Txt14Visible;

                    trigger OnValidate()
                    begin
                        vText14OnAfterValidate;
                    end;
                }
                field(Txt15; vText[15])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(15);
                    Editable = Txt15Editable;
                    Visible = Txt15Visible;

                    trigger OnValidate()
                    begin
                        vText15OnAfterValidate;
                    end;
                }
                field(Bookterms; vTermsBook)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Term Book';
                    Editable = BooktermsEditable;
                    Visible = BooktermsVisible;

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
                    Visible = SheetTermsVisible;

                    trigger OnValidate()
                    begin
                        InsertTerms(vTermsBook, vTermsSheet);
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
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction()
                var
                    l_Class: Record Class;
                begin

                    if l_Class.Get(Rec.Class, varSchoolYear) then;

                    fRemarksWizard.GetMomentInformation(varSelectedMoment);

                    varTypeButtonEdit := false;
                    fRemarksWizard.GetInformation(Rec."Student Code No.", varSchoolYear, Rec.Class, Rec."Schooling Year", l_Class."Study Plan Code", '', '',
                                                   Rec."Class No.", l_Class.Type, varTypeButtonEdit);
                    fRemarksWizard.Run;
                end;
            }
            action("&Remarks")
            {
                ApplicationArea = All;
                Caption = '&Remarks';
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction()
                var
                    l_class: Record Class;
                begin
                    if l_class.Get(Rec.Class, varSchoolYear) then;

                    Clear(fRemarksWizard);
                    fRemarksWizard.GetMomentInformation(varSelectedMoment);

                    varTypeButtonEdit := false;
                    fRemarksWizard.GetInformation(Rec."Student Code No.", varSchoolYear, Rec.Class, Rec."Schooling Year", l_class."Study Plan Code", Rec."Subject Code",
                                      Rec."Sub-Subject Code", Rec."Class No.", l_class.Type, varTypeButtonEdit);
                    fRemarksWizard.Run;
                end;
            }
            action("&Observações")
            {
                ApplicationArea = All;
                Caption = '&Observações';
                Image = Setup;

                trigger OnAction()
                var
                    l_class: Record Class;
                    NavNotePad: Page "Nav NotePad";
                begin
                    if l_class.Get(Rec.Class, varSchoolYear) then;
                    Clear(NavNotePad);
                    NavNotePad.SendObservation(Rec."Student Code No.", varSchoolYear, Rec.Class, Rec."Schooling Year", l_class."Study Plan Code", Rec."Subject Code", Rec."Sub-Subject Code",
                    Rec."Class No.", l_class.Type, varSelectedMoment);
                    NavNotePad.Run;
                end;
            }
            action("&Observações Globais")
            {
                ApplicationArea = All;
                Caption = '&Observações Globais';
                Image = SetupList;

                trigger OnAction()
                var
                    l_class: Record Class;
                    NavNotePad: Page "Nav NotePad";
                begin
                    if l_class.Get(Rec.Class, varSchoolYear) then;
                    Clear(NavNotePad);
                    NavNotePad.SendObservation(Rec."Student Code No.", varSchoolYear, Rec.Class, Rec."Schooling Year", l_class."Study Plan Code", '', '',
                    Rec."Class No.", l_class.Type, '');
                    NavNotePad.Run;
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
                    Image = CloseDocument;

                    trigger OnAction()
                    begin
                        InitTempTable;
                    end;
                }
            }
            action("&Print")
            {
                ApplicationArea = All;
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
        ClassNoOnFormat;
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
        InsertStudents;
        InitTempTable;
        UpdateForm;
        ShowHideTerms;
    end;

    var
        BufferAssignAssessments: Record "Assign Assessments Buffer" temporary;
        rStudyPlanLines: Record "Study Plan Lines";
        rSettingRatingsSubSubjects: Record "Setting Ratings Sub-Subjects";
        rRankGroup: Record "Rank Group";
        cStudentsRegistration: Codeunit "Students Registration";
        rCourseLinesTEMP: Record "Course Lines" temporary;
        rCourseLinesTEMP2: Record "Course Lines" temporary;
        rCourseLines: Record "Course Lines";
        rStruEduCountry: Record "Structure Education Country";
        l_rStruEduCountry: Record "Structure Education Country";
        cUserEducation: Codeunit "User Education";
        rMomentsAssessment: Record "Moments Assessment";
        ActualExpansionStatus: BigInteger;
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
        rAssessingStudentsTEMP: Record "Assessing Students" temporary;
        [InDataSet]
        "Class No.Emphasize": Boolean;
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
        [InDataSet]
        BooktermsVisible: Boolean;
        [InDataSet]
        SheetTermsVisible: Boolean;
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
        //BufferAssignAssessments.SETRANGE(BufferAssignAssessments."Class No.",ActualAssess."Class No.");
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


    procedure BuildMoments()
    var
        varMomentCode: Code[20];
    begin

        Clear(vArrayMomento);
        Clear(vArrayCodMomento);
        Clear(vArrayType);
        indx := 0;
        rAssessingStudents.Reset;
        rAssessingStudents.SetCurrentKey("Student Code No.", "School Year", "Moment Code");
        rAssessingStudents.SetRange("Student Code No.", varStudent);
        rAssessingStudents.SetRange("School Year", varSchoolYear);
        //rAssessingStudents.SETRANGE("Schooling Year","Schooling Year");
        if rAssessingStudents.FindSet then begin
            repeat
                if varMomentCode <> rAssessingStudents."Moment Code" then begin
                    rMomentsAssessment.Reset;
                    rMomentsAssessment.SetRange("Moment Code", rAssessingStudents."Moment Code");
                    rMomentsAssessment.SetRange("School Year", rAssessingStudents."School Year");
                    rMomentsAssessment.SetRange("Schooling Year", rAssessingStudents."Schooling Year");
                    rMomentsAssessment.SetRange("Responsibility Center", varRespCenter);
                    if rMomentsAssessment.FindFirst then begin
                        if rMomentsAssessment."Sorting ID" = 0 then
                            Error(text0017, rMomentsAssessment."Moment Code", rMomentsAssessment."Schooling Year", rMomentsAssessment."School Year");
                        if rMomentsAssessment."Sorting ID" > indx then
                            indx := rMomentsAssessment."Sorting ID";
                        if rMomentsAssessment.Description = '' then
                            vArrayMomento[rMomentsAssessment."Sorting ID"] := rMomentsAssessment."Moment Code"
                        else
                            vArrayMomento[rMomentsAssessment."Sorting ID"] := rMomentsAssessment.Description;

                        varMomentCode := rAssessingStudents."Moment Code";
                        vArrayCodMomento[rMomentsAssessment."Sorting ID"] := rAssessingStudents."Moment Code";
                        vArrayType[rMomentsAssessment."Sorting ID"] := rAssessingStudents."Evaluation Moment";
                    end else begin
                        indx := indx + 1;
                        varMomentCode := rAssessingStudents."Moment Code";
                        vArrayMomento[indx] := rAssessingStudents."Moment Code";
                        vArrayCodMomento[indx] := rAssessingStudents."Moment Code";
                        vArrayType[indx] := rAssessingStudents."Evaluation Moment";

                    end;
                end;
            until rAssessingStudents.Next = 0;
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
            end;
            if rStruEduCountry."Final Stage Caption" <> '' then begin
                indx := indx + 1;
                vArrayCodMomento[indx] := rStruEduCountry."Schooling Year";
                vArrayMomento[indx] := rStruEduCountry."Final Stage Caption";
                VarFinalType[indx] := VarFinalType::"Final Stage";
            end;
        end;
    end;


    procedure UpdateForm()
    begin
        BuildMoments;
    end;


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


    procedure getCaptionLabel(label: Integer) out: Text[30]
    begin

        exit(vArrayMomento[label]);
    end;


    procedure GetAssessment(inStudentCode: Code[20]; inClassNo: Integer; inIndex: Integer; inText: Text[250]; inSubSubjCode: Code[20]) Out: Text[100]
    var
        rAssessingStudents: Record "Assessing Students";
        l_FinalAssessingStudents: Record "Assessing Students Final";
    begin
        GetRegistrationAproved(false);
        if (Rec."Option Type" = Rec."Option Type"::"Option Group") or (Rec."Option Type" = Rec."Option Type"::"Schooling Year") then begin
            if (Rec."Option Type" = Rec."Option Type"::"Option Group") and (vArrayType[inIndex] = vArrayType[inIndex] ::" ") and
              (VarFinalType[inIndex] <> VarFinalType[inIndex] ::" ") then
                exit('');


            l_FinalAssessingStudents.Reset;
            l_FinalAssessingStudents.SetRange(Class, Rec.Class);
            l_FinalAssessingStudents.SetRange("School Year", varSchoolYear);
            l_FinalAssessingStudents.SetRange("Student Code No.", Rec."Student Code No.");

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
            //

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

            //

            if l_FinalAssessingStudents.FindSet then begin
                repeat
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
                until l_FinalAssessingStudents.Next = 0;
            end else
                exit('');
        end;
        if (Rec."Option Type" = Rec."Option Type"::Subjects) or (Rec."Option Type" = Rec."Option Type"::"Sub-Subjects") then begin
            rAssessingStudents.Reset;
            rAssessingStudents.SetFilter(Class, Rec.Class);
            rAssessingStudents.SetFilter("School Year", varSchoolYear);
            rAssessingStudents.SetFilter("Schooling Year", Rec."Schooling Year");
            rAssessingStudents.SetFilter(Subject, Rec."Subject Code");
            if Rec."Option Type" = Rec."Option Type"::"Sub-Subjects" then
                rAssessingStudents.SetRange("Sub-Subject Code", Rec."Sub-Subject Code");
            if Rec."Option Type" = Rec."Option Type"::Subjects then
                rAssessingStudents.SetRange("Sub-Subject Code", '');
            rAssessingStudents.SetFilter("Student Code No.", Rec."Student Code No.");
            rAssessingStudents.SetFilter("Moment Code", vArrayCodMomento[inIndex]);
            if rAssessingStudents.FindFirst then begin
                if (rAssessingStudents."Qualitative Grade" <> '') and (rAssessingStudents.Grade <> 0) then begin
                    if varMixedClassification then begin
                        if (rAssessingStudents."Recuperation Qualitative Grade" <> '') and (rAssessingStudents."Recuperation Grade" <> 0) then
                            exit(Format(rAssessingStudents."Recuperation Grade"))
                        else begin
                            if rAssessingStudents.Grade <> 0 then
                                exit(Format(rAssessingStudents.Grade))
                            else
                                exit(Format(rAssessingStudents."Grade Calc"));
                        end;
                    end else
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
                    else begin
                        if rAssessingStudents.Grade <> 0 then
                            exit(Format(rAssessingStudents.Grade))
                        else
                            exit(Format(rAssessingStudents."Grade Calc"));
                    end;
                end;
                if (rAssessingStudents."Qualitative Grade" = '') and (rAssessingStudents."Grade Calc" <> 0) then begin
                    if (rAssessingStudents."Recuperation Qualitative Grade" = '') and (rAssessingStudents."Recuperation Grade" <> 0) then
                        exit(Format(rAssessingStudents."Recuperation Grade"))
                    else begin
                        if rAssessingStudents.Grade <> 0 then
                            exit(Format(rAssessingStudents.Grade))
                        else
                            exit(Format(rAssessingStudents."Grade Calc"));
                    end;
                end;
            end else
                exit('');
        end;
    end;


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


    procedure DeleteBuffer()
    begin
        BufferAssignAssessments.Reset;
        BufferAssignAssessments.DeleteAll;
    end;


    procedure InsertStudents()
    var
        l_Students: Record Students;
        l_RegistrationSubjects: Record "Registration Subjects";
        l_StudentSubSubjects: Record "Student Sub-Subjects Plan ";
        l_RegistrationSubjects2: Record "Registration Subjects";
        l_GroupSubjects: Record "Group Subjects";
    begin
        DeleteBuffer;

        VarlineNo := 0;

        rRegistration.Reset;
        rRegistration.SetRange("Student Code No.", varStudent);
        rRegistration.SetRange("School Year", varSchoolYear);
        rRegistration.SetFilter(Class, '<>%1', '');
        rRegistration.SetFilter(Status, '<>%1', rRegistration.Status::" ");
        if rRegistration.FindFirst then begin
            varRespCenter := rRegistration."Responsibility Center";
            l_RegistrationSubjects.Reset;
            l_RegistrationSubjects.SetCurrentKey("School Year", "Schooling Year", "Option Group");
            l_RegistrationSubjects.SetRange("Student Code No.", rRegistration."Student Code No.");
            l_RegistrationSubjects.SetRange("School Year", rRegistration."School Year");
            l_RegistrationSubjects.SetFilter(Status, '<>%1', l_RegistrationSubjects.Status::" ");
            l_RegistrationSubjects.SetRange("Responsibility Center", rRegistration."Responsibility Center");
            l_RegistrationSubjects.SetFilter("Evaluation Type", '<>%1', l_RegistrationSubjects."Evaluation Type"::"None Qualification");
            if l_RegistrationSubjects.FindSet then begin
                repeat
                    BufferAssignAssessments.Reset;
                    BufferAssignAssessments.SetRange("User ID", UserId);
                    BufferAssignAssessments.SetRange("Student Code No.", l_RegistrationSubjects."Student Code No.");
                    BufferAssignAssessments.SetRange("Option Type", BufferAssignAssessments."Option Type"::"Schooling Year");
                    BufferAssignAssessments.SetRange("Schooling Year", l_RegistrationSubjects."Schooling Year");
                    if not BufferAssignAssessments.FindFirst then begin

                        BufferAssignAssessments.Init;
                        BufferAssignAssessments."User ID" := UserId;
                        VarlineNo += 10000;
                        BufferAssignAssessments."Line No." := VarlineNo;
                        BufferAssignAssessments."Student Code No." := l_RegistrationSubjects."Student Code No.";
                        BufferAssignAssessments.Level := 1;
                        BufferAssignAssessments."Option Type" := BufferAssignAssessments."Option Type"::"Schooling Year";
                        BufferAssignAssessments."Schooling Year" := l_RegistrationSubjects."Schooling Year";
                        BufferAssignAssessments.Class := l_RegistrationSubjects.Class;
                        BufferAssignAssessments."Class No." := l_RegistrationSubjects."Class No.";
                        BufferAssignAssessments.Insert;
                    end;

                    if l_RegistrationSubjects."Option Group" = '' then begin

                        ValidateClassTransfer(l_RegistrationSubjects, 2);

                        BufferAssignAssessments.Reset;
                        BufferAssignAssessments.Init;
                        BufferAssignAssessments."User ID" := UserId;
                        VarlineNo += 10000;
                        BufferAssignAssessments."Line No." := VarlineNo;
                        BufferAssignAssessments."Student Code No." := l_RegistrationSubjects."Student Code No.";
                        BufferAssignAssessments."Class No." := l_RegistrationSubjects."Class No.";
                        BufferAssignAssessments."Subject Code" := l_RegistrationSubjects."Subjects Code";
                        BufferAssignAssessments.Text := l_RegistrationSubjects.Description;
                        BufferAssignAssessments.Level := 2;

                        BufferAssignAssessments."Option Type" := BufferAssignAssessments."Option Type"::Subjects;
                        BufferAssignAssessments."Schooling Year" := l_RegistrationSubjects."Schooling Year";
                        BufferAssignAssessments.Class := l_RegistrationSubjects.Class;
                        BufferAssignAssessments.Insert;

                        l_RegistrationSubjects.CalcFields("Sub-subject");

                        if l_RegistrationSubjects."Sub-subject" then begin
                            l_StudentSubSubjects.Reset;
                            l_StudentSubSubjects.SetRange("Student Code No.", rRegistration."Student Code No.");
                            l_StudentSubSubjects.SetRange("Subject Code", l_RegistrationSubjects."Subjects Code");
                            l_StudentSubSubjects.SetRange("Schooling Year", l_RegistrationSubjects."Schooling Year");
                            l_StudentSubSubjects.SetRange("Responsibility Center", rRegistration."Responsibility Center");
                            l_StudentSubSubjects.SetRange(Type, l_RegistrationSubjects.Type);
                            l_StudentSubSubjects.SetFilter("Evaluation Type", '<>%1', l_StudentSubSubjects."Evaluation Type"::"None Qualification");
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
                                    BufferAssignAssessments."Schooling Year" := l_RegistrationSubjects."Schooling Year";
                                    BufferAssignAssessments.Class := l_RegistrationSubjects.Class;
                                    BufferAssignAssessments.Insert;

                                until l_StudentSubSubjects.Next = 0;
                            end;
                        end;
                    end else begin
                        //OPTION GROUP
                        BufferAssignAssessments.Reset;
                        BufferAssignAssessments.SetRange("Student Code No.", l_RegistrationSubjects."Student Code No.");
                        BufferAssignAssessments.SetRange("Schooling Year", l_RegistrationSubjects."Schooling Year");
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
                            BufferAssignAssessments."Schooling Year" := l_RegistrationSubjects."Schooling Year";
                            BufferAssignAssessments.Class := l_RegistrationSubjects.Class;

                            BufferAssignAssessments.Insert;

                            l_RegistrationSubjects2.Reset;
                            l_RegistrationSubjects2.SetCurrentKey("Student Code No.", "Option Group", "Sorting ID");
                            l_RegistrationSubjects2.SetRange("Student Code No.", rRegistration."Student Code No.");
                            l_RegistrationSubjects2.SetRange("School Year", rRegistration."School Year");
                            l_RegistrationSubjects2.SetRange("Schooling Year", l_RegistrationSubjects."Schooling Year");
                            l_RegistrationSubjects2.SetRange("Option Group", l_RegistrationSubjects."Option Group");
                            l_RegistrationSubjects2.SetFilter(Status, '<>%1', l_RegistrationSubjects2.Status::" ");
                            l_RegistrationSubjects2.SetRange("Responsibility Center", rRegistration."Responsibility Center");
                            l_RegistrationSubjects2.SetFilter("Evaluation Type", '<>%1',
                            l_RegistrationSubjects2."Evaluation Type"::"None Qualification");
                            if l_RegistrationSubjects2.FindSet then begin
                                repeat
                                    ValidateClassTransfer(l_RegistrationSubjects2, 3);

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
                                    BufferAssignAssessments."Schooling Year" := l_RegistrationSubjects2."Schooling Year";
                                    BufferAssignAssessments.Class := l_RegistrationSubjects2.Class;
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
                                                BufferAssignAssessments."Schooling Year" := l_RegistrationSubjects2."Schooling Year";
                                                BufferAssignAssessments.Class := l_RegistrationSubjects2.Class;
                                                BufferAssignAssessments.Insert;

                                            until l_StudentSubSubjects.Next = 0;
                                        end;
                                    end;
                                until l_RegistrationSubjects2.Next = 0;
                            end;
                        end;


                    end;
                //end option
                until l_RegistrationSubjects.Next = 0;

                //for students with subjects of past years
                l_RegistrationSubjects.Reset;
                l_RegistrationSubjects.SetCurrentKey("Student Code No.", "Option Group", "Sorting ID");
                l_RegistrationSubjects.SetRange("School Year", varSchoolYear);
                l_RegistrationSubjects.SetRange("Study Plan Code", varStudyPlanCode);
                l_RegistrationSubjects.SetRange("Schooling Year", varSchoolingYear);
                if varClass <> '' then
                    l_RegistrationSubjects.SetRange(Class, varClass);
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
                            l_RegistrationSubjects2.SetFilter("Evaluation Type", '<>%1',
                               l_RegistrationSubjects2."Evaluation Type"::"None Qualification");
                            if l_RegistrationSubjects2.FindSet then begin
                                BufferAssignAssessments.Reset;
                                BufferAssignAssessments.Init;
                                BufferAssignAssessments.Class := rRegistration.Class;
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
                                    BufferAssignAssessments.Class := rRegistration.Class;
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
                                        l_StudentSubSubjects.SetFilter("Evaluation Type", '<>%1',
                                           l_StudentSubSubjects."Evaluation Type"::"None Qualification");
                                        if l_StudentSubSubjects.FindSet then begin
                                            repeat
                                                BufferAssignAssessments.Reset;
                                                BufferAssignAssessments.Init;
                                                BufferAssignAssessments."User ID" := UserId;
                                                VarlineNo += 10000;
                                                BufferAssignAssessments.Class := rRegistration.Class;
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
        end else begin
            GetMultiplePE;
            GetStudyPlan;

        end;
    end;


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


    procedure ValidateClassTransfer(pRegistrationSubjects: Record "Registration Subjects"; pLevel: Integer)
    var
        l_StudentSubjectsEntry: Record "Student Subjects Entry";
        l_AssessingStudents: Record "Assessing Students";
        l_StudentSubSubjects: Record "Student Sub-Subjects Plan ";
    begin


        l_StudentSubjectsEntry.Reset;
        l_StudentSubjectsEntry.SetRange("Student Code No.", pRegistrationSubjects."Student Code No.");
        l_StudentSubjectsEntry.SetRange("School Year", varSchoolYear);
        l_StudentSubjectsEntry.SetRange("Schooling Year", pRegistrationSubjects."Schooling Year");
        l_StudentSubjectsEntry.SetRange("Study Plan Code", pRegistrationSubjects."Study Plan Code");
        l_StudentSubjectsEntry.SetRange(Status, l_StudentSubjectsEntry.Status::Transfer);
        l_StudentSubjectsEntry.SetFilter(Class, '<>%1', pRegistrationSubjects.Class);
        l_StudentSubjectsEntry.SetRange("Subjects Code", pRegistrationSubjects."Subjects Code");
        if l_StudentSubjectsEntry.FindSet then begin
            l_AssessingStudents.Reset;
            l_AssessingStudents.SetRange(Class, l_StudentSubjectsEntry.Class);
            l_AssessingStudents.SetRange("School Year", l_StudentSubjectsEntry."School Year");
            l_AssessingStudents.SetRange("Schooling Year", l_StudentSubjectsEntry."Schooling Year");
            l_AssessingStudents.SetRange(Subject, l_StudentSubjectsEntry."Subjects Code");
            l_AssessingStudents.SetRange("Student Code No.", l_StudentSubjectsEntry."Student Code No.");
            if l_AssessingStudents.FindFirst then begin
                BufferAssignAssessments.Reset;
                BufferAssignAssessments.Init;
                BufferAssignAssessments."User ID" := UserId;
                VarlineNo += 10000;
                BufferAssignAssessments."Line No." := VarlineNo;
                BufferAssignAssessments."Student Code No." := pRegistrationSubjects."Student Code No.";
                BufferAssignAssessments."Class No." := l_StudentSubjectsEntry."Class No.";
                BufferAssignAssessments."Subject Code" := pRegistrationSubjects."Subjects Code";
                BufferAssignAssessments.Text := pRegistrationSubjects.Description;
                BufferAssignAssessments.Level := pLevel;
                BufferAssignAssessments."Option Type" := BufferAssignAssessments."Option Type"::Subjects;
                BufferAssignAssessments."Schooling Year" := pRegistrationSubjects."Schooling Year";
                BufferAssignAssessments.Class := l_StudentSubjectsEntry.Class;
                BufferAssignAssessments."Class No." := l_AssessingStudents."Class No.";
                BufferAssignAssessments.Insert;
                //SUBSUbject

                pRegistrationSubjects.CalcFields("Sub-subject");
                if pRegistrationSubjects."Sub-subject" then begin
                    l_StudentSubSubjects.Reset;
                    l_StudentSubSubjects.SetRange("Student Code No.", pRegistrationSubjects."Student Code No.");
                    l_StudentSubSubjects.SetRange("School Year", pRegistrationSubjects."School Year");
                    l_StudentSubSubjects.SetRange("Subject Code", pRegistrationSubjects."Subjects Code");
                    l_StudentSubSubjects.SetRange(Code, pRegistrationSubjects."Study Plan Code");
                    l_StudentSubSubjects.SetRange("Schooling Year", pRegistrationSubjects."Schooling Year");
                    l_StudentSubSubjects.SetRange("Responsibility Center", pRegistrationSubjects."Responsibility Center");
                    l_StudentSubSubjects.SetRange(Type, pRegistrationSubjects.Type);
                    if l_StudentSubSubjects.FindSet then begin
                        repeat
                            BufferAssignAssessments.Reset;
                            BufferAssignAssessments.Init;
                            BufferAssignAssessments."User ID" := UserId;
                            VarlineNo += 10000;
                            BufferAssignAssessments."Line No." := VarlineNo;
                            BufferAssignAssessments."Student Code No." := pRegistrationSubjects."Student Code No.";
                            BufferAssignAssessments."Class No." := l_AssessingStudents."Class No.";
                            BufferAssignAssessments."Subject Code" := l_AssessingStudents.Subject;
                            BufferAssignAssessments."Sub-Subject Code" := l_StudentSubSubjects."Sub-Subject Code";
                            BufferAssignAssessments.Text := l_StudentSubSubjects."Sub-Subject Description";
                            BufferAssignAssessments.Level := pLevel + 1;
                            BufferAssignAssessments."Option Type" := BufferAssignAssessments."Option Type"::"Sub-Subjects";
                            BufferAssignAssessments."Schooling Year" := l_AssessingStudents."Schooling Year";
                            BufferAssignAssessments.Class := l_AssessingStudents.Class;
                            BufferAssignAssessments.Insert;

                        until l_StudentSubSubjects.Next = 0;
                    end;
                end;
            end;
        end;
    end;


    procedure GetInfo(pSchoolYear: Code[9]; pStudentCode: Code[20])
    begin
        varSchoolYear := pSchoolYear;
        varStudent := pStudentCode;
    end;


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


    procedure GetMultiplePE()
    begin
        rAssessingStudentsTEMP.Reset;
        rAssessingStudentsTEMP.DeleteAll;

        rAssessingStudents.Reset;
        rAssessingStudents.SetRange("Student Code No.", varStudent);
        rAssessingStudents.SetRange("School Year", varSchoolYear);
        rAssessingStudents.SetRange(Class, '');
        if rAssessingStudents.FindSet then begin
            repeat
                rAssessingStudentsTEMP.Reset;
                rAssessingStudentsTEMP.SetRange("School Year", varSchoolYear);
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


    procedure GetStudyPlan()
    var
        l_StudyPlanLines: Record "Study Plan Lines";
        l_StudyPlanLines2: Record "Study Plan Lines";
        l_GroupSubjects: Record "Group Subjects";
    begin
        rAssessingStudentsTEMP.Reset;
        if rAssessingStudentsTEMP.FindSet then begin
            repeat
                if rAssessingStudentsTEMP."Type Education" = rAssessingStudentsTEMP."Type Education"::Simple then begin
                    DeleteBuffer;
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
                            BufferAssignAssessments.Level := 1;
                            BufferAssignAssessments."Option Type" := BufferAssignAssessments."Option Type"::"Schooling Year";
                            BufferAssignAssessments."Schooling Year" := rAssessingStudentsTEMP."Schooling Year";
                            //BufferAssignAssessments.Class := rRegistration.Class;
                            //BufferAssignAssessments."Class No." := rRegistration."Class No.";
                            BufferAssignAssessments.Insert;
                        end;
                        repeat
                            if l_StudyPlanLines."Option Group" = '' then begin

                                if HasGrade(l_StudyPlanLines."School Year", l_StudyPlanLines."Schooling Year", rAssessingStudentsTEMP."Student Code No.",
                                  l_StudyPlanLines."Subject Code", l_StudyPlanLines.Code) then begin
                                    BufferAssignAssessments.Reset;
                                    BufferAssignAssessments.Init;
                                    BufferAssignAssessments."User ID" := UserId;
                                    VarlineNo += 10000;
                                    BufferAssignAssessments."Line No." := VarlineNo;
                                    BufferAssignAssessments."Student Code No." := rAssessingStudentsTEMP."Student Code No.";
                                    //BufferAssignAssessments."Class No." := l_RegistrationSubjects."Class No.";
                                    BufferAssignAssessments."Subject Code" := l_StudyPlanLines."Subject Code";
                                    BufferAssignAssessments.Text := l_StudyPlanLines."Subject Description";
                                    BufferAssignAssessments.Level := 2;

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
                                    //BufferAssignAssessments."Class No." := l_RegistrationSubjects."Class No.";
                                    BufferAssignAssessments."Subject Code" := l_StudyPlanLines."Option Group";
                                    l_GroupSubjects.Reset;
                                    l_GroupSubjects.SetRange(Code, l_StudyPlanLines."Option Group");
                                    if rAssessingStudentsTEMP."Type Education" = rAssessingStudentsTEMP."Type Education"::Simple then
                                        l_GroupSubjects.SetRange("Schooling Year", l_StudyPlanLines."Schooling Year")
                                    else
                                        l_GroupSubjects.SetRange("Schooling Year", '');
                                    if l_GroupSubjects.FindFirst then
                                        BufferAssignAssessments.Text := l_GroupSubjects.Description;
                                    BufferAssignAssessments.Level := 2;
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
                                                //BufferAssignAssessments."Class No." := l_RegistrationSubjects2."Class No.";
                                                BufferAssignAssessments."Subject Code" := l_StudyPlanLines2."Subject Code";
                                                BufferAssignAssessments.Text := l_StudyPlanLines2."Subject Description";
                                                BufferAssignAssessments.Level := 3;
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
                    DeleteBuffer;
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
                            BufferAssignAssessments.Level := 1;
                            BufferAssignAssessments."Option Type" := BufferAssignAssessments."Option Type"::"Schooling Year";
                            BufferAssignAssessments."Schooling Year" := rAssessingStudentsTEMP."Schooling Year";
                            //BufferAssignAssessments.Class := rRegistration.Class;
                            //BufferAssignAssessments."Class No." := rRegistration."Class No.";
                            BufferAssignAssessments.Insert;
                        end;
                        repeat
                            if rCourseLinesTEMP."Option Group" = '' then begin

                                if HasGrade(rAssessingStudentsTEMP."School Year", rAssessingStudentsTEMP."Schooling Year",
                                          rAssessingStudentsTEMP."Student Code No.",
                                          rCourseLinesTEMP."Subject Code", rCourseLinesTEMP.Code) then begin

                                    BufferAssignAssessments.Init;
                                    BufferAssignAssessments."User ID" := UserId;
                                    VarlineNo += 10000;
                                    BufferAssignAssessments."Line No." := VarlineNo;
                                    BufferAssignAssessments."Student Code No." := rAssessingStudentsTEMP."Student Code No.";
                                    //BufferAssignAssessments."Class No." := l_RegistrationSubjects."Class No.";
                                    BufferAssignAssessments."Subject Code" := rCourseLinesTEMP."Subject Code";
                                    BufferAssignAssessments.Text := rCourseLinesTEMP."Subject Description";
                                    BufferAssignAssessments.Level := 2;

                                    BufferAssignAssessments."Option Type" := BufferAssignAssessments."Option Type"::Subjects;
                                    BufferAssignAssessments."Schooling Year" := rAssessingStudentsTEMP."Schooling Year";
                                    //BufferAssignAssessments.Class := l_RegistrationSubjects.Class;
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
                                    //BufferAssignAssessments."Class No." := l_RegistrationSubjects."Class No.";
                                    BufferAssignAssessments."Subject Code" := rCourseLinesTEMP."Option Group";
                                    l_GroupSubjects.Reset;
                                    l_GroupSubjects.SetRange(Code, rCourseLinesTEMP."Option Group");
                                    if rAssessingStudentsTEMP."Type Education" = rAssessingStudentsTEMP."Type Education"::Simple then
                                        l_GroupSubjects.SetRange("Schooling Year", rAssessingStudentsTEMP."Schooling Year")
                                    else
                                        l_GroupSubjects.SetRange("Schooling Year", '');
                                    if l_GroupSubjects.FindFirst then
                                        BufferAssignAssessments.Text := l_GroupSubjects.Description;
                                    BufferAssignAssessments.Level := 2;
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
                                                //BufferAssignAssessments."Class No." := l_RegistrationSubjects2."Class No.";
                                                BufferAssignAssessments."Subject Code" := rCourseLinesTEMP2."Subject Code";
                                                BufferAssignAssessments.Text := rCourseLinesTEMP2."Subject Description";
                                                BufferAssignAssessments.Level := 3;
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


    procedure ValidateCourse(pAssessingStudents: Record "Assessing Students")
    begin
        rCourseLinesTEMP.Reset;
        rCourseLinesTEMP.DeleteAll;
        rCourseLinesTEMP2.Reset;
        rCourseLinesTEMP2.DeleteAll;

        // Quadriennal
        VarlineNo := 10000;
        rCourseLines.Reset;
        rCourseLines.SetRange(Code, pAssessingStudents."Study Plan Code");
        rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Quadriennal);
        if rCourseLines.FindSet then begin
            repeat
                InsertSubjects(rCourseLines);
                VarlineNo += 10000;
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
                VarlineNo += 10000;
            until rCourseLines.Next = 0;
        end;


        //Biennial

        rStruEduCountry.Reset;
        rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
        //rStruEduCountry.SETRANGE(Level,rStruEduCountry.Level::Secondary);
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
                    VarlineNo += 10000;
                until rCourseLines.Next = 0;
            end;
            //      ELSE BEGIN
            l_rStruEduCountry.Reset;
            l_rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
            l_rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
            l_rStruEduCountry.SetRange("Sorting ID", GetNoStructureCountry(pAssessingStudents."Schooling Year") - 1);
            if l_rStruEduCountry.Find('-') then begin
                rCourseLines.Reset;
                rCourseLines.SetRange(Code, pAssessingStudents."Study Plan Code");
                rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Biennial);
                rCourseLines.SetRange("Schooling Year Begin", l_rStruEduCountry."Schooling Year");
                if rCourseLines.FindSet then begin
                    repeat
                        InsertSubjects(rCourseLines);
                        VarlineNo += 10000;
                    until rCourseLines.Next = 0;
                end;
            end;
            l_rStruEduCountry.Reset;
            l_rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
            l_rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
            l_rStruEduCountry.SetRange("Sorting ID", GetNoStructureCountry(pAssessingStudents."Schooling Year") - 2);
            if l_rStruEduCountry.FindSet then begin
                rCourseLines.Reset;
                rCourseLines.SetRange(Code, pAssessingStudents."Study Plan Code");
                rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Triennial);
                rCourseLines.SetRange("Schooling Year Begin", l_rStruEduCountry."Schooling Year");
                if rCourseLines.FindSet then begin
                    repeat
                        InsertSubjects(rCourseLines);
                        VarlineNo += 10000;
                    until rCourseLines.Next = 0;
                end;
            end;
            l_rStruEduCountry.Reset;
            l_rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
            l_rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
            l_rStruEduCountry.SetRange("Sorting ID", GetNoStructureCountry(pAssessingStudents."Schooling Year") - 1);
            if l_rStruEduCountry.FindSet then begin
                rCourseLines.Reset;
                rCourseLines.SetRange(Code, pAssessingStudents."Study Plan Code");
                rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Triennial);
                rCourseLines.SetRange("Schooling Year Begin", l_rStruEduCountry."Schooling Year");
                if rCourseLines.FindSet then begin
                    repeat
                        InsertSubjects(rCourseLines);
                        VarlineNo += 10000;
                    until rCourseLines.Next = 0;
                end;
            end;
        end;
    end;


    procedure GetNoStructureCountry(pSchoolingYear: Code[10]): Integer
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


    procedure ShowHideTerms()
    begin
        BooktermsVisible := false;
        SheetTermsVisible := false;

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
            rAssessingStudents.SetFilter("Student Code No.", Rec."Student Code No.");
            rAssessingStudents.SetFilter("Moment Code", rMomentsAssessment."Moment Code");
            if rAssessingStudents.FindFirst then begin
                BooktermsVisible := true;
                SheetTermsVisible := true;
            end;

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
        DeleteBuffer;
        InsertStudents;
        InitTempTable;
        UpdateForm;
        CurrPage.Update(false);
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

