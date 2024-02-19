xmlport 50055 CreatePortalUser
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
            XmlName = 'CreatePortalUser';
            fieldelement(UserType; User.UserType)
            {
                MinOccurs = Once;
                MaxOccurs = Once;
            }
            fieldelement(Salt; User.Salt)
            {
                MinOccurs = Once;
                MaxOccurs = Once;
            }
            fieldelement(Name; User.Name)
            {
                MinOccurs = Once;
                MaxOccurs = Once;
            }
            fieldelement(Email; User.Email)
            {
                MinOccurs = Once;
                MaxOccurs = Once;
            }
            fieldelement(RecoverGuid; User.RecoverGUID)
            {
                MinOccurs = Once;
                MaxOccurs = Once;
            }
            trigger OnBeforeInsertRecord()
            begin
                RecPortalUser.Init();
                RecPortalUser.Validate(UserType, User.UserType);
                RecPortalUser.Validate(UserID, User.UserID);
                RecPortalUser.Validate(Salt, User.Salt);
                RecPortalUser.Validate(Name, user.Name);
                RecPortalUser.Validate(Email, User.Email);
                RecPortalUser.LastPassDate := system.CurrentDateTime;
                RecPortalUser.Status := RecPortalUser.Status::Activo;
                // if not RecPortalUser.Insert(true) then begin
                //     Error('Insert error');
                // end;
                RecPortalUser.Insert(true);
            end;
        }
    }
    var
        RecPortalUser: Record "Portal User";
}