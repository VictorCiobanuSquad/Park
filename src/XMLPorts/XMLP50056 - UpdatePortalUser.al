xmlport 50056 UpdatePortalUser
{
    Format = Xml;
    UseDefaultNamespace = true;
    Direction = Import;
    Encoding = UTF8;
    schema
    {
        tableelement(User; "Portal User")
        {
            UseTemporary = true;
            AutoUpdate = true;
            MaxOccurs = Once;
            MinOccurs = Once;
            XmlName = 'UpdatePortalUser';

            fieldelement(UserType; User.UserType)
            {
                MinOccurs = Once;
                MaxOccurs = Once;
            }
            fieldelement(UserId; User.UserID)
            {
                MinOccurs = Once;
                MaxOccurs = Once;
            }
            fieldelement(RecoverGUID; User.RecoverGUID)
            {
                MinOccurs = Zero;
                MaxOccurs = Once;
            }
            fieldelement(RecoverDate; User.RecoverDate)
            {
                MinOccurs = Zero;
                MaxOccurs = Once;
            }
            fieldelement(Status; User.Status)
            {
                MinOccurs = Zero;
                MaxOccurs = Once;
            }
            fieldelement(LastPassDate; User.LastPassDate)
            {
                MinOccurs = Zero;
                MaxOccurs = Once;
            }
            fieldelement(Pass; User.Pass)
            {
                MinOccurs = Zero;
                MaxOccurs = Once;
            }
            fieldelement(Name; User.Name)
            {
                MinOccurs = Zero;
                MaxOccurs = Once;
            }
            fieldelement(Email; User.Email)
            {
                MinOccurs = Zero;
                MaxOccurs = Once;
            }
            trigger OnBeforeInsertRecord()
            begin
                RecPortalUser.Get(User.UserId, User.UserType);
                // RecPortalUser.Validate(UserType, User.UserType);
                // RecPortalUser.Validate(UserID, User.UserID);
                User.Salt := RecPortalUser.Salt;
                RecPortalUser.Validate(RecoverGUID, User.RecoverGUID);
                RecPortalUser.Validate(RecoverDate, User.RecoverDate);
                RecPortalUser.Validate(LastPassDate, User.LastPassDate);
                RecPortalUser.Validate(pass, User.Pass);
                RecPortalUser.Validate(Name, User.Name);
                RecPortalUser.Validate(Email, User.Email);
                RecPortalUser.Validate(Status, user.Status);
                RecPortalUser.Modify();
            end;
        }
    }
    var
        RecPortalUser: Record "Portal User";

}