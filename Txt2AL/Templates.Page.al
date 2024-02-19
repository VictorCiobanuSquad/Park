#pragma implicitwith disable
page 31009920 Templates
{
    // IT001 - 2017.01.18 - Novo campo "4 Ano com prova" por causa dos registos biográficos 1º ciclo
    //

    Caption = 'Templates';
    DelayedInsert = true;
    PageType = Card;
    SourceTable = Templates;

    layout
    {
        area(content)
        {
            group(Control1102065017)
            {
                ShowCaption = false;
                field(OptionReport; varOptionTypeReport)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Report Type';
                    Editable = OptionReportEditable;
                    OptionCaption = 'All,Bulletins,Services,Class,Biographic Records,Legal Reports,Students,Relation Parents Students,Minutes,Candidates';

                    trigger OnValidate()
                    begin
                        varOptionTypeReportOnAfterVali;
                    end;
                }
                field("Legal Reports"; varType)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Report Subtype';
                    Editable = "Legal ReportsEditable";
                    OptionCaption = ' ,,,,,,,,,,,,Legal LS - Transfer,Legal LS - Qualificacions,Legal LS - Historic,Legal LS - Dossier,Legal Pri - Actas Qualf,Legal Pri - Transfer,Legal Pri - Historic,Legal Pri - Dossier,Legal Pri - Individual Report,Legal UPP - Actas Qualf,Legal UPP - Transfer,Legal UPP - Historic,Legal UPP - Dossier';
                    Visible = "Legal ReportsVisible";

                    trigger OnValidate()
                    begin
                        varTypeC1102065012OnAfterValid;
                    end;
                }
                field(Services; varType)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Report Type';
                    OptionCaption = ' ,,,,,,,,,,,Services';
                    Visible = ServicesVisible;

                    trigger OnValidate()
                    begin
                        varTypeC1102065005OnAfterValid;
                    end;
                }
                field(Student; varType)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Report Type';
                    OptionCaption = ' ,Registration Sheet';
                    Visible = StudentVisible;

                    trigger OnValidate()
                    begin
                        varTypeC1102065013OnAfterValid;
                    end;
                }
                field("Relation Parent Students"; varType)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Report Type';
                    OptionCaption = ' ,,,,,,,,,,,,,,,,,,,,,,,,,Relation Parents Students';
                    Visible = RelationParentStudentsVisible;

                    trigger OnValidate()
                    begin
                        varTypeC1102065018OnAfterValid;
                    end;
                }
                field(Minutes; varType)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Report Type';
                    OptionCaption = ' ,,,,,,,,,,,,,,,,,,,,,,,,,,Class Meeting,Department Meeting,Head Department Meeting,Level Meeting';
                    Visible = MinutesVisible;

                    trigger OnValidate()
                    begin
                        varTypeC1102065016OnAfterValid;
                    end;
                }
                field(Candidates; varType)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Report Type';
                    OptionCaption = ' ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,Pre-registration';
                    Visible = CandidatesVisible;

                    trigger OnValidate()
                    begin
                        varTypeC1102065027OnAfterValid;
                    end;
                }
                field("Biographic Records"; varType)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Report Type';
                    OptionCaption = ' ,,,,,,,,Biografic Record Primary,Biografic Record Secondary,Biografic Record Upper Secondary,Services,,,,,,,,,,,,,,,Biografic Record Primary (v2018)';
                    Visible = "Biographic RecordsVisible";

                    trigger OnValidate()
                    begin
                        varTypeC1102065000OnAfterValid;
                    end;
                }
                field(Bulletins; varType)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Report Type';
                    OptionCaption = ' ,,Bulletin Pre Primary,Bulletin Primary,Bulletin Lower Secondary,Bulletin Upper Secondary';
                    Visible = BulletinsVisible;

                    trigger OnValidate()
                    begin
                        varTypeC1102065001OnAfterValid;
                    end;
                }
                field(Class; varType)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Report Type';
                    OptionCaption = ' ,,,,,,Student Class,Class Evaluation';
                    Visible = ClassVisible;

                    trigger OnValidate()
                    begin
                        varTypeC1102065008OnAfterValid;
                    end;
                }
                field(All; varType)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Report Type';
                    Editable = AllEditable;
                    OptionCaption = ' ,Registration Sheet,Bulletin Pre Primary,Bulletin Primary,Bulletin Lower Secondary,Bulletin Upper Secondary,Student Class,Class Evaluation,Biographic Record Primary,Biographic Record Lower Secondary,Biographic Record Upper Secondary,Services,Legal LS - Transfer,Legal LS - Qualificacions,Legal LS - Historic,Legal LS - Dossier,Legal Pri - Actas Qualf,Legal Pri - Transfer,Legal Pri - Historic,Legal Pri - Dossier,Legal Pri - Individual Report,Legal UPP - Actas Qualf,Legal UPP - Transfer,Legal UPP - Historic,Legal UPP - Dossier,Relation Parents Students,Class Meeting,Department Meeting,Head Department Meeting,Level Meeting,Pre-registration,Biographic Record Primary (v2018)';
                    Visible = AllVisible;

                    trigger OnValidate()
                    begin
                        varTypeC1102065004OnAfterValid;
                    end;
                }
                field(Import; varTemplateType)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Import';
                    OptionCaption = 'Import,Word,Excel';

                    trigger OnValidate()
                    begin
                        if varTemplateType = varTemplateType::Excel then
                            ExcelvarTemplateTypeOnValidate;
                        if varTemplateType = varTemplateType::Word then
                            WordvarTemplateTypeOnValidate;

                        if varTemplateType = varTemplateType::Import then
                            varTemplateTypeOnValidate;
                    end;
                }
            }
            repeater(TableBox)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = CodeEditable;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = DescriptionEditable;
                }
                field("""File Import"".HASVALUE"; Rec."File Import".HasValue)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Imported';
                }
            }
            group("Option Report")
            {
                Caption = 'Legal Reports Options';
                Visible = "Option ReportVisible";
                field(CurricularSubjects; varCurricularSubjects)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Curricular Subjects';
                    Enabled = CurricularSubjectsEnable;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        rStudentsTemp: Record Students temporary;
                        rStudents: Record Students;
                    begin
                        rGroupSubjectsTemp.DeleteAll;

                        if varStudyPlanCode = '' then begin
                            rStruEduCountry.Reset;
                            rStruEduCountry.SetRange("Schooling Year", varSchoolingYear);
                            if rStruEduCountry.FindSet then begin
                                if rStruEduCountry.Type = rStruEduCountry.Type::Multi then begin
                                    rClass.Reset;
                                    rClass.SetRange(Class, varClass);
                                    rClass.SetRange("Schooling Year", varSchoolingYear);
                                    if rClass.FindSet then begin
                                        rcourseLines.Reset;
                                        rcourseLines.SetRange(Code, rClass."Study Plan Code");
                                        rcourseLines.SetFilter("Option Group", '<> %1', '');
                                        if rcourseLines.FindSet then begin
                                            repeat
                                                rGroupSubjects.Reset;
                                                rGroupSubjects.SetRange(Code, rcourseLines."Option Group");
                                                if rGroupSubjects.FindSet then begin
                                                    rGroupSubjectsTemp.Reset;
                                                    rGroupSubjectsTemp.SetRange(Code, rGroupSubjects.Code);
                                                    if not rGroupSubjectsTemp.FindSet then begin
                                                        rGroupSubjectsTemp.Init;
                                                        rGroupSubjectsTemp.TransferFields(rGroupSubjects);
                                                        rGroupSubjectsTemp.Insert;
                                                    end;
                                                end;
                                            until rcourseLines.Next = 0;
                                        end;
                                        rGroupSubjectsTemp.Reset;
                                        if PAGE.RunModal(PAGE::"Groups Subjects List", rGroupSubjectsTemp) = ACTION::LookupOK then
                                            varCurricularSubjects := rGroupSubjectsTemp.Code;
                                    end;
                                end else begin
                                    rClass.Reset;
                                    rClass.SetRange(Class, varClass);
                                    rClass.SetRange("Schooling Year", varSchoolingYear);
                                    if rClass.FindSet then begin
                                        rStudyPlanLines.Reset;
                                        rStudyPlanLines.SetRange(Code, rClass."Study Plan Code");
                                        rStudyPlanLines.SetFilter("Option Group", '<> %1', '');
                                        if rStudyPlanLines.FindSet then begin
                                            repeat
                                                rGroupSubjects.Reset;
                                                rGroupSubjects.SetRange(Code, rStudyPlanLines."Option Group");
                                                if rGroupSubjects.FindSet then begin
                                                    rGroupSubjectsTemp.Reset;
                                                    rGroupSubjectsTemp.SetRange(Code, rGroupSubjects.Code);
                                                    if not rGroupSubjectsTemp.FindSet then begin
                                                        rGroupSubjectsTemp.Init;
                                                        rGroupSubjectsTemp.TransferFields(rGroupSubjects);
                                                        rGroupSubjectsTemp.Insert;
                                                    end;
                                                end;
                                            until rStudyPlanLines.Next = 0;
                                        end;
                                        rGroupSubjectsTemp.Reset;
                                        if PAGE.RunModal(PAGE::"Groups Subjects List", rGroupSubjectsTemp) = ACTION::LookupOK then
                                            varCurricularSubjects := rGroupSubjectsTemp.Code;
                                    end;
                                end;
                            end;
                        end else begin
                            rcourseLines.Reset;
                            rcourseLines.SetRange(Code, varStudyPlanCode);
                            rcourseLines.SetFilter("Option Group", '<> %1', '');
                            if rcourseLines.FindSet then begin
                                repeat
                                    rGroupSubjects.Reset;
                                    rGroupSubjects.SetRange(Code, rcourseLines."Option Group");
                                    if rGroupSubjects.FindSet then begin
                                        rGroupSubjectsTemp.Reset;
                                        rGroupSubjectsTemp.SetRange(Code, rGroupSubjects.Code);
                                        if not rGroupSubjectsTemp.FindSet then begin
                                            rGroupSubjectsTemp.Init;
                                            rGroupSubjectsTemp.TransferFields(rGroupSubjects);
                                            rGroupSubjectsTemp.Insert;
                                        end;
                                    end;
                                until rcourseLines.Next = 0;
                            end;
                            rGroupSubjectsTemp.Reset;
                            if PAGE.RunModal(PAGE::"Groups Subjects List", rGroupSubjectsTemp) = ACTION::LookupOK then
                                varCurricularSubjects := rGroupSubjectsTemp.Code;
                        end;
                    end;
                }
                field(BasicSkills; varBasicSkills)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Basic Skills';
                    Enabled = BasicSkillsEnable;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        rStudentsTemp: Record Students temporary;
                        rStudents: Record Students;
                    begin
                        rGroupSubjectsTemp.DeleteAll;
                        if varStudyPlanCode = '' then begin
                            rStruEduCountry.Reset;
                            rStruEduCountry.SetRange("Schooling Year", varSchoolingYear);
                            if rStruEduCountry.FindSet then begin
                                if rStruEduCountry.Type = rStruEduCountry.Type::Multi then begin
                                    rClass.Reset;
                                    rClass.SetRange(Class, varClass);
                                    rClass.SetRange("Schooling Year", varSchoolingYear);
                                    if rClass.FindSet then begin
                                        rcourseLines.Reset;
                                        rcourseLines.SetRange(Code, rClass."Study Plan Code");
                                        rcourseLines.SetFilter("Option Group", '<> %1', '');
                                        if rcourseLines.FindSet then begin
                                            repeat
                                                rGroupSubjects.Reset;
                                                rGroupSubjects.SetRange(Code, rcourseLines."Option Group");
                                                if rGroupSubjects.FindSet then begin
                                                    rGroupSubjectsTemp.Reset;
                                                    rGroupSubjectsTemp.SetRange(Code, rGroupSubjects.Code);
                                                    if not rGroupSubjectsTemp.FindSet then begin
                                                        rGroupSubjectsTemp.Init;
                                                        rGroupSubjectsTemp.TransferFields(rGroupSubjects);
                                                        rGroupSubjectsTemp.Insert;
                                                    end;
                                                end;
                                            until rcourseLines.Next = 0;
                                        end;
                                        rGroupSubjectsTemp.Reset;
                                        if PAGE.RunModal(PAGE::"Groups Subjects List", rGroupSubjectsTemp) = ACTION::LookupOK then
                                            varBasicSkills := rGroupSubjectsTemp.Code;
                                    end;
                                end else begin
                                    rClass.Reset;
                                    rClass.SetRange(Class, varClass);
                                    rClass.SetRange("Schooling Year", varSchoolingYear);
                                    if rClass.FindSet then begin
                                        rStudyPlanLines.Reset;
                                        rStudyPlanLines.SetRange(Code, rClass."Study Plan Code");
                                        rStudyPlanLines.SetFilter("Option Group", '<> %1', '');
                                        if rStudyPlanLines.FindSet then begin
                                            repeat
                                                rGroupSubjects.Reset;
                                                rGroupSubjects.SetRange(Code, rStudyPlanLines."Option Group");
                                                if rGroupSubjects.FindSet then begin
                                                    rGroupSubjectsTemp.Reset;
                                                    rGroupSubjectsTemp.SetRange(Code, rGroupSubjects.Code);
                                                    if not rGroupSubjectsTemp.FindSet then begin
                                                        rGroupSubjectsTemp.Init;
                                                        rGroupSubjectsTemp.TransferFields(rGroupSubjects);
                                                        rGroupSubjectsTemp.Insert;
                                                    end;
                                                end;
                                            until rStudyPlanLines.Next = 0;
                                        end;
                                        rGroupSubjectsTemp.Reset;
                                        if PAGE.RunModal(PAGE::"Groups Subjects List", rGroupSubjectsTemp) = ACTION::LookupOK then
                                            varBasicSkills := rGroupSubjectsTemp.Code;
                                    end;
                                end;
                            end;
                        end else begin
                            rcourseLines.Reset;
                            rcourseLines.SetRange(Code, varStudyPlanCode);
                            rcourseLines.SetFilter("Option Group", '<> %1', '');
                            if rcourseLines.FindSet then begin
                                repeat
                                    rGroupSubjects.Reset;
                                    rGroupSubjects.SetRange(Code, rcourseLines."Option Group");
                                    if rGroupSubjects.FindSet then begin
                                        rGroupSubjectsTemp.Reset;
                                        rGroupSubjectsTemp.SetRange(Code, rGroupSubjects.Code);
                                        if not rGroupSubjectsTemp.FindSet then begin
                                            rGroupSubjectsTemp.Init;
                                            rGroupSubjectsTemp.TransferFields(rGroupSubjects);
                                            rGroupSubjectsTemp.Insert;
                                        end;
                                    end;
                                until rcourseLines.Next = 0;
                            end;
                            rGroupSubjectsTemp.Reset;
                            if PAGE.RunModal(PAGE::"Groups Subjects List", rGroupSubjectsTemp) = ACTION::LookupOK then
                                varBasicSkills := rGroupSubjectsTemp.Code;
                        end;
                    end;
                }
                field("Optional group"; varPersonalAspects)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Optional group';
                    Enabled = "Optional groupEnable";
                    Visible = "Optional groupVisible";

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        rStudentsTemp: Record Students temporary;
                        rStudents: Record Students;
                    begin
                        rGroupSubjectsTemp.DeleteAll;

                        if varStudyPlanCode = '' then begin
                            rStruEduCountry.Reset;
                            rStruEduCountry.SetRange("Schooling Year", varSchoolingYear);
                            if rStruEduCountry.FindSet then begin
                                if rStruEduCountry.Type = rStruEduCountry.Type::Multi then begin
                                    rClass.Reset;
                                    rClass.SetRange(Class, varClass);
                                    rClass.SetRange("Schooling Year", varSchoolingYear);
                                    if rClass.FindSet then begin
                                        rcourseLines.Reset;
                                        rcourseLines.SetRange(Code, rClass."Study Plan Code");
                                        rcourseLines.SetFilter("Option Group", '<> %1', '');
                                        if rcourseLines.FindSet then begin
                                            repeat
                                                rGroupSubjects.Reset;
                                                rGroupSubjects.SetRange(Code, rcourseLines."Option Group");
                                                if rGroupSubjects.FindSet then begin
                                                    rGroupSubjectsTemp.Reset;
                                                    rGroupSubjectsTemp.SetRange(Code, rGroupSubjects.Code);
                                                    if not rGroupSubjectsTemp.FindSet then begin
                                                        rGroupSubjectsTemp.Init;
                                                        rGroupSubjectsTemp.TransferFields(rGroupSubjects);
                                                        rGroupSubjectsTemp.Insert;
                                                    end;
                                                end;
                                            until rcourseLines.Next = 0;
                                        end;
                                        rGroupSubjectsTemp.Reset;
                                        if PAGE.RunModal(PAGE::"Groups Subjects List", rGroupSubjectsTemp) = ACTION::LookupOK then
                                            varPersonalAspects := rGroupSubjectsTemp.Code;
                                    end;
                                end else begin
                                    rClass.Reset;
                                    rClass.SetRange(Class, varClass);
                                    rClass.SetRange("Schooling Year", varSchoolingYear);
                                    if rClass.FindSet then begin
                                        rStudyPlanLines.Reset;
                                        rStudyPlanLines.SetRange(Code, rClass."Study Plan Code");
                                        rStudyPlanLines.SetFilter("Option Group", '<> %1', '');
                                        if rStudyPlanLines.FindSet then begin
                                            repeat
                                                rGroupSubjects.Reset;
                                                rGroupSubjects.SetRange(Code, rStudyPlanLines."Option Group");
                                                if rGroupSubjects.FindSet then begin
                                                    rGroupSubjectsTemp.Reset;
                                                    rGroupSubjectsTemp.SetRange(Code, rGroupSubjects.Code);
                                                    if not rGroupSubjectsTemp.FindSet then begin
                                                        rGroupSubjectsTemp.Init;
                                                        rGroupSubjectsTemp.TransferFields(rGroupSubjects);
                                                        rGroupSubjectsTemp.Insert;
                                                    end;
                                                end;
                                            until rStudyPlanLines.Next = 0;
                                        end;
                                        rGroupSubjectsTemp.Reset;
                                        if PAGE.RunModal(PAGE::"Groups Subjects List", rGroupSubjectsTemp) = ACTION::LookupOK then
                                            varPersonalAspects := rGroupSubjectsTemp.Code;
                                    end;
                                end;
                            end;
                        end else begin
                            rcourseLines.Reset;
                            rcourseLines.SetRange(Code, varStudyPlanCode);
                            rcourseLines.SetFilter("Option Group", '<> %1', '');
                            if rcourseLines.FindSet then begin
                                repeat
                                    rGroupSubjects.Reset;
                                    rGroupSubjects.SetRange(Code, rcourseLines."Option Group");
                                    if rGroupSubjects.FindSet then begin
                                        rGroupSubjectsTemp.Reset;
                                        rGroupSubjectsTemp.SetRange(Code, rGroupSubjects.Code);
                                        if not rGroupSubjectsTemp.FindSet then begin
                                            rGroupSubjectsTemp.Init;
                                            rGroupSubjectsTemp.TransferFields(rGroupSubjects);
                                            rGroupSubjectsTemp.Insert;
                                        end;
                                    end;
                                until rcourseLines.Next = 0;
                            end;
                            rGroupSubjectsTemp.Reset;
                            if PAGE.RunModal(PAGE::"Groups Subjects List", rGroupSubjectsTemp) = ACTION::LookupOK then
                                varPersonalAspects := rGroupSubjectsTemp.Code;
                        end;
                    end;
                }
                field(PersonalAspects; varPersonalAspects)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Personal Aspects';
                    Enabled = PersonalAspectsEnable;
                    Visible = PersonalAspectsVisible;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        rStudentsTemp: Record Students temporary;
                        rStudents: Record Students;
                    begin
                        rGroupSubjectsTemp.DeleteAll;

                        if varStudyPlanCode = '' then begin
                            rStruEduCountry.Reset;
                            rStruEduCountry.SetRange("Schooling Year", varSchoolingYear);
                            if rStruEduCountry.FindSet then begin
                                if rStruEduCountry.Type = rStruEduCountry.Type::Multi then begin
                                    rClass.Reset;
                                    rClass.SetRange(Class, varClass);
                                    rClass.SetRange("Schooling Year", varSchoolingYear);
                                    if rClass.FindSet then begin
                                        rcourseLines.Reset;
                                        rcourseLines.SetRange(Code, rClass."Study Plan Code");
                                        rcourseLines.SetFilter("Option Group", '<> %1', '');
                                        if rcourseLines.FindSet then begin
                                            repeat
                                                rGroupSubjects.Reset;
                                                rGroupSubjects.SetRange(Code, rcourseLines."Option Group");
                                                if rGroupSubjects.FindSet then begin
                                                    rGroupSubjectsTemp.Reset;
                                                    rGroupSubjectsTemp.SetRange(Code, rGroupSubjects.Code);
                                                    if not rGroupSubjectsTemp.FindSet then begin
                                                        rGroupSubjectsTemp.Init;
                                                        rGroupSubjectsTemp.TransferFields(rGroupSubjects);
                                                        rGroupSubjectsTemp.Insert;
                                                    end;
                                                end;
                                            until rcourseLines.Next = 0;
                                        end;
                                        rGroupSubjectsTemp.Reset;
                                        if PAGE.RunModal(PAGE::"Groups Subjects List", rGroupSubjectsTemp) = ACTION::LookupOK then
                                            varPersonalAspects := rGroupSubjectsTemp.Code;
                                    end;
                                end else begin
                                    rClass.Reset;
                                    rClass.SetRange(Class, varClass);
                                    rClass.SetRange("Schooling Year", varSchoolingYear);
                                    if rClass.FindSet then begin
                                        rStudyPlanLines.Reset;
                                        rStudyPlanLines.SetRange(Code, rClass."Study Plan Code");
                                        rStudyPlanLines.SetFilter("Option Group", '<> %1', '');
                                        if rStudyPlanLines.FindSet then begin
                                            repeat
                                                rGroupSubjects.Reset;
                                                rGroupSubjects.SetRange(Code, rStudyPlanLines."Option Group");
                                                if rGroupSubjects.FindSet then begin
                                                    rGroupSubjectsTemp.Reset;
                                                    rGroupSubjectsTemp.SetRange(Code, rGroupSubjects.Code);
                                                    if not rGroupSubjectsTemp.FindSet then begin
                                                        rGroupSubjectsTemp.Init;
                                                        rGroupSubjectsTemp.TransferFields(rGroupSubjects);
                                                        rGroupSubjectsTemp.Insert;
                                                    end;
                                                end;
                                            until rStudyPlanLines.Next = 0;
                                        end;
                                        rGroupSubjectsTemp.Reset;
                                        if PAGE.RunModal(PAGE::"Groups Subjects List", rGroupSubjectsTemp) = ACTION::LookupOK then
                                            varPersonalAspects := rGroupSubjectsTemp.Code;
                                    end;
                                end;
                            end;
                        end else begin
                            rcourseLines.Reset;
                            rcourseLines.SetRange(Code, varStudyPlanCode);
                            rcourseLines.SetFilter("Option Group", '<> %1', '');
                            if rcourseLines.FindSet then begin
                                repeat
                                    rGroupSubjects.Reset;
                                    rGroupSubjects.SetRange(Code, rcourseLines."Option Group");
                                    if rGroupSubjects.FindSet then begin
                                        rGroupSubjectsTemp.Reset;
                                        rGroupSubjectsTemp.SetRange(Code, rGroupSubjects.Code);
                                        if not rGroupSubjectsTemp.FindSet then begin
                                            rGroupSubjectsTemp.Init;
                                            rGroupSubjectsTemp.TransferFields(rGroupSubjects);
                                            rGroupSubjectsTemp.Insert;
                                        end;
                                    end;
                                until rcourseLines.Next = 0;
                            end;
                            rGroupSubjectsTemp.Reset;
                            if PAGE.RunModal(PAGE::"Groups Subjects List", rGroupSubjectsTemp) = ACTION::LookupOK then
                                varPersonalAspects := rGroupSubjectsTemp.Code;
                        end;
                    end;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Print Button")
            {
                Caption = '&Print';
                Enabled = "Print ButtonEnable";
                Image = Print;
                InFooterBar = true;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    PrintButton;
                end;
            }
            group(Bbotton)
            {
                Caption = 'F&unctions';
                action("&Import")
                {
                    Caption = '&Import';
                    Image = Import;

                    trigger OnAction()
                    begin
                        Rec.Import();
                    end;
                }
                action("&Export")
                {
                    Caption = '&Export';
                    Image = Export;

                    trigger OnAction()
                    begin
                        Rec.Export;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if "Print ButtonEnable" then
            UpdateSections;
        OnAfterGetCurrRecord2;
    end;

    trigger OnInit()
    begin
        ImportEnable := true;
        WordEnable := true;
        ExcelEnable := true;
        "Optional groupEnable" := true;
        CurricularSubjectsEnable := true;
        PersonalAspectsEnable := true;
        BasicSkillsEnable := true;
        "Legal ReportsEditable" := true;
        "Optional groupVisible" := true;
        PersonalAspectsVisible := true;
        "Option ReportVisible" := true;
        CancelVisible := true;
        okVisible := true;
        CandidatesVisible := true;
        MinutesVisible := true;
        RelationParentStudentsVisible := true;
        ServicesVisible := true;
        ClassVisible := true;
        StudentVisible := true;
        "Biographic RecordsVisible" := true;
        BulletinsVisible := true;
        AllVisible := true;
        "Print ButtonEnable" := true;
        BbottonEnable := true;
        DescriptionEditable := true;
        CodeEditable := true;
        OptionReportEditable := true;
        AllEditable := true;
        "Legal ReportsVisible" := true;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if (varTemplateType = varTemplateType::Word) or (varTemplateType = varTemplateType::Excel) then
            Error(text001);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        OnAfterGetCurrRecord2;
    end;

    trigger OnOpenPage()
    begin
        if CurrPage.LookupMode then begin
            BbottonEnable := false;
            varTemplateType := varTemplateType::Word;
            AllEditable := false;
            OptionReportEditable := false;
        end else begin
            BbottonEnable := true;
            varTemplateType := varTemplateType::Import;
        end;

        if CurrPage.LookupMode then begin
            "Print ButtonEnable" := true;
            CodeEditable := false;
            DescriptionEditable := false;
        end else begin
            "Print ButtonEnable" := false;
            Rec.SetRange(Type, varType::" ");
            if varType = 0 then begin
                CodeEditable := false;
                DescriptionEditable := false;
            end else begin
                CodeEditable := true;
                DescriptionEditable := true;
            end;
        end;

        Updatetemplates;
        /*
        IF (CurrPage."Print Button".ENABLED = FALSE) AND (varClass <> '') THEN BEGIN
           UpdateSections;
           UpdateSize;
        END;
        IF CurrPage.LOOKUPMODE AND CurrPage."Print Button".ENABLED AND "Legal ReportsVisible" THEN BEGIN
           UpdateSections;
           UpdateSize;
        END;
        */
        CurrPage.Update(false);

    end;

    var
        varStudentNo: Code[50];
        varClass: Code[50];
        varSchoolYear: Code[50];
        varcode: Code[50];
        varSchoolingYear: Code[50];
        varPageBreak: Boolean;
        varButtonPrint: Boolean;
        p: Integer;
        c: Integer;
        varSubjectCode: Code[20];
        varTeacherCode: Code[20];
        varTemplateType: Option Import,Word,Excel;
        varType: Option " ","Registration Sheet","Bulletin Pre Primary","Bulletin Primary","Bulletin Lower Secondary","Bulletin Upper Secondary","Student Class","Class Evaluation","Biographic Record Primary","Biographic Record Lower Secondary","Biographic Record Upper Secondary",Services,"Legal LS - Transfer","Legal LS - Qualificacions","Legal LS - Historic","Legal LS - Dossier","Legal Pri - Actas Qualf","Legal Pri - Transfer","Legal Pri - Historic","Legal Pri - Dossier","Legal Pri - Individual Report","Legal UPP - Actas Qualf","Legal UPP - Transfer","Legal UPP - Historic","Legal UPP - Dossier","Relation Parents Students","Class Meeting","Department Meeting","Head Department Meeting","Level Meeting","Pre-registration","Biographic Record Primary (v2018)";
        text001: Label 'For import the option must be "Import".';
        varResponsibilityCenter: Code[20];
        varOptionTypeReport: Option All,Bulletin,Services,Class,"Biographic Records","Legal Reports",Student,"Relation Parents Students",Minutes,Candidates;
        text002: Label 'WORD';
        Text003: Label 'EXCEL';
        varCurricularSubjects: Code[20];
        varPersonalAspects: Code[20];
        varBasicSkills: Code[20];
        varStudyPlanCode: Code[20];
        varSize: Integer;
        rStruEduCountry: Record "Structure Education Country";
        rRegistrationClass: Record "Registration Class";
        rRegistration: Record Registration;
        rGroupSubjects: Record "Group Subjects";
        rGroupSubjectsTemp: Record "Group Subjects" temporary;
        rClass: Record Class;
        rcourseLines: Record "Course Lines";
        rStudyPlanLines: Record "Study Plan Lines";
        rTimetableTeacher: Record "Timetable-Teacher";
        rCandidates: Record Candidate;
        [InDataSet]
        "Print ButtonEnable": Boolean;
        [InDataSet]
        "Legal ReportsVisible": Boolean;
        [InDataSet]
        AllEditable: Boolean;
        [InDataSet]
        OptionReportEditable: Boolean;
        [InDataSet]
        CodeEditable: Boolean;
        [InDataSet]
        DescriptionEditable: Boolean;
        [InDataSet]
        BbottonEnable: Boolean;
        [InDataSet]
        AllVisible: Boolean;
        [InDataSet]
        BulletinsVisible: Boolean;
        [InDataSet]
        "Biographic RecordsVisible": Boolean;
        [InDataSet]
        StudentVisible: Boolean;
        [InDataSet]
        ClassVisible: Boolean;
        [InDataSet]
        ServicesVisible: Boolean;
        [InDataSet]
        RelationParentStudentsVisible: Boolean;
        [InDataSet]
        MinutesVisible: Boolean;
        [InDataSet]
        CandidatesVisible: Boolean;
        [InDataSet]
        okVisible: Boolean;
        [InDataSet]
        CancelVisible: Boolean;
        [InDataSet]
        "Option ReportVisible": Boolean;
        [InDataSet]
        PersonalAspectsVisible: Boolean;
        [InDataSet]
        "Optional groupVisible": Boolean;
        [InDataSet]
        "Legal ReportsEditable": Boolean;
        [InDataSet]
        BasicSkillsEnable: Boolean;
        [InDataSet]
        PersonalAspectsEnable: Boolean;
        [InDataSet]
        CurricularSubjectsEnable: Boolean;
        [InDataSet]
        "Optional groupEnable": Boolean;
        [InDataSet]
        ExcelEnable: Boolean;
        [InDataSet]
        WordEnable: Boolean;
        [InDataSet]
        ImportEnable: Boolean;
        "Option ReportHeight": Integer;
        TableBoxHeight: Integer;
        Text666: Label '%1 is not a valid selection.';
        Text19048410: Label 'Type of Template';

    //[Scope('OnPrem')]
    procedure SetFormRegistration(var pRegistration: Record Registration; pTemplatecode: Option; pbuttonPrint: Boolean)
    begin
        varSchoolYear := pRegistration."School Year";
        varSchoolingYear := pRegistration."Schooling Year";
        varClass := pRegistration.Class;
        varType := pTemplatecode;
        varResponsibilityCenter := pRegistration."Responsibility Center";
        varStudentNo := pRegistration."Student Code No.";
        varButtonPrint := pbuttonPrint;
    end;

    //[Scope('OnPrem')]
    procedure SetFormStudents(pStudentNo: Code[50]; pSchoolYear: Code[50]; pcode: Code[50]; pSchoolingYear: Code[50]; pclass: Code[50]; pPageBreak: Boolean; pTeacherCode: Code[20]; pSubjectCode: Code[20]; pTemplateType: Option; pResponsibilityCenter: Code[20]; pStudyPlanCode: Code[20]; pbuttonPrint: Boolean)
    var
        varTemplates: Record Templates;
    begin
        varStudentNo := pStudentNo;
        varSchoolYear := pSchoolYear;
        varSchoolingYear := pSchoolingYear;
        varClass := pclass;
        varPageBreak := pPageBreak;
        varTeacherCode := pTeacherCode;
        varSubjectCode := pSubjectCode;
        varType := pTemplateType;
        varButtonPrint := pbuttonPrint;
        varResponsibilityCenter := pResponsibilityCenter;
        varStudyPlanCode := pStudyPlanCode;
        case varType of
            Rec.Type::"Legal LS - Dossier":
                begin
                    varOptionTypeReport := varOptionTypeReport::"Legal Reports";
                end;
            Rec.Type::"Legal LS - Transfer":
                begin
                    varOptionTypeReport := varOptionTypeReport::"Legal Reports";
                end;
            Rec.Type::"Legal LS - Qualificacions":
                begin
                    varOptionTypeReport := varOptionTypeReport::"Legal Reports";
                end;
            Rec.Type::"Legal LS - Historic":
                begin
                    varOptionTypeReport := varOptionTypeReport::"Legal Reports";
                end;
            Rec.Type::"Legal Pri - Individual Report":
                begin
                    varOptionTypeReport := varOptionTypeReport::"Legal Reports";
                end;
            Rec.Type::"Legal Pri - Dossier":
                begin
                    varOptionTypeReport := varOptionTypeReport::"Legal Reports";
                end;
            Rec.Type::"Legal Pri - Historic":
                begin
                    varOptionTypeReport := varOptionTypeReport::"Legal Reports";
                end;
            Rec.Type::"Legal Pri - Transfer":
                begin
                    varOptionTypeReport := varOptionTypeReport::"Legal Reports";
                end;
            Rec.Type::"Legal Pri - Actas Qualf":
                begin
                    varOptionTypeReport := varOptionTypeReport::"Legal Reports";
                end;
            Rec.Type::"Legal UPP - Transfer":
                begin
                    varOptionTypeReport := varOptionTypeReport::"Legal Reports";
                end;
            Rec.Type::"Legal UPP - Actas Qualf":
                begin
                    varOptionTypeReport := varOptionTypeReport::"Legal Reports";
                end;
            Rec.Type::"Legal UPP - Dossier":
                begin
                    varOptionTypeReport := varOptionTypeReport::"Legal Reports";
                end;
            Rec.Type::"Legal UPP - Historic":
                begin
                    varOptionTypeReport := varOptionTypeReport::"Legal Reports";
                end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure PrintButton()
    var
        varmomentCode: Code[20];
        window: Dialog;
        text001: Label 'Processing @1@@@@@@@@@@@';
    begin
        Clear(p);
        case Rec.Type of
            Rec.Type::"Registration Sheet":
                begin
                    if (varStudentNo = '') then begin
                        rRegistrationClass.Reset;
                        rRegistrationClass.SetCurrentKey("Class No.");
                        rRegistrationClass.SetRange(Class, varClass);
                        rRegistrationClass.SetRange("School Year", varSchoolYear);
                        rRegistrationClass.SetRange("Schooling Year", varSchoolingYear);
                        rRegistrationClass.SetRange(Status, rRegistrationClass.Status::Subscribed);
                        if rRegistrationClass.Find('-') then begin

                            // LFM  - Para PT não é nessário os momentos.
                            //varmomentCode := GetMoment(varSchoolingYear,varSchoolYear,rRegistrationClass."Responsibility Center");
                            //IF (varmomentCode = '')OR(varmomentCode = '0') THEN
                            //   EXIT;

                            c := rRegistrationClass.Count;
                            window.Open(text001);
                            repeat
                                p += 1;
                                varStudentNo := '';
                                window.Update(1, Round(p / c * 10000, 1));
                                varStudentNo := rRegistrationClass."Student Code No.";
                                if Rec.Type = Rec.Type::"Registration Sheet" then
                                    SetFormStudents(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varClass, varPageBreak, '', '', varType,
                                    varResponsibilityCenter, varStudyPlanCode, varButtonPrint);
                                Rec.Print(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varPageBreak, p, c, varmomentCode, varClass, '', '', varTemplateType
                                , '', '', '');
                            until rRegistrationClass.Next = 0;
                            varStudentNo := '';
                            window.Close;
                            CurrPage.Close;
                        end;
                    end else begin
                        // LFM  - Para PT não é nessário os momentos.
                        // varmomentCode := GetMoment(varSchoolingYear,varSchoolYear,varResponsibilityCenter);
                        // IF varmomentCode = FORMAT(0) THEN
                        //   EXIT;
                        SetFormStudents(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, '', varPageBreak, '', '', varType, varResponsibilityCenter,
                                       varStudyPlanCode, varButtonPrint);
                        Rec.Print(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varPageBreak, 0, 0, varmomentCode, '', '', '', varTemplateType, '', '', '');
                    end;
                end;
            Rec.Type::"Bulletin Pre Primary":
                begin
                    if (varStudentNo = '') then begin
                        rRegistrationClass.Reset;
                        rRegistrationClass.SetCurrentKey("Class No.");
                        rRegistrationClass.SetRange(Class, varClass);
                        rRegistrationClass.SetRange("School Year", varSchoolYear);
                        rRegistrationClass.SetRange("Schooling Year", varSchoolingYear);
                        rRegistrationClass.SetRange(Status, rRegistrationClass.Status::Subscribed);
                        if rRegistrationClass.Find('-') then begin
                            varmomentCode := Rec.GetMoment(varSchoolingYear, varSchoolYear, rRegistrationClass."Responsibility Center");
                            if (varmomentCode = '') or (varmomentCode = '0') then
                                exit;
                            c := rRegistrationClass.Count;
                            window.Open(text001);
                            repeat
                                p += 1;
                                varStudentNo := '';
                                window.Update(1, Round(p / c * 10000, 1));
                                varStudentNo := rRegistrationClass."Student Code No.";
                                if Rec.Type = Rec.Type::"Bulletin Pre Primary" then
                                    SetFormStudents(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varClass, varPageBreak, '', '', varType,
                                    varResponsibilityCenter, varStudyPlanCode, varButtonPrint);
                                Rec.Print(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varPageBreak, p, c, varmomentCode, varClass, '', '', varTemplateType
                                , '', '', '');
                            until rRegistrationClass.Next = 0;
                            varStudentNo := '';
                            window.Close;
                            CurrPage.Close;
                        end;
                    end else begin
                        varmomentCode := Rec.GetMoment(varSchoolingYear, varSchoolYear, varResponsibilityCenter);
                        if varmomentCode = Format(0) then
                            exit;
                        SetFormStudents(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, '', varPageBreak, '', '', varType, varResponsibilityCenter
                                       , varStudyPlanCode, varButtonPrint);
                        Rec.Print(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varPageBreak, 0, 0, varmomentCode, '', '', '', varTemplateType, '', '', '');
                    end;
                end;
            Rec.Type::"Bulletin Primary":
                begin
                    if (varStudentNo = '') then begin
                        rRegistrationClass.Reset;
                        rRegistrationClass.SetCurrentKey("Class No.");
                        rRegistrationClass.SetRange(Class, varClass);
                        rRegistrationClass.SetRange("School Year", varSchoolYear);
                        rRegistrationClass.SetRange("Schooling Year", varSchoolingYear);
                        rRegistrationClass.SetRange(Status, rRegistrationClass.Status::Subscribed);
                        if rRegistrationClass.Find('-') then begin
                            varmomentCode := Rec.GetMoment(varSchoolingYear, varSchoolYear, rRegistrationClass."Responsibility Center");
                            if (varmomentCode = '') or (varmomentCode = '0') then
                                exit;
                            c := rRegistrationClass.Count;
                            window.Open(text001);
                            repeat
                                p += 1;
                                varStudentNo := '';
                                window.Update(1, Round(p / c * 10000, 1));
                                varStudentNo := rRegistrationClass."Student Code No.";
                                if Rec.Type = Rec.Type::"Bulletin Primary" then
                                    SetFormStudents(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varClass, varPageBreak, '', '', varType,
                                    varResponsibilityCenter, varStudyPlanCode, varButtonPrint);
                                Rec.Print(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varPageBreak, p, c, varmomentCode, varClass, '', '', varTemplateType
                                , '', '', '');
                            until rRegistrationClass.Next = 0;
                            varStudentNo := '';
                            window.Close;
                            CurrPage.Close;
                        end;
                    end else begin
                        varmomentCode := Rec.GetMoment(varSchoolingYear, varSchoolYear, varResponsibilityCenter);
                        if varmomentCode = Format(0) then
                            exit;
                        SetFormStudents(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, '', varPageBreak, '', '', varType, varResponsibilityCenter
                                       , varStudyPlanCode, varButtonPrint);
                        Rec.Print(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varPageBreak, 0, 0, varmomentCode, '', '', '', varTemplateType, '', '', '');
                    end;
                end;
            Rec.Type::"Bulletin Lower Secondary":
                begin
                    if (varStudentNo = '') then begin
                        rRegistrationClass.Reset;
                        rRegistrationClass.SetCurrentKey("Class No.");
                        rRegistrationClass.SetRange(Class, varClass);
                        rRegistrationClass.SetRange("School Year", varSchoolYear);
                        rRegistrationClass.SetRange("Schooling Year", varSchoolingYear);
                        rRegistrationClass.SetRange(Status, rRegistrationClass.Status::Subscribed);
                        if rRegistrationClass.Find('-') then begin
                            varmomentCode := Rec.GetMoment(varSchoolingYear, varSchoolYear, rRegistrationClass."Responsibility Center");
                            if (varmomentCode = '') or (varmomentCode = '0') then
                                exit;
                            c := rRegistrationClass.Count;
                            window.Open(text001);
                            repeat
                                p += 1;
                                varStudentNo := '';
                                window.Update(1, Round(p / c * 10000, 1));
                                varStudentNo := rRegistrationClass."Student Code No.";
                                if Rec.Type = Rec.Type::"Bulletin Lower Secondary" then
                                    SetFormStudents(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varClass, varPageBreak, '', '', varType,
                                    varResponsibilityCenter, varStudyPlanCode, varButtonPrint);
                                Rec.Print(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varPageBreak, p, c, varmomentCode, varClass, '', '', varTemplateType
                                , '', '', '');
                            until rRegistrationClass.Next = 0;
                            varStudentNo := '';
                            window.Close;
                            CurrPage.Close;
                        end;
                    end else begin
                        varmomentCode := Rec.GetMoment(varSchoolingYear, varSchoolYear, varResponsibilityCenter);
                        if varmomentCode = Format(0) then
                            exit;
                        SetFormStudents(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, '', varPageBreak, '', '', varType, varResponsibilityCenter
                                       , varStudyPlanCode, varButtonPrint);
                        Rec.Print(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varPageBreak, 0, 0, varmomentCode, '', '', '', varTemplateType, '', '', '');
                    end;
                end;
            Rec.Type::"Bulletin Upper Secondary":
                begin
                    if (varStudentNo = '') then begin
                        rRegistrationClass.Reset;
                        rRegistrationClass.SetCurrentKey("Class No.");
                        rRegistrationClass.SetRange(Class, varClass);
                        rRegistrationClass.SetRange("School Year", varSchoolYear);
                        rRegistrationClass.SetRange("Schooling Year", varSchoolingYear);
                        rRegistrationClass.SetRange(Status, rRegistrationClass.Status::Subscribed);
                        if rRegistrationClass.Find('-') then begin
                            varmomentCode := Rec.GetMoment(varSchoolingYear, varSchoolYear, rRegistrationClass."Responsibility Center");
                            if (varmomentCode = '') or (varmomentCode = '0') then
                                exit;
                            c := rRegistrationClass.Count;
                            window.Open(text001);
                            repeat
                                p += 1;
                                varStudentNo := '';
                                window.Update(1, Round(p / c * 10000, 1));
                                varStudentNo := rRegistrationClass."Student Code No.";
                                if Rec.Type = Rec.Type::"Bulletin Upper Secondary" then
                                    SetFormStudents(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varClass, varPageBreak, '', '', varType,
                                    varResponsibilityCenter, varStudyPlanCode, varButtonPrint);
                                Rec.Print(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varPageBreak, p, c, varmomentCode, varClass, '', '', varTemplateType
                                , '', '', '');
                            until rRegistrationClass.Next = 0;
                            varStudentNo := '';
                            window.Close;
                            CurrPage.Close;
                        end;
                    end else begin
                        varmomentCode := Rec.GetMoment(varSchoolingYear, varSchoolYear, varResponsibilityCenter);
                        if varmomentCode = Format(0) then
                            exit;
                        SetFormStudents(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, '', varPageBreak, '', '', varType, varResponsibilityCenter
                                       , varStudyPlanCode, varButtonPrint);
                        Rec.Print(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varPageBreak, 0, 0, varmomentCode, '', '', '', varTemplateType, '', '', '');
                    end;
                end;
            Rec.Type::"Student Class":
                begin
                    SetFormStudents('', varSchoolYear, Rec.Code, varSchoolingYear, varClass, false, varTeacherCode, varSubjectCode, varType,
                    varResponsibilityCenter, varStudyPlanCode, varButtonPrint);
                    Rec.Print('', varSchoolYear, Rec.Code, varSchoolingYear, false, 0, 0, varmomentCode, varClass, varSubjectCode, varTeacherCode, varTemplateType
                    , '', '', '');
                end;
            Rec.Type::"Class Evaluation":
                begin
                    SetFormStudents('', varSchoolYear, Rec.Code, varSchoolingYear, varClass, false, '', '', varType, varResponsibilityCenter
                                   , varStudyPlanCode, varButtonPrint);
                    varmomentCode := Rec.GetMoment(varSchoolingYear, varSchoolYear, varResponsibilityCenter);
                    if varmomentCode = Format(0) then
                        exit;
                    Rec.Print('', varSchoolYear, Rec.Code, varSchoolingYear, false, 0, 0, varmomentCode, varClass, '', '', varTemplateType, '', '', '');
                end;
            Rec.Type::"Biographic Record Primary":
                begin
                    if (varStudentNo = '') then begin
                        rRegistrationClass.Reset;
                        rRegistrationClass.SetCurrentKey("Class No.");
                        rRegistrationClass.SetRange(Class, varClass);
                        rRegistrationClass.SetRange("School Year", varSchoolYear);
                        rRegistrationClass.SetRange("Schooling Year", varSchoolingYear);
                        rRegistrationClass.SetRange(Status, rRegistrationClass.Status::Subscribed);
                        if rRegistrationClass.Find('-') then begin
                            c := rRegistrationClass.Count;
                            window.Open(text001);
                            repeat
                                p += 1;
                                varStudentNo := '';
                                window.Update(1, Round(p / c * 10000, 1));
                                varStudentNo := rRegistrationClass."Student Code No.";
                                if Rec.Type = Rec.Type::"Biographic Record Primary" then
                                    SetFormStudents(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varClass, varPageBreak, '', '', varType,
                                    varResponsibilityCenter, varStudyPlanCode, varButtonPrint);
                                Rec.Print(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varPageBreak, p, c, '', varClass, '', '', varTemplateType
                                , '', '', '');
                            until rRegistrationClass.Next = 0;
                            varStudentNo := '';
                            window.Close;
                            CurrPage.Close;
                        end;
                    end else begin
                        SetFormStudents(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varClass, false, varTeacherCode, varSubjectCode, varType,
                        varResponsibilityCenter, varStudyPlanCode, varButtonPrint);
                        Rec.Print(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, false, 0, 0, '', '', '', '', varTemplateType, '', '', '');
                    end;
                end;
            Rec.Type::"Biographic Record Lower Secondary":
                begin
                    if (varStudentNo = '') then begin
                        rRegistrationClass.Reset;
                        rRegistrationClass.SetCurrentKey("Class No.");
                        rRegistrationClass.SetRange(Class, varClass);
                        rRegistrationClass.SetRange("School Year", varSchoolYear);
                        rRegistrationClass.SetRange("Schooling Year", varSchoolingYear);
                        rRegistrationClass.SetRange(Status, rRegistrationClass.Status::Subscribed);
                        if rRegistrationClass.Find('-') then begin
                            c := rRegistrationClass.Count;
                            window.Open(text001);
                            repeat
                                p += 1;
                                varStudentNo := '';
                                window.Update(1, Round(p / c * 10000, 1));
                                varStudentNo := rRegistrationClass."Student Code No.";
                                if Rec.Type = Rec.Type::"Biographic Record Lower Secondary" then
                                    SetFormStudents(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varClass, varPageBreak, '', '', varType,
                                    varResponsibilityCenter, varStudyPlanCode, varButtonPrint);
                                Rec.Print(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varPageBreak, p, c, '', varClass, '', '', varTemplateType, '', '', '');
                            until rRegistrationClass.Next = 0;
                            varStudentNo := '';
                            window.Close;
                            CurrPage.Close;
                        end;
                    end else begin
                        SetFormStudents(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varClass, false, varTeacherCode, varSubjectCode, varType,
                        varResponsibilityCenter, varStudyPlanCode, varButtonPrint);
                        Rec.Print(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, false, 0, 0, '', '', '', '', varTemplateType, '', '', '');
                    end;
                end;
            Rec.Type::"Biographic Record Upper Secondary":
                begin
                    if (varStudentNo = '') then begin
                        rRegistrationClass.Reset;
                        rRegistrationClass.SetCurrentKey("Class No.");
                        rRegistrationClass.SetRange(Class, varClass);
                        rRegistrationClass.SetRange("School Year", varSchoolYear);
                        rRegistrationClass.SetRange("Schooling Year", varSchoolingYear);
                        rRegistrationClass.SetRange(Status, rRegistrationClass.Status::Subscribed);
                        if rRegistrationClass.Find('-') then begin
                            c := rRegistrationClass.Count;
                            window.Open(text001);
                            repeat
                                p += 1;
                                varStudentNo := '';
                                window.Update(1, Round(p / c * 10000, 1));
                                varStudentNo := rRegistrationClass."Student Code No.";
                                if Rec.Type = Rec.Type::"Biographic Record Upper Secondary" then
                                    SetFormStudents(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varClass, varPageBreak, '', '', varType,
                                    varResponsibilityCenter, varStudyPlanCode, varButtonPrint);
                                Rec.Print(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varPageBreak, p, c, '', varClass, '', '', varTemplateType, '', '', '');
                            until rRegistrationClass.Next = 0;
                            varStudentNo := '';
                            window.Close;
                            CurrPage.Close;
                        end;
                    end else begin
                        SetFormStudents(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varClass, false, varTeacherCode, varSubjectCode, varType,
                        varResponsibilityCenter, varStudyPlanCode, varButtonPrint);
                        Rec.Print(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, false, 0, 0, '', '', '', '', varTemplateType, '', '', '');
                    end;
                end;
            Rec.Type::Services:
                begin
                    if (varStudentNo = '') then begin
                        rRegistrationClass.Reset;
                        rRegistrationClass.SetCurrentKey("Class No.");
                        rRegistrationClass.SetRange(Class, varClass);
                        rRegistrationClass.SetRange("School Year", varSchoolYear);
                        rRegistrationClass.SetRange("Schooling Year", varSchoolingYear);
                        rRegistrationClass.SetRange(Status, rRegistrationClass.Status::Subscribed);
                        if rRegistrationClass.Find('-') then begin
                            c := rRegistrationClass.Count;
                            window.Open(text001);
                            repeat
                                p += 1;
                                varStudentNo := '';
                                window.Update(1, Round(p / c * 10000, 1));
                                varStudentNo := rRegistrationClass."Student Code No.";
                                if Rec.Type = Rec.Type::Services then
                                    SetFormStudents(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varClass, varPageBreak, '', '', varType,
                                    varResponsibilityCenter, varStudyPlanCode, varButtonPrint);
                                Rec.Print(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varPageBreak, p, c, '', varClass, '', '', varTemplateType, '', '', '');
                            until rRegistrationClass.Next = 0;
                            varStudentNo := '';
                            window.Close;
                            CurrPage.Close;
                        end;
                    end else begin
                        SetFormStudents('', varSchoolYear, Rec.Code, varSchoolingYear, varClass, false, varTeacherCode, varSubjectCode, varType,
                        varResponsibilityCenter, varStudyPlanCode, varButtonPrint);
                        Rec.Print('', varSchoolYear, Rec.Code, varSchoolingYear, false, 0, 0, '', varClass, varSubjectCode, varTeacherCode, varTemplateType, '', '', '');
                    end;
                end;
            Rec.Type::"Legal LS - Qualificacions":
                begin
                    varOptionTypeReport := varOptionTypeReport::"Legal Reports";
                    SetFormStudents(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varClass, varPageBreak, '', '', varType,
                                   varResponsibilityCenter, varStudyPlanCode, varButtonPrint);
                    Rec.Print(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varPageBreak, p, c, '', varClass, '', '', varTemplateType,
                         varCurricularSubjects, varPersonalAspects, '');
                end;
            Rec.Type::"Legal LS - Historic":
                begin
                    if (varStudentNo = '') then begin
                        rRegistrationClass.Reset;
                        rRegistrationClass.SetCurrentKey("Class No.");
                        rRegistrationClass.SetRange(Class, varClass);
                        rRegistrationClass.SetRange("School Year", varSchoolYear);
                        rRegistrationClass.SetRange("Schooling Year", varSchoolingYear);
                        if rRegistrationClass.Find('-') then begin
                            c := rRegistrationClass.Count;
                            window.Open(text001);
                            repeat
                                p += 1;
                                varStudentNo := '';
                                window.Update(1, Round(p / c * 10000, 1));
                                varStudentNo := rRegistrationClass."Student Code No.";
                                if Rec.Type = Rec.Type::"Legal LS - Historic" then
                                    SetFormStudents(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varClass, varPageBreak, '', '', varType,
                                    varResponsibilityCenter, varStudyPlanCode, varButtonPrint);
                                Rec.Print(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varPageBreak, p, c, '', varClass, '', '', varTemplateType,
                                    varCurricularSubjects, varPersonalAspects, '');
                            until rRegistrationClass.Next = 0;
                            varStudentNo := '';
                            window.Close;
                            CurrPage.Close;
                        end;
                    end else begin
                        SetFormStudents(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, '', varPageBreak, '', '', varType, varResponsibilityCenter
                                       , varStudyPlanCode, varButtonPrint);
                        Rec.Print(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varPageBreak, 0, 0, '', '', '', '', varTemplateType,
                              varCurricularSubjects, varPersonalAspects, '');
                    end;
                end;
            Rec.Type::"Legal LS - Dossier":
                begin
                    if (varStudentNo = '') then begin
                        rRegistrationClass.Reset;
                        rRegistrationClass.SetCurrentKey("Class No.");
                        rRegistrationClass.SetRange(Class, varClass);
                        rRegistrationClass.SetRange("School Year", varSchoolYear);
                        rRegistrationClass.SetRange("Schooling Year", varSchoolingYear);
                        if rRegistrationClass.Find('-') then begin
                            c := rRegistrationClass.Count;
                            window.Open(text001);
                            repeat
                                p += 1;
                                varStudentNo := '';
                                window.Update(1, Round(p / c * 10000, 1));
                                varStudentNo := rRegistrationClass."Student Code No.";
                                if Rec.Type = Rec.Type::"Legal LS - Dossier" then
                                    SetFormStudents(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varClass, varPageBreak, '', '', varType,
                                    varResponsibilityCenter, varStudyPlanCode, varButtonPrint);
                                Rec.Print(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varPageBreak, p, c, '', varClass, '', '', varTemplateType, '', '', '');
                            until rRegistrationClass.Next = 0;
                            varStudentNo := '';
                            window.Close;
                            CurrPage.Close;
                        end;
                    end else begin
                        SetFormStudents(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, '', varPageBreak, '', '', varType, varResponsibilityCenter
                                       , varStudyPlanCode, varButtonPrint);
                        Rec.Print(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varPageBreak, 0, 0, '', '', '', '', varTemplateType, '', '', '');
                    end;
                end;
            Rec.Type::"Legal Pri - Actas Qualf":
                begin
                    if (varStudentNo = '') then begin
                        rRegistrationClass.Reset;
                        rRegistrationClass.SetCurrentKey("Class No.");
                        rRegistrationClass.SetRange(Class, varClass);
                        rRegistrationClass.SetRange("School Year", varSchoolYear);
                        rRegistrationClass.SetRange("Schooling Year", varSchoolingYear);
                        if rRegistrationClass.Find('-') then begin
                            c := rRegistrationClass.Count;
                            window.Open(text001);
                            repeat
                                p += 1;
                                varStudentNo := '';
                                window.Update(1, Round(p / c * 10000, 1));
                                varStudentNo := rRegistrationClass."Student Code No.";
                                if Rec.Type = Rec.Type::"Legal Pri - Actas Qualf" then
                                    SetFormStudents(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varClass, varPageBreak, '', '', varType,
                                    varResponsibilityCenter, varStudyPlanCode, varButtonPrint);
                                Rec.Print(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varPageBreak, p, c, '', varClass, '', '', varTemplateType,
                                     varCurricularSubjects, '', '');
                            until rRegistrationClass.Next = 0;
                            varStudentNo := '';
                            window.Close;
                            CurrPage.Close;
                        end;
                    end else begin
                        SetFormStudents(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, '', varPageBreak, '', '', varType, varResponsibilityCenter
                                       , varStudyPlanCode, varButtonPrint);
                        Rec.Print(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varPageBreak, 0, 0, '', '', '', '', varTemplateType,
                             varCurricularSubjects, '', '');
                    end;
                end;
            Rec.Type::"Legal Pri - Historic":
                begin
                    if (varStudentNo = '') then begin
                        rRegistrationClass.Reset;
                        rRegistrationClass.SetCurrentKey("Class No.");
                        rRegistrationClass.SetRange(Class, varClass);
                        rRegistrationClass.SetRange("School Year", varSchoolYear);
                        rRegistrationClass.SetRange("Schooling Year", varSchoolingYear);
                        if rRegistrationClass.Find('-') then begin
                            c := rRegistrationClass.Count;
                            window.Open(text001);
                            repeat
                                p += 1;
                                varStudentNo := '';
                                window.Update(1, Round(p / c * 10000, 1));
                                varStudentNo := rRegistrationClass."Student Code No.";
                                if Rec.Type = Rec.Type::"Legal Pri - Historic" then
                                    SetFormStudents(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varClass, varPageBreak, '', '', varType,
                                    varResponsibilityCenter, varStudyPlanCode, varButtonPrint);
                                Rec.Print(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varPageBreak, p, c, '', varClass, '', '', varTemplateType,
                                     varCurricularSubjects, '', '');
                            until rRegistrationClass.Next = 0;
                            varStudentNo := '';
                            window.Close;
                            CurrPage.Close;
                        end;
                    end else begin
                        SetFormStudents(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, '', varPageBreak, '', '', varType, varResponsibilityCenter
                                       , varStudyPlanCode, varButtonPrint);
                        Rec.Print(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varPageBreak, 0, 0, '', '', '', '', varTemplateType,
                             varCurricularSubjects, '', '');
                    end;
                end;
            Rec.Type::"Legal Pri - Dossier":
                begin
                    if (varStudentNo = '') then begin
                        rRegistrationClass.Reset;
                        rRegistrationClass.SetCurrentKey("Class No.");
                        rRegistrationClass.SetRange(Class, varClass);
                        rRegistrationClass.SetRange("School Year", varSchoolYear);
                        rRegistrationClass.SetRange("Schooling Year", varSchoolingYear);
                        if rRegistrationClass.Find('-') then begin
                            c := rRegistrationClass.Count;
                            window.Open(text001);
                            repeat
                                p += 1;
                                varStudentNo := '';
                                window.Update(1, Round(p / c * 10000, 1));
                                varStudentNo := rRegistrationClass."Student Code No.";
                                if Rec.Type = Rec.Type::"Legal Pri - Dossier" then
                                    SetFormStudents(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varClass, varPageBreak, '', '', varType,
                                    varResponsibilityCenter, varStudyPlanCode, varButtonPrint);
                                Rec.Print(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varPageBreak, p, c, '', varClass, '', '', varTemplateType,
                                     varCurricularSubjects, varPersonalAspects, varBasicSkills);
                            until rRegistrationClass.Next = 0;
                            varStudentNo := '';
                            window.Close;
                            CurrPage.Close;
                        end;
                    end else begin
                        SetFormStudents(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, '', varPageBreak, '', '', varType, varResponsibilityCenter
                                       , varStudyPlanCode, varButtonPrint);
                        Rec.Print(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varPageBreak, 0, 0, '', '', '', '', varTemplateType, varCurricularSubjects,
                        varPersonalAspects, varBasicSkills);
                    end;
                end;
            Rec.Type::"Legal UPP - Transfer":
                begin
                    if (varStudentNo = '') then begin
                        rRegistrationClass.Reset;
                        rRegistrationClass.SetCurrentKey("Class No.");
                        rRegistrationClass.SetRange(Class, varClass);
                        rRegistrationClass.SetRange("School Year", varSchoolYear);
                        rRegistrationClass.SetRange("Schooling Year", varSchoolingYear);
                        if rRegistrationClass.Find('-') then begin
                            c := rRegistrationClass.Count;
                            window.Open(text001);
                            repeat
                                p += 1;
                                varStudentNo := '';
                                window.Update(1, Round(p / c * 10000, 1));
                                varStudentNo := rRegistrationClass."Student Code No.";
                                if Rec.Type = Rec.Type::"Legal UPP - Transfer" then
                                    SetFormStudents(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varClass, varPageBreak, '', '', varType,
                                    varResponsibilityCenter, varStudyPlanCode, varButtonPrint);
                                Rec.Print(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varPageBreak, p, c, '', varClass, '', '', varTemplateType, '', '', '');
                            until rRegistrationClass.Next = 0;
                            varStudentNo := '';
                            window.Close;
                            CurrPage.Close;
                        end;
                    end else begin
                        SetFormStudents(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, '', varPageBreak, '', '', varType, varResponsibilityCenter
                                       , varStudyPlanCode, varButtonPrint);
                        Rec.Print(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varPageBreak, 0, 0, '', '', '', '', varTemplateType, '', '', '');
                    end;
                end;
            Rec.Type::"Legal UPP - Actas Qualf":
                begin
                    if (varStudentNo = '') then begin
                        rRegistrationClass.Reset;
                        rRegistrationClass.SetCurrentKey("Class No.");
                        rRegistrationClass.SetRange(Class, varClass);
                        rRegistrationClass.SetRange("School Year", varSchoolYear);
                        rRegistrationClass.SetRange("Schooling Year", varSchoolingYear);
                        if rRegistrationClass.Find('-') then begin
                            c := rRegistrationClass.Count;
                            window.Open(text001);
                            repeat
                                p += 1;
                                varStudentNo := '';
                                window.Update(1, Round(p / c * 10000, 1));
                                varStudentNo := rRegistrationClass."Student Code No.";
                                if Rec.Type = Rec.Type::"Legal UPP - Actas Qualf" then
                                    SetFormStudents(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varClass, varPageBreak, '', '', varType,
                                    varResponsibilityCenter, varStudyPlanCode, varButtonPrint);
                                Rec.Print(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varPageBreak, p, c, '', varClass, '', '', varTemplateType,
                                     varCurricularSubjects, varPersonalAspects, '');
                            until rRegistrationClass.Next = 0;
                            varStudentNo := '';
                            window.Close;
                            CurrPage.Close;
                        end;
                    end else begin
                        SetFormStudents(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, '', varPageBreak, '', '', varType, varResponsibilityCenter
                                       , varStudyPlanCode, varButtonPrint);
                        Rec.Print(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varPageBreak, 0, 0, '', '', '', '', varTemplateType,
                              varCurricularSubjects, varPersonalAspects, '');
                    end;
                end;
            Rec.Type::"Legal Pri - Individual Report":
                begin
                    if (varStudentNo = '') then begin
                        rRegistrationClass.Reset;
                        rRegistrationClass.SetCurrentKey("Class No.");
                        rRegistrationClass.SetRange(Class, varClass);
                        rRegistrationClass.SetRange("School Year", varSchoolYear);
                        rRegistrationClass.SetRange("Schooling Year", varSchoolingYear);
                        if rRegistrationClass.Find('-') then begin
                            c := rRegistrationClass.Count;
                            window.Open(text001);
                            repeat
                                p += 1;
                                varStudentNo := '';
                                window.Update(1, Round(p / c * 10000, 1));
                                varStudentNo := rRegistrationClass."Student Code No.";
                                if Rec.Type = Rec.Type::"Legal Pri - Individual Report" then
                                    SetFormStudents(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varClass, varPageBreak, '', '', varType,
                                    varResponsibilityCenter, varStudyPlanCode, varButtonPrint);
                                Rec.Print(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varPageBreak, p, c, '', varClass, '', '', varTemplateType,
                                     '', varPersonalAspects, varBasicSkills);
                            until rRegistrationClass.Next = 0;
                            varStudentNo := '';
                            window.Close;
                            CurrPage.Close;
                        end;
                    end else begin
                        SetFormStudents(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, '', varPageBreak, '', '', varType, varResponsibilityCenter
                                       , varStudyPlanCode, varButtonPrint);
                        Rec.Print(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varPageBreak, 0, 0, '', '', '', '', varTemplateType,
                             '', varPersonalAspects, varBasicSkills);
                    end;
                end;
            Rec.Type::"Legal UPP - Historic":
                begin
                    if (varStudentNo = '') then begin
                        rRegistrationClass.Reset;
                        rRegistrationClass.SetCurrentKey("Class No.");
                        rRegistrationClass.SetRange(Class, varClass);
                        rRegistrationClass.SetRange("School Year", varSchoolYear);
                        rRegistrationClass.SetRange("Schooling Year", varSchoolingYear);
                        if rRegistrationClass.Find('-') then begin
                            c := rRegistrationClass.Count;
                            window.Open(text001);
                            repeat
                                p += 1;
                                varStudentNo := '';
                                window.Update(1, Round(p / c * 10000, 1));
                                varStudentNo := rRegistrationClass."Student Code No.";
                                if Rec.Type = Rec.Type::"Legal UPP - Historic" then
                                    SetFormStudents(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varClass, varPageBreak, '', '', varType,
                                    varResponsibilityCenter, varStudyPlanCode, varButtonPrint);
                                Rec.Print(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varPageBreak, p, c, '', varClass, '', '', varTemplateType, '', '', '');
                            until rRegistrationClass.Next = 0;
                            varStudentNo := '';
                            window.Close;
                            CurrPage.Close;
                        end;
                    end else begin
                        SetFormStudents(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, '', varPageBreak, '', '', varType, varResponsibilityCenter
                                       , varStudyPlanCode, varButtonPrint);
                        Rec.Print(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varPageBreak, 0, 0, '', '', '', '', varTemplateType, '',
                        '', '');
                    end;
                end;
            Rec.Type::"Legal UPP - Dossier":
                begin
                    if (varStudentNo = '') then begin
                        rRegistrationClass.Reset;
                        rRegistrationClass.SetCurrentKey("Class No.");
                        rRegistrationClass.SetRange(Class, varClass);
                        rRegistrationClass.SetRange("School Year", varSchoolYear);
                        rRegistrationClass.SetRange("Schooling Year", varSchoolingYear);
                        if rRegistrationClass.Find('-') then begin
                            c := rRegistrationClass.Count;
                            window.Open(text001);
                            repeat
                                p += 1;
                                varStudentNo := '';
                                window.Update(1, Round(p / c * 10000, 1));
                                varStudentNo := rRegistrationClass."Student Code No.";
                                if Rec.Type = Rec.Type::"Legal UPP - Dossier" then
                                    SetFormStudents(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varClass, varPageBreak, '', '', varType,
                                    varResponsibilityCenter, varStudyPlanCode, varButtonPrint);
                                Rec.Print(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varPageBreak, p, c, '', varClass, '', '', varTemplateType, '', '', '');
                            until rRegistrationClass.Next = 0;
                            varStudentNo := '';
                            window.Close;
                            CurrPage.Close;
                        end;
                    end else begin
                        SetFormStudents(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, '', varPageBreak, '', '', varType, varResponsibilityCenter
                                       , varStudyPlanCode, varButtonPrint);
                        Rec.Print(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varPageBreak, 0, 0, '', '', '', '', varTemplateType, '', '', '');
                    end;
                end;
            Rec.Type::"Legal LS - Transfer":
                begin
                    if (varStudentNo = '') then begin
                        rRegistrationClass.Reset;
                        rRegistrationClass.SetCurrentKey("Class No.");
                        rRegistrationClass.SetRange(Class, varClass);
                        rRegistrationClass.SetRange("School Year", varSchoolYear);
                        rRegistrationClass.SetRange("Schooling Year", varSchoolingYear);
                        if rRegistrationClass.Find('-') then begin
                            c := rRegistrationClass.Count;
                            window.Open(text001);
                            repeat
                                p += 1;
                                varStudentNo := '';
                                window.Update(1, Round(p / c * 10000, 1));
                                varStudentNo := rRegistrationClass."Student Code No.";
                                if Rec.Type = Rec.Type::"Legal LS - Transfer" then
                                    SetFormStudents(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varClass, varPageBreak, '', '', varType,
                                    varResponsibilityCenter, varStudyPlanCode, varButtonPrint);
                                Rec.Print(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varPageBreak, p, c, '', varClass, '', '', varTemplateType,
                                     varCurricularSubjects, '', varBasicSkills);
                            until rRegistrationClass.Next = 0;
                            varStudentNo := '';
                            window.Close;
                            CurrPage.Close;
                        end;
                    end else begin
                        SetFormStudents(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, '', varPageBreak, '', '', varType, varResponsibilityCenter
                                       , varStudyPlanCode, varButtonPrint);
                        Rec.Print(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varPageBreak, 0, 0, '', '', '', '', varTemplateType,
                             varCurricularSubjects, '', varBasicSkills);
                    end;
                end;
            Rec.Type::"Legal Pri - Transfer":
                begin
                    if (varStudentNo = '') then begin
                        rRegistrationClass.Reset;
                        rRegistrationClass.SetCurrentKey("Class No.");
                        rRegistrationClass.SetRange(Class, varClass);
                        rRegistrationClass.SetRange("School Year", varSchoolYear);
                        rRegistrationClass.SetRange("Schooling Year", varSchoolingYear);
                        if rRegistrationClass.Find('-') then begin
                            c := rRegistrationClass.Count;
                            window.Open(text001);
                            repeat
                                p += 1;
                                varStudentNo := '';
                                window.Update(1, Round(p / c * 10000, 1));
                                varStudentNo := rRegistrationClass."Student Code No.";
                                if Rec.Type = Rec.Type::"Legal Pri - Transfer" then
                                    SetFormStudents(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varClass, varPageBreak, '', '', varType,
                                    varResponsibilityCenter, varStudyPlanCode, varButtonPrint);
                                Rec.Print(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varPageBreak, p, c, '', varClass, '', '', varTemplateType,
                                     varCurricularSubjects, varPersonalAspects, varBasicSkills);
                            until rRegistrationClass.Next = 0;
                            varStudentNo := '';
                            window.Close;
                            CurrPage.Close;
                        end;
                    end else begin
                        SetFormStudents(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, '', varPageBreak, '', '', varType, varResponsibilityCenter
                                       , varStudyPlanCode, varButtonPrint);
                        Rec.Print(varStudentNo, varSchoolYear, Rec.Code, varSchoolingYear, varPageBreak, 0, 0, '', '', '', '', varTemplateType,
                             varCurricularSubjects, varPersonalAspects, varBasicSkills);
                    end;
                end;
            Rec.Type::"Class Meeting":
                begin
                    Rec.PrintMeeting(rTimetableTeacher);
                end;
            Rec.Type::"Department Meeting":
                begin
                    Rec.PrintMeeting(rTimetableTeacher);
                end;
            Rec.Type::"Head Department Meeting":
                begin
                    Rec.PrintMeeting(rTimetableTeacher);
                end;
            Rec.Type::"Level Meeting":
                begin
                    Rec.PrintMeeting(rTimetableTeacher);
                end;
            Rec.Type::"Pre-registration":
                begin
                    Rec.PrintCandidate(rCandidates);
                end;




        end;

        CurrPage.Close;
    end;

    //[Scope('OnPrem')]
    procedure Updatetemplates()
    begin
        case varOptionTypeReport of
            varOptionTypeReport::All:
                begin
                    AllVisible := true;
                    BulletinsVisible := false;
                    "Biographic RecordsVisible" := false;
                    StudentVisible := false;
                    ClassVisible := false;
                    ServicesVisible := false;
                    RelationParentStudentsVisible := false;
                    "Legal ReportsVisible" := false;
                    MinutesVisible := false;
                    CandidatesVisible := false;
                end;
            varOptionTypeReport::Bulletin:
                begin
                    AllVisible := false;
                    BulletinsVisible := true;
                    "Biographic RecordsVisible" := false;
                    StudentVisible := false;
                    ClassVisible := false;
                    ServicesVisible := false;
                    RelationParentStudentsVisible := false;
                    "Legal ReportsVisible" := false;
                    MinutesVisible := false;
                    CandidatesVisible := false;
                end;
            varOptionTypeReport::"Biographic Records":
                begin
                    AllVisible := false;
                    BulletinsVisible := false;
                    "Biographic RecordsVisible" := true;
                    StudentVisible := false;
                    ClassVisible := false;
                    ServicesVisible := false;
                    RelationParentStudentsVisible := false;
                    "Legal ReportsVisible" := false;
                    MinutesVisible := false;
                    CandidatesVisible := false;
                end;
            varOptionTypeReport::Student:
                begin
                    AllVisible := false;
                    BulletinsVisible := false;
                    "Biographic RecordsVisible" := false;
                    StudentVisible := true;
                    ClassVisible := false;
                    ServicesVisible := false;
                    RelationParentStudentsVisible := false;
                    "Legal ReportsVisible" := false;
                    MinutesVisible := false;
                    CandidatesVisible := false;
                end;
            varOptionTypeReport::Class:
                begin
                    AllVisible := false;
                    BulletinsVisible := false;
                    "Biographic RecordsVisible" := false;
                    StudentVisible := false;
                    ClassVisible := true;
                    ServicesVisible := false;
                    RelationParentStudentsVisible := false;
                    "Legal ReportsVisible" := false;
                    MinutesVisible := false;
                    CandidatesVisible := false;
                end;
            varOptionTypeReport::Services:
                begin
                    AllVisible := false;
                    BulletinsVisible := false;
                    "Biographic RecordsVisible" := false;
                    StudentVisible := false;
                    ClassVisible := false;
                    ServicesVisible := true;
                    RelationParentStudentsVisible := false;
                    "Legal ReportsVisible" := false;
                    MinutesVisible := false;
                    CandidatesVisible := false;
                end;
            varOptionTypeReport::"Relation Parents Students":
                begin
                    AllVisible := false;
                    BulletinsVisible := false;
                    "Biographic RecordsVisible" := false;
                    StudentVisible := false;
                    ClassVisible := false;
                    ServicesVisible := false;
                    "Legal ReportsVisible" := false;
                    RelationParentStudentsVisible := true;
                    MinutesVisible := false;
                    CandidatesVisible := false;
                end;

            varOptionTypeReport::Minutes:
                begin
                    AllVisible := false;
                    BulletinsVisible := false;
                    "Biographic RecordsVisible" := false;
                    StudentVisible := false;
                    ClassVisible := false;
                    ServicesVisible := false;
                    "Legal ReportsVisible" := false;
                    RelationParentStudentsVisible := false;
                    MinutesVisible := true;
                    CandidatesVisible := false;
                end;
            varOptionTypeReport::Candidates:
                begin
                    AllVisible := false;
                    BulletinsVisible := false;
                    "Biographic RecordsVisible" := false;
                    StudentVisible := false;
                    ClassVisible := false;
                    ServicesVisible := false;
                    "Legal ReportsVisible" := false;
                    RelationParentStudentsVisible := false;
                    MinutesVisible := false;
                    CandidatesVisible := true;
                end;


            varOptionTypeReport::"Legal Reports":
                begin
                    AllVisible := false;
                    BulletinsVisible := false;
                    "Biographic RecordsVisible" := false;
                    StudentVisible := false;
                    ClassVisible := false;
                    ServicesVisible := false;
                    RelationParentStudentsVisible := false;
                    "Legal ReportsVisible" := true;
                    MinutesVisible := false;
                    CandidatesVisible := false;
                    //IF varType <> 0 THEN
                    //CurrForm."Legal Reports".EDITABLE(FALSE);
                    if varType = varType::"Legal Pri - Actas Qualf" then begin
                        BasicSkillsEnable := false;
                        PersonalAspectsEnable := false;
                    end;
                    if varType = varType::"Legal Pri - Transfer" then begin
                        BasicSkillsEnable := true;
                        PersonalAspectsEnable := true;
                    end;
                    if varType = varType::"Legal Pri - Individual Report" then begin
                        BasicSkillsEnable := true;
                        PersonalAspectsEnable := true;
                        CurricularSubjectsEnable := false;
                    end;
                    if varType = varType::"Legal Pri - Historic" then begin
                        BasicSkillsEnable := false;
                        PersonalAspectsEnable := false;
                        CurricularSubjectsEnable := true;
                    end;
                    if varType = varType::"Legal LS - Historic" then begin
                        BasicSkillsEnable := false;
                        "Optional groupEnable" := true;
                        CurricularSubjectsEnable := true;
                    end;
                    if varType = varType::"Legal LS - Qualificacions" then begin
                        BasicSkillsEnable := false;
                        "Optional groupEnable" := true;
                        CurricularSubjectsEnable := true;
                    end;
                    if varType = varType::"Legal LS - Dossier" then begin
                        BasicSkillsEnable := false;
                        "Optional groupEnable" := true;
                        CurricularSubjectsEnable := true;
                    end;
                end;
        end;

        case varTemplateType of
            varTemplateType::Word:
                begin
                    Rec.SetFilter("File Extension", '=%1|%2|%3|%4', 'DOC', 'DOCX', 'doc', 'docx');
                end;
            varTemplateType::Excel:
                begin
                    Rec.SetFilter("File Extension", '=%1|%2|%3|%4', 'XLS', 'XLSX', 'xls', 'xlsx');
                end;
            varTemplateType::Import:
                begin
                    Rec.SetRange("File Extension", '');
                end;
        end;

        if CurrPage.LookupMode and (varType = 0) and not varButtonPrint then begin
            CodeEditable := false;
            DescriptionEditable := false;
            "Print ButtonEnable" := false;
        end else begin
            if CurrPage.LookupMode and (varType <> 0) then begin
                if not varButtonPrint then begin
                    okVisible := true;
                    CancelVisible := true;
                    "Print ButtonEnable" := false;
                end;
                if varButtonPrint then begin
                    okVisible := false;
                    CancelVisible := false;
                    "Print ButtonEnable" := true;
                    CodeEditable := false;
                    DescriptionEditable := false;
                end;
            end;
        end;

        if CurrPage.LookupMode then begin
            if (varType <> Rec.Type::" ") and (varType <> varType::"Class Evaluation") then begin
                ExcelEnable := false;
                WordEnable := true;
                ImportEnable := false;
                if varType = varType::Services then begin
                    if varSubjectCode = Text003 then begin
                        ExcelEnable := true;
                        WordEnable := false;
                        ImportEnable := false;
                        varTemplateType := varTemplateType::Excel;
                    end;
                    if varSubjectCode = text002 then begin
                        ExcelEnable := false;
                        WordEnable := true;
                        ImportEnable := false;
                        varTemplateType := varTemplateType::Word;
                    end;
                end;
            end else begin
                ExcelEnable := true;
                WordEnable := true;
                if varType = varType::"Class Evaluation" then begin
                    if varSubjectCode = Text003 then begin
                        ExcelEnable := true;
                        WordEnable := false;
                        ImportEnable := false;
                        varTemplateType := varTemplateType::Excel;
                    end;
                    if varSubjectCode = text002 then begin
                        ExcelEnable := false;
                        WordEnable := true;
                        ImportEnable := false;
                        varTemplateType := varTemplateType::Word;
                    end;
                end;
            end;
        end else begin
            CodeEditable := true;
            DescriptionEditable := true;
            if (varType <> varType::" ") then begin
                ImportEnable := true;
                ExcelEnable := true;
                WordEnable := true;
            end else begin
                ImportEnable := false;
                WordEnable := false;
                ExcelEnable := false;
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure UpdateSections()
    begin
        if "Legal ReportsVisible" then begin
            rStruEduCountry.Reset;
            rStruEduCountry.SetRange("Schooling Year", varSchoolingYear);
            rStruEduCountry.SetFilter("Edu. Level", '= %1|%2', rStruEduCountry."Edu. Level"::"Primary Edu.",
            rStruEduCountry."Edu. Level"::"Lower Secondary Edu.");
            if rStruEduCountry.FindSet then begin
                "Option ReportVisible" := true;
            end;
        end else begin
            "Option ReportVisible" := false;
        end;
    end;

    //[Scope('OnPrem')]
    procedure UpdateSize()
    var
        l_TableHeight: Integer;
        l_LastTableHeight: Integer;
    begin
        if "Legal ReportsVisible" then begin
            rStruEduCountry.Reset;
            rStruEduCountry.SetRange("Schooling Year", varSchoolingYear);
            rStruEduCountry.SetFilter("Edu. Level", '= %1|%2', rStruEduCountry."Edu. Level"::"Primary Edu.",
            rStruEduCountry."Edu. Level"::"Lower Secondary Edu.");
            if rStruEduCountry.FindSet then begin
                l_TableHeight := "Option ReportHeight";
                l_LastTableHeight := TableBoxHeight;
                TableBoxHeight := (l_LastTableHeight - l_TableHeight);
                varSize := 1;
            end;
            if rStruEduCountry."Edu. Level" = rStruEduCountry."Edu. Level"::"Lower Secondary Edu." then begin
                PersonalAspectsVisible := false;
                "Optional groupVisible" := true;
            end else begin
                PersonalAspectsVisible := true;
                "Optional groupVisible" := false;
            end;
            "Legal ReportsEditable" := false;
        end else begin
            if varSize = 1 then begin
                TableBoxHeight := 12691;
                Clear(varSize);
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure GetOptionsGroups(var pCurricularSubjects: Code[20]; var pPersonalAspects: Code[20]; var pBasicSkills: Code[20])
    begin
        pCurricularSubjects := varCurricularSubjects;
        pPersonalAspects := varPersonalAspects;
        pBasicSkills := varBasicSkills;
    end;

    //[Scope('OnPrem')]
    procedure SetFormMinutes(pTimetableTeacher: Record "Timetable-Teacher")
    begin
        rTimetableTeacher := pTimetableTeacher;
        varButtonPrint := true;
    end;

    //[Scope('OnPrem')]
    procedure SetFormCandidates(pCandidates: Record Candidate)
    begin
        rCandidates := pCandidates;
        varButtonPrint := true;
    end;

    local procedure ExcelvarTemplateTypeOnAfterVal()
    begin
        if varType <> 0 then
            Rec.SetRange(Type, varType);
        Updatetemplates;
    end;

    local procedure WordvarTemplateTypeOnAfterVali()
    begin
        if varType <> 0 then
            Rec.SetRange(Type, varType);
        Updatetemplates;
    end;

    local procedure varTemplateTypeOnAfterValidate()
    begin
        if varType <> 0 then
            Rec.SetRange(Type, varType);
        Updatetemplates;
    end;

    local procedure varTypeC1102065001OnAfterValid()
    begin
        Rec.SetRange(Type, varType);
        Updatetemplates;
        CurrPage.Update(false);
    end;

    local procedure varTypeC1102065000OnAfterValid()
    begin
        Rec.SetRange(Type, varType);
        Updatetemplates;
        CurrPage.Update(false);
    end;

    local procedure varTypeC1102065004OnAfterValid()
    begin
        Rec.SetRange(Type, varType);
        Updatetemplates;
        UpdateSections;
        CurrPage.Update(false);
    end;

    local procedure varTypeC1102065008OnAfterValid()
    begin
        Rec.SetRange(Type, varType);
        Updatetemplates;
        CurrPage.Update(false);
    end;

    local procedure varOptionTypeReportOnAfterVali()
    begin
        Clear(varType);
        Updatetemplates;
        if "Print ButtonEnable" then
            UpdateSize;
    end;

    local procedure varTypeC1102065012OnAfterValid()
    begin
        Rec.SetRange(Type, varType);
        Updatetemplates;
        CurrPage.Update(false);
    end;

    local procedure varTypeC1102065013OnAfterValid()
    begin
        Rec.SetRange(Type, varType);
        Updatetemplates;
        CurrPage.Update(false);
    end;

    local procedure varTypeC1102065005OnAfterValid()
    begin
        Rec.SetRange(Type, varType);
        Updatetemplates;
        CurrPage.Update(false);
    end;

    local procedure varTypeC1102065018OnAfterValid()
    begin
        Rec.SetRange(Type, varType);
        Updatetemplates;
        CurrPage.Update(false);
    end;

    local procedure varTypeC1102065016OnAfterValid()
    begin
        Rec.SetRange(Type, varType);
        Updatetemplates;
        CurrPage.Update(false);
    end;

    local procedure varTypeC1102065027OnAfterValid()
    begin
        Rec.SetRange(Type, varType);
        Updatetemplates;
        CurrPage.Update(false);
    end;

    local procedure OnAfterGetCurrRecord2()
    begin
        xRec := Rec;
        Updatetemplates;
    end;

    local procedure ExcelvarTemplateTypeOnPush()
    begin
        CurrPage.Update(false);
    end;

    local procedure WordvarTemplateTypeOnPush()
    begin
        CurrPage.Update(false);
    end;

    local procedure varTemplateTypeOnPush()
    begin
        CurrPage.Update(false);
    end;

    local procedure varTemplateTypeOnValidate()
    begin
        if not (ImportEnable) then
            Error(Text666, varTemplateType);
        varTemplateTypeOnPush;
        varTemplateTypeOnAfterValidate;
    end;

    local procedure WordvarTemplateTypeOnValidate()
    begin
        if not (WordEnable) then
            Error(Text666, varTemplateType);
        WordvarTemplateTypeOnPush;
        WordvarTemplateTypeOnAfterVali;
    end;

    local procedure ExcelvarTemplateTypeOnValidate()
    begin
        if not (ExcelEnable) then
            Error(Text666, varTemplateType);
        ExcelvarTemplateTypeOnPush;
        ExcelvarTemplateTypeOnAfterVal;
    end;
}

#pragma implicitwith restore

