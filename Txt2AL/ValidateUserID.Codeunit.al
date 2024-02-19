codeunit 31009762 "Validate User ID"
{

    trigger OnRun()
    begin
    end;

    //[Scope('OnPrem')]
    procedure ValidateUser(p_UserName: Text[30])
    var
        rStudents: Record Students;
        rTeacher: Record Teacher;
        rUsersFamily: Record "Users Family";
        Text001: Label 'The User ID %1 already exists in the database.';
    begin
        if p_UserName = '' then
            exit;
        rStudents.Reset;
        rStudents.SetRange("User Name", p_UserName);
        if rStudents.Find('-') then
            Error(Text001, p_UserName);


        rTeacher.Reset;
        rTeacher.SetRange("User Name", p_UserName);
        if rTeacher.Find('-') then
            Error(Text001, p_UserName);

        rUsersFamily.Reset;
        rUsersFamily.SetRange("User Name", p_UserName);
        if rUsersFamily.Find('-') then
            Error(Text001, p_UserName);


        /*rEmployee.RESET;
        rEmployee.SETRANGE("User Name",p_UserName);
        IF rEmployee.FIND('-') THEN
          ERROR(Text001,p_UserName);*/

    end;
}

