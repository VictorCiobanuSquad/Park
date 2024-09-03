report 52846 "Test Summoning"
{
    DefaultLayout = RDLC;
    RDLCLayout = './TestSummoning.rdlc';
    Caption = 'Test Summoning';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(Test; Test)
        {
            DataItemTableView = SORTING("Test Type", "Test No.", "Line Type", "Candidate no.", "Student No.") WHERE("Line Type" = CONST(Header), "Test Type" = CONST(Candidate));
            column(Test_Test_Type; "Test Type")
            {
            }
            column(Test_Test_No_; "Test No.")
            {
            }
            column(Test_Line_Type; "Line Type")
            {
            }
            column(Test_Candidate_no_; "Candidate no.")
            {
            }
            column(Test_Student_No_; "Student No.")
            {
            }
            dataitem(TestCandidate; Test)
            {
                DataItemLink = "Test No." = FIELD("Test No.");
                DataItemTableView = SORTING("Test Type", "Test No.", "Line Type", "Candidate no.", "Student No.") WHERE("Line Type" = CONST(Line), "Test Type" = CONST(Candidate));
                column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
                {
                }
                column(nomeEscola; nomeEscola)
                {
                }
                // column(CurrReport_PAGENO;CurrReport.PageNo)
                // {
                // }
                column(CompanyInfo_Picture; CompanyInfo.Picture)
                {
                }
                column(vTexto; vTexto)
                {
                }
                column(FORMAT_Test__Type_of_Test______________Test_Description; Format(Test."Type of Test") + ' - ' + Test.Description)
                {
                }
                column(TestCandidate__Candidate_Name_______; TestCandidate."Candidate Name" + ',')
                {
                }
                column(Test_Date; Test.Date)
                {
                }
                column(Test_Hour; Test.Hour)
                {
                }
                column(Test_Duration; Test.Duration)
                {
                }
                column(Test_Room; Test.Room)
                {
                }
                column(vTeacherName; vTeacherName)
                {
                }
                column(vRoom; vRoom)
                {
                }
                column(Text0002; Text0002)
                {
                }
                column(Text0003; Text0003)
                {
                }
                column(Test_SummoningCaption; Test_SummoningCaptionLbl)
                {
                }
                column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
                {
                }
                column(Test_DateCaption; Test.FieldCaption(Date))
                {
                }
                column(Test_HourCaption; Test.FieldCaption(Hour))
                {
                }
                column(Test_DurationCaption; Test.FieldCaption(Duration))
                {
                }
                column(Test_RoomCaption; Test.FieldCaption(Room))
                {
                }
                column(vTeacherNameCaption; vTeacherNameCaptionLbl)
                {
                }
                column(TestCandidate_Test_Type; "Test Type")
                {
                }
                column(TestCandidate_Test_No_; "Test No.")
                {
                }
                column(TestCandidate_Line_Type; "Line Type")
                {
                }
                column(TestCandidate_Candidate_no_; "Candidate no.")
                {
                }
                column(TestCandidate_Student_No_; "Student No.")
                {
                }

                trigger OnAfterGetRecord()
                begin

                    vTexto := StrSubstNo(Text0001, TestCandidate."School Year", nomeEscola);


                    if rTeacher.Get(Test."Teacher No.") then begin
                        if rEduConfiguration.Get then begin
                            if rEduConfiguration."Full Name syntax" = 0 then begin
                                if rTeacher."Last Name 2" <> '' then
                                    vTeacherName := rTeacher."Last Name" + ' ' + rTeacher."Last Name 2" + ', ' + rTeacher.Name
                                else
                                    vTeacherName := rTeacher."Last Name" + ', ' + rTeacher.Name;
                            end else begin
                                if rTeacher."Last Name 2" <> '' then
                                    vTeacherName := rTeacher.Name + ' ' + rTeacher."Last Name 2" + ' ' + rTeacher."Last Name"
                                else
                                    vTeacherName := rTeacher.Name + ' ' + rTeacher."Last Name";
                            end;
                        end;
                    end;

                    if rRoom.Get(Test.Room) then
                        vRoom := rRoom."Room Description";
                end;
            }

            trigger OnPreDataItem()
            begin
                if cUserEducation.GetEducationFilter(UserId) <> '' then begin
                    rRespCenter.Reset;
                    rRespCenter.Get(cUserEducation.GetEducationFilter(UserId));
                    nomeEscola := rRespCenter.Name + ' ' + rRespCenter."Name 2";
                end else begin
                    rSchool.Reset;
                    if rSchool.Find('-') then
                        nomeEscola := rSchool."School Name";
                end;


                if vSchoolYear <> '' then Test.SetRange(Test."School Year", vSchoolYear);

                if vTest <> '' then Test.SetRange(Test."Test No.", vTest);
            end;
        }
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
                    field(vSchoolYear; vSchoolYear)
                    {
                        ApplicationArea = All;
                        Caption = 'School Year';
                        TableRelation = "School Year";
                    }
                    field(vTest; vTest)
                    {
                        ApplicationArea = All;
                        Caption = 'Test No.';
                        TableRelation = Test."Test No.";
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

    trigger OnPreReport()
    begin
        if CompanyInfo.Get() then
            CompanyInfo.CalcFields(CompanyInfo.Picture);

        //Filtros := classs.GETFILTERS;
    end;

    var
        CompanyInfo: Record "Company Information";
        rRespCenter: Record "Responsibility Center";
        rSchool: Record School;
        rTeacher: Record Teacher;
        rRoom: Record Room;
        rEduConfiguration: Record "Edu. Configuration";
        cUserEducation: Codeunit "User Education";
        nomeEscola: Text[128];
        vTexto: Text[1024];
        vTeacherName: Text[191];
        vTest: Code[20];
        vSchoolYear: Code[9];
        Text0001: Label 'Following your candidature for the %1 School Year, we hereby invite you to be present at the %2 in order to perform:';
        vRoom: Text[30];
        Text0002: Label 'Yours sincerely,';
        Text0003: Label 'Hour';
        Test_SummoningCaptionLbl: Label 'Test Summoning';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        vTeacherNameCaptionLbl: Label 'Teacher';
}

