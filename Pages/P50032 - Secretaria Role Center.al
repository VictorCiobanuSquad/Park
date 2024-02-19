page 50032 "Secretaria Role Center"
{
    Caption = 'Secretaria Role Center';
    ApplicationArea = All;
    UsageCategory = Administration;
    PageType = RoleCenter;
    actions
    {
        area(Sections)
        {
            group(Candidaturas)
            {
                Caption = 'Candidates';
                action("Candidate")
                {
                    ApplicationArea = All;
                    Caption = 'Candidate List';
                    RunObject = page "Candidate List";
                }
                action("Test")
                {
                    ApplicationArea = All;
                    Caption = 'Test List';
                    RunObject = page "Test List";
                }
                action("Candidate Selection List")
                {
                    ApplicationArea = All;
                    Caption = 'Candidate Selection List';
                    RunObject = page "Candidate Selection List";
                }
                action("Candidate Selection")
                {
                    ApplicationArea = All;
                    Caption = 'Candidate Selection';
                    RunObject = page "Candidate Selection";
                }
                action("Prioridade")
                {
                    ApplicationArea = All;
                    Caption = 'Priority';
                    RunObject = page Priority;
                }
                action("Candidates List Report")
                {
                    ApplicationArea = All;
                    Caption = 'Candidates List Report';
                    RunObject = report "Candidates List";
                }
                action("Test Summoning")
                {
                    ApplicationArea = All;
                    Caption = 'Test SUmmoning';
                    RunObject = report "Test Summoning";
                }
            }
            group(Secretaria)
            {
                Caption = 'Secretary';
                action("Students")
                {
                    ApplicationArea = All;
                    Caption = 'Students List';
                    RunObject = page "Students List";
                }
                action("Users Family")
                {
                    ApplicationArea = All;
                    Caption = 'Users Family List';
                    RunObject = page "Users Family List";
                }
                action("Teacher")
                {
                    ApplicationArea = All;
                    Caption = 'Teacher List';
                    RunObject = page "Teacher List";
                }
                action("Class List")
                {
                    ApplicationArea = All;
                    Caption = 'Class List';
                    RunObject = page "Class List";
                }
                action("Matriculas")
                {
                    ApplicationArea = All;
                    Caption = 'Registration Entry';
                    RunObject = page "Registration Entry";
                }
                action("Disciplinas Opcionais Alunos")
                {
                    ApplicationArea = All;
                    Caption = 'Students Optional Subjects';
                    RunObject = page "Students Optional Subjects";
                }
                action("Users Family/Student List")
                {
                    ApplicationArea = All;
                    Caption = 'Users Family/Student List';
                    RunObject = page "Users Family / Students";
                }
                action("Movs. ALunos")
                {
                    ApplicationArea = All;
                    Caption = 'Student Entry';
                    RunObject = page "Students Entry";
                }
                group(Alunos)
                {
                    Caption = 'Students';
                    action("Lista Alunos Turma")
                    {
                        ApplicationArea = All;
                        Caption = 'Students Calss List';
                        RunObject = report "Students - List Class";
                    }
                    action("Aniversários dos Alunos")
                    {
                        ApplicationArea = All;
                        Caption = 'Students Birthdays';
                        RunObject = report "Students Birthdays";
                    }
                    action("Irmãos dos Alunos")
                    {
                        ApplicationArea = All;
                        Caption = 'Student Brothers';
                        RunObject = report "Students brothers";
                    }
                    action("Alunos por Disciplina")
                    {
                        ApplicationArea = All;
                        Caption = 'Students Subject';
                        RunObject = report "Students Subject";
                    }
                    action("Aunos Serviços Fixos")
                    {
                        ApplicationArea = All;
                        Caption = 'Students Fixed Services';
                        RunObject = report "Students Fixed Services";
                    }
                    action("Alunos por Curso/Plano Estudos")
                    {
                        ApplicationArea = All;
                        Caption = 'Students Courses/Study Plans';
                        RunObject = report "Students Course/Study Plans";
                    }
                    action("Ficha Saúde")
                    {
                        ApplicationArea = All;
                        Caption = 'Health Card';
                        RunObject = report "Health Card";
                    }
                    action("Cartão Aluno")
                    {
                        ApplicationArea = All;
                        Caption = 'Student Transport Card';
                        RunObject = report "Student Transport Card";
                    }
                    action("Ficha de Aluno")
                    {
                        ApplicationArea = All;
                        Caption = 'Student Card';
                        RunObject = report "Student Card";
                    }
                    action("Matricula Aluno")
                    {
                        ApplicationArea = All;

                        // RunObject=report missing
                    }
                    action("Declaração IRS")
                    {
                        ApplicationArea = All;
                        //RunObject = report 50048 Declaração de IRS missing
                    }
                }
                group(Turma)
                {
                    Caption = 'Class';
                    action("Folha de Ponto")
                    {
                        ApplicationArea = All;
                        Caption = 'Attendance Registration';
                        RunObject = report "Attendance Registration";
                    }
                    action("Lista Turmas")
                    {
                        ApplicationArea = All;
                        Caption = 'Class List';
                        RunObject = report "Class List";
                    }
                    action("Lista de Professores/Turma - Disciplina")
                    {
                        ApplicationArea = All;
                        Caption = 'Teacher Class List';
                        RunObject = report "Teacher Class List";
                    }
                    action("Turmas Curso/Plano Estudos")
                    {
                        ApplicationArea = All;
                        Caption = 'Class Course/Study Plan';
                        RunObject = report "Class Course/Study Plan";
                    }
                    action("Alunos - Contactos")
                    {
                        ApplicationArea = All;
                        Caption = 'Student - Contacts';
                        RunObject = report "Alunos - Contactos";
                    }
                    action("Movimentos Escolares")
                    {
                        ApplicationArea = All;
                        Caption = '"Movimentos Escolares"';
                        RunObject = report "School Movements";
                    }
                }
                group(Geral)
                {
                    Caption = 'General';
                    action("Escola")
                    {
                        ApplicationArea = All;
                        Caption = 'School';
                        RunObject = page School;
                    }
                    action("Lista Escolas")
                    {
                        ApplicationArea = All;
                        Caption = '';
                        RunObject = page School;
                        //missing not school list
                    }
                    action("Conf. Educação")
                    {
                        ApplicationArea = All;
                        Caption = 'Edu. Configuration';
                        RunObject = page "Edu. Configuration";
                    }
                    action("Ano Letivo")
                    {
                        ApplicationArea = All;
                        Caption = 'School Year';
                        RunObject = page "School Year";
                    }
                }
                group(Disciplinas)
                {
                    Caption = 'Subjects';
                    action("Config. Departamento")
                    {
                        ApplicationArea = All;
                        Caption = 'Department Config.';
                        RunObject = page "Department Config.";
                    }
                    action("Lista Disciplinas Grupo")
                    {
                        ApplicationArea = All;
                        Caption = 'Groups Subjects List';
                        RunObject = page "Groups Subjects List";
                    }

                    action("Disciplinas Opcionais Alunos 2")
                    {
                        ApplicationArea = All;
                        Caption = 'Students Optional Subjects';
                        RunObject = page "Students Optional Subjects";
                    }

                    action("Lista de Turnos")
                    {
                        ApplicationArea = All;
                        Caption = 'Turn List';
                        RunObject = page "Turn List";
                    }
                }
                group("Actividades Não Lectivas")
                {
                    Caption = 'Non Scholar Activities';
                    action("Componente não Lectiva")
                    {
                        ApplicationArea = All;
                        Caption = 'Non lective component List';
                        RunObject = page "Non lective component List";
                    }
                    action("Horas não lectivas")
                    {
                        ApplicationArea = All;
                        Caption = 'Students Non Lective Hours';
                        RunObject = page "Students Non Lective Hours";
                    }
                }
                group(Avaliações)
                {
                    Caption = 'Assessment';
                    action("Configuração Momentos")
                    {
                        ApplicationArea = All;
                        Caption = 'Setting Moments';
                        RunObject = page "Setting Moments";
                    }
                    action("Lista Configuração Classificações")
                    {
                        ApplicationArea = All;
                        Caption = 'Setting Evaluations List';
                        RunObject = page "Setting Evaluations List";
                    }
                    action("Aspetos Gerais")
                    {
                        ApplicationArea = All;
                        Caption = 'Adpects';
                        RunObject = page Aspects;
                    }
                    action("Configuração Avaliações")
                    {
                        ApplicationArea = All;
                        Caption = 'Assessment Configuration';
                        RunObject = page "Assessment Configuration";
                    }
                    action("Classificações de Sub-Disciplinas")
                    {
                        ApplicationArea = All;
                        Caption = 'Sub Subjects Setting Ratings';
                        RunObject = page "Sub Subjects Setting Ratings";
                    }
                    action("Observações")
                    {
                        ApplicationArea = All;
                        Caption = 'Observation';
                        RunObject = page "Student Inc. Observation List";
                    }
                    action("Averbamento")
                    {
                        ApplicationArea = All;
                        Caption = 'Averbamento';
                        //RunObject=page missing
                    }
                    action("Permissões")
                    {
                        ApplicationArea = All;
                        Caption = 'Permissions';
                        RunObject = page Permissions;
                    }
                }
                group(Incidências)
                {
                    Caption = 'Incidence';
                    action(Categoria)
                    {
                        ApplicationArea = All;
                        Caption = 'Category';
                        RunObject = page Category;
                    }
                    action("Configuração de Incidências")
                    {
                        ApplicationArea = All;
                        Caption = 'Incidences';
                        RunObject = page Incidences;
                    }
                    action("Observações 2")
                    {
                        ApplicationArea = All;
                        Caption = 'Observations 2';
                        RunObject = page "Student Inc. Observation List";
                    }
                    action("Permissões 2")
                    {
                        ApplicationArea = All;
                        Caption = 'Permissions';
                        RunObject = page Permissions;
                    }
                }
                group("Saúde e Segurança")
                {
                    Caption = 'Health & Safety';
                    action("Saúde e Segurança 1")

                    {
                        ApplicationArea = All;
                        Caption = 'Health & Safety';
                        RunObject = page "Health & Safety";
                    }
                }
                group(Utilizadores)
                {
                    Caption = 'Users';
                    action("Config. Utilizador")
                    {
                        ApplicationArea = All;
                        Caption = 'User Configuration';
                        RunObject = page "User Setup";
                    }
                }
                group(Templates)
                {
                    Caption = 'Templates';
                    action("Templates de Mapas")
                    {
                        ApplicationArea = All;
                        Caption = 'Templates';
                        RunObject = page Templates;
                    }
                }
                group("Planos de Estudos")
                {
                    Caption = 'Study Plans';
                    action("Lista Planos de Estudo")
                    {
                        ApplicationArea = All;
                        Caption = 'Study Plan Lst';
                        RunObject = page "Study Plan List";
                    }
                    action("Lista Cursos")
                    {
                        ApplicationArea = All;
                        Caption = 'Course List';
                        RunObject = page "Course List";
                    }
                    action("Disciplinas Cursos/Plano Estudo")
                    {
                        ApplicationArea = All;
                        Caption = 'Subjects Course/Study Plan';
                        RunObject = report "Subjects Course/Study Plan";
                    }
                    action("Turmas Curso/Plano Estudos 2")
                    {
                        ApplicationArea = All;
                        Caption = 'Class Course/Study Plan';
                        RunObject = report "Class Course/Study Plan";
                    }
                }
                group(Planeamento)
                {
                    Caption = 'Planning';
                    action("Lista Horários")
                    {
                        ApplicationArea = All;
                        Caption = 'Timetable';
                        RunObject = page "Timetable List";
                    }
                    action("Lista de Salas")
                    {
                        ApplicationArea = All;
                        Caption = 'Room List';
                        RunObject = page "Room List";
                    }
                    action("Calendário Base")
                    {
                        ApplicationArea = All;
                        Caption = 'Calendar Base';
                        RunObject = page "Calendar Base";
                    }
                    action("Modelo Horário")
                    {
                        ApplicationArea = All;
                        Caption = 'Modelo Horário';
                        RunObject = page "Timetable Template List";
                    }
                    action(Horário)
                    {
                        ApplicationArea = All;
                        Caption = 'Timetable';
                        RunObject = report Timetable;
                    }
                }
                group("Transporte e Cantina")
                {
                    Caption = 'Transport & Lunch';
                    action("Lista Transporte")
                    {
                        ApplicationArea = All;
                        Caption = 'Transport List';
                        RunObject = page "Transport List";
                    }
                    action("Assistente Transporte & Cantina")
                    {
                        ApplicationArea = All;
                        Caption = 'Transports Wizard';
                        RunObject = page "Transports Wizard";
                    }
                    action("Movimentos Transporte & Cantina")
                    {
                        ApplicationArea = All;
                        Caption = 'Transport Entry';
                        RunObject = page "Transport Entry";
                    }
                    action("Transporte - Itinerário")
                    {
                        ApplicationArea = All;
                        Caption = 'Transport Route';
                        RunObject = report "Transport Route";
                    }
                    action("Alunos por Transporte e Cantina")
                    {
                        ApplicationArea = All;
                        Caption = 'Students Transport and Lunch';
                        RunObject = report "Students Transport and Lunch";
                    }
                    action("Relação Diária Almoços")
                    {
                        ApplicationArea = All;
                        Caption = 'Value Daily Lunch';
                        RunObject = report "Value Daily Lunch";
                    }

                }
            }
            group("JDE Integrated")
            {
                Caption = 'JDE Integrated';
                action("Export JDE Int. Temp Files")
                {
                    ApplicationArea = All;
                    caption = 'Export JDE Int. Temp Files';
                    RunObject = xmlport "Export JDE Int. Temp Files";
                }
                action("Export JDE Int. Posted Files")
                {
                    ApplicationArea = All;
                    caption = 'Export JDE Int. Posted Files';
                    RunObject = xmlport "Export JDE Int. Posted Files";
                }
                action("Export JDE Int. G/L Entries")
                {
                    ApplicationArea = All;
                    caption = 'Export JDE Int. G/L Entries';
                    RunObject = xmlport "Export JDE Int. G/L Entries";
                }
                action("Import JDE Cust Codes")
                {
                    ApplicationArea = All;
                    caption = 'Import JDE Cust Codes';
                    RunObject = xmlport "Import JDE Cust Codes";
                }
            }
        }
    }
}
