codeunit 52769 "Calc. Evaluation"
{
    Permissions = TableData Remarks = rimd,
                  TableData "Assessing Students" = rimd,
                  TableData Absence = rimd,
                  TableData "WEB Absence" = rimd,
                  TableData GeneralTable = rimd,
                  TableData GeneralTableAspects = rimd,
                  TableData MasterTableWEB = rimd,
                  TableData "Assessing Students Final" = rimd,
                  TableData "WEB Remarks" = rimd;

    trigger OnRun()
    begin
        /*CalcWEBSubjectClass;
        WEBtoNAVFinalAssessment;
        WEBtoNAVAspects;
        WEBtoNAVIncidences;             //Incidence
        WEBtoNAVIncidencesDaily;        //IncidenceDaily
        WEBtoNAVClassObservation;
        WEBtoNAVSubjObservation;
        WEBtoNAVIncidenceObservation1;  //IncidenceDailyStudent_ObsTick
        WEBtoNAVIncidenceObservation2;  //IncidenceDailyStudent_ObsText
        WEBtoNAVIncidenceObservation3;  //IncidenceStudentsObsTick
        WEBtoNAVIncidenceObservation4;  //IncidenceStudentsObsText*/
    end;

    /*var
        cInsertWEBMasterTable: Codeunit InsertWEB_MasterTable;
    
        //[Scope('OnPrem')]
        procedure CalcWEBSubjectClass()
        var
            Text0001: Label '''%1''';
            Text0002: Label 'SELECT * from dbo.[view_temp_Students_SubSubjects]';
            Text0003: Label ' Where Company = ''%1''';
            autConnection: Automation;
            autRecSet: Automation;
            rGeneralTable: Record GeneralTable;
            rGeneralTable2: Record GeneralTable;
            rGeneralTable3: Record GeneralTable;
            rCompanyInfo: Record "Company Information";
            AssessementConfiguration: Record "Assessment Configuration";
            rClass: Record Class;
            cInsertWEBGenTable: Codeunit InsertWEBGenTable;
            txtSQL: Text[1024];
            optUpdateType: Option " ",Insert,Update,Delete;
            intCount: Integer;
            intActiveMoment: Integer;
            txtSQLBegin: Text[1024];
            txtSQLEnd: Text[1024];
            txtSeparador: Text[30];
            txtVALUES: array[30] of Text[1024];
            Text0004: Label 'There is nothing to import.';
            i: Integer;
            k: Integer;
            SubjectCals: Decimal;
            SUMPounder: Decimal;
            SubSubjectValue: Variant;
            SubSubjectValueDEC: Decimal;
            EntryNoPortal: Integer;
            GradeTXT: Variant;
            GradeDec: Decimal;
            GradeTXT1: Text[30];
            GradeTXT2: Text[30];
            GradeDec1: Decimal;
            GradeDec2: Decimal;
            Text0005: Label 'UPDATE dbo.[nav_Students_SubSubjects] SET ';
            Text0006: Label ' Where EntryNo = ''%1'' and Company = ''%2''';
            Text0011: Label 'EXEC sp_temp_Student_SubjectGrade_2';
            varGradeRecTXT: Text[30];
            varGradeRec: Decimal;
        begin
            rCompanyInfo.Get;
            case rCompanyInfo."Connection Type" of
                rCompanyInfo."Connection Type"::" ":
                    exit;
                rCompanyInfo."Connection Type"::"1 Connection":
                    i := 1;
                rCompanyInfo."Connection Type"::"2 Connection":
                    i := 2;
            end;

            for k := 1 to i do begin

                // Feita a Ligação ao SQL através da funcão CREATEDBConnection
                Clear(autConnection);
                cInsertWEBMasterTable.CreateDBConnection(autConnection, k);

                // Espaço para inserir qualquer tipo de filtragem

                // Criado o apontador para a tabela de sql. Este apontador irá nos ajudar a percorrer as linhas da tabela.
                Clear(autRecSet);
                Create(autRecSet, false, true);

                // Declaração da statement que nos porporcionará posicionar-mos na linha que pretendemos obter informação.
                txtSQL := Text0002 + Text0003;
                txtSQL := StrSubstNo(txtSQL, CompanyName);

                // Neste momento apontamos o apontador para a tabela, enviando a statement criada em cima.
                autRecSet.Open(txtSQL, autConnection, 1, 1);

                // Verificação de que se o apontador chegou ao fim da tabela SQL, terminando o dataitem do report
                if autRecSet.EOF then begin
                    exit;
                end;

                intCount := 1;
                repeat
                    if intCount = 1 then
                        autRecSet.MoveFirst;
                    SubjectCals := 0;
                    SUMPounder := 0;

                    EntryNoPortal := autRecSet.Fields.Item('EntryNo').Value;
                    rGeneralTable.LockTable(true);
                    rGeneralTable.Reset;
                    rGeneralTable.SetRange("Entry No.", EntryNoPortal);
                    if rGeneralTable.Find('-') then begin
                        //Vai calcular a nota da disciplina.
                        if rGeneralTable."Is SubSubject" and
                        (rGeneralTable."Interface Type WEB" = rGeneralTable."Interface Type WEB"::General) then begin
                            rGeneralTable2.Reset;
                            rGeneralTable2.SetCurrentKey("School Year", Student, Class, Subject, "Sub Subject", "Is SubSubject");
                            rGeneralTable2.SetRange("School Year", rGeneralTable."School Year");
                            rGeneralTable2.SetRange(Student, rGeneralTable.Student);
                            rGeneralTable2.SetRange(Class, rGeneralTable.Class);
                            rGeneralTable2.SetRange(Subject, rGeneralTable.Subject);
                            rGeneralTable2.SetRange("Sub Subject", rGeneralTable.Subject);
                            rGeneralTable2.SetRange(Moment, rGeneralTable.Moment);
                            rGeneralTable2.SetRange("Is SubSubject", false);
                            if rGeneralTable2.Find('-') then begin
                                //Achou a linha da disciplina.
                                //Agora tem de valiadar se tem subdisciplinas com classificações para Calcular a nota da disciplina.
                                rGeneralTable3.Reset;
                                rGeneralTable3.SetCurrentKey("School Year", Student, Class, Subject, "Sub Subject", "Is SubSubject");
                                rGeneralTable3.SetRange("School Year", rGeneralTable."School Year");
                                rGeneralTable3.SetRange(Student, rGeneralTable.Student);
                                rGeneralTable3.SetRange(Class, rGeneralTable.Class);
                                rGeneralTable3.SetRange(Subject, rGeneralTable.Subject);
                                rGeneralTable3.SetRange(Moment, rGeneralTable.Moment);
                                rGeneralTable3.SetRange("Is SubSubject", true);
                                if rGeneralTable3.Find('-') then begin
                                    repeat
                                        GradeDec1 := 0;
                                        if rGeneralTable."Entry No." = rGeneralTable3."Entry No." then begin
                                            GradeTXT1 := autRecSet.Fields.Item('GradeManual').Value;
                                            if Evaluate(GradeDec1, GradeTXT1) then begin
                                                SubjectCals += (GradeDec1 * rGeneralTable."Sub Subject Ponder");
                                                SUMPounder += rGeneralTable."Sub Subject Ponder";
                                            end;
                                        end else begin
                                            GradeTXT1 := rGeneralTable3.GradeManual;
                                            if Evaluate(GradeDec1, GradeTXT1) then begin
                                                SubjectCals += (GradeDec1 * rGeneralTable3."Sub Subject Ponder");
                                                SUMPounder += rGeneralTable3."Sub Subject Ponder";
                                            end;
                                        end;
                                    until rGeneralTable3.Next = 0;
                                end;
                            end;
                            //Vai atribuir a classificação á disciplina
                            if SubjectCals <> 0 then begin

                                SubSubjectValueDEC := 0;
                                SubSubjectValue := autRecSet.Fields.Item('GradeManual').Value;
                                if SubSubjectValue.IsText then
                                    if Evaluate(SubSubjectValueDEC, SubSubjectValue) then;

                                rClass.Reset;
                                rClass.SetRange(Class, rGeneralTable2.Class);
                                rClass.SetRange("School Year", rGeneralTable2."School Year");
                                if rClass.Find('-') then begin
                                    AssessementConfiguration.Reset;
                                    AssessementConfiguration.SetRange("School Year", rGeneralTable2."School Year");
                                    AssessementConfiguration.SetRange(Type, rClass.Type);
                                    AssessementConfiguration.SetRange("Study Plan Code", rClass."Study Plan Code");
                                    if AssessementConfiguration.Find('-') then begin
                                        if rGeneralTable2."Update Type" <> rGeneralTable2."Update Type"::Insert then
                                            rGeneralTable2."Update Type" := rGeneralTable2."Update Type"::Update;

                                        if rGeneralTable2."Update Type 2" <> rGeneralTable2."Update Type 2"::Insert then
                                            rGeneralTable2."Update Type 2" := rGeneralTable2."Update Type 2"::Update;

                                        rGeneralTable2.GradeAuto := Format(Round((SubjectCals +
                                                                               (SubSubjectValueDEC * rGeneralTable."Sub Subject Ponder"))
                                                                               / SUMPounder, AssessementConfiguration."PA Subject Round Method"));
                                        rGeneralTable2.GradeManual := rGeneralTable2.GradeAuto;

                                    end;
                                end
                                else begin
                                    if rGeneralTable2."Update Type" <> rGeneralTable2."Update Type"::Insert then
                                        rGeneralTable2."Update Type" := rGeneralTable2."Update Type"::Update;

                                    if rGeneralTable2."Update Type 2" <> rGeneralTable2."Update Type 2"::Insert then
                                        rGeneralTable2."Update Type 2" := rGeneralTable2."Update Type 2"::Update;

                                    rGeneralTable2.GradeAuto := Format(Round((SubjectCals +
                                                                           (SubSubjectValueDEC * rGeneralTable."Sub Subject Ponder"))
                                                                           / SUMPounder, 0.01));
                                    rGeneralTable2.GradeManual := rGeneralTable2.GradeAuto;
                                end;

                                varGradeRecTXT := autRecSet.Fields.Item('GradeRec').Value;
                                Evaluate(varGradeRec, varGradeRecTXT);
                                rGeneralTable."Recuperation Grade" := varGradeRec;
                                rGeneralTable2."Has Individual Plan" := autRecSet.Fields.Item('IsIndividualPlan').Value;
                                rGeneralTable2."Scholarship Reinforcement" := autRecSet.Fields.Item('IsReinforcement').Value;
                                rGeneralTable2."Scholarship Support" := autRecSet.Fields.Item('IsSupport').Value;
                                rGeneralTable2.Modify;

                            end;
                        end;

                        GradeTXT := autRecSet.Fields.Item('GradeAuto').Value;
                        if GradeTXT.IsText then
                            rGeneralTable.GradeAuto := GradeTXT;
                        GradeTXT := autRecSet.Fields.Item('GradeManual').Value;
                        if GradeTXT.IsText then
                            rGeneralTable.GradeManual := GradeTXT;

                        if rGeneralTable."Update Type" <> rGeneralTable."Update Type"::Insert then
                            rGeneralTable."Update Type" := rGeneralTable."Update Type"::Update;

                        if rGeneralTable."Update Type 2" <> rGeneralTable."Update Type 2"::Insert then
                            rGeneralTable."Update Type 2" := rGeneralTable."Update Type 2"::Update;

                        varGradeRecTXT := autRecSet.Fields.Item('GradeRec').Value;
                        Evaluate(varGradeRec, varGradeRecTXT);
                        rGeneralTable."Recuperation Grade" := varGradeRec;

                        rGeneralTable."Has Individual Plan" := autRecSet.Fields.Item('IsIndividualPlan').Value;
                        rGeneralTable."Scholarship Reinforcement" := autRecSet.Fields.Item('IsReinforcement').Value;
                        rGeneralTable."Scholarship Support" := autRecSet.Fields.Item('IsSupport').Value;
                        rGeneralTable.Modify;


                        rClass.Reset;
                        rClass.SetRange(Class, rGeneralTable.Class);
                        rClass.SetRange("School Year", rGeneralTable."School Year");
                        if rClass.Find('-') and (rGeneralTable."Is SubSubject" = false) then begin

                            AssessementConfiguration.Reset;
                            AssessementConfiguration.SetRange("School Year", rGeneralTable."School Year");
                            AssessementConfiguration.SetRange(Type, rClass.Type);
                            AssessementConfiguration.SetRange("Study Plan Code", rClass."Study Plan Code");
                            if AssessementConfiguration.Find('-') then begin
                                GradeDec := 0;
                                GradeTXT2 := rGeneralTable.GradeAuto;
                                if Evaluate(GradeDec, GradeTXT2) then
                                    rGeneralTable.GradeAuto := Format(Round(GradeDec, AssessementConfiguration."PA Subject Round Method"));
                                GradeDec := 0;
                                GradeTXT2 := rGeneralTable.GradeManual;
                                if Evaluate(GradeDec, GradeTXT2) then
                                    rGeneralTable.GradeManual := Format(Round(GradeDec, AssessementConfiguration."PA Subject Round Method"));

                                varGradeRecTXT := autRecSet.Fields.Item('GradeRec').Value;
                                Evaluate(varGradeRec, varGradeRecTXT);
                                rGeneralTable."Recuperation Grade" := varGradeRec;

                                rGeneralTable."Has Individual Plan" := autRecSet.Fields.Item('IsIndividualPlan').Value;
                                rGeneralTable."Scholarship Reinforcement" := autRecSet.Fields.Item('IsReinforcement').Value;
                                rGeneralTable."Scholarship Support" := autRecSet.Fields.Item('IsSupport').Value;
                                rGeneralTable.Modify;
                            end;
                        end;
                    end;

                    intCount := intCount + 1;

                    //Change the status of the line in the database
                    txtSQLBegin := Text0011;
                    txtSQLEnd := '';
                    txtSeparador := ', ';

                    txtVALUES[1] := StrSubstNo(Text0001, Format(rGeneralTable."Entry No."));
                    txtVALUES[2] := StrSubstNo(Text0001, Format(cInsertWEBGenTable.InsertString(CompanyName)));
                    txtVALUES[3] := StrSubstNo(Text0001, Format(cInsertWEBGenTable.InsertString(rGeneralTable."School Year")));
                    txtVALUES[4] := StrSubstNo(Text0001, Format(cInsertWEBGenTable.InsertString(rGeneralTable.Student)));
                    txtVALUES[5] := StrSubstNo(Text0001, Format(cInsertWEBGenTable.InsertString(rGeneralTable.Class)));
                    txtVALUES[6] := StrSubstNo(Text0001, Format(cInsertWEBGenTable.InsertString(rGeneralTable.Subject)));
                    txtVALUES[7] := StrSubstNo(Text0001, Format(cInsertWEBGenTable.InsertString(rGeneralTable."Sub Subject")));
                    txtVALUES[8] := StrSubstNo(Text0001, Format(rGeneralTable."Is SubSubject", 0, '<Number>'));
                    txtVALUES[9] := StrSubstNo(Text0001, Format(cInsertWEBGenTable.InsertString(rGeneralTable.Moment)));
                    txtVALUES[10] := StrSubstNo(Text0001, Format(rGeneralTable."Moment Ponder"));
                    txtVALUES[11] := StrSubstNo(Text0001, Format(rGeneralTable."Subject Ponder"));
                    txtVALUES[12] := StrSubstNo(Text0001, Format(rGeneralTable."Sub Subject Ponder"));
                    txtVALUES[13] := StrSubstNo(Text0001,
                                     Format(CurrentDateTime, 0, '<Year4>-<Month,2>-<Day,2> <Hours24>:<Minutes,2>:<Seconds,2>'));
                    txtVALUES[14] := StrSubstNo(Text0001, Format(rGeneralTable.GradeAuto));
                    txtVALUES[15] := StrSubstNo(Text0001, Format(rGeneralTable.GradeManual));
                    txtVALUES[16] := StrSubstNo(Text0001, Format(0));
                    txtVALUES[17] := StrSubstNo(Text0001, Format(cInsertWEBGenTable.InsertString(rGeneralTable.SchoolingYear)));
                    txtVALUES[18] := StrSubstNo(Text0001, Format(cInsertWEBGenTable.InsertString(rGeneralTable.Turn)));
                    txtVALUES[19] := StrSubstNo(Text0001, Format(rGeneralTable."Recuperation Grade"));
                    txtVALUES[20] := StrSubstNo(Text0001, Format(rGeneralTable."Has Individual Plan", 0, '<Number>'));
                    txtVALUES[21] := StrSubstNo(Text0001, Format(rGeneralTable."Scholarship Support", 0, '<Number>'));
                    txtVALUES[22] := StrSubstNo(Text0001, Format(rGeneralTable."Scholarship Reinforcement", 0, '<Number>'));



                    // Statement que irá permitir incluir cada linha da tabela Navision para a tabela SQL
                    autConnection.Execute(txtSQLBegin +
                    txtVALUES[1] + txtSeparador +
                    txtVALUES[2] + txtSeparador +
                    txtVALUES[3] + txtSeparador +
                    txtVALUES[4] + txtSeparador +
                    txtVALUES[5] + txtSeparador +
                    txtVALUES[6] + txtSeparador +
                    txtVALUES[7] + txtSeparador +
                    txtVALUES[8] + txtSeparador +
                    txtVALUES[9] + txtSeparador +
                    txtVALUES[10] + txtSeparador +
                    txtVALUES[11] + txtSeparador +
                    txtVALUES[12] + txtSeparador +
                    txtVALUES[13] + txtSeparador +
                    txtVALUES[14] + txtSeparador +
                    txtVALUES[15] + txtSeparador +
                    txtVALUES[16] + txtSeparador +
                    txtVALUES[17] + txtSeparador +
                    txtVALUES[18] + txtSeparador +
                    txtVALUES[19] + txtSeparador +
                    txtVALUES[20] + txtSeparador +
                    txtVALUES[21] + txtSeparador +
                    txtVALUES[22] +
                    txtSQLEnd);

                    //
                    autRecSet.MoveNext;
                until autRecSet.EOF;
            end;
        end;

        //[Scope('OnPrem')]
        procedure WEBtoNAVFinalAssessment()
        var
            Text0001: Label '''%1''';
            Text0002: Label 'SELECT * from dbo.[view_temp_Students_Class]';
            Text0003: Label ' Where Company = ''%1''';
            autConnection: Automation;
            autRecSet: Automation;
            rGeneralTable: Record GeneralTable;
            rGeneralTable2: Record GeneralTable;
            rGeneralTable3: Record GeneralTable;
            rCompanyInfo: Record "Company Information";
            AssessementConfiguration: Record "Assessment Configuration";
            rClass: Record Class;
            cInsertWEBGenTable: Codeunit InsertWEBGenTable;
            txtSQL: Text[1024];
            optUpdateType: Option " ",Insert,Update,Delete;
            intCount: Integer;
            intActiveMoment: Integer;
            txtSQLBegin: Text[1024];
            txtSQLEnd: Text[1024];
            txtSeparador: Text[30];
            txtVALUES: array[30] of Text[1024];
            Text0004: Label 'There is nothing to import.';
            i: Integer;
            k: Integer;
            SubjectCals: Decimal;
            SUMPounder: Decimal;
            SubSubjectValue: Variant;
            SubSubjectValueDEC: Decimal;
            EntryNoPortal: Integer;
            GradeTXT: Variant;
            GradeDec: Decimal;
            GradeTXT1: Text[30];
            GradeTXT2: Text[30];
            GradeDec1: Decimal;
            GradeDec2: Decimal;
            Text0005: Label 'UPDATE dbo.[temp_Assessing_Students_Final] SET ';
            Text0006: Label ' Where EntryNo = ''%1'' and Company = ''%2''';
            Text0007: Label 'SELECT * from dbo.[view_temp_Students_GroupSubjects]';
            Text0009: Label 'EXEC sp_temp_Student_ClassGrade';
            Text0010: Label 'EXEC sp_temp_Student_GroupSubjectGrade';
            lCompany: Text[100];
            lSchoolYear: Text[30];
            lStudent: Text[30];
            lClassw: Text[30];
            lMoment: Text[30];
            lSchoolingYear: Text[30];
            lOptionGroup: Text[30];
        begin
            rCompanyInfo.Get;
            case rCompanyInfo."Connection Type" of
                rCompanyInfo."Connection Type"::" ":
                    exit;
                rCompanyInfo."Connection Type"::"1 Connection":
                    i := 1;
                rCompanyInfo."Connection Type"::"2 Connection":
                    i := 2;
            end;

            for k := 1 to i do begin

                //Student Moment Final Classification
                // Feita a Ligação ao SQL através da funcão CREATEDBConnection
                Clear(autConnection);
                cInsertWEBMasterTable.CreateDBConnection(autConnection, k);

                // Espaço para inserir qualquer tipo de filtragem

                // Criado o apontador para a tabela de sql. Este apontador irá nos ajudar a percorrer as linhas da tabela.
                Clear(autRecSet);
                Create(autRecSet, false, true);

                // Declaração da statement que nos porporcionará posicionar-mos na linha que pretendemos obter informação.
                txtSQL := Text0002 + Text0003;
                txtSQL := StrSubstNo(txtSQL, CompanyName);

                // Neste momento apontamos o apontador para a tabela, enviando a statement criada em cima.
                autRecSet.Open(txtSQL, autConnection, 1, 1);

                // Verificação de que se o apontador chegou ao fim da tabela SQL, terminando o dataitem do report
                if autRecSet.EOF then begin
                    exit;
                end;

                intCount := 1;
                repeat
                    if intCount = 1 then
                        autRecSet.MoveFirst;
                    SubjectCals := 0;
                    SUMPounder := 0;

                    lCompany := autRecSet.Fields.Item('Company').Value;
                    lSchoolYear := autRecSet.Fields.Item('SchoolYear').Value;
                    lStudent := autRecSet.Fields.Item('Student').Value;
                    lClassw := autRecSet.Fields.Item('Classw').Value;
                    lMoment := autRecSet.Fields.Item('Moment').Value;
                    lSchoolingYear := autRecSet.Fields.Item('SchoolingYear').Value;

                    //EntryNoPortal := autRecSet.Fields.Item('EntryNo').Value;
                    rGeneralTable.LockTable(true);
                    rGeneralTable.Reset;
                    rGeneralTable.SetRange(Company, lCompany);
                    rGeneralTable.SetRange("School Year", lSchoolYear);
                    rGeneralTable.SetRange(Student, lStudent);
                    rGeneralTable.SetRange(Class, lClassw);
                    rGeneralTable.SetRange("Option Group", '');
                    //rGeneralTable.SETRANGE("Option Group",autRecSet.Fields.Item('Subject_Group').Value);
                    //rGeneralTable.SETRANGE("Entry Type",autRecSet.Fields.Item('EvaluationType').Value);
                    rGeneralTable.SetRange(Moment, lMoment);
                    rGeneralTable.SetRange(SchoolingYear, lSchoolingYear);
                    rGeneralTable.SetFilter("Entry Type", '<>0');
                    if rGeneralTable.Find('-') then begin
                        if rGeneralTable2.Get(rGeneralTable."Entry No.") then begin

                            rGeneralTable2.GradeManual := autRecSet.Fields.Item('GradeManual').Value;
                            rGeneralTable2."Qualitative Eval." := autRecSet.Fields.Item('GradeManual').Value;

                            AssessementConfiguration.Reset;
                            AssessementConfiguration.SetRange("School Year", rGeneralTable."School Year");
                            AssessementConfiguration.SetRange(Type, rGeneralTable."Type Education");
                            AssessementConfiguration.SetRange("Study Plan Code", rGeneralTable.StudyPlanCode);
                            if AssessementConfiguration.Find('-') then begin
                                GradeDec := 0;
                                GradeTXT2 := rGeneralTable2.GradeManual;
                                if Evaluate(GradeDec, GradeTXT2) then begin
                                    case rGeneralTable."Entry Type" of
                                        rGeneralTable."Entry Type"::"Final Moment":
                                            rGeneralTable2.GradeManual := Format(Round(GradeDec, AssessementConfiguration."PA Final Round Method"));
                                        rGeneralTable."Entry Type"::"Final Moment Group":
                                            rGeneralTable2.GradeManual := Format(Round(GradeDec, AssessementConfiguration."PA Group Sub. Round Method"));
                                        rGeneralTable."Entry Type"::"Final Year":
                                            rGeneralTable2.GradeManual := Format(Round(GradeDec, AssessementConfiguration."FY Final Round Method"));
                                        rGeneralTable."Entry Type"::"Final Year Group":
                                            rGeneralTable2.GradeManual := Format(Round(GradeDec, AssessementConfiguration."FY Group Sub. Round Method"));
                                    end;
                                end;
                            end;
                            rGeneralTable2.Modify;

                            txtSQLBegin := Text0009;
                            txtSQLEnd := '';
                            txtSeparador := ', ';

                            txtVALUES[1] := StrSubstNo(Text0001, Format(cInsertWEBGenTable.InsertString(CompanyName)));
                            txtVALUES[2] := StrSubstNo(Text0001, Format(cInsertWEBGenTable.InsertString(rGeneralTable2."School Year")));
                            txtVALUES[3] := StrSubstNo(Text0001, Format(cInsertWEBGenTable.InsertString(rGeneralTable2.Student)));
                            txtVALUES[4] := StrSubstNo(Text0001, Format(cInsertWEBGenTable.InsertString(rGeneralTable2.Class)));
                            txtVALUES[5] := StrSubstNo(Text0001, Format(cInsertWEBGenTable.InsertString(rGeneralTable2.Moment)));
                            txtVALUES[6] := StrSubstNo(Text0001, Format(rGeneralTable2."Type Education", 0, '<Number>'));
                            txtVALUES[7] := StrSubstNo(Text0001, Format(rGeneralTable2.EvaluationType, 0, '<Number>'));
                            txtVALUES[8] := StrSubstNo(Text0001, Format(rGeneralTable2.GradeAuto));
                            txtVALUES[9] := StrSubstNo(Text0001, Format(rGeneralTable2.GradeManual));
                            txtVALUES[10] := StrSubstNo(Text0001, Format(0));
                            txtVALUES[11] := StrSubstNo(Text0001, Format(cInsertWEBGenTable.InsertString(rGeneralTable2.SchoolingYear)));
                            txtVALUES[12] := StrSubstNo(Text0001, Format(cInsertWEBGenTable.InsertString(rGeneralTable2."Responsibility Center")));

                            // Statement que irá permitir incluir cada linha da tabela Navision para a tabela SQL
                            autConnection.Execute(txtSQLBegin +
                            txtVALUES[1] + txtSeparador +
                            txtVALUES[2] + txtSeparador +
                            txtVALUES[3] + txtSeparador +
                            txtVALUES[4] + txtSeparador +
                            txtVALUES[5] + txtSeparador +
                            txtVALUES[6] + txtSeparador +
                            txtVALUES[7] + txtSeparador +
                            txtVALUES[8] + txtSeparador +
                            txtVALUES[9] + txtSeparador +
                            txtVALUES[10] + txtSeparador +
                            txtVALUES[11] + txtSeparador +
                            txtVALUES[12] +
                            txtSQLEnd);

                        end;
                    end;

                    intCount := intCount + 1;


                    autRecSet.MoveNext;
                until autRecSet.EOF;

                //Group Classifications
                // Feita a Ligação ao SQL através da funcão CREATEDBConnection
                Clear(autConnection);
                cInsertWEBMasterTable.CreateDBConnection(autConnection, k);

                // Espaço para inserir qualquer tipo de filtragem

                // Criado o apontador para a tabela de sql. Este apontador irá nos ajudar a percorrer as linhas da tabela.
                Clear(autRecSet);
                Create(autRecSet, false, true);

                // Declaração da statement que nos porporcionará posicionar-mos na linha que pretendemos obter informação.
                txtSQL := Text0007 + Text0003;
                txtSQL := StrSubstNo(txtSQL, CompanyName);

                // Neste momento apontamos o apontador para a tabela, enviando a statement criada em cima.
                autRecSet.Open(txtSQL, autConnection, 1, 1);

                // Verificação de que se o apontador chegou ao fim da tabela SQL, terminando o dataitem do report
                if autRecSet.EOF then begin
                    exit;
                end;

                intCount := 1;
                repeat
                    if intCount = 1 then
                        autRecSet.MoveFirst;
                    SubjectCals := 0;
                    SUMPounder := 0;

                    //EntryNoPortal := autRecSet.Fields.Item('EntryNo').Value;

                    lCompany := autRecSet.Fields.Item('Company').Value;
                    lSchoolYear := autRecSet.Fields.Item('SchoolYear').Value;
                    lStudent := autRecSet.Fields.Item('Student').Value;
                    lClassw := autRecSet.Fields.Item('Classw').Value;
                    lMoment := autRecSet.Fields.Item('Moment').Value;
                    lSchoolingYear := autRecSet.Fields.Item('SchoolingYear').Value;
                    lOptionGroup := autRecSet.Fields.Item('OptionGroup').Value;


                    rGeneralTable.LockTable(true);
                    rGeneralTable.Reset;
                    rGeneralTable.SetRange(Company, lCompany);
                    rGeneralTable.SetRange("School Year", lSchoolYear);
                    rGeneralTable.SetRange(Student, lStudent);
                    rGeneralTable.SetRange(Class, lClassw);
                    rGeneralTable.SetRange("Option Group", lOptionGroup);
                    rGeneralTable.SetRange(Moment, lMoment);
                    rGeneralTable.SetRange(SchoolingYear, lSchoolingYear);
                    rGeneralTable.SetFilter("Entry Type", '<>0');
                    if rGeneralTable.Find('-') then begin
                        if rGeneralTable2.Get(rGeneralTable."Entry No.") then begin
                            rGeneralTable2.GradeManual := autRecSet.Fields.Item('GradeManual').Value;
                            rGeneralTable2."Qualitative Eval." := autRecSet.Fields.Item('GradeManual').Value;

                            AssessementConfiguration.Reset;
                            AssessementConfiguration.SetRange("School Year", rGeneralTable."School Year");
                            AssessementConfiguration.SetRange(Type, rClass.Type);
                            AssessementConfiguration.SetRange("Study Plan Code", rClass."Study Plan Code");
                            if AssessementConfiguration.Find('-') then begin
                                GradeDec := 0;
                                GradeTXT2 := rGeneralTable2.GradeManual;
                                if Evaluate(GradeDec, GradeTXT2) then begin
                                    case rGeneralTable."Entry Type" of
                                        rGeneralTable."Entry Type"::"Final Moment":
                                            rGeneralTable2.GradeManual := Format(Round(GradeDec, AssessementConfiguration."PA Final Round Method"));
                                        rGeneralTable."Entry Type"::"Final Moment Group":
                                            rGeneralTable2.GradeManual := Format(Round(GradeDec, AssessementConfiguration."PA Group Sub. Round Method"));
                                        rGeneralTable."Entry Type"::"Final Year":
                                            rGeneralTable2.GradeManual := Format(Round(GradeDec, AssessementConfiguration."FY Final Round Method"));
                                        rGeneralTable."Entry Type"::"Final Year Group":
                                            rGeneralTable2.GradeManual := Format(Round(GradeDec, AssessementConfiguration."FY Group Sub. Round Method"));
                                    end;
                                end;
                            end;
                            rGeneralTable2.Modify;

                            txtSQLBegin := Text0010;
                            txtSQLEnd := '';
                            txtSeparador := ', ';

                            txtVALUES[1] := StrSubstNo(Text0001, Format(cInsertWEBGenTable.InsertString(CompanyName)));
                            txtVALUES[2] := StrSubstNo(Text0001, Format(cInsertWEBGenTable.InsertString(rGeneralTable2."School Year")));
                            txtVALUES[3] := StrSubstNo(Text0001, Format(cInsertWEBGenTable.InsertString(rGeneralTable2.Student)));
                            txtVALUES[4] := StrSubstNo(Text0001, Format(cInsertWEBGenTable.InsertString(rGeneralTable2.Class)));
                            txtVALUES[5] := StrSubstNo(Text0001, Format(cInsertWEBGenTable.InsertString(rGeneralTable2."Option Group")));
                            txtVALUES[6] := StrSubstNo(Text0001, Format(cInsertWEBGenTable.InsertString(rGeneralTable2.Moment)));
                            txtVALUES[7] := StrSubstNo(Text0001, Format(rGeneralTable2.GradeAuto));
                            txtVALUES[8] := StrSubstNo(Text0001, Format(rGeneralTable2.GradeManual));
                            txtVALUES[9] := StrSubstNo(Text0001, Format(0));
                            txtVALUES[10] := StrSubstNo(Text0001, Format(cInsertWEBGenTable.InsertString(rGeneralTable2.SchoolingYear)));
                            txtVALUES[11] := StrSubstNo(Text0001, Format(cInsertWEBGenTable.InsertString(rGeneralTable2."Responsibility Center")));

                            // Statement que irá permitir incluir cada linha da tabela Navision para a tabela SQL
                            autConnection.Execute(txtSQLBegin +
                            txtVALUES[1] + txtSeparador +
                            txtVALUES[2] + txtSeparador +
                            txtVALUES[3] + txtSeparador +
                            txtVALUES[4] + txtSeparador +
                            txtVALUES[5] + txtSeparador +
                            txtVALUES[6] + txtSeparador +
                            txtVALUES[7] + txtSeparador +
                            txtVALUES[8] + txtSeparador +
                            txtVALUES[9] + txtSeparador +
                            txtVALUES[10] + txtSeparador +
                            txtVALUES[11] +
                            txtSQLEnd);

                        end;
                    end;

                    intCount := intCount + 1;

                    autRecSet.MoveNext;
                until autRecSet.EOF;

            end;
        end;

        //[Scope('OnPrem')]
        procedure WEBtoNAVAspects()
        var
            Text0001: Label '''%1''';
            Text0002: Label 'SELECT * from dbo.[view_temp_Students_SubSubjects_Aspects]';
            Text0003: Label ' Where Company = ''%1''';
            autConnection: Automation;
            autRecSet: Automation;
            rGeneralTableAspects: Record GeneralTableAspects;
            rCompanyInfo: Record "Company Information";
            AssessementConfiguration: Record "Assessment Configuration";
            rClass: Record Class;
            rGeneralTable: Record GeneralTable;
            cInsertWEBGenTable: Codeunit InsertWEBGenTable;
            txtSQL: Text[1024];
            optUpdateType: Option " ",Insert,Update,Delete;
            intCount: Integer;
            intActiveMoment: Integer;
            txtSQLBegin: Text[1024];
            txtSQLEnd: Text[1024];
            txtSeparador: Text[30];
            txtVALUES: array[30] of Text[1024];
            Text0004: Label 'There is nothing to import.';
            i: Integer;
            k: Integer;
            SubjectCals: Decimal;
            SUMPounder: Decimal;
            SubSubjectValue: Decimal;
            EntryNoPortal: Integer;
            GradeTXT: Variant;
            GradeDec: Decimal;
            GradeTXT1: Text[30];
            GradeTXT2: Text[30];
            GradeDec1: Decimal;
            GradeDec2: Decimal;
            Text0005: Label 'UPDATE dbo.[nav_SS_Evals_Aspects] SET ';
            Text0006: Label ' Where SS_Evals_Aspects = ''%1'' and Company = ''%2''';
            Text0009: Label 'EXEC sp_temp_Student_AspectGrade';
        begin
            rCompanyInfo.Get;
            case rCompanyInfo."Connection Type" of
                rCompanyInfo."Connection Type"::" ":
                    exit;
                rCompanyInfo."Connection Type"::"1 Connection":
                    i := 1;
                rCompanyInfo."Connection Type"::"2 Connection":
                    i := 2;
            end;

            for k := 1 to i do begin

                // Feita a Ligação ao SQL através da funcão CREATEDBConnection
                Clear(autConnection);
                cInsertWEBMasterTable.CreateDBConnection(autConnection, k);

                // Espaço para inserir qualquer tipo de filtragem

                // Criado o apontador para a tabela de sql. Este apontador irá nos ajudar a percorrer as linhas da tabela.
                Clear(autRecSet);
                Create(autRecSet, false, true);

                // Declaração da statement que nos porporcionará posicionar-mos na linha que pretendemos obter informação.
                txtSQL := Text0002 + Text0003;
                txtSQL := StrSubstNo(txtSQL, CompanyName);

                // Neste momento apontamos o apontador para a tabela, enviando a statement criada em cima.
                autRecSet.Open(txtSQL, autConnection, 1, 1);

                // Verificação de que se o apontador chegou ao fim da tabela SQL, terminando o dataitem do report
                if autRecSet.EOF then begin
                    exit;
                end;

                intCount := 1;
                repeat
                    if intCount = 1 then
                        autRecSet.MoveFirst;
                    SubjectCals := 0;
                    SUMPounder := 0;
                    intCount := intCount + 1;

                    EntryNoPortal := autRecSet.Fields.Item('EntryNo_GA').Value;
                    rGeneralTableAspects.LockTable(true);
                    rGeneralTableAspects.Reset;
                    rGeneralTableAspects.SetRange("Entry No.", EntryNoPortal);
                    if rGeneralTableAspects.Find('-') then begin

                        GradeTXT := autRecSet.Fields.Item('GradeAuto').Value;
                        if GradeTXT.IsText then
                            rGeneralTableAspects.GradeAuto := Format(GradeTXT);
                        GradeTXT := autRecSet.Fields.Item('GradeManual').Value;
                        if GradeTXT.IsText then
                            rGeneralTableAspects.GradeManual := Format(GradeTXT);

                        rGeneralTableAspects."Update Type" := rGeneralTableAspects."Update Type"::Update;
                        if rGeneralTableAspects."Update Type 2" <> rGeneralTableAspects."Update Type 2"::Insert then
                            rGeneralTableAspects."Update Type 2" := rGeneralTableAspects."Update Type 2"::Update;

                        rGeneralTableAspects.Modify;

                        //Insert grades by store
                        txtSQLBegin := Text0009;
                        txtSQLEnd := '';
                        txtSeparador := ', ';

                        if rGeneralTable.Get(rGeneralTableAspects."Study Plan Entry No.") then;

                        txtVALUES[1] := StrSubstNo(Text0001, Format(rGeneralTableAspects."Entry No."));
                        txtVALUES[2] := StrSubstNo(Text0001, Format(rGeneralTableAspects."Study Plan Entry No."));
                        txtVALUES[3] := StrSubstNo(Text0001, Format(cInsertWEBGenTable.InsertString(rGeneralTableAspects."School Year")));
                        txtVALUES[4] := StrSubstNo(Text0001, Format(cInsertWEBGenTable.InsertString(CompanyName)));
                        txtVALUES[5] := StrSubstNo(Text0001, Format(cInsertWEBGenTable.InsertString(rGeneralTableAspects.Aspect)));
                        txtVALUES[6] := ConvertStr(StrSubstNo(Text0001, Format(rGeneralTableAspects."Percent Aspect")), ',', '.');
                        txtVALUES[7] := StrSubstNo(Text0001,
                                         Format(CurrentDateTime, 0, '<Year4>-<Month,2>-<Day,2> <Hours24>:<Minutes,2>:<Seconds,2>'));
                        txtVALUES[8] := StrSubstNo(Text0001, Format(rGeneralTableAspects.GradeAuto));
                        txtVALUES[9] := StrSubstNo(Text0001, Format(rGeneralTableAspects.GradeManual));
                        txtVALUES[10] := StrSubstNo(Text0001, Format('0'));
                        txtVALUES[11] := StrSubstNo(Text0001, Format(rGeneralTable."Is SubSubject", 0, '<Number>'));
                        txtVALUES[12] := StrSubstNo(Text0001, Format(rGeneralTable.StudyPlanCode));
                        txtVALUES[13] := StrSubstNo(Text0001, Format(rGeneralTable."Type Education", 0, '<Number>'));

                        // Statement que irá permitir incluir cada linha da tabela Navision para a tabela SQL
                        autConnection.Execute(txtSQLBegin +
                        txtVALUES[1] + txtSeparador +
                        txtVALUES[2] + txtSeparador +
                        txtVALUES[3] + txtSeparador +
                        txtVALUES[4] + txtSeparador +
                        txtVALUES[5] + txtSeparador +
                        txtVALUES[6] + txtSeparador +
                        txtVALUES[7] + txtSeparador +
                        txtVALUES[8] + txtSeparador +
                        txtVALUES[9] + txtSeparador +
                        txtVALUES[10] + txtSeparador +
                        txtVALUES[11] + txtSeparador +
                        txtVALUES[12] + txtSeparador +
                        txtVALUES[13] +
                        txtSQLEnd);
                    end;

                    autRecSet.MoveNext;
                until autRecSet.EOF;
            end;
        end;

        //[Scope('OnPrem')]
        procedure WEBtoNAVIncidences()
        var
            Text0001: Label '''%1''';
            Text0002: Label 'SELECT * from dbo.[view_temp_IncidenceStudent]';
            Text0003: Label ' Where Company = ''%1''';
            autConnection: Automation;
            autRecSet: Automation;
            rGeneralTableAspects: Record GeneralTableAspects;
            rCompanyInfo: Record "Company Information";
            AssessementConfiguration: Record "Assessment Configuration";
            rClass: Record Class;
            rGeneralTable: Record GeneralTable;
            rWebCalendar: Record "Web Calendar";
            rCalendar: Record Calendar;
            cInsertWEBGenTable: Codeunit InsertWEBGenTable;
            rAbsence: Record Absence;
            rWEBAbsence: Record "WEB Absence";
            txtSQL: Text[1024];
            optUpdateType: Option " ",Insert,Update,Delete;
            intCount: Integer;
            intActiveMoment: Integer;
            txtSQLBegin: Text[1024];
            txtSQLEnd: Text[1024];
            txtSeparador: Text[30];
            txtVALUES: array[30] of Text[1024];
            Text0004: Label 'There is nothing to import.';
            i: Integer;
            k: Integer;
            SubjectCals: Decimal;
            SUMPounder: Decimal;
            SubSubjectValue: Decimal;
            Text0009: Label 'EXEC sp_temp_InsertUpdate_IncidenceStudent';
            ID_IncidenceStudentLine: Text[30];
            ID_Calendar: Integer;
            StudentCodeNo: Text[30];
            SchoolYear: Text[30];
            SchoolingYear: Text[30];
            Type: Text[30];
            SubType: Text[30];
            IncidenceCode: Text[30];
            JustificationCode: Text[30];
            Text0010: Label 'SELECT * from dbo.[view_temp_IncidenceDailyStudent]';
            Text0011: Label 'EXEC sp_temp_InsertUpdate_IncidenceDailyStudent';
            Class: Text[30];
            Date: Text[30];
            IncidenceType: Text[30];
            IsDeleted: Boolean;
            Text0012: Label 'EXEC sp_temp_Delete_IncidenceStudent';
            Text0013: Label 'EXEC sp_temp_Delete_IncidenceDailyStudent';
        begin
            rCompanyInfo.Get;
            case rCompanyInfo."Connection Type" of
                rCompanyInfo."Connection Type"::" ":
                    exit;
                rCompanyInfo."Connection Type"::"1 Connection":
                    i := 1;
                rCompanyInfo."Connection Type"::"2 Connection":
                    i := 2;
            end;

            for k := 1 to i do begin

                // Feita a Ligação ao SQL através da funcão CREATEDBConnection
                Clear(autConnection);
                cInsertWEBMasterTable.CreateDBConnection(autConnection, k);

                // Espaço para inserir qualquer tipo de filtragem

                // Criado o apontador para a tabela de sql. Este apontador irá nos ajudar a percorrer as linhas da tabela.
                Clear(autRecSet);
                Create(autRecSet, false, true);

                // Declaração da statement que nos porporcionará posicionar-mos na linha que pretendemos obter informação.
                txtSQL := Text0002 + Text0003;
                txtSQL := StrSubstNo(txtSQL, CompanyName);

                // Neste momento apontamos o apontador para a tabela, enviando a statement criada em cima.
                autRecSet.Open(txtSQL, autConnection, 1, 1);

                // Verificação de que se o apontador chegou ao fim da tabela SQL, terminando o dataitem do report
                if autRecSet.EOF then begin
                    exit;
                end;

                intCount := 1;
                repeat
                    if intCount = 1 then
                        autRecSet.MoveFirst;
                    SubjectCals := 0;
                    SUMPounder := 0;
                    intCount := intCount + 1;

                    ID_IncidenceStudentLine := Format(autRecSet.Fields.Item('ID_IncidenceStudentLine').Value);
                    ID_Calendar := autRecSet.Fields.Item('ID_Calendar').Value;
                    StudentCodeNo := autRecSet.Fields.Item('StudentCodeNo').Value;
                    SchoolYear := autRecSet.Fields.Item('SchoolYear').Value;
                    SchoolingYear := autRecSet.Fields.Item('SchoolingYear').Value;
                    Type := Format(autRecSet.Fields.Item('Type').Value);
                    SubType := autRecSet.Fields.Item('SubType').Value;
                    IncidenceCode := autRecSet.Fields.Item('IncidenceCode').Value;
                    JustificationCode := autRecSet.Fields.Item('JustificationCode').Value;
                    IncidenceType := Format(autRecSet.Fields.Item('IncidenceType').Value);
                    IsDeleted := autRecSet.Fields.Item('isDeleted').Value;
                    if not IsDeleted then begin

                        if rWebCalendar.Get(ID_Calendar) then begin
                            rCalendar.Reset;
                            rCalendar.SetCurrentKey(rCalendar."Web ID");
                            rCalendar.SetRange("Web ID", rWebCalendar.ID);
                            if rCalendar.FindFirst then;

                            // For Updata OR Insert Must delete old lines.
                            rAbsence.Reset;
                            rAbsence.SetRange("Timetable Code", rWebCalendar."Timetable Code");
                            rAbsence.SetRange("School Year", rWebCalendar."School Year");
                            rAbsence.SetRange("Study Plan", rWebCalendar."Study Plan");
                            rAbsence.SetRange(Class, rWebCalendar.Class);
                            rAbsence.SetRange(Type, rWebCalendar.Type);
                            rAbsence.SetRange("Line No. Timetable", rCalendar."Line No.");
                            rAbsence.SetRange("Student/Teacher", rAbsence."Student/Teacher"::Student);
                            rAbsence.SetRange("Student/Teacher Code No.", StudentCodeNo);
                            rAbsence.SetRange("Responsibility Center", rCalendar."Responsibility Center");
                            rAbsence.SetRange(Subject, rWebCalendar.Subject);
                            rAbsence.SetRange("Absence Type", rCalendar."Absence Type");
                            rAbsence.SetRange("Sub-Subject Code", rWebCalendar."Sub-Subject Code");
                            rAbsence.SetRange(Turn, rWebCalendar.Turn);
                            rAbsence.SetRange("Schooling Year", rWebCalendar."Schooling Year");
                            rAbsence.SetRange("Type Subject", rCalendar."Type Subject");
                            rAbsence.SetFilter(Day, Date);
                            rAbsence.SetRange("Justified Code", JustificationCode);
                            rAbsence.SetFilter("Incidence Type", IncidenceType);
                            rAbsence.SetRange("Incidence Code", IncidenceCode);
                            rAbsence.SetFilter(Category, Type);
                            rAbsence.SetRange("Subcategory Code", SubType);
                            if rAbsence.FindFirst then
                                rAbsence.Delete;

                            rWEBAbsence.Reset;
                            rWEBAbsence.SetRange("Timetable Code", rWebCalendar."Timetable Code");
                            rWEBAbsence.SetRange("School Year", rWebCalendar."School Year");
                            rWEBAbsence.SetRange("Study Plan", rWebCalendar."Study Plan");
                            rWEBAbsence.SetRange(Class, rWebCalendar.Class);
                            rWEBAbsence.SetRange(Type, rWebCalendar.Type);
                            rWEBAbsence.SetRange("Line No. Timetable", rCalendar."Line No.");
                            rWEBAbsence.SetRange("Student/Teacher", rWEBAbsence."Student/Teacher"::Student);
                            rWEBAbsence.SetRange("Student/Teacher Code No.", StudentCodeNo);
                            rWEBAbsence.SetRange("Responsibility Center", rCalendar."Responsibility Center");
                            rWEBAbsence.SetRange(Subject, rWebCalendar.Subject);
                            rWEBAbsence.SetRange("Absence Type", rCalendar."Absence Type");
                            rWEBAbsence.SetRange("Sub-Subject Code", rWebCalendar."Sub-Subject Code");
                            rWEBAbsence.SetRange(Turn, rWebCalendar.Turn);
                            rWEBAbsence.SetRange("Schooling Year", rWebCalendar."Schooling Year");
                            rWEBAbsence.SetRange("Type Subject", rCalendar."Type Subject");
                            rWEBAbsence.SetFilter(Day, Date);
                            rWEBAbsence.SetRange("Justified Code", JustificationCode);
                            rWEBAbsence.SetFilter("Incidence Type", IncidenceType);
                            rWEBAbsence.SetRange("Incidence Code", IncidenceCode);
                            rWEBAbsence.SetFilter(Category, Type);
                            rWEBAbsence.SetRange("Subcategory Code", SubType);
                            if rWEBAbsence.FindFirst then
                                rWEBAbsence.Delete;
                            //
                            rAbsence.Init;
                            rAbsence."Timetable Code" := rWebCalendar."Timetable Code";
                            rAbsence."School Year" := rWebCalendar."School Year";
                            rAbsence."Study Plan" := rWebCalendar."Study Plan";
                            rAbsence.Class := rWebCalendar.Class;
                            rAbsence.Type := rWebCalendar.Type;
                            rAbsence."Line No. Timetable" := rCalendar."Line No.";
                            rAbsence."Student/Teacher" := rAbsence."Student/Teacher"::Student;
                            rAbsence.Validate("Student/Teacher Code No.", StudentCodeNo);
                            rAbsence."Responsibility Center" := rCalendar."Responsibility Center";
                            rAbsence.Subject := rWebCalendar.Subject;
                            rAbsence.Day := rCalendar."Filter Period";
                            rAbsence."Absence Type" := rCalendar."Absence Type";
                            rAbsence."Sub-Subject Code" := rWebCalendar."Sub-Subject Code";
                            rAbsence.Turn := rWebCalendar.Turn;
                            rAbsence."Schooling Year" := rWebCalendar."Schooling Year";
                            rAbsence."Type Subject" := rCalendar."Type Subject";
                            rAbsence."Justified Code" := JustificationCode;
                            Evaluate(rAbsence."Incidence Type", IncidenceType);
                            rAbsence."Incidence Code" := IncidenceCode;
                            Evaluate(rAbsence.Category, Type);
                            rAbsence."Subcategory Code" := SubType;
                            if rAbsence."Incidence Type" = rAbsence."Incidence Type"::Default then
                                rAbsence."Absence Status" := rAbsence."Absence Status"::Justified;
                            if rAbsence."Incidence Type" = rAbsence."Incidence Type"::Absence then
                                rAbsence."Absence Status" := rAbsence."Absence Status"::Unjustified;
                            if (rAbsence."Incidence Type" = rAbsence."Incidence Type"::Absence) and
                              (rAbsence."Justified Code" <> '') then
                                rAbsence."Absence Status" := rAbsence."Absence Status"::Justification;
                            rAbsence."Line No." := rAbsence.ValidateLastLineNoWEB;
                            rAbsence.ValidateWEB;

                            if not rAbsence.Insert then
                                rAbsence.Modify;

                            txtSQLBegin := Text0009;
                            txtSQLEnd := '';
                            txtSeparador := ', ';

                            txtVALUES[1] := StrSubstNo(Text0001, Format(ID_IncidenceStudentLine));
                            txtVALUES[2] := StrSubstNo(Text0001, Format(cInsertWEBGenTable.InsertString(CompanyName)));
                            txtVALUES[3] := StrSubstNo(Text0001, Format(ID_Calendar));
                            txtVALUES[4] := StrSubstNo(Text0001, Format(cInsertWEBGenTable.InsertString(StudentCodeNo)));
                            txtVALUES[5] := StrSubstNo(Text0001, Format(cInsertWEBGenTable.InsertString(SchoolYear)));
                            txtVALUES[6] := StrSubstNo(Text0001, Format(cInsertWEBGenTable.InsertString(SchoolingYear)));
                            txtVALUES[7] := StrSubstNo(Text0001, Format(Type));
                            txtVALUES[8] := StrSubstNo(Text0001, Format(cInsertWEBGenTable.InsertString(SubType)));
                            txtVALUES[9] := StrSubstNo(Text0001, Format(cInsertWEBGenTable.InsertString(IncidenceCode)));
                            txtVALUES[10] := StrSubstNo(Text0001, Format(cInsertWEBGenTable.InsertString(JustificationCode)));
                            txtVALUES[11] := StrSubstNo(Text0001, Format(0));
                            txtVALUES[12] := StrSubstNo(Text0001, Format(IncidenceType));

                            // Statement que irá permitir incluir cada linha da tabela Navision para a tabela SQL
                            autConnection.Execute(txtSQLBegin +
                            txtVALUES[1] + txtSeparador +
                            txtVALUES[2] + txtSeparador +
                            txtVALUES[3] + txtSeparador +
                            txtVALUES[4] + txtSeparador +
                            txtVALUES[5] + txtSeparador +
                            txtVALUES[6] + txtSeparador +
                            txtVALUES[7] + txtSeparador +
                            txtVALUES[8] + txtSeparador +
                            txtVALUES[9] + txtSeparador +
                            txtVALUES[10] + txtSeparador +
                            txtVALUES[11] + txtSeparador +
                            txtVALUES[12] +
                            txtSQLEnd);

                        end;
                    end else begin
                        if rWebCalendar.Get(ID_Calendar) then begin
                            rCalendar.Reset;
                            rCalendar.SetCurrentKey(rCalendar."Web ID");
                            rCalendar.SetRange("Web ID", rWebCalendar.ID);
                            if rCalendar.FindFirst then;

                            rAbsence.Reset;
                            rAbsence.SetRange("Timetable Code", rWebCalendar."Timetable Code");
                            rAbsence.SetRange("School Year", rWebCalendar."School Year");
                            rAbsence.SetRange("Study Plan", rWebCalendar."Study Plan");
                            rAbsence.SetRange(Class, rWebCalendar.Class);
                            rAbsence.SetRange(Type, rWebCalendar.Type);
                            rAbsence.SetRange("Line No. Timetable", rCalendar."Line No.");
                            rAbsence.SetRange("Student/Teacher", rAbsence."Student/Teacher"::Student);
                            rAbsence.SetRange("Student/Teacher Code No.", StudentCodeNo);
                            rAbsence.SetRange("Responsibility Center", rCalendar."Responsibility Center");
                            rAbsence.SetRange(Subject, rWebCalendar.Subject);
                            rAbsence.SetRange("Absence Type", rCalendar."Absence Type");
                            rAbsence.SetRange("Sub-Subject Code", rWebCalendar."Sub-Subject Code");
                            rAbsence.SetRange(Turn, rWebCalendar.Turn);
                            rAbsence.SetRange("Schooling Year", rWebCalendar."Schooling Year");
                            rAbsence.SetRange("Type Subject", rCalendar."Type Subject");
                            rAbsence.SetFilter(Day, Date);
                            rAbsence.SetRange("Justified Code", JustificationCode);
                            rAbsence.SetFilter("Incidence Type", IncidenceType);
                            rAbsence.SetRange("Incidence Code", IncidenceCode);
                            rAbsence.SetFilter(Category, Type);
                            rAbsence.SetRange("Subcategory Code", SubType);
                            if rAbsence.FindFirst then
                                rAbsence.Delete;

                            rWEBAbsence.Reset;
                            rWEBAbsence.SetRange("Timetable Code", rWebCalendar."Timetable Code");
                            rWEBAbsence.SetRange("School Year", rWebCalendar."School Year");
                            rWEBAbsence.SetRange("Study Plan", rWebCalendar."Study Plan");
                            rWEBAbsence.SetRange(Class, rWebCalendar.Class);
                            rWEBAbsence.SetRange(Type, rWebCalendar.Type);
                            rWEBAbsence.SetRange("Line No. Timetable", rCalendar."Line No.");
                            rWEBAbsence.SetRange("Student/Teacher", rWEBAbsence."Student/Teacher"::Student);
                            rWEBAbsence.SetRange("Student/Teacher Code No.", StudentCodeNo);
                            rWEBAbsence.SetRange("Responsibility Center", rCalendar."Responsibility Center");
                            rWEBAbsence.SetRange(Subject, rWebCalendar.Subject);
                            rWEBAbsence.SetRange("Absence Type", rCalendar."Absence Type");
                            rWEBAbsence.SetRange("Sub-Subject Code", rWebCalendar."Sub-Subject Code");
                            rWEBAbsence.SetRange(Turn, rWebCalendar.Turn);
                            rWEBAbsence.SetRange("Schooling Year", rWebCalendar."Schooling Year");
                            rWEBAbsence.SetRange("Type Subject", rCalendar."Type Subject");
                            rWEBAbsence.SetFilter(Day, Date);
                            rWEBAbsence.SetRange("Justified Code", JustificationCode);
                            rWEBAbsence.SetFilter("Incidence Type", IncidenceType);
                            rWEBAbsence.SetRange("Incidence Code", IncidenceCode);
                            rWEBAbsence.SetFilter(Category, Type);
                            rWEBAbsence.SetRange("Subcategory Code", SubType);
                            if rWEBAbsence.FindFirst then
                                rWEBAbsence.Delete;

                            txtSQLBegin := Text0012;
                            txtSQLEnd := '';
                            txtSeparador := ', ';

                            txtVALUES[1] := StrSubstNo(Text0001, Format(cInsertWEBGenTable.InsertString(CompanyName)));
                            txtVALUES[2] := StrSubstNo(Text0001, Format(ID_Calendar));
                            txtVALUES[3] := StrSubstNo(Text0001, Format(cInsertWEBGenTable.InsertString(StudentCodeNo)));
                            txtVALUES[4] := StrSubstNo(Text0001, Format(cInsertWEBGenTable.InsertString(SchoolYear)));
                            txtVALUES[5] := StrSubstNo(Text0001, Format(cInsertWEBGenTable.InsertString(SchoolingYear)));
                            txtVALUES[6] := StrSubstNo(Text0001, Format(Type));
                            txtVALUES[7] := StrSubstNo(Text0001, Format(cInsertWEBGenTable.InsertString(SubType)));
                            txtVALUES[8] := StrSubstNo(Text0001, Format(cInsertWEBGenTable.InsertString(IncidenceCode)));
                            txtVALUES[9] := StrSubstNo(Text0001, Format(IncidenceType));
                            txtVALUES[10] := StrSubstNo(Text0001, Format(ID_IncidenceStudentLine));

                            // Statement que irá permitir incluir cada linha da tabela Navision para a tabela SQL
                            autConnection.Execute(txtSQLBegin +
                            txtVALUES[1] + txtSeparador +
                            txtVALUES[2] + txtSeparador +
                            txtVALUES[3] + txtSeparador +
                            txtVALUES[4] + txtSeparador +
                            txtVALUES[5] + txtSeparador +
                            txtVALUES[6] + txtSeparador +
                            txtVALUES[7] + txtSeparador +
                            txtVALUES[8] + txtSeparador +
                            txtVALUES[9] + txtSeparador +
                            txtVALUES[10] +
                            txtSQLEnd);

                        end;
                    end;

                    autRecSet.MoveNext;
                until autRecSet.EOF;
            end;
        end;

        //[Scope('OnPrem')]
        procedure WEBtoNAVIncidencesDaily()
        var
            Text0001: Label '''%1''';
            Text0002: Label 'SELECT * from dbo.[view_temp_IncidenceStudent]';
            Text0003: Label ' Where Company = ''%1''';
            autConnection: Automation;
            autRecSet: Automation;
            rGeneralTableAspects: Record GeneralTableAspects;
            rCompanyInfo: Record "Company Information";
            AssessementConfiguration: Record "Assessment Configuration";
            rClass: Record Class;
            rGeneralTable: Record GeneralTable;
            rWebCalendar: Record "Web Calendar";
            rCalendar: Record Calendar;
            cInsertWEBGenTable: Codeunit InsertWEBGenTable;
            rAbsence: Record Absence;
            rWEBAbsence: Record "WEB Absence";
            txtSQL: Text[1024];
            optUpdateType: Option " ",Insert,Update,Delete;
            intCount: Integer;
            intActiveMoment: Integer;
            txtSQLBegin: Text[1024];
            txtSQLEnd: Text[1024];
            txtSeparador: Text[30];
            txtVALUES: array[30] of Text[1024];
            Text0004: Label 'There is nothing to import.';
            i: Integer;
            k: Integer;
            SubjectCals: Decimal;
            SUMPounder: Decimal;
            SubSubjectValue: Decimal;
            Text0009: Label 'EXEC sp_temp_InsertUpdate_IncidenceStudent';
            ID_IncidenceStudentLine: Text[30];
            ID_Calendar: Integer;
            StudentCodeNo: Text[30];
            SchoolYear: Text[30];
            SchoolingYear: Text[30];
            Type: Text[30];
            SubType: Text[30];
            IncidenceCode: Text[30];
            JustificationCode: Text[30];
            Text0010: Label 'SELECT * from dbo.[view_temp_IncidenceDailyStudent]';
            Text0011: Label 'EXEC sp_temp_InsertUpdate_IncidenceDailyStudent';
            Class: Text[30];
            Date: Text[30];
            IncidenceType: Text[30];
            IsDeleted: Boolean;
            Text0012: Label 'EXEC sp_temp_Delete_IncidenceStudent';
            Text0013: Label 'EXEC sp_temp_Delete_IncidenceDailyStudent';
        begin
            rCompanyInfo.Get;
            case rCompanyInfo."Connection Type" of
                rCompanyInfo."Connection Type"::" ":
                    exit;
                rCompanyInfo."Connection Type"::"1 Connection":
                    i := 1;
                rCompanyInfo."Connection Type"::"2 Connection":
                    i := 2;
            end;

            for k := 1 to i do begin

                // Feita a Ligação ao SQL através da funcão CREATEDBConnection
                Clear(autConnection);
                cInsertWEBMasterTable.CreateDBConnection(autConnection, k);

                // Espaço para inserir qualquer tipo de filtragem

                // Criado o apontador para a tabela de sql. Este apontador irá nos ajudar a percorrer as linhas da tabela.
                Clear(autRecSet);
                Create(autRecSet, false, true);

                // Declaração da statement que nos porporcionará posicionar-mos na linha que pretendemos obter informação.
                txtSQL := Text0010 + Text0003;
                txtSQL := StrSubstNo(txtSQL, CompanyName, 1);

                // Neste momento apontamos o apontador para a tabela, enviando a statement criada em cima.
                autRecSet.Open(txtSQL, autConnection, 1, 1);

                // Verificação de que se o apontador chegou ao fim da tabela SQL, terminando o dataitem do report
                if autRecSet.EOF then begin
                    exit;
                end;

                intCount := 1;
                repeat
                    if intCount = 1 then
                        autRecSet.MoveFirst;
                    SubjectCals := 0;
                    SUMPounder := 0;
                    intCount := intCount + 1;


                    ID_IncidenceStudentLine := autRecSet.Fields.Item('ID_IncidenceStudentLine').Value;
                    StudentCodeNo := autRecSet.Fields.Item('StudentNo').Value;
                    Date := autRecSet.Fields.Item('Date').Value;
                    SchoolYear := autRecSet.Fields.Item('SchoolYear').Value;
                    SchoolingYear := autRecSet.Fields.Item('SchoolingYear').Value;
                    Type := autRecSet.Fields.Item('Type').Value;
                    SubType := autRecSet.Fields.Item('SubType').Value;
                    IncidenceCode := autRecSet.Fields.Item('IncidenceCode').Value;
                    Class := autRecSet.Fields.Item('Class').Value;
                    IncidenceType := autRecSet.Fields.Item('IncidenceType').Value;
                    IsDeleted := autRecSet.Fields.Item('isDeleted').Value;
                    if not IsDeleted then begin

                        rWebCalendar.Reset;
                        rWebCalendar.SetRange(Class, Class);
                        rWebCalendar.SetRange("School Year", SchoolYear);
                        rWebCalendar.SetRange("Schooling Year", SchoolingYear);
                        rWebCalendar.SetFilter("Filter Period", Date);
                        if rWebCalendar.FindSet then begin
                            rCalendar.Reset;
                            rCalendar.SetCurrentKey(rCalendar."Web ID");
                            rCalendar.SetRange("Web ID", rWebCalendar.ID);
                            if rCalendar.FindFirst then;

                            rAbsence.Init;
                            rAbsence."Timetable Code" := rWebCalendar."Timetable Code";
                            rAbsence."School Year" := rWebCalendar."School Year";
                            rAbsence."Study Plan" := rWebCalendar."Study Plan";
                            rAbsence.Class := rWebCalendar.Class;
                            rAbsence.Type := rWebCalendar.Type;
                            rAbsence."Line No. Timetable" := rCalendar."Line No.";
                            rAbsence."Student/Teacher" := rAbsence."Student/Teacher"::Student;
                            rAbsence.Validate("Student/Teacher Code No.", StudentCodeNo);
                            rAbsence."Responsibility Center" := rCalendar."Responsibility Center";
                            rAbsence.Subject := rWebCalendar.Subject;
                            rAbsence."Absence Type" := rCalendar."Absence Type";
                            rAbsence."Sub-Subject Code" := rWebCalendar."Sub-Subject Code";
                            rAbsence.Turn := rWebCalendar.Turn;
                            rAbsence."Schooling Year" := rWebCalendar."Schooling Year";
                            rAbsence."Type Subject" := rCalendar."Type Subject";
                            rAbsence.Day := rCalendar."Filter Period";
                            rAbsence."Justified Code" := JustificationCode;
                            Evaluate(rAbsence."Incidence Type", IncidenceType);
                            rAbsence."Incidence Code" := IncidenceCode;
                            Evaluate(rAbsence.Category, Type);
                            rAbsence."Subcategory Code" := SubType;
                            if rAbsence."Incidence Type" = rAbsence."Incidence Type"::Default then
                                rAbsence."Absence Status" := rAbsence."Absence Status"::Justified;
                            if rAbsence."Incidence Type" = rAbsence."Incidence Type"::Absence then
                                rAbsence."Absence Status" := rAbsence."Absence Status"::Unjustified;
                            if (rAbsence."Incidence Type" = rAbsence."Incidence Type"::Absence) and
                              (rAbsence."Justified Code" <> '') then
                                rAbsence."Absence Status" := rAbsence."Absence Status"::Justification;
                            rAbsence."Line No." := rAbsence.ValidateLastLineNoWEB;
                            rAbsence.ValidateWEB;

                            if not rAbsence.Insert then
                                rAbsence.Modify;


                            //Insert grades by store
                            txtSQLBegin := Text0011;
                            txtSQLEnd := '';
                            txtSeparador := ', ';

                            txtVALUES[1] := StrSubstNo(Text0001, Format(ID_IncidenceStudentLine));
                            txtVALUES[2] := StrSubstNo(Text0001, Format(cInsertWEBGenTable.InsertString(CompanyName)));
                            txtVALUES[3] := StrSubstNo(Text0001, Format(Date));
                            txtVALUES[4] := StrSubstNo(Text0001, Format(cInsertWEBGenTable.InsertString(StudentCodeNo)));
                            txtVALUES[5] := StrSubstNo(Text0001, Format(cInsertWEBGenTable.InsertString(SchoolYear)));
                            txtVALUES[6] := StrSubstNo(Text0001, Format(cInsertWEBGenTable.InsertString(SchoolingYear)));
                            txtVALUES[7] := StrSubstNo(Text0001, Format(Type));
                            txtVALUES[8] := StrSubstNo(Text0001, Format(cInsertWEBGenTable.InsertString(SubType)));
                            txtVALUES[9] := StrSubstNo(Text0001, Format(cInsertWEBGenTable.InsertString(IncidenceCode)));
                            txtVALUES[10] := StrSubstNo(Text0001, Format(JustificationCode));
                            txtVALUES[11] := StrSubstNo(Text0001, Format(Class));
                            //txtVALUES[12] := STRSUBSTNO(Text0001,FORMAT(0));
                            txtVALUES[13] := StrSubstNo(Text0001, Format(IncidenceType));
                            txtVALUES[14] := StrSubstNo(Text0001, Format(0));

                            // Statement que irá permitir incluir cada linha da tabela Navision para a tabela SQL
                            autConnection.Execute(txtSQLBegin +
                            txtVALUES[1] + txtSeparador +
                            txtVALUES[2] + txtSeparador +
                            txtVALUES[3] + txtSeparador +
                            txtVALUES[4] + txtSeparador +
                            txtVALUES[5] + txtSeparador +
                            txtVALUES[6] + txtSeparador +
                            txtVALUES[7] + txtSeparador +
                            txtVALUES[8] + txtSeparador +
                            txtVALUES[9] + txtSeparador +
                            txtVALUES[10] + txtSeparador +
                            txtVALUES[11] + txtSeparador +
                            //txtVALUES[12] + txtSeparador +
                            txtVALUES[13] + txtSeparador +
                            txtVALUES[14] +
                            txtSQLEnd);
                        end;
                    end else begin

                        rWebCalendar.Reset;
                        rWebCalendar.SetRange(Class, Class);
                        rWebCalendar.SetRange("School Year", SchoolYear);
                        rWebCalendar.SetRange("Schooling Year", SchoolingYear);
                        rWebCalendar.SetFilter("Filter Period", Date);
                        if rWebCalendar.FindSet then begin
                            rCalendar.Reset;
                            rCalendar.SetCurrentKey(rCalendar."Web ID");
                            rCalendar.SetRange("Web ID", rWebCalendar.ID);
                            if rCalendar.FindFirst then;

                            rAbsence.Reset;
                            rAbsence.SetRange("Timetable Code", rWebCalendar."Timetable Code");
                            rAbsence.SetRange("School Year", rWebCalendar."School Year");
                            rAbsence.SetRange("Study Plan", rWebCalendar."Study Plan");
                            rAbsence.SetRange(Class, rWebCalendar.Class);
                            rAbsence.SetRange(Type, rWebCalendar.Type);
                            rAbsence.SetRange("Line No. Timetable", rCalendar."Line No.");
                            rAbsence.SetRange("Student/Teacher", rAbsence."Student/Teacher"::Student);
                            rAbsence.SetRange("Student/Teacher Code No.", StudentCodeNo);
                            rAbsence.SetRange("Responsibility Center", rCalendar."Responsibility Center");
                            rAbsence.SetRange(Subject, rWebCalendar.Subject);
                            rAbsence.SetRange("Absence Type", rCalendar."Absence Type");
                            rAbsence.SetRange("Sub-Subject Code", rWebCalendar."Sub-Subject Code");
                            rAbsence.SetRange(Turn, rWebCalendar.Turn);
                            rAbsence.SetRange("Schooling Year", rWebCalendar."Schooling Year");
                            rAbsence.SetRange("Type Subject", rCalendar."Type Subject");
                            rAbsence.SetFilter(Day, Date);
                            rAbsence.SetFilter("Incidence Type", IncidenceType);
                            rAbsence.SetRange("Incidence Code", IncidenceCode);
                            rAbsence.SetFilter(Category, Type);
                            rAbsence.DeleteAll;

                            rWEBAbsence.Reset;
                            rWEBAbsence.SetRange("Timetable Code", rWebCalendar."Timetable Code");
                            rWEBAbsence.SetRange("School Year", rWebCalendar."School Year");
                            rWEBAbsence.SetRange("Study Plan", rWebCalendar."Study Plan");
                            rWEBAbsence.SetRange(Class, rWebCalendar.Class);
                            rWEBAbsence.SetRange(Type, rWebCalendar.Type);
                            rWEBAbsence.SetRange("Line No. Timetable", rCalendar."Line No.");
                            rWEBAbsence.SetRange("Student/Teacher", rWEBAbsence."Student/Teacher"::Student);
                            rWEBAbsence.SetRange("Student/Teacher Code No.", StudentCodeNo);
                            rWEBAbsence.SetRange("Responsibility Center", rCalendar."Responsibility Center");
                            rWEBAbsence.SetRange(Subject, rWebCalendar.Subject);
                            rWEBAbsence.SetRange("Absence Type", rCalendar."Absence Type");
                            rWEBAbsence.SetRange("Sub-Subject Code", rWebCalendar."Sub-Subject Code");
                            rWEBAbsence.SetRange(Turn, rWebCalendar.Turn);
                            rWEBAbsence.SetRange("Schooling Year", rWebCalendar."Schooling Year");
                            rWEBAbsence.SetRange("Type Subject", rCalendar."Type Subject");
                            rWEBAbsence.SetFilter(Day, Date);
                            rWEBAbsence.SetFilter("Incidence Type", IncidenceType);
                            rWEBAbsence.SetRange("Incidence Code", IncidenceCode);
                            rWEBAbsence.SetFilter(Category, Type);
                            rWEBAbsence.DeleteAll;

                            //Insert grades by store
                            txtSQLBegin := Text0013;
                            txtSQLEnd := '';
                            txtSeparador := ', ';

                            txtVALUES[1] := StrSubstNo(Text0001, Format(cInsertWEBGenTable.InsertString(CompanyName)));
                            txtVALUES[2] := StrSubstNo(Text0001, Format(Date));
                            txtVALUES[3] := StrSubstNo(Text0001, Format(cInsertWEBGenTable.InsertString(StudentCodeNo)));
                            txtVALUES[4] := StrSubstNo(Text0001, Format(cInsertWEBGenTable.InsertString(SchoolYear)));
                            txtVALUES[5] := StrSubstNo(Text0001, Format(cInsertWEBGenTable.InsertString(SchoolingYear)));
                            txtVALUES[6] := StrSubstNo(Text0001, Format(Type));
                            txtVALUES[7] := StrSubstNo(Text0001, Format(cInsertWEBGenTable.InsertString(SubType)));
                            txtVALUES[8] := StrSubstNo(Text0001, Format(cInsertWEBGenTable.InsertString(IncidenceCode)));
                            txtVALUES[9] := StrSubstNo(Text0001, Format(Class));
                            txtVALUES[10] := StrSubstNo(Text0001, Format(IncidenceType));
                            txtVALUES[11] := StrSubstNo(Text0001, Format(ID_IncidenceStudentLine));

                            // Statement que irá permitir incluir cada linha da tabela Navision para a tabela SQL
                            autConnection.Execute(txtSQLBegin +
                            txtVALUES[1] + txtSeparador +
                            txtVALUES[2] + txtSeparador +
                            txtVALUES[3] + txtSeparador +
                            txtVALUES[4] + txtSeparador +
                            txtVALUES[5] + txtSeparador +
                            txtVALUES[6] + txtSeparador +
                            txtVALUES[7] + txtSeparador +
                            txtVALUES[8] + txtSeparador +
                            txtVALUES[9] + txtSeparador +
                            txtVALUES[10] + txtSeparador +
                            txtVALUES[11] +
                            txtSQLEnd);
                        end;
                    end;

                    autRecSet.MoveNext;
                until autRecSet.EOF;
            end;
        end;

        //[Scope('OnPrem')]
        procedure WEBtoNAVClassObservation()
        var
            Text0001: Label '''%1''';
            Text0002: Label 'SELECT * from dbo.[_CommentTextClass]';
            Text0003: Label ' Where IsChanged = ''%1'' and Company = ''%2''';
            autConnection: Automation;
            autRecSet: Automation;
            rGeneralTableAspects: Record GeneralTableAspects;
            lGeneralTable: Record GeneralTable;
            rCompanyInfo: Record "Company Information";
            rClass: Record Class;
            rRemarks: Record Remarks;
            rWEBRemarks: Record "WEB Remarks";
            txtSQL: Text[1024];
            optUpdateType: Option " ",Insert,Update,Delete;
            intCount: Integer;
            intActiveMoment: Integer;
            txtSQLBegin: Text[1024];
            txtSQLEnd: Text[1024];
            txtSeparador: Text[30];
            txtVALUES: array[30] of Text[1024];
            Text0004: Label 'There is nothing to import.';
            i: Integer;
            k: Integer;
            SubjectCals: Decimal;
            SUMPounder: Decimal;
            SubSubjectValue: Decimal;
            Text0005: Label 'EXEC GEWEB_Insert_ObservationMomentChanged';
            Text0006: Label ' Where Student = ''%1'' and SchoolYear = ''%2'' and Classw = ''%3'' and Moment = ''%4'' and OrderNum = ''%5'' and Company = ''%6''';
            tSchoolYear: Text[30];
            tClass: Text[30];
            tStudent: Text[30];
            tOrderNo: Integer;
            tMoment: Text[30];
            LastLineNo: Integer;
            Text0007: Label 'SELECT * from dbo.[view_temp_CommentTickClass]';
            Text0008: Label ' Where Company = ''%1''';
            Text0009: Label 'EXEC GEWEB_Insert_ObservationTickClassChanged';
            tSchoolingYear: Text[30];
            tObserGroup: Text[30];
            LastStudent: Text[30];
        begin
            rCompanyInfo.Get;
            case rCompanyInfo."Connection Type" of
                rCompanyInfo."Connection Type"::" ":
                    exit;
                rCompanyInfo."Connection Type"::"1 Connection":
                    i := 1;
                rCompanyInfo."Connection Type"::"2 Connection":
                    i := 2;
            end;

            for k := 1 to i do begin

                // Feita a Ligação ao SQL através da funcão CREATEDBConnection
                Clear(autConnection);
                cInsertWEBMasterTable.CreateDBConnection(autConnection, k);

                // Espaço para inserir qualquer tipo de filtragem

                // Criado o apontador para a tabela de sql. Este apontador irá nos ajudar a percorrer as linhas da tabela.
                Clear(autRecSet);
                Create(autRecSet, false, true);

                // Declaração da statement que nos porporcionará posicionar-mos na linha que pretendemos obter informação.
                txtSQL := Text0002 + Text0003;
                txtSQL := StrSubstNo(txtSQL, 1, CompanyName);

                // Neste momento apontamos o apontador para a tabela, enviando a statement criada em cima.
                autRecSet.Open(txtSQL, autConnection, 1, 1);

                // Verificação de que se o apontador chegou ao fim da tabela SQL, terminando o dataitem do report
                if autRecSet.EOF then begin
                    exit;
                end;

                intCount := 1;
                repeat
                    if intCount = 1 then
                        autRecSet.MoveFirst;
                    SubjectCals := 0;
                    SUMPounder := 0;

                    tSchoolYear := autRecSet.Fields.Item('SchoolYear').Value;
                    tStudent := autRecSet.Fields.Item('Student').Value;
                    tClass := autRecSet.Fields.Item('Classw').Value;
                    tMoment := autRecSet.Fields.Item('Moment').Value;
                    tOrderNo := autRecSet.Fields.Item('OrderNum').Value;

                    if LastStudent <> tStudent then begin
                        rRemarks.LockTable(true);
                        rRemarks.Reset;
                        rRemarks.SetRange("Type Remark", rRemarks."Type Remark"::Assessment);
                        rRemarks.SetRange(Class, tClass);
                        rRemarks.SetRange("School Year", tSchoolYear);
                        rRemarks.SetFilter(Subject, '');
                        rRemarks.SetFilter("Sub-subject", '');
                        rRemarks.SetRange("Student/Teacher Code No.", tStudent);
                        rRemarks.SetRange("Moment Code", tMoment);
                        //rRemarks.SETRANGE("Line No.",tOrderNo);
                        rRemarks.SetRange("Original Line No.", 0);
                        rRemarks.SetRange("Type Remark", rRemarks."Type Remark"::Assessment);
                        if rRemarks.Find('-') then
                            rRemarks.DeleteAll(true);

                        rWEBRemarks.Reset;
                        rWEBRemarks.SetRange(Class, tClass);
                        rWEBRemarks.SetRange("School Year", tSchoolYear);
                        rWEBRemarks.SetFilter(Subject, '');
                        rWEBRemarks.SetFilter("Sub-subject", '');
                        rWEBRemarks.SetRange("Student/Teacher Code No.", tStudent);
                        rWEBRemarks.SetRange("Moment Code", tMoment);
                        rWEBRemarks.SetRange("Type Remark", rWEBRemarks."Type Remark"::Assessment);
                        //rWEBRemarks.SETRANGE("Line No.",tOrderNo);
                        rWEBRemarks.SetRange("Original Line No.", 0);
                        if rWEBRemarks.Find('-') then
                            rWEBRemarks.DeleteAll(true);
                    end;
                    LastStudent := tStudent;


                    //Filter the table for de student remarks
                    //if the line exist change the text of the line
                    rRemarks.Reset;
                    rRemarks.SetRange("Type Remark", rRemarks."Type Remark"::Assessment);
                    rRemarks.SetRange(Class, tClass);
                    rRemarks.SetRange("School Year", tSchoolYear);
                    rRemarks.SetFilter(Subject, '');
                    rRemarks.SetFilter("Sub-subject", '');
                    rRemarks.SetRange("Student/Teacher Code No.", tStudent);
                    rRemarks.SetRange("Moment Code", tMoment);
                    rRemarks.SetRange("Original Line No.", 0);
                    rRemarks.SetRange("Type Remark", rRemarks."Type Remark"::Assessment);
                    if not rRemarks.Find('-') then begin
                        //rRemarks.RESET;
                        //IF NOT rRemarks.FIND('+') THEN
                        //   LastLineNo := 0
                        //ELSE
                        //  LastLineNo := rRemarks."Entry No.";
                        if rClass.Get(tClass, tSchoolYear) then;
                        Clear(rRemarks);
                        rRemarks.Init;
                        //rRemarks."Entry No." := LastLineNo + 1;
                        rRemarks.Class := tClass;
                        rRemarks."School Year" := tSchoolYear;
                        rRemarks."Schooling Year" := rClass."Schooling Year";
                        rRemarks.Subject := '';
                        rRemarks."Sub-subject" := '';
                        rRemarks."Study Plan Code" := rClass."Study Plan Code";
                        rRemarks."Student/Teacher Code No." := tStudent;
                        rRemarks."Class No." := 0;
                        rRemarks."Moment Code" := tMoment;
                        rRemarks."Line No." := tOrderNo;
                        rRemarks.Textline := autRecSet.Fields.Item('Comment').Value;
                        rRemarks.Seperator := rRemarks.Seperator::"Carriage Return";
                        rRemarks."Responsibility Center" := rClass."Responsibility Center";
                        rRemarks."Type Education" := rClass.Type;
                        rRemarks."Original Line No." := 0;
                        rRemarks."Type Remark" := rRemarks."Type Remark"::Assessment;
                        rRemarks.Day := 0D;
                        rRemarks."Calendar Line" := 0;
                        rRemarks.Insert(true);
                        rRemarks.Modify(true);
                    end else begin
                        rRemarks.Textline := autRecSet.Fields.Item('Comment').Value;
                        rRemarks.Modify(true);
                    end;

                    intCount := intCount + 1;


                    //Change the status of the line in the database

                    txtSQLBegin := Text0005;
                    txtSQLEnd := '';
                    txtSeparador := ', ';

                    txtVALUES[1] := StrSubstNo(Text0001, Format(CompanyName));
                    txtVALUES[2] := StrSubstNo(Text0001, Format(tClass));
                    txtVALUES[3] := StrSubstNo(Text0001, Format(tMoment));
                    txtVALUES[4] := StrSubstNo(Text0001, Format(tStudent));
                    txtVALUES[5] := StrSubstNo(Text0001, Format(tOrderNo));
                    txtVALUES[6] := StrSubstNo(Text0001, Format(cInsertWEBMasterTable.InsertString(rRemarks.Textline)));
                    txtVALUES[7] := StrSubstNo(Text0001, Format(tSchoolYear));
                    txtVALUES[8] := StrSubstNo(Text0001, Format('0'));

                    // Statement que irá permitir incluir cada linha da tabela Navision para a tabela SQL
                    autConnection.Execute(txtSQLBegin +
                    txtVALUES[1] + txtSeparador +
                    txtVALUES[2] + txtSeparador +
                    txtVALUES[3] + txtSeparador +
                    txtVALUES[4] + txtSeparador +
                    txtVALUES[5] + txtSeparador +
                    txtVALUES[6] + txtSeparador +
                    txtVALUES[7] + txtSeparador +
                    txtVALUES[8] +
                    txtSQLEnd);

                    //
                    autRecSet.MoveNext;
                until autRecSet.EOF;

                // Feita a Ligação ao SQL através da funcão CREATEDBConnection
                Clear(autConnection);
                cInsertWEBMasterTable.CreateDBConnection(autConnection, k);

                // Espaço para inserir qualquer tipo de filtragem

                // Criado o apontador para a tabela de sql. Este apontador irá nos ajudar a percorrer as linhas da tabela.
                Clear(autRecSet);
                Create(autRecSet, false, true);

                // Declaração da statement que nos porporcionará posicionar-mos na linha que pretendemos obter informação.
                txtSQL := Text0007 + Text0008;
                txtSQL := StrSubstNo(txtSQL, CompanyName);

                // Neste momento apontamos o apontador para a tabela, enviando a statement criada em cima.
                autRecSet.Open(txtSQL, autConnection, 1, 1);

                // Verificação de que se o apontador chegou ao fim da tabela SQL, terminando o dataitem do report
                if autRecSet.EOF then begin
                    exit;
                end;

                intCount := 1;
                repeat
                    if intCount = 1 then
                        autRecSet.MoveFirst;
                    SubjectCals := 0;
                    SUMPounder := 0;

                    tSchoolYear := autRecSet.Fields.Item('SchoolYear').Value;
                    tStudent := autRecSet.Fields.Item('Student').Value;
                    tClass := autRecSet.Fields.Item('Classw').Value;
                    tMoment := autRecSet.Fields.Item('Moment').Value;
                    tOrderNo := autRecSet.Fields.Item('LineNoW').Value;

                    rRemarks.Reset;
                    rRemarks.SetRange("Type Remark", rRemarks."Type Remark"::Assessment);
                    rRemarks.SetRange(Class, tClass);
                    rRemarks.SetRange("School Year", tSchoolYear);
                    rRemarks.SetFilter(Subject, '');
                    rRemarks.SetFilter("Sub-subject", '');
                    rRemarks.SetRange("Student/Teacher Code No.", tStudent);
                    rRemarks.SetRange("Moment Code", tMoment);
                    rRemarks.SetRange("Line No.", tOrderNo);
                    if rRemarks.Find('-') then
                        rRemarks.DeleteAll(true);

                    //Filter the table for de student remarks
                    //if the line exist change the text of the line
                    rRemarks.Reset;
                    rRemarks.SetRange("Type Remark", rRemarks."Type Remark"::Assessment);
                    rRemarks.SetRange(Class, tClass);
                    rRemarks.SetRange("School Year", tSchoolYear);
                    rRemarks.SetFilter(Subject, '');
                    rRemarks.SetFilter("Sub-subject", '');
                    rRemarks.SetRange("Student/Teacher Code No.", tStudent);
                    rRemarks.SetRange("Moment Code", tMoment);
                    rRemarks.SetRange("Line No.", tOrderNo);
                    if not rRemarks.Find('-') then begin
                        //rRemarks.RESET;
                        //IF NOT rRemarks.FIND('+') THEN
                        //   LastLineNo := 0
                        //ELSE
                        //  LastLineNo := rRemarks."Entry No.";
                        if rClass.Get(tClass, tSchoolYear) then;

                        Clear(rRemarks);
                        rRemarks.Init;
                        //rRemarks."Entry No." := LastLineNo + 1;
                        rRemarks.Class := tClass;
                        rRemarks."School Year" := tSchoolYear;
                        rRemarks."Schooling Year" := rClass."Schooling Year";
                        rRemarks.Subject := '';
                        rRemarks."Sub-subject" := '';
                        rRemarks."Study Plan Code" := rClass."Study Plan Code";
                        rRemarks."Student/Teacher Code No." := tStudent;
                        rRemarks."Class No." := 0;
                        rRemarks."Moment Code" := tMoment;
                        rRemarks."Line No." := tOrderNo;
                        rRemarks.Textline := autRecSet.Fields.Item('Comment').Value;
                        rRemarks.Seperator := rRemarks.Seperator::"Carriage Return";
                        rRemarks."Responsibility Center" := rClass."Responsibility Center";
                        rRemarks."Type Education" := rClass.Type;
                        rRemarks."Original Line No." := tOrderNo;
                        rRemarks."Type Remark" := rRemarks."Type Remark"::Assessment;
                        rRemarks.Day := 0D;
                        rRemarks."Calendar Line" := 0;
                        rRemarks.Insert(true);
                        rRemarks.Modify(true);
                    end else begin
                        rRemarks.Textline := autRecSet.Fields.Item('Comment').Value;
                        rRemarks.Modify(true);
                    end;

                    intCount := intCount + 1;

                    tSchoolingYear := rClass."Schooling Year";
                    tObserGroup := '';

                    //Change the status of the line in the database

                    txtSQLBegin := Text0009;
                    txtSQLEnd := '';
                    txtSeparador := ', ';

                    txtVALUES[1] := StrSubstNo(Text0001, Format(CompanyName));
                    txtVALUES[2] := StrSubstNo(Text0001, Format(tClass));
                    txtVALUES[3] := StrSubstNo(Text0001, Format(tMoment));
                    txtVALUES[4] := StrSubstNo(Text0001, Format(tStudent));
                    txtVALUES[5] := StrSubstNo(Text0001, Format(tSchoolingYear));
                    txtVALUES[6] := StrSubstNo(Text0001, Format(tSchoolYear));
                    txtVALUES[7] := StrSubstNo(Text0001, Format(tObserGroup));
                    txtVALUES[8] := StrSubstNo(Text0001, Format(tOrderNo));
                    txtVALUES[9] := StrSubstNo(Text0001, Format(cInsertWEBMasterTable.InsertString(rRemarks.Textline)));
                    txtVALUES[10] := StrSubstNo(Text0001, Format('0'));

                    // Statement que irá permitir incluir cada linha da tabela Navision para a tabela SQL
                    autConnection.Execute(txtSQLBegin +
                    txtVALUES[1] + txtSeparador +
                    txtVALUES[2] + txtSeparador +
                    txtVALUES[3] + txtSeparador +
                    txtVALUES[4] + txtSeparador +
                    txtVALUES[5] + txtSeparador +
                    txtVALUES[6] + txtSeparador +
                    txtVALUES[7] + txtSeparador +
                    txtVALUES[8] + txtSeparador +
                    txtVALUES[9] + txtSeparador +
                    txtVALUES[10] +
                    txtSQLEnd);

                    autRecSet.MoveNext;
                until autRecSet.EOF;

            end;
        end;

        //[Scope('OnPrem')]
        procedure WEBtoNAVSubjObservation()
        var
            Text0001: Label '''%1''';
            Text0002: Label 'SELECT * from dbo.[_CommentText]';
            Text0003: Label ' Where IsChanged = ''%1'' and Company = ''%2''';
            autConnection: Automation;
            autRecSet: Automation;
            rGeneralTableAspects: Record GeneralTableAspects;
            rGeneralTable: Record GeneralTable;
            rCompanyInfo: Record "Company Information";
            rClass: Record Class;
            rRemarks: Record Remarks;
            rWEBRemarks: Record "WEB Remarks";
            txtSQL: Text[1024];
            optUpdateType: Option " ",Insert,Update,Delete;
            intCount: Integer;
            intActiveMoment: Integer;
            txtSQLBegin: Text[1024];
            txtSQLEnd: Text[1024];
            txtSeparador: Text[30];
            txtVALUES: array[30] of Text[1024];
            Text0004: Label 'There is nothing to import.';
            i: Integer;
            k: Integer;
            SubjectCals: Decimal;
            SUMPounder: Decimal;
            SubSubjectValue: Decimal;
            Text0005: Label 'UPDATE dbo.[_CommentText] SET ';
            Text0006: Label ' Where ID_CommentText = ''%1''';
            tSchoolYear: Text[30];
            tClass: Text[30];
            tStudent: Text[30];
            tOrderNo: Integer;
            tMoment: Text[30];
            tSubject: Text[30];
            tSubSubject: Text[30];
            LastLineNo: Integer;
            Text0007: Label 'SELECT * from dbo.[_CommentTick]';
            lEntryNo: Integer;
            intIDComment: Integer;
            Text0008: Label 'UPDATE dbo.[_CommentTick] SET ';
            Text0009: Label 'SELECT * from dbo.[_CommentTick]';
            LineNoW: Integer;
            Text0010: Label 'UPDATE dbo.[_CommentTick] SET ';
            Text0011: Label ' Where ID_CommentTick = ''%1''';
        begin
            rCompanyInfo.Get;
            case rCompanyInfo."Connection Type" of
                rCompanyInfo."Connection Type"::" ":
                    exit;
                rCompanyInfo."Connection Type"::"1 Connection":
                    i := 1;
                rCompanyInfo."Connection Type"::"2 Connection":
                    i := 2;
            end;

            for k := 1 to i do begin

                // Feita a Ligação ao SQL através da funcão CREATEDBConnection
                Clear(autConnection);
                cInsertWEBMasterTable.CreateDBConnection(autConnection, k);

                // Espaço para inserir qualquer tipo de filtragem

                // Criado o apontador para a tabela de sql. Este apontador irá nos ajudar a percorrer as linhas da tabela.
                Clear(autRecSet);
                Create(autRecSet, false, true);

                // Declaração da statement que nos porporcionará posicionar-mos na linha que pretendemos obter informação.
                txtSQL := Text0002 + Text0003;
                txtSQL := StrSubstNo(txtSQL, 1, CompanyName);

                // Neste momento apontamos o apontador para a tabela, enviando a statement criada em cima.
                autRecSet.Open(txtSQL, autConnection, 1, 1);

                // Verificação de que se o apontador chegou ao fim da tabela SQL, terminando o dataitem do report
                if autRecSet.EOF then begin
                    exit;
                end;

                intCount := 1;
                repeat
                    if intCount = 1 then
                        autRecSet.MoveFirst;
                    SubjectCals := 0;
                    SUMPounder := 0;

                    lEntryNo := autRecSet.Fields.Item('EntryNo').Value;

                    rRemarks.LockTable(true);
                    if rGeneralTable.Get(lEntryNo) then begin
                        if (tClass <> rGeneralTable.Class) or
                          (tSchoolYear <> rGeneralTable."School Year") or
                          (tStudent <> rGeneralTable.Student) or
                          (tMoment <> rGeneralTable.Moment) or
                          (tSubject <> rGeneralTable.Subject) or
                          (tSubSubject <> rGeneralTable."Sub Subject") then begin
                            rRemarks.Reset;
                            rRemarks.SetRange(Class, rGeneralTable.Class);
                            rRemarks.SetRange("School Year", rGeneralTable."School Year");
                            rRemarks.SetFilter(Subject, rGeneralTable.Subject);
                            if rGeneralTable."Is SubSubject" = false then
                                rRemarks.SetFilter("Sub-subject", '')
                            else
                                rRemarks.SetFilter("Sub-subject", rGeneralTable."Sub Subject");
                            rRemarks.SetRange("Student/Teacher Code No.", rGeneralTable.Student);
                            rRemarks.SetRange("Moment Code", rGeneralTable.Moment);
                            rRemarks.SetRange("Type Remark", rRemarks."Type Remark"::Assessment);
                            //rRemarks.SETRANGE("Original Line No.",0);
                            if rRemarks.Find('-') then
                                rRemarks.DeleteAll(true);

                            rWEBRemarks.Reset;
                            rWEBRemarks.SetRange(Class, rGeneralTable.Class);
                            rWEBRemarks.SetRange("School Year", rGeneralTable."School Year");
                            rWEBRemarks.SetFilter(Subject, rGeneralTable.Subject);
                            if rGeneralTable."Is SubSubject" = false then
                                rWEBRemarks.SetFilter("Sub-subject", '')
                            else
                                rWEBRemarks.SetFilter("Sub-subject", rGeneralTable."Sub Subject");
                            rWEBRemarks.SetRange("Student/Teacher Code No.", rGeneralTable.Student);
                            rWEBRemarks.SetRange("Moment Code", rGeneralTable.Moment);
                            rWEBRemarks.SetRange("Type Remark", rWEBRemarks."Type Remark"::Assessment);
                            //rRemarks.SETRANGE("Original Line No.",0);
                            if rWEBRemarks.Find('-') then
                                rWEBRemarks.DeleteAll(true);

                        end;

                        tClass := rGeneralTable.Class;
                        tSchoolYear := rGeneralTable."School Year";
                        tStudent := rGeneralTable.Student;
                        tMoment := rGeneralTable.Moment;
                        tSubject := rGeneralTable.Subject;
                        tSubSubject := rGeneralTable."Sub Subject";

                        tOrderNo := autRecSet.Fields.Item('OrderNum').Value;

                        //Filter the table for de student remarks
                        //if the line exist change the text of the line
                        rRemarks.Reset;
                        rRemarks.SetRange(Class, tClass);
                        rRemarks.SetRange("School Year", tSchoolYear);
                        rRemarks.SetFilter(Subject, tSubject);
                        if rGeneralTable."Is SubSubject" = false then
                            rRemarks.SetFilter("Sub-subject", '')
                        else
                            rRemarks.SetFilter("Sub-subject", tSubSubject);
                        rRemarks.SetRange("Student/Teacher Code No.", tStudent);
                        rRemarks.SetRange("Moment Code", tMoment);
                        rRemarks.SetRange("Line No.", tOrderNo);
                        rRemarks.SetRange("Type Remark", rRemarks."Type Remark"::Assessment);
                        if not rRemarks.Find('-') then begin
                            //rRemarks.RESET;
                            //IF NOT rRemarks.FIND('+') THEN
                            //   LastLineNo := 0
                            //ELSE
                            //  LastLineNo := rRemarks."Entry No.";
                            if rClass.Get(tClass, tSchoolYear) then;

                            Clear(rRemarks);
                            rRemarks.Init;
                            //rRemarks."Entry No." := LastLineNo + 1;
                            rRemarks.Class := tClass;
                            rRemarks."School Year" := tSchoolYear;
                            rRemarks."Schooling Year" := rClass."Schooling Year";
                            rRemarks.Subject := tSubject;
                            if rGeneralTable."Is SubSubject" = false then
                                rRemarks."Sub-subject" := ''
                            else
                                rRemarks."Sub-subject" := tSubSubject;
                            rRemarks."Study Plan Code" := rClass."Study Plan Code";
                            rRemarks."Student/Teacher Code No." := tStudent;
                            rRemarks."Class No." := 0;
                            rRemarks."Moment Code" := tMoment;
                            rRemarks."Line No." := tOrderNo;
                            rRemarks.Textline := autRecSet.Fields.Item('Comment').Value;
                            rRemarks.Seperator := rRemarks.Seperator::"Carriage Return";
                            rRemarks."Responsibility Center" := rClass."Responsibility Center";
                            rRemarks."Type Education" := rClass.Type;
                            rRemarks."Original Line No." := 0;
                            rRemarks."Type Remark" := rRemarks."Type Remark"::Assessment;
                            rRemarks.Day := 0D;
                            rRemarks."Calendar Line" := 0;
                            rRemarks.Insert(true);
                            rRemarks.Modify(true);
                        end else begin
                            rRemarks.Textline := autRecSet.Fields.Item('Comment').Value;
                            rRemarks.Modify(true);
                        end;
                    end;
                    intCount := intCount + 1;

                    //Change the status of the line in the database
                    intIDComment := autRecSet.Fields.Item('ID_CommentText').Value;

                    txtSQLBegin := Text0005;
                    txtSQLEnd := Text0006;
                    txtSQLEnd := StrSubstNo(txtSQLEnd,
                                               intIDComment);

                    txtVALUES[1] := 'IsChanged = ' + StrSubstNo(Text0001, '0');
                    autConnection.Execute(txtSQLBegin +
                    txtVALUES[1] + txtSQLEnd);
                    //
                    autRecSet.MoveNext;
                until autRecSet.EOF;

                // Feita a Ligação ao SQL através da funcão CREATEDBConnection
                Clear(autConnection);
                cInsertWEBMasterTable.CreateDBConnection(autConnection, k);

                // Espaço para inserir qualquer tipo de filtragem

                // Criado o apontador para a tabela de sql. Este apontador irá nos ajudar a percorrer as linhas da tabela.
                Clear(autRecSet);
                Create(autRecSet, false, true);

                // Declaração da statement que nos porporcionará posicionar-mos na linha que pretendemos obter informação.
                txtSQL := Text0009 + Text0003;
                txtSQL := StrSubstNo(txtSQL, 1, CompanyName);

                // Neste momento apontamos o apontador para a tabela, enviando a statement criada em cima.
                autRecSet.Open(txtSQL, autConnection, 1, 1);

                // Verificação de que se o apontador chegou ao fim da tabela SQL, terminando o dataitem do report
                if autRecSet.EOF then begin
                    exit;
                end;

                intCount := 1;
                repeat
                    if intCount = 1 then
                        autRecSet.MoveFirst;
                    SubjectCals := 0;
                    SUMPounder := 0;

                    lEntryNo := autRecSet.Fields.Item('EntryNo').Value;

                    rRemarks.LockTable(true);
                    if rGeneralTable.Get(lEntryNo) then begin
                        /*IF (tClass <> rGeneralTable.Class) OR
                          (tSchoolYear <> rGeneralTable."School Year") OR
                          (tStudent <> rGeneralTable.Student) OR
                          (tMoment <> rGeneralTable.Moment) OR
                          (tSubject <> rGeneralTable.Subject) OR
                          (tSubSubject <> rGeneralTable."Sub Subject") THEN BEGIN
                          rRemarks.RESET;
                          rRemarks.SETRANGE(Class,rGeneralTable.Class);
                          rRemarks.SETRANGE("School Year",rGeneralTable."School Year");
                          rRemarks.SETFILTER(Subject,rGeneralTable.Subject);
                          IF rGeneralTable."Is SubSubject" = FALSE THEN
                            rRemarks.SETFILTER("Sub-subject",'')
                          ELSE
                            rRemarks.SETFILTER("Sub-subject",rGeneralTable."Sub Subject");
                          rRemarks.SETRANGE("Student/Teacher Code No.",rGeneralTable.Student);
                          rRemarks.SETRANGE("Moment Code",rGeneralTable.Moment);
                          rRemarks.SETRANGE("Type Remark",rRemarks."Type Remark"::Assessment);
                          rRemarks.SETFILTER("Original Line No.",'<>%1',0);
                          IF rRemarks.FIND('-') THEN
                            rRemarks.DELETEALL(TRUE);
                        END;
                         *//*
                        tClass := rGeneralTable.Class;
                        tSchoolYear := rGeneralTable."School Year";
                        tStudent := rGeneralTable.Student;
                        tMoment := rGeneralTable.Moment;
                        tSubject := rGeneralTable.Subject;
                        tSubSubject := rGeneralTable."Sub Subject";

                        tOrderNo := autRecSet.Fields.Item('EntryNo').Value;
                        LineNoW := autRecSet.Fields.Item('LineNoW').Value;

                        //Filter the table for de student remarks
                        //if the line exist change the text of the line
                        rRemarks.Reset;
                        rRemarks.SetRange(Class, tClass);
                        rRemarks.SetRange("School Year", tSchoolYear);
                        rRemarks.SetFilter(Subject, tSubject);
                        if rGeneralTable."Is SubSubject" = false then
                            rRemarks.SetFilter("Sub-subject", '')
                        else
                            rRemarks.SetFilter("Sub-subject", tSubSubject);
                        rRemarks.SetRange("Student/Teacher Code No.", tStudent);
                        rRemarks.SetRange("Moment Code", tMoment);
                        rRemarks.SetRange("Line No.", tOrderNo);
                        rRemarks.SetRange("Original Line No.", LineNoW);
                        rRemarks.SetRange("Type Remark", rRemarks."Type Remark"::Assessment);
                        if not rRemarks.Find('-') then begin
                            //rRemarks.RESET;
                            //IF NOT rRemarks.FIND('+') THEN
                            //   LastLineNo := 0
                            //ELSE
                            //  LastLineNo := rRemarks."Entry No.";
                            if rClass.Get(tClass, tSchoolYear) then;

                            Clear(rRemarks);
                            rRemarks.Init;
                            //rRemarks."Entry No." := LastLineNo + 1;
                            rRemarks.Class := tClass;
                            rRemarks."School Year" := tSchoolYear;
                            rRemarks."Schooling Year" := rClass."Schooling Year";
                            rRemarks.Subject := tSubject;
                            if rGeneralTable."Is SubSubject" = false then
                                rRemarks."Sub-subject" := ''
                            else
                                rRemarks."Sub-subject" := tSubSubject;
                            rRemarks."Study Plan Code" := rClass."Study Plan Code";
                            rRemarks."Student/Teacher Code No." := tStudent;
                            rRemarks."Class No." := 0;
                            rRemarks."Moment Code" := tMoment;
                            rRemarks."Line No." := tOrderNo;
                            rRemarks.Textline := autRecSet.Fields.Item('Comment').Value;
                            rRemarks.Seperator := rRemarks.Seperator::"Carriage Return";
                            rRemarks."Responsibility Center" := rClass."Responsibility Center";
                            rRemarks."Type Education" := rClass.Type;
                            rRemarks."Original Line No." := LineNoW;
                            rRemarks."Type Remark" := rRemarks."Type Remark"::Assessment;
                            rRemarks.Day := 0D;
                            rRemarks."Calendar Line" := 0;
                            rRemarks.Insert(true);
                            rRemarks.Modify(true);
                        end else begin
                            rRemarks.Textline := autRecSet.Fields.Item('Comment').Value;
                            rRemarks.Modify(true);
                        end;
                    end;
                    intCount := intCount + 1;

                    //Change the status of the line in the database
                    intIDComment := autRecSet.Fields.Item('ID_CommentTick').Value;

                    txtSQLBegin := Text0010;
                    txtSQLEnd := Text0011;
                    txtSQLEnd := StrSubstNo(txtSQLEnd,
                                               intIDComment);

                    txtVALUES[1] := 'IsChanged = ' + StrSubstNo(Text0001, '0');
                    autConnection.Execute(txtSQLBegin +
                    txtVALUES[1] + txtSQLEnd);
                    //
                    autRecSet.MoveNext;
                until autRecSet.EOF;

            end;

        end;

        //[Scope('OnPrem')]
        procedure WEBtoNAVIncidenceObservation1()
        var
            Text0001: Label '''%1''';
            Text0002: Label 'SELECT * from dbo.[view_temp_IncidenceDailyStudent_ObsTick]';
            Text0003: Label ' Where Company = ''%1''';
            autConnection: Automation;
            autRecSet: Automation;
            rGeneralTableAspects: Record GeneralTableAspects;
            rGeneralTable: Record GeneralTable;
            rCompanyInfo: Record "Company Information";
            rClass: Record Class;
            rRemarks: Record Remarks;
            rWEBRemarks: Record "WEB Remarks";
            rRegistrationSubjects: Record "Registration Subjects";
            rWebCalendar: Record "Web Calendar";
            rAbsence: Record Absence;
            InsertWEB_MasterTable: Codeunit InsertWEB_MasterTable;
            txtSQL: Text[1024];
            optUpdateType: Option " ",Insert,Update,Delete;
            intCount: Integer;
            intActiveMoment: Integer;
            txtSQLBegin: Text[1024];
            txtSQLEnd: Text[1024];
            txtSeparador: Text[30];
            txtVALUES: array[30] of Text[1024];
            Text0004: Label 'There is nothing to import.';
            i: Integer;
            k: Integer;
            SubjectCals: Decimal;
            SUMPounder: Decimal;
            SubSubjectValue: Decimal;
            Text0005: Label 'EXEC sp_temp_Insert_IncidenceDailyStudent_ObsTick';
            Text0006: Label ' Where ID_CommentText = ''%1''';
            tDate: Text[30];
            tSchoolYear: Text[30];
            tSchoolingYear: Text[30];
            tType: Integer;
            tSubType: Text[30];
            tIncidenceCode: Text[30];
            tClass: Text[30];
            tStudent: Text[30];
            tMoment: Text[30];
            tSubject: Text[30];
            tSubSubject: Text[30];
            TObservationCode: Text[30];
            LastLineNo: Integer;
            lEntryNo: Integer;
            intIDComment: Integer;
            tOrderNo: Integer;
            Text0007: Label 'SELECT * from dbo.[view_temp_IncidenceStudent_ObsTick]';
            Text0008: Label 'EXEC GEWEB_InsertUpdate_IncidenceStudentsObsTick_Changed';
            tID_Calendar: Integer;
            Text0009: Label 'SELECT * from dbo.[view_temp_IncidenceStudent_ObsText]';
            Text0010: Label 'EXEC GEWEB_InsertUpdate_IncidenceStudentsObsText_Changed';
            tLastID_Calendar: Integer;
            Text0011: Label 'SELECT * from dbo.[view_temp_IncidenceDailyStudent_ObsText]';
            Text0012: Label 'EXEC sp_temp_Insert_IncidenceDailyStudent_ObsText';
            tLastStudent: Text[30];
            tLastDate: Text[30];
            tIncidenceType: Integer;
        begin
            rCompanyInfo.Get;
            case rCompanyInfo."Connection Type" of
                rCompanyInfo."Connection Type"::" ":
                    exit;
                rCompanyInfo."Connection Type"::"1 Connection":
                    i := 1;
                rCompanyInfo."Connection Type"::"2 Connection":
                    i := 2;
            end;

            for k := 1 to i do begin

                // Feita a Ligação ao SQL através da funcão CREATEDBConnection
                Clear(autConnection);
                InsertWEB_MasterTable.CreateDBConnection(autConnection, k);

                // Espaço para inserir qualquer tipo de filtragem

                // Criado o apontador para a tabela de sql. Este apontador irá nos ajudar a percorrer as linhas da tabela.
                Clear(autRecSet);
                Create(autRecSet, false, true);

                // Declaração da statement que nos porporcionará posicionar-mos na linha que pretendemos obter informação.
                //**** sp_temp_Insert_IncidenceDailyStudent_ObsTick ****
                txtSQL := Text0002 + Text0003;
                txtSQL := StrSubstNo(txtSQL, CompanyName);

                // Neste momento apontamos o apontador para a tabela, enviando a statement criada em cima.
                autRecSet.Open(txtSQL, autConnection, 1, 1);

                // Verificação de que se o apontador chegou ao fim da tabela SQL, terminando o dataitem do report
                if autRecSet.EOF then begin
                    exit;
                end;

                intCount := 1;
                repeat
                    if intCount = 1 then
                        autRecSet.MoveFirst;
                    SubjectCals := 0;
                    SUMPounder := 0;

                    tDate := autRecSet.Fields.Item('Date').Value;
                    tStudent := autRecSet.Fields.Item('StudentNo').Value;
                    tSchoolYear := autRecSet.Fields.Item('SchoolYear').Value;
                    tSchoolingYear := autRecSet.Fields.Item('SchoolingYear').Value;
                    tType := autRecSet.Fields.Item('Type').Value;
                    tSubType := autRecSet.Fields.Item('SubType').Value;
                    tIncidenceCode := autRecSet.Fields.Item('IncidenceCode').Value;
                    tClass := autRecSet.Fields.Item('Class').Value;
                    tOrderNo := autRecSet.Fields.Item('ObservationLine').Value;
                    tIncidenceType := autRecSet.Fields.Item('IncidenceType ').Value;

                    rRegistrationSubjects.Reset;
                    rRegistrationSubjects.SetRange("Student Code No.", tStudent);
                    rRegistrationSubjects.SetRange("School Year", tSchoolYear);
                    rRegistrationSubjects.SetRange("Schooling Year", tSchoolingYear);
                    rRegistrationSubjects.SetRange(Status, rRegistrationSubjects.Status::Subscribed);
                    if rRegistrationSubjects.FindFirst then begin
                        rWebCalendar.Reset;
                        rWebCalendar.SetRange("School Year", tSchoolYear);
                        rWebCalendar.SetRange("Schooling Year", tSchoolingYear);
                        rWebCalendar.SetRange(Class, tClass);
                        rWebCalendar.SetFilter("Filter Period", tDate);
                        if rWebCalendar.FindSet then begin

                            rRemarks.Reset;
                            rRemarks.SetRange(Class, tClass);
                            rRemarks.SetRange("School Year", tSchoolYear);
                            rRemarks.SetFilter(Subject, rWebCalendar.Subject);
                            rRemarks.SetFilter("Sub-subject", rWebCalendar."Sub-Subject Code");
                            rRemarks.SetRange("Student/Teacher Code No.", tStudent);
                            rRemarks.SetFilter(Day, tDate);
                            rRemarks.SetRange("Study Plan Code", rRegistrationSubjects."Study Plan Code");
                            rRemarks.SetRange("Type Education", rRegistrationSubjects.Type);
                            rRemarks.SetRange("Type Remark", rRemarks."Type Remark"::Absence);
                            rRemarks.SetRange("Original Line No.", tOrderNo);
                            rRemarks.SetRange("Calendar Line", rWebCalendar."Line No.");
                            rRemarks.DeleteAll(true);

                            rWEBRemarks.Reset;
                            rWEBRemarks.SetRange(Class, tClass);
                            rWEBRemarks.SetRange("School Year", tSchoolYear);
                            rWEBRemarks.SetFilter(Subject, rWebCalendar.Subject);
                            rWEBRemarks.SetFilter("Sub-subject", rWebCalendar."Sub-Subject Code");
                            rWEBRemarks.SetRange("Student/Teacher Code No.", tStudent);
                            rWEBRemarks.SetFilter(Day, tDate);
                            rWEBRemarks.SetRange("Study Plan Code", rRegistrationSubjects."Study Plan Code");
                            rWEBRemarks.SetRange("Type Education", rRegistrationSubjects.Type);
                            rWEBRemarks.SetRange("Type Remark", rWEBRemarks."Type Remark"::Absence);
                            rWEBRemarks.SetRange("Original Line No.", lEntryNo);
                            rWEBRemarks.SetRange("Calendar Line", rWebCalendar."Line No.");
                            rWEBRemarks.DeleteAll(true);

                            //Filter the table for de student remarks
                            //if the line exist change the text of the line
                            rRemarks.Reset;
                            rRemarks.SetRange(Class, tClass);
                            rRemarks.SetRange("School Year", tSchoolYear);
                            rRemarks.SetFilter(Subject, rWebCalendar.Subject);
                            rRemarks.SetFilter("Sub-subject", rWebCalendar."Sub-Subject Code");
                            rRemarks.SetRange("Student/Teacher Code No.", tStudent);
                            rRemarks.SetFilter(Day, tDate);
                            rRemarks.SetRange("Study Plan Code", rRegistrationSubjects."Study Plan Code");
                            rRemarks.SetRange("Type Education", rRegistrationSubjects.Type);
                            rRemarks.SetRange("Type Remark", rRemarks."Type Remark"::Absence);
                            rRemarks.SetRange("Original Line No.", tOrderNo);
                            rRemarks.SetRange("Calendar Line", rWebCalendar."Line No.");
                            if not rRemarks.Find('-') then begin
                                if rClass.Get(tClass, tSchoolYear) then;

                                rAbsence.Reset;
                                rAbsence.SetRange(Class, rRegistrationSubjects.Class);
                                rAbsence.SetRange("School Year", tSchoolYear);
                                rAbsence.SetRange(Subject, rWebCalendar.Subject);
                                rAbsence.SetRange("Sub-Subject Code", rWebCalendar."Sub-Subject Code");
                                rAbsence.SetRange("Student/Teacher Code No.", tStudent);
                                rAbsence.SetRange(Day, rWebCalendar."Filter Period");
                                rAbsence.SetRange("Study Plan", rRegistrationSubjects."Study Plan Code");
                                rAbsence.SetRange(Type, rRegistrationSubjects.Type);
                                rAbsence.SetRange("Absence Type", tIncidenceType);
                                rAbsence.SetRange("Incidence Code", tIncidenceCode);
                                rAbsence.SetRange(Category, tType);
                                rAbsence.SetRange("Subcategory Code", tSubType);
                                if rAbsence.FindFirst then;

                                Clear(rRemarks);
                                rRemarks.Init;
                                rRemarks.Class := tClass;
                                rRemarks."School Year" := tSchoolYear;
                                rRemarks."Schooling Year" := rClass."Schooling Year";
                                rRemarks.Subject := rWebCalendar.Subject;
                                rRemarks."Sub-subject" := rWebCalendar."Sub-Subject Code";
                                rRemarks."Study Plan Code" := rClass."Study Plan Code";
                                rRemarks."Student/Teacher Code No." := tStudent;
                                rRemarks."Class No." := 0;
                                rRemarks."Moment Code" := '';
                                rRemarks."Line No." := rAbsence."Line No.";
                                rRemarks.Textline := autRecSet.Fields.Item('Observation').Value;
                                rRemarks.Seperator := rRemarks.Seperator::"Carriage Return";
                                rRemarks."Responsibility Center" := rClass."Responsibility Center";
                                rRemarks."Type Education" := rClass.Type;
                                rRemarks."Original Line No." := tOrderNo;
                                rRemarks."Type Remark" := rRemarks."Type Remark"::Absence;
                                Evaluate(rRemarks.Day, tDate);
                                rRemarks."Calendar Line" := rWebCalendar."Line No.";
                                rRemarks."Incidence Type" := tIncidenceType;
                                rRemarks.GetTickText;
                                rRemarks.Insert(true);

                            end else begin
                                rRemarks.Textline := autRecSet.Fields.Item('Observation').Value;
                                rRemarks.Modify(true);
                            end;
                            intCount := intCount + 1;

                            //Change the status of the line in the database
                            intIDComment := autRecSet.Fields.Item('').Value;

                            txtSQLBegin := Text0005;
                            txtSQLEnd := '';
                            txtSeparador := ', ';

                            txtVALUES[1] := StrSubstNo(Text0001, Format(CompanyName));
                            txtVALUES[2] := StrSubstNo(Text0001, Format(tDate));
                            txtVALUES[3] := StrSubstNo(Text0001, Format(tStudent));
                            txtVALUES[4] := StrSubstNo(Text0001, Format(tSchoolYear));
                            txtVALUES[5] := StrSubstNo(Text0001, Format(tSchoolingYear));
                            txtVALUES[6] := StrSubstNo(Text0001, Format(tType));
                            txtVALUES[7] := StrSubstNo(Text0001, Format(tSubType));
                            txtVALUES[8] := StrSubstNo(Text0001, Format(tIncidenceCode));
                            txtVALUES[9] := StrSubstNo(Text0001, Format(tClass));
                            txtVALUES[10] := StrSubstNo(Text0001, Format(InsertWEB_MasterTable.InsertString(rRemarks.Textline)));
                            txtVALUES[11] := StrSubstNo(Text0001, Format(tOrderNo));

                            // Statement que irá permitir incluir cada linha da tabela Navision para a tabela SQL
                            autConnection.Execute(txtSQLBegin +
                            txtVALUES[1] + txtSeparador +
                            txtVALUES[2] + txtSeparador +
                            txtVALUES[3] + txtSeparador +
                            txtVALUES[4] + txtSeparador +
                            txtVALUES[5] + txtSeparador +
                            txtVALUES[6] + txtSeparador +
                            txtVALUES[7] + txtSeparador +
                            txtVALUES[8] + txtSeparador +
                            txtVALUES[9] + txtSeparador +
                            txtVALUES[10] + txtSeparador +
                            txtVALUES[11] +
                            txtSQLEnd);

                        end;
                    end;
                    //
                    autRecSet.MoveNext;
                until autRecSet.EOF;
            end;
        end;

        //[Scope('OnPrem')]
        procedure WEBtoNAVIncidenceObservation2()
        var
            Text0001: Label '''%1''';
            Text0002: Label 'SELECT * from dbo.[view_temp_IncidenceDailyStudent_ObsTick]';
            Text0003: Label ' Where Company = ''%1''';
            autConnection: Automation;
            autRecSet: Automation;
            rGeneralTableAspects: Record GeneralTableAspects;
            rGeneralTable: Record GeneralTable;
            rCompanyInfo: Record "Company Information";
            rClass: Record Class;
            rRemarks: Record Remarks;
            rWEBRemarks: Record "WEB Remarks";
            rRegistrationSubjects: Record "Registration Subjects";
            rWebCalendar: Record "Web Calendar";
            rAbsence: Record Absence;
            InsertWEB_MasterTable: Codeunit InsertWEB_MasterTable;
            txtSQL: Text[1024];
            optUpdateType: Option " ",Insert,Update,Delete;
            intCount: Integer;
            intActiveMoment: Integer;
            txtSQLBegin: Text[1024];
            txtSQLEnd: Text[1024];
            txtSeparador: Text[30];
            txtVALUES: array[30] of Text[1024];
            Text0004: Label 'There is nothing to import.';
            i: Integer;
            k: Integer;
            SubjectCals: Decimal;
            SUMPounder: Decimal;
            SubSubjectValue: Decimal;
            Text0005: Label 'EXEC sp_temp_Insert_IncidenceDailyStudent_ObsTick';
            Text0006: Label ' Where ID_CommentText = ''%1''';
            tDate: Text[30];
            tSchoolYear: Text[30];
            tSchoolingYear: Text[30];
            tType: Integer;
            tSubType: Text[30];
            tIncidenceCode: Text[30];
            tClass: Text[30];
            tStudent: Text[30];
            tMoment: Text[30];
            tSubject: Text[30];
            tSubSubject: Text[30];
            TObservationCode: Text[30];
            LastLineNo: Integer;
            lEntryNo: Integer;
            intIDComment: Integer;
            tOrderNo: Integer;
            Text0007: Label 'SELECT * from dbo.[view_temp_IncidenceStudent_ObsTick]';
            Text0008: Label 'EXEC GEWEB_InsertUpdate_IncidenceStudentsObsTick_Changed';
            tID_Calendar: Integer;
            Text0009: Label 'SELECT * from dbo.[view_temp_IncidenceStudent_ObsText]';
            Text0010: Label 'EXEC GEWEB_InsertUpdate_IncidenceStudentsObsText_Changed';
            tLastID_Calendar: Integer;
            Text0011: Label 'SELECT * from dbo.[view_temp_IncidenceDailyStudent_ObsText]';
            Text0012: Label 'EXEC sp_temp_Insert_IncidenceDailyStudent_ObsText';
            tLastStudent: Text[30];
            tLastDate: Text[30];
            tIncidenceType: Integer;
        begin
            rCompanyInfo.Get;
            case rCompanyInfo."Connection Type" of
                rCompanyInfo."Connection Type"::" ":
                    exit;
                rCompanyInfo."Connection Type"::"1 Connection":
                    i := 1;
                rCompanyInfo."Connection Type"::"2 Connection":
                    i := 2;
            end;

            for k := 1 to i do begin

                //*************************************************************************************
                // Feita a Ligação ao SQL através da funcão CREATEDBConnection
                Clear(autConnection);
                InsertWEB_MasterTable.CreateDBConnection(autConnection, k);

                // Espaço para inserir qualquer tipo de filtragem

                // Criado o apontador para a tabela de sql. Este apontador irá nos ajudar a percorrer as linhas da tabela.
                Clear(autRecSet);
                Create(autRecSet, false, true);

                // Declaração da statement que nos porporcionará posicionar-mos na linha que pretendemos obter informação.
                //**** view_temp_IncidenceDailyStudent_ObsText ****
                txtSQL := Text0011 + Text0003;
                txtSQL := StrSubstNo(txtSQL, CompanyName);

                // Neste momento apontamos o apontador para a tabela, enviando a statement criada em cima.
                autRecSet.Open(txtSQL, autConnection, 1, 1);

                // Verificação de que se o apontador chegou ao fim da tabela SQL, terminando o dataitem do report
                if autRecSet.EOF then begin
                    exit;
                end;

                intCount := 1;
                repeat
                    if intCount = 1 then
                        autRecSet.MoveFirst;
                    SubjectCals := 0;
                    SUMPounder := 0;

                    tDate := autRecSet.Fields.Item('Date').Value;
                    tStudent := autRecSet.Fields.Item('StudentNo').Value;
                    tSchoolYear := autRecSet.Fields.Item('SchoolYear').Value;
                    tSchoolingYear := autRecSet.Fields.Item('SchoolingYear').Value;
                    tType := autRecSet.Fields.Item('Type').Value;
                    tSubType := autRecSet.Fields.Item('SubType').Value;
                    tIncidenceCode := autRecSet.Fields.Item('IncidenceCode').Value;
                    tClass := autRecSet.Fields.Item('Class').Value;
                    lEntryNo := autRecSet.Fields.Item('ObservationLine').Value;
                    tIncidenceType := autRecSet.Fields.Item('IncidenceType ').Value;

                    rRegistrationSubjects.Reset;
                    rRegistrationSubjects.SetRange("Student Code No.", tStudent);
                    rRegistrationSubjects.SetRange("School Year", tSchoolYear);
                    rRegistrationSubjects.SetRange("Schooling Year", tSchoolingYear);
                    rRegistrationSubjects.SetRange(Status, rRegistrationSubjects.Status::Subscribed);
                    if rRegistrationSubjects.FindFirst then begin
                        if (tLastStudent <> tStudent) and (tLastDate <> tDate) then begin
                            rWebCalendar.Reset;
                            rWebCalendar.SetRange("School Year", tSchoolYear);
                            rWebCalendar.SetRange("Schooling Year", tSchoolingYear);
                            rWebCalendar.SetRange(Class, tClass);
                            rWebCalendar.SetFilter("Filter Period", tDate);
                            if rWebCalendar.FindSet then begin

                                rRemarks.Reset;
                                rRemarks.SetRange(Class, tClass);
                                rRemarks.SetRange("School Year", tSchoolYear);
                                rRemarks.SetFilter(Subject, rWebCalendar.Subject);
                                rRemarks.SetFilter("Sub-subject", rWebCalendar."Sub-Subject Code");
                                rRemarks.SetRange("Student/Teacher Code No.", tStudent);
                                rRemarks.SetFilter(Day, tDate);
                                rRemarks.SetRange("Study Plan Code", rRegistrationSubjects."Study Plan Code");
                                rRemarks.SetRange("Type Education", rRegistrationSubjects.Type);
                                rRemarks.SetRange("Type Remark", rRemarks."Type Remark"::Absence);
                                rRemarks.SetRange("Calendar Line", rWebCalendar."Line No.");
                                if rRemarks.Find('-') then
                                    rRemarks.DeleteAll(true);

                                rWEBRemarks.Reset;
                                rWEBRemarks.SetRange(Class, tClass);
                                rWEBRemarks.SetRange("School Year", tSchoolYear);
                                rWEBRemarks.SetFilter(Subject, rWebCalendar.Subject);
                                rWEBRemarks.SetFilter("Sub-subject", rWebCalendar."Sub-Subject Code");
                                rWEBRemarks.SetRange("Student/Teacher Code No.", tStudent);
                                rWEBRemarks.SetFilter(Day, tDate);
                                rWEBRemarks.SetRange("Study Plan Code", rRegistrationSubjects."Study Plan Code");
                                rWEBRemarks.SetRange("Type Education", rRegistrationSubjects.Type);
                                rWEBRemarks.SetRange("Type Remark", rWEBRemarks."Type Remark"::Absence);
                                rWEBRemarks.SetRange("Calendar Line", rWebCalendar."Line No.");
                                if rWEBRemarks.Find('-') then
                                    rWEBRemarks.DeleteAll(true);
                            end;
                        end;
                        tLastStudent := tStudent;
                        tLastDate := tDate;

                        //Filter the table for de student remarks
                        //if the line exist change the text of the line
                        rRemarks.Reset;
                        rRemarks.SetRange(Class, tClass);
                        rRemarks.SetRange("School Year", tSchoolYear);
                        rRemarks.SetFilter(Subject, rWebCalendar.Subject);
                        rRemarks.SetFilter("Sub-subject", rWebCalendar."Sub-Subject Code");
                        rRemarks.SetRange("Student/Teacher Code No.", tStudent);
                        rRemarks.SetFilter(Day, tDate);
                        rRemarks.SetRange("Study Plan Code", rRegistrationSubjects."Study Plan Code");
                        rRemarks.SetRange("Type Education", rRegistrationSubjects.Type);
                        rRemarks.SetRange("Type Remark", rRemarks."Type Remark"::Absence);
                        rRemarks.SetRange("Original Line No.", lEntryNo);
                        rRemarks.SetRange("Calendar Line", rWebCalendar."Line No.");
                        if not rRemarks.Find('-') then begin
                            if rClass.Get(tClass, tSchoolYear) then;

                            rAbsence.Reset;
                            rAbsence.SetRange(Class, rRegistrationSubjects.Class);
                            rAbsence.SetRange("School Year", tSchoolYear);
                            rAbsence.SetRange(Subject, rWebCalendar.Subject);
                            rAbsence.SetRange("Sub-Subject Code", rWebCalendar."Sub-Subject Code");
                            rAbsence.SetRange("Student/Teacher Code No.", tStudent);
                            rAbsence.SetRange(Day, rWebCalendar."Filter Period");
                            rAbsence.SetRange("Study Plan", rRegistrationSubjects."Study Plan Code");
                            rAbsence.SetRange(Type, rRegistrationSubjects.Type);
                            rAbsence.SetRange("Absence Type", tIncidenceType);
                            rAbsence.SetRange("Incidence Code", tIncidenceCode);
                            rAbsence.SetRange(Category, tType);
                            rAbsence.SetRange("Subcategory Code", tSubType);
                            if rAbsence.FindFirst then;

                            Clear(rRemarks);
                            rRemarks.Init;
                            rRemarks.Class := tClass;
                            rRemarks."School Year" := tSchoolYear;
                            rRemarks."Schooling Year" := rClass."Schooling Year";
                            rRemarks.Subject := rWebCalendar.Subject;
                            rRemarks."Sub-subject" := rWebCalendar."Sub-Subject Code";
                            rRemarks."Study Plan Code" := rClass."Study Plan Code";
                            rRemarks."Student/Teacher Code No." := tStudent;
                            rRemarks."Class No." := 0;
                            rRemarks."Moment Code" := '';
                            rRemarks."Line No." := rAbsence."Line No.";
                            rRemarks.Textline := autRecSet.Fields.Item('Observation').Value;
                            rRemarks.Seperator := rRemarks.Seperator::"Carriage Return";
                            rRemarks."Responsibility Center" := rClass."Responsibility Center";
                            rRemarks."Type Education" := rClass.Type;
                            rRemarks."Original Line No." := tOrderNo;
                            rRemarks."Type Remark" := rRemarks."Type Remark"::Absence;
                            Evaluate(rRemarks.Day, tDate);
                            rRemarks."Calendar Line" := rWebCalendar."Line No.";
                            rRemarks."Incidence Type" := tIncidenceType;
                            rRemarks.Insert(true);

                        end else begin
                            rRemarks.Textline := autRecSet.Fields.Item('Observation').Value;
                            rRemarks.Modify(true);
                        end;
                        intCount := intCount + 1;

                        //Change the status of the line in the database
                        intIDComment := autRecSet.Fields.Item('').Value;

                        txtSQLBegin := Text0012;
                        txtSQLEnd := '';
                        txtSeparador := ', ';

                        txtVALUES[1] := StrSubstNo(Text0001, Format(CompanyName));
                        txtVALUES[2] := StrSubstNo(Text0001, Format(tDate));
                        txtVALUES[3] := StrSubstNo(Text0001, Format(tStudent));
                        txtVALUES[4] := StrSubstNo(Text0001, Format(tSchoolYear));
                        txtVALUES[5] := StrSubstNo(Text0001, Format(tSchoolingYear));
                        txtVALUES[6] := StrSubstNo(Text0001, Format(tType));
                        txtVALUES[7] := StrSubstNo(Text0001, Format(tSubType));
                        txtVALUES[8] := StrSubstNo(Text0001, Format(tIncidenceCode));
                        txtVALUES[9] := StrSubstNo(Text0001, Format(tClass));
                        txtVALUES[10] := StrSubstNo(Text0001, Format(tOrderNo));
                        txtVALUES[11] := StrSubstNo(Text0001, Format(InsertWEB_MasterTable.InsertString(rRemarks.Textline)));


                        // Statement que irá permitir incluir cada linha da tabela Navision para a tabela SQL
                        autConnection.Execute(txtSQLBegin +
                        txtVALUES[1] + txtSeparador +
                        txtVALUES[2] + txtSeparador +
                        txtVALUES[3] + txtSeparador +
                        txtVALUES[4] + txtSeparador +
                        txtVALUES[5] + txtSeparador +
                        txtVALUES[6] + txtSeparador +
                        txtVALUES[7] + txtSeparador +
                        txtVALUES[8] + txtSeparador +
                        txtVALUES[9] + txtSeparador +
                        txtVALUES[10] + txtSeparador +
                        txtVALUES[11] +
                        txtSQLEnd);

                    end;
                    //
                    autRecSet.MoveNext;
                until autRecSet.EOF;
            end;
        end;

        //[Scope('OnPrem')]
        procedure WEBtoNAVIncidenceObservation3()
        var
            Text0001: Label '''%1''';
            Text0002: Label 'SELECT * from dbo.[view_temp_IncidenceDailyStudent_ObsTick]';
            Text0003: Label ' Where Company = ''%1''';
            autConnection: Automation;
            autRecSet: Automation;
            rGeneralTableAspects: Record GeneralTableAspects;
            rGeneralTable: Record GeneralTable;
            rCompanyInfo: Record "Company Information";
            rClass: Record Class;
            rRemarks: Record Remarks;
            rWEBRemarks: Record "WEB Remarks";
            rRegistrationSubjects: Record "Registration Subjects";
            rWebCalendar: Record "Web Calendar";
            rAbsence: Record Absence;
            InsertWEB_MasterTable: Codeunit InsertWEB_MasterTable;
            txtSQL: Text[1024];
            optUpdateType: Option " ",Insert,Update,Delete;
            intCount: Integer;
            intActiveMoment: Integer;
            txtSQLBegin: Text[1024];
            txtSQLEnd: Text[1024];
            txtSeparador: Text[30];
            txtVALUES: array[30] of Text[1024];
            Text0004: Label 'There is nothing to import.';
            i: Integer;
            k: Integer;
            SubjectCals: Decimal;
            SUMPounder: Decimal;
            SubSubjectValue: Decimal;
            Text0005: Label 'EXEC GEWEB_InsertUpdate_IncidenceStudentsObsTick_Changed';
            Text0006: Label ' Where ID_CommentText = ''%1''';
            tDate: Text[30];
            tSchoolYear: Text[30];
            tSchoolingYear: Text[30];
            tType: Integer;
            tSubType: Text[30];
            tIncidenceCode: Text[30];
            tClass: Text[30];
            tStudent: Text[30];
            tMoment: Text[30];
            tSubject: Text[30];
            tSubSubject: Text[30];
            TObservationCode: Text[30];
            LastLineNo: Integer;
            lEntryNo: Integer;
            intIDComment: Integer;
            tOrderNo: Integer;
            Text0007: Label 'SELECT * from dbo.[view_temp_IncidenceStudent_ObsTick]';
            Text0008: Label 'EXEC GEWEB_InsertUpdate_IncidenceStudentsObsTick_Changed';
            tID_Calendar: Integer;
            Text0009: Label 'SELECT * from dbo.[view_temp_IncidenceStudent_ObsText]';
            Text0010: Label 'EXEC GEWEB_InsertUpdate_IncidenceStudentsObsText_Changed';
            tLastID_Calendar: Integer;
            Text0011: Label 'SELECT * from dbo.[view_temp_IncidenceDailyStudent_ObsText]';
            Text0012: Label 'EXEC sp_temp_Insert_IncidenceDailyStudent_ObsText';
            tLastStudent: Text[30];
            tLastDate: Text[30];
            tIncidenceType: Integer;
        begin
            rCompanyInfo.Get;
            case rCompanyInfo."Connection Type" of
                rCompanyInfo."Connection Type"::" ":
                    exit;
                rCompanyInfo."Connection Type"::"1 Connection":
                    i := 1;
                rCompanyInfo."Connection Type"::"2 Connection":
                    i := 2;
            end;

            for k := 1 to i do begin

                //*************************************************************************************

                // Feita a Ligação ao SQL através da funcão CREATEDBConnection
                Clear(autConnection);
                InsertWEB_MasterTable.CreateDBConnection(autConnection, k);

                // Espaço para inserir qualquer tipo de filtragem

                // Criado o apontador para a tabela de sql. Este apontador irá nos ajudar a percorrer as linhas da tabela.
                Clear(autRecSet);
                Create(autRecSet, false, true);

                // Declaração da statement que nos porporcionará posicionar-mos na linha que pretendemos obter informação.
                //**** GEWEB_InsertUpdate_IncidenceStudentsObsTick_Changed ****
                txtSQL := Text0007 + Text0003;
                txtSQL := StrSubstNo(txtSQL, CompanyName);

                // Neste momento apontamos o apontador para a tabela, enviando a statement criada em cima.
                autRecSet.Open(txtSQL, autConnection, 1, 1);

                // Verificação de que se o apontador chegou ao fim da tabela SQL, terminando o dataitem do report
                if autRecSet.EOF then begin
                    exit;
                end;

                intCount := 1;
                repeat
                    if intCount = 1 then
                        autRecSet.MoveFirst;
                    SubjectCals := 0;
                    SUMPounder := 0;

                    tStudent := autRecSet.Fields.Item('StudentCodeNo').Value;
                    tSchoolYear := autRecSet.Fields.Item('SchoolYear').Value;
                    tSchoolingYear := autRecSet.Fields.Item('SchoolingYear').Value;
                    tType := autRecSet.Fields.Item('Type').Value;
                    tSubType := autRecSet.Fields.Item('SubType').Value;
                    tIncidenceCode := autRecSet.Fields.Item('IncidenceCode').Value;
                    tOrderNo := autRecSet.Fields.Item('ObservationLineNo').Value;
                    tID_Calendar := autRecSet.Fields.Item('ID_Calendar').Value;
                    TObservationCode := autRecSet.Fields.Item('ObservationCode').Value;
                    tIncidenceType := autRecSet.Fields.Item('IncidenceType ').Value;

                    rRegistrationSubjects.Reset;
                    rRegistrationSubjects.SetRange("Student Code No.", tStudent);
                    rRegistrationSubjects.SetRange("School Year", tSchoolYear);
                    rRegistrationSubjects.SetRange("Schooling Year", tSchoolingYear);
                    rRegistrationSubjects.SetRange(Status, rRegistrationSubjects.Status::Subscribed);
                    if rRegistrationSubjects.FindFirst and rWebCalendar.Get(tID_Calendar) then begin


                        rRemarks.Reset;
                        rRemarks.SetRange(Class, rRegistrationSubjects.Class);
                        rRemarks.SetRange("School Year", tSchoolYear);
                        rRemarks.SetFilter(Subject, rWebCalendar.Subject);
                        rRemarks.SetFilter("Sub-subject", rWebCalendar."Sub-Subject Code");
                        rRemarks.SetRange("Student/Teacher Code No.", tStudent);
                        rRemarks.SetRange(Day, rWebCalendar."Filter Period");
                        rRemarks.SetRange("Study Plan Code", rRegistrationSubjects."Study Plan Code");
                        rRemarks.SetRange("Type Education", rRegistrationSubjects.Type);
                        rRemarks.SetRange("Type Remark", rRemarks."Type Remark"::Absence);
                        rRemarks.SetRange("Calendar Line", rWebCalendar."Line No.");
                        rRemarks.SetRange("Original Line No.", tOrderNo);
                        rRemarks.DeleteAll(true);

                        rWEBRemarks.Reset;
                        rWEBRemarks.SetRange(Class, rRegistrationSubjects.Class);
                        rWEBRemarks.SetRange("School Year", tSchoolYear);
                        rWEBRemarks.SetFilter(Subject, rWebCalendar.Subject);
                        rWEBRemarks.SetFilter("Sub-subject", rWebCalendar."Sub-Subject Code");
                        rWEBRemarks.SetRange("Student/Teacher Code No.", tStudent);
                        rWEBRemarks.SetRange(Day, rWebCalendar."Filter Period");
                        rWEBRemarks.SetRange("Study Plan Code", rRegistrationSubjects."Study Plan Code");
                        rWEBRemarks.SetRange("Type Education", rRegistrationSubjects.Type);
                        rWEBRemarks.SetRange("Type Remark", rWEBRemarks."Type Remark"::Absence);
                        rWEBRemarks.SetRange("Calendar Line", rWebCalendar."Line No.");
                        rWEBRemarks.SetRange("Original Line No.", tOrderNo);
                        rWEBRemarks.DeleteAll(true);


                        //Filter the table for de student remarks
                        //if the line exist change the text of the line
                        rRemarks.Reset;
                        rRemarks.SetRange(Class, rRegistrationSubjects.Class);
                        rRemarks.SetRange("School Year", tSchoolYear);
                        rRemarks.SetFilter(Subject, rWebCalendar.Subject);
                        rRemarks.SetFilter("Sub-subject", rWebCalendar."Sub-Subject Code");
                        rRemarks.SetRange("Student/Teacher Code No.", tStudent);
                        rRemarks.SetRange(Day, rWebCalendar."Filter Period");
                        rRemarks.SetRange("Study Plan Code", rRegistrationSubjects."Study Plan Code");
                        rRemarks.SetRange("Type Education", rRegistrationSubjects.Type);
                        rRemarks.SetRange("Type Remark", rRemarks."Type Remark"::Absence);
                        rRemarks.SetRange("Original Line No.", tOrderNo);
                        rRemarks.SetRange("Calendar Line", rWebCalendar."Line No.");
                        if not rRemarks.Find('-') then begin
                            if rClass.Get(rRegistrationSubjects.Class, tSchoolYear) then;

                            rAbsence.Reset;
                            rAbsence.SetRange(Class, rRegistrationSubjects.Class);
                            rAbsence.SetRange("School Year", tSchoolYear);
                            rAbsence.SetRange(Subject, rWebCalendar.Subject);
                            rAbsence.SetRange("Sub-Subject Code", rWebCalendar."Sub-Subject Code");
                            rAbsence.SetRange("Student/Teacher Code No.", tStudent);
                            rAbsence.SetRange(Day, rWebCalendar."Filter Period");
                            rAbsence.SetRange("Study Plan", rRegistrationSubjects."Study Plan Code");
                            rAbsence.SetRange(Type, rRegistrationSubjects.Type);
                            rAbsence.SetRange("Absence Type", tIncidenceType);
                            rAbsence.SetRange("Incidence Code", tIncidenceCode);
                            rAbsence.SetRange(Category, tType);
                            rAbsence.SetRange("Subcategory Code", tSubType);
                            if rAbsence.FindFirst then;


                            Clear(rRemarks);
                            rRemarks.Init;
                            rRemarks.Class := rRegistrationSubjects.Class;
                            rRemarks."School Year" := tSchoolYear;
                            rRemarks."Schooling Year" := rClass."Schooling Year";
                            rRemarks.Subject := rWebCalendar.Subject;
                            rRemarks."Sub-subject" := rWebCalendar."Sub-Subject Code";
                            rRemarks."Study Plan Code" := rClass."Study Plan Code";
                            rRemarks."Student/Teacher Code No." := tStudent;
                            rRemarks."Class No." := 0;
                            rRemarks."Moment Code" := '';
                            rRemarks."Line No." := rAbsence."Line No.";
                            rRemarks.Textline := autRecSet.Fields.Item('Observation').Value;
                            rRemarks.Seperator := rRemarks.Seperator::"Carriage Return";
                            rRemarks."Responsibility Center" := rClass."Responsibility Center";
                            rRemarks."Type Education" := rClass.Type;
                            rRemarks."Original Line No." := tOrderNo;
                            rRemarks."Timetable Code" := rWebCalendar."Timetable Code";
                            rRemarks."Type Remark" := rRemarks."Type Remark"::Absence;
                            rRemarks.Day := rWebCalendar."Filter Period";
                            rRemarks."Calendar Line" := rWebCalendar."Line No.";
                            rRemarks."Incidence Type" := tIncidenceType;
                            rRemarks.GetTickText;
                            rRemarks.Insert(true);

                        end else begin
                            rRemarks.Textline := autRecSet.Fields.Item('Observation').Value;
                            rRemarks.Modify(true);
                        end;
                        intCount := intCount + 1;

                        txtSQLBegin := Text0005;
                        txtSQLEnd := '';
                        txtSeparador := ', ';

                        txtVALUES[1] := StrSubstNo(Text0001, Format(CompanyName));
                        txtVALUES[2] := StrSubstNo(Text0001, Format(tID_Calendar));
                        txtVALUES[3] := StrSubstNo(Text0001, Format(tStudent));
                        txtVALUES[4] := StrSubstNo(Text0001, Format(tSchoolYear));
                        txtVALUES[5] := StrSubstNo(Text0001, Format(tSchoolingYear));
                        txtVALUES[6] := StrSubstNo(Text0001, Format(tIncidenceCode));
                        txtVALUES[7] := StrSubstNo(Text0001, Format(tType));
                        txtVALUES[8] := StrSubstNo(Text0001, Format(tSubType));
                        txtVALUES[9] := StrSubstNo(Text0001, Format(TObservationCode));
                        txtVALUES[10] := StrSubstNo(Text0001, Format(tOrderNo));
                        txtVALUES[11] := StrSubstNo(Text0001, Format(0));
                        txtVALUES[12] := StrSubstNo(Text0001, Format(tIncidenceType));


                        // Statement que irá permitir incluir cada linha da tabela Navision para a tabela SQL
                        autConnection.Execute(txtSQLBegin +
                        txtVALUES[1] + txtSeparador +
                        txtVALUES[2] + txtSeparador +
                        txtVALUES[3] + txtSeparador +
                        txtVALUES[4] + txtSeparador +
                        txtVALUES[5] + txtSeparador +
                        txtVALUES[6] + txtSeparador +
                        txtVALUES[7] + txtSeparador +
                        txtVALUES[8] + txtSeparador +
                        txtVALUES[9] + txtSeparador +
                        txtVALUES[10] + txtSeparador +
                        txtVALUES[11] + txtSeparador +
                        txtVALUES[12] +
                        txtSQLEnd);

                    end;
                    //
                    autRecSet.MoveNext;
                until autRecSet.EOF;
            end;
        end;

        //[Scope('OnPrem')]
        procedure WEBtoNAVIncidenceObservation4()
        var
            Text0001: Label '''%1''';
            Text0002: Label 'SELECT * from dbo.[view_temp_IncidenceDailyStudent_ObsTick]';
            Text0003: Label ' Where Company = ''%1''';
            autConnection: Automation;
            autRecSet: Automation;
            rGeneralTableAspects: Record GeneralTableAspects;
            rGeneralTable: Record GeneralTable;
            rCompanyInfo: Record "Company Information";
            rClass: Record Class;
            rRemarks: Record Remarks;
            rWEBRemarks: Record "WEB Remarks";
            rRegistrationSubjects: Record "Registration Subjects";
            rWebCalendar: Record "Web Calendar";
            rAbsence: Record Absence;
            InsertWEB_MasterTable: Codeunit InsertWEB_MasterTable;
            txtSQL: Text[1024];
            optUpdateType: Option " ",Insert,Update,Delete;
            intCount: Integer;
            intActiveMoment: Integer;
            txtSQLBegin: Text[1024];
            txtSQLEnd: Text[1024];
            txtSeparador: Text[30];
            txtVALUES: array[30] of Text[1024];
            Text0004: Label 'There is nothing to import.';
            i: Integer;
            k: Integer;
            SubjectCals: Decimal;
            SUMPounder: Decimal;
            SubSubjectValue: Decimal;
            Text0005: Label 'EXEC sp_temp_Insert_IncidenceDailyStudent_ObsTick';
            Text0006: Label ' Where ID_CommentText = ''%1''';
            tDate: Text[30];
            tSchoolYear: Text[30];
            tSchoolingYear: Text[30];
            tType: Integer;
            tSubType: Text[30];
            tIncidenceCode: Text[30];
            tClass: Text[30];
            tStudent: Text[30];
            tMoment: Text[30];
            tSubject: Text[30];
            tSubSubject: Text[30];
            TObservationCode: Text[30];
            LastLineNo: Integer;
            lEntryNo: Integer;
            intIDComment: Integer;
            tOrderNo: Integer;
            Text0007: Label 'SELECT * from dbo.[view_temp_IncidenceStudent_ObsTick]';
            Text0008: Label 'EXEC GEWEB_InsertUpdate_IncidenceStudentsObsTick_Changed';
            tID_Calendar: Integer;
            Text0009: Label 'SELECT * from dbo.[view_temp_IncidenceStudent_ObsText]';
            Text0010: Label 'EXEC GEWEB_InsertUpdate_IncidenceStudentsObsText_Changed';
            tLastID_Calendar: Integer;
            Text0011: Label 'SELECT * from dbo.[view_temp_IncidenceDailyStudent_ObsText]';
            Text0012: Label 'EXEC sp_temp_Insert_IncidenceDailyStudent_ObsText';
            tLastStudent: Text[30];
            tLastDate: Text[30];
            tIncidenceType: Integer;
        begin
            rCompanyInfo.Get;
            case rCompanyInfo."Connection Type" of
                rCompanyInfo."Connection Type"::" ":
                    exit;
                rCompanyInfo."Connection Type"::"1 Connection":
                    i := 1;
                rCompanyInfo."Connection Type"::"2 Connection":
                    i := 2;
            end;

            for k := 1 to i do begin

                //*************************************************************************************
                // Feita a Ligação ao SQL através da funcão CREATEDBConnection
                Clear(autConnection);
                InsertWEB_MasterTable.CreateDBConnection(autConnection, k);

                // Espaço para inserir qualquer tipo de filtragem

                // Criado o apontador para a tabela de sql. Este apontador irá nos ajudar a percorrer as linhas da tabela.
                Clear(autRecSet);
                Create(autRecSet, false, true);

                // Declaração da statement que nos porporcionará posicionar-mos na linha que pretendemos obter informação.
                //**** IncidenceStudentsObsText ****
                txtSQL := Text0009 + Text0003;
                txtSQL := StrSubstNo(txtSQL, CompanyName);

                // Neste momento apontamos o apontador para a tabela, enviando a statement criada em cima.
                autRecSet.Open(txtSQL, autConnection, 1, 1);

                // Verificação de que se o apontador chegou ao fim da tabela SQL, terminando o dataitem do report
                if autRecSet.EOF then begin
                    exit;
                end;

                intCount := 1;
                repeat
                    if intCount = 1 then
                        autRecSet.MoveFirst;
                    SubjectCals := 0;
                    SUMPounder := 0;

                    tStudent := autRecSet.Fields.Item('StudentCodeNo').Value;
                    tSchoolYear := autRecSet.Fields.Item('SchoolYear').Value;
                    tSchoolingYear := autRecSet.Fields.Item('SchoolingYear').Value;
                    tType := autRecSet.Fields.Item('Type').Value;
                    tSubType := autRecSet.Fields.Item('SubType').Value;
                    tIncidenceCode := autRecSet.Fields.Item('IncidenceCode').Value;
                    lEntryNo := autRecSet.Fields.Item('ObservationLineNo').Value;
                    tID_Calendar := autRecSet.Fields.Item('ID_Calendar').Value;
                    lEntryNo := autRecSet.Fields.Item('ObservationLineNo').Value;
                    tIncidenceType := autRecSet.Fields.Item('IncidenceType ').Value;

                    rRegistrationSubjects.Reset;
                    rRegistrationSubjects.SetRange("Student Code No.", tStudent);
                    rRegistrationSubjects.SetRange("School Year", tSchoolYear);
                    rRegistrationSubjects.SetRange("Schooling Year", tSchoolingYear);
                    rRegistrationSubjects.SetRange(Status, rRegistrationSubjects.Status::Subscribed);
                    if rRegistrationSubjects.FindFirst and rWebCalendar.Get(tID_Calendar) then begin
                        if tID_Calendar <> tLastID_Calendar then begin
                            rRemarks.Reset;
                            rRemarks.SetRange(Class, rRegistrationSubjects.Class);
                            rRemarks.SetRange("School Year", tSchoolYear);
                            rRemarks.SetFilter(Subject, rWebCalendar.Subject);
                            rRemarks.SetFilter("Sub-subject", rWebCalendar."Sub-Subject Code");
                            rRemarks.SetRange("Student/Teacher Code No.", tStudent);
                            rRemarks.SetRange(Day, rWebCalendar."Filter Period");
                            rRemarks.SetRange("Study Plan Code", rRegistrationSubjects."Study Plan Code");
                            rRemarks.SetRange("Type Education", rRegistrationSubjects.Type);
                            rRemarks.SetRange("Type Remark", rRemarks."Type Remark"::Absence);
                            rRemarks.SetRange("Calendar Line", rWebCalendar."Line No.");
                            rRemarks.DeleteAll(true);

                            rWEBRemarks.Reset;
                            rWEBRemarks.SetRange(Class, rRegistrationSubjects.Class);
                            rWEBRemarks.SetRange("School Year", tSchoolYear);
                            rWEBRemarks.SetFilter(Subject, rWebCalendar.Subject);
                            rWEBRemarks.SetFilter("Sub-subject", rWebCalendar."Sub-Subject Code");
                            rWEBRemarks.SetRange("Student/Teacher Code No.", tStudent);
                            rWEBRemarks.SetRange(Day, rWebCalendar."Filter Period");
                            rWEBRemarks.SetRange("Study Plan Code", rRegistrationSubjects."Study Plan Code");
                            rWEBRemarks.SetRange("Type Education", rRegistrationSubjects.Type);
                            rWEBRemarks.SetRange("Type Remark", rWEBRemarks."Type Remark"::Absence);
                            rRemarks.SetRange("Calendar Line", rWebCalendar."Line No.");
                            rWEBRemarks.DeleteAll(true);
                        end;
                        tLastID_Calendar := tID_Calendar;

                        //Filter the table for de student remarks
                        //if the line exist change the text of the line
                        rRemarks.Reset;
                        rRemarks.SetRange(Class, rRegistrationSubjects.Class);
                        rRemarks.SetRange("School Year", tSchoolYear);
                        rRemarks.SetFilter(Subject, rWebCalendar.Subject);
                        rRemarks.SetFilter("Sub-subject", rWebCalendar."Sub-Subject Code");
                        rRemarks.SetRange("Student/Teacher Code No.", tStudent);
                        rRemarks.SetRange(Day, rWebCalendar."Filter Period");
                        rRemarks.SetRange("Study Plan Code", rRegistrationSubjects."Study Plan Code");
                        rRemarks.SetRange("Type Education", rRegistrationSubjects.Type);
                        rRemarks.SetRange("Type Remark", rRemarks."Type Remark"::Absence);
                        rRemarks.SetRange("Original Line No.", lEntryNo);
                        if not rRemarks.Find('-') then begin
                            if rClass.Get(rRegistrationSubjects.Class, tSchoolYear) then;

                            rAbsence.Reset;
                            rAbsence.SetRange(Class, rRegistrationSubjects.Class);
                            rAbsence.SetRange("School Year", tSchoolYear);
                            rAbsence.SetRange(Subject, rWebCalendar.Subject);
                            rAbsence.SetRange("Sub-Subject Code", rWebCalendar."Sub-Subject Code");
                            rAbsence.SetRange("Student/Teacher Code No.", tStudent);
                            rAbsence.SetRange(Day, rWebCalendar."Filter Period");
                            rAbsence.SetRange("Study Plan", rRegistrationSubjects."Study Plan Code");
                            rAbsence.SetRange(Type, rRegistrationSubjects.Type);
                            rAbsence.SetRange("Absence Type", tIncidenceType);
                            rAbsence.SetRange("Incidence Code", tIncidenceCode);
                            rAbsence.SetRange(Category, tType);
                            rAbsence.SetRange("Subcategory Code", tSubType);
                            if rAbsence.FindFirst then;

                            Clear(rRemarks);
                            rRemarks.Init;
                            rRemarks.Class := rRegistrationSubjects.Class;
                            rRemarks."School Year" := tSchoolYear;
                            rRemarks."Schooling Year" := rClass."Schooling Year";
                            rRemarks.Subject := rWebCalendar.Subject;
                            rRemarks."Sub-subject" := rWebCalendar."Sub-Subject Code";
                            rRemarks."Study Plan Code" := rClass."Study Plan Code";
                            rRemarks."Student/Teacher Code No." := tStudent;
                            rRemarks."Class No." := 0;
                            rRemarks."Moment Code" := '';
                            rRemarks."Line No." := rAbsence."Line No.";
                            rRemarks.Textline := autRecSet.Fields.Item('Observation').Value;
                            rRemarks.Seperator := rRemarks.Seperator::"Carriage Return";
                            rRemarks."Responsibility Center" := rClass."Responsibility Center";
                            rRemarks."Type Education" := rClass.Type;
                            rRemarks."Original Line No." := tOrderNo;
                            rRemarks."Type Remark" := rRemarks."Type Remark"::Absence;
                            rRemarks.Day := rWebCalendar."Filter Period";
                            rRemarks."Calendar Line" := rWebCalendar."Line No.";
                            rRemarks."Incidence Type" := tIncidenceType;
                            rRemarks.Insert(true);

                        end else begin
                            rRemarks.Textline := autRecSet.Fields.Item('Observation').Value;
                            rRemarks.Modify(true);
                        end;
                        intCount := intCount + 1;

                        txtSQLBegin := Text0010;
                        txtSQLEnd := '';
                        txtSeparador := ', ';

                        txtVALUES[1] := StrSubstNo(Text0001, Format(CompanyName));
                        txtVALUES[2] := StrSubstNo(Text0001, Format(tID_Calendar));
                        txtVALUES[3] := StrSubstNo(Text0001, Format(tStudent));
                        txtVALUES[4] := StrSubstNo(Text0001, Format(tSchoolYear));
                        txtVALUES[5] := StrSubstNo(Text0001, Format(tSchoolingYear));
                        txtVALUES[6] := StrSubstNo(Text0001, Format(tIncidenceCode));
                        txtVALUES[7] := StrSubstNo(Text0001, Format(tType));
                        txtVALUES[8] := StrSubstNo(Text0001, Format(tSubType));
                        txtVALUES[9] := StrSubstNo(Text0001, Format(lEntryNo));
                        txtVALUES[10] := StrSubstNo(Text0001, Format(InsertWEB_MasterTable.InsertString(rRemarks.Textline)));
                        txtVALUES[11] := StrSubstNo(Text0001, Format(0));
                        txtVALUES[12] := StrSubstNo(Text0001, Format(tIncidenceType));

                        // Statement que irá permitir incluir cada linha da tabela Navision para a tabela SQL
                        autConnection.Execute(txtSQLBegin +
                        txtVALUES[1] + txtSeparador +
                        txtVALUES[2] + txtSeparador +
                        txtVALUES[3] + txtSeparador +
                        txtVALUES[4] + txtSeparador +
                        txtVALUES[5] + txtSeparador +
                        txtVALUES[6] + txtSeparador +
                        txtVALUES[7] + txtSeparador +
                        txtVALUES[8] + txtSeparador +
                        txtVALUES[9] + txtSeparador +
                        txtVALUES[10] + txtSeparador +
                       txtVALUES[11] + txtSeparador +
                       txtVALUES[12] +
                        txtSQLEnd);

                    end;
                    //
                    autRecSet.MoveNext;
                until autRecSet.EOF;
            end;
        end;*/

    //[Scope('OnPrem')]
    procedure WEBtoNAVClassifications()
    var
        rGeneralTable: Record GeneralTable;
        rAssessingStudents: Record "Assessing Students";
        rAssessingStudentsFinal: Record "Assessing Students Final";
        rMomentsAssessment: Record "Moments Assessment";
        rSchoolYear: Record "School Year";
        rClass: Record Class;
        rStudentSubjects: Record "Registration Subjects";
        Text001: Label 'Update Classifications\@1@@@@@@@@@@@@@@@@@@@@\Class\#2####################\Assessment Type\#3####################';
        rClassificationLevel: Record "Classification Level";
        Window: Dialog;
        nreg: Integer;
        TotalReg: Integer;
        GradeTXT: Text[30];
        GradeDec: Decimal;
        Text002: Label 'Subjects';
    begin

        //Passa os dados da General table para a tabela de classificações do NAV
        rSchoolYear.Reset;
        rSchoolYear.SetRange(Status, rSchoolYear.Status::Active);
        if rSchoolYear.Find('-') then begin
            Window.Open(Text001);

            rAssessingStudents.LockTable(true);
            rAssessingStudentsFinal.LockTable(true);
            rMomentsAssessment.Reset;
            rMomentsAssessment.SetRange(Active, true);
            rMomentsAssessment.SetRange("School Year", rSchoolYear."School Year");
            if rMomentsAssessment.Find('-') then begin
                TotalReg := rMomentsAssessment.Count;
                repeat
                    nreg += 1;
                    rClass.Reset;
                    rClass.SetRange("School Year", rMomentsAssessment."School Year");
                    rClass.SetRange("Schooling Year", rMomentsAssessment."Schooling Year");
                    if rClass.Find('-') then
                        repeat
                            //Update the moment assessment
                            Window.Update(2, rClass.Class);
                            Window.Update(3, Text002);
                            rGeneralTable.Reset;
                            rGeneralTable.SetCurrentKey("School Year", Class, Moment);
                            rGeneralTable.SetRange("School Year", rSchoolYear."School Year");
                            rGeneralTable.SetRange(Class, rClass.Class);
                            rGeneralTable.SetRange(Moment, rMomentsAssessment."Moment Code");
                            rGeneralTable.SetRange("Entry Type", rGeneralTable."Entry Type"::" ");
                            if rGeneralTable.Find('-') then
                                repeat
                                    Window.Update(1, Round(nreg / TotalReg * 10000, 1));

                                    rAssessingStudents.Reset;
                                    //rAssessingStudents.SETRANGE(Class,rClass.Class);
                                    rAssessingStudents.SetRange("School Year", rClass."School Year");
                                    rAssessingStudents.SetRange("Schooling Year", rClass."Schooling Year");
                                    rAssessingStudents.SetRange(Subject, rGeneralTable.Subject);
                                    if rGeneralTable."Is SubSubject" then
                                        rAssessingStudents.SetRange("Sub-Subject Code", rGeneralTable."Sub Subject")
                                    else
                                        rAssessingStudents.SetRange("Sub-Subject Code", '');
                                    rAssessingStudents.SetRange("Student Code No.", rGeneralTable.Student);
                                    rAssessingStudents.SetRange("Moment Code", rMomentsAssessment."Moment Code");
                                    rAssessingStudents.SetRange("Study Plan Code", rClass."Study Plan Code");
                                    if rAssessingStudents.Find('-') then begin

                                        case rGeneralTable.EvaluationType of
                                            rGeneralTable.EvaluationType::Qualitative:
                                                begin
                                                    rAssessingStudents."Qualitative Grade" := rGeneralTable.GradeManual;
                                                    rAssessingStudents."Qualitative Grade Calc" := rGeneralTable.GradeAuto;
                                                end;
                                            rGeneralTable.EvaluationType::Quantitative:
                                                begin
                                                    GradeTXT := rGeneralTable.GradeManual;
                                                    if GradeTXT <> '' then begin
                                                        Evaluate(GradeDec, GradeTXT);
                                                        rAssessingStudents.Grade := GradeDec;
                                                    end else begin
                                                        rAssessingStudents.Grade := 0;
                                                    end;
                                                    GradeTXT := rGeneralTable.GradeAuto;
                                                    if GradeTXT <> '' then begin
                                                        Evaluate(GradeDec, GradeTXT);
                                                        rAssessingStudents."Grade Calc" := GradeDec;
                                                    end else begin
                                                        rAssessingStudents."Grade Calc" := 0;
                                                    end;

                                                end;
                                            rGeneralTable.EvaluationType::"Mixed-Qualification":
                                                begin
                                                    GradeTXT := rGeneralTable.GradeManual;
                                                    if GradeTXT <> '' then begin
                                                        Evaluate(GradeDec, GradeTXT);
                                                        rAssessingStudents.Grade := GradeDec;
                                                    end else begin
                                                        rAssessingStudents.Grade := 0;
                                                    end;

                                                    GradeTXT := rGeneralTable.GradeAuto;
                                                    if GradeTXT <> '' then begin
                                                        Evaluate(GradeDec, GradeTXT);
                                                        rAssessingStudents."Grade Calc" := GradeDec;
                                                    end else begin
                                                        rAssessingStudents."Grade Calc" := 0;
                                                    end;

                                                    rClassificationLevel.Reset;
                                                    rClassificationLevel.SetRange("Classification Group Code", rGeneralTable."Assement Code");
                                                    if rClassificationLevel.Find('-') then begin
                                                        repeat
                                                            if (rClassificationLevel."Min Value" <= rAssessingStudents.Grade) and
                                                              (rClassificationLevel."Max Value" >= rAssessingStudents.Grade) then
                                                                rAssessingStudents."Qualitative Grade" := rClassificationLevel."Classification Level Code";
                                                        until rClassificationLevel.Next = 0
                                                    end;
                                                    if rAssessingStudents.Grade = 0 then
                                                        rAssessingStudents."Qualitative Grade" := '';

                                                end;
                                        end;
                                        rAssessingStudents."Recuperation Grade" := rGeneralTable."Recuperation Grade";
                                        rAssessingStudents."Has Individual Plan" := rGeneralTable."Has Individual Plan";
                                        rAssessingStudents."Scholarship Reinforcement" := rGeneralTable."Scholarship Reinforcement";
                                        rAssessingStudents."Scholarship Support" := rGeneralTable."Scholarship Support";
                                        rAssessingStudents.Modify(true);
                                    end else begin
                                        if (rGeneralTable.GradeManual <> '') or (rGeneralTable.GradeAuto <> '') then begin
                                            rAssessingStudents.Init;
                                            rAssessingStudents.Class := rClass.Class;
                                            rAssessingStudents."School Year" := rClass."School Year";
                                            rAssessingStudents."Schooling Year" := rClass."Schooling Year";
                                            rAssessingStudents.Subject := rGeneralTable.Subject;
                                            if rGeneralTable."Is SubSubject" then
                                                rAssessingStudents."Sub-Subject Code" := rGeneralTable."Sub Subject"
                                            else
                                                rAssessingStudents."Sub-Subject Code" := '';
                                            rAssessingStudents."Study Plan Code" := rClass."Study Plan Code";
                                            rAssessingStudents."Student Code No." := rGeneralTable.Student;
                                            rAssessingStudents."Moment Code" := rMomentsAssessment."Moment Code";

                                            rStudentSubjects.Reset;
                                            rStudentSubjects.SetRange("Student Code No.", rGeneralTable.Student);
                                            rStudentSubjects.SetRange("School Year", rClass."School Year");
                                            rStudentSubjects.SetRange("Subjects Code", rGeneralTable.Subject);
                                            rStudentSubjects.SetRange(Class, rGeneralTable.Class);
                                            if rStudentSubjects.Find('-') then
                                                rAssessingStudents."Class No." := rStudentSubjects."Class No.";

                                            rAssessingStudents."Evaluation Moment" := rMomentsAssessment."Evaluation Moment";

                                            case rGeneralTable.EvaluationType of
                                                rGeneralTable.EvaluationType::Qualitative:
                                                    begin
                                                        rAssessingStudents."Qualitative Grade" := rGeneralTable.GradeManual;
                                                        rAssessingStudents."Qualitative Grade Calc" := rGeneralTable.GradeAuto;
                                                    end;
                                                rGeneralTable.EvaluationType::Quantitative:
                                                    begin
                                                        GradeTXT := rGeneralTable.GradeManual;
                                                        if GradeTXT <> '' then begin
                                                            Evaluate(GradeDec, GradeTXT);
                                                            rAssessingStudents.Grade := GradeDec;
                                                        end else begin
                                                            rAssessingStudents.Grade := 0;
                                                        end;

                                                        GradeTXT := rGeneralTable.GradeAuto;
                                                        if GradeTXT <> '' then begin
                                                            Evaluate(GradeDec, GradeTXT);
                                                            rAssessingStudents."Grade Calc" := GradeDec;
                                                        end else begin
                                                            rAssessingStudents."Grade Calc" := 0;
                                                        end;

                                                    end;
                                                rGeneralTable.EvaluationType::"Mixed-Qualification":
                                                    begin
                                                        GradeTXT := rGeneralTable.GradeManual;
                                                        if GradeTXT <> '' then begin
                                                            Evaluate(GradeDec, GradeTXT);
                                                            rAssessingStudents.Grade := GradeDec;
                                                        end else begin
                                                            rAssessingStudents.Grade := 0;
                                                        end;

                                                        GradeTXT := rGeneralTable.GradeAuto;
                                                        if GradeTXT <> '' then begin
                                                            Evaluate(GradeDec, GradeTXT);
                                                            rAssessingStudents."Grade Calc" := GradeDec;
                                                        end else begin
                                                            rAssessingStudents."Grade Calc" := 0;
                                                        end;

                                                        rClassificationLevel.Reset;
                                                        rClassificationLevel.SetRange("Classification Group Code", rGeneralTable."Assement Code");
                                                        if rClassificationLevel.Find('-') then begin
                                                            repeat
                                                                if (rClassificationLevel."Min Value" <= rAssessingStudents.Grade) and
                                                                  (rClassificationLevel."Max Value" >= rAssessingStudents.Grade) then
                                                                    rAssessingStudents."Qualitative Grade" := rClassificationLevel."Classification Level Code";
                                                            until rClassificationLevel.Next = 0
                                                        end;
                                                        if rAssessingStudents.Grade = 0 then
                                                            rAssessingStudents."Qualitative Grade" := '';
                                                    end;
                                            end;
                                            rAssessingStudents."Type Education" := rClass.Type;
                                            rAssessingStudents."Recuperation Grade" := rGeneralTable."Recuperation Grade";
                                            rAssessingStudents."Country/Region Code" := rClass."Country/Region Code";
                                            rAssessingStudents."Has Individual Plan" := rGeneralTable."Has Individual Plan";
                                            rAssessingStudents."Scholarship Reinforcement" := rGeneralTable."Scholarship Reinforcement";
                                            rAssessingStudents."Scholarship Support" := rGeneralTable."Scholarship Support";
                                            rAssessingStudents.Insert(true);
                                        end;
                                    end;
                                until rGeneralTable.Next = 0;

                            //Update the final moments assessments
                            Window.Update(2, rClass.Class);

                            rGeneralTable.Reset;
                            rGeneralTable.SetCurrentKey("School Year", Class, Moment);
                            rGeneralTable.SetRange("School Year", rSchoolYear."School Year");
                            rGeneralTable.SetRange(Class, rClass.Class);
                            rGeneralTable.SetRange(Moment, rMomentsAssessment."Moment Code");
                            rGeneralTable.SetFilter("Entry Type", '%1|%2|%3|%4',
                              rGeneralTable."Entry Type"::"Final Moment",
                              rGeneralTable."Entry Type"::"Final Moment Group",
                              rGeneralTable."Entry Type"::"Final Year",
                              rGeneralTable."Entry Type"::"Final Year Group");
                            if rGeneralTable.Find('-') then
                                repeat
                                    Window.Update(3, ConvertOptionString(rGeneralTable, rGeneralTable."Entry Type"));
                                    Window.Update(1, Round(nreg / TotalReg * 10000, 1));

                                    rAssessingStudentsFinal.Reset;
                                    rAssessingStudentsFinal.SetRange(Class, rGeneralTable.Class);
                                    rAssessingStudentsFinal.SetRange("School Year", rGeneralTable."School Year");
                                    rAssessingStudentsFinal.SetRange("Schooling Year", rGeneralTable.SchoolingYear);
                                    rAssessingStudentsFinal.SetRange("Moment Code", rGeneralTable.Moment);
                                    rAssessingStudentsFinal.SetRange("Student Code No.", rGeneralTable.Student);
                                    case rGeneralTable."Entry Type" of
                                        rGeneralTable."Entry Type"::"Final Moment":
                                            begin
                                                rAssessingStudentsFinal.SetRange("Option Group", '');
                                                rAssessingStudentsFinal.SetRange("Evaluation Type", rAssessingStudentsFinal."Evaluation Type"::"Final Moment");
                                            end;
                                        rGeneralTable."Entry Type"::"Final Moment Group":
                                            begin
                                                rAssessingStudentsFinal.SetRange("Option Group", rGeneralTable."Option Group");
                                                rAssessingStudentsFinal.SetRange("Evaluation Type",
                                                  rAssessingStudentsFinal."Evaluation Type"::"Final Moment Group");
                                            end;
                                        rGeneralTable."Entry Type"::"Final Year":
                                            begin
                                                rAssessingStudentsFinal.SetRange("Option Group", '');
                                                rAssessingStudentsFinal.SetRange("Evaluation Type", rAssessingStudentsFinal."Evaluation Type"::"Final Year");
                                            end;
                                        rGeneralTable."Entry Type"::"Final Year Group":
                                            begin
                                                rAssessingStudentsFinal.SetRange("Option Group", rGeneralTable."Option Group");
                                                rAssessingStudentsFinal.SetRange("Evaluation Type",
                                                  rAssessingStudentsFinal."Evaluation Type"::"Final Year Group");
                                            end;
                                    end;
                                    if rAssessingStudentsFinal.FindSet(true, true) then begin

                                        case rGeneralTable.EvaluationType of
                                            rGeneralTable.EvaluationType::Qualitative:
                                                begin
                                                    rAssessingStudentsFinal."Qualitative Manual Grade" := rGeneralTable.GradeManual;
                                                    rAssessingStudentsFinal."Qualitative Grade" := rGeneralTable.GradeAuto;
                                                end;
                                            rGeneralTable.EvaluationType::Quantitative:
                                                begin
                                                    GradeTXT := rGeneralTable.GradeManual;
                                                    if GradeTXT <> '' then begin
                                                        Evaluate(GradeDec, GradeTXT);
                                                        rAssessingStudentsFinal."Manual Grade" := GradeDec;
                                                    end else begin
                                                        rAssessingStudentsFinal."Manual Grade" := 0;
                                                    end;

                                                    GradeTXT := rGeneralTable.GradeAuto;
                                                    if GradeTXT <> '' then begin
                                                        Evaluate(GradeDec, GradeTXT);
                                                        rAssessingStudentsFinal.Grade := GradeDec;
                                                    end else begin
                                                        rAssessingStudentsFinal.Grade := 0;
                                                    end;

                                                end;
                                            rGeneralTable.EvaluationType::"Mixed-Qualification":
                                                begin
                                                    GradeTXT := rGeneralTable.GradeManual;
                                                    if GradeTXT <> '' then begin
                                                        Evaluate(GradeDec, GradeTXT);
                                                        rAssessingStudentsFinal."Manual Grade" := GradeDec;
                                                    end else begin
                                                        rAssessingStudentsFinal."Manual Grade" := 0;
                                                    end;

                                                    rClassificationLevel.Reset;
                                                    rClassificationLevel.SetRange("Classification Group Code", rGeneralTable."Assement Code");
                                                    if rClassificationLevel.Find('-') then begin
                                                        repeat
                                                            if (rClassificationLevel."Min Value" <= rAssessingStudentsFinal."Manual Grade") and
                                                              (rClassificationLevel."Max Value" >= rAssessingStudentsFinal."Manual Grade") then
                                                                rAssessingStudentsFinal."Qualitative Manual Grade" := rClassificationLevel."Classification Level Code"
                                    ;
                                                        until rClassificationLevel.Next = 0
                                                    end;
                                                    if rAssessingStudentsFinal."Manual Grade" = 0 then
                                                        rAssessingStudentsFinal."Qualitative Manual Grade" := '';

                                                    GradeTXT := rGeneralTable.GradeAuto;
                                                    if GradeTXT <> '' then begin
                                                        Evaluate(GradeDec, GradeTXT);
                                                        rAssessingStudentsFinal.Grade := GradeDec;
                                                    end else begin
                                                        rAssessingStudentsFinal.Grade := 0;
                                                    end;

                                                    rClassificationLevel.Reset;
                                                    rClassificationLevel.SetRange("Classification Group Code", rGeneralTable."Assement Code");
                                                    if rClassificationLevel.Find('-') then begin
                                                        repeat
                                                            if (rClassificationLevel."Min Value" <= rAssessingStudentsFinal.Grade) and
                                                              (rClassificationLevel."Max Value" >= rAssessingStudentsFinal.Grade) then
                                                                rAssessingStudentsFinal."Qualitative Grade" := rClassificationLevel."Classification Level Code";
                                                        until rClassificationLevel.Next = 0
                                                    end;
                                                    if rAssessingStudentsFinal.Grade = 0 then
                                                        rAssessingStudentsFinal."Qualitative Grade" := '';
                                                end;
                                        end;

                                        rAssessingStudentsFinal.Modify;
                                    end;
                                until rGeneralTable.Next = 0;
                        until rClass.Next = 0;
                until rMomentsAssessment.Next = 0;
            end;
            //  Recuperacao não activo
            rMomentsAssessment.Reset;
            rMomentsAssessment.SetRange(Recuperation, true);
            rMomentsAssessment.SetRange(Active, false);
            rMomentsAssessment.SetRange("School Year", rSchoolYear."School Year");
            if rMomentsAssessment.Find('-') then begin
                TotalReg := rMomentsAssessment.Count;
                repeat
                    nreg += 1;
                    rClass.Reset;
                    rClass.SetRange("School Year", rMomentsAssessment."School Year");
                    rClass.SetRange("Schooling Year", rMomentsAssessment."Schooling Year");
                    if rClass.Find('-') then
                        repeat
                            //Update the moment assessment
                            Window.Update(2, rClass.Class);
                            Window.Update(3, Text002);
                            rGeneralTable.Reset;
                            rGeneralTable.SetCurrentKey("School Year", Class, Moment);
                            rGeneralTable.SetRange("School Year", rSchoolYear."School Year");
                            rGeneralTable.SetRange(Class, rClass.Class);
                            rGeneralTable.SetRange(Moment, rMomentsAssessment."Moment Code");
                            rGeneralTable.SetRange("Entry Type", rGeneralTable."Entry Type"::" ");
                            if rGeneralTable.Find('-') then
                                repeat
                                    Window.Update(1, Round(nreg / TotalReg * 10000, 1));

                                    rAssessingStudents.Reset;
                                    //rAssessingStudents.SETRANGE(Class,rClass.Class);
                                    rAssessingStudents.SetRange("School Year", rClass."School Year");
                                    rAssessingStudents.SetRange("Schooling Year", rClass."Schooling Year");
                                    rAssessingStudents.SetRange(Subject, rGeneralTable.Subject);
                                    if rGeneralTable."Is SubSubject" then
                                        rAssessingStudents.SetRange("Sub-Subject Code", rGeneralTable."Sub Subject")
                                    else
                                        rAssessingStudents.SetRange("Sub-Subject Code", '');
                                    rAssessingStudents.SetRange("Student Code No.", rGeneralTable.Student);
                                    rAssessingStudents.SetRange("Moment Code", rMomentsAssessment."Moment Code");
                                    rAssessingStudents.SetRange("Study Plan Code", rClass."Study Plan Code");
                                    if rAssessingStudents.Find('-') then begin

                                        case rGeneralTable.EvaluationType of
                                            rGeneralTable.EvaluationType::Qualitative:
                                                begin
                                                    rAssessingStudents."Qualitative Grade" := rGeneralTable.GradeManual;
                                                    rAssessingStudents."Qualitative Grade Calc" := rGeneralTable.GradeAuto;
                                                end;
                                            rGeneralTable.EvaluationType::Quantitative:
                                                begin
                                                    GradeTXT := rGeneralTable.GradeManual;
                                                    if GradeTXT <> '' then begin
                                                        Evaluate(GradeDec, GradeTXT);
                                                        rAssessingStudents.Grade := GradeDec;
                                                    end else begin
                                                        rAssessingStudents.Grade := 0;
                                                    end;
                                                    GradeTXT := rGeneralTable.GradeAuto;
                                                    if GradeTXT <> '' then begin
                                                        Evaluate(GradeDec, GradeTXT);
                                                        rAssessingStudents."Grade Calc" := GradeDec;
                                                    end else begin
                                                        rAssessingStudents."Grade Calc" := 0;
                                                    end;

                                                end;
                                            rGeneralTable.EvaluationType::"Mixed-Qualification":
                                                begin
                                                    GradeTXT := rGeneralTable.GradeManual;
                                                    if GradeTXT <> '' then begin
                                                        Evaluate(GradeDec, GradeTXT);
                                                        rAssessingStudents.Grade := GradeDec;
                                                    end else begin
                                                        rAssessingStudents.Grade := 0;
                                                    end;

                                                    GradeTXT := rGeneralTable.GradeAuto;
                                                    if GradeTXT <> '' then begin
                                                        Evaluate(GradeDec, GradeTXT);
                                                        rAssessingStudents."Grade Calc" := GradeDec;
                                                    end else begin
                                                        rAssessingStudents."Grade Calc" := 0;
                                                    end;

                                                    rClassificationLevel.Reset;
                                                    rClassificationLevel.SetRange("Classification Group Code", rGeneralTable."Assement Code");
                                                    if rClassificationLevel.Find('-') then begin
                                                        repeat
                                                            if (rClassificationLevel."Min Value" <= rAssessingStudents.Grade) and
                                                              (rClassificationLevel."Max Value" >= rAssessingStudents.Grade) then
                                                                rAssessingStudents."Qualitative Grade" := rClassificationLevel."Classification Level Code";
                                                        until rClassificationLevel.Next = 0
                                                    end;
                                                    if rAssessingStudents.Grade = 0 then
                                                        rAssessingStudents."Qualitative Grade" := '';

                                                end;
                                        end;
                                        rAssessingStudents."Recuperation Grade" := rGeneralTable."Recuperation Grade";
                                        rAssessingStudents."Has Individual Plan" := rGeneralTable."Has Individual Plan";
                                        rAssessingStudents."Scholarship Reinforcement" := rGeneralTable."Scholarship Reinforcement";
                                        rAssessingStudents."Scholarship Support" := rGeneralTable."Scholarship Support";
                                        rAssessingStudents.Modify(true);
                                    end else begin
                                        if (rGeneralTable.GradeManual <> '') or (rGeneralTable.GradeAuto <> '') then begin
                                            rAssessingStudents.Init;
                                            rAssessingStudents.Class := rClass.Class;
                                            rAssessingStudents."School Year" := rClass."School Year";
                                            rAssessingStudents."Schooling Year" := rClass."Schooling Year";
                                            rAssessingStudents.Subject := rGeneralTable.Subject;
                                            if rGeneralTable."Is SubSubject" then
                                                rAssessingStudents."Sub-Subject Code" := rGeneralTable."Sub Subject"
                                            else
                                                rAssessingStudents."Sub-Subject Code" := '';
                                            rAssessingStudents."Study Plan Code" := rClass."Study Plan Code";
                                            rAssessingStudents."Student Code No." := rGeneralTable.Student;
                                            rAssessingStudents."Moment Code" := rMomentsAssessment."Moment Code";

                                            rStudentSubjects.Reset;
                                            rStudentSubjects.SetRange("Student Code No.", rGeneralTable.Student);
                                            rStudentSubjects.SetRange("School Year", rClass."School Year");
                                            rStudentSubjects.SetRange("Subjects Code", rGeneralTable.Subject);
                                            rStudentSubjects.SetRange(Class, rGeneralTable.Class);
                                            if rStudentSubjects.Find('-') then
                                                rAssessingStudents."Class No." := rStudentSubjects."Class No.";

                                            rAssessingStudents."Evaluation Moment" := rMomentsAssessment."Evaluation Moment";

                                            case rGeneralTable.EvaluationType of
                                                rGeneralTable.EvaluationType::Qualitative:
                                                    begin
                                                        rAssessingStudents."Qualitative Grade" := rGeneralTable.GradeManual;
                                                        rAssessingStudents."Qualitative Grade Calc" := rGeneralTable.GradeAuto;
                                                    end;
                                                rGeneralTable.EvaluationType::Quantitative:
                                                    begin
                                                        GradeTXT := rGeneralTable.GradeManual;
                                                        if GradeTXT <> '' then begin
                                                            Evaluate(GradeDec, GradeTXT);
                                                            rAssessingStudents.Grade := GradeDec;
                                                        end else begin
                                                            rAssessingStudents.Grade := 0;
                                                        end;

                                                        GradeTXT := rGeneralTable.GradeAuto;
                                                        if GradeTXT <> '' then begin
                                                            Evaluate(GradeDec, GradeTXT);
                                                            rAssessingStudents."Grade Calc" := GradeDec;
                                                        end else begin
                                                            rAssessingStudents."Grade Calc" := 0;
                                                        end;

                                                    end;
                                                rGeneralTable.EvaluationType::"Mixed-Qualification":
                                                    begin
                                                        GradeTXT := rGeneralTable.GradeManual;
                                                        if GradeTXT <> '' then begin
                                                            Evaluate(GradeDec, GradeTXT);
                                                            rAssessingStudents.Grade := GradeDec;
                                                        end else begin
                                                            rAssessingStudents.Grade := 0;
                                                        end;

                                                        GradeTXT := rGeneralTable.GradeAuto;
                                                        if GradeTXT <> '' then begin
                                                            Evaluate(GradeDec, GradeTXT);
                                                            rAssessingStudents."Grade Calc" := GradeDec;
                                                        end else begin
                                                            rAssessingStudents."Grade Calc" := 0;
                                                        end;

                                                        rClassificationLevel.Reset;
                                                        rClassificationLevel.SetRange("Classification Group Code", rGeneralTable."Assement Code");
                                                        if rClassificationLevel.Find('-') then begin
                                                            repeat
                                                                if (rClassificationLevel."Min Value" <= rAssessingStudents.Grade) and
                                                                  (rClassificationLevel."Max Value" >= rAssessingStudents.Grade) then
                                                                    rAssessingStudents."Qualitative Grade" := rClassificationLevel."Classification Level Code";
                                                            until rClassificationLevel.Next = 0
                                                        end;
                                                        if rAssessingStudents.Grade = 0 then
                                                            rAssessingStudents."Qualitative Grade" := '';
                                                    end;
                                            end;
                                            rAssessingStudents."Type Education" := rClass.Type;
                                            rAssessingStudents."Recuperation Grade" := rGeneralTable."Recuperation Grade";
                                            rAssessingStudents."Country/Region Code" := rClass."Country/Region Code";
                                            rAssessingStudents."Has Individual Plan" := rGeneralTable."Has Individual Plan";
                                            rAssessingStudents."Scholarship Reinforcement" := rGeneralTable."Scholarship Reinforcement";
                                            rAssessingStudents."Scholarship Support" := rGeneralTable."Scholarship Support";
                                            rAssessingStudents.Insert(true);
                                        end;
                                    end;
                                until rGeneralTable.Next = 0;

                            //Update the final moments assessments
                            Window.Update(2, rClass.Class);

                            rGeneralTable.Reset;
                            rGeneralTable.SetCurrentKey("School Year", Class, Moment);
                            rGeneralTable.SetRange("School Year", rSchoolYear."School Year");
                            rGeneralTable.SetRange(Class, rClass.Class);
                            rGeneralTable.SetRange(Moment, rMomentsAssessment."Moment Code");
                            rGeneralTable.SetFilter("Entry Type", '%1|%2|%3|%4',
                              rGeneralTable."Entry Type"::"Final Moment",
                              rGeneralTable."Entry Type"::"Final Moment Group",
                              rGeneralTable."Entry Type"::"Final Year",
                              rGeneralTable."Entry Type"::"Final Year Group");
                            if rGeneralTable.Find('-') then
                                repeat
                                    Window.Update(3, ConvertOptionString(rGeneralTable, rGeneralTable."Entry Type"));
                                    Window.Update(1, Round(nreg / TotalReg * 10000, 1));

                                    rAssessingStudentsFinal.Reset;
                                    rAssessingStudentsFinal.SetRange(Class, rGeneralTable.Class);
                                    rAssessingStudentsFinal.SetRange("School Year", rGeneralTable."School Year");
                                    rAssessingStudentsFinal.SetRange("Schooling Year", rGeneralTable.SchoolingYear);
                                    rAssessingStudentsFinal.SetRange("Moment Code", rGeneralTable.Moment);
                                    rAssessingStudentsFinal.SetRange("Student Code No.", rGeneralTable.Student);
                                    case rGeneralTable."Entry Type" of
                                        rGeneralTable."Entry Type"::"Final Moment":
                                            begin
                                                rAssessingStudentsFinal.SetRange("Option Group", '');
                                                rAssessingStudentsFinal.SetRange("Evaluation Type", rAssessingStudentsFinal."Evaluation Type"::"Final Moment");
                                            end;
                                        rGeneralTable."Entry Type"::"Final Moment Group":
                                            begin
                                                rAssessingStudentsFinal.SetRange("Option Group", rGeneralTable."Option Group");
                                                rAssessingStudentsFinal.SetRange("Evaluation Type",
                                                  rAssessingStudentsFinal."Evaluation Type"::"Final Moment Group");
                                            end;
                                        rGeneralTable."Entry Type"::"Final Year":
                                            begin
                                                rAssessingStudentsFinal.SetRange("Option Group", '');
                                                rAssessingStudentsFinal.SetRange("Evaluation Type", rAssessingStudentsFinal."Evaluation Type"::"Final Year");
                                            end;
                                        rGeneralTable."Entry Type"::"Final Year Group":
                                            begin
                                                rAssessingStudentsFinal.SetRange("Option Group", rGeneralTable."Option Group");
                                                rAssessingStudentsFinal.SetRange("Evaluation Type",
                                                  rAssessingStudentsFinal."Evaluation Type"::"Final Year Group");
                                            end;
                                    end;
                                    if rAssessingStudentsFinal.FindSet(true, true) then begin

                                        case rGeneralTable.EvaluationType of
                                            rGeneralTable.EvaluationType::Qualitative:
                                                begin
                                                    rAssessingStudentsFinal."Qualitative Manual Grade" := rGeneralTable.GradeManual;
                                                    rAssessingStudentsFinal."Qualitative Grade" := rGeneralTable.GradeAuto;
                                                end;
                                            rGeneralTable.EvaluationType::Quantitative:
                                                begin
                                                    GradeTXT := rGeneralTable.GradeManual;
                                                    if GradeTXT <> '' then begin
                                                        Evaluate(GradeDec, GradeTXT);
                                                        rAssessingStudentsFinal."Manual Grade" := GradeDec;
                                                    end else begin
                                                        rAssessingStudentsFinal."Manual Grade" := 0;
                                                    end;

                                                    GradeTXT := rGeneralTable.GradeAuto;
                                                    if GradeTXT <> '' then begin
                                                        Evaluate(GradeDec, GradeTXT);
                                                        rAssessingStudentsFinal.Grade := GradeDec;
                                                    end else begin
                                                        rAssessingStudentsFinal.Grade := 0;
                                                    end;

                                                end;
                                            rGeneralTable.EvaluationType::"Mixed-Qualification":
                                                begin
                                                    GradeTXT := rGeneralTable.GradeManual;
                                                    if GradeTXT <> '' then begin
                                                        Evaluate(GradeDec, GradeTXT);
                                                        rAssessingStudentsFinal."Manual Grade" := GradeDec;
                                                    end else begin
                                                        rAssessingStudentsFinal."Manual Grade" := 0;
                                                    end;

                                                    rClassificationLevel.Reset;
                                                    rClassificationLevel.SetRange("Classification Group Code", rGeneralTable."Assement Code");
                                                    if rClassificationLevel.Find('-') then begin
                                                        repeat
                                                            if (rClassificationLevel."Min Value" <= rAssessingStudentsFinal."Manual Grade") and
                                                              (rClassificationLevel."Max Value" >= rAssessingStudentsFinal."Manual Grade") then
                                                                rAssessingStudentsFinal."Qualitative Manual Grade" := rClassificationLevel."Classification Level Code"
                                    ;
                                                        until rClassificationLevel.Next = 0
                                                    end;
                                                    if rAssessingStudentsFinal."Manual Grade" = 0 then
                                                        rAssessingStudentsFinal."Qualitative Manual Grade" := '';

                                                    GradeTXT := rGeneralTable.GradeAuto;
                                                    if GradeTXT <> '' then begin
                                                        Evaluate(GradeDec, GradeTXT);
                                                        rAssessingStudentsFinal.Grade := GradeDec;
                                                    end else begin
                                                        rAssessingStudentsFinal.Grade := 0;
                                                    end;

                                                    rClassificationLevel.Reset;
                                                    rClassificationLevel.SetRange("Classification Group Code", rGeneralTable."Assement Code");
                                                    if rClassificationLevel.Find('-') then begin
                                                        repeat
                                                            if (rClassificationLevel."Min Value" <= rAssessingStudentsFinal.Grade) and
                                                              (rClassificationLevel."Max Value" >= rAssessingStudentsFinal.Grade) then
                                                                rAssessingStudentsFinal."Qualitative Grade" := rClassificationLevel."Classification Level Code";
                                                        until rClassificationLevel.Next = 0
                                                    end;
                                                    if rAssessingStudentsFinal.Grade = 0 then
                                                        rAssessingStudentsFinal."Qualitative Grade" := '';
                                                end;
                                        end;

                                        rAssessingStudentsFinal.Modify;
                                    end;
                                until rGeneralTable.Next = 0;
                        until rClass.Next = 0;
                until rMomentsAssessment.Next = 0;
            end;
            //
            Window.Close;

        end;
        //END;

        InsertAspects;
    end;

    //[Scope('OnPrem')]
    procedure CalcFinalMoment(pClass: Code[20]; pSchoolYear: Code[20]; pMoment: Code[20]; pStudent: Code[20])
    var
        rAssessingStudents: Record "Assessing Students";
        rAssessingStudentsSubSuj: Record "Assessing Students";
        rAssessingStudentsFinal: Record "Assessing Students Final";
        rStudyPlanHeader: Record "Study Plan Header";
        rStudyPlanLines: Record "Study Plan Lines";
        rCourseHeader: Record "Course Header";
        rCourseLines: Record "Course Lines";
        rClass: Record Class;
        rAssessementConfiguration: Record "Assessment Configuration";
        Text002: Label 'The Study Plan/Course %1 does not have Assessement Configuration';
        rStudyPlanSubSubjectsLines: Record "Study Plan Sub-Subjects Lines";
        rMomentsAssessment: Record "Moments Assessment";
        rGroupSubjects: Record "Group Subjects";
        TotalSubSubject: Decimal;
        TotalPonderSubSubj: Decimal;
        TotalSubject: Decimal;
        TotalPonderSubj: Decimal;
        TotalSubject2: Decimal;
        TotalPonderSubj2: Decimal;
        TotalSubSubjectFinal: Decimal;
        TotalPonderSubSubjFinal: Decimal;
        TotalSubjectFinal: Decimal;
        TotalPonderSubjFinal: Decimal;
        TotalSubject2Final: Decimal;
        TotalPonderSubj2Final: Decimal;
        TotalOption: Decimal;
        TotalPonderOption: Decimal;
        Total: Decimal;
        LastOptionGroup: Code[20];
        LastSubject: Code[20];
        LastSchoolingYear: Code[20];
        CountryRegionCode: Code[20];
        StudyPlanCourse: Code[20];
        cCalcEvaluations: Codeunit "Calc. Evaluations";
    begin
        if rClass.Get(pClass, pSchoolYear) then begin

            rAssessementConfiguration.Reset;
            rAssessementConfiguration.SetRange("School Year", rClass."School Year");
            rAssessementConfiguration.SetRange(Type, rClass.Type);
            rAssessementConfiguration.SetRange("Study Plan Code", rClass."Study Plan Code");
            rAssessementConfiguration.SetRange("Country/Region Code", rClass."Country/Region Code");
            if not rAssessementConfiguration.FindFirst then
                Error(Text002, rClass."Study Plan Code");
            rAssessementConfiguration.TestField("PA Assessment Code");

            rAssessingStudentsFinal.LockTable(true);

            if rClass.Type = rClass.Type::Simple then begin
                rStudyPlanLines.Reset;
                rStudyPlanLines.SetCurrentKey("Option Group", "Subject Code");
                rStudyPlanLines.SetRange(Code, rClass."Study Plan Code");
                rStudyPlanLines.SetRange("School Year", rClass."School Year");
                rStudyPlanLines.SetRange("Subject Excluded From Assess.", false);
                if rStudyPlanLines.FindSet then
                    repeat
                        CountryRegionCode := rStudyPlanLines."Country/Region Code";
                        StudyPlanCourse := rStudyPlanLines.Code;

                        //Valida se o grupo é diferente do anterior e insere a linha na tabela de classificações finais.
                        if (LastOptionGroup <> rStudyPlanLines."Option Group") and ((TotalSubject <> 0) or (TotalSubject2 <> 0)) then begin

                            rMomentsAssessment.Reset;
                            rMomentsAssessment.SetRange("Moment Code", pMoment);
                            rMomentsAssessment.SetRange("School Year", pSchoolYear);
                            rMomentsAssessment.SetRange("Schooling Year", LastSchoolingYear);
                            if rMomentsAssessment.FindFirst then;

                            Total := 0;
                            case rAssessementConfiguration."PA Group Sub. Classification" of
                                rAssessementConfiguration."PA Group Sub. Classification"::"Sub-Subject (Vertical) ":
                                    begin
                                        if (TotalPonderSubSubj <> 0) then
                                            //((TotalSubject <> 0) OR (TotalSubSubject <> 0)) AND ((TotalPonderSubj <> 0) OR
                                            Total := Round((TotalSubSubject) / (TotalPonderSubSubj),
                                          rAssessementConfiguration."PA Group Sub. Round Method");
                                        if Total <> 0 then
                                            InsertFinalClassification(pClass,
                                                                pSchoolYear,
                                                                LastSchoolingYear,
                                                                //LastSubject,
                                                                '',
                                                                '',
                                                                StudyPlanCourse,
                                                                pStudent,
                                                                rMomentsAssessment."Evaluation Moment",
                                                                pMoment,
                                                                Total,
                                                                rClass.Type,
                                                                LastOptionGroup,
                                                                rStudyPlanLines."Country/Region Code",
                                                                3,
                                                                0);

                                        //Vai guardar a classificação do grupo para utilizar no calculo da nota final
                                        if Total <> 0 then begin
                                            rGroupSubjects.Reset;
                                            rGroupSubjects.SetRange(Code, LastOptionGroup);
                                            rGroupSubjects.SetRange("Schooling Year", LastSchoolingYear);
                                            rGroupSubjects.SetRange("Country/Region Code", rClass."Country/Region Code");
                                            if rGroupSubjects.FindFirst then begin
                                                rGroupSubjects.TestField("Assessment Code");
                                                TotalOption += Total * rGroupSubjects.Ponder;
                                                TotalPonderOption += rGroupSubjects.Ponder;
                                            end else begin
                                                rGroupSubjects.Reset;
                                                rGroupSubjects.SetRange(Code, LastOptionGroup);
                                                rGroupSubjects.SetFilter("Schooling Year", '%1', '');
                                                rGroupSubjects.SetRange("Country/Region Code", rClass."Country/Region Code");
                                                if rGroupSubjects.FindFirst then begin
                                                    rGroupSubjects.TestField("Assessment Code");
                                                    TotalOption += Total * rGroupSubjects.Ponder;
                                                    TotalPonderOption += rGroupSubjects.Ponder;
                                                end;
                                            end;
                                        end;


                                        TotalSubSubjectFinal += TotalSubSubject;
                                        TotalPonderSubSubjFinal += TotalPonderSubSubj;
                                        TotalSubjectFinal += TotalSubject;
                                        TotalPonderSubjFinal += TotalPonderSubj;
                                        TotalSubject2Final += TotalSubject2;
                                        TotalPonderSubj2Final += TotalPonderSubj2;

                                        TotalSubSubject := 0;
                                        TotalPonderSubSubj := 0;
                                        TotalSubject := 0;
                                        TotalPonderSubj := 0;
                                        TotalSubject2 := 0;
                                        TotalPonderSubj2 := 0;


                                    end;
                                rAssessementConfiguration."PA Group Sub. Classification"::"Subject (Vertical)":
                                    begin
                                        if ((TotalSubject <> 0) or (TotalSubject2 <> 0)) and ((TotalPonderSubj <> 0) or (TotalPonderSubj2 <> 0)) then
                                            Total := Round((TotalSubject + TotalSubject2) / (TotalPonderSubj + TotalPonderSubj2),
                                                        rAssessementConfiguration."PA Group Sub. Round Method");

                                        if Total <> 0 then
                                            InsertFinalClassification(pClass,
                                                                 pSchoolYear,
                                                                 LastSchoolingYear,
                                                                 //LastSubject,
                                                                 '',
                                                                 '',
                                                                 StudyPlanCourse,
                                                                 pStudent,
                                                                 rMomentsAssessment."Evaluation Moment",
                                                                 pMoment,
                                                                 Total,
                                                                 rClass.Type,
                                                                 LastOptionGroup,
                                                                 rStudyPlanLines."Country/Region Code",
                                                                 3,
                                                                 0);

                                        //Vai guardar a classificação do grupo para utilizar no calculo da nota final
                                        if Total <> 0 then begin
                                            rGroupSubjects.Reset;
                                            rGroupSubjects.SetRange(Code, LastOptionGroup);
                                            rGroupSubjects.SetRange("Schooling Year", LastSchoolingYear);
                                            rGroupSubjects.SetRange("Country/Region Code", rClass."Country/Region Code");
                                            if rGroupSubjects.FindFirst then begin
                                                rGroupSubjects.TestField("Assessment Code");
                                                TotalOption += Total * rGroupSubjects.Ponder;
                                                TotalPonderOption += rGroupSubjects.Ponder;
                                            end else begin
                                                rGroupSubjects.Reset;
                                                rGroupSubjects.SetRange(Code, LastOptionGroup);
                                                rGroupSubjects.SetFilter("Schooling Year", '%1', '');
                                                rGroupSubjects.SetRange("Country/Region Code", rClass."Country/Region Code");
                                                if rGroupSubjects.FindFirst then begin
                                                    rGroupSubjects.TestField("Assessment Code");
                                                    TotalOption += Total * rGroupSubjects.Ponder;
                                                    TotalPonderOption += rGroupSubjects.Ponder;
                                                end;
                                            end;
                                        end;

                                        TotalSubSubjectFinal += TotalSubSubject;
                                        TotalPonderSubSubjFinal += TotalPonderSubSubj;
                                        TotalSubjectFinal += TotalSubject;
                                        TotalPonderSubjFinal += TotalPonderSubj;
                                        TotalSubject2Final += TotalSubject2;
                                        TotalPonderSubj2Final += TotalPonderSubj2;

                                        TotalSubSubject := 0;
                                        TotalPonderSubSubj := 0;
                                        TotalSubject := 0;
                                        TotalPonderSubj := 0;
                                        TotalSubject2 := 0;
                                        TotalPonderSubj2 := 0;
                                    end;

                            end;
                        end;

                        rStudyPlanLines.CalcFields("Sub-Subject");
                        //Vai calcular a classificação com base nas subdisciplinas
                        if rStudyPlanLines."Sub-Subject" then begin
                            rStudyPlanSubSubjectsLines.Reset;
                            rStudyPlanSubSubjectsLines.SetRange(Type, rClass.Type);
                            rStudyPlanSubSubjectsLines.SetRange(Code, rStudyPlanLines.Code);
                            rStudyPlanSubSubjectsLines.SetRange("Schooling Year", rStudyPlanLines."Schooling Year");
                            rStudyPlanSubSubjectsLines.SetRange("Subject Code", rStudyPlanLines."Subject Code");
                            if rStudyPlanSubSubjectsLines.FindSet then
                                repeat
                                    rAssessingStudents.Reset;
                                    rAssessingStudents.SetRange(Class, pClass);
                                    rAssessingStudents.SetRange("School Year", pSchoolYear);
                                    rAssessingStudents.SetRange("Moment Code", pMoment);
                                    rAssessingStudents.SetRange(Subject, rStudyPlanLines."Subject Code");
                                    rAssessingStudents.SetRange("Sub-Subject Code", rStudyPlanSubSubjectsLines."Sub-Subject Code");
                                    rAssessingStudents.SetRange("Student Code No.", pStudent);
                                    if rAssessingStudents.FindSet then
                                        repeat
                                            //Change 12-04-2008
                                            if rAssessingStudents."Recuperation Grade" = 0 then begin
                                                TotalPonderSubSubj += cCalcEvaluations.GetSubSettingRattingPonder(rAssessingStudents);
                                                TotalSubSubject +=
                                                        rAssessingStudents.Grade * cCalcEvaluations.GetSubSettingRattingPonder(rAssessingStudents);
                                            end else begin
                                                TotalPonderSubSubj += rAssessingStudents."Recuperation Grade" *
                                                   cCalcEvaluations.GetSubSettingRattingPonder(rAssessingStudents);
                                                TotalSubSubject += rAssessingStudents."Recuperation Grade" *
                                                   cCalcEvaluations.GetSubSettingRattingPonder(rAssessingStudents);
                                            end;
                                        //
                                        until rAssessingStudents.Next = 0;
                                until rStudyPlanSubSubjectsLines.Next = 0;

                            rAssessingStudents.Reset;
                            rAssessingStudents.SetRange(Class, pClass);
                            rAssessingStudents.SetRange("School Year", pSchoolYear);
                            rAssessingStudents.SetRange("Moment Code", pMoment);
                            rAssessingStudents.SetRange(Subject, rStudyPlanLines."Subject Code");
                            rAssessingStudents.SetFilter("Sub-Subject Code", '%1', '');
                            rAssessingStudents.SetRange("Student Code No.", pStudent);
                            if rAssessingStudents.FindSet then
                                repeat
                                    //Change 05-12-2008
                                    //TotalPonderSubj2 += rStudyPlanLines.Weighting;
                                    TotalPonderSubj2 += cCalcEvaluations.GetSettingRatting(rAssessingStudents);
                                    if rAssessingStudents."Recuperation Grade" = 0 then
                                        //TotalSubject2 += rAssessingStudents.Grade * rStudyPlanLines.Weighting
                                        TotalSubject2 += rAssessingStudents.Grade * cCalcEvaluations.GetSettingRatting(rAssessingStudents)
                                    else
                                        //TotalSubject2 += rAssessingStudents."Recuperation Grade" * rStudyPlanLines.Weighting;
                                        TotalSubject2 += rAssessingStudents."Recuperation Grade"
                                              * cCalcEvaluations.GetSettingRatting(rAssessingStudents);

                                until rAssessingStudents.Next = 0;

                        end else begin
                            rAssessingStudents.Reset;
                            rAssessingStudents.SetRange(Class, pClass);
                            rAssessingStudents.SetRange("School Year", pSchoolYear);
                            rAssessingStudents.SetRange("Moment Code", pMoment);
                            rAssessingStudents.SetRange(Subject, rStudyPlanLines."Subject Code");
                            rAssessingStudents.SetFilter("Sub-Subject Code", '%1', '');
                            rAssessingStudents.SetRange("Student Code No.", pStudent);
                            if rAssessingStudents.FindSet then
                                repeat
                                    //TotalPonderSubj += rStudyPlanLines.Weighting;
                                    TotalPonderSubj += cCalcEvaluations.GetSettingRatting(rAssessingStudents);
                                    if rAssessingStudents."Recuperation Grade" = 0 then
                                        //TotalSubject += rAssessingStudents.Grade * rStudyPlanLines.Weighting
                                        TotalSubject += rAssessingStudents.Grade * cCalcEvaluations.GetSettingRatting(rAssessingStudents)

                                    else
                                        //TotalSubject += rAssessingStudents."Recuperation Grade" * rStudyPlanLines.Weighting;
                                        TotalSubject += rAssessingStudents."Recuperation Grade"
                                             * cCalcEvaluations.GetSettingRatting(rAssessingStudents);
                                until rAssessingStudents.Next = 0;
                        end;

                        LastOptionGroup := rStudyPlanLines."Option Group";
                        LastSubject := rStudyPlanLines."Subject Code";
                        LastSchoolingYear := rStudyPlanLines."Schooling Year";

                    until rStudyPlanLines.Next = 0;
            end else begin
                rCourseLines.Reset;
                rCourseLines.SetCurrentKey("Option Group", "Subject Code");
                rCourseLines.SetRange(Code, rClass."Study Plan Code");
                //rcourseLines.SETRANGE("School Year",rClass."School Year");
                rCourseLines.SetRange("Subject Excluded From Assess.", false);
                if rCourseLines.Find('-') then
                    repeat

                        CountryRegionCode := rCourseLines."Country/Region Code";
                        StudyPlanCourse := rCourseLines.Code;

                        //Valida se o grupo é diferente do anterior e insere a linha na tabela de classificações finais.
                        if (LastOptionGroup <> rCourseLines."Option Group") and ((TotalSubject <> 0) or (TotalSubject2 <> 0)) then begin

                            rMomentsAssessment.Reset;
                            rMomentsAssessment.SetRange("Moment Code", pMoment);
                            rMomentsAssessment.SetRange("School Year", pSchoolYear);
                            rMomentsAssessment.SetRange("Schooling Year", LastSchoolingYear);
                            if rMomentsAssessment.FindFirst then;

                            Total := 0;
                            case rAssessementConfiguration."PA Group Sub. Classification" of
                                rAssessementConfiguration."PA Group Sub. Classification"::"Sub-Subject (Vertical) ":
                                    begin
                                        if ((TotalSubject <> 0) or (TotalSubSubject <> 0)) and ((TotalPonderSubj <> 0) or (TotalPonderSubSubj <> 0)) then
                                            Total := Round((TotalSubject + TotalSubSubject) / (TotalPonderSubj + TotalPonderSubSubj),
                                                         rAssessementConfiguration."PA Group Sub. Round Method");
                                        ;
                                        if Total <> 0 then
                                            InsertFinalClassification(pClass,
                                                                 pSchoolYear,
                                                                 LastSchoolingYear,
                                                                 //LastSubject,
                                                                 '',
                                                                 '',
                                                                 StudyPlanCourse,
                                                                 pStudent,
                                                                 rMomentsAssessment."Evaluation Moment",
                                                                 pMoment,
                                                                 Total,
                                                                 rClass.Type,
                                                                 LastOptionGroup,
                                                                 rCourseLines."Country/Region Code",
                                                                 3,
                                                                 0);

                                        //Vai guardar a classificação do grupo para utilizar no calculo da nota final
                                        if Total <> 0 then begin
                                            rGroupSubjects.Reset;
                                            rGroupSubjects.SetRange(Code, LastOptionGroup);
                                            rGroupSubjects.SetRange("Schooling Year", LastSchoolingYear);
                                            rGroupSubjects.SetRange("Country/Region Code", rClass."Country/Region Code");
                                            if rGroupSubjects.FindFirst then begin
                                                rGroupSubjects.TestField("Assessment Code");
                                                TotalOption += Total * rGroupSubjects.Ponder;
                                                TotalPonderOption += rGroupSubjects.Ponder;
                                            end else begin
                                                rGroupSubjects.Reset;
                                                rGroupSubjects.SetRange(Code, LastOptionGroup);
                                                rGroupSubjects.SetFilter("Schooling Year", '%1', '');
                                                rGroupSubjects.SetRange("Country/Region Code", rClass."Country/Region Code");
                                                if rGroupSubjects.FindFirst then begin
                                                    rGroupSubjects.TestField("Assessment Code");
                                                    TotalOption += Total * rGroupSubjects.Ponder;
                                                    TotalPonderOption += rGroupSubjects.Ponder;
                                                end;
                                            end;
                                        end;


                                        TotalSubSubjectFinal += TotalSubSubject;
                                        TotalPonderSubSubjFinal += TotalPonderSubSubj;
                                        TotalSubjectFinal += TotalSubject;
                                        TotalPonderSubjFinal += TotalPonderSubj;
                                        TotalSubject2Final += TotalSubject2;
                                        TotalPonderSubj2Final += TotalPonderSubj2;

                                        TotalSubSubject := 0;
                                        TotalPonderSubSubj := 0;
                                        TotalSubject := 0;
                                        TotalPonderSubj := 0;
                                        TotalSubject2 := 0;
                                        TotalPonderSubj2 := 0;

                                    end;
                                rAssessementConfiguration."PA Group Sub. Classification"::"Subject (Vertical)":
                                    begin
                                        if ((TotalSubject <> 0) or (TotalSubject2 <> 0)) and ((TotalPonderSubj <> 0) or (TotalPonderSubj2 <> 0)) then
                                            Total := Round((TotalSubject + TotalSubject2) / (TotalPonderSubj + TotalPonderSubj2),
                                                         rAssessementConfiguration."PA Group Sub. Round Method");

                                        if Total <> 0 then
                                            InsertFinalClassification(pClass,
                                                                 pSchoolYear,
                                                                 LastSchoolingYear,
                                                                 //LastSubject,
                                                                 '',
                                                                 '',
                                                                 StudyPlanCourse,
                                                                 pStudent,
                                                                 rMomentsAssessment."Evaluation Moment",
                                                                 pMoment,
                                                                 Total,
                                                                 rClass.Type,
                                                                 LastOptionGroup,
                                                                 rCourseLines."Country/Region Code",
                                                                 3,
                                                                 0);
                                        //Vai guardar a classificação do grupo para utilizar no calculo da nota final
                                        if Total <> 0 then begin
                                            rGroupSubjects.Reset;
                                            rGroupSubjects.SetRange(Code, LastOptionGroup);
                                            rGroupSubjects.SetRange("Schooling Year", LastSchoolingYear);
                                            rGroupSubjects.SetRange("Country/Region Code", rClass."Country/Region Code");
                                            if rGroupSubjects.FindFirst then begin
                                                rGroupSubjects.TestField("Assessment Code");
                                                TotalOption += Total * rGroupSubjects.Ponder;
                                                TotalPonderOption += rGroupSubjects.Ponder;
                                            end else begin
                                                rGroupSubjects.Reset;
                                                rGroupSubjects.SetRange(Code, LastOptionGroup);
                                                rGroupSubjects.SetFilter("Schooling Year", '%1', '');
                                                rGroupSubjects.SetRange("Country/Region Code", rClass."Country/Region Code");
                                                if rGroupSubjects.FindFirst then begin
                                                    rGroupSubjects.TestField("Assessment Code");
                                                    TotalOption += Total * rGroupSubjects.Ponder;
                                                    TotalPonderOption += rGroupSubjects.Ponder;
                                                end;
                                            end;
                                        end;


                                        TotalSubSubjectFinal += TotalSubSubject;
                                        TotalPonderSubSubjFinal += TotalPonderSubSubj;
                                        TotalSubjectFinal += TotalSubject;
                                        TotalPonderSubjFinal += TotalPonderSubj;
                                        TotalSubject2Final += TotalSubject2;
                                        TotalPonderSubj2Final += TotalPonderSubj2;

                                        TotalSubSubject := 0;
                                        TotalPonderSubSubj := 0;
                                        TotalSubject := 0;
                                        TotalPonderSubj := 0;
                                        TotalSubject2 := 0;
                                        TotalPonderSubj2 := 0;
                                    end;
                            end;
                        end;

                        rCourseLines.CalcFields("Sub-Subject");
                        //Vai calcular a classificação com base nas subdisciplinas
                        if rCourseLines."Sub-Subject" then begin
                            rStudyPlanSubSubjectsLines.Reset;
                            rStudyPlanSubSubjectsLines.SetRange(Type, rClass.Type);
                            rStudyPlanSubSubjectsLines.SetRange(Code, rCourseLines.Code);
                            rStudyPlanSubSubjectsLines.SetRange("Subject Code", rCourseLines."Subject Code");
                            if rStudyPlanSubSubjectsLines.FindSet then
                                repeat
                                    rAssessingStudents.Reset;
                                    rAssessingStudents.SetRange(Class, pClass);
                                    rAssessingStudents.SetRange("School Year", pSchoolYear);
                                    rAssessingStudents.SetRange("Moment Code", pMoment);
                                    rAssessingStudents.SetRange(Subject, rCourseLines."Subject Code");
                                    rAssessingStudents.SetRange("Sub-Subject Code", rStudyPlanSubSubjectsLines."Sub-Subject Code");
                                    rAssessingStudents.SetRange("Student Code No.", pStudent);
                                    if rAssessingStudents.FindSet then
                                        repeat
                                            // Change 12-04-2010
                                            if rAssessingStudents."Recuperation Grade" = 0 then begin
                                                TotalPonderSubSubj += cCalcEvaluations.GetSubSettingRattingPonder(rAssessingStudents);
                                                TotalSubSubject += rAssessingStudents.Grade
                                                                 * cCalcEvaluations.GetSubSettingRattingPonder(rAssessingStudents);
                                            end else begin
                                                TotalPonderSubSubj +=
                                                   cCalcEvaluations.GetSubSettingRattingPonder(rAssessingStudents);
                                                TotalSubSubject += rAssessingStudents."Recuperation Grade"
                                                                * cCalcEvaluations.GetSubSettingRattingPonder(rAssessingStudents);
                                            end;
                                        until rAssessingStudents.Next = 0;
                                until rStudyPlanSubSubjectsLines.Next = 0;

                            rAssessingStudents.Reset;
                            rAssessingStudents.SetRange(Class, pClass);
                            rAssessingStudents.SetRange("School Year", pSchoolYear);
                            rAssessingStudents.SetRange("Moment Code", pMoment);
                            rAssessingStudents.SetRange(Subject, rCourseLines."Subject Code");
                            rAssessingStudents.SetFilter("Sub-Subject Code", '%1', '');
                            rAssessingStudents.SetRange("Student Code No.", pStudent);
                            if rAssessingStudents.FindSet then
                                repeat
                                    // Change 05-12-2008
                                    //TotalPonderSubj2 += rCourseLines.Weighting;
                                    TotalPonderSubj2 += cCalcEvaluations.GetSettingRatting(rAssessingStudents);
                                    if rAssessingStudents."Recuperation Grade" = 0 then
                                        //TotalSubject2 += rAssessingStudents.Grade * rCourseLines.Weighting
                                        TotalSubject2 += rAssessingStudents.Grade
                                              * cCalcEvaluations.GetSettingRatting(rAssessingStudents)

                                    else
                                        // TotalSubject2 += rAssessingStudents."Recuperation Grade" * rCourseLines.Weighting;
                                        TotalSubject2 += rAssessingStudents."Recuperation Grade"
                                          * cCalcEvaluations.GetSettingRatting(rAssessingStudents);
                                until rAssessingStudents.Next = 0;

                        end else begin
                            rAssessingStudents.Reset;
                            rAssessingStudents.SetRange(Class, pClass);
                            rAssessingStudents.SetRange("School Year", pSchoolYear);
                            rAssessingStudents.SetRange("Moment Code", pMoment);
                            rAssessingStudents.SetRange(Subject, rCourseLines."Subject Code");
                            rAssessingStudents.SetFilter("Sub-Subject Code", '%1', '');
                            rAssessingStudents.SetRange("Student Code No.", pStudent);
                            if rAssessingStudents.FindSet then
                                repeat
                                    //Change 05-12-2008
                                    //TotalPonderSubj += rCourseLines.Weighting;
                                    TotalPonderSubj += cCalcEvaluations.GetSettingRatting(rAssessingStudents);
                                    if rAssessingStudents."Recuperation Grade" = 0 then
                                        //TotalSubject += rAssessingStudents.Grade * rCourseLines.Weighting
                                        TotalSubject += rAssessingStudents.Grade *
                                              cCalcEvaluations.GetSettingRatting(rAssessingStudents)
                                    else
                                        //TotalSubject += rAssessingStudents."Recuperation Grade" * rCourseLines.Weighting;
                                        TotalSubject += rAssessingStudents."Recuperation Grade" *
                                             cCalcEvaluations.GetSettingRatting(rAssessingStudents)
                                until rAssessingStudents.Next = 0;
                        end;

                        LastOptionGroup := rCourseLines."Option Group";
                        LastSubject := rCourseLines."Subject Code";
                        LastSchoolingYear := rClass."Schooling Year";

                    until rCourseLines.Next = 0;
            end;
        end;

        Total := 0;
        //Lança a nota do ultimo grupo de disciplinas
        rMomentsAssessment.Reset;
        rMomentsAssessment.SetRange("Moment Code", pMoment);
        rMomentsAssessment.SetRange("School Year", pSchoolYear);
        rMomentsAssessment.SetRange("Schooling Year", LastSchoolingYear);
        if rMomentsAssessment.FindFirst then;

        case rAssessementConfiguration."PA Group Sub. Classification" of
            rAssessementConfiguration."PA Group Sub. Classification"::"Sub-Subject (Vertical) ":
                begin
                    if (TotalPonderSubSubj <> 0) then
                        //((TotalSubject <> 0) OR (TotalSubSubject <> 0)) AND ((TotalPonderSubj <>0) OR
                        Total := Round(TotalSubSubject / TotalPonderSubSubj,
                            rAssessementConfiguration."PA Group Sub. Round Method");
                    ;
                    if Total <> 0 then
                        InsertFinalClassification(pClass,
                                             pSchoolYear,
                                             LastSchoolingYear,
                                             //LastSubject,
                                             '',
                                             '',
                                             StudyPlanCourse,
                                             pStudent,
                                             rMomentsAssessment."Evaluation Moment",
                                             pMoment,
                                             Total,
                                             rClass.Type,
                                             LastOptionGroup,
                                             CountryRegionCode,
                                             3,
                                             0);

                    //Vai guardar a classificação do grupo para utilizar no calculo da nota final
                    if Total <> 0 then begin
                        rGroupSubjects.Reset;
                        rGroupSubjects.SetRange(Code, LastOptionGroup);
                        rGroupSubjects.SetRange("Schooling Year", LastSchoolingYear);
                        rGroupSubjects.SetRange("Country/Region Code", rClass."Country/Region Code");
                        if rGroupSubjects.FindFirst then begin
                            TotalOption += Total * rGroupSubjects.Ponder;
                            TotalPonderOption += rGroupSubjects.Ponder;
                        end else begin
                            rGroupSubjects.Reset;
                            rGroupSubjects.SetRange(Code, LastOptionGroup);
                            rGroupSubjects.SetFilter("Schooling Year", '%1', '');
                            rGroupSubjects.SetRange("Country/Region Code", rClass."Country/Region Code");
                            if rGroupSubjects.FindFirst then begin
                                TotalOption += Total * rGroupSubjects.Ponder;
                                TotalPonderOption += rGroupSubjects.Ponder;
                            end;
                        end;
                    end;


                    TotalSubSubjectFinal += TotalSubSubject;
                    TotalPonderSubSubjFinal += TotalPonderSubSubj;
                    TotalSubjectFinal += TotalSubject;
                    TotalPonderSubjFinal += TotalPonderSubj;
                    TotalSubject2Final += TotalSubject2;
                    TotalPonderSubj2Final += TotalPonderSubj2;

                    TotalSubSubject := 0;
                    TotalPonderSubSubj := 0;
                    TotalSubject := 0;
                    TotalPonderSubj := 0;
                    TotalSubject2 := 0;
                    TotalPonderSubj2 := 0;

                end;
            rAssessementConfiguration."PA Group Sub. Classification"::"Subject (Vertical)":
                begin
                    if ((TotalSubject <> 0) or (TotalSubject2 <> 0)) and ((TotalPonderSubj <> 0) or (TotalPonderSubj2 <> 0)) then
                        Total := Round((TotalSubject + TotalSubject2) / (TotalPonderSubj + TotalPonderSubj2),
                                     rAssessementConfiguration."PA Group Sub. Round Method");

                    if Total <> 0 then
                        InsertFinalClassification(pClass,
                                             pSchoolYear,
                                             LastSchoolingYear,
                                             //LastSubject,
                                             '',
                                             '',
                                             StudyPlanCourse,
                                             pStudent,
                                             rMomentsAssessment."Evaluation Moment",
                                             pMoment,
                                             Total,
                                             rClass.Type,
                                             LastOptionGroup,
                                             CountryRegionCode,
                                             3,
                                             0);

                    //Vai guardar a classificação do grupo para utilizar no calculo da nota final
                    if Total <> 0 then begin
                        rGroupSubjects.Reset;
                        rGroupSubjects.SetRange(Code, LastOptionGroup);
                        rGroupSubjects.SetRange("Schooling Year", LastSchoolingYear);
                        rGroupSubjects.SetRange("Country/Region Code", rClass."Country/Region Code");
                        if rGroupSubjects.FindFirst then begin
                            TotalOption += Total * rGroupSubjects.Ponder;
                            TotalPonderOption += rGroupSubjects.Ponder;
                        end else begin
                            rGroupSubjects.Reset;
                            rGroupSubjects.SetRange(Code, LastOptionGroup);
                            rGroupSubjects.SetFilter("Schooling Year", '%1', '');
                            rGroupSubjects.SetRange("Country/Region Code", rClass."Country/Region Code");
                            if rGroupSubjects.FindFirst then begin
                                TotalOption += Total * rGroupSubjects.Ponder;
                                TotalPonderOption += rGroupSubjects.Ponder;
                            end;
                        end;
                    end;


                    TotalSubSubjectFinal += TotalSubSubject;
                    TotalPonderSubSubjFinal += TotalPonderSubSubj;
                    TotalSubjectFinal += TotalSubject;
                    TotalPonderSubjFinal += TotalPonderSubj;
                    TotalSubject2Final += TotalSubject2;
                    TotalPonderSubj2Final += TotalPonderSubj2;

                    TotalSubSubject := 0;
                    TotalPonderSubSubj := 0;
                    TotalSubject := 0;
                    TotalPonderSubj := 0;
                    TotalSubject2 := 0;
                    TotalPonderSubj2 := 0;
                end;
        end;

        Total := 0;
        //Lança a nota final de momento do aluno.
        case rAssessementConfiguration."PA Final Classification" of
            rAssessementConfiguration."PA Final Classification"::"Group (Vertical)":
                begin
                    if (TotalOption <> 0) and (TotalPonderOption <> 0) then
                        Total := Round((TotalOption) / (TotalPonderOption),
                                     rAssessementConfiguration."PA Final Round Method");
                    ;
                    if Total <> 0 then
                        InsertFinalClassification(pClass,
                                             pSchoolYear,
                                             LastSchoolingYear,
                                             //LastSubject,
                                             '',
                                             '',
                                             StudyPlanCourse,
                                             pStudent,
                                             rMomentsAssessment."Evaluation Moment",
                                             pMoment,
                                             Total,
                                             rClass.Type,
                                             '',
                                             CountryRegionCode,
                                             2,
                                             0);
                end;
            rAssessementConfiguration."PA Final Classification"::"Sub-Subject (Vertical)":
                begin
                    //IF ((TotalSubjectFinal <> 0) OR (TotalSubSubjectFinal <> 0)) AND
                    //   ((TotalPonderSubjFinal <>0) OR
                    if (TotalPonderSubSubjFinal <> 0) then
                        Total := Round((TotalSubSubjectFinal) / (TotalPonderSubSubjFinal),
                                    rAssessementConfiguration."PA Final Round Method");
                    ;
                    if Total <> 0 then
                        InsertFinalClassification(pClass,
                                             pSchoolYear,
                                             LastSchoolingYear,
                                             //LastSubject,
                                             '',
                                             '',
                                             StudyPlanCourse,
                                             pStudent,
                                             rMomentsAssessment."Evaluation Moment",
                                             pMoment,
                                             Total,
                                             rClass.Type,
                                             '',
                                             CountryRegionCode,
                                             2,
                                             0);
                end;
            rAssessementConfiguration."PA Final Classification"::"Subject (Vertical)":
                begin
                    if ((TotalSubjectFinal <> 0) or (TotalSubject2Final <> 0)) and ((TotalPonderSubjFinal <> 0) or (TotalPonderSubj2Final <> 0))
               then
                        Total := Round((TotalSubjectFinal + TotalSubject2Final) / (TotalPonderSubjFinal + TotalPonderSubj2Final),
                                        rAssessementConfiguration."PA Final Round Method");
                    if Total <> 0 then
                        InsertFinalClassification(pClass,
                                             pSchoolYear,
                                             LastSchoolingYear,
                                             //LastSubject,
                                             '',
                                             '',
                                             StudyPlanCourse,
                                             pStudent,
                                             rMomentsAssessment."Evaluation Moment",
                                             pMoment,
                                             Total,
                                             rClass.Type,
                                             '',
                                             CountryRegionCode,
                                             2,
                                             0);
                end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure InsertFinalClassification(pClass: Code[20]; pSchoolYear: Code[20]; pSchoolingYear: Code[20]; pSubject: Code[20]; pSubSubject: Code[20]; pStudyPlan: Code[20]; pStudent: Code[20]; pEvaluationMoment: Integer; pMoment: Code[20]; pGrade: Decimal; pTypeEducation: Integer; pOptionGroup: Code[20]; pCountryRegionCode: Code[20]; pEvaluationType: Integer; pRulesEntryNo: Integer)
    var
        AssessingStudentsFinal: Record "Assessing Students Final";
        l_OptionGroup: Record "Group Subjects";
        l_RegistrationClass: Record "Registration Class";
        l_rAssessingStudentsFinal: Record "Assessing Students Final";
    begin
        AssessingStudentsFinal.LockTable(true);

        l_rAssessingStudentsFinal.Reset;
        l_rAssessingStudentsFinal.SetRange(Class, pClass);
        l_rAssessingStudentsFinal.SetRange("School Year", pSchoolYear);
        l_rAssessingStudentsFinal.SetRange("Moment Code", pMoment);
        l_rAssessingStudentsFinal.SetRange("Student Code No.", pStudent);
        l_rAssessingStudentsFinal.SetRange("Schooling Year", pSchoolingYear);
        l_rAssessingStudentsFinal.SetRange("Option Group", pOptionGroup);
        l_rAssessingStudentsFinal.SetRange(Subject, pSubject);
        l_rAssessingStudentsFinal.SetRange("Evaluation Type", pEvaluationType);
        l_rAssessingStudentsFinal.SetRange("Sub-Subject Code", pSubSubject);
        l_rAssessingStudentsFinal.SetRange("Study Plan Code", pStudyPlan);
        l_rAssessingStudentsFinal.SetRange("Evaluation Moment", pEvaluationMoment);
        if l_rAssessingStudentsFinal.FindFirst then
            AssessingStudentsFinal.TransferFields(l_rAssessingStudentsFinal)
        else
            AssessingStudentsFinal.Init;

        AssessingStudentsFinal."Evaluation Type" := pEvaluationType;

        if ((AssessingStudentsFinal."Evaluation Type" = AssessingStudentsFinal."Evaluation Type"::"Final Year Group") or
          (AssessingStudentsFinal."Evaluation Type" = AssessingStudentsFinal."Evaluation Type"::"Final Moment Group")) and
          (pOptionGroup = '') then
            exit;

        AssessingStudentsFinal.Class := pClass;
        AssessingStudentsFinal."School Year" := pSchoolYear;
        AssessingStudentsFinal."Schooling Year" := pSchoolingYear;
        AssessingStudentsFinal."Moment Code" := pMoment;
        AssessingStudentsFinal."Option Group" := pOptionGroup;
        AssessingStudentsFinal.Subject := pSubject;
        AssessingStudentsFinal."Sub-Subject Code" := pSubSubject;
        AssessingStudentsFinal."Study Plan Code" := pStudyPlan;
        AssessingStudentsFinal."Student Code No." := pStudent;
        AssessingStudentsFinal."Evaluation Moment" := pEvaluationMoment;
        AssessingStudentsFinal.Grade := pGrade;

        l_RegistrationClass.Reset;
        l_RegistrationClass.SetRange(Class, pClass);
        l_RegistrationClass.SetRange("School Year", pSchoolYear);
        l_RegistrationClass.SetRange("Schooling Year", pSchoolingYear);
        l_RegistrationClass.SetRange("Student Code No.", pStudent);
        l_RegistrationClass.SetRange(Type, pTypeEducation);
        l_RegistrationClass.SetRange("Study Plan Code", pStudyPlan);
        if l_RegistrationClass.FindFirst then
            AssessingStudentsFinal."Class No." := l_RegistrationClass."Class No.";

        if (AssessingStudentsFinal."Evaluation Type" = AssessingStudentsFinal."Evaluation Type"::"Final Moment Group")
         or (AssessingStudentsFinal."Evaluation Type" = AssessingStudentsFinal."Evaluation Type"::"Final Year Group") then begin
            if pTypeEducation = 1 then begin
                l_OptionGroup.Reset;
                l_OptionGroup.SetRange(Code, pOptionGroup);
                l_OptionGroup.SetRange("Schooling Year", '');
                if l_OptionGroup.FindFirst then;
            end;
            if pTypeEducation = 0 then
                if l_OptionGroup.Get(pOptionGroup, pSchoolingYear) then;
            if (l_OptionGroup."Evaluation Type" = l_OptionGroup."Evaluation Type"::"Mixed-Qualification") then
                AssessingStudentsFinal."Qualitative Grade" := ValidateAssessmentMixed(pGrade, l_OptionGroup."Assessment Code");
        end;


        AssessingStudentsFinal."Type Education" := pTypeEducation;
        AssessingStudentsFinal."Country/Region Code" := pCountryRegionCode;
        AssessingStudentsFinal."Rule Entry No." := pRulesEntryNo;

        if (AssessingStudentsFinal."Evaluation Type" = AssessingStudentsFinal."Evaluation Type"::"Final Moment") or
            (AssessingStudentsFinal."Evaluation Type" = AssessingStudentsFinal."Evaluation Type"::"Final Year") then begin
            AssessingStudentsFinal."Qualitative Grade" := GetAssessmentEvaluation(AssessingStudentsFinal);
        end;
        if not AssessingStudentsFinal.Insert(true) then
            AssessingStudentsFinal.Modify(true);
    end;

    //[Scope('OnPrem')]
    procedure InsertClassification(pClass: Code[20]; pSchoolYear: Code[20]; pSchoolingYear: Code[20]; pSubject: Code[20]; pSubSubject: Code[20]; pStudyPlan: Code[20]; pStudent: Code[20]; pEvaluationMoment: Integer; pMoment: Code[20]; pGrade: Decimal; pTypeEducation: Integer; pCountryRegionCode: Code[20]; pEvaluationType: Integer; pAssessmentCode: Code[20])
    var
        AssessingStudents: Record "Assessing Students";
        l_rAssessingStudents: Record "Assessing Students";
        l_RegistrationClass: Record "Registration Class";
        lCourseLines: Record "Course Lines";
        lStudyPlanSubSubjectsLines: Record "Study Plan Sub-Subjects Lines";
        lStudyPlanLines: Record "Study Plan Lines";
    begin
        AssessingStudents.LockTable(true);

        l_rAssessingStudents.Reset;
        l_rAssessingStudents.SetRange(Class, pClass);
        l_rAssessingStudents.SetRange("School Year", pSchoolYear);
        l_rAssessingStudents.SetRange("Moment Code", pMoment);
        l_rAssessingStudents.SetRange("Student Code No.", pStudent);
        l_rAssessingStudents.SetRange("Schooling Year", pSchoolingYear);
        l_rAssessingStudents.SetRange(Subject, pSubject);
        l_rAssessingStudents.SetRange("Type Education", pTypeEducation);
        l_rAssessingStudents.SetRange("Sub-Subject Code", pSubSubject);
        l_rAssessingStudents.SetRange("Study Plan Code", pStudyPlan);
        l_rAssessingStudents.SetRange("Evaluation Moment", pEvaluationMoment);
        if l_rAssessingStudents.FindFirst then
            AssessingStudents.TransferFields(l_rAssessingStudents)
        else
            AssessingStudents.Init;


        AssessingStudents.Class := pClass;
        AssessingStudents."School Year" := pSchoolYear;
        AssessingStudents."Schooling Year" := pSchoolingYear;
        AssessingStudents."Moment Code" := pMoment;
        AssessingStudents.Subject := pSubject;
        AssessingStudents."Sub-Subject Code" := pSubSubject;
        AssessingStudents."Study Plan Code" := pStudyPlan;
        AssessingStudents."Student Code No." := pStudent;
        AssessingStudents."Evaluation Moment" := pEvaluationMoment;


        l_RegistrationClass.Reset;
        l_RegistrationClass.SetRange(Class, pClass);
        l_RegistrationClass.SetRange("School Year", pSchoolYear);
        l_RegistrationClass.SetRange("Schooling Year", pSchoolingYear);
        l_RegistrationClass.SetRange("Student Code No.", pStudent);
        l_RegistrationClass.SetRange(Type, pTypeEducation);
        l_RegistrationClass.SetRange("Study Plan Code", pStudyPlan);
        if l_RegistrationClass.FindFirst then
            AssessingStudents."Class No." := l_RegistrationClass."Class No.";
        /*
        if (l_RegistrationClass.Type = l_RegistrationClass.Type::Simple) and (pSubSubject = '') then begin
        
           lStudyPlanLines.reset;
           lStudyPlanLines.setrange(Code,pStudyPlan);
           lStudyPlanLines.setrange("School Year",pSchoolYear);
           lStudyPlanLines.setrange("Schooling Year",pSchoolingYear);
           lStudyPlanLines.setrange("Subject Code",pSubject);
           if lStudyPlanLines.findset then begin
             pEvaluationType := lStudyPlanLines."Evaluation Type";
             pAssessmentCode := lStudyPlanLines."Assessment Code";
           end;
        end;
        
        if (l_RegistrationClass.Type = l_RegistrationClass.Type::multi) and (pSubSubject = '') then begin
        
           lCourseLines.reset;
           lCourseLines.setrange(Code,pStudyPlan);
           lCourseLines.setrange("Subject Code",pSubject);
           if lCourseLines.findset then begin
             lEvaluationType := lCourseLines."Evaluation Type";
             lAssessmentCode := lCourselines."Assessment Code";
           end;
        
        end;
        
        if pSubSubject <> '' then begin
           lStudyPlanSubSubjectsLines.reset;
           lStudyPlanSubSubjectsLines.setrange(Type,l_RegistrationClass.Type);
           lStudyPlanSubSubjectsLines.setrange(Code,pStudyPlan);
           lStudyPlanSubSubjectsLines.setrange("Schooling Year",pSchoolingYear);
           lStudyPlanSubSubjectsLines.setrange("Subject Code",pSubject);
           lStudyPlanSubSubjectsLines.setrange("Sub-Subject Code",pSubSubject);
           lStudyPlanSubSubjectsLines.setrange("School Year",pSchoolYear);
           IF lStudyPlanSubSubjectsLines.FINDSET THEN begin
             lEvaluationType := lStudyPlanSubSubjectsLines."Evaluation Type";
             lAssessmentCode := lStudyPlanSubSubjectsLines."Assessment Code";
           end;
        
        end;
        */
        case pEvaluationType of
            //Qualitative
            1:
                begin
                    AssessingStudents."Grade Calc" := pGrade;
                end;
            //Quantitative
            2:
                begin
                    //Does not have calculated evaluation
                end;
            //mixed qualification
            4:
                begin
                    AssessingStudents."Grade Calc" := pGrade;
                    AssessingStudents."Qualitative Grade Calc" := ValidateAssessmentMixed(pGrade, pAssessmentCode);
                end;
        end;

        AssessingStudents."Type Education" := pTypeEducation;
        AssessingStudents."Country/Region Code" := pCountryRegionCode;

        if not AssessingStudents.Insert(true) then
            AssessingStudents.Modify(true);

    end;

    //[Scope('OnPrem')]
    procedure InsertAspects()
    var
        rGeneralTableAspects: Record GeneralTableAspects;
        rGeneralTable: Record GeneralTable;
        rAssessingStudentsAspects: Record "Assessing Students Aspects";
        rMomentsAssessment: Record "Moments Assessment";
        rSchoolYear: Record "School Year";
        rClass: Record Class;
        rStudentSubjects: Record "Registration Subjects";
        rClassificationLevel: Record "Classification Level";
        Window: Dialog;
        nreg: Integer;
        TotalReg: Integer;
        GradeTXT: Text[30];
        GradeDec: Decimal;
        Text001: Label 'Update Aspects\ @1@@@@@@@@@@@@@';
        l_AssStudentsAspInsert: Record "Assessing Students Aspects";
    begin
        //Passa os dados da General table Aspects para a tabela de classificações Aspects do NAV
        rSchoolYear.Reset;
        rSchoolYear.SetRange(Status, rSchoolYear.Status::Active);
        if rSchoolYear.Find('-') then begin
            Window.Open(Text001);
            rAssessingStudentsAspects.LockTable(true);
            rMomentsAssessment.Reset;
            rMomentsAssessment.SetRange(Active, true);
            rMomentsAssessment.SetRange("School Year", rSchoolYear."School Year");
            if rMomentsAssessment.Find('-') then begin
                TotalReg := rMomentsAssessment.Count;
                repeat
                    nreg += 1;
                    rClass.Reset;
                    rClass.SetRange("School Year", rMomentsAssessment."School Year");
                    rClass.SetRange("Schooling Year", rMomentsAssessment."Schooling Year");
                    if rClass.Find('-') then
                        repeat
                            rGeneralTableAspects.Reset;
                            rGeneralTableAspects.SetCurrentKey("School Year", Class, Moment);
                            rGeneralTableAspects.SetRange("School Year", rSchoolYear."School Year");
                            rGeneralTableAspects.SetRange(Class, rClass.Class);
                            rGeneralTableAspects.SetRange(Moment, rMomentsAssessment."Moment Code");
                            if rGeneralTableAspects.Find('-') then
                                repeat
                                    Window.Update(1, Round(nreg / TotalReg * 10000, 1));
                                    if rGeneralTable.Get(rGeneralTableAspects."Study Plan Entry No.") then begin
                                        rAssessingStudentsAspects.Reset;
                                        rAssessingStudentsAspects.SetRange(Class, rClass.Class);
                                        rAssessingStudentsAspects.SetRange("School Year", rClass."School Year");
                                        rAssessingStudentsAspects.SetRange("Schooling Year", rClass."Schooling Year");
                                        rAssessingStudentsAspects.SetRange(Subject, rGeneralTableAspects.Subject);
                                        if rGeneralTable."Is SubSubject" then
                                            rAssessingStudentsAspects.SetRange("Sub-Subject Code", rGeneralTable."Sub Subject")
                                        else
                                            rAssessingStudentsAspects.SetRange("Sub-Subject Code", '');
                                        rAssessingStudentsAspects.SetRange("Student Code No.", rGeneralTableAspects.Student);
                                        rAssessingStudentsAspects.SetRange("Moment Code", rMomentsAssessment."Moment Code");
                                        rAssessingStudentsAspects.SetRange("Study Plan Code", rClass."Study Plan Code");
                                        rAssessingStudentsAspects.SetRange("Aspects Code", rGeneralTableAspects.Aspect);
                                        if rAssessingStudentsAspects.Find('-') then begin

                                            case rGeneralTableAspects."Evaluation Type" of
                                                rGeneralTableAspects."Evaluation Type"::Qualitative:
                                                    begin
                                                        rAssessingStudentsAspects."Qualitative Grade" := rGeneralTableAspects.GradeManual;
                                                        rAssessingStudentsAspects."Qualitative Grade Calc" := rGeneralTableAspects.GradeAuto;
                                                    end;
                                                rGeneralTableAspects."Evaluation Type"::Quantitative:
                                                    begin
                                                        GradeTXT := rGeneralTableAspects.GradeManual;
                                                        if GradeTXT <> '' then begin
                                                            Evaluate(GradeDec, GradeTXT);
                                                            rAssessingStudentsAspects.Grade := GradeDec;
                                                        end;
                                                        GradeTXT := rGeneralTableAspects.GradeAuto;
                                                        if GradeTXT <> '' then begin
                                                            Evaluate(GradeDec, GradeTXT);
                                                            rAssessingStudentsAspects."Grade Calc" := GradeDec;
                                                        end;
                                                    end;
                                                rGeneralTableAspects."Evaluation Type"::"Mixed-Qualification":
                                                    begin
                                                        GradeTXT := rGeneralTableAspects.GradeManual;
                                                        if GradeTXT <> '' then begin
                                                            Evaluate(GradeDec, GradeTXT);
                                                            rAssessingStudentsAspects.Grade := GradeDec;
                                                        end;
                                                        GradeTXT := rGeneralTableAspects.GradeAuto;
                                                        if GradeTXT <> '' then begin
                                                            Evaluate(GradeDec, GradeTXT);
                                                            rAssessingStudentsAspects."Grade Calc" := GradeDec;
                                                        end;
                                                        rClassificationLevel.Reset;
                                                        rClassificationLevel.SetRange("Classification Group Code", rGeneralTableAspects."Assessment Code");
                                                        if rClassificationLevel.Find('-') then begin
                                                            repeat
                                                                if (rClassificationLevel."Min Value" <= rAssessingStudentsAspects.Grade) and
                                                                   (rClassificationLevel."Max Value" >= rAssessingStudentsAspects.Grade) then
                                                                    rAssessingStudentsAspects."Qualitative Grade" :=
                                                                        rClassificationLevel."Classification Level Code";
                                                            until rClassificationLevel.Next = 0
                                                        end;
                                                    end;
                                            end;
                                            rAssessingStudentsAspects.Modify;
                                        end else begin
                                            if (rGeneralTableAspects.GradeManual <> '') or (rGeneralTableAspects.GradeAuto <> '') then begin
                                                l_AssStudentsAspInsert.Init;
                                                l_AssStudentsAspInsert.Class := rClass.Class;
                                                l_AssStudentsAspInsert."School Year" := rClass."School Year";
                                                l_AssStudentsAspInsert."Schooling Year" := rClass."Schooling Year";
                                                l_AssStudentsAspInsert.Subject := rGeneralTableAspects.Subject;
                                                if rGeneralTable."Is SubSubject" then
                                                    l_AssStudentsAspInsert."Sub-Subject Code" := rGeneralTableAspects."Sub Subject"
                                                else
                                                    l_AssStudentsAspInsert."Sub-Subject Code" := '';
                                                l_AssStudentsAspInsert."Study Plan Code" := rClass."Study Plan Code";
                                                l_AssStudentsAspInsert."Student Code No." := rGeneralTableAspects.Student;
                                                l_AssStudentsAspInsert."Moment Code" := rMomentsAssessment."Moment Code";
                                                l_AssStudentsAspInsert."Aspects Code" := rGeneralTableAspects.Aspect;

                                                rStudentSubjects.Reset;
                                                rStudentSubjects.SetRange("Student Code No.", rGeneralTableAspects.Student);
                                                rStudentSubjects.SetRange("School Year", rClass."School Year");
                                                rStudentSubjects.SetRange("Subjects Code", rGeneralTableAspects.Subject);
                                                rStudentSubjects.SetRange(Class, rGeneralTableAspects.Class);
                                                if rStudentSubjects.Find('-') then
                                                    l_AssStudentsAspInsert."Class No." := rStudentSubjects."Class No.";

                                                l_AssStudentsAspInsert."Evaluation Moment" := rMomentsAssessment."Evaluation Moment";

                                                case rGeneralTableAspects."Evaluation Type" of
                                                    rGeneralTableAspects."Evaluation Type"::Qualitative:
                                                        begin
                                                            l_AssStudentsAspInsert."Qualitative Grade" := rGeneralTableAspects.GradeManual;
                                                            l_AssStudentsAspInsert."Qualitative Grade Calc" := rGeneralTableAspects.GradeAuto;
                                                        end;
                                                    rGeneralTableAspects."Evaluation Type"::Quantitative:
                                                        begin
                                                            GradeTXT := rGeneralTableAspects.GradeManual;
                                                            if GradeTXT <> '' then begin
                                                                Evaluate(GradeDec, GradeTXT);
                                                                l_AssStudentsAspInsert.Grade := GradeDec;
                                                            end;
                                                            GradeTXT := rGeneralTableAspects.GradeAuto;
                                                            if GradeTXT <> '' then begin
                                                                Evaluate(GradeDec, GradeTXT);
                                                                l_AssStudentsAspInsert."Grade Calc" := GradeDec;
                                                            end;
                                                        end;
                                                    rGeneralTableAspects."Evaluation Type"::"Mixed-Qualification":
                                                        begin
                                                            GradeTXT := rGeneralTableAspects.GradeManual;
                                                            if GradeTXT <> '' then begin
                                                                Evaluate(GradeDec, GradeTXT);
                                                                l_AssStudentsAspInsert.Grade := GradeDec;
                                                            end;
                                                            GradeTXT := rGeneralTableAspects.GradeAuto;
                                                            if GradeTXT <> '' then begin
                                                                Evaluate(GradeDec, GradeTXT);
                                                                l_AssStudentsAspInsert."Grade Calc" := GradeDec;
                                                            end;
                                                            rClassificationLevel.Reset;
                                                            rClassificationLevel.SetRange("Classification Group Code", rGeneralTableAspects."Assessment Code");
                                                            if rClassificationLevel.Find('-') then begin
                                                                repeat
                                                                    if (rClassificationLevel."Min Value" <= rAssessingStudentsAspects.Grade) and
                                                                       (rClassificationLevel."Max Value" >= rAssessingStudentsAspects.Grade) then
                                                                        l_AssStudentsAspInsert."Qualitative Grade" :=
                                                                           rClassificationLevel."Classification Level Code";
                                                                until rClassificationLevel.Next = 0
                                                            end;
                                                        end;
                                                end;
                                                l_AssStudentsAspInsert."Type Education" := rClass.Type;
                                                l_AssStudentsAspInsert."Country/Region Code" := rClass."Country/Region Code";
                                                l_AssStudentsAspInsert.Insert;
                                            end;
                                        end;
                                    end;
                                until rGeneralTableAspects.Next = 0;
                        until rClass.Next = 0;
                until rMomentsAssessment.Next = 0;

                Window.Close;

            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure ValidateAssessmentMixed(InClassification: Decimal; pAssessmentCode: Code[20]) Out: Text[50]
    var
        varLocalClasification: Decimal;
        rClassificationLevelMin: Record "Classification Level";
        rClassificationLevelMax: Record "Classification Level";
        VarMinValue: Decimal;
        VarMaxValue: Decimal;
        rClassificationLevel: Record "Classification Level";
    begin
        if InClassification <> 0 then begin
            rClassificationLevelMin.Reset;
            rClassificationLevelMin.SetCurrentKey("Id Ordination");
            rClassificationLevelMin.Ascending(true);
            rClassificationLevelMin.SetRange("Classification Group Code", pAssessmentCode);
            if rClassificationLevelMin.FindFirst then
                VarMinValue := rClassificationLevelMin."Min Value";

            rClassificationLevelMax.Reset;
            rClassificationLevelMax.SetCurrentKey("Id Ordination");
            rClassificationLevelMax.Ascending(false);
            rClassificationLevelMax.SetRange("Classification Group Code", pAssessmentCode);
            if rClassificationLevelMax.FindFirst then
                VarMaxValue := rClassificationLevelMax."Max Value";

            if (VarMinValue <= InClassification) and
                (VarMaxValue >= InClassification) then begin
                rClassificationLevel.Reset;
                rClassificationLevel.SetRange("Classification Group Code", pAssessmentCode);
                rClassificationLevel.SetRange(Value, InClassification);
                if rClassificationLevel.FindSet(false, false) then
                    exit(rClassificationLevel."Classification Level Code");

                rClassificationLevel.Reset;
                rClassificationLevel.SetRange("Classification Group Code", pAssessmentCode);
                if rClassificationLevel.Find('-') then begin
                    repeat
                        if (rClassificationLevel."Min Value" <= InClassification) and
                           (rClassificationLevel."Max Value" >= InClassification) then
                            exit(rClassificationLevel."Classification Level Code");
                    until rClassificationLevel.Next = 0
                end;

            end;
        end;
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
        //IF pAssessingStudentsFinal."Evaluation Type" = pAssessingStudentsFinal."Evaluation Type"::"Final Moment" THEN
        //  l_AssessConf.SETRANGE("PA Evaluation Type",l_AssessConf."PA Evaluation Type"::"Mixed-Qualification");
        //IF pAssessingStudentsFinal."Evaluation Type" = pAssessingStudentsFinal."Evaluation Type"::"Final Year" THEN
        //  l_AssessConf.SETRANGE("FY Evaluation Type",l_AssessConf."FY Evaluation Type"::"Mixed-Qualification");
        if l_AssessConf.FindFirst then begin
            if pAssessingStudentsFinal."Evaluation Type" = pAssessingStudentsFinal."Evaluation Type"::"Final Moment" then
                exit(ValidateAssessmentMixed(pAssessingStudentsFinal.Grade, l_AssessConf."PA Assessment Code"));

            if pAssessingStudentsFinal."Evaluation Type" = pAssessingStudentsFinal."Evaluation Type"::"Final Year" then
                exit(ValidateAssessmentMixed(pAssessingStudentsFinal.Grade, l_AssessConf."FY Assessment Code"));
        end;
    end;

    //[Scope('OnPrem')]
    procedure CalcFinalYear(pClass: Code[20]; pSchoolYear: Code[20]; pMoment: Code[20]; pStudent: Code[20]; pEvaluationMoment: Integer)
    var
        rAssessingStudents: Record "Assessing Students";
        rAssessingStudentsSubSuj: Record "Assessing Students";
        rAssessingStudentsFinal: Record "Assessing Students Final";
        rStudyPlanHeader: Record "Study Plan Header";
        rStudyPlanLines: Record "Study Plan Lines";
        rCourseHeader: Record "Course Header";
        rCourseLines: Record "Course Lines";
        rClass: Record Class;
        rAssessementConfiguration: Record "Assessment Configuration";
        Text002: Label 'The Study Plan/Course %1 does not have Assessement Configuration';
        rStudyPlanSubSubjectsLines: Record "Study Plan Sub-Subjects Lines";
        rMomentsAssessment: Record "Moments Assessment";
        rGroupSubjects: Record "Group Subjects";
        lSettingRatingsSubSubjects: Record "Setting Ratings Sub-Subjects";
        lSettingRatings: Record "Setting Ratings";
        cCalcEvaluations: Codeunit "Calc. Evaluations";
        LastOptionGroup: Code[20];
        LastSubject: Code[20];
        LastSchoolingYear: Code[20];
        CountryRegionCode: Code[20];
        StudyPlanCourse: Code[20];
        Total: Decimal;
        TotalPonderSubSubj: Decimal;
        TotalPonderSubSubjType1: Decimal;
        TotalPonderGroupSubType1: Decimal;
        TotalPonderGroupSubType2: Decimal;
        TotalPonderGroupSubType3: Decimal;
        TotalPonderFinalType1: Decimal;
        TotalPonderFinalType2: Decimal;
        TotalPonderFinalType3: Decimal;
        TotalPonderFinalType4: Decimal;
        TotalSubSubject: Decimal;
        TotalSubSubjectType1: Decimal;
        TotalGroupSubType1: Decimal;
        TotalGroupSubType2: Decimal;
        TotalGroupSubType3: Decimal;
        TotalFinalType1: Decimal;
        TotalFinalType2: Decimal;
        TotalFinalType3: Decimal;
        TotalFinalType4: Decimal;
        GroupSubjectPonder: Decimal;
        rRulesEvaluations: Record "Rules of Evaluations";
        varCount: Integer;
        VarSum: Decimal;
        Flag1: Boolean;
        Flag2: Boolean;
        Flag3: Boolean;
        Flag4: Boolean;
        Flag5: Boolean;
        Flag6: Boolean;
        FinalGrade: array[6] of Decimal;
        cParser: Codeunit Parser;
        rStrEduCountry: Record "Structure Education Country";
        i: Integer;
    begin
        if rClass.Get(pClass, pSchoolYear) then begin
            //Calc the sub-subject Final Classifications
            LastSchoolingYear := rClass."Schooling Year";

            rAssessementConfiguration.Reset;
            rAssessementConfiguration.SetRange("School Year", rClass."School Year");
            rAssessementConfiguration.SetRange(Type, rClass.Type);
            rAssessementConfiguration.SetRange("Study Plan Code", rClass."Study Plan Code");
            rAssessementConfiguration.SetRange("Country/Region Code", rClass."Country/Region Code");
            if not rAssessementConfiguration.FindFirst then
                Error(Text002, rClass."Study Plan Code");

            rAssessingStudentsFinal.Reset;
            rAssessingStudentsFinal.SetRange(Class, pClass);
            rAssessingStudentsFinal.SetRange("School Year", pSchoolYear);
            rAssessingStudentsFinal.SetRange("Schooling Year", rClass."Schooling Year");
            rAssessingStudentsFinal.SetFilter("Evaluation Type", '%1|%2',
              rAssessingStudentsFinal."Evaluation Type"::"Final Cycle", rAssessingStudentsFinal."Evaluation Type"::"Final Stage");
            rAssessingStudentsFinal.SetRange("Student Code No.", pStudent);
            rAssessingStudentsFinal.DeleteAll(true);

            if rClass.Type = rClass.Type::Simple then begin
                rStudyPlanLines.Reset;
                rStudyPlanLines.SetCurrentKey("Option Group", "Subject Code");
                rStudyPlanLines.SetRange(Code, rClass."Study Plan Code");
                rStudyPlanLines.SetRange("School Year", rClass."School Year");
                rStudyPlanLines.SetRange("Subject Excluded From Assess.", false);
                if rStudyPlanLines.FindSet then
                    repeat
                        CountryRegionCode := rStudyPlanLines."Country/Region Code";
                        StudyPlanCourse := rStudyPlanLines.Code;

                        if (LastOptionGroup <> '') and (LastOptionGroup <> rStudyPlanLines."Option Group") then begin
                            case rAssessementConfiguration."FY Group Sub. Classification" of
                                rAssessementConfiguration."FY Group Sub. Classification"::"Group (Horizontal)":
                                    begin

                                        //Get the pounder of the group
                                        rGroupSubjects.Reset;
                                        rGroupSubjects.SetRange("Schooling Year", rStudyPlanLines."Schooling Year");
                                        rGroupSubjects.SetRange(Code, LastOptionGroup);
                                        if rGroupSubjects.FindSet then;
                                        rGroupSubjects.TestField("Assessment Code");

                                        rMomentsAssessment.Reset;
                                        rMomentsAssessment.SetRange("School Year", pSchoolYear);
                                        rMomentsAssessment.SetRange("Schooling Year", rStudyPlanLines."Schooling Year");
                                        rMomentsAssessment.SetRange("Responsibility Center", rStudyPlanLines."Responsibility Center");
                                        rMomentsAssessment.SetRange("Evaluation Moment", rMomentsAssessment."Evaluation Moment"::"Final Moment");
                                        if rMomentsAssessment.FindSet then begin
                                            repeat
                                                GroupSubjectPonder := rMomentsAssessment.Weighting;
                                                rAssessingStudentsFinal.Reset;
                                                rAssessingStudentsFinal.SetRange("Evaluation Type",
                                                  rAssessingStudentsFinal."Evaluation Type"::"Final Moment Group");
                                                rAssessingStudentsFinal.SetRange("School Year", pSchoolYear);
                                                rAssessingStudentsFinal.SetRange("Schooling Year", rStudyPlanLines."Schooling Year");
                                                rAssessingStudentsFinal.SetRange("Option Group", LastOptionGroup);
                                                rAssessingStudentsFinal.SetRange("Student Code No.", pStudent);
                                                if rAssessingStudentsFinal.FindSet then begin
                                                    repeat
                                                        TotalPonderGroupSubType1 += GroupSubjectPonder;
                                                        if rAssessingStudentsFinal."Manual Grade" = 0 then
                                                            TotalGroupSubType1 += rAssessingStudentsFinal.Grade * GroupSubjectPonder
                                                        else
                                                            TotalGroupSubType1 += rAssessingStudentsFinal."Manual Grade" * GroupSubjectPonder;

                                                    until rAssessingStudents.Next = 0;

                                                    if TotalGroupSubType1 <> 0 then begin
                                                        Total := 0;
                                                        Total :=
                                                          Round(TotalGroupSubType1 / TotalPonderGroupSubType1,
                                                          rAssessementConfiguration."FY Group Sub. Round Method");

                                                        InsertFinalClassification(pClass,
                                                                             pSchoolYear,
                                                                             LastSchoolingYear,
                                                                             '',
                                                                             '',
                                                                             rStudyPlanLines.Code,
                                                                             pStudent,
                                                                             pEvaluationMoment,
                                                                             pMoment,
                                                                             Total,
                                                                             rClass.Type,
                                                                             LastOptionGroup,
                                                                             rStudyPlanLines."Country/Region Code",
                                                                             1,
                                                                             0);
                                                        //sum the clasifications for the Final evaluation
                                                        TotalPonderFinalType2 += rGroupSubjects.Ponder;
                                                        TotalFinalType2 += Total;

                                                    end;

                                                end;
                                            until rMomentsAssessment.Next = 0;

                                            TotalPonderGroupSubType1 := 0;
                                            TotalGroupSubType1 := 0;
                                            TotalPonderGroupSubType2 := 0;
                                            TotalGroupSubType2 := 0;
                                            TotalPonderGroupSubType3 := 0;
                                            TotalGroupSubType3 := 0;


                                        end;
                                    end;
                                rAssessementConfiguration."FY Group Sub. Classification"::"Sub-Subject (Vertical) ":
                                    begin
                                        if TotalGroupSubType2 <> 0 then begin
                                            Total := 0;
                                            Total :=
                                              Round(TotalGroupSubType2 / TotalPonderGroupSubType2,
                                              rAssessementConfiguration."FY Group Sub. Round Method");

                                            InsertFinalClassification(pClass,
                                                                 pSchoolYear,
                                                                 LastSchoolingYear,
                                                                 '',
                                                                  '',
                                                                 rStudyPlanLines.Code,
                                                                 pStudent,
                                                                 pEvaluationMoment,
                                                                 pMoment,
                                                                 Total,
                                                                 rClass.Type,
                                                                 LastOptionGroup,
                                                                 rStudyPlanLines."Country/Region Code",
                                                                 1,
                                                                 0);

                                            //sum the clasifications for the Final evaluation
                                            TotalPonderFinalType2 += rGroupSubjects.Ponder;
                                            TotalFinalType2 += Total;

                                            TotalPonderGroupSubType2 := 0;
                                            TotalGroupSubType2 := 0;
                                        end;
                                    end;
                                rAssessementConfiguration."FY Group Sub. Classification"::"Subject (Vertical)":
                                    begin
                                        if TotalGroupSubType3 <> 0 then begin
                                            Total := 0;
                                            Total :=
                                              Round(TotalGroupSubType3 / TotalPonderGroupSubType3,
                                              rAssessementConfiguration."FY Group Sub. Round Method");

                                            InsertFinalClassification(pClass,
                                                                 pSchoolYear,
                                                                 LastSchoolingYear,
                                                                 '',
                                                                  '',
                                                                 rStudyPlanLines.Code,
                                                                 pStudent,
                                                                 pEvaluationMoment,
                                                                 pMoment,
                                                                 Total,
                                                                 rClass.Type,
                                                                 LastOptionGroup,
                                                                 rStudyPlanLines."Country/Region Code",
                                                                 1,
                                                                 0);

                                            //sum the clasifications for the Final evaluation
                                            TotalPonderFinalType2 += rGroupSubjects.Ponder;
                                            TotalFinalType2 += Total;

                                            TotalPonderGroupSubType3 := 0;
                                            TotalGroupSubType3 := 0;
                                        end;
                                    end;
                            end;
                        end;

                        TotalPonderSubSubjType1 := 0;
                        TotalSubSubjectType1 := 0;

                        //Valida se a sub-disciplina é diferente da anterior e insere a linha de avaliação final
                        rStudyPlanLines.CalcFields("Sub-Subject");
                        //Vai calcular a classificação com base nas subdisciplinas
                        if rStudyPlanLines."Sub-Subject" then begin
                            rStudyPlanSubSubjectsLines.Reset;
                            rStudyPlanSubSubjectsLines.SetRange(Type, rClass.Type);
                            rStudyPlanSubSubjectsLines.SetRange(Code, rStudyPlanLines.Code);
                            rStudyPlanSubSubjectsLines.SetRange("Schooling Year", rStudyPlanLines."Schooling Year");
                            rStudyPlanSubSubjectsLines.SetRange("Subject Code", rStudyPlanLines."Subject Code");
                            if rStudyPlanSubSubjectsLines.FindSet then
                                repeat
                                    TotalPonderSubSubj := 0;
                                    TotalSubSubject := 0;

                                    rMomentsAssessment.Reset;
                                    rMomentsAssessment.SetRange("School Year", pSchoolYear);
                                    rMomentsAssessment.SetRange("Schooling Year", rStudyPlanLines."Schooling Year");
                                    rMomentsAssessment.SetRange("Responsibility Center", rStudyPlanLines."Responsibility Center");
                                    rMomentsAssessment.SetRange("Evaluation Moment", rMomentsAssessment."Evaluation Moment"::"Final Moment");
                                    if rMomentsAssessment.FindSet then begin
                                        repeat
                                            lSettingRatingsSubSubjects.Reset;
                                            lSettingRatingsSubSubjects.SetRange("School Year", pSchoolYear);
                                            lSettingRatingsSubSubjects.SetRange("Schooling Year", rStudyPlanLines."Schooling Year");
                                            lSettingRatingsSubSubjects.SetRange("Study Plan Code", rStudyPlanLines.Code);
                                            lSettingRatingsSubSubjects.SetRange("Subject Code", rStudyPlanSubSubjectsLines."Subject Code");
                                            lSettingRatingsSubSubjects.SetRange("Sub-Subject Code", rStudyPlanSubSubjectsLines."Sub-Subject Code");
                                            lSettingRatingsSubSubjects.SetRange("Type Education", lSettingRatingsSubSubjects."Type Education"::Simple);
                                            lSettingRatingsSubSubjects.SetRange("Moment Code", rMomentsAssessment."Moment Code");
                                            if lSettingRatingsSubSubjects.FindSet then begin
                                                repeat
                                                    rAssessingStudents.Reset;
                                                    rAssessingStudents.SetRange(Class, pClass);
                                                    rAssessingStudents.SetRange("School Year", pSchoolYear);
                                                    rAssessingStudents.SetRange("Moment Code", lSettingRatingsSubSubjects."Moment Code");
                                                    rAssessingStudents.SetRange(Subject, rStudyPlanLines."Subject Code");
                                                    rAssessingStudents.SetRange("Sub-Subject Code", rStudyPlanSubSubjectsLines."Sub-Subject Code");
                                                    rAssessingStudents.SetRange("Student Code No.", pStudent);
                                                    if rAssessingStudents.FindSet then
                                                        repeat

                                                            TotalPonderSubSubj += rMomentsAssessment.Weighting;

                                                            if rAssessingStudents."Recuperation Grade" = 0 then
                                                                TotalSubSubject +=
                                                                      rAssessingStudents.Grade * rMomentsAssessment.Weighting
                                                            else
                                                                TotalSubSubject +=
                                                                      rAssessingStudents."Recuperation Grade" * rMomentsAssessment.Weighting;

                                                            TotalPonderSubSubjType1 += rStudyPlanSubSubjectsLines."Moment Ponder";

                                                            if rAssessingStudents."Recuperation Grade" = 0 then
                                                                TotalSubSubjectType1 +=
                                                                      rAssessingStudents.Grade * rStudyPlanSubSubjectsLines."Moment Ponder"
                                                            else
                                                                TotalSubSubjectType1 +=
                                                                      rAssessingStudents."Recuperation Grade" * rStudyPlanSubSubjectsLines."Moment Ponder";


                                                        until rAssessingStudents.Next = 0;

                                                until lSettingRatingsSubSubjects.Next = 0;
                                            end;
                                        until rMomentsAssessment.Next = 0;
                                    end;
                                    //Insert the line if evaluation exist for the sub Subject

                                    if TotalSubSubject <> 0 then begin
                                        Total := 0;
                                        Total := Round(TotalSubSubject / TotalPonderSubSubj, rAssessementConfiguration."FY Sub Subject Round Method");

                                        InsertClassification(
                                                             pClass,
                                                             pSchoolYear,
                                                             LastSchoolingYear,
                                                             rStudyPlanSubSubjectsLines."Subject Code",
                                                             rStudyPlanSubSubjectsLines."Sub-Subject Code",
                                                             rStudyPlanLines.Code,
                                                             pStudent,
                                                             pEvaluationMoment,
                                                             pMoment,
                                                             Total,
                                                             rClass.Type,
                                                             rStudyPlanLines."Country/Region Code",
                                                             rStudyPlanLines."Evaluation Type",
                                                             rStudyPlanLines."Assessment Code"
                                                             );

                                        //sum the clasifications for the Group evaluation
                                        if rStudyPlanLines."Option Group" <> '' then begin
                                            TotalPonderGroupSubType2 += rStudyPlanSubSubjectsLines."Moment Ponder";
                                            TotalGroupSubType2 += Total * rStudyPlanSubSubjectsLines."Moment Ponder";
                                        end;

                                        //sum the clasifications for the Final evaluation
                                        if rStudyPlanLines."Option Group" <> '' then begin
                                            TotalPonderFinalType3 += rStudyPlanSubSubjectsLines."Moment Ponder";
                                            TotalFinalType3 += Total * rStudyPlanSubSubjectsLines."Moment Ponder";
                                        end;
                                    end;
                                until rStudyPlanSubSubjectsLines.Next = 0;

                        end;

                        if rAssessementConfiguration."FY Subjects Classification" =
                          rAssessementConfiguration."FY Subjects Classification"::"Sub-Subject (Vertical) " then begin
                            if TotalSubSubjectType1 <> 0 then begin
                                Total := 0;
                                Total := Round(TotalSubSubjectType1 / TotalPonderSubSubjType1, rAssessementConfiguration."FY Subject Round Method");

                                InsertClassification(
                                                     pClass,
                                                     pSchoolYear,
                                                     LastSchoolingYear,
                                                     rStudyPlanLines."Subject Code",
                                                     '',
                                                     rStudyPlanLines.Code,
                                                     pStudent,
                                                     pEvaluationMoment,
                                                     pMoment,
                                                     Total,
                                                     rClass.Type,
                                                     rStudyPlanLines."Country/Region Code",
                                                     rStudyPlanLines."Evaluation Type",
                                                     rStudyPlanLines."Assessment Code"
                                                     );

                                //sum the clasifications for the Group evaluation
                                if rStudyPlanLines."Option Group" <> '' then begin
                                    TotalPonderGroupSubType3 += rStudyPlanLines.Weighting;
                                    TotalGroupSubType3 += Total;
                                end;

                            end;
                        end else begin
                            TotalPonderSubSubj := 0;
                            TotalSubSubject := 0;

                            rMomentsAssessment.Reset;
                            rMomentsAssessment.SetRange("School Year", pSchoolYear);
                            rMomentsAssessment.SetRange("Schooling Year", rStudyPlanLines."Schooling Year");
                            rMomentsAssessment.SetRange("Responsibility Center", rStudyPlanLines."Responsibility Center");
                            rMomentsAssessment.SetRange("Evaluation Moment", rMomentsAssessment."Evaluation Moment"::"Final Moment");
                            if rMomentsAssessment.FindSet then begin
                                repeat
                                    lSettingRatings.Reset;
                                    lSettingRatings.SetRange("School Year", pSchoolYear);
                                    lSettingRatings.SetRange("Schooling Year", rStudyPlanLines."Schooling Year");
                                    lSettingRatings.SetRange("Study Plan Code", rStudyPlanLines.Code);
                                    lSettingRatings.SetRange("Subject Code", rStudyPlanLines."Subject Code");
                                    lSettingRatings.SetRange("Type Education", lSettingRatings."Type Education"::Simple);
                                    lSettingRatings.SetRange("Moment Code", rMomentsAssessment."Moment Code");
                                    if lSettingRatings.FindSet then begin
                                        repeat
                                            rAssessingStudents.Reset;
                                            rAssessingStudents.SetRange(Class, pClass);
                                            rAssessingStudents.SetRange("School Year", pSchoolYear);
                                            rAssessingStudents.SetRange("Moment Code", lSettingRatings."Moment Code");
                                            rAssessingStudents.SetRange(Subject, rStudyPlanLines."Subject Code");
                                            rAssessingStudents.SetRange("Sub-Subject Code", '');
                                            rAssessingStudents.SetRange("Student Code No.", pStudent);
                                            if rAssessingStudents.FindSet then
                                                repeat

                                                    TotalPonderSubSubj += rMomentsAssessment.Weighting;
                                                    if rAssessingStudents."Recuperation Grade" = 0 then
                                                        TotalSubSubject +=
                                                                rAssessingStudents.Grade * rMomentsAssessment.Weighting
                                                    else
                                                        TotalSubSubject +=
                                                                rAssessingStudents."Recuperation Grade" * rMomentsAssessment.Weighting


                                                until rAssessingStudents.Next = 0;

                                        until lSettingRatings.Next = 0;
                                    end;
                                until rMomentsAssessment.Next = 0;
                                if TotalSubSubject <> 0 then begin
                                    Total := 0;
                                    Total := Round(TotalSubSubject / TotalPonderSubSubj, rAssessementConfiguration."FY Subject Round Method");

                                    InsertClassification(
                                                         pClass,
                                                         pSchoolYear,
                                                         LastSchoolingYear,
                                                         rStudyPlanLines."Subject Code",
                                                         '',
                                                         rStudyPlanLines.Code,
                                                         pStudent,
                                                         pEvaluationMoment,
                                                         pMoment,
                                                         Total,
                                                         rClass.Type,
                                                         rStudyPlanLines."Country/Region Code",
                                                         rStudyPlanLines."Evaluation Type",
                                                         rStudyPlanLines."Assessment Code"
                                                         );

                                    //sum the clasifications for the Group evaluation
                                    if rStudyPlanLines."Option Group" <> '' then begin
                                        TotalPonderGroupSubType3 += rStudyPlanLines.Weighting;
                                        TotalGroupSubType3 += Total;
                                    end;

                                    //sum the clasifications for the final evaluation
                                    TotalPonderFinalType4 += rStudyPlanLines.Weighting;
                                    TotalFinalType4 += Total;

                                end;
                            end;
                        end;

                        LastOptionGroup := rStudyPlanLines."Option Group";

                    until rStudyPlanLines.Next = 0;

                //Post the last group subject
                case rAssessementConfiguration."FY Group Sub. Classification" of
                    rAssessementConfiguration."FY Group Sub. Classification"::"Group (Horizontal)":
                        begin
                            TotalPonderGroupSubType1 := 0;
                            TotalGroupSubType1 := 0;

                            //Get the pounder of the group
                            rGroupSubjects.Reset;
                            rGroupSubjects.SetRange("Schooling Year", rStudyPlanLines."Schooling Year");
                            rGroupSubjects.SetRange(Code, LastOptionGroup);
                            if rGroupSubjects.FindSet then;

                            rGroupSubjects.TestField("Assessment Code");

                            rMomentsAssessment.Reset;
                            rMomentsAssessment.SetRange("School Year", pSchoolYear);
                            rMomentsAssessment.SetRange("Schooling Year", rStudyPlanLines."Schooling Year");
                            rMomentsAssessment.SetRange("Responsibility Center", rStudyPlanLines."Responsibility Center");
                            rMomentsAssessment.SetRange("Evaluation Moment", rMomentsAssessment."Evaluation Moment"::"Final Moment");
                            if rMomentsAssessment.FindSet then begin
                                repeat
                                    GroupSubjectPonder := rMomentsAssessment.Weighting;

                                    rAssessingStudentsFinal.Reset;
                                    rAssessingStudentsFinal.SetRange("Evaluation Type", rAssessingStudentsFinal."Evaluation Type"::"Final Moment Group")
                     ;
                                    rAssessingStudentsFinal.SetRange("School Year", pSchoolYear);
                                    rAssessingStudentsFinal.SetRange("Schooling Year", rStudyPlanLines."Schooling Year");
                                    rAssessingStudentsFinal.SetRange("Option Group", LastOptionGroup);
                                    rAssessingStudentsFinal.SetRange("Student Code No.", pStudent);
                                    if rAssessingStudentsFinal.FindSet then begin
                                        repeat
                                            TotalPonderGroupSubType1 += GroupSubjectPonder;
                                            if rAssessingStudentsFinal."Manual Grade" = 0 then
                                                TotalGroupSubType1 += rAssessingStudentsFinal.Grade * GroupSubjectPonder
                                            else
                                                TotalGroupSubType1 += rAssessingStudentsFinal."Manual Grade" * GroupSubjectPonder;

                                        until rAssessingStudentsFinal.Next = 0;

                                        if TotalGroupSubType1 <> 0 then begin
                                            Total := 0;
                                            Total :=
                                              Round(TotalGroupSubType1 / TotalPonderGroupSubType1,
                                              rAssessementConfiguration."FY Group Sub. Round Method");

                                            InsertFinalClassification(pClass,
                                                                 pSchoolYear,
                                                                 LastSchoolingYear,
                                                                 '',
                                                                  '',
                                                                 rStudyPlanLines.Code,
                                                                 pStudent,
                                                                 pEvaluationMoment,
                                                                 pMoment,
                                                                 Total,
                                                                 rClass.Type,
                                                                 LastOptionGroup,
                                                                 rStudyPlanLines."Country/Region Code",
                                                                 1,
                                                                 0);
                                            //sum the clasifications for the Final evaluation
                                            TotalPonderFinalType2 += rGroupSubjects.Ponder;
                                            TotalFinalType2 += Total;

                                            TotalGroupSubType1 := 0;
                                            TotalPonderGroupSubType1 := 0;
                                        end;

                                    end;
                                until rMomentsAssessment.Next = 0;

                                TotalPonderGroupSubType1 := 0;
                                TotalGroupSubType1 := 0;
                                TotalPonderGroupSubType2 := 0;
                                TotalGroupSubType2 := 0;
                                TotalPonderGroupSubType3 := 0;
                                TotalGroupSubType3 := 0;

                            end;
                        end;

                    rAssessementConfiguration."FY Group Sub. Classification"::"Sub-Subject (Vertical) ":
                        begin
                            if TotalGroupSubType2 <> 0 then begin
                                Total := 0;
                                Total :=
                                  Round(TotalGroupSubType2 / TotalPonderGroupSubType2,
                                  rAssessementConfiguration."FY Group Sub. Round Method");

                                InsertFinalClassification(pClass,
                                                     pSchoolYear,
                                                     LastSchoolingYear,
                                                     '',
                                                      '',
                                                     rStudyPlanLines.Code,
                                                     pStudent,
                                                     pEvaluationMoment,
                                                     pMoment,
                                                     Total,
                                                     rClass.Type,
                                                     LastOptionGroup,
                                                     rStudyPlanLines."Country/Region Code",
                                                     1,
                                                     0);

                                TotalPonderGroupSubType2 := 0;
                                TotalGroupSubType2 := 0;
                            end;
                        end;

                    rAssessementConfiguration."FY Group Sub. Classification"::"Subject (Vertical)":
                        begin
                            if TotalGroupSubType3 <> 0 then begin
                                Total := 0;
                                Total :=
                                  Round(TotalGroupSubType3 / TotalPonderGroupSubType3,
                                  rAssessementConfiguration."FY Group Sub. Round Method");

                                InsertFinalClassification(pClass,
                                                     pSchoolYear,
                                                     LastSchoolingYear,
                                                     '',
                                                      '',
                                                     rStudyPlanLines.Code,
                                                     pStudent,
                                                     pEvaluationMoment,
                                                     pMoment,
                                                     Total,
                                                     rClass.Type,
                                                     LastOptionGroup,
                                                     rStudyPlanLines."Country/Region Code",
                                                     1,
                                                     0);

                                TotalPonderGroupSubType3 := 0;
                                TotalGroupSubType3 := 0;
                            end;
                        end;
                end;

                //Post the final evaluation for the student
                case rAssessementConfiguration."FY Final Classification" of
                    rAssessementConfiguration."FY Final Classification"::"Final (Horizontal)":
                        begin
                            rMomentsAssessment.Reset;
                            rMomentsAssessment.SetRange("School Year", pSchoolYear);
                            rMomentsAssessment.SetRange("Schooling Year", rStudyPlanLines."Schooling Year");
                            rMomentsAssessment.SetRange("Responsibility Center", rStudyPlanLines."Responsibility Center");
                            rMomentsAssessment.SetRange("Evaluation Moment", rMomentsAssessment."Evaluation Moment"::"Final Moment");
                            if rMomentsAssessment.FindSet then begin
                                repeat
                                    rAssessingStudentsFinal.Reset;
                                    rAssessingStudentsFinal.SetRange("Evaluation Type", rAssessingStudentsFinal."Evaluation Type"::"Final Moment");
                                    rAssessingStudentsFinal.SetRange("School Year", pSchoolYear);
                                    rAssessingStudentsFinal.SetRange("Schooling Year", rStudyPlanLines."Schooling Year");
                                    rAssessingStudentsFinal.SetRange("Student Code No.", pStudent);
                                    if rAssessingStudentsFinal.FindSet then begin
                                        repeat
                                            TotalPonderFinalType1 += rMomentsAssessment.Weighting;
                                            TotalFinalType1 += rAssessingStudentsFinal.Grade * rMomentsAssessment.Weighting;
                                        until rAssessingStudentsFinal.Next = 0;

                                        if TotalFinalType1 <> 0 then begin
                                            Total := 0;
                                            Total :=
                                              Round(TotalFinalType1 / TotalPonderFinalType1,
                                              rAssessementConfiguration."FY Final Round Method");

                                            InsertFinalClassification(pClass,
                                                                 pSchoolYear,
                                                                 LastSchoolingYear,
                                                                 '',
                                                                 '',
                                                                 rStudyPlanLines.Code,
                                                                 pStudent,
                                                                 pEvaluationMoment,
                                                                 pMoment,
                                                                 Total,
                                                                 rClass.Type,
                                                                 '',
                                                                 rStudyPlanLines."Country/Region Code",
                                                                 0,
                                                                 0);

                                            TotalFinalType1 := 0;
                                            TotalPonderFinalType1 := 0;
                                        end;

                                    end;
                                until rMomentsAssessment.Next = 0;
                            end;
                        end;

                    rAssessementConfiguration."FY Final Classification"::"Group (Horizontal)":
                        begin
                            TotalFinalType2 := 0;
                            TotalPonderFinalType2 := 0;
                            //rMomentsAssessment.RESET;
                            //rMomentsAssessment.SETRANGE("School Year",pSchoolYear);
                            //rMomentsAssessment.SETRANGE("Schooling Year",rStudyPlanLines."Schooling Year");
                            //rMomentsAssessment.SETRANGE("Responsibility Center",rStudyPlanLines."Responsibility Center");
                            //rMomentsAssessment.SETRANGE("Evaluation Moment",rMomentsAssessment."Evaluation Moment"::"Final Moment");
                            //IF rMomentsAssessment.FINDSET THEN BEGIN
                            //  REPEAT
                            rAssessingStudentsFinal.Reset;
                            rAssessingStudentsFinal.SetRange("Evaluation Type", rAssessingStudentsFinal."Evaluation Type"::"Final Year Group");
                            rAssessingStudentsFinal.SetRange("School Year", pSchoolYear);
                            rAssessingStudentsFinal.SetRange("Schooling Year", rStudyPlanLines."Schooling Year");
                            rAssessingStudentsFinal.SetRange("Student Code No.", pStudent);
                            if rAssessingStudentsFinal.FindSet then begin
                                repeat
                                    rGroupSubjects.Reset;
                                    rGroupSubjects.SetRange(Code, rAssessingStudentsFinal."Option Group");
                                    rGroupSubjects.SetRange("Schooling Year", rAssessingStudentsFinal."Schooling Year");
                                    if rGroupSubjects.FindSet then begin
                                        rGroupSubjects.TestField("Assessment Code");
                                        TotalPonderFinalType2 += rGroupSubjects.Ponder;
                                        if rAssessingStudentsFinal."Manual Grade" = 0 then
                                            TotalFinalType2 += rAssessingStudentsFinal.Grade * rGroupSubjects.Ponder
                                        else
                                            TotalFinalType2 += rAssessingStudentsFinal."Manual Grade" * rGroupSubjects.Ponder;
                                    end;
                                until rAssessingStudentsFinal.Next = 0;
                            end;
                            //  UNTIL rMomentsAssessment.NEXT = 0;
                            //END;
                            if TotalFinalType2 <> 0 then begin
                                Total := 0;
                                Total :=
                                  Round(TotalFinalType2 / TotalPonderFinalType2,
                                  rAssessementConfiguration."FY Final Round Method");

                                InsertFinalClassification(pClass,
                                                     pSchoolYear,
                                                     LastSchoolingYear,
                                                     '',
                                                     '',
                                                     rStudyPlanLines.Code,
                                                     pStudent,
                                                     pEvaluationMoment,
                                                     pMoment,
                                                     Total,
                                                     rClass.Type,
                                                     '',
                                                     rStudyPlanLines."Country/Region Code",
                                                     0,
                                                     0);

                                TotalFinalType2 := 0;
                                TotalPonderFinalType2 := 0;
                            end;
                        end;

                    rAssessementConfiguration."FY Final Classification"::"Sub-Subject (Vertical)":
                        begin
                            if TotalFinalType3 <> 0 then begin
                                Total := 0;
                                Total :=
                                  Round(TotalFinalType3 / TotalPonderFinalType3,
                                  rAssessementConfiguration."FY Final Round Method");

                                InsertFinalClassification(pClass,
                                                     pSchoolYear,
                                                     LastSchoolingYear,
                                                     '',
                                                     '',
                                                     rStudyPlanLines.Code,
                                                     pStudent,
                                                     pEvaluationMoment,
                                                     pMoment,
                                                     Total,
                                                     rClass.Type,
                                                     '',
                                                     rStudyPlanLines."Country/Region Code",
                                                     0,
                                                     0);

                                TotalFinalType3 := 0;
                                TotalPonderFinalType3 := 0;
                            end;
                        end;

                    rAssessementConfiguration."FY Final Classification"::"Subject (Vertical)":
                        begin
                            if TotalFinalType4 <> 0 then begin
                                Total := 0;
                                Total :=
                                  Round(TotalFinalType4 / TotalPonderFinalType4,
                                  rAssessementConfiguration."FY Final Round Method");

                                InsertFinalClassification(pClass,
                                                     pSchoolYear,
                                                     LastSchoolingYear,
                                                     '',
                                                     '',
                                                     rStudyPlanLines.Code,
                                                     pStudent,
                                                     pEvaluationMoment,
                                                     pMoment,
                                                     Total,
                                                     rClass.Type,
                                                     '',
                                                     rStudyPlanLines."Country/Region Code",
                                                     0,
                                                     0);

                                TotalFinalType4 := 0;
                                TotalPonderFinalType4 := 0;
                            end;
                        end;
                end;
                //BEGIN LEGAL
                //LEGAL study plan
                if rAssessementConfiguration."Use Evaluation Rules" then begin

                    //
                    varCount := 0;
                    VarSum := 0;
                    Flag1 := true;
                    Flag2 := true;
                    Flag3 := true;
                    Flag4 := true;
                    Flag5 := true;
                    Flag6 := true;

                    rRulesEvaluations.Reset;
                    rRulesEvaluations.SetRange("Study Plan Code", rClass."Study Plan Code");
                    rRulesEvaluations.SetRange(Type, rClass.Type);
                    rRulesEvaluations.SetRange("Schooling Year", rClass."Schooling Year");
                    rRulesEvaluations.SetRange("School Year", rClass."School Year");
                    rRulesEvaluations.SetRange("Classifications Calculations",
                                                rRulesEvaluations."Classifications Calculations"::"Final Cycle");
                    if rRulesEvaluations.FindFirst then
                        if rRulesEvaluations."Value 1" = rRulesEvaluations."Value 1"::"Final Year" then begin
                            InsertFinalCycle(rClass, pStudent, rRulesEvaluations);
                        end;


                    rRulesEvaluations.Reset;
                    rRulesEvaluations.SetRange("Study Plan Code", rClass."Study Plan Code");
                    rRulesEvaluations.SetRange(Type, rClass.Type);
                    rRulesEvaluations.SetRange("Schooling Year", rClass."Schooling Year");
                    rRulesEvaluations.SetRange("School Year", rClass."School Year");
                    rRulesEvaluations.SetRange("Classifications Calculations", rRulesEvaluations."Classifications Calculations"::"Final Year"
          );
                    if rRulesEvaluations.FindFirst then begin

                        rStudyPlanLines.Reset;
                        rStudyPlanLines.SetCurrentKey("Option Group", "Subject Code");
                        rStudyPlanLines.SetRange(Code, rClass."Study Plan Code");
                        rStudyPlanLines.SetRange("Subject Excluded From Assess.", false);
                        if rStudyPlanLines.FindSet then begin
                            repeat
                                rAssessingStudents.Reset;
                                rAssessingStudents.SetRange("Schooling Year", rClass."Schooling Year");
                                rAssessingStudents.SetRange(Subject, rStudyPlanLines."Subject Code");
                                rAssessingStudents.SetRange("Student Code No.", pStudent);
                                rAssessingStudents.SetRange("Evaluation Moment", rAssessingStudents."Evaluation Moment"::"Final Year");
                                if rAssessingStudents.FindFirst then begin
                                    if ((rStudyPlanLines."Option Group" <> rRulesEvaluations."Code Value 1") and
                                      (rRulesEvaluations."Code Value 1" <> '')) then begin
                                        varCount += 1;
                                        VarSum += rAssessingStudents.Grade;
                                    end;
                                    if ((rStudyPlanLines."Option Group" <> rRulesEvaluations."Code Value 2") and
                                      (rRulesEvaluations."Code Value 2" <> '')) then begin
                                        varCount += 1;
                                        VarSum += rAssessingStudents.Grade;
                                    end;
                                    if ((rStudyPlanLines."Option Group" <> rRulesEvaluations."Code Value 3") and
                                      (rRulesEvaluations."Code Value 3" <> '')) then begin
                                        varCount += 1;
                                        VarSum += rAssessingStudents.Grade;
                                    end;
                                    if ((rStudyPlanLines."Option Group" <> rRulesEvaluations."Code Value 4") and
                                      (rRulesEvaluations."Code Value 4" <> '')) then begin
                                        varCount += 1;
                                        VarSum += rAssessingStudents.Grade;
                                    end;
                                    if ((rStudyPlanLines."Option Group" <> rRulesEvaluations."Code Value 5") and
                                      (rRulesEvaluations."Code Value 5" <> '')) then begin
                                        varCount += 1;
                                        VarSum += rAssessingStudents.Grade;
                                    end;
                                    if ((rStudyPlanLines."Option Group" <> rRulesEvaluations."Code Value 6") and
                                      (rRulesEvaluations."Code Value 6" <> '')) then begin
                                        varCount += 1;
                                        VarSum += rAssessingStudents.Grade;
                                    end;
                                end;

                                if rStudyPlanLines."Option Group" <> '' then begin
                                    rAssessingStudentsFinal.Reset;
                                    rAssessingStudentsFinal.SetRange("Schooling Year", rClass."Schooling Year");
                                    rAssessingStudentsFinal.SetRange("Student Code No.", pStudent);
                                    rAssessingStudentsFinal.SetRange("Evaluation Type", rAssessingStudentsFinal."Evaluation Type"::"Final Year Group"
                  );
                                    if rAssessingStudentsFinal.FindSet then begin
                                        repeat
                                            if (rStudyPlanLines."Option Group" = rAssessingStudentsFinal."Option Group") and
                                               (rStudyPlanLines."Option Group" = rRulesEvaluations."Code Value 1") and Flag1 then begin
                                                varCount += 1;
                                                VarSum += rAssessingStudentsFinal.Grade;
                                                Flag1 := false;
                                            end;
                                            if (rStudyPlanLines."Option Group" = rAssessingStudentsFinal."Option Group") and
                                               (rStudyPlanLines."Option Group" = rRulesEvaluations."Code Value 2") and Flag2 then begin
                                                varCount += 1;
                                                VarSum += rAssessingStudentsFinal.Grade;
                                                Flag2 := false;
                                            end;
                                            if (rStudyPlanLines."Option Group" = rAssessingStudentsFinal."Option Group") and
                                               (rStudyPlanLines."Option Group" = rRulesEvaluations."Code Value 3") and Flag3 then begin
                                                varCount += 1;
                                                VarSum += rAssessingStudentsFinal.Grade;
                                                Flag3 := false;
                                            end;
                                            if (rStudyPlanLines."Option Group" = rAssessingStudentsFinal."Option Group") and
                                               (rStudyPlanLines."Option Group" = rRulesEvaluations."Code Value 4") and Flag4 then begin
                                                varCount += 1;
                                                VarSum += rAssessingStudentsFinal.Grade;
                                                Flag4 := false;
                                            end;
                                            if (rStudyPlanLines."Option Group" = rAssessingStudentsFinal."Option Group") and
                                               (rStudyPlanLines."Option Group" = rRulesEvaluations."Code Value 5") and Flag5 then begin
                                                varCount += 1;
                                                VarSum += rAssessingStudentsFinal.Grade;
                                                Flag5 := false;
                                            end;
                                            if (rStudyPlanLines."Option Group" = rAssessingStudentsFinal."Option Group") and
                                               (rStudyPlanLines."Option Group" = rRulesEvaluations."Code Value 6") and Flag6 then begin
                                                varCount += 1;
                                                VarSum += rAssessingStudentsFinal.Grade;
                                                Flag6 := false;
                                            end;

                                        until rAssessingStudentsFinal.Next = 0;
                                    end;
                                end;
                            until rStudyPlanLines.Next = 0;

                            if varCount > 0 then
                                Total := Round(VarSum / varCount, rRulesEvaluations."Round Method");


                            InsertFinalClassification(pClass,
                                                 pSchoolYear,
                                                 LastSchoolingYear,
                                                 '',
                                                  '',
                                                 rStudyPlanLines.Code,
                                                 pStudent,
                                                 pEvaluationMoment,
                                                 pMoment,
                                                 Total,
                                                 rClass.Type,
                                                 '',
                                                 rStudyPlanLines."Country/Region Code",
                                                 0,
                                                 rRulesEvaluations."Entry No.");

                        end;
                    end;

                    //Final STAGE
                    rRulesEvaluations.Reset;
                    rRulesEvaluations.SetRange("Study Plan Code", rClass."Study Plan Code");
                    rRulesEvaluations.SetRange(Type, rClass.Type);
                    rRulesEvaluations.SetRange("Schooling Year", rClass."Schooling Year");
                    rRulesEvaluations.SetRange("School Year", rClass."School Year");
                    rRulesEvaluations.SetRange("Classifications Calculations", rRulesEvaluations."Classifications Calculations"::"Final Stage"
           );
                    if rRulesEvaluations.FindFirst then begin
                        if rRulesEvaluations."Value 1" = rRulesEvaluations."Value 1"::"Final Year" then begin
                            if rRulesEvaluations."Code Value 1" = rClass."Schooling Year" then;
                            InsertFinalStage(rClass, pStudent, rRulesEvaluations);
                        end;
                        if rRulesEvaluations."Value 1" = rRulesEvaluations."Value 1"::"Schooling Year" then begin
                            rAssessingStudentsFinal.Reset;
                            rAssessingStudentsFinal.SetRange("Evaluation Type", rAssessingStudentsFinal."Evaluation Type"::"Final Year");
                            rAssessingStudentsFinal.SetRange("Schooling Year", rRulesEvaluations."Code Value 1");
                            rAssessingStudentsFinal.SetRange("Student Code No.", pStudent);
                            if rAssessingStudentsFinal.FindSet then begin
                                repeat
                                    if FinalGrade[1] < rAssessingStudentsFinal.Grade then
                                        FinalGrade[1] := rAssessingStudentsFinal.Grade;
                                until rAssessingStudentsFinal.Next = 0;
                            end;
                        end;
                        if rRulesEvaluations."Value 2" = rRulesEvaluations."Value 2"::"Schooling Year" then begin
                            rAssessingStudentsFinal.Reset;
                            rAssessingStudentsFinal.SetRange("Evaluation Type", rAssessingStudentsFinal."Evaluation Type"::"Final Year");
                            rAssessingStudentsFinal.SetRange("Schooling Year", rRulesEvaluations."Code Value 2");
                            rAssessingStudentsFinal.SetRange("Student Code No.", pStudent);
                            if rAssessingStudentsFinal.FindSet then begin
                                repeat
                                    if FinalGrade[2] < rAssessingStudentsFinal.Grade then
                                        FinalGrade[2] := rAssessingStudentsFinal.Grade;
                                until rAssessingStudentsFinal.Next = 0;
                            end;
                        end;
                        if rRulesEvaluations."Value 3" = rRulesEvaluations."Value 3"::"Schooling Year" then begin
                            rAssessingStudentsFinal.Reset;
                            rAssessingStudentsFinal.SetRange("Evaluation Type", rAssessingStudentsFinal."Evaluation Type"::"Final Year");
                            rAssessingStudentsFinal.SetRange("Schooling Year", rRulesEvaluations."Code Value 3");
                            rAssessingStudentsFinal.SetRange("Student Code No.", pStudent);
                            if rAssessingStudentsFinal.FindSet then begin
                                repeat
                                    if FinalGrade[3] < rAssessingStudentsFinal.Grade then
                                        FinalGrade[3] := rAssessingStudentsFinal.Grade;
                                until rAssessingStudentsFinal.Next = 0;
                            end;
                        end;
                        if rRulesEvaluations."Value 4" = rRulesEvaluations."Value 4"::"Schooling Year" then begin
                            rAssessingStudentsFinal.Reset;
                            rAssessingStudentsFinal.SetRange("Evaluation Type", rAssessingStudentsFinal."Evaluation Type"::"Final Year");
                            rAssessingStudentsFinal.SetRange("Schooling Year", rRulesEvaluations."Code Value 4");
                            rAssessingStudentsFinal.SetRange("Student Code No.", pStudent);
                            if rAssessingStudentsFinal.FindSet then begin
                                repeat
                                    if FinalGrade[4] < rAssessingStudentsFinal.Grade then
                                        FinalGrade[4] := rAssessingStudentsFinal.Grade;
                                until rAssessingStudentsFinal.Next = 0;
                            end;
                        end;
                        if rRulesEvaluations."Value 5" = rRulesEvaluations."Value 5"::"Schooling Year" then begin
                            rAssessingStudentsFinal.Reset;
                            rAssessingStudentsFinal.SetRange("Evaluation Type", rAssessingStudentsFinal."Evaluation Type"::"Final Year");
                            rAssessingStudentsFinal.SetRange("Schooling Year", rRulesEvaluations."Code Value 5");
                            rAssessingStudentsFinal.SetRange("Student Code No.", pStudent);
                            if rAssessingStudentsFinal.FindSet then begin
                                repeat
                                    if FinalGrade[5] < rAssessingStudentsFinal.Grade then
                                        FinalGrade[5] := rAssessingStudentsFinal.Grade;
                                until rAssessingStudentsFinal.Next = 0;
                            end;
                        end;
                        if rRulesEvaluations."Value 6" = rRulesEvaluations."Value 6"::"Schooling Year" then begin
                            rAssessingStudentsFinal.Reset;
                            rAssessingStudentsFinal.SetRange("Evaluation Type", rAssessingStudentsFinal."Evaluation Type"::"Final Year");
                            rAssessingStudentsFinal.SetRange("Schooling Year", rRulesEvaluations."Code Value 6");
                            rAssessingStudentsFinal.SetRange("Student Code No.", pStudent);
                            if rAssessingStudentsFinal.FindSet then begin
                                repeat
                                    if FinalGrade[6] < rAssessingStudentsFinal.Grade then
                                        FinalGrade[6] := rAssessingStudentsFinal.Grade;
                                until rAssessingStudentsFinal.Next = 0;
                            end;
                        end;
                        Total := Round(
                          cParser.CalcDecimalExpr(StrSubstNo(rRulesEvaluations.Formula, FinalGrade[1], FinalGrade[2], FinalGrade[3], FinalGrade[4]
            ,
                          FinalGrade[5], FinalGrade[6])), rRulesEvaluations."Round Method");
                        if Total <> 0 then
                            InsertFinalClassification(pClass,
                                                 pSchoolYear,
                                                 LastSchoolingYear,
                                                 '',
                                                  '',
                                                 rStudyPlanLines.Code,
                                                 pStudent,
                                                 pEvaluationMoment,
                                                 pMoment,
                                                 Total,
                                                 rClass.Type,
                                                 '',
                                                 rCourseLines."Country/Region Code",
                                                 5,
                                                 rRulesEvaluations."Entry No.");


                    end;

                    rRulesEvaluations.Reset;
                    rRulesEvaluations.SetRange("Study Plan Code", rClass."Study Plan Code");
                    rRulesEvaluations.SetRange(Type, rClass.Type);
                    rRulesEvaluations.SetRange("Schooling Year", rClass."Schooling Year");
                    rRulesEvaluations.SetRange("School Year", rClass."School Year");
                    rRulesEvaluations.SetRange("Classifications Calculations", rRulesEvaluations."Classifications Calculations"::"Final Stage"
           );
                    if rRulesEvaluations.FindSet then begin
                        if rRulesEvaluations."Value 1" = rRulesEvaluations."Value 1"::"All Subjects - Grade" then begin
                            FinalGrade[1] := 0;
                            FinalGrade[2] := 0;
                            FinalGrade[3] := 0;
                            FinalGrade[4] := 0;
                            FinalGrade[5] := 0;
                            FinalGrade[6] := 0;
                            varCount := 0;
                            rStudyPlanLines.Reset;
                            rStudyPlanLines.SetRange(Code, rClass."Study Plan Code");
                            rStudyPlanLines.SetFilter("Legal Code", '<>%1', '');
                            rStudyPlanLines.SetRange("Subject Excluded From Assess.", false);
                            if rStudyPlanLines.FindSet then begin
                                repeat
                                    rStrEduCountry.Reset;
                                    rStrEduCountry.SetCurrentKey("Sorting ID");
                                    rStrEduCountry.SetRange("Edu. Level", rRulesEvaluations."Edu. Level");
                                    if rStrEduCountry.FindSet then begin
                                        repeat
                                            rAssessingStudents.Reset;
                                            rAssessingStudents.SetRange("Schooling Year", rStrEduCountry."Schooling Year");
                                            rAssessingStudents.SetRange(Subject, rStudyPlanLines."Subject Code");
                                            rAssessingStudents.SetRange("Sub-Subject Code", '');
                                            rAssessingStudents.SetRange("Student Code No.", pStudent);
                                            rAssessingStudents.SetRange("Evaluation Moment", rAssessingStudents."Evaluation Moment"::"Final Year");
                                            if rAssessingStudents.FindSet then begin
                                                //IF (rRulesEvaluations."Code Value 2" <> rStudyPlanLines."Legal Code") THEN
                                                FinalGrade[1] += rAssessingStudents.Grade;

                                                if (rRulesEvaluations."Value 2" = rRulesEvaluations."Value 2"::"Legal Code") and
                                                   (rRulesEvaluations."Code Value 2" = rStudyPlanLines."Legal Code") then begin
                                                    FinalGrade[2] += rAssessingStudents.Grade;
                                                    FinalGrade[1] -= rAssessingStudents.Grade;
                                                end;
                                                if (rRulesEvaluations."Value 3" = rRulesEvaluations."Value 3"::"Legal Code") and
                                                  (rRulesEvaluations."Code Value 3" = rStudyPlanLines."Legal Code") then begin
                                                    FinalGrade[3] += rAssessingStudents.Grade;
                                                    FinalGrade[1] -= rAssessingStudents.Grade;
                                                end;
                                                if (rRulesEvaluations."Value 4" = rRulesEvaluations."Value 4"::"Legal Code") and
                                                  (rRulesEvaluations."Code Value 4" = rStudyPlanLines."Legal Code") then begin
                                                    FinalGrade[4] += rAssessingStudents.Grade;
                                                    FinalGrade[1] -= rAssessingStudents.Grade;
                                                end;

                                                if (rRulesEvaluations."Value 5" = rRulesEvaluations."Value 5"::"Legal Code") and
                                                  (rRulesEvaluations."Code Value 5" = rStudyPlanLines."Legal Code") then begin
                                                    FinalGrade[5] += rAssessingStudents.Grade;
                                                    FinalGrade[1] -= rAssessingStudents.Grade;
                                                end;

                                                if (rRulesEvaluations."Value 6" = rRulesEvaluations."Value 5"::"Legal Code") and
                                                 (rRulesEvaluations."Code Value 6" = rStudyPlanLines."Legal Code") then begin
                                                    FinalGrade[6] += rAssessingStudents.Grade;
                                                    FinalGrade[1] -= rAssessingStudents.Grade;
                                                end;


                                                if (rRulesEvaluations."Value 2" = rRulesEvaluations."Value 2"::"All Subjects - Grade") then
                                                    FinalGrade[2] += 1;

                                                if (rRulesEvaluations."Value 3" = rRulesEvaluations."Value 3"::"All Subjects - Grade") then
                                                    FinalGrade[3] += 1;

                                                if (rRulesEvaluations."Value 4" = rRulesEvaluations."Value 4"::"All Subjects - Grade") then
                                                    FinalGrade[4] += 1;

                                                if (rRulesEvaluations."Value 5" = rRulesEvaluations."Value 5"::"All Subjects - Grade") then
                                                    FinalGrade[5] += 1;

                                                if (rRulesEvaluations."Value 6" = rRulesEvaluations."Value 5"::"All Subjects - Grade") then
                                                    FinalGrade[6] += 1;

                                            end;

                                        until rStrEduCountry.Next = 0;
                                    end;

                                until rStudyPlanLines.Next = 0;
                            end;

                            Total := Round(
                              cParser.CalcDecimalExpr(StrSubstNo(rRulesEvaluations.Formula, FinalGrade[1], FinalGrade[2], FinalGrade[3], FinalGrade[4]
                ,
                                                     FinalGrade[5], FinalGrade[6], rRulesEvaluations."Round Method")));

                            InsertFinalClassification(pClass,
                                                 pSchoolYear,
                                                 LastSchoolingYear,
                                                 '',
                                                  '',
                                                 rStudyPlanLines.Code,
                                                 pStudent,
                                                 pEvaluationMoment,
                                                 pMoment,
                                                 Total,
                                                 rClass.Type,
                                                 '',
                                                 rStudyPlanLines."Country/Region Code",
                                                 5,
                                                 rRulesEvaluations."Entry No.");



                        end;
                    end;
                end;

                //END LEGAL
            end else begin
                rCourseLines.Reset;
                rCourseLines.SetCurrentKey("Option Group", "Subject Code");
                rCourseLines.SetRange(Code, rClass."Study Plan Code");
                rCourseLines.SetRange("Subject Excluded From Assess.", false);
                if rCourseLines.Find('-') then begin
                    repeat

                        CountryRegionCode := rCourseLines."Country/Region Code";
                        StudyPlanCourse := rCourseLines.Code;

                        //////////////////////////////////////////////////////////////////////////////////

                        if (LastOptionGroup <> '') and (LastOptionGroup <> rCourseLines."Option Group") then begin
                            case rAssessementConfiguration."FY Group Sub. Classification" of
                                rAssessementConfiguration."FY Group Sub. Classification"::"Group (Horizontal)":
                                    begin

                                        //Get the pounder of the group
                                        rGroupSubjects.Reset;
                                        rGroupSubjects.SetRange("Schooling Year", '');
                                        rGroupSubjects.SetRange(Code, LastOptionGroup);
                                        if rGroupSubjects.FindSet then;
                                        rGroupSubjects.TestField("Assessment Code");

                                        rMomentsAssessment.Reset;
                                        rMomentsAssessment.SetRange("School Year", pSchoolYear);
                                        rMomentsAssessment.SetRange("Schooling Year", rClass."Schooling Year");
                                        rMomentsAssessment.SetRange("Responsibility Center", rCourseLines."Responsibility Center");
                                        rMomentsAssessment.SetRange("Evaluation Moment", rMomentsAssessment."Evaluation Moment"::"Final Moment");
                                        if rMomentsAssessment.FindSet then begin
                                            repeat
                                                GroupSubjectPonder := rMomentsAssessment.Weighting;
                                                rAssessingStudentsFinal.Reset;
                                                rAssessingStudentsFinal.SetRange("Evaluation Type",
                                                  rAssessingStudentsFinal."Evaluation Type"::"Final Moment Group");
                                                rAssessingStudentsFinal.SetRange("School Year", pSchoolYear);
                                                rAssessingStudentsFinal.SetRange("Schooling Year", rClass."Schooling Year");
                                                rAssessingStudentsFinal.SetRange("Option Group", LastOptionGroup);
                                                rAssessingStudentsFinal.SetRange("Student Code No.", pStudent);
                                                if rAssessingStudentsFinal.FindSet then begin
                                                    repeat
                                                        TotalPonderGroupSubType1 += GroupSubjectPonder;
                                                        if rAssessingStudentsFinal."Manual Grade" = 0 then
                                                            TotalGroupSubType1 += rAssessingStudentsFinal.Grade * GroupSubjectPonder
                                                        else
                                                            TotalGroupSubType1 += rAssessingStudentsFinal."Manual Grade" * GroupSubjectPonder

                                                    until rAssessingStudentsFinal.Next = 0;

                                                    if TotalGroupSubType1 <> 0 then begin
                                                        Total := 0;
                                                        Total :=
                                                          Round(TotalGroupSubType1 / TotalPonderGroupSubType1,
                                                          rAssessementConfiguration."FY Group Sub. Round Method");

                                                        InsertFinalClassification(pClass,
                                                                             pSchoolYear,
                                                                             LastSchoolingYear,
                                                                             '',
                                                                             '',
                                                                             rCourseLines.Code,
                                                                             pStudent,
                                                                             pEvaluationMoment,
                                                                             pMoment,
                                                                             Total,
                                                                             rClass.Type,
                                                                             LastOptionGroup,
                                                                             rCourseLines."Country/Region Code",
                                                                             1,
                                                                             0);
                                                        //sum the clasifications for the Final evaluation
                                                        TotalPonderFinalType2 += rGroupSubjects.Ponder;
                                                        TotalFinalType2 += Total;

                                                    end;

                                                end;
                                            until rMomentsAssessment.Next = 0;

                                            TotalPonderGroupSubType1 := 0;
                                            TotalGroupSubType1 := 0;
                                            TotalPonderGroupSubType2 := 0;
                                            TotalGroupSubType2 := 0;
                                            TotalPonderGroupSubType3 := 0;
                                            TotalGroupSubType3 := 0;


                                        end;
                                    end;
                                rAssessementConfiguration."FY Group Sub. Classification"::"Sub-Subject (Vertical) ":
                                    begin
                                        if TotalGroupSubType2 <> 0 then begin
                                            Total := 0;
                                            Total :=
                                              Round(TotalGroupSubType2 / TotalPonderGroupSubType2,
                                              rAssessementConfiguration."FY Group Sub. Round Method");

                                            InsertFinalClassification(pClass,
                                                                 pSchoolYear,
                                                                 LastSchoolingYear,
                                                                 '',
                                                                  '',
                                                                 rCourseLines.Code,
                                                                 pStudent,
                                                                 pEvaluationMoment,
                                                                 pMoment,
                                                                 Total,
                                                                 rClass.Type,
                                                                 LastOptionGroup,
                                                                 rCourseLines."Country/Region Code",
                                                                 1,
                                                                 0);

                                            //sum the clasifications for the Final evaluation
                                            TotalPonderFinalType2 += rGroupSubjects.Ponder;
                                            TotalFinalType2 += Total;

                                            TotalPonderGroupSubType2 := 0;
                                            TotalGroupSubType2 := 0;
                                        end;
                                    end;
                                rAssessementConfiguration."FY Group Sub. Classification"::"Subject (Vertical)":
                                    begin
                                        if TotalGroupSubType3 <> 0 then begin
                                            Total := 0;
                                            Total :=
                                              Round(TotalGroupSubType3 / TotalPonderGroupSubType3,
                                              rAssessementConfiguration."FY Group Sub. Round Method");

                                            InsertFinalClassification(pClass,
                                                                 pSchoolYear,
                                                                 LastSchoolingYear,
                                                                 '',
                                                                  '',
                                                                 rCourseLines.Code,
                                                                 pStudent,
                                                                 pEvaluationMoment,
                                                                 pMoment,
                                                                 Total,
                                                                 rClass.Type,
                                                                 LastOptionGroup,
                                                                 rCourseLines."Country/Region Code",
                                                                 1,
                                                                 0);

                                            //sum the clasifications for the Final evaluation
                                            TotalPonderFinalType2 += rGroupSubjects.Ponder;
                                            TotalFinalType2 += Total;

                                            TotalPonderGroupSubType3 := 0;
                                            TotalGroupSubType3 := 0;
                                        end;
                                    end;
                            end;
                        end;

                        TotalPonderSubSubjType1 := 0;
                        TotalSubSubjectType1 := 0;

                        //Valida se a sub-disciplina é diferente da anterior e insere a linha de avaliação final
                        rCourseLines.CalcFields("Sub-Subject");
                        //Vai calcular a classificação com base nas subdisciplinas
                        if rCourseLines."Sub-Subject" then begin
                            rStudyPlanSubSubjectsLines.Reset;
                            rStudyPlanSubSubjectsLines.SetRange(Type, rClass.Type);
                            rStudyPlanSubSubjectsLines.SetRange(Code, rCourseLines.Code);
                            rStudyPlanSubSubjectsLines.SetRange("Schooling Year", rClass."Schooling Year");
                            rStudyPlanSubSubjectsLines.SetRange("Subject Code", rCourseLines."Subject Code");
                            if rStudyPlanSubSubjectsLines.FindSet then
                                repeat
                                    TotalPonderSubSubj := 0;
                                    TotalSubSubject := 0;

                                    rMomentsAssessment.Reset;
                                    rMomentsAssessment.SetRange("School Year", pSchoolYear);
                                    rMomentsAssessment.SetRange("Schooling Year", rClass."Schooling Year");
                                    rMomentsAssessment.SetRange("Responsibility Center", rCourseLines."Responsibility Center");
                                    rMomentsAssessment.SetRange("Evaluation Moment", rMomentsAssessment."Evaluation Moment"::"Final Moment");
                                    if rMomentsAssessment.FindSet then begin
                                        repeat
                                            lSettingRatingsSubSubjects.Reset;
                                            lSettingRatingsSubSubjects.SetRange("School Year", pSchoolYear);
                                            lSettingRatingsSubSubjects.SetRange("Schooling Year", rClass."Schooling Year");
                                            lSettingRatingsSubSubjects.SetRange("Study Plan Code", rCourseLines.Code);
                                            lSettingRatingsSubSubjects.SetRange("Subject Code", rStudyPlanSubSubjectsLines."Subject Code");
                                            lSettingRatingsSubSubjects.SetRange("Sub-Subject Code", rStudyPlanSubSubjectsLines."Sub-Subject Code");
                                            lSettingRatingsSubSubjects.SetRange("Type Education", lSettingRatingsSubSubjects."Type Education"::Multi);
                                            lSettingRatingsSubSubjects.SetRange("Moment Code", rMomentsAssessment."Moment Code");
                                            if lSettingRatingsSubSubjects.FindSet then begin
                                                repeat
                                                    rAssessingStudents.Reset;
                                                    rAssessingStudents.SetRange(Class, pClass);
                                                    rAssessingStudents.SetRange("School Year", pSchoolYear);
                                                    rAssessingStudents.SetRange("Moment Code", lSettingRatingsSubSubjects."Moment Code");
                                                    rAssessingStudents.SetRange(Subject, rCourseLines."Subject Code");
                                                    rAssessingStudents.SetRange("Sub-Subject Code", rStudyPlanSubSubjectsLines."Sub-Subject Code");
                                                    rAssessingStudents.SetRange("Student Code No.", pStudent);
                                                    if rAssessingStudents.FindSet then
                                                        repeat

                                                            TotalPonderSubSubj
                                                              += rMomentsAssessment.Weighting;
                                                            if rAssessingStudents."Recuperation Grade" = 0 then
                                                                TotalSubSubject +=
                                                                        rAssessingStudents.Grade * rMomentsAssessment.Weighting
                                                            else
                                                                TotalSubSubject +=
                                                                          rAssessingStudents."Recuperation Grade" * rMomentsAssessment.Weighting;

                                                        until rAssessingStudents.Next = 0;

                                                until lSettingRatingsSubSubjects.Next = 0;
                                            end;
                                        until rMomentsAssessment.Next = 0;
                                    end;

                                    //Insert the line if evaluation exist for the sub Subject

                                    if TotalSubSubject <> 0 then begin
                                        Total := 0;
                                        Total := Round(TotalSubSubject / TotalPonderSubSubj, rAssessementConfiguration."FY Sub Subject Round Method");

                                        InsertClassification(
                                                             pClass,
                                                             pSchoolYear,
                                                             LastSchoolingYear,
                                                             rStudyPlanSubSubjectsLines."Subject Code",
                                                             rStudyPlanSubSubjectsLines."Sub-Subject Code",
                                                             rCourseLines.Code,
                                                             pStudent,
                                                             pEvaluationMoment,
                                                             pMoment,
                                                             Total,
                                                             rClass.Type,
                                                             rCourseLines."Country/Region Code",
                                                             rCourseLines."Evaluation Type",
                                                             rCourseLines."Assessment Code"
                                                             );

                                        //sum the clasifications for the Group evaluation
                                        if rCourseLines."Option Group" <> '' then begin
                                            TotalPonderGroupSubType2 += rStudyPlanSubSubjectsLines."Moment Ponder";
                                            TotalGroupSubType2 += Total * rStudyPlanSubSubjectsLines."Moment Ponder";
                                        end;

                                        //sum the clasifications for the Final evaluation
                                        if rCourseLines."Option Group" <> '' then begin
                                            TotalPonderFinalType3 += rStudyPlanSubSubjectsLines."Moment Ponder";
                                            TotalFinalType3 += Total * rStudyPlanSubSubjectsLines."Moment Ponder";
                                        end;
                                    end;
                                    //sum the clasifications for the Sub-Subject evaluation
                                    TotalPonderSubSubjType1 += rStudyPlanSubSubjectsLines."Moment Ponder";
                                    TotalSubSubjectType1 +=
                                      Total * rStudyPlanSubSubjectsLines."Moment Ponder";


                                until rStudyPlanSubSubjectsLines.Next = 0;
                            if rAssessementConfiguration."FY Subjects Classification" =
                              rAssessementConfiguration."FY Subjects Classification"::"Sub-Subject (Vertical) " then begin
                                if TotalSubSubjectType1 <> 0 then begin
                                    Total := 0;
                                    Total := Round(TotalSubSubjectType1 / TotalPonderSubSubjType1, rAssessementConfiguration."FY Subject Round Method");


                                    InsertClassification(pClass,
                                                       pSchoolYear,
                                                       LastSchoolingYear,
                                                       rCourseLines."Subject Code",
                                                       '',
                                                       rCourseLines.Code,
                                                       pStudent,
                                                       pEvaluationMoment,
                                                       pMoment,
                                                       Total,
                                                       rClass.Type,
                                                       rCourseLines."Country/Region Code",
                                                       rCourseLines."Evaluation Type",
                                                       rCourseLines."Assessment Code"
                                                       );

                                    //sum the clasifications for the Group evaluation
                                    if rCourseLines."Option Group" <> '' then begin
                                        TotalPonderGroupSubType3 += rCourseLines.Weighting;
                                        TotalGroupSubType3 += Total * rCourseLines.Weighting;
                                    end;

                                    //sum the clasifications for the final evaluation
                                    TotalPonderFinalType4 += rCourseLines.Weighting;
                                    TotalFinalType4 += Total * rCourseLines.Weighting;

                                end;
                            end;

                        end else begin
                            TotalPonderSubSubj := 0;
                            TotalSubSubject := 0;

                            rMomentsAssessment.Reset;
                            rMomentsAssessment.SetRange("School Year", pSchoolYear);
                            rMomentsAssessment.SetRange("Schooling Year", rClass."Schooling Year");
                            rMomentsAssessment.SetRange("Responsibility Center", rCourseLines."Responsibility Center");
                            rMomentsAssessment.SetRange("Evaluation Moment", rMomentsAssessment."Evaluation Moment"::"Final Moment");
                            if rMomentsAssessment.FindSet then begin
                                repeat
                                    lSettingRatings.Reset;
                                    lSettingRatings.SetRange("School Year", pSchoolYear);
                                    lSettingRatings.SetRange("Schooling Year", rClass."Schooling Year");
                                    lSettingRatings.SetRange("Study Plan Code", rCourseLines.Code);
                                    lSettingRatings.SetRange("Subject Code", rCourseLines."Subject Code");
                                    lSettingRatings.SetRange("Type Education", lSettingRatings."Type Education"::Multi);
                                    lSettingRatings.SetRange("Moment Code", rMomentsAssessment."Moment Code");
                                    if lSettingRatings.FindSet then begin
                                        repeat
                                            rAssessingStudents.Reset;
                                            rAssessingStudents.SetRange(Class, pClass);
                                            rAssessingStudents.SetRange("School Year", pSchoolYear);
                                            rAssessingStudents.SetRange("Moment Code", lSettingRatings."Moment Code");
                                            rAssessingStudents.SetRange(Subject, rCourseLines."Subject Code");
                                            rAssessingStudents.SetRange("Sub-Subject Code", '');
                                            rAssessingStudents.SetRange("Student Code No.", pStudent);
                                            if rAssessingStudents.FindSet then
                                                repeat

                                                    TotalPonderSubSubj += rMomentsAssessment.Weighting;

                                                    if rAssessingStudents."Recuperation Grade" = 0 then
                                                        TotalSubSubject +=
                                                              rAssessingStudents.Grade * rMomentsAssessment.Weighting
                                                    else
                                                        TotalSubSubject +=
                                                                rAssessingStudents."Recuperation Grade" * rMomentsAssessment.Weighting;

                                                until rAssessingStudents.Next = 0;

                                        until lSettingRatings.Next = 0;
                                    end;
                                until rMomentsAssessment.Next = 0;
                                if TotalSubSubject <> 0 then begin
                                    Total := 0;
                                    Total := Round(TotalSubSubject / TotalPonderSubSubj, rAssessementConfiguration."FY Subject Round Method");

                                    InsertClassification(
                                                         pClass,
                                                         pSchoolYear,
                                                         LastSchoolingYear,
                                                         rCourseLines."Subject Code",
                                                         '',
                                                         rCourseLines.Code,
                                                         pStudent,
                                                         pEvaluationMoment,
                                                         pMoment,
                                                         Total,
                                                         rClass.Type,
                                                         rCourseLines."Country/Region Code",
                                                         rCourseLines."Evaluation Type",
                                                         rCourseLines."Assessment Code"
                                                         );

                                    //sum the clasifications for the Group evaluation
                                    if rCourseLines."Option Group" <> '' then begin
                                        TotalPonderGroupSubType3 += rCourseLines.Weighting;
                                        TotalGroupSubType3 += Total * rCourseLines.Weighting;
                                    end;

                                    //sum the clasifications for the final evaluation
                                    TotalPonderFinalType4 += rCourseLines.Weighting;
                                    TotalFinalType4 += Total * rCourseLines.Weighting;

                                end;
                            end;
                        end;

                        LastOptionGroup := rCourseLines."Option Group";

                    until rCourseLines.Next = 0;

                    //Post the last group subject
                    case rAssessementConfiguration."FY Group Sub. Classification" of
                        rAssessementConfiguration."FY Group Sub. Classification"::"Group (Horizontal)":
                            begin
                                TotalPonderGroupSubType1 := 0;
                                TotalGroupSubType1 := 0;

                                //Get the pounder of the group
                                rGroupSubjects.Reset;
                                rGroupSubjects.SetRange("Schooling Year", '');
                                rGroupSubjects.SetRange(Code, LastOptionGroup);
                                if rGroupSubjects.FindSet then;

                                rGroupSubjects.TestField("Assessment Code");

                                rMomentsAssessment.Reset;
                                rMomentsAssessment.SetRange("School Year", pSchoolYear);
                                rMomentsAssessment.SetRange("Schooling Year", rClass."Schooling Year");
                                rMomentsAssessment.SetRange("Responsibility Center", rCourseLines."Responsibility Center");
                                rMomentsAssessment.SetRange("Evaluation Moment", rMomentsAssessment."Evaluation Moment"::"Final Moment");
                                if rMomentsAssessment.FindSet then begin
                                    repeat
                                        GroupSubjectPonder := rMomentsAssessment.Weighting;
                                        rAssessingStudentsFinal.Reset;
                                        rAssessingStudentsFinal.SetRange("Evaluation Type", rAssessingStudentsFinal."Evaluation Type"::"Final Moment Group")
                         ;
                                        rAssessingStudentsFinal.SetRange("School Year", pSchoolYear);
                                        rAssessingStudentsFinal.SetRange("Schooling Year", rClass."Schooling Year");
                                        rAssessingStudentsFinal.SetRange("Option Group", LastOptionGroup);
                                        rAssessingStudentsFinal.SetRange("Student Code No.", pStudent);
                                        if rAssessingStudentsFinal.FindSet then begin
                                            repeat
                                                TotalPonderGroupSubType1 += GroupSubjectPonder;
                                                if rAssessingStudentsFinal."Manual Grade" = 0 then
                                                    TotalGroupSubType1 += rAssessingStudentsFinal.Grade * GroupSubjectPonder
                                                else
                                                    TotalGroupSubType1 += rAssessingStudentsFinal."Manual Grade" * GroupSubjectPonder;
                                            until rAssessingStudentsFinal.Next = 0;

                                            if TotalGroupSubType1 <> 0 then begin
                                                Total := 0;
                                                Total :=
                                                  Round(TotalGroupSubType1 / TotalPonderGroupSubType1,
                                                  rAssessementConfiguration."FY Group Sub. Round Method");

                                                InsertFinalClassification(pClass,
                                                                     pSchoolYear,
                                                                     LastSchoolingYear,
                                                                     '',
                                                                      '',
                                                                     rCourseLines.Code,
                                                                     pStudent,
                                                                     pEvaluationMoment,
                                                                     pMoment,
                                                                     Total,
                                                                     rClass.Type,
                                                                     LastOptionGroup,
                                                                     rCourseLines."Country/Region Code",
                                                                     1,
                                                                     0);
                                                //sum the clasifications for the Final evaluation
                                                TotalPonderFinalType2 += rGroupSubjects.Ponder;
                                                TotalFinalType2 += Total;

                                                TotalGroupSubType1 := 0;
                                                TotalPonderGroupSubType1 := 0;
                                            end;

                                        end;
                                    until rMomentsAssessment.Next = 0;

                                    TotalPonderGroupSubType1 := 0;
                                    TotalGroupSubType1 := 0;
                                    TotalPonderGroupSubType2 := 0;
                                    TotalGroupSubType2 := 0;
                                    TotalPonderGroupSubType3 := 0;
                                    TotalGroupSubType3 := 0;

                                end;
                            end;

                        rAssessementConfiguration."FY Group Sub. Classification"::"Sub-Subject (Vertical) ":
                            begin
                                if TotalGroupSubType2 <> 0 then begin
                                    Total := 0;
                                    Total :=
                                      Round(TotalGroupSubType2 / TotalPonderGroupSubType2,
                                      rAssessementConfiguration."FY Group Sub. Round Method");

                                    InsertFinalClassification(pClass,
                                                         pSchoolYear,
                                                         LastSchoolingYear,
                                                         '',
                                                          '',
                                                         rCourseLines.Code,
                                                         pStudent,
                                                         pEvaluationMoment,
                                                         pMoment,
                                                         Total,
                                                         rClass.Type,
                                                         LastOptionGroup,
                                                         rCourseLines."Country/Region Code",
                                                       1,
                                                       0);

                                    TotalPonderGroupSubType2 := 0;
                                    TotalGroupSubType2 := 0;
                                end;
                            end;

                        rAssessementConfiguration."FY Group Sub. Classification"::"Subject (Vertical)":
                            begin
                                if TotalGroupSubType3 <> 0 then begin
                                    Total := 0;
                                    Total :=
                                      Round(TotalGroupSubType3 / TotalPonderGroupSubType3,
                                      rAssessementConfiguration."FY Group Sub. Round Method");

                                    InsertFinalClassification(pClass,
                                                         pSchoolYear,
                                                         LastSchoolingYear,
                                                         '',
                                                          '',
                                                         rCourseLines.Code,
                                                         pStudent,
                                                         pEvaluationMoment,
                                                         pMoment,
                                                         Total,
                                                         rClass.Type,
                                                         LastOptionGroup,
                                                         rCourseLines."Country/Region Code",
                                                       1,
                                                       0);

                                    TotalPonderGroupSubType3 := 0;
                                    TotalGroupSubType3 := 0;
                                end;
                            end;
                    end;

                    //Post the final evaluation for the student
                    case rAssessementConfiguration."FY Final Classification" of
                        rAssessementConfiguration."FY Final Classification"::"Final (Horizontal)":
                            begin
                                rMomentsAssessment.Reset;
                                rMomentsAssessment.SetRange("School Year", pSchoolYear);
                                rMomentsAssessment.SetRange("Schooling Year", rClass."Schooling Year");
                                rMomentsAssessment.SetRange("Responsibility Center", rCourseLines."Responsibility Center");
                                rMomentsAssessment.SetRange("Evaluation Moment", rMomentsAssessment."Evaluation Moment"::"Final Moment");
                                if rMomentsAssessment.FindSet then begin
                                    repeat
                                        rAssessingStudentsFinal.Reset;
                                        rAssessingStudentsFinal.SetRange("Evaluation Type", rAssessingStudentsFinal."Evaluation Type"::"Final Moment");
                                        rAssessingStudentsFinal.SetRange("School Year", pSchoolYear);
                                        rAssessingStudentsFinal.SetRange("Schooling Year", rClass."Schooling Year");
                                        rAssessingStudentsFinal.SetRange("Student Code No.", pStudent);
                                        rAssessingStudentsFinal.SetRange("Moment Code", rMomentsAssessment."Moment Code");
                                        if rAssessingStudentsFinal.FindSet then begin
                                            repeat
                                                TotalPonderFinalType1 += rMomentsAssessment.Weighting;
                                                TotalFinalType1 += rAssessingStudentsFinal.Grade * rMomentsAssessment.Weighting;
                                            until rAssessingStudentsFinal.Next = 0;
                                        end;

                                    until rMomentsAssessment.Next = 0;

                                    if TotalFinalType1 <> 0 then begin
                                        Total := 0;
                                        Total :=
                                          Round(TotalFinalType1 / TotalPonderFinalType1,
                                          rAssessementConfiguration."FY Final Round Method");

                                        InsertFinalClassification(pClass,
                                                             pSchoolYear,
                                                             LastSchoolingYear,
                                                             '',
                                                             '',
                                                             rCourseLines.Code,
                                                             pStudent,
                                                             pEvaluationMoment,
                                                             pMoment,
                                                             Total,
                                                             rClass.Type,
                                                             '',
                                                             rCourseLines."Country/Region Code",
                                                    0,
                                                             0);

                                        TotalFinalType1 := 0;
                                        TotalPonderFinalType1 := 0;
                                    end;
                                end;
                            end;

                        rAssessementConfiguration."FY Final Classification"::"Group (Horizontal)":
                            begin
                                TotalFinalType2 := 0;
                                TotalPonderFinalType2 := 0;
                                //rMomentsAssessment.RESET;
                                //rMomentsAssessment.SETRANGE("School Year",pSchoolYear);
                                //rMomentsAssessment.SETRANGE("Schooling Year",rclass."Schooling Year");
                                //rMomentsAssessment.SETRANGE("Responsibility Center",rCourseLines."Responsibility Center");
                                //rMomentsAssessment.SETRANGE("Evaluation Moment",rMomentsAssessment."Evaluation Moment"::"Final Moment");
                                //IF rMomentsAssessment.FINDSET THEN BEGIN
                                //  REPEAT
                                rAssessingStudentsFinal.Reset;
                                rAssessingStudentsFinal.SetRange("Evaluation Type", rAssessingStudentsFinal."Evaluation Type"::"Final Year Group");
                                rAssessingStudentsFinal.SetRange("School Year", pSchoolYear);
                                rAssessingStudentsFinal.SetRange("Schooling Year", rClass."Schooling Year");
                                rAssessingStudentsFinal.SetRange("Student Code No.", pStudent);
                                if rAssessingStudentsFinal.FindSet then begin
                                    repeat
                                        rGroupSubjects.Reset;
                                        rGroupSubjects.SetRange(Code, rAssessingStudentsFinal."Option Group");
                                        if rGroupSubjects.FindSet then begin
                                            rGroupSubjects.TestField("Assessment Code");
                                            TotalPonderFinalType2 += rGroupSubjects.Ponder;
                                            if rAssessingStudentsFinal."Manual Grade" = 0 then
                                                TotalFinalType2 += rAssessingStudentsFinal.Grade * rGroupSubjects.Ponder
                                            else
                                                TotalFinalType2 += rAssessingStudentsFinal."Manual Grade" * rGroupSubjects.Ponder;
                                        end;
                                    until rAssessingStudentsFinal.Next = 0;
                                end;
                                //  UNTIL rMomentsAssessment.NEXT = 0;
                                //END;
                                if TotalFinalType2 <> 0 then begin
                                    Total := 0;
                                    Total :=
                                      Round(TotalFinalType2 / TotalPonderFinalType2,
                                      rAssessementConfiguration."FY Final Round Method");

                                    InsertFinalClassification(pClass,
                                                         pSchoolYear,
                                                         LastSchoolingYear,
                                                         '',
                                                         '',
                                                         rCourseLines.Code,
                                                         pStudent,
                                                         pEvaluationMoment,
                                                         pMoment,
                                                         Total,
                                                         rClass.Type,
                                                         '',
                                                         rCourseLines."Country/Region Code",
                                                    0,
                                                         0);

                                    TotalFinalType2 := 0;
                                    TotalPonderFinalType2 := 0;
                                end;
                            end;

                        rAssessementConfiguration."FY Final Classification"::"Sub-Subject (Vertical)":
                            begin
                                if TotalFinalType3 <> 0 then begin
                                    Total := 0;
                                    Total :=
                                      Round(TotalFinalType3 / TotalPonderFinalType3,
                                      rAssessementConfiguration."FY Final Round Method");

                                    InsertFinalClassification(pClass,
                                                         pSchoolYear,
                                                         LastSchoolingYear,
                                                         '',
                                                         '',
                                                         rCourseLines.Code,
                                                         pStudent,
                                                         pEvaluationMoment,
                                                         pMoment,
                                                         Total,
                                                         rClass.Type,
                                                         '',
                                                         rCourseLines."Country/Region Code",
                                                    0,
                                                         0);

                                    TotalFinalType3 := 0;
                                    TotalPonderFinalType3 := 0;
                                end;
                            end;

                        rAssessementConfiguration."FY Final Classification"::"Subject (Vertical)":
                            begin
                                if TotalFinalType4 <> 0 then begin
                                    Total := 0;
                                    Total :=
                                      Round(TotalFinalType4 / TotalPonderFinalType4,
                                      rAssessementConfiguration."FY Final Round Method");

                                    InsertFinalClassification(pClass,
                                                         pSchoolYear,
                                                         LastSchoolingYear,
                                                         '',
                                                         '',
                                                         rCourseLines.Code,
                                                         pStudent,
                                                         pEvaluationMoment,
                                                         pMoment,
                                                         Total,
                                                         rClass.Type,
                                                         '',
                                                         rCourseLines."Country/Region Code",
                                                    0,
                                                         0);

                                    TotalFinalType4 := 0;
                                    TotalPonderFinalType4 := 0;
                                end;
                            end;
                    end;
                    //BEGIN LEgal
                    //legal course
                    if rAssessementConfiguration."Use Evaluation Rules" then begin

                        varCount := 0;
                        VarSum := 0;
                        Flag1 := true;
                        Flag2 := true;
                        Flag3 := true;
                        Flag4 := true;
                        Flag5 := true;
                        Flag6 := true;
                        rRulesEvaluations.Reset;
                        rRulesEvaluations.SetRange("Study Plan Code", rClass."Study Plan Code");
                        rRulesEvaluations.SetRange(Type, rClass.Type);
                        rRulesEvaluations.SetRange("Schooling Year", rClass."Schooling Year");
                        rRulesEvaluations.SetRange("School Year", rClass."School Year");
                        rRulesEvaluations.SetRange("Classifications Calculations",
                                                    rRulesEvaluations."Classifications Calculations"::"Final Cycle");
                        if rRulesEvaluations.FindSet then begin
                            repeat
                                if rRulesEvaluations."Value 1" = rRulesEvaluations."Value 1"::"Final Year" then begin
                                    InsertFinalCycle(rClass, pStudent, rRulesEvaluations);
                                end;
                            until rRulesEvaluations.Next = 0;
                        end;
                        //FINAL YEAR  ESO
                        rRulesEvaluations.Reset;
                        rRulesEvaluations.SetRange("Study Plan Code", rClass."Study Plan Code");
                        rRulesEvaluations.SetRange(Type, rClass.Type);
                        rRulesEvaluations.SetRange("Schooling Year", rClass."Schooling Year");
                        rRulesEvaluations.SetRange("School Year", rClass."School Year");
                        rRulesEvaluations.SetRange("Classifications Calculations", rRulesEvaluations."Classifications Calculations"::"Final Year"
              );
                        if rRulesEvaluations.FindSet then begin
                            repeat
                                rCourseLines.Reset;
                                rCourseLines.SetCurrentKey("Option Group", "Subject Code");
                                rCourseLines.SetRange(Code, rClass."Study Plan Code");
                                rCourseLines.SetRange("Subject Excluded From Assess.", false);
                                if rCourseLines.FindSet then begin
                                    repeat
                                        rAssessingStudents.Reset;
                                        rAssessingStudents.SetRange("Schooling Year", rClass."Schooling Year");
                                        rAssessingStudents.SetRange(Subject, rCourseLines."Subject Code");
                                        rAssessingStudents.SetRange("Student Code No.", pStudent);
                                        rAssessingStudents.SetRange("Evaluation Moment", rAssessingStudents."Evaluation Moment"::"Final Year");
                                        if rAssessingStudents.FindFirst then begin
                                            if ((rCourseLines."Option Group" <> rRulesEvaluations."Code Value 1") and
                                              (rRulesEvaluations."Code Value 1" <> '')) then begin
                                                varCount += 1;
                                                VarSum += rAssessingStudents.Grade;
                                            end;
                                            if ((rCourseLines."Option Group" <> rRulesEvaluations."Code Value 2") and
                                              (rRulesEvaluations."Code Value 2" <> '')) then begin
                                                varCount += 1;
                                                VarSum += rAssessingStudents.Grade;
                                            end;
                                            if ((rCourseLines."Option Group" <> rRulesEvaluations."Code Value 3") and
                                              (rRulesEvaluations."Code Value 3" <> '')) then begin
                                                varCount += 1;
                                                VarSum += rAssessingStudents.Grade;
                                            end;
                                            if ((rCourseLines."Option Group" <> rRulesEvaluations."Code Value 4") and
                                              (rRulesEvaluations."Code Value 4" <> '')) then begin
                                                varCount += 1;
                                                VarSum += rAssessingStudents.Grade;
                                            end;
                                            if ((rCourseLines."Option Group" <> rRulesEvaluations."Code Value 5") and
                                              (rRulesEvaluations."Code Value 5" <> '')) then begin
                                                varCount += 1;
                                                VarSum += rAssessingStudents.Grade;
                                            end;
                                            if ((rCourseLines."Option Group" <> rRulesEvaluations."Code Value 6") and
                                              (rRulesEvaluations."Code Value 6" <> '')) then begin
                                                varCount += 1;
                                                VarSum += rAssessingStudents.Grade;
                                            end;
                                        end;

                                        if rCourseLines."Option Group" <> '' then begin
                                            rAssessingStudentsFinal.Reset;
                                            rAssessingStudentsFinal.SetRange("Schooling Year", rClass."Schooling Year");
                                            rAssessingStudentsFinal.SetRange("Student Code No.", pStudent);
                                            rAssessingStudentsFinal.SetRange("Evaluation Type", rAssessingStudentsFinal."Evaluation Type"::"Final Year Group");
                                            if rAssessingStudentsFinal.FindSet then begin
                                                repeat
                                                    if (rCourseLines."Option Group" = rAssessingStudentsFinal."Option Group") and
                                                       (rCourseLines."Option Group" = rRulesEvaluations."Code Value 1") and Flag1 then begin
                                                        varCount += 1;
                                                        VarSum += rAssessingStudentsFinal.Grade;
                                                        Flag1 := false;
                                                    end;
                                                    if (rCourseLines."Option Group" = rAssessingStudentsFinal."Option Group") and
                                                       (rCourseLines."Option Group" = rRulesEvaluations."Code Value 2") and Flag2 then begin
                                                        varCount += 1;
                                                        VarSum += rAssessingStudentsFinal.Grade;
                                                        Flag2 := false;
                                                    end;
                                                    if (rCourseLines."Option Group" = rAssessingStudentsFinal."Option Group") and
                                                       (rCourseLines."Option Group" = rRulesEvaluations."Code Value 3") and Flag3 then begin
                                                        varCount += 1;
                                                        VarSum += rAssessingStudentsFinal.Grade;
                                                        Flag3 := false;
                                                    end;
                                                    if (rCourseLines."Option Group" = rAssessingStudentsFinal."Option Group") and
                                                       (rCourseLines."Option Group" = rRulesEvaluations."Code Value 4") and Flag4 then begin
                                                        varCount += 1;
                                                        VarSum += rAssessingStudentsFinal.Grade;
                                                        Flag4 := false;
                                                    end;
                                                    if (rCourseLines."Option Group" = rAssessingStudentsFinal."Option Group") and
                                                       (rCourseLines."Option Group" = rRulesEvaluations."Code Value 5") and Flag5 then begin
                                                        varCount += 1;
                                                        VarSum += rAssessingStudentsFinal.Grade;
                                                        Flag5 := false;
                                                    end;
                                                    if (rCourseLines."Option Group" = rAssessingStudentsFinal."Option Group") and
                                                       (rCourseLines."Option Group" = rRulesEvaluations."Code Value 6") and Flag6 then begin
                                                        varCount += 1;
                                                        VarSum += rAssessingStudentsFinal.Grade;
                                                        Flag6 := false;
                                                    end;

                                                until rAssessingStudentsFinal.Next = 0;
                                            end;
                                        end;
                                    until rCourseLines.Next = 0;

                                    if varCount > 0 then
                                        Total := Round(VarSum / varCount, rRulesEvaluations."Round Method");


                                    InsertFinalClassification(pClass,
                                                         pSchoolYear,
                                                         LastSchoolingYear,
                                                         '',
                                                          '',
                                                         rCourseLines.Code,
                                                         pStudent,
                                                         pEvaluationMoment,
                                                         pMoment,
                                                         Total,
                                                         rClass.Type,
                                                         '',
                                                         rCourseLines."Country/Region Code",
                                                           0,
                                                           rRulesEvaluations."Entry No.");

                                end;
                            until rRulesEvaluations.Next = 0;
                        end;

                        //Final STAGE ESO
                        rRulesEvaluations.Reset;
                        rRulesEvaluations.SetRange("Study Plan Code", rClass."Study Plan Code");
                        rRulesEvaluations.SetRange(Type, rClass.Type);
                        rRulesEvaluations.SetRange("Schooling Year", rClass."Schooling Year");
                        rRulesEvaluations.SetRange("School Year", rClass."School Year");
                        rRulesEvaluations.SetRange("Classifications Calculations", rRulesEvaluations."Classifications Calculations"::"Final Stage"
               );
                        if rRulesEvaluations.FindSet then begin
                            repeat
                                if rRulesEvaluations."Value 1" = rRulesEvaluations."Value 1"::"Final Year" then begin
                                    if rRulesEvaluations."Code Value 1" = rClass."Schooling Year" then;
                                    InsertFinalStage(rClass, pStudent, rRulesEvaluations);
                                end;

                                if rRulesEvaluations."Value 1" = rRulesEvaluations."Value 1"::"Schooling Year" then begin
                                    rAssessingStudentsFinal.Reset;
                                    rAssessingStudentsFinal.SetRange("Evaluation Type", rAssessingStudentsFinal."Evaluation Type"::"Final Year");
                                    rAssessingStudentsFinal.SetRange("Schooling Year", rRulesEvaluations."Code Value 1");
                                    rAssessingStudentsFinal.SetRange("Student Code No.", pStudent);
                                    if rAssessingStudentsFinal.FindSet then begin
                                        repeat
                                            if FinalGrade[1] < rAssessingStudentsFinal.Grade then
                                                FinalGrade[1] := rAssessingStudentsFinal.Grade;
                                        until rAssessingStudentsFinal.Next = 0;
                                    end;
                                end;
                                if rRulesEvaluations."Value 2" = rRulesEvaluations."Value 2"::"Schooling Year" then begin
                                    rAssessingStudentsFinal.Reset;
                                    rAssessingStudentsFinal.SetRange("Evaluation Type", rAssessingStudentsFinal."Evaluation Type"::"Final Year");
                                    rAssessingStudentsFinal.SetRange("Schooling Year", rRulesEvaluations."Code Value 2");
                                    rAssessingStudentsFinal.SetRange("Student Code No.", pStudent);
                                    if rAssessingStudentsFinal.FindSet then begin
                                        repeat
                                            if FinalGrade[2] < rAssessingStudentsFinal.Grade then
                                                FinalGrade[2] := rAssessingStudentsFinal.Grade;
                                        until rAssessingStudentsFinal.Next = 0;
                                    end;
                                end;
                                if rRulesEvaluations."Value 3" = rRulesEvaluations."Value 3"::"Schooling Year" then begin
                                    rAssessingStudentsFinal.Reset;
                                    rAssessingStudentsFinal.SetRange("Evaluation Type", rAssessingStudentsFinal."Evaluation Type"::"Final Year");
                                    rAssessingStudentsFinal.SetRange("Schooling Year", rRulesEvaluations."Code Value 3");
                                    rAssessingStudentsFinal.SetRange("Student Code No.", pStudent);
                                    if rAssessingStudentsFinal.FindSet then begin
                                        repeat
                                            if FinalGrade[3] < rAssessingStudentsFinal.Grade then
                                                FinalGrade[3] := rAssessingStudentsFinal.Grade;
                                        until rAssessingStudentsFinal.Next = 0;
                                    end;
                                end;
                                if rRulesEvaluations."Value 4" = rRulesEvaluations."Value 4"::"Schooling Year" then begin
                                    rAssessingStudentsFinal.Reset;
                                    rAssessingStudentsFinal.SetRange("Evaluation Type", rAssessingStudentsFinal."Evaluation Type"::"Final Year");
                                    rAssessingStudentsFinal.SetRange("Schooling Year", rRulesEvaluations."Code Value 4");
                                    rAssessingStudentsFinal.SetRange("Student Code No.", pStudent);
                                    if rAssessingStudentsFinal.FindSet then begin
                                        repeat
                                            if FinalGrade[4] < rAssessingStudentsFinal.Grade then
                                                FinalGrade[4] := rAssessingStudentsFinal.Grade;
                                        until rAssessingStudentsFinal.Next = 0;
                                    end;
                                end;
                                if rRulesEvaluations."Value 5" = rRulesEvaluations."Value 5"::"Schooling Year" then begin
                                    rAssessingStudentsFinal.Reset;
                                    rAssessingStudentsFinal.SetRange("Evaluation Type", rAssessingStudentsFinal."Evaluation Type"::"Final Year");
                                    rAssessingStudentsFinal.SetRange("Schooling Year", rRulesEvaluations."Code Value 5");
                                    rAssessingStudentsFinal.SetRange("Student Code No.", pStudent);
                                    if rAssessingStudentsFinal.FindSet then begin
                                        repeat
                                            if FinalGrade[5] < rAssessingStudentsFinal.Grade then
                                                FinalGrade[5] := rAssessingStudentsFinal.Grade;
                                        until rAssessingStudentsFinal.Next = 0;
                                    end;
                                end;
                                if rRulesEvaluations."Value 6" = rRulesEvaluations."Value 6"::"Schooling Year" then begin
                                    rAssessingStudentsFinal.Reset;
                                    rAssessingStudentsFinal.SetRange("Evaluation Type", rAssessingStudentsFinal."Evaluation Type"::"Final Year");
                                    rAssessingStudentsFinal.SetRange("Schooling Year", rRulesEvaluations."Code Value 6");
                                    rAssessingStudentsFinal.SetRange("Student Code No.", pStudent);
                                    if rAssessingStudentsFinal.FindSet then begin
                                        repeat
                                            if FinalGrade[6] < rAssessingStudentsFinal.Grade then
                                                FinalGrade[6] := rAssessingStudentsFinal.Grade;
                                        until rAssessingStudentsFinal.Next = 0;
                                    end;
                                end;
                                Total := Round(
                                  cParser.CalcDecimalExpr(StrSubstNo(rRulesEvaluations.Formula, FinalGrade[1], FinalGrade[2], FinalGrade[3], FinalGrade[4]
                    ,
                                  FinalGrade[5], FinalGrade[6])), rRulesEvaluations."Round Method");
                                if Total <> 0 then
                                    InsertFinalClassification(pClass,
                                                         pSchoolYear,
                                                         LastSchoolingYear,
                                                         '',
                                                          '',
                                                         rCourseLines.Code,
                                                         pStudent,
                                                         pEvaluationMoment,
                                                         pMoment,
                                                         Total,
                                                         rClass.Type,
                                                         '',
                                                         rCourseLines."Country/Region Code",
                                                          5,
                                                          rRulesEvaluations."Entry No.");

                            until rRulesEvaluations.Next = 0;
                        end;
                        //Final STAGE BCH2
                        rRulesEvaluations.Reset;
                        rRulesEvaluations.SetRange("Study Plan Code", rClass."Study Plan Code");
                        rRulesEvaluations.SetRange(Type, rClass.Type);
                        rRulesEvaluations.SetRange("Schooling Year", rClass."Schooling Year");
                        rRulesEvaluations.SetRange("School Year", rClass."School Year");
                        rRulesEvaluations.SetRange("Classifications Calculations", rRulesEvaluations."Classifications Calculations"::"Final Stage"
               );
                        if rRulesEvaluations.FindSet then begin
                            repeat
                                if rRulesEvaluations."Value 1" = rRulesEvaluations."Value 1"::"All Subjects - Grade" then begin
                                    FinalGrade[1] := 0;
                                    FinalGrade[2] := 0;
                                    FinalGrade[3] := 0;
                                    FinalGrade[4] := 0;
                                    FinalGrade[5] := 0;
                                    FinalGrade[6] := 0;
                                    varCount := 0;
                                    rCourseLines.Reset;
                                    rCourseLines.SetRange(Code, rClass."Study Plan Code");
                                    rCourseLines.SetFilter("Legal Code", '<>%1', '');
                                    rCourseLines.SetRange("Subject Excluded From Assess.", false);
                                    if rCourseLines.FindSet then begin
                                        repeat
                                            rStrEduCountry.Reset;
                                            rStrEduCountry.SetCurrentKey("Sorting ID");
                                            rStrEduCountry.SetRange("Edu. Level", rRulesEvaluations."Edu. Level");
                                            if rStrEduCountry.FindSet then begin
                                                repeat
                                                    rAssessingStudents.Reset;
                                                    rAssessingStudents.SetRange("Schooling Year", rStrEduCountry."Schooling Year");
                                                    rAssessingStudents.SetRange(Subject, rCourseLines."Subject Code");
                                                    rAssessingStudents.SetRange("Sub-Subject Code", '');
                                                    rAssessingStudents.SetRange("Student Code No.", pStudent);
                                                    rAssessingStudents.SetRange("Evaluation Moment", rAssessingStudents."Evaluation Moment"::"Final Year");
                                                    if rAssessingStudents.FindSet then begin
                                                        FinalGrade[1] += rAssessingStudents.Grade;

                                                        if (rRulesEvaluations."Value 2" = rRulesEvaluations."Value 2"::"Legal Code") and
                                                           (rRulesEvaluations."Code Value 2" = rCourseLines."Legal Code") then begin
                                                            FinalGrade[2] += rAssessingStudents.Grade;
                                                            FinalGrade[1] -= rAssessingStudents.Grade;
                                                        end;
                                                        if (rRulesEvaluations."Value 3" = rRulesEvaluations."Value 3"::"Legal Code") and
                                                          (rRulesEvaluations."Code Value 3" = rCourseLines."Legal Code") then begin
                                                            FinalGrade[3] += rAssessingStudents.Grade;
                                                            FinalGrade[1] -= rAssessingStudents.Grade;
                                                        end;
                                                        if (rRulesEvaluations."Value 4" = rRulesEvaluations."Value 4"::"Legal Code") and
                                                          (rRulesEvaluations."Code Value 4" = rCourseLines."Legal Code") then begin
                                                            FinalGrade[4] += rAssessingStudents.Grade;
                                                            FinalGrade[1] -= rAssessingStudents.Grade;
                                                        end;

                                                        if (rRulesEvaluations."Value 5" = rRulesEvaluations."Value 5"::"Legal Code") and
                                                          (rRulesEvaluations."Code Value 5" = rCourseLines."Legal Code") then begin
                                                            FinalGrade[5] += rAssessingStudents.Grade;
                                                            FinalGrade[1] -= rAssessingStudents.Grade;
                                                        end;

                                                        if (rRulesEvaluations."Value 6" = rRulesEvaluations."Value 6"::"Legal Code") and
                                                         (rRulesEvaluations."Code Value 6" = rCourseLines."Legal Code") then begin
                                                            FinalGrade[6] += rAssessingStudents.Grade;
                                                            FinalGrade[1] -= rAssessingStudents.Grade;
                                                        end;


                                                        if (rRulesEvaluations."Value 2" = rRulesEvaluations."Value 2"::"All Subjects - Qtd") then
                                                            FinalGrade[2] += 1;

                                                        if (rRulesEvaluations."Value 3" = rRulesEvaluations."Value 3"::"All Subjects - Qtd") then
                                                            FinalGrade[3] += 1;

                                                        if (rRulesEvaluations."Value 4" = rRulesEvaluations."Value 4"::"All Subjects - Qtd") then
                                                            FinalGrade[4] += 1;

                                                        if (rRulesEvaluations."Value 5" = rRulesEvaluations."Value 5"::"All Subjects - Qtd") then
                                                            FinalGrade[5] += 1;

                                                        if (rRulesEvaluations."Value 6" = rRulesEvaluations."Value 6"::"All Subjects - Qtd") then
                                                            FinalGrade[6] += 1;


                                                    end;

                                                until rStrEduCountry.Next = 0;
                                            end;

                                        until rCourseLines.Next = 0;
                                    end;
                                    if (rRulesEvaluations."Value 2" = rRulesEvaluations."Value 2"::"All Subjects - Qtd")
                                      and (FinalGrade[2] > 0) then
                                        FinalGrade[2] -= 1;
                                    if (rRulesEvaluations."Value 3" = rRulesEvaluations."Value 3"::"All Subjects - Qtd")
                                     and (FinalGrade[3] > 0) then
                                        FinalGrade[3] -= 1;
                                    if (rRulesEvaluations."Value 4" = rRulesEvaluations."Value 4"::"All Subjects - Qtd")
                                     and (FinalGrade[4] > 0) then
                                        FinalGrade[4] -= 1;
                                    if (rRulesEvaluations."Value 5" = rRulesEvaluations."Value 5"::"All Subjects - Qtd")
                                     and (FinalGrade[5] > 0) then
                                        FinalGrade[5] -= 1;
                                    if (rRulesEvaluations."Value 6" = rRulesEvaluations."Value 6"::"All Subjects - Qtd")
                                     and (FinalGrade[6] > 0) then
                                        FinalGrade[6] -= 1;

                                    //COISO
                                    //FinalGrade[3] -= 1;
                                    Total := Round(
                                        cParser.CalcDecimalExpr(StrSubstNo(rRulesEvaluations.Formula,
                                                                           FinalGrade[1],
                                                                           FinalGrade[2],
                                                                           FinalGrade[3],
                                                                           FinalGrade[4],
                                                                           FinalGrade[5],
                                                                           FinalGrade[6],
                                                                           rRulesEvaluations."Round Method")));
                                    InsertFinalClassification(pClass,
                                                         pSchoolYear,
                                                         LastSchoolingYear,
                                                         '',
                                                          '',
                                                         rCourseLines.Code,
                                                         pStudent,
                                                         pEvaluationMoment,
                                                         pMoment,
                                                         Total,
                                                         rClass.Type,
                                                         '',
                                                         rCourseLines."Country/Region Code",
                                                           5,
                                                           rRulesEvaluations."Entry No.");



                                end;
                            until rRulesEvaluations.Next = 0;
                        end;
                    end;
                    //END LEGAL
                end;
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure ConvertOptionString(lGeneralTable: Record GeneralTable; pCodeType: Integer) ExitValue: Text[100]
    var
        rRefvar: RecordRef;
        fieldRefvar: FieldRef;
        lintOption: Integer;
        Optiontextvar: Text[1024];
        i: Integer;
    begin
        rRefvar.GetTable(lGeneralTable);
        fieldRefvar := rRefvar.Field(lGeneralTable.FieldNo("Entry Type"));
        Optiontextvar := Format(fieldRefvar.Type);
        if Optiontextvar = 'Option' then begin
            Optiontextvar := fieldRefvar.OptionCaption;
            //EVALUATE(i,pCodeType);
            i := pCodeType;
            lintOption := i + 1;
            ExitValue := SelectStr(lintOption, Optiontextvar);
        end;
    end;

    //[Scope('OnPrem')]
    procedure InsertFinalStage(pClass: Record Class; pStudentcode: Code[20]; pRulesEvaluations: Record "Rules of Evaluations")
    var
        l_AssessingStudents: Record "Assessing Students";
        l_AssessingStudentsFinal: Record "Assessing Students Final";
        l_AssessingStudentsFinal2: Record "Assessing Students Final";
        l_AssessingStudentsFinal3: Record "Assessing Students Final";
    begin
        l_AssessingStudentsFinal.LockTable(true);

        l_AssessingStudents.Reset;
        l_AssessingStudents.SetRange(Class, pClass.Class);
        l_AssessingStudents.SetRange("School Year", pClass."School Year");
        l_AssessingStudents.SetRange("Schooling Year", pClass."Schooling Year");
        l_AssessingStudents.SetRange("Sub-Subject Code", '');
        l_AssessingStudents.SetRange("Student Code No.", pStudentcode);
        l_AssessingStudents.SetRange("Evaluation Moment", l_AssessingStudents."Evaluation Moment"::"Final Year");
        l_AssessingStudents.SetRange("Study Plan Code", pClass."Study Plan Code");
        l_AssessingStudents.SetRange("Type Education", pClass.Type);
        if l_AssessingStudents.FindSet then begin
            repeat
                l_AssessingStudentsFinal.Init;
                l_AssessingStudentsFinal."Evaluation Type" := l_AssessingStudentsFinal."Evaluation Type"::"Final Stage";
                l_AssessingStudentsFinal.Class := l_AssessingStudents.Class;
                l_AssessingStudentsFinal."School Year" := l_AssessingStudents."School Year";
                l_AssessingStudentsFinal."Schooling Year" := l_AssessingStudents."Schooling Year";
                l_AssessingStudentsFinal.Subject := l_AssessingStudents.Subject;
                l_AssessingStudentsFinal."Study Plan Code" := l_AssessingStudents."Study Plan Code";
                l_AssessingStudentsFinal."Student Code No." := l_AssessingStudents."Student Code No.";
                l_AssessingStudentsFinal."Class No." := l_AssessingStudents."Class No.";
                l_AssessingStudentsFinal.Grade := Round(l_AssessingStudents.Grade, pRulesEvaluations."Round Method");
                l_AssessingStudentsFinal."Qualitative Grade" :=
                                          ValidateAssessmentMixed(l_AssessingStudentsFinal.Grade, pRulesEvaluations."Assessment Code");
                l_AssessingStudentsFinal."Type Education" := l_AssessingStudents."Type Education";
                l_AssessingStudentsFinal."Country/Region Code" := l_AssessingStudents."Country/Region Code";
                l_AssessingStudentsFinal.Insert;
            until l_AssessingStudents.Next = 0;
        end;



        l_AssessingStudentsFinal2.Reset;
        l_AssessingStudentsFinal2.SetRange("Evaluation Type", l_AssessingStudentsFinal2."Evaluation Type"::"Final Year");
        l_AssessingStudentsFinal2.SetRange("Student Code No.", pStudentcode);
        l_AssessingStudentsFinal2.SetRange(Class, pClass.Class);
        l_AssessingStudentsFinal2.SetRange("School Year", pClass."School Year");
        l_AssessingStudentsFinal2.SetRange("Schooling Year", pClass."Schooling Year");
        if l_AssessingStudentsFinal2.FindSet then begin
            l_AssessingStudentsFinal3.Init;
            l_AssessingStudentsFinal3.TransferFields(l_AssessingStudentsFinal2);
            l_AssessingStudentsFinal3."Moment Code" := '';
            l_AssessingStudentsFinal3."Evaluation Type" := l_AssessingStudentsFinal3."Evaluation Type"::"Final Stage";
            l_AssessingStudentsFinal3.Insert;
        end;
    end;

    //[Scope('OnPrem')]
    procedure InsertFinalCycle(pClass: Record Class; pStudentcode: Code[20]; pRulesEvaluations: Record "Rules of Evaluations")
    var
        l_AssessingStudents: Record "Assessing Students";
        l_AssessingStudentsFinal: Record "Assessing Students Final";
        l_AssessingStudentsFinal2: Record "Assessing Students Final";
        l_AssessingStudentsFinal3: Record "Assessing Students Final";
    begin

        l_AssessingStudentsFinal.LockTable(true);

        l_AssessingStudents.Reset;
        l_AssessingStudents.SetRange(Class, pClass.Class);
        l_AssessingStudents.SetRange("School Year", pClass."School Year");
        l_AssessingStudents.SetRange("Schooling Year", pClass."Schooling Year");
        l_AssessingStudents.SetRange("Sub-Subject Code", '');
        l_AssessingStudents.SetRange("Student Code No.", pStudentcode);
        l_AssessingStudents.SetRange("Evaluation Moment", l_AssessingStudents."Evaluation Moment"::"Final Year");
        l_AssessingStudents.SetRange("Study Plan Code", pClass."Study Plan Code");
        l_AssessingStudents.SetRange("Type Education", pClass.Type);
        if l_AssessingStudents.FindSet then begin
            repeat
                l_AssessingStudentsFinal.Init;
                l_AssessingStudentsFinal."Evaluation Type" := l_AssessingStudentsFinal."Evaluation Type"::"Final Cycle";
                l_AssessingStudentsFinal.Class := l_AssessingStudents.Class;
                l_AssessingStudentsFinal."School Year" := l_AssessingStudents."School Year";
                l_AssessingStudentsFinal."Schooling Year" := l_AssessingStudents."Schooling Year";
                l_AssessingStudentsFinal.Subject := l_AssessingStudents.Subject;
                l_AssessingStudentsFinal."Study Plan Code" := l_AssessingStudents."Study Plan Code";
                l_AssessingStudentsFinal."Student Code No." := l_AssessingStudents."Student Code No.";
                l_AssessingStudentsFinal."Class No." := l_AssessingStudents."Class No.";
                l_AssessingStudentsFinal.Grade := Round(l_AssessingStudents.Grade, pRulesEvaluations."Round Method");
                l_AssessingStudentsFinal."Qualitative Grade" :=
                                          ValidateAssessmentMixed(l_AssessingStudentsFinal.Grade, pRulesEvaluations."Assessment Code");
                l_AssessingStudentsFinal."Type Education" := l_AssessingStudents."Type Education";
                l_AssessingStudentsFinal."Country/Region Code" := l_AssessingStudents."Country/Region Code";
                l_AssessingStudentsFinal."Rule Entry No." := pRulesEvaluations."Entry No.";
                l_AssessingStudentsFinal.Insert;
            until l_AssessingStudents.Next = 0;
        end;



        l_AssessingStudentsFinal2.Reset;
        l_AssessingStudentsFinal2.SetRange("Evaluation Type", l_AssessingStudentsFinal2."Evaluation Type"::"Final Year");
        l_AssessingStudentsFinal2.SetRange("Student Code No.", pStudentcode);
        l_AssessingStudentsFinal2.SetRange(Class, pClass.Class);
        l_AssessingStudentsFinal2.SetRange("School Year", pClass."School Year");
        l_AssessingStudentsFinal2.SetRange("Schooling Year", pClass."Schooling Year");
        if l_AssessingStudentsFinal2.FindSet then begin
            l_AssessingStudentsFinal3.Init;
            l_AssessingStudentsFinal3.TransferFields(l_AssessingStudentsFinal2);
            l_AssessingStudentsFinal3."Moment Code" := '';
            l_AssessingStudentsFinal3."Evaluation Type" := l_AssessingStudentsFinal3."Evaluation Type"::"Final Cycle";
            l_AssessingStudentsFinal3."Rule Entry No." := pRulesEvaluations."Entry No.";
            l_AssessingStudentsFinal3.Insert;
        end;
    end;
}

