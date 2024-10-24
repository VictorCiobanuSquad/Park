table 52811 Templates
{
    Caption = 'Templates';
    DrillDownPageID = Templates;
    LookupPageID = Templates;
    Permissions = TableData "Assessing Students" = rimd;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,Registration Sheet,Bulletin Pre Primary,Bulletin Primary,Bulletin Lower Secondary,Bulletin Upper Secondary,Student Class,Class Evaluation,Biographic Record Primary,Biographic Record Secondary,Biographic Record Upper Secondary,Services,Legal LS - Transfer,Legal LS - Qualificacions,Legal LS - Historic,Legal LS - Dossier,Legal Pri - Actas Qualf,Legal Pri - Transfer,Legal Pri - Historic,Legal Pri - Dossier,Legal Pri - Individual Report,Legal UPP - Actas Qualf,Legal UPP - Transfer,Legal UPP - Historic,Legal UPP - Dossier,Relation Parents Students,Class Meeting,Department Meeting,Head Department Meeting,Level Meeting,Pre-registration';
            OptionMembers = " ","Registration Sheet","Bulletin Pre Primary","Bulletin Primary","Bulletin Lower Secondary","Bulletin Upper Secondary","Student Class","Class Evaluation","Biographic Record Primary","Biographic Record Lower Secondary","Biographic Record Upper Secondary",Services,"Legal LS - Transfer","Legal LS - Qualificacions","Legal LS - Historic","Legal LS - Dossier","Legal Pri - Actas Qualf","Legal Pri - Transfer","Legal Pri - Historic","Legal Pri - Dossier","Legal Pri - Individual Report","Legal UPP - Actas Qualf","Legal UPP - Transfer","Legal UPP - Historic","Legal UPP - Dossier","Relation Parents Students","Class Meeting","Department Meeting","Head Department Meeting","Level Meeting","Pre-registration";
        }
        field(3; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(4; "File Import"; BLOB)
        {
            Caption = 'File Import';
            Compressed = false;
        }
        field(6; "File Extension"; Text[250])
        {
            Caption = 'File Extension';
        }
    }

    keys
    {
        key(Key1; Type, "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if Type = 0 then
            Error(Text004);
    end;

    var
        Filename: Text[256];
        Link: Text[255];
        FileMgt: Codeunit "File Management";
        AttachmentManagement: Codeunit AttachmentManagement;
        Text001: Label 'There is no file associated to the contract.';
        Text002: Label 'Contract %1 was sucessfully exported!';
        rRegistration: Record Registration;
        rAssessingStudents: Record "Assessing Students";
        varStudentno: Code[50];
        varSchoolYear: Code[50];
        varTemplatecode: Code[50];
        varSchoolingYear: Code[50];
        varPagebreakNo: Integer;
        VarMomentCode: Code[20];
        Text003: Label 'All Moments';
        Text004: Label 'Must Choose the Report Type.';
        InStr: InStream;
        OutStr: OutStream;


    procedure Import()
    var
        _varText: Text[255];
        _varTextA: Text[255];
        _varTextB: Text[255];
        _varTextC: Text[255];
        _varTextD: Text[255];
        _varTextE: Text[255];
        Text001: Label 'Selecionar o Caminho do Documento';
        Text002: Label '<*.*>';
        Text003: Label '< >';
        Text011: Label 'Selecionar o Caminho do Documento';
        Text012: Label '<*.*>';
        Text013: Label '< >';
        Text004: Label 'Word Documents(*.doc,*.docx)|*.doc;*.docx|Excel Documents (*.xls,*.xlsx)|*.xls;*.xlsx|All Files (*.*)|*.*';
        Text005: Label 'File must be (doc/docx) Or (Xls/Xlsx).';
        Text006: Label 'O ficheiro %1 foi importado com sucesso!';
        Text007: Label 'File must be (Xls/Xlsx).';
        Text008: Label 'File must be (doc/docx).';
        i: Integer;
        _varText2: Text[255];
    begin

        Clear(_varText);
        Clear(Link);

        case Type of
            Type::"Bulletin Lower Secondary",
          Type::"Bulletin Upper Secondary",
          Type::"Bulletin Pre Primary",
          Type::"Bulletin Primary",
          Type::"Student Class",
          Type::"Class Evaluation",
          Type::"Biographic Record Primary",
          Type::"Biographic Record Lower Secondary",
          Type::"Biographic Record Upper Secondary",
          Type::Services,
          Type::"Legal LS - Transfer",
          Type::"Legal LS - Qualificacions",
          Type::"Legal LS - Historic",
          Type::"Legal LS - Dossier",
          Type::"Legal Pri - Actas Qualf",
          Type::"Legal Pri - Dossier",
          Type::"Legal Pri - Historic",
          Type::"Legal Pri - Individual Report",
          Type::"Legal Pri - Transfer",
          Type::"Legal UPP - Actas Qualf",
          Type::"Legal UPP - Transfer",
          Type::"Legal UPP - Dossier",
          Type::"Legal UPP - Historic",
          Type::"Relation Parents Students",
          Type::"Class Meeting",
          Type::"Department Meeting",
          Type::"Head Department Meeting",
          Type::"Level Meeting",
          Type::"Pre-registration",
          //Type::"Registration Sheet": Link := CommonDialogMgt.OpenFile('IMPORT',Filename,4,Text004,0);
          Type::"Registration Sheet":
                //Link := FileMgt.OpenFileDialog('IMPORT', Filename, Text004);
                UploadIntoStream('', '', Text004, Link, InStr);
        end;


        if StrLen(Link) > 0 then begin
            //  _varText := COPYSTR(Link,(STRLEN(Link)-3),5);
            _varText := UpperCase(FileExtension(Link));

            case Type of
                /*
                Type::"Bulletin Lower Secondary":BEGIN
                  IF (UPPERCASE(_varText) <> 'DOC') THEN
                    IF (UPPERCASE(_varText) <> 'DOCX') THEN
                       ERROR(Text008);
                END;
                */
                Type::"Bulletin Upper Secondary":
                    begin
                        if (UpperCase(_varText) <> 'DOC') then
                            if (UpperCase(_varText) <> 'DOCX') then
                                Error(Text008);
                    end;

                Type::"Bulletin Pre Primary":
                    begin
                        if (UpperCase(_varText) <> 'DOC') then
                            if (UpperCase(_varText) <> 'DOCX') then
                                Error(Text008);

                    end;
                /*
                Type::"Bulletin Primary":BEGIN
                  IF (UPPERCASE(_varText) <> 'DOC') THEN
                    IF (UPPERCASE(_varText) <> 'DOCX') THEN
                       ERROR(Text008);
                END;
                */
                Type::"Student Class":
                    begin
                        if (UpperCase(_varText) <> 'DOC') then
                            if (UpperCase(_varText) <> 'DOCX') then
                                Error(Text008);
                    end;
                Type::"Class Evaluation":
                    begin
                        if (UpperCase(_varText) <> 'DOC') then
                            if (UpperCase(_varText) <> 'DOCX') then
                                if (UpperCase(_varText) <> 'XLS') then
                                    if (UpperCase(_varText) <> 'XLSX') then
                                        Error(Text005);
                    end;
                Type::"Registration Sheet":
                    begin
                        if (UpperCase(_varText) <> 'DOC') then
                            if (UpperCase(_varText) <> 'DOCX') then
                                Error(Text008);
                    end;
                Type::"Biographic Record Primary":
                    begin
                        if (UpperCase(_varText) <> 'DOC') then
                            if (UpperCase(_varText) <> 'DOCX') then
                                Error(Text008);
                    end;
                Type::"Biographic Record Lower Secondary":
                    begin
                        if (UpperCase(_varText) <> 'DOC') then
                            if (UpperCase(_varText) <> 'DOCX') then
                                Error(Text008);
                    end;
                Type::"Biographic Record Upper Secondary":
                    begin
                        if (UpperCase(_varText) <> 'DOC') then
                            if (UpperCase(_varText) <> 'DOCX') then
                                Error(Text008);
                    end;
                Type::"Legal LS - Transfer":
                    begin
                        if (UpperCase(_varText) <> 'DOC') then
                            if (UpperCase(_varText) <> 'DOCX') then
                                Error(Text008);
                    end;
                Type::Services:
                    begin
                        if (UpperCase(_varText) <> 'XLS') then
                            if (UpperCase(_varText) <> 'XLSX') then
                                Error(Text007);
                    end;
                Type::"Legal LS - Qualificacions":
                    begin
                        if (UpperCase(_varText) <> 'DOC') then
                            if (UpperCase(_varText) <> 'DOCX') then
                                Error(Text008);
                    end;
                Type::"Legal Pri - Actas Qualf":
                    begin
                        if (UpperCase(_varText) <> 'DOC') then
                            if (UpperCase(_varText) <> 'DOCX') then
                                Error(Text008);
                    end;
                Type::"Legal LS - Dossier":
                    begin
                        if (UpperCase(_varText) <> 'DOC') then
                            if (UpperCase(_varText) <> 'DOCX') then
                                Error(Text008);
                    end;
                Type::"Legal LS - Historic":
                    begin
                        if (UpperCase(_varText) <> 'DOC') then
                            if (UpperCase(_varText) <> 'DOCX') then
                                Error(Text008);
                    end;
                Type::"Legal Pri - Dossier":
                    begin
                        if (UpperCase(_varText) <> 'DOC') then
                            if (UpperCase(_varText) <> 'DOCX') then
                                Error(Text008);
                    end;
                Type::"Legal UPP - Actas Qualf":
                    begin
                        if (UpperCase(_varText) <> 'DOC') then
                            if (UpperCase(_varText) <> 'DOCX') then
                                Error(Text008);
                    end;
                Type::"Legal Pri - Individual Report":
                    begin
                        if (UpperCase(_varText) <> 'DOC') then
                            if (UpperCase(_varText) <> 'DOCX') then
                                Error(Text008);
                    end;
                Type::"Legal Pri - Historic":
                    begin
                        if (UpperCase(_varText) <> 'DOC') then
                            if (UpperCase(_varText) <> 'DOCX') then
                                Error(Text008);
                    end;
                Type::"Legal Pri - Transfer":
                    begin
                        if (UpperCase(_varText) <> 'DOC') then
                            if (UpperCase(_varText) <> 'DOCX') then
                                Error(Text008);
                    end;
                Type::"Legal UPP - Transfer":
                    begin
                        if (UpperCase(_varText) <> 'DOC') then
                            if (UpperCase(_varText) <> 'DOCX') then
                                Error(Text008);
                    end;
                Type::"Legal UPP - Dossier":
                    begin
                        if (UpperCase(_varText) <> 'DOC') then
                            if (UpperCase(_varText) <> 'DOCX') then
                                Error(Text008);
                    end;
                Type::"Legal UPP - Historic":
                    begin
                        if (UpperCase(_varText) <> 'DOC') then
                            if (UpperCase(_varText) <> 'DOCX') then
                                Error(Text008);
                    end;
                Type::"Relation Parents Students":
                    begin
                        if (UpperCase(_varText) <> 'DOC') then
                            if (UpperCase(_varText) <> 'DOCX') then
                                Error(Text008);
                    end;
                Type::"Class Meeting":
                    begin
                        if (UpperCase(_varText) <> 'DOC') then
                            if (UpperCase(_varText) <> 'DOCX') then
                                Error(Text008);
                    end;
                Type::"Department Meeting":
                    begin
                        if (UpperCase(_varText) <> 'DOC') then
                            if (UpperCase(_varText) <> 'DOCX') then
                                Error(Text008);
                    end;
                Type::"Head Department Meeting":
                    begin
                        if (UpperCase(_varText) <> 'DOC') then
                            if (UpperCase(_varText) <> 'DOCX') then
                                Error(Text008);
                    end;
                Type::"Level Meeting":
                    begin
                        if (UpperCase(_varText) <> 'DOC') then
                            if (UpperCase(_varText) <> 'DOCX') then
                                Error(Text008);
                    end;
                Type::"Pre-registration":
                    begin
                        if (UpperCase(_varText) <> 'DOC') then
                            if (UpperCase(_varText) <> 'DOCX') then
                                Error(Text008);
                    end;



            end;
            // For Name of the File
            i := StrLen(Link);
            while CopyStr(Link, i, 1) <> '\' do
                i := i - 1;

            _varText2 := CopyStr(Link, i + 1, StrLen(Link) - i - (StrLen(_varText) + 2));


            //

            if StrLen(Link) > 0 then begin
                //"File Import".Import(Link);
                "File Import".CreateOutStream(OutStr);
                CopyStream(OutStr, InStr);
                "File Extension" := _varText;
                if Description = '' then
                    Description := _varText2;
                Modify;
                Message(Text006, Link);
            end;
        end;

    end;


    procedure Export()
    var
        Text011: Label 'Selecionar o Caminho do Documento';
        Text012: Label '*.*';
        Text013: Label ' ';
        _DestinoFile: Text[255];
        _DestinoFileAux: Text[255];
    begin
        CalcFields("File Import");
        if "File Import".HasValue then begin
            Clear(Link);
            //Link := CommonDialogMgt.OpenFile('Export',Description,4,'.'+"File Extension",1);
            //Link := FileMgt.OpenFileDialog('Export', Description, '.' + "File Extension");
            "File Import".CreateInStream(InStr);
            DownloadFromStream(InStr, '', '', '', Link);
            if Link = '' then
                exit;
            //"File Import".Export(Link);
        end else
            Error(Text001);
    end;


    procedure Print(pStudentNo: Code[50]; pSchoolYear: Code[50]; pTemplateCode: Code[50]; pSchoolingYear: Code[50]; pPageBreak: Boolean; pPageBreakNo: Integer; pCount: Integer; pMomentCode: Code[20]; pclass: Code[20]; pSubjectCode: Code[20]; pteacherCode: Code[20]; pTemplateType: Option " ",Word,Excel; pCurricularSubjects: Code[20]; pPersonalAspects: Code[20]; pBasicSkills: Code[20])
    var
        //repTemplateBulletin1: Report "Bulletin Lower Secondary";
        //repRegistrationSheet: Report "Registration Sheet";
        lRegistration: Record Registration;
        lAssessingStudents: Record "Assessing Students";
        lStudents: Record Students;
        lTimetableTeacher: Record "Timetable-Teacher";
        varPageBreak: Boolean;
        varCount: Integer;
        varclass: Code[20];
        VarType: Integer;
        lClass: Record Class;
        /*repTemplateBulletin3: Report "Bulletin Primary";
        repTemplateBulletin2: Report "Bulletin Pre Primary";
        repTemplateBulletin: Report "Bulletin Upper Secondary";
        repStudentClass: Report "Student Class";
        repClassEvaluation: Report "Class Evaluation Word";
        repClassList: Report "Class Evaluation Excel";*/
        lInteger: Record "Integer";
        varTeacherCode: Code[20];
        varSubjectCode: Code[20];
    /*rBiographicRecordPri: Report "Biographic Record Pri";
    rBiographicRecordLower: Report "Biographic Record Sec";
    rBiographicRecordUpper: Report "Biographic Record Upp teste";
    repLegalLSTransfer: Report "Legal LS - Transfer";
    repLegalLSActasQualif: Report "Legal LS - Actas Qualf";
    repLegalLSHistoric: Report "Legal LS - Historic";
    repLegalLSDossier: Report "Legal LS - Dossier";
    repLegalPRITransfer: Report "Legal Pri - Transfer";
    repLegalPRIIndividualReport: Report "Legal Pri - Individual Report";
    repLegalPRIActasQualif: Report "Legal Pri - Actas Qualf";
    repLegalPRIHistoric: Report "Legal Pri - Historic";
    repLegalPRIDossier: Report "Legal Pri - Dossier";
    repLegalUPPTransfer: Report "Legal UPP - Transfer";
    repLegalUPPActasQualif: Report "Legal UPP - Actas Qualf";
    repLegalUPPHistoric: Report "Legal UPP - Historic";
    repLegalUPPDossier: Report "Legal UPP - Dossier";
    repMinutes: Report Minutes;*/
    begin
        varStudentno := pStudentNo;
        varSchoolYear := pSchoolYear;
        varTemplatecode := pTemplateCode;
        varSchoolingYear := pSchoolingYear;
        varPageBreak := pPageBreak;
        varPagebreakNo := pPageBreakNo;
        varCount := pCount;
        VarMomentCode := pMomentCode;
        varclass := pclass;
        varSubjectCode := pSubjectCode;
        varTeacherCode := pteacherCode;
        /*Clear(repTemplateBulletin2);
        Clear(repTemplateBulletin3);
        Clear(repTemplateBulletin);
        Clear(repTemplateBulletin1);
        Clear(repRegistrationSheet);
        Clear(repClassEvaluation);
        Clear(repStudentClass);
        Clear(repMinutes);*/

        /*case Type of
            Type::"Bulletin Pre Primary":
                begin
                    if varPageBreak = true then begin
                        lAssessingStudents.Reset;
                        lAssessingStudents.SetRange("Student Code No.", rAssessingStudents."Student Code No.");
                        lAssessingStudents.SetRange("Schooling Year", rAssessingStudents."Schooling Year");
                        repTemplateBulletin2.SetTableView(lStudents);
                        repTemplateBulletin2.SetGlobals(varStudentno,
                                                        varSchoolYear,
                                                        varTemplatecode,
                                                        VarMomentCode,
                                                        varSchoolingYear,
                                                        varPageBreak,
                                                        varPagebreakNo,
                                                        varCount,
                                                        varclass,
                                                        Type::"Bulletin Pre Primary");
                        repTemplateBulletin2.UseRequestPage(false);
                        repTemplateBulletin2.RunModal;
                    end else begin
                        lAssessingStudents.Reset;
                        lAssessingStudents.SetRange("Student Code No.", rAssessingStudents."Student Code No.");
                        lAssessingStudents.SetRange("Schooling Year", rAssessingStudents."Schooling Year");
                        repTemplateBulletin2.SetTableView(lStudents);
                        repTemplateBulletin2.SetGlobals(varStudentno,
                                                        varSchoolYear,
                                                        varTemplatecode,
                                                        VarMomentCode,
                                                        varSchoolingYear,
                                                        varPageBreak,
                                                        varPagebreakNo,
                                                        varCount,
                                                        '',
                                                        Type::"Bulletin Pre Primary");
                        repTemplateBulletin2.UseRequestPage(false);
                        repTemplateBulletin2.RunModal;
                    end;
                end;
            Type::"Bulletin Primary":
                begin
                    if varPageBreak = true then begin
                        lAssessingStudents.Reset;
                        lAssessingStudents.SetRange("Student Code No.", rAssessingStudents."Student Code No.");
                        lAssessingStudents.SetRange("Schooling Year", rAssessingStudents."Schooling Year");
                        repTemplateBulletin3.SetTableView(lStudents);
                        repTemplateBulletin3.SetGlobals(varStudentno,
                                                        varSchoolYear,
                                                        varTemplatecode,
                                                        VarMomentCode,
                                                        varSchoolingYear,
                                                        varPageBreak,
                                                        varPagebreakNo,
                                                        varCount,
                                                        varclass,
                                                        Type::"Bulletin Primary");
                        repTemplateBulletin3.UseRequestPage(false);
                        repTemplateBulletin3.RunModal;
                    end else begin
                        lAssessingStudents.Reset;
                        lAssessingStudents.SetRange("Student Code No.", rAssessingStudents."Student Code No.");
                        lAssessingStudents.SetRange("Schooling Year", rAssessingStudents."Schooling Year");
                        repTemplateBulletin3.SetTableView(lStudents);
                        repTemplateBulletin3.SetGlobals(varStudentno,
                                                        varSchoolYear,
                                                        varTemplatecode,
                                                        VarMomentCode,
                                                        varSchoolingYear,
                                                        varPageBreak,
                                                        varPagebreakNo,
                                                        varCount,
                                                        '',
                                                        Type::"Bulletin Primary");
                        repTemplateBulletin3.UseRequestPage(false);
                        repTemplateBulletin3.RunModal;
                    end;
                end;
            Type::"Bulletin Lower Secondary":
                begin
                    if varPageBreak = true then begin
                        lAssessingStudents.Reset;
                        lAssessingStudents.SetRange("Student Code No.", varStudentno);
                        lAssessingStudents.SetRange("School Year", rRegistration."School Year");
                        repTemplateBulletin1.SetTableView(lStudents);
                        repTemplateBulletin1.SetGlobals(varStudentno,
                                                        varSchoolYear,
                                                        varTemplatecode,
                                                        VarMomentCode,
                                                        varSchoolingYear,
                                                        varPageBreak,
                                                        varPagebreakNo,
                                                        varCount,
                                                        varclass,
                                                        Type::"Bulletin Lower Secondary");
                        repTemplateBulletin1.UseRequestPage(false);
                        repTemplateBulletin1.RunModal;
                    end else begin
                        lAssessingStudents.Reset;
                        lAssessingStudents.SetRange("Student Code No.", varStudentno);
                        lAssessingStudents.SetRange("School Year", rRegistration."School Year");
                        repTemplateBulletin1.SetTableView(lStudents);
                        repTemplateBulletin1.SetGlobals(varStudentno,
                                                        varSchoolYear,
                                                        varTemplatecode,
                                                        VarMomentCode,
                                                        varSchoolingYear,
                                                        varPageBreak,
                                                        varPagebreakNo,
                                                        varCount,
                                                        '',
                                                        Type::"Bulletin Lower Secondary");
                        repTemplateBulletin1.UseRequestPage(false);
                        repTemplateBulletin1.RunModal;
                    end;
                end;
            Type::"Bulletin Upper Secondary":
                begin
                    if varPageBreak = true then begin
                        lAssessingStudents.Reset;
                        lAssessingStudents.SetRange("Student Code No.", rAssessingStudents."Student Code No.");
                        lAssessingStudents.SetRange("Schooling Year", rAssessingStudents."Schooling Year");
                        repTemplateBulletin.SetTableView(lStudents);
                        repTemplateBulletin.SetGlobals(varStudentno,
                                                       varSchoolYear,
                                                       varTemplatecode,
                                                       VarMomentCode,
                                                       varSchoolingYear,
                                                       varPageBreak,
                                                       varPagebreakNo,
                                                       varCount,
                                                       varclass,
                                                       Type::"Bulletin Upper Secondary");
                        repTemplateBulletin.UseRequestPage(false);
                        repTemplateBulletin.RunModal;
                    end else begin
                        lAssessingStudents.Reset;
                        lAssessingStudents.SetRange("Student Code No.", rAssessingStudents."Student Code No.");
                        lAssessingStudents.SetRange("Schooling Year", rAssessingStudents."Schooling Year");
                        repTemplateBulletin.SetTableView(lStudents);
                        repTemplateBulletin.SetGlobals(varStudentno,
                                                       varSchoolYear,
                                                       varTemplatecode,
                                                       VarMomentCode,
                                                       varSchoolingYear,
                                                       varPageBreak,
                                                       varPagebreakNo,
                                                       varCount,
                                                       '',
                                                       Type::"Bulletin Upper Secondary");
                        repTemplateBulletin.UseRequestPage(false);
                        repTemplateBulletin.RunModal;
                    end;
                end;
            Type::"Registration Sheet":
                begin
                    if varPageBreak = true then begin
                        lRegistration.Reset;
                        lRegistration.SetRange("Student Code No.", rRegistration."Student Code No.");
                        lRegistration.SetRange("School Year", rRegistration."School Year");
                        repRegistrationSheet.SetTableView(lRegistration);
                        repRegistrationSheet.SetGlobals(varStudentno,
                                                        varSchoolYear,
                                                        varTemplatecode,
                                                        VarMomentCode,
                                                        varSchoolingYear,
                                                        varPageBreak,
                                                        varPagebreakNo,
                                                        varCount,
                                                        varclass,
                                                        Type::"Registration Sheet");
                        repRegistrationSheet.UseRequestPage(false);
                        repRegistrationSheet.RunModal;
                    end else begin
                        lRegistration.Reset;
                        lRegistration.SetRange("Student Code No.", rRegistration."Student Code No.");
                        lRegistration.SetRange("School Year", rRegistration."School Year");
                        repRegistrationSheet.SetTableView(lRegistration);
                        repRegistrationSheet.SetGlobals(varStudentno,
                                                        varSchoolYear,
                                                        varTemplatecode,
                                                        VarMomentCode,
                                                        varSchoolingYear,
                                                        varPageBreak,
                                                        varPagebreakNo,
                                                        varCount,
                                                        '',
                                                        Type::"Registration Sheet");
                        repRegistrationSheet.UseRequestPage(false);
                        repRegistrationSheet.RunModal;
                    end;
                end;
            Type::"Student Class":
                begin
                    lRegistration.Reset;
                    lRegistration.SetRange("Student Code No.", rRegistration."Student Code No.");
                    lRegistration.SetRange("School Year", rRegistration."School Year");
                    lRegistration.SetRange("Schooling Year", rAssessingStudents."Schooling Year");
                    repStudentClass.SetTableView(lStudents);
                    repStudentClass.SetGlobals('',
                                               varSchoolYear,
                                               varTemplatecode,
                                               VarMomentCode,
                                               varSchoolingYear,
                                               false,
                                               0,
                                               0,
                                               varclass,
                                               Type::"Student Class",
                                               varSubjectCode,
                                               varTeacherCode);
                    repStudentClass.UseRequestPage(false);
                    repStudentClass.RunModal;
                end;


            Type::"Class Evaluation":
                begin
                    lRegistration.Reset;
                    lRegistration.SetRange("Student Code No.", rRegistration."Student Code No.");
                    lRegistration.SetRange("School Year", rRegistration."School Year");
                    lRegistration.SetRange("Schooling Year", rAssessingStudents."Schooling Year");
                    if pTemplateType = pTemplateType::Word then begin
                        repClassEvaluation.SetTableView(lInteger);
                        repClassEvaluation.SetGlobals('',
                                                      varSchoolYear,
                                                      varTemplatecode,
                                                      VarMomentCode,
                                                      varSchoolingYear,
                                                      false,
                                                      0,
                                                      0,
                                                      varclass,
                                                      Type::"Class Evaluation");
                        repClassEvaluation.UseRequestPage(false);
                        repClassEvaluation.RunModal;
                    end;
                    if pTemplateType = pTemplateType::Excel then begin
                        repClassList.SetTableView(lInteger);
                        repClassList.SetGlobals('',
                                                varSchoolYear,
                                                varTemplatecode,
                                                VarMomentCode,
                                                varSchoolingYear,
                                                varclass,
                                                Type::"Class Evaluation");
                        repClassList.UseRequestPage(false);
                        repClassList.RunModal;
                    end;
                end;
            Type::"Biographic Record Primary":
                begin
                    if varPageBreak = true then begin
                        lAssessingStudents.Reset;
                        lAssessingStudents.SetRange("Student Code No.", rAssessingStudents."Student Code No.");
                        lAssessingStudents.SetRange("Schooling Year", rAssessingStudents."Schooling Year");
                        rBiographicRecordPri.SetTableView(lStudents);
                        rBiographicRecordPri.SetGlobals(varStudentno,
                                                        varSchoolYear,
                                                        varTemplatecode,
                                                        VarMomentCode,
                                                        varSchoolingYear,
                                                        varPageBreak,
                                                        varPagebreakNo,
                                                        varCount,
                                                        varclass,
                                                        Type::"Biographic Record Primary");
                        rBiographicRecordPri.UseRequestPage(false);
                        rBiographicRecordPri.RunModal;
                    end else begin
                        lAssessingStudents.Reset;
                        lAssessingStudents.SetRange("Student Code No.", rAssessingStudents."Student Code No.");
                        lAssessingStudents.SetRange("Schooling Year", rAssessingStudents."Schooling Year");
                        rBiographicRecordPri.SetTableView(lStudents);
                        rBiographicRecordPri.SetGlobals(varStudentno,
                                                        varSchoolYear,
                                                        varTemplatecode,
                                                        VarMomentCode,
                                                        varSchoolingYear,
                                                        varPageBreak,
                                                        varPagebreakNo,
                                                        varCount,
                                                        '',
                                                        Type::"Biographic Record Primary");
                        rBiographicRecordPri.UseRequestPage(false);
                        rBiographicRecordPri.RunModal;
                    end;
                end;
            Type::"Biographic Record Lower Secondary":
                begin
                    if varPageBreak = true then begin
                        lAssessingStudents.Reset;
                        lAssessingStudents.SetRange("Student Code No.", rAssessingStudents."Student Code No.");
                        lAssessingStudents.SetRange("Schooling Year", rAssessingStudents."Schooling Year");
                        rBiographicRecordLower.SetTableView(lStudents);
                        rBiographicRecordLower.SetGlobals(varStudentno,
                                                         varSchoolYear,
                                                         varTemplatecode,
                                                         VarMomentCode,
                                                         varSchoolingYear,
                                                         varPageBreak,
                                                         varPagebreakNo,
                                                         varCount,
                                                         varclass,
                                                         Type::"Biographic Record Lower Secondary");
                        rBiographicRecordLower.UseRequestPage(false);
                        rBiographicRecordLower.RunModal;
                    end else begin
                        lAssessingStudents.Reset;
                        lAssessingStudents.SetRange("Student Code No.", rAssessingStudents."Student Code No.");
                        lAssessingStudents.SetRange("Schooling Year", rAssessingStudents."Schooling Year");
                        rBiographicRecordLower.SetTableView(lStudents);
                        rBiographicRecordLower.SetGlobals(varStudentno,
                                                          varSchoolYear,
                                                          varTemplatecode,
                                                          VarMomentCode,
                                                          varSchoolingYear,
                                                          varPageBreak,
                                                          varPagebreakNo,
                                                          varCount,
                                                          '',
                                                          Type::"Biographic Record Lower Secondary");
                        rBiographicRecordLower.UseRequestPage(false);
                        rBiographicRecordLower.RunModal;
                    end;
                end;
            Type::"Biographic Record Upper Secondary":
                begin
                    if varPageBreak = true then begin
                        lAssessingStudents.Reset;
                        lAssessingStudents.SetRange("Student Code No.", rAssessingStudents."Student Code No.");
                        lAssessingStudents.SetRange("Schooling Year", rAssessingStudents."Schooling Year");
                        rBiographicRecordUpper.SetTableView(lStudents);
                        rBiographicRecordUpper.SetGlobals(varStudentno,
                                                          varSchoolYear,
                                                          varTemplatecode,
                                                          VarMomentCode,
                                                          varSchoolingYear,
                                                          varPageBreak,
                                                          varPagebreakNo,
                                                          varCount,
                                                          varclass,
                                                          Type::"Biographic Record Upper Secondary");
                        rBiographicRecordUpper.UseRequestPage(false);
                        rBiographicRecordUpper.RunModal;
                    end else begin
                        lAssessingStudents.Reset;
                        lAssessingStudents.SetRange("Student Code No.", rAssessingStudents."Student Code No.");
                        lAssessingStudents.SetRange("Schooling Year", rAssessingStudents."Schooling Year");
                        rBiographicRecordUpper.SetTableView(lStudents);
                        rBiographicRecordUpper.SetGlobals(varStudentno,
                                                          varSchoolYear,
                                                          varTemplatecode,
                                                          VarMomentCode,
                                                          varSchoolingYear,
                                                          varPageBreak,
                                                          varPagebreakNo,
                                                          varCount,
                                                          '',
                                                          Type::"Biographic Record Upper Secondary");
                        rBiographicRecordUpper.UseRequestPage(false);
                        rBiographicRecordUpper.RunModal;
                    end;
                end;
            Type::"Legal LS - Transfer":
                begin
                    if varPageBreak = true then begin
                        lAssessingStudents.Reset;
                        lAssessingStudents.SetRange("Student Code No.", varStudentno);
                        lAssessingStudents.SetRange("School Year", rRegistration."School Year");
                        repLegalLSTransfer.SetTableView(lStudents);
                        repLegalLSTransfer.SetGlobals(varStudentno,
                                                      varSchoolYear,
                                                      varTemplatecode,
                                                      VarMomentCode,
                                                      varSchoolingYear,
                                                      varPageBreak,
                                                      varPagebreakNo,
                                                      varCount,
                                                      varclass,
                                                      Type::"Legal LS - Transfer",
                                                      pBasicSkills,
                                                      pCurricularSubjects,
                                                      lAssessingStudents."Study Plan Code");
                        repLegalLSTransfer.UseRequestPage(false);
                        repLegalLSTransfer.RunModal;
                    end else begin
                        lAssessingStudents.Reset;
                        lAssessingStudents.SetRange("Student Code No.", varStudentno);
                        lAssessingStudents.SetRange("School Year", rRegistration."School Year");
                        repLegalLSTransfer.SetTableView(lStudents);
                        repLegalLSTransfer.SetGlobals(varStudentno,
                                                      varSchoolYear,
                                                      varTemplatecode,
                                                      VarMomentCode,
                                                      varSchoolingYear,
                                                      varPageBreak,
                                                      varPagebreakNo,
                                                      varCount,
                                                      '',
                                                      Type::"Legal LS - Transfer",
                                                      pBasicSkills,
                                                      pCurricularSubjects,
                                                      lAssessingStudents."Study Plan Code");
                        repLegalLSTransfer.UseRequestPage(false);
                        repLegalLSTransfer.RunModal;
                    end;
                end;
            Type::"Legal LS - Qualificacions":
                begin
                    if varPageBreak = true then begin
                        lAssessingStudents.Reset;
                        lAssessingStudents.SetRange("Student Code No.", varStudentno);
                        lAssessingStudents.SetRange("School Year", rRegistration."School Year");
                        repLegalLSActasQualif.SetTableView(lStudents);
                        repLegalLSActasQualif.SetGlobals(varStudentno,
                                                         varSchoolYear,
                                                         varTemplatecode,
                                                         VarMomentCode,
                                                         varSchoolingYear,
                                                         varPageBreak,
                                                         varPagebreakNo,
                                                         varCount,
                                                         varclass,
                                                         Type::"Legal LS - Qualificacions",
                                                         pPersonalAspects,
                                                         pCurricularSubjects);
                        repLegalLSActasQualif.UseRequestPage(true);
                        repLegalLSActasQualif.RunModal;
                    end else begin
                        lAssessingStudents.Reset;
                        lAssessingStudents.SetRange("Student Code No.", varStudentno);
                        lAssessingStudents.SetRange("School Year", rRegistration."School Year");
                        repLegalLSActasQualif.SetTableView(lStudents);
                        repLegalLSActasQualif.SetGlobals(varStudentno,
                                                         varSchoolYear,
                                                         varTemplatecode,
                                                         VarMomentCode,
                                                         varSchoolingYear,
                                                         varPageBreak,
                                                         varPagebreakNo,
                                                         varCount,
                                                         '',
                                                         Type::"Legal LS - Qualificacions",
                                                         pPersonalAspects,
                                                         pCurricularSubjects);
                        repLegalLSActasQualif.UseRequestPage(true);
                        repLegalLSActasQualif.RunModal;
                    end;
                end;
            Type::"Legal LS - Historic":
                begin
                    if varPageBreak = true then begin
                        lAssessingStudents.Reset;
                        lAssessingStudents.SetRange("Student Code No.", varStudentno);
                        lAssessingStudents.SetRange("School Year", rRegistration."School Year");
                        repLegalLSHistoric.SetTableView(lStudents);
                        repLegalLSHistoric.SetGlobals(varStudentno,
                                                      varSchoolYear,
                                                      varTemplatecode,
                                                      VarMomentCode,
                                                      varSchoolingYear,
                                                      varPageBreak,
                                                      varPagebreakNo,
                                                      varCount,
                                                      varclass,
                                                      Type::"Legal LS - Historic",
                                                      pCurricularSubjects,
                                                      pPersonalAspects);
                        repLegalLSHistoric.UseRequestPage(false);
                        repLegalLSHistoric.RunModal;
                    end else begin
                        lAssessingStudents.Reset;
                        lAssessingStudents.SetRange("Student Code No.", varStudentno);
                        lAssessingStudents.SetRange("School Year", rRegistration."School Year");
                        repLegalLSHistoric.SetTableView(lStudents);
                        repLegalLSHistoric.SetGlobals(varStudentno,
                                                      varSchoolYear,
                                                      varTemplatecode,
                                                      VarMomentCode,
                                                      varSchoolingYear,
                                                      varPageBreak,
                                                      varPagebreakNo,
                                                      varCount,
                                                      '',
                                                      Type::"Legal LS - Historic",
                                                      pCurricularSubjects,
                                                      pPersonalAspects);
                        repLegalLSHistoric.UseRequestPage(false);
                        repLegalLSHistoric.RunModal;
                    end;
                end;
            Type::"Legal LS - Dossier":
                begin
                    if varPageBreak = true then begin
                        lAssessingStudents.Reset;
                        lAssessingStudents.SetRange("Student Code No.", varStudentno);
                        lAssessingStudents.SetRange("School Year", rRegistration."School Year");
                        repLegalLSDossier.SetTableView(lStudents);
                        repLegalLSDossier.SetGlobals(varStudentno,
                                                     varSchoolYear,
                                                     varTemplatecode,
                                                     VarMomentCode,
                                                     varSchoolingYear,
                                                     varPageBreak,
                                                     varPagebreakNo,
                                                     varCount,
                                                     varclass,
                                                     Type::"Legal LS - Dossier");
                        repLegalLSDossier.UseRequestPage(false);
                        repLegalLSDossier.RunModal;
                    end else begin
                        lAssessingStudents.Reset;
                        lAssessingStudents.SetRange("Student Code No.", varStudentno);
                        lAssessingStudents.SetRange("School Year", rRegistration."School Year");
                        repLegalLSDossier.SetTableView(lStudents);
                        repLegalLSDossier.SetGlobals(varStudentno,
                                                     varSchoolYear,
                                                     varTemplatecode,
                                                     VarMomentCode,
                                                     varSchoolingYear,
                                                     varPageBreak,
                                                     varPagebreakNo,
                                                     varCount,
                                                     '',
                                                     Type::"Legal LS - Dossier");
                        repLegalLSDossier.UseRequestPage(false);
                        repLegalLSDossier.RunModal;
                    end;
                end;
            Type::"Legal Pri - Transfer":
                begin
                    if varPageBreak = true then begin
                        lAssessingStudents.Reset;
                        lAssessingStudents.SetRange("Student Code No.", varStudentno);
                        lAssessingStudents.SetRange("School Year", rRegistration."School Year");
                        repLegalPRITransfer.SetTableView(lStudents);
                        repLegalPRITransfer.SetGlobals(varStudentno,
                                                       varSchoolYear,
                                                       varTemplatecode,
                                                       VarMomentCode,
                                                       varSchoolingYear,
                                                       varPageBreak,
                                                       varPagebreakNo,
                                                       varCount,
                                                       varclass,
                                                       Type::"Legal Pri - Transfer",
                                                       pCurricularSubjects,
                                                       pPersonalAspects,
                                                       pBasicSkills);
                        repLegalPRITransfer.UseRequestPage(false);
                        repLegalPRITransfer.RunModal;
                    end else begin
                        lAssessingStudents.Reset;
                        lAssessingStudents.SetRange("Student Code No.", varStudentno);
                        lAssessingStudents.SetRange("School Year", rRegistration."School Year");
                        repLegalPRITransfer.SetTableView(lStudents);
                        repLegalPRITransfer.SetGlobals(varStudentno,
                                                       varSchoolYear,
                                                       varTemplatecode,
                                                       VarMomentCode,
                                                       varSchoolingYear,
                                                       varPageBreak,
                                                       varPagebreakNo,
                                                       varCount,
                                                       '',
                                                       Type::"Legal Pri - Transfer",
                                                       pCurricularSubjects,
                                                       pPersonalAspects,
                                                       pBasicSkills);
                        repLegalPRITransfer.UseRequestPage(false);
                        repLegalPRITransfer.RunModal;
                    end;
                end;
            Type::"Legal Pri - Actas Qualf":
                begin
                    if varPageBreak = true then begin
                        lAssessingStudents.Reset;
                        lAssessingStudents.SetRange("Student Code No.", varStudentno);
                        lAssessingStudents.SetRange("School Year", rRegistration."School Year");
                        repLegalPRIActasQualif.SetTableView(lStudents);
                        repLegalPRIActasQualif.SetGlobals(varStudentno,
                                                          varSchoolYear,
                                                          varTemplatecode,
                                                          VarMomentCode,
                                                          varSchoolingYear,
                                                          varPageBreak,
                                                          varPagebreakNo,
                                                          varCount,
                                                          varclass,
                                                          Type::"Legal Pri - Actas Qualf",
                                                          pCurricularSubjects);
                        repLegalPRIActasQualif.UseRequestPage(false);
                        repLegalPRIActasQualif.RunModal;
                    end else begin
                        lAssessingStudents.Reset;
                        lAssessingStudents.SetRange("Student Code No.", varStudentno);
                        lAssessingStudents.SetRange("School Year", rRegistration."School Year");
                        repLegalPRIActasQualif.SetTableView(lStudents);
                        repLegalPRIActasQualif.SetGlobals(varStudentno,
                                                          varSchoolYear,
                                                          varTemplatecode,
                                                          VarMomentCode,
                                                          varSchoolingYear,
                                                          varPageBreak,
                                                          varPagebreakNo,
                                                          varCount,
                                                          '',
                                                          Type::"Legal Pri - Actas Qualf",
                                                          pCurricularSubjects);
                        repLegalPRIActasQualif.UseRequestPage(false);
                        repLegalPRIActasQualif.RunModal;
                    end;
                end;
            Type::"Legal Pri - Historic":
                begin
                    if varPageBreak = true then begin
                        lAssessingStudents.Reset;
                        lAssessingStudents.SetRange("Student Code No.", varStudentno);
                        lAssessingStudents.SetRange("School Year", rRegistration."School Year");
                        repLegalPRIHistoric.SetTableView(lStudents);
                        repLegalPRIHistoric.SetGlobals(varStudentno,
                                                       varSchoolYear,
                                                       varTemplatecode,
                                                       VarMomentCode,
                                                       varSchoolingYear,
                                                       varPageBreak,
                                                       varPagebreakNo,
                                                       varCount,
                                                       varclass,
                                                       Type::"Legal Pri - Historic",
                                                       pCurricularSubjects);
                        repLegalPRIHistoric.UseRequestPage(false);
                        repLegalPRIHistoric.RunModal;
                    end else begin
                        lAssessingStudents.Reset;
                        lAssessingStudents.SetRange("Student Code No.", varStudentno);
                        lAssessingStudents.SetRange("School Year", rRegistration."School Year");
                        repLegalPRIHistoric.SetTableView(lStudents);
                        repLegalPRIHistoric.SetGlobals(varStudentno,
                                                       varSchoolYear,
                                                       varTemplatecode,
                                                       VarMomentCode,
                                                       varSchoolingYear,
                                                       varPageBreak,
                                                       varPagebreakNo,
                                                       varCount,
                                                       '',
                                                       Type::"Legal Pri - Historic",
                                                       pCurricularSubjects);
                        repLegalPRIHistoric.UseRequestPage(false);
                        repLegalPRIHistoric.RunModal;
                    end;
                end;
            Type::"Legal Pri - Dossier":
                begin
                    if varPageBreak = true then begin
                        lAssessingStudents.Reset;
                        lAssessingStudents.SetRange("Student Code No.", varStudentno);
                        lAssessingStudents.SetRange("School Year", rRegistration."School Year");
                        repLegalPRIDossier.SetTableView(lStudents);
                        repLegalPRIDossier.SetGlobals(varStudentno,
                                                      varSchoolYear,
                                                      varTemplatecode,
                                                      VarMomentCode,
                                                      varSchoolingYear,
                                                      varPageBreak,
                                                      varPagebreakNo,
                                                      varCount,
                                                      varclass,
                                                      Type::"Legal Pri - Dossier",
                                                      pPersonalAspects,
                                                      pBasicSkills,
                                                      pPersonalAspects);
                        repLegalPRIDossier.UseRequestPage(false);
                        repLegalPRIDossier.RunModal;
                    end else begin
                        lAssessingStudents.Reset;
                        lAssessingStudents.SetRange("Student Code No.", varStudentno);
                        lAssessingStudents.SetRange("School Year", rRegistration."School Year");
                        repLegalPRIDossier.SetTableView(lStudents);
                        repLegalPRIDossier.SetGlobals(varStudentno,
                                                     varSchoolYear,
                                                     varTemplatecode,
                                                     VarMomentCode,
                                                     varSchoolingYear,
                                                     varPageBreak,
                                                     varPagebreakNo,
                                                     varCount,
                                                     '',
                                                     Type::"Legal Pri - Dossier",
                                                     pPersonalAspects,
                                                     pBasicSkills,
                                                     pPersonalAspects);
                        repLegalPRIDossier.UseRequestPage(false);
                        repLegalPRIDossier.RunModal;
                    end;
                end;
            Type::"Legal Pri - Individual Report":
                begin
                    if varPageBreak = true then begin
                        lAssessingStudents.Reset;
                        lAssessingStudents.SetRange("Student Code No.", varStudentno);
                        lAssessingStudents.SetRange("School Year", rRegistration."School Year");
                        repLegalPRIIndividualReport.SetTableView(lStudents);
                        repLegalPRIIndividualReport.SetGlobals(varStudentno,
                                                               varSchoolYear,
                                                               varTemplatecode,
                                                               VarMomentCode,
                                                               varSchoolingYear,
                                                               varPageBreak,
                                                               varPagebreakNo,
                                                               varCount,
                                                               varclass,
                                                               Type::"Legal Pri - Individual Report",
                                                               pPersonalAspects,
                                                               pBasicSkills);
                        repLegalPRIIndividualReport.UseRequestPage(false);
                        repLegalPRIIndividualReport.RunModal;
                    end else begin
                        lAssessingStudents.Reset;
                        lAssessingStudents.SetRange("Student Code No.", varStudentno);
                        lAssessingStudents.SetRange("School Year", rRegistration."School Year");
                        repLegalPRIIndividualReport.SetTableView(lStudents);
                        repLegalPRIIndividualReport.SetGlobals(varStudentno,
                                                               varSchoolYear,
                                                               varTemplatecode,
                                                               VarMomentCode,
                                                               varSchoolingYear,
                                                               varPageBreak,
                                                               varPagebreakNo,
                                                               varCount,
                                                               '',
                                                               Type::"Legal Pri - Individual Report",
                                                               pPersonalAspects,
                                                               pBasicSkills);
                        repLegalPRIIndividualReport.UseRequestPage(false);
                        repLegalPRIIndividualReport.RunModal;
                    end;
                end;
            Type::"Legal UPP - Transfer":
                begin
                    if varPageBreak = true then begin
                        lAssessingStudents.Reset;
                        lAssessingStudents.SetRange("Student Code No.", varStudentno);
                        lAssessingStudents.SetRange("School Year", rRegistration."School Year");
                        repLegalUPPTransfer.SetTableView(lStudents);
                        repLegalUPPTransfer.SetGlobals(varStudentno,
                                                       varSchoolYear,
                                                       varTemplatecode,
                                                       VarMomentCode,
                                                       varSchoolingYear,
                                                       varPageBreak,
                                                       varPagebreakNo,
                                                       varCount,
                                                       varclass,
                                                       Type::"Legal UPP - Transfer");
                        repLegalUPPTransfer.UseRequestPage(false);
                        repLegalUPPTransfer.RunModal;
                    end else begin
                        lAssessingStudents.Reset;
                        lAssessingStudents.SetRange("Student Code No.", varStudentno);
                        lAssessingStudents.SetRange("School Year", rRegistration."School Year");
                        repLegalUPPTransfer.SetTableView(lStudents);
                        repLegalUPPTransfer.SetGlobals(varStudentno,
                                                       varSchoolYear,
                                                       varTemplatecode,
                                                       VarMomentCode,
                                                       varSchoolingYear,
                                                       varPageBreak,
                                                       varPagebreakNo,
                                                       varCount,
                                                       '',
                                                       Type::"Legal UPP - Transfer");
                        repLegalUPPTransfer.UseRequestPage(false);
                        repLegalUPPTransfer.RunModal;
                    end;
                end;
            Type::"Legal UPP - Actas Qualf":
                begin
                    if varPageBreak = true then begin
                        lAssessingStudents.Reset;
                        lAssessingStudents.SetRange("Student Code No.", varStudentno);
                        lAssessingStudents.SetRange("School Year", rRegistration."School Year");
                        repLegalUPPActasQualif.SetTableView(lStudents);
                        repLegalUPPActasQualif.SetGlobals(varStudentno,
                                                         varSchoolYear,
                                                         varTemplatecode,
                                                         VarMomentCode,
                                                         varSchoolingYear,
                                                         varPageBreak,
                                                         varPagebreakNo,
                                                         varCount,
                                                         varclass,
                                                         Type::"Legal UPP - Actas Qualf",
                                                         pPersonalAspects,
                                                         pCurricularSubjects);
                        repLegalUPPActasQualif.UseRequestPage(false);
                        repLegalUPPActasQualif.RunModal;
                    end else begin
                        lAssessingStudents.Reset;
                        lAssessingStudents.SetRange("Student Code No.", varStudentno);
                        lAssessingStudents.SetRange("School Year", rRegistration."School Year");
                        repLegalUPPActasQualif.SetTableView(lStudents);
                        repLegalUPPActasQualif.SetGlobals(varStudentno,
                                                          varSchoolYear,
                                                          varTemplatecode,
                                                          VarMomentCode,
                                                          varSchoolingYear,
                                                          varPageBreak,
                                                          varPagebreakNo,
                                                          varCount,
                                                          '',
                                                          Type::"Legal UPP - Actas Qualf",
                                                          pPersonalAspects,
                                                          pCurricularSubjects);
                        repLegalUPPActasQualif.UseRequestPage(false);
                        repLegalUPPActasQualif.RunModal;
                    end;
                end;
            Type::"Legal UPP - Historic":
                begin
                    if varPageBreak = true then begin
                        lAssessingStudents.Reset;
                        lAssessingStudents.SetRange("Student Code No.", varStudentno);
                        lAssessingStudents.SetRange("School Year", rRegistration."School Year");
                        repLegalUPPHistoric.SetTableView(lStudents);
                        repLegalUPPHistoric.SetGlobals(varStudentno,
                                                       varSchoolYear,
                                                       varTemplatecode,
                                                       VarMomentCode,
                                                       varSchoolingYear,
                                                       varPageBreak,
                                                       varPagebreakNo,
                                                       varCount,
                                                       varclass,
                                                       Type::"Legal UPP - Historic");
                        repLegalUPPHistoric.UseRequestPage(false);
                        repLegalUPPHistoric.RunModal;
                    end else begin
                        lAssessingStudents.Reset;
                        lAssessingStudents.SetRange("Student Code No.", varStudentno);
                        lAssessingStudents.SetRange("School Year", rRegistration."School Year");
                        repLegalUPPHistoric.SetTableView(lStudents);
                        repLegalUPPHistoric.SetGlobals(varStudentno,
                                                       varSchoolYear,
                                                       varTemplatecode,
                                                       VarMomentCode,
                                                       varSchoolingYear,
                                                       varPageBreak,
                                                       varPagebreakNo,
                                                       varCount,
                                                       '',
                                                       Type::"Legal UPP - Historic");
                        repLegalUPPHistoric.UseRequestPage(false);
                        repLegalUPPHistoric.RunModal;
                    end;
                end;
            Type::"Legal UPP - Dossier":
                begin
                    if varPageBreak = true then begin
                        lAssessingStudents.Reset;
                        lAssessingStudents.SetRange("Student Code No.", varStudentno);
                        lAssessingStudents.SetRange("School Year", rRegistration."School Year");
                        repLegalUPPDossier.SetTableView(lStudents);
                        repLegalUPPDossier.SetGlobals(varStudentno,
                                                      varSchoolYear,
                                                      varTemplatecode,
                                                      VarMomentCode,
                                                      varSchoolingYear,
                                                      varPageBreak,
                                                      varPagebreakNo,
                                                      varCount,
                                                      varclass,
                                                      Type::"Legal UPP - Dossier");
                        repLegalUPPDossier.UseRequestPage(false);
                        repLegalUPPDossier.RunModal;
                    end else begin
                        lAssessingStudents.Reset;
                        lAssessingStudents.SetRange("Student Code No.", varStudentno);
                        lAssessingStudents.SetRange("School Year", rRegistration."School Year");
                        repLegalUPPDossier.SetTableView(lStudents);
                        repLegalUPPDossier.SetGlobals(varStudentno,
                                                      varSchoolYear,
                                                      varTemplatecode,
                                                      VarMomentCode,
                                                      varSchoolingYear,
                                                      varPageBreak,
                                                      varPagebreakNo,
                                                      varCount,
                                                      '',
                                                      Type::"Legal UPP - Dossier");
                        repLegalUPPDossier.UseRequestPage(false);
                        repLegalUPPDossier.RunModal;
                    end;
                end;
        end;*/
    end;


    procedure SetRegistration(var pRegistration: Record Registration)
    begin
        if varStudentno <> '' then begin
            varStudentno := pRegistration."Student Code No.";
            varSchoolYear := pRegistration."School Year";
        end;
    end;


    procedure SetAssessingStudents(pAssessingStudents: Record "Assessing Students")
    begin
        rAssessingStudents := pAssessingStudents;
    end;


    procedure SetStudents(pStudentNo: Code[50]; pClass: Code[50]; pSchoolYear: Code[50]; pTemplateCode: Code[50])
    begin
        varStudentno := pStudentNo;
        varSchoolYear := pSchoolYear;
        varTemplatecode := pTemplateCode;
    end;


    procedure GetMoment(pSchoolingYear: Code[20]; pSchoolYear: Code[20]; pResponsibilityCenter: Code[20]): Code[20]
    var
        l_rMoments: Record "Moments Assessment";
        tAssessment: Text[1024];
        int: Integer;
    begin
        Clear(int);
        l_rMoments.Reset;
        l_rMoments.SetCurrentKey("Schooling Year", "Sorting ID");
        l_rMoments.SetRange("School Year", pSchoolYear);
        l_rMoments.SetRange("Schooling Year", pSchoolingYear);
        l_rMoments.SetRange("Responsibility Center", pResponsibilityCenter);
        if l_rMoments.Find('-') then
            repeat
                int += 1;
                if int = 1 then begin
                    tAssessment := tAssessment + Text003 + ',';
                    tAssessment := tAssessment + l_rMoments."Moment Code" + ',';
                end else
                    tAssessment := tAssessment + l_rMoments."Moment Code" + ','
            until l_rMoments.Next = 0;
        Clear(int);
        if tAssessment <> '' then begin
            int := StrMenu(tAssessment);
            l_rMoments.Reset;
            l_rMoments.SetCurrentKey("Schooling Year", "Sorting ID");
            l_rMoments.SetRange("School Year", pSchoolYear);
            l_rMoments.SetRange("Schooling Year", pSchoolingYear);
            l_rMoments.SetRange("Responsibility Center", pResponsibilityCenter);
            if l_rMoments.Find('-') and (int <> 0) then
                l_rMoments.Next := int - 2
            else
                exit(Format(int));
            if int = 1 then
                exit('');
        end;
        if int <> 0 then
            exit(l_rMoments."Moment Code");
    end;


    procedure FileExtension(FileName: Text[260]) Extension: Text[260]
    var
        I: Integer;
    begin
        I := StrLen(FileName);
        while CopyStr(FileName, I, 1) <> '.' do
            I := I - 1;
        Extension := CopyStr(FileName, I + 1, StrLen(FileName) - I);
    end;


    procedure PrintMeeting(pTimetableTeacher: Record "Timetable-Teacher")
    var
        lTimetableTeacher: Record "Timetable-Teacher";
    //repMinutes: Report Minutes;
    begin

        lTimetableTeacher.Reset;
        lTimetableTeacher.SetRange(lTimetableTeacher."Timetable Code", pTimetableTeacher."Timetable Code");
        lTimetableTeacher.SetRange(lTimetableTeacher."Timetable Line No.", pTimetableTeacher."Timetable Line No.");
        lTimetableTeacher.SetRange(lTimetableTeacher."Filter Period", pTimetableTeacher."Filter Period");
        lTimetableTeacher.SetRange(lTimetableTeacher."Teacher No.", pTimetableTeacher."Teacher No.");
        lTimetableTeacher.SetRange(lTimetableTeacher.Class, pTimetableTeacher.Class);
        lTimetableTeacher.SetRange(lTimetableTeacher.Subject, pTimetableTeacher.Subject);
        /*repMinutes.SetTableView(lTimetableTeacher);
        repMinutes.SetGlobals(Type, Code);
        repMinutes.UseRequestPage(false);
        repMinutes.RunModal;*/
    end;


    procedure PrintCandidate(pCandidate: Record Candidate)
    var
        lCandidate: Record Candidate;
    //repPreRegistration: Report "Pre-registration Report";
    begin

        lCandidate.Reset;
        lCandidate.SetRange(lCandidate."No.", pCandidate."No.");
        /*repPreRegistration.SetTableView(lCandidate);
        repPreRegistration.SetGlobals(Type, Code);
        repPreRegistration.RunModal;*/
    end;
}

