report 50054 eSchooling
{
    /*
    IT001 - Parque - 2018.02.22 - Novos campos Endereço Mae, NIF Mae, Endereço Pai, NIF Pai
                                - modificação da importação do NIB
                                - Separação da morada em adress e adress 2
    */
    UsageCategory = Tasks;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(eSchooling; eSchooling)
        {
            trigger OnAfterGetRecord()
            begin

                CLEAR(NumAluno);
                NumAluno := PADSTR(NumAluno, 5 - STRLEN(eSchooling."No."), '0') + eSchooling."No.";
                //MESSAGE('%1', NumAluno);

                rStudents.RESET;
                IF rStudents.GET(NumAluno) THEN BEGIN
                    //IT 2016.12.22 - A pedido do Parque não é para atualizar alunos que já existem, só criar novos ( o codigo foi comentado)
                    /*
                    //Atualiza
                    //----------------
                    IF eSchooling.Name <> '' THEN rStudents.VALIDATE(rStudents.Name, eSchooling.Name);
                    IF eSchooling."VAT Registration No." <> '' THEN 
                       rStudents.VALIDATE(rStudents."VAT Registration No.",eSchooling."VAT Registration No.");
                    IF eSchooling."Birth Date" <> 0D THEN rStudents.VALIDATE(rStudents."Birth Date", eSchooling."Birth Date");
                    IF eSchooling.Sex <> 0 THEN rStudents.VALIDATE(rStudents.Sex, eSchooling.Sex);
                    IF eSchooling.Address <> '' THEN rStudents.VALIDATE(rStudents.Address, eSchooling.Address);
                    IF (eSchooling."Post Code" <> '') AND (eSchooling."Post Code" <> '-') THEN rStudents."Post Code" :=  eSchooling."Post Code";
                    IF eSchooling.Location <> '' THEN rStudents.Location := eSchooling.Location;
                    IF (eSchooling.NIB <> '') AND (eSchooling.NIB <> '0') THEN rStudents.VALIDATE(rStudents.NIB, eSchooling.NIB);
                    IF eSchooling."E-mail" <> '' THEN rStudents.VALIDATE(rStudents."E-mail", eSchooling."E-mail");
                    rStudents.MODIFY(TRUE);

                    /////////////MAE///////////
                    //------------------------
                    encontrou := FALSE;
                    IF eSchooling.NomeMae <> '' THEN BEGIN

                      //Testar se o associado já existe pelo nº contribuinte
                      IF (eSchooling.ParentescoEncEdu = 2) AND (NContribuinteEncEdu<>'') THEN BEGIN //Mãe
                        rUsersFamily.RESET;
                        rUsersFamily.SETRANGE(rUsersFamily."VAT Registration No.",eSchooling.NContribuinteEncEdu);
                        IF rUsersFamily.FINDFIRST THEN
                          encontrou := TRUE;
                      END;

                      //Testar se o associado já existe pelo nome
                      IF encontrou = FALSE THEN BEGIN
                        rUsersFamily.RESET;
                        rUsersFamily.SETRANGE(rUsersFamily.Name,eSchooling.NomeMae);
                        IF rUsersFamily.FINDFIRST THEN
                          encontrou := TRUE;
                      END;

                      //Atualizar o associado Mãe
                      IF encontrou = TRUE THEN BEGIN
                        IF eSchooling.NomeMae <> '' THEN rUsersFamily.VALIDATE(rUsersFamily.Name,eSchooling.NomeMae);
                        IF eSchooling.TelefoneEmpMae <>'' THEN rUsersFamily."Phone No. 2" := eSchooling.TelefoneEmpMae;
                        IF eSchooling.TelemovelMae <>'' THEN rUsersFamily."Mobile Phone" := eSchooling.TelemovelMae;
                        IF eSchooling."E-mailMae" <>'' THEN rUsersFamily."E-mail" := eSchooling."E-mailMae";
                        IF eSchooling.ParentescoEncEdu = 2 THEN
                          IF eSchooling.NContribuinteEncEdu <> '' THEN rUsersFamily."VAT Registration No." := eSchooling.NContribuinteEncEdu;
                        rUsersFamily.MODIFY;

                        //Atualizar a mae nos Associados
                        rUsersFamilyStudents.RESET;
                        rUsersFamilyStudents.SETRANGE("School Year",cStudentsRegistration.GetShoolYearActive);
                        rUsersFamilyStudents.SETRANGE("Student Code No.",rStudents."No.");
                        rUsersFamilyStudents.SETRANGE(Kinship, rUsersFamilyStudents.Kinship::Mother);
                        IF rUsersFamilyStudents.FINDFIRST THEN BEGIN
                          rUsersFamilyStudents.RENAME(rUsersFamilyStudents."School Year",
                                                      rUsersFamilyStudents."Student Code No.",
                                                      rUsersFamilyStudents.Kinship::Mother,
                                                      rUsersFamily."No.");
                        END;
                      END;
                    END;

                    //////////////PAI///////////////////
                    encontrou := FALSE;
                    IF eSchooling.NomePai <> '' THEN BEGIN

                      //Testar se o associado já existe pelo nº contribuinte
                      IF (eSchooling.ParentescoEncEdu = 1) AND (NContribuinteEncEdu<>'') THEN BEGIN
                        rUsersFamily.RESET;
                        rUsersFamily.SETRANGE(rUsersFamily."VAT Registration No.",eSchooling.NContribuinteEncEdu);
                        IF rUsersFamily.FINDFIRST THEN
                          encontrou := TRUE;
                      END;

                      //Testar se o associado já existe pelo nome
                      IF encontrou = FALSE THEN BEGIN
                        rUsersFamily.RESET;
                        rUsersFamily.SETRANGE(rUsersFamily.Name,eSchooling.NomePai);
                        IF rUsersFamily.FINDFIRST THEN
                          encontrou := TRUE;
                      END;

                      //Atualizar o associado Pai
                      IF encontrou = TRUE THEN BEGIN
                        IF eSchooling.NomePai <> '' THEN rUsersFamily.VALIDATE(rUsersFamily.Name,NomePai);
                        IF eSchooling.TelefoneEmpPai <>'' THEN rUsersFamily."Phone No. 2" := TelefoneEmpPai;
                        IF eSchooling.TelemovelPai <>'' THEN rUsersFamily."Mobile Phone" := TelemovelPai;
                        IF eSchooling."E-mailPai" <>'' THEN rUsersFamily."E-mail" := "E-mailPai";
                        IF eSchooling.ParentescoEncEdu = 1 THEN
                          IF eSchooling.NContribuinteEncEdu <>'' THEN rUsersFamily."VAT Registration No." := eSchooling.NContribuinteEncEdu;
                        rUsersFamily.MODIFY;

                        //Atualizar o pai nos Associados
                        rUsersFamilyStudents.RESET;
                        rUsersFamilyStudents.SETRANGE("School Year",cStudentsRegistration.GetShoolYearActive);
                        rUsersFamilyStudents.SETRANGE("Student Code No.",rStudents."No.");
                        rUsersFamilyStudents.SETRANGE(Kinship, rUsersFamilyStudents.Kinship::Father);
                        IF rUsersFamilyStudents.FINDFIRST THEN BEGIN
                          rUsersFamilyStudents.RENAME(rUsersFamilyStudents."School Year",
                                                      rUsersFamilyStudents."Student Code No.",
                                                      rUsersFamilyStudents.Kinship::Father,
                                                      rUsersFamily."No.");
                        END;
                      END;
                    END;
                    */

                END ELSE BEGIN
                    //Insere
                    //----------------

                    rStudents.INIT;
                    rStudents."No." := NumAluno;
                    IF eSchooling.Name <> '' THEN rStudents.VALIDATE(rStudents.Name, eSchooling.Name);
                    IF eSchooling."VAT Registration No." <> '' THEN
                        rStudents.VALIDATE(rStudents."VAT Registration No.", eSchooling."VAT Registration No.");
                    IF eSchooling."Birth Date" <> 0D THEN rStudents.VALIDATE(rStudents."Birth Date", eSchooling."Birth Date");
                    IF eSchooling.Sex <> 0 THEN rStudents.VALIDATE(rStudents.Sex, eSchooling.Sex);

                    //IT001 - Parque - 2018.02.22,sn
                    IF eSchooling.Address <> '' THEN BEGIN
                        IF STRLEN(eSchooling.Address) <= 50 THEN
                            rStudents.VALIDATE(rStudents.Address, eSchooling.Address)
                        ELSE BEGIN
                            CLEAR(moradaaux);
                            CLEAR(Aux);
                            CLEAR(moradaComp);
                            moradaaux := eSchooling.Address;
                            Flag := FALSE;

                            WHILE (STRPOS(moradaaux, ' ') <> 0) AND (Flag = FALSE) DO BEGIN
                                Aux := COPYSTR(moradaaux, 1, STRPOS(moradaaux, ' ') - 1);
                                IF moradaComp = '' THEN
                                    moradaComp := Aux
                                ELSE BEGIN
                                    IF STRLEN(moradaComp + ' ' + Aux) > 50 THEN
                                        Flag := TRUE
                                    ELSE
                                        moradaComp := moradaComp + ' ' + Aux;
                                END;
                                moradaaux := COPYSTR(moradaaux, STRPOS(moradaaux, ' ') + 1);
                            END;
                            rStudents.VALIDATE(rStudents.Address, moradaComp);
                            rStudents.VALIDATE(rStudents."Address 2", Aux + ' ' + moradaaux);
                        END;
                    END;
                    //IT001 - Parque - 2018.02.22,en


                    //IF eSchooling.Address <> '' THEN rStudents.VALIDATE(rStudents.Address, eSchooling.Address);
                    IF (eSchooling."Post Code" <> '') AND (eSchooling."Post Code" <> '-') THEN rStudents."Post Code" := eSchooling."Post Code";
                    IF eSchooling.Location <> '' THEN rStudents.Location := eSchooling.Location;
                    //IT001 - Parque - 2018.02.22,sn
                    IF eSchooling."NIB-IBAN" <> '' THEN BEGIN
                        IF COPYSTR(eSchooling."NIB-IBAN", 1, 2) = 'PT' THEN BEGIN
                            rStudents.VALIDATE(rStudents.IBAN, eSchooling."NIB-IBAN");
                            rStudents.VALIDATE(rStudents.NIB, COPYSTR(eSchooling."NIB-IBAN", 5));
                        END ELSE BEGIN
                            rStudents.VALIDATE(rStudents.IBAN, 'PT50' + eSchooling."NIB-IBAN");
                            rStudents.VALIDATE(rStudents.NIB, eSchooling."NIB-IBAN");
                        END;
                    END;
                    //IT001 - Parque - 2018.02.22,en
                    IF eSchooling."E-mail" <> '' THEN rStudents.VALIDATE(rStudents."E-mail", eSchooling."E-mail");

                    IF rEduConf.GET THEN;
                    rStudents."Payment Method Code" := rEduConf."Payment Method Code";
                    rStudents."Currency Code" := rEduConf."Currency Code";
                    rStudents."Payment Terms Code" := rEduConf."Payment Terms Code";
                    rStudents."Customer Disc. Group" := rEduConf."Customer Disc. Group";
                    rStudents."Allow Line Disc." := rEduConf."Allow Line Disc.";
                    rStudents."Customer Posting Group" := rEduConf."Customer Posting Group";
                    rStudents."Gen. Bus. Posting Group" := rEduConf."Gen. Bus. Posting Group";
                    rStudents."VAT Bus. Posting Group" := rEduConf."VAT Bus. Posting Group";
                    rStudents."Use Student Disc. Group" := rEduConf."Use Student Disc. Group";
                    rStudents.VALIDATE(rStudents."Nationality Code", cStudentsRegistration.GetCountry);
                    rStudents.VALIDATE(rStudents."Naturalness Code", cStudentsRegistration.GetCountry);
                    rStudents."Country/Region Code" := cStudentsRegistration.GetCountry;
                    rStudents."User Id" := USERID;
                    rStudents.Date := WORKDATE;
                    rStudents.InsertUsersStudent;

                    rStudents.INSERT;



                    //----------------------------------------------------------------------------------------
                    //Criar os associados
                    //----------------------------------------------------------------------------------------


                    //////////////MAE///////////////////
                    encontrou := FALSE;
                    IF NomeMae <> '' THEN BEGIN

                        //Testar se o associado já existe pelo nº contribuinte
                        //IF (ParentescoEncEdu = 2) AND (NContribuinteEncEdu<>'') THEN BEGIN
                        //  rUsersFamily.RESET;
                        //  rUsersFamily.SETRANGE(rUsersFamily."VAT Registration No.",NContribuinteEncEdu);
                        //  IF rUsersFamily.FINDFIRST THEN
                        //    encontrou := TRUE;
                        //END;

                        //IT001 - Parque - 2018.02.22,en
                        //Testar se o associado já existe pelo nº contribuinte
                        IF NIFMae <> '' THEN BEGIN
                            rUsersFamily.RESET;
                            rUsersFamily.SETRANGE(rUsersFamily."VAT Registration No.", NIFMae);
                            IF rUsersFamily.FINDFIRST THEN
                                encontrou := TRUE;
                        END;
                        //IT001 - Parque - 2018.02.22,sn


                        //Testar se o associado já existe pelo nome
                        IF encontrou = FALSE THEN BEGIN
                            rUsersFamily.RESET;
                            rUsersFamily.SETRANGE(rUsersFamily.Name, NomeMae);
                            IF rUsersFamily.FINDFIRST THEN
                                encontrou := TRUE;
                        END;

                        //Criar o associado Mãe
                        IF encontrou = FALSE THEN BEGIN
                            rUsersFamily.INIT;
                            //rUsersFamily."No." := cNoSeriesMgt.GetNextNo(rEduConf."Users Family Nos.", 0D, TRUE);
                            rUsersFamily."No." := CU_NoSeries.GetNextNo(rEduConf."Users Family Nos.", 0D, TRUE);
                            rUsersFamily.VALIDATE(rUsersFamily.Name, NomeMae);
                            rUsersFamily."Phone No. 2" := TelefoneEmpMae;
                            rUsersFamily."Mobile Phone" := TelemovelMae;
                            rUsersFamily."E-mail" := "E-mailMae";


                            //IT001 - Parque - 2018.02.22,sn
                            IF eSchooling.EnderecoMae <> '' THEN BEGIN
                                IF STRLEN(eSchooling.EnderecoMae) <= 50 THEN
                                    rUsersFamily.VALIDATE(rUsersFamily.Address, eSchooling.EnderecoMae)
                                ELSE BEGIN

                                    CLEAR(moradaaux);
                                    CLEAR(Aux);
                                    CLEAR(moradaComp);
                                    moradaaux := eSchooling.EnderecoMae;
                                    Flag := FALSE;

                                    WHILE (STRPOS(moradaaux, ' ') <> 0) AND (Flag = FALSE) DO BEGIN
                                        Aux := COPYSTR(moradaaux, 1, STRPOS(moradaaux, ' ') - 1);
                                        IF moradaComp = '' THEN
                                            moradaComp := Aux
                                        ELSE BEGIN
                                            IF STRLEN(moradaComp + ' ' + Aux) > 50 THEN
                                                Flag := TRUE
                                            ELSE
                                                moradaComp := moradaComp + ' ' + Aux;
                                        END;
                                        moradaaux := COPYSTR(moradaaux, STRPOS(moradaaux, ' ') + 1);
                                    END;
                                    rUsersFamily.Address := moradaComp;
                                    rUsersFamily."Address 2" := Aux + ' ' + moradaaux;
                                END;
                            END;
                            IF (eSchooling.CodPostalMae <> '') AND (eSchooling.CodPostalMae <> '-') THEN
                                rUsersFamily."Post Code" := eSchooling.CodPostalMae;
                            IF eSchooling.LocalidadeMae <> '' THEN rUsersFamily.Location := eSchooling.LocalidadeMae;
                            rUsersFamily."VAT Registration No." := NIFMae;
                            //IT001 - Parque - 2018.02.22,en

                            IF ParentescoEncEdu = 2 THEN
                                rUsersFamily."VAT Registration No." := NContribuinteEncEdu;
                            rUsersFamily."Payment Method Code" := rEduConf."Payment Method Code";
                            rUsersFamily."Currency Code" := rEduConf."Currency Code";
                            rUsersFamily."Payment Terms Code" := rEduConf."Payment Terms Code";
                            rUsersFamily."Customer Disc. Group" := rEduConf."Customer Disc. Group";
                            rUsersFamily."Allow Line Disc." := rEduConf."Allow Line Disc.";
                            rUsersFamily."Customer Posting Group" := rEduConf."Customer Posting Group";
                            rUsersFamily."Gen. Bus. Posting Group" := rEduConf."Gen. Bus. Posting Group";
                            rUsersFamily."VAT Bus. Posting Group" := rEduConf."VAT Bus. Posting Group";
                            rUsersFamily.INSERT(TRUE);
                        END;


                        //Associar a mae ao aluno
                        rUsersFamilyStudents.INIT;
                        rUsersFamilyStudents."School Year" := cStudentsRegistration.GetShoolYearActive;
                        rUsersFamilyStudents."Student Code No." := rStudents."No.";
                        rUsersFamilyStudents.Kinship := rUsersFamilyStudents.Kinship::Mother;
                        rUsersFamilyStudents.VALIDATE(rUsersFamilyStudents."No.", rUsersFamily."No.");
                        IF ParentescoEncEdu = 2 THEN
                            rUsersFamilyStudents."Education Head" := TRUE;
                        rUsersFamilyStudents.INSERT(TRUE);
                    END;

                    //////////////PAI///////////////////
                    encontrou := FALSE;
                    IF NomePai <> '' THEN BEGIN

                        //Testar se o associado já existe pelo nº contribuinte
                        IF (ParentescoEncEdu = 1) AND (NContribuinteEncEdu <> '') THEN BEGIN
                            rUsersFamily.RESET;
                            rUsersFamily.SETRANGE(rUsersFamily."VAT Registration No.", NContribuinteEncEdu);
                            IF rUsersFamily.FINDFIRST THEN
                                encontrou := TRUE;
                        END;

                        //Testar se o associado já existe pelo nome
                        //IF encontrou = FALSE THEN BEGIN
                        //  rUsersFamily.RESET;
                        //  rUsersFamily.SETRANGE(rUsersFamily.Name,NomePai);
                        //  IF rUsersFamily.FINDFIRST THEN
                        //    encontrou := TRUE;
                        //END;

                        //IT001 - Parque - 2018.02.22,en
                        //Testar se o associado já existe pelo nº contribuinte
                        IF NIFPai <> '' THEN BEGIN
                            rUsersFamily.RESET;
                            rUsersFamily.SETRANGE(rUsersFamily."VAT Registration No.", NIFPai);
                            IF rUsersFamily.FINDFIRST THEN
                                encontrou := TRUE;
                        END;
                        //IT001 - Parque - 2018.02.22,sn


                        //Criar o associado Pai
                        IF encontrou = FALSE THEN BEGIN
                            rUsersFamily.INIT;
                            //rUsersFamily."No." := cNoSeriesMgt.GetNextNo(rEduConf."Users Family Nos.", 0D, TRUE);
                            //TODO: to test
                            rUsersFamily."No." := CU_NoSeries.GetNextNo(rEduConf."Users Family Nos.", 0D, TRUE);
                            rUsersFamily.VALIDATE(rUsersFamily.Name, NomePai);
                            rUsersFamily."Phone No. 2" := TelefoneEmpPai;
                            rUsersFamily."Mobile Phone" := TelemovelPai;
                            rUsersFamily."E-mail" := "E-mailPai";

                            //IT001 - Parque - 2018.02.22,sn
                            IF eSchooling.EnderecoPai <> '' THEN BEGIN
                                IF STRLEN(eSchooling.EnderecoPai) <= 50 THEN
                                    rUsersFamily.VALIDATE(rUsersFamily.Address, eSchooling.EnderecoPai)
                                ELSE BEGIN

                                    CLEAR(moradaaux);
                                    CLEAR(Aux);
                                    CLEAR(moradaComp);
                                    moradaaux := eSchooling.EnderecoPai;
                                    Flag := FALSE;

                                    WHILE (STRPOS(moradaaux, ' ') <> 0) AND (Flag = FALSE) DO BEGIN
                                        Aux := COPYSTR(moradaaux, 1, STRPOS(moradaaux, ' ') - 1);
                                        IF moradaComp = '' THEN
                                            moradaComp := Aux
                                        ELSE BEGIN
                                            IF STRLEN(moradaComp + ' ' + Aux) > 50 THEN
                                                Flag := TRUE
                                            ELSE
                                                moradaComp := moradaComp + ' ' + Aux;
                                        END;
                                        moradaaux := COPYSTR(moradaaux, STRPOS(moradaaux, ' ') + 1);
                                    END;
                                    rUsersFamily.Address := moradaComp;
                                    rUsersFamily."Address 2" := Aux + ' ' + moradaaux;
                                END;
                            END;
                            IF (eSchooling.CodPostalPai <> '') AND (eSchooling.CodPostalPai <> '-') THEN
                                rUsersFamily."Post Code" := eSchooling.CodPostalPai;
                            IF eSchooling.LocalidadePai <> '' THEN rUsersFamily.Location := eSchooling.LocalidadePai;
                            rUsersFamily."VAT Registration No." := NIFPai;

                            //IT001 - Parque - 2018.02.22,en

                            IF ParentescoEncEdu = 1 THEN
                                rUsersFamily."VAT Registration No." := NContribuinteEncEdu;
                            rUsersFamily."Payment Method Code" := rEduConf."Payment Method Code";
                            rUsersFamily."Currency Code" := rEduConf."Currency Code";
                            rUsersFamily."Payment Terms Code" := rEduConf."Payment Terms Code";
                            rUsersFamily."Customer Disc. Group" := rEduConf."Customer Disc. Group";
                            rUsersFamily."Allow Line Disc." := rEduConf."Allow Line Disc.";
                            rUsersFamily."Customer Posting Group" := rEduConf."Customer Posting Group";
                            rUsersFamily."Gen. Bus. Posting Group" := rEduConf."Gen. Bus. Posting Group";
                            rUsersFamily."VAT Bus. Posting Group" := rEduConf."VAT Bus. Posting Group";
                            rUsersFamily.INSERT(TRUE);
                        END;


                        //Associar o Pai ao aluno
                        rUsersFamilyStudents.INIT;
                        rUsersFamilyStudents."School Year" := cStudentsRegistration.GetShoolYearActive;
                        rUsersFamilyStudents."Student Code No." := rStudents."No.";
                        rUsersFamilyStudents.Kinship := rUsersFamilyStudents.Kinship::Father;
                        rUsersFamilyStudents.VALIDATE(rUsersFamilyStudents."No.", rUsersFamily."No.");
                        IF ParentescoEncEdu = 1 THEN
                            rUsersFamilyStudents."Education Head" := TRUE;
                        rUsersFamilyStudents.INSERT(TRUE);
                    END;


                END;
            end;
        }
    }

    var
        rStudents: Record Students;
        NumAluno: Code[10];
        encontrou: Boolean;
        rUsersFamily: Record "Users Family";
        rUsersFamilyStudents: Record "Users Family / Students";
        cStudentsRegistration: Codeunit "Students Registration";
        rEduConf: Record "Edu. Configuration";
        //cNoSeriesMgt: Codeunit NoSeriesManagement;
        CU_NoSeries: Codeunit "No. Series";
        Morada: Text[100];
        Aux: Text[65];
        moradaComp: Text[100];
        moradaaux: Text[100];
        Flag: Boolean;
}