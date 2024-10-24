report 52797 "Copy Temp Timetable"
{
    Caption = 'Copy Template Timetable';
    ProcessingOnly = true;

    dataset
    {
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(vSchoolYearOld; vSchoolYearOld)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Old School Year';
                        TableRelation = "School Year"."School Year" WHERE(Status = FILTER(Active | Planning));
                    }
                    field(vTemplateCodeOld; vTemplateCodeOld)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Old Template Code';
                        TableRelation = "Template Timetable"."Template Code";
                    }
                    field(vSchoolYearNew; vSchoolYearNew)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'New School Year';
                        TableRelation = "School Year"."School Year" WHERE(Status = FILTER(Active | Planning));
                    }
                    field(vTemplateCodeNew; vTemplateCodeNew)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'New Template Code';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        //Início - C+_RSC_C+ 2008.09.19 - Validações
        if vSchoolYearNew = '' then
            Error(Text0001);

        if vSchoolYearOld = vSchoolYearNew then
            Error(Text0002);


        CopyTempTimetable;

        Message(Text0005);
    end;

    var
        vSchoolYearOld: Code[10];
        vSchoolYearNew: Code[10];
        Text0001: Label 'The School Year is empty.';
        Text0002: Label 'The new school year cannot be identical to the old school year.';
        Text0003: Label 'The Old Template code is empty.';
        Text0004: Label 'The New template code is empty.';
        Text0005: Label 'Copies conducted successfully.';
        vTemplateCodeOld: Code[20];
        vTemplateCodeNew: Code[20];


    procedure CopyTempTimetable()
    var
        l_rTemplateTimetable: Record "Template Timetable";
        l_rTemplateTimetableNew: Record "Template Timetable";
        aux_rTemplateTimetable: Record "Template Timetable";
        auxN_linha: Integer;
    begin
        l_rTemplateTimetable.Reset;
        l_rTemplateTimetable.SetRange(Type, l_rTemplateTimetable.Type::Header);
        l_rTemplateTimetable.SetRange("School Year", vSchoolYearOld);
        if vTemplateCodeOld <> '' then
            l_rTemplateTimetable.SetRange("Template Code", vTemplateCodeOld);
        if l_rTemplateTimetable.Find('-') then begin
            repeat
                l_rTemplateTimetableNew.Init;
                l_rTemplateTimetableNew.TransferFields(l_rTemplateTimetable);
                l_rTemplateTimetableNew."School Year" := vSchoolYearNew;
                if vTemplateCodeNew <> '' then
                    l_rTemplateTimetableNew."Template Code" := vTemplateCodeNew;
                l_rTemplateTimetableNew.Insert(true);
            until l_rTemplateTimetable.Next = 0;
        end;

        //2011.10.13 - procurar o nº linha do cab. para passar para as linhas porque seixou de ser autoincrement
        Clear(auxN_linha);
        aux_rTemplateTimetable.Reset;
        aux_rTemplateTimetable.SetRange(aux_rTemplateTimetable."School Year", vSchoolYearNew);
        aux_rTemplateTimetable.SetRange(aux_rTemplateTimetable.Type, aux_rTemplateTimetable.Type::Header);
        aux_rTemplateTimetable.SetRange(aux_rTemplateTimetable."Template Code", vTemplateCodeNew);
        if aux_rTemplateTimetable.FindFirst then
            auxN_linha := aux_rTemplateTimetable."Line No.";


        l_rTemplateTimetable.Reset;
        l_rTemplateTimetable.SetRange(Type, l_rTemplateTimetable.Type::Lines);
        l_rTemplateTimetable.SetRange("School Year", vSchoolYearOld);
        if vTemplateCodeOld <> '' then
            l_rTemplateTimetable.SetRange("Template Code", vTemplateCodeOld);
        if l_rTemplateTimetable.Find('-') then begin
            repeat
                l_rTemplateTimetableNew.Init;
                l_rTemplateTimetableNew.TransferFields(l_rTemplateTimetable);
                l_rTemplateTimetableNew."School Year" := vSchoolYearNew;
                if vTemplateCodeNew <> '' then
                    l_rTemplateTimetableNew."Template Code" := vTemplateCodeNew;
                l_rTemplateTimetableNew."Line Header" := auxN_linha;//2011.10.13
                l_rTemplateTimetableNew.Insert(true);
            until l_rTemplateTimetable.Next = 0;
        end;
    end;


    procedure GETTempTimetable(pSchoolYear: Code[9]; pTempTimetable: Code[20])
    begin
        vSchoolYearOld := pSchoolYear;
        vTemplateCodeOld := pTempTimetable;
    end;
}

