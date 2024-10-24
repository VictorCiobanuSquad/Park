codeunit 52753 "User Education"
{

    trigger OnRun()
    begin
    end;

    var
        rUserSetup: Record "User Setup";
        EducationUserRespCenter: Code[10];
        HasGotSalesUserSetup: Boolean;
        UserRespCenter: Code[10];


    procedure GetEducationFilter(UserCode: Code[20]): Code[10]
    begin

        if not HasGotSalesUserSetup then begin
            if rUserSetup.Get(UserCode) then
                if rUserSetup."Education Resp. Ctr. Filter" <> '' then
                    EducationUserRespCenter := rUserSetup."Education Resp. Ctr. Filter";
            HasGotSalesUserSetup := true;
        end;
        exit(EducationUserRespCenter);
    end;


    procedure CheckRespCenterEducation(AccRespCenter: Code[10]): Boolean
    begin
        exit(CheckRespCenterEducation2(AccRespCenter, UserId));
    end;


    procedure CheckRespCenterEducation2(AccRespCenter: Code[20]; UserCode: Code[20]): Boolean
    begin
        UserRespCenter := GetEducationFilter(UserCode);

        if (UserRespCenter <> '') and
           (AccRespCenter <> UserRespCenter)
        then
            exit(false)
        else
            exit(true);
    end;
}

