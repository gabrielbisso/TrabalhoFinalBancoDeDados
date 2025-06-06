DROP SCHEMA IF EXISTS Consultorio;
CREATE SCHEMA Consultorio;
USE Consultorio;

CREATE TABLE Convenio (
	codConvenio INTEGER NOT NULL,
	nome VARCHAR(100) NOT NULL,
	CONSTRAINT PK_CONVENIO PRIMARY KEY(codConvenio)
);

CREATE TABLE Especialidade (
	codEspecialidade CHAR(2) NOT NULL,
	nome VARCHAR(100) NOT NULL,
	CONSTRAINT PK_ASSUNTO PRIMARY KEY(codEspecialidade)
);

CREATE TABLE Medico (
	codMedico INTEGER NOT NULL,
	nome VARCHAR(100) NOT NULL,
	datanascimento DATE NOT NULL,
    crm  VARCHAR(100) NOT NULL,
    telefone  VARCHAR(100) NOT NULL,
	codEspecialidade CHAR(2) NOT NULL,
	CONSTRAINT PK_MEDICO PRIMARY KEY(codMedico),
	CONSTRAINT FK_ESPECIALIDADE_MEDICO FOREIGN KEY(codEspecialidade) REFERENCES Especialidade(codEspecialidade)
);

CREATE TABLE Paciente (
	codPaciente INTEGER NOT NULL,
	nome VARCHAR(100) NOT NULL,
	cpf  VARCHAR(100) NOT NULL,
    rg  VARCHAR(100) NOT NULL,
	datanascimento DATE NOT NULL,
	telefone VARCHAR(100) NOT NULL,
	email VARCHAR(100) NOT NULL,
    codConvenio INTEGER NOT NULL,
	CONSTRAINT PK_MEDICO PRIMARY KEY(codPaciente),
    CONSTRAINT FK_CONVENIO_PACIENTE FOREIGN KEY(codConvenio) REFERENCES Convenio(codConvenio)
);

CREATE TABLE Atendimento (
	codMedico INTEGER,
	codPaciente INTEGER,
    dataAtendimento DATE,
    valor FLOAT,
	CONSTRAINT PK_ATENDIMENTO PRIMARY KEY(codMedico,codPaciente),
	CONSTRAINT FOREIGN KEY(codMedico) REFERENCES Medico (codMedico),
	CONSTRAINT FOREIGN KEY(codPaciente) REFERENCES Paciente (codPaciente) ON DELETE CASCADE
);

-- INSERINDO DADOS NA TABELA CONVENIO
INSERT INTO Convenio (codConvenio, nome)
	VALUES ('1','Unimed'),
			('2','Bradesco'),
            ('3','Amil'),
            ('4','Sompo Seguros'),
            ('5','Saúde Beneficiência'),
			('6','Golden Cross'),
            ('0','Particular');

-- INSERINDO DADOS NA TABELA ESPECIALIDADE
INSERT INTO Especialidade (codEspecialidade, nome)
	VALUES ('01','Anestesiologia'),
			('02','Cardiologia'),
            ('03','Cirurgia Geral'),
            ('04','Dermatologia'),
            ('05','Ginecologia e Obstetrícia'),
			('06','Ortopedia e Traumatologia'),
            ('07','Psiquiatria');
            
-- INSERINDO DADOS NA TABELA MÉDICO
INSERT INTO Medico (codMedico, nome, dataNascimento, crm, telefone, codEspecialidade)
	VALUES ('001','Lucas Neto','2000-01-01','123456','998450678','01'),
			('002','Mariana Medeiros','2001-03-23','123520','963251025','02'),
			('003','Vanessa Lopes','2002-11-16','012365','932587410','03'),
			('004','Marina Senna','2003-12-09','012012','930125694','04'),
			('005','Bruna Gonçalves','2000-09-03','785214','936021025','05'),
            ('006','Maya Massafera','2001-04-12','987520','901204560','06'),
            ('007','João Guilherme','2000-05-30','301265','947852103','04'),
            ('008','Luisa De Sá','2002-07-04','952145','993047852','03'),
            ('009','Marco André','2000-09-05','102365','910201030','06');
            
-- INSERINDO DADOS NA TABELA PACIENTE
INSERT INTO Paciente (codPaciente, nome, cpf, rg, datanascimento, telefone, email, codConvenio) 
	VALUES ('001','Andressa Viana','01254102031','745841239','2006-01-01','51991250678','andressaviana@gmail.com','0'),
			('002','Marco Andre','10214785101','467135089','2004-05-04','51941254785','marcoandre@gmail.com','1'),
			('003','Maria Eduarda Souza','47954384132','461376974','1986-07-01','55981514397','maria.souza@gmail.com','2'),
			('004','Vitória Viana','49692032913','461749851','1998-01-04','51992515138','vitoriavi.ana@gmail.com','3'),
			('005','Julia Bisso','12734689432','764381741','2006-05-14','54997634003','julia.bisso@gmail.com','4'),
            ('006','Carolina Farias','75681432895','594683105','2021-03-01','51948845635','carol.farias@gmail.com','5'),
            ('007','Daniel Santos','04779134007','794613854','2007-05-13','53987675849','danielsantos@gmail.com','0'),
            ('008','Guilherme Luz','74125896346','945682132','1996-11-25','21995313178','gui.luz@gmail.com','1'),
            ('009','Iago Fraga','00730489004','125743658','1983-12-17','51987564458','iago.fraga@gmail.com','3');
		
-- INSERINDO DADOS NA TABELA ATENDIMENTO
INSERT INTO Atendimento (codMedico, codPaciente, dataAtendimento, valor)
	VALUES ('001','009','2024-01-11', 42.00),
			('003','008','2024-04-19', 55.00),
			('003','007','2024-03-04', 800.00),
            ('004','006','2024-08-20', 150.00),
            ('006','004','2024-08-14', 350.00),
            ('007','003','2024-02-05', 30.00),
            ('008','002','2024-12-29', 60.00);
        
-- Pelo menos duas consultas devem implementar junção interna--------------------------------------------------------------------------
-- Consultar nome dos Pacientes e Médicos que realizaram atendimentos após o mês de março, ordenados de forma decrescente pela data.
SELECT P.nome AS Nome_Paciente, M.nome AS Nome_Medico, A.dataAtendimento AS Data_Atendimento
FROM Paciente P
INNER JOIN Atendimento A
ON P.codPaciente = A.codPaciente
INNER JOIN Medico M
ON A.codMedico = M.codMedico
WHERE A.dataAtendimento > '2024-03-31'
ORDER BY A.dataAtendimento DESC;

-- Consultar Nome e Valor do atendimento de cada paciente que tenha pagado entre R$ 50 e R$ 300, ordenados de forma crescente de valor do atendimento.
SELECT P.nome AS Nome_Paciente, A.valor AS Valor_Consulta
FROM Paciente P
NATURAL JOIN Atendimento A
WHERE A.valor BETWEEN 50 AND 300
ORDER BY A.valor ASC;

-- Pelo menos uma consulta deve implementar junção externa -----------------------------------------------------------
-- Lista de todos os pacientes, incluindo aqueles que não têm atendimentos registrados.
SELECT P.nome AS NomePaciente, C.nome AS NomeConvenio, A.codMedico, A.dataAtendimento, A.valor
FROM Paciente P
LEFT OUTER JOIN Atendimento A 
	ON P.codPaciente = A.codPaciente
LEFT OUTER JOIN Convenio C 
	ON P.codConvenio = C.codConvenio;
 
-- Pelo menos uma consulta deve implementar subconsultas--------------------------------------------------------------------------
-- Selecionar as especialidades em que foram atendidos e o nome dos pacientes cujo valor do atendimento é menor que a média do valor dos atendimentos.
SELECT E.nome AS Nome_Especialidade, P.nome AS Nome_Paciente, A.valor AS Valor_Atendimento
FROM Especialidade E
INNER JOIN Medico M
ON E.codEspecialidade = M.codespecialidade
INNER JOIN Atendimento A 
ON A.codMedico = M.codMedico
INNER JOIN Paciente P
ON P.codPaciente = A.codPaciente
WHERE A.valor >
	(SELECT AVG(valor) AS Media_ValorAtend
		FROM Atendimento A);

-- ○ Pelo menos duas delas devem implementar função agregada com agrupamento e cláusula having. Uma implementação de função agregada deve, necessariamente, acompanhar uma implementação com junção.
-- Listagem das especialidades com mais de um médico.
SELECT E.nome AS Especialidade, COUNT(M.codMedico) AS QuantidadeMedicos
FROM Medico M
INNER JOIN Especialidade E 
	ON M.codEspecialidade = E.codEspecialidade
GROUP BY E.nome
HAVING COUNT(M.codMedico) > 1
ORDER BY QuantidadeMedicos DESC;

-- Listagem dos convênios com média de valor dos atendimentos superior a R$ 50,00.
SELECT C.nome AS Convenio, AVG(A.valor) AS MediaValorAtendimento
FROM Atendimento A
INNER JOIN Paciente P
	ON A.codPaciente = P.codPaciente
INNER JOIN Convenio C 
	ON P.codConvenio = C.codConvenio
GROUP BY C.nome
HAVING AVG(A.valor) > 50
ORDER BY MediaValorAtendimento DESC;




