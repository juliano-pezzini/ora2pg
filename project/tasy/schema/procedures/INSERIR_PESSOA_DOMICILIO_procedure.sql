-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_pessoa_domicilio ( NM_USUARIO_P text, CD_PESSOA_FISICA_P text, NR_SEQ_DOMICILIO_P bigint DEFAULT NULL, NR_SEQ_GRAU_PARENTESCO_P bigint DEFAULT NULL, ACAO_P text DEFAULT 'OUTRA', NM_CONTATO_P text DEFAULT NULL, DS_BAIRRO_P text DEFAULT NULL, DS_COMPLEMENTO_P text DEFAULT NULL, DS_ENDERECO_P text DEFAULT NULL, NR_ENDERECO_P text DEFAULT NULL, DS_MUNICIPIO_P text DEFAULT NULL, NR_TELEFONE_P text DEFAULT NULL, CD_CEP_P text DEFAULT NULL, DS_REFERENCIA_P text DEFAULT NULL, IE_TIPO_DOMICILIO_P text DEFAULT NULL, IE_TRATAMENTO_AGUA_P text DEFAULT NULL, IE_TIPO_AGUA_P text DEFAULT NULL, IE_DESTINO_LIXO_P text DEFAULT NULL, IE_ESGOTO_SANITARIO_P text DEFAULT NULL, IE_TIPO_COMUNICACAO_P text DEFAULT NULL, IE_TIPO_DOENCA_P text DEFAULT NULL, IE_TIPO_TRANSPORTE_P text DEFAULT NULL, IE_ENERGIA_ELETRICA_P text DEFAULT NULL, DS_REF_RESIDENCIAL_P text DEFAULT NULL, NR_DDI_RESIDENCIAL_P text DEFAULT NULL, NR_SEQ_AREA_P bigint DEFAULT NULL, NR_SEQ_EQUIPE_P bigint DEFAULT NULL, NR_SEQ_MICROAREA_P bigint DEFAULT NULL, QT_COMODO_P bigint DEFAULT NULL, NR_SEQ_TIPO_LOGRADOURO_P bigint DEFAULT NULL, CD_DOMICILIO_P bigint DEFAULT NULL, INSERIR_SI_PROPRIO_P text DEFAULT 'N') AS $body$
DECLARE


  

NM_USUARIO_ATIVO_W USUARIO.NM_USUARIO%TYPE;
MEMBROSDOMICILIO   bigint;
QT_EXISTE          bigint;
NR_SEQ_DOMICILIO_W bigint;
NR_SEQ_PESSOA_DOMICILIO_W bigint;
NR_SEQUENCIA_COMPL_W bigint;

DS_BAIRRO_W varchar(30);
DS_COMPLEMENTO_W varchar(15);
DS_ENDERECO_W varchar(50);
NR_ENDERECO_W varchar(7);
CD_DOMICILIO_MUNICIPIO_W varchar(48);
NR_TEL_RESIDENCIAL_W varchar(50);
CD_CEP_W varchar(15);
NM_PESSOA_RESPONSAVEL_W varchar(255);
DS_REFERENCIA_W varchar(50);
IE_TIPO_DOMICILIO_W varchar(1);
IE_TRATAMENTO_AGUA_W varchar(1);
IE_TIPO_AGUA_W varchar(1);
IE_DESTINO_LIXO_W varchar(1);
IE_ESGOTO_SANITARIO_W varchar(1);
IE_TIPO_COMUNICACAO_W varchar(1);
IE_TIPO_DOENCA_W varchar(1);
IE_TIPO_TRANSPORTE_W varchar(1);
IE_ENERGIA_ELETRICA_W varchar(1);
DS_REF_RESIDENCIAL_W varchar(50);
NR_DDI_RESIDENCIAL_W varchar(3);
NR_SEQ_AREA_W  bigint;
NR_SEQ_EQUIPE_W  bigint;
NR_SEQ_MICROAREA_W bigint;
QT_COMODO_W smallint;
NR_SEQ_TIPO_LOGRADOURO_W bigint;
CD_DOMICILIO_W bigint;
tag_pais_w	varchar(15);



C02 CURSOR FOR /*UTILIZADO PARA PREENCHER DADOS DA MORADIA*/
	SELECT DISTINCT A.CD_PESSOA_FISICA
	FROM DOMICILIO_FAMILIA A
	WHERE CD_DOMICILIO = CD_DOMICILIO_P
	AND CD_PESSOA_FISICA NOT IN (SELECT B.CD_PESSOA_FAMILIA
					FROM PESSOA_DOMICILIO_MORADIA B
					WHERE B.NR_SEQ_DOMICILIO = CD_DOMICILIO_P
					AND B.CD_PESSOA_FAMILIA = A.CD_PESSOA_FISICA);


C01 CURSOR FOR /*UTILIZADO PARA PREENCHER DADOS AO VINCULAR DOMICILIOS DE UM PACIENTE PARA OUTRO.*/
SELECT  DS_BAIRRO,
        DS_COMPLEMENTO,
        DS_ENDERECO,
        NR_ENDERECO,
        CD_DOMICILIO_MUNICIPIO,
        NR_TEL_RESIDENCIAL,
        CD_CEP,
        NM_PESSOA_RESPONSAVEL,
        DS_REFERENCIA,
        IE_TIPO_DOMICILIO,
        IE_TRATAMENTO_AGUA,
        IE_TIPO_AGUA,
        IE_DESTINO_LIXO,
        IE_ESGOTO_SANITARIO,
        IE_TIPO_COMUNICACAO,
        IE_TIPO_DOENCA,
        IE_TIPO_TRANSPORTE,
        IE_ENERGIA_ELETRICA,
        DS_REF_RESIDENCIAL,
        NR_DDI_RESIDENCIAL,
        NR_SEQ_AREA,
        NR_SEQ_EQUIPE,
        NR_SEQ_MICROAREA,
        QT_COMODO,
        NR_SEQ_TIPO_LOGRADOURO,
        CD_DOMICILIO
        FROM DOMICILIO_FAMILIA
	WHERE CD_DOMICILIO = CD_DOMICILIO_P
	AND NR_SEQUENCIA = CD_DOMICILIO;

BEGIN

OPEN C01;
	FETCH C01 INTO
	DS_BAIRRO_W,
	DS_COMPLEMENTO_W,
	DS_ENDERECO_W,
	NR_ENDERECO_W,
	CD_DOMICILIO_MUNICIPIO_W,
	NR_TEL_RESIDENCIAL_W,
	CD_CEP_W,
	NM_PESSOA_RESPONSAVEL_W,
	DS_REFERENCIA_W,
	IE_TIPO_DOMICILIO_W,
	IE_TRATAMENTO_AGUA_W,
	IE_TIPO_AGUA_W,
	IE_DESTINO_LIXO_W,
	IE_ESGOTO_SANITARIO_W,
	IE_TIPO_COMUNICACAO_W,
	IE_TIPO_DOENCA_W,
	IE_TIPO_TRANSPORTE_W,
	IE_ENERGIA_ELETRICA_W,
	DS_REF_RESIDENCIAL_W,
	NR_DDI_RESIDENCIAL_W,
	NR_SEQ_AREA_W,
	NR_SEQ_EQUIPE_W,
	NR_SEQ_MICROAREA_W,
	QT_COMODO_W,
	NR_SEQ_TIPO_LOGRADOURO_W,
	CD_DOMICILIO_W;
CLOSE C01;

select	max(ds_locale)
into STRICT	tag_pais_w
from	user_locale 
where	nm_user = NM_USUARIO_P;

IF ACAO_P = 'INSERIR_RESIDENCIA' THEN
	
	SELECT	coalesce(MAX(NR_SEQUENCIA),0) + 1
		INTO STRICT	NR_SEQUENCIA_COMPL_W
		FROM	COMPL_PESSOA_FISICA
		WHERE	CD_PESSOA_FISICA = CD_PESSOA_FISICA_P;
	
	if (tag_pais_w = 'de_DE')then
		INSERT INTO COMPL_PESSOA_FISICA(NR_SEQUENCIA,
						CD_PESSOA_FISICA,
						IE_TIPO_COMPLEMENTO,
						DT_ATUALIZACAO,
						DT_ATUALIZACAO_NREC,
						NM_USUARIO,
						NM_USUARIO_NREC,
						CD_CEP,
						DS_BAIRRO,
						DS_COMPLEMENTO,
						DS_MUNICIPIO,
						DS_COMPL_END,
						DS_ENDERECO)
					 VALUES (NR_SEQUENCIA_COMPL_W,
						CD_PESSOA_FISICA_P,
						'1',
						clock_timestamp(),
						clock_timestamp(),
						NM_USUARIO_P,
						NM_USUARIO_P,
						CD_CEP_W,
						DS_BAIRRO_W,
						DS_COMPLEMENTO_W,
						CD_DOMICILIO_MUNICIPIO_W,
						NR_ENDERECO_W,
						DS_ENDERECO_W);
						COMMIT;
	else
		INSERT INTO COMPL_PESSOA_FISICA(NR_SEQUENCIA,
						CD_PESSOA_FISICA,
						IE_TIPO_COMPLEMENTO,
						DT_ATUALIZACAO,
						DT_ATUALIZACAO_NREC,
						NM_USUARIO,
						NM_USUARIO_NREC,
						CD_CEP,
						DS_BAIRRO,
						DS_COMPLEMENTO,
						DS_MUNICIPIO,
						NR_ENDERECO,
						DS_ENDERECO)
					 VALUES (NR_SEQUENCIA_COMPL_W,
						CD_PESSOA_FISICA_P,
						'1',
						clock_timestamp(),
						clock_timestamp(),
						NM_USUARIO_P,
						NM_USUARIO_P,
						CD_CEP_W,
						DS_BAIRRO_W,
						DS_COMPLEMENTO_W,
						CD_DOMICILIO_MUNICIPIO_W,
						NR_ENDERECO_W,
						DS_ENDERECO_W);
						COMMIT;
	end if;

ELSIF ACAO_P = 'ALTERAR_RESIDENCIA' THEN
	if (tag_pais_w = 'de_DE')then
		UPDATE COMPL_PESSOA_FISICA
			SET  DT_ATUALIZACAO = clock_timestamp(),
			DT_ATUALIZACAO_NREC = clock_timestamp(),
			NM_USUARIO = NM_USUARIO_P,
			NM_USUARIO_NREC = NM_USUARIO_P,
			CD_CEP = CD_CEP_W,
			DS_BAIRRO = DS_BAIRRO_W,
			DS_COMPLEMENTO = DS_COMPLEMENTO_W,
			DS_MUNICIPIO = CD_DOMICILIO_MUNICIPIO_W,
			DS_COMPL_END = NR_ENDERECO_W,
			DS_ENDERECO = DS_ENDERECO_W
			WHERE CD_PESSOA_FISICA = CD_PESSOA_FISICA_P
				AND IE_TIPO_COMPLEMENTO  = 1;
			COMMIT;
	else
		UPDATE COMPL_PESSOA_FISICA
			SET  DT_ATUALIZACAO = clock_timestamp(),
			DT_ATUALIZACAO_NREC = clock_timestamp(),
			NM_USUARIO = NM_USUARIO_P,
			NM_USUARIO_NREC = NM_USUARIO_P,
			CD_CEP = CD_CEP_W,
			DS_BAIRRO = DS_BAIRRO_W,
			DS_COMPLEMENTO = DS_COMPLEMENTO_W,
			DS_MUNICIPIO = CD_DOMICILIO_MUNICIPIO_W,
			NR_ENDERECO = NR_ENDERECO_W,
			DS_ENDERECO = DS_ENDERECO_W
			WHERE CD_PESSOA_FISICA = CD_PESSOA_FISICA_P
				AND IE_TIPO_COMPLEMENTO  = 1;
			COMMIT;
	end if;

ELSE

	NM_USUARIO_ATIVO_W     := WHEB_USUARIO_PCK.GET_NM_USUARIO;
	SELECT nextval('domicilio_familia_seq')
		INTO STRICT NR_SEQ_DOMICILIO_W
		;
		
	SELECT nextval('pessoa_domicilio_moradia_seq')
		INTO STRICT NR_SEQ_PESSOA_DOMICILIO_W
		;

	IF ACAO_P = 'MUDAR DOMICILIO' OR ACAO_P = 'DELETE MORADIA' THEN
		SELECT COUNT(1)
			INTO STRICT QT_EXISTE
			FROM  DOMICILIO_FAMILIA
			WHERE CD_PESSOA_FISICA = CD_PESSOA_FISICA_P AND IE_MUDOU_SE = 'N';
		IF QT_EXISTE >= 1 THEN
			UPDATE DOMICILIO_FAMILIA
				SET IE_MUDOU_SE  =  'S'
				WHERE CD_PESSOA_FISICA = CD_PESSOA_FISICA_P;
		END IF;

		SELECT COUNT(1)
			INTO STRICT QT_EXISTE
			FROM  PESSOA_DOMICILIO_MORADIA
			WHERE CD_PESSOA_FAMILIA = CD_PESSOA_FISICA_P;
		IF QT_EXISTE >= 1 THEN
			UPDATE PESSOA_DOMICILIO_MORADIA
			SET IE_MUDOU_SE  =  'S'
			WHERE CD_PESSOA_FAMILIA = CD_PESSOA_FISICA_P;
		END IF;

    
	ELSIF ACAO_P = 'ATUALIZA CD_DOMICILIO' THEN
		
		UPDATE DOMICILIO_FAMILIA
			SET CD_DOMICILIO = NR_SEQUENCIA
			WHERE coalesce(CD_DOMICILIO::text, '') = '';
			COMMIT;

	ELSIF ACAO_P = 'CD MORADIA' THEN
    
		UPDATE PESSOA_DOMICILIO_MORADIA
			SET NR_SEQ_DOMICILIO = CD_DOMICILIO_P
			WHERE CD_PESSOA_FISICA = CD_PESSOA_FISICA_P
			AND coalesce(NR_SEQ_DOMICILIO::text, '') = '';
			COMMIT;

	ELSIF ACAO_P = 'MEMBROS DOMICILIO' OR ACAO_P = 'INSERIR NOVO' THEN -- INSERIR NOVOS MEMBROS AO DOMICILIO.
	
		SELECT COUNT(1)
			INTO STRICT QT_EXISTE
			FROM  DOMICILIO_FAMILIA
			WHERE CD_PESSOA_FISICA = CD_PESSOA_FISICA_P AND IE_MUDOU_SE = 'N';
		IF QT_EXISTE >= 1 THEN
			UPDATE DOMICILIO_FAMILIA
			SET IE_MUDOU_SE  =  'S'
			WHERE CD_PESSOA_FISICA = CD_PESSOA_FISICA_P;
		END IF;
		
		IF ACAO_P = 'MEMBROS DOMICILIO' THEN
        
			UPDATE PESSOA_DOMICILIO_MORADIA
				SET NR_SEQ_DOMICILIO = CD_DOMICILIO_P
				WHERE CD_PESSOA_FISICA = CD_PESSOA_FISICA_P;
				COMMIT;
		END IF;


		INSERT
		INTO DOMICILIO_FAMILIA(NR_SEQUENCIA,
					NM_USUARIO,
					DT_ATUALIZACAO_NREC,
					NM_USUARIO_NREC,
					DS_BAIRRO,
					DS_COMPLEMENTO,
					DS_ENDERECO,
					NR_ENDERECO,
					CD_DOMICILIO_MUNICIPIO,
					NR_TEL_RESIDENCIAL,
					CD_PESSOA_FISICA,
					CD_CEP,
					NM_PESSOA_RESPONSAVEL,
					IE_MUDOU_SE,
					DT_ATUALIZACAO,
					DS_REFERENCIA,
					IE_TIPO_DOMICILIO,
					IE_TRATAMENTO_AGUA,
					IE_TIPO_AGUA,
					IE_DESTINO_LIXO,
					IE_ESGOTO_SANITARIO,
					IE_TIPO_COMUNICACAO,
					IE_TIPO_DOENCA,
					IE_TIPO_TRANSPORTE,
					IE_ENERGIA_ELETRICA,
					DS_REF_RESIDENCIAL,
					NR_DDI_RESIDENCIAL,
					NR_SEQ_AREA,
					NR_SEQ_EQUIPE,
					NR_SEQ_MICROAREA,
					QT_COMODO,
					NR_SEQ_TIPO_LOGRADOURO,
					CD_DOMICILIO)
				VALUES (NR_SEQ_DOMICILIO_W,
					NM_USUARIO_P,
					clock_timestamp(),
					NM_USUARIO_P,
					substr(DS_BAIRRO_P,1,30),
					substr(DS_COMPLEMENTO_P,1,15),
					substr(DS_ENDERECO_P,1,50),
					NR_ENDERECO_P,
					DS_MUNICIPIO_P,
					NR_TELEFONE_P,
					CD_PESSOA_FISICA_P,
					CD_CEP_P,
					NM_CONTATO_P,
					'N',
					clock_timestamp(),
					DS_REFERENCIA_P,
					IE_TIPO_DOMICILIO_P,
					IE_TRATAMENTO_AGUA_P,
					IE_TIPO_AGUA_P,
					IE_DESTINO_LIXO_P,
					IE_ESGOTO_SANITARIO_P,
					IE_TIPO_COMUNICACAO_P,
					IE_TIPO_DOENCA_P,
					IE_TIPO_TRANSPORTE_P,
					IE_ENERGIA_ELETRICA_P,
					DS_REF_RESIDENCIAL_P,
					NR_DDI_RESIDENCIAL_P,
					NR_SEQ_AREA_P,
					NR_SEQ_EQUIPE_P,
					NR_SEQ_MICROAREA_P,
					QT_COMODO_P,
					NR_SEQ_TIPO_LOGRADOURO_P,
					CD_DOMICILIO_P);
					COMMIT;
					
		IF coalesce(CD_DOMICILIO_P::text, '') = '' THEN
			UPDATE DOMICILIO_FAMILIA
				SET CD_DOMICILIO = (NR_SEQUENCIA)
				WHERE CD_PESSOA_FISICA = CD_PESSOA_FISICA_P;
				COMMIT;
			END IF;
	
	ELSIF ACAO_P = 'INSERIR DOMICILIO COMPL' THEN -- INSERIR NOVO DOMICILIO ATRAVÉS DE COMPL_PESSOA_FISICA.
	    
		SELECT COUNT(1)
			INTO STRICT QT_EXISTE
			FROM  DOMICILIO_FAMILIA
			WHERE CD_PESSOA_FISICA = CD_PESSOA_FISICA_P AND IE_MUDOU_SE = 'N';
		IF QT_EXISTE >= 1 THEN
			UPDATE DOMICILIO_FAMILIA
				SET IE_MUDOU_SE  =  'S'
				WHERE CD_PESSOA_FISICA = CD_PESSOA_FISICA_P;
		END IF;
		
		SELECT COUNT(1)
			INTO STRICT QT_EXISTE
			FROM  PESSOA_DOMICILIO_MORADIA
			WHERE CD_PESSOA_FAMILIA = CD_PESSOA_FISICA_P;
			
		IF QT_EXISTE >= 1 THEN
			UPDATE PESSOA_DOMICILIO_MORADIA
				SET IE_MUDOU_SE  =  'S'
				WHERE CD_PESSOA_FAMILIA = CD_PESSOA_FISICA_P;
		END IF;
		
		INSERT
			INTO DOMICILIO_FAMILIA(NR_SEQUENCIA,
			NM_USUARIO,
			DT_ATUALIZACAO_NREC,
			NM_USUARIO_NREC,
			DS_BAIRRO,
			DS_COMPLEMENTO,
			DS_ENDERECO,
			NR_ENDERECO,
			CD_DOMICILIO_MUNICIPIO,
			NR_TEL_RESIDENCIAL,
			CD_PESSOA_FISICA,
			CD_CEP,
			NM_PESSOA_RESPONSAVEL,
			IE_MUDOU_SE,
			DT_ATUALIZACAO)
		VALUES ( NR_SEQ_DOMICILIO_W,
			NM_USUARIO_P,
			clock_timestamp(),
			NM_USUARIO_P,
			substr(DS_BAIRRO_P,1,30),
			substr(DS_COMPLEMENTO_P,1,15),
			substr(DS_ENDERECO_P,1,50),
			NR_ENDERECO_P,
			DS_MUNICIPIO_P,
			NR_TELEFONE_P,
			CD_PESSOA_FISICA_P,
			CD_CEP_P,
			NM_CONTATO_P,
			'N',
			clock_timestamp());
		    COMMIT;
		
		IF coalesce(CD_DOMICILIO_P::text, '') = '' THEN
			UPDATE DOMICILIO_FAMILIA
				SET CD_DOMICILIO = (NR_SEQUENCIA)
				WHERE CD_PESSOA_FISICA = CD_PESSOA_FISICA_P;
				COMMIT;
		END IF;
		
	ELSIF ACAO_P =  'ATUALIZA COMPL' THEN
		UPDATE DOMICILIO_FAMILIA
			SET DS_BAIRRO = substr(DS_BAIRRO_P,1,30),
			DS_COMPLEMENTO = substr(DS_COMPLEMENTO_P,1,15),
			DS_ENDERECO = substr(DS_ENDERECO_P,1,50),
			NR_ENDERECO = NR_ENDERECO_P,
			CD_DOMICILIO_MUNICIPIO = DS_MUNICIPIO_P,
			NR_TEL_RESIDENCIAL = NR_TELEFONE_P,
			CD_CEP = CD_CEP_P,
			NM_PESSOA_RESPONSAVEL = NM_CONTATO_P
			WHERE CD_PESSOA_FISICA = CD_PESSOA_FISICA_P
			AND IE_MUDOU_SE = 'N';
			COMMIT;

	ELSIF ACAO_P =  'ATUALIZA TODOS COMPL' THEN
		UPDATE DOMICILIO_FAMILIA
			SET DS_BAIRRO = substr(DS_BAIRRO_P,1,30),
			DS_COMPLEMENTO = substr(DS_COMPLEMENTO_P,1,15),
			DS_ENDERECO = substr(DS_ENDERECO_P,1,50),
			NR_ENDERECO = NR_ENDERECO_P,
			CD_DOMICILIO_MUNICIPIO = DS_MUNICIPIO_P,
			NR_TEL_RESIDENCIAL = NR_TELEFONE_P,
			CD_CEP = CD_CEP_P,
			NM_PESSOA_RESPONSAVEL = NM_CONTATO_P
		WHERE CD_DOMICILIO = (  SELECT CD_DOMICILIO
					FROM DOMICILIO_FAMILIA
					WHERE CD_PESSOA_FISICA = CD_PESSOA_FISICA_P
					AND IE_MUDOU_SE = 'N')
					AND IE_MUDOU_SE = 'N';
		COMMIT;

	
	ELSIF ACAO_P = 'DELETE' THEN
		DELETE FROM PESSOA_DOMICILIO_MORADIA
			WHERE CD_PESSOA_FISICA = CD_PESSOA_FISICA_P AND NR_SEQ_DOMICILIO = NR_SEQ_DOMICILIO_P;
			COMMIT;
	
	  ELSIF ACAO_P = 'UPDATE ALL' THEN
		UPDATE DOMICILIO_FAMILIA
			SET  DT_ATUALIZACAO_NREC = clock_timestamp(),
			NM_USUARIO_NREC = NM_USUARIO_P,
			DS_BAIRRO = substr(DS_BAIRRO_P,1,30),
			DS_COMPLEMENTO = substr(DS_COMPLEMENTO_P,1,15),
			DS_ENDERECO = substr(DS_ENDERECO_P,1,50),
			NR_ENDERECO = NR_ENDERECO_P,
			NR_TEL_RESIDENCIAL = NR_TELEFONE_P,
			CD_CEP = CD_CEP_P,
			NM_PESSOA_RESPONSAVEL = NM_CONTATO_P,
			DT_ATUALIZACAO = clock_timestamp(),
			CD_DOMICILIO_MUNICIPIO = DS_MUNICIPIO_P,
			DS_REFERENCIA = DS_REFERENCIA_P,
			IE_TIPO_DOMICILIO = IE_TIPO_DOMICILIO_P,
			IE_TRATAMENTO_AGUA = IE_TRATAMENTO_AGUA_P,
			IE_TIPO_AGUA = IE_TIPO_AGUA_P,
			IE_DESTINO_LIXO = IE_DESTINO_LIXO_P,
			IE_ESGOTO_SANITARIO = IE_ESGOTO_SANITARIO_P,
			IE_TIPO_COMUNICACAO = IE_TIPO_COMUNICACAO_P,
			IE_TIPO_DOENCA = IE_TIPO_DOENCA_P,
			IE_TIPO_TRANSPORTE = IE_TIPO_TRANSPORTE_P,
			IE_ENERGIA_ELETRICA = IE_ENERGIA_ELETRICA_P,
			DS_REF_RESIDENCIAL = DS_REF_RESIDENCIAL_P,
			NR_SEQ_AREA = NR_SEQ_AREA_P,
			NR_SEQ_EQUIPE = NR_SEQ_EQUIPE_P,
			NR_SEQ_MICROAREA = NR_SEQ_MICROAREA_P,
			QT_COMODO = QT_COMODO_P,
			NR_SEQ_TIPO_LOGRADOURO = NR_SEQ_TIPO_LOGRADOURO_P
			WHERE CD_DOMICILIO = CD_DOMICILIO_P;
			COMMIT;
	  
	ELSIF ACAO_P = 'VINCULAR' THEN
		  
		SELECT COUNT(1)
			INTO STRICT QT_EXISTE
			FROM  PESSOA_DOMICILIO_MORADIA
			WHERE CD_PESSOA_FAMILIA = CD_PESSOA_FISICA_P;
		IF QT_EXISTE >= 1 THEN
			UPDATE PESSOA_DOMICILIO_MORADIA
			SET IE_MUDOU_SE  =  'S'
			WHERE CD_PESSOA_FAMILIA = CD_PESSOA_FISICA_P;
		END IF;

		SELECT COUNT(1)
			INTO STRICT QT_EXISTE
			FROM  DOMICILIO_FAMILIA
			WHERE CD_PESSOA_FISICA = CD_PESSOA_FISICA_P AND IE_MUDOU_SE = 'N';
		IF QT_EXISTE >= 1 THEN
			UPDATE DOMICILIO_FAMILIA
			SET IE_MUDOU_SE  =  'S'
			WHERE CD_PESSOA_FISICA = CD_PESSOA_FISICA_P;
		END IF;
		
		    
		FOR REGISTRO IN C02
		LOOP
    IF (CD_PESSOA_FISICA_P <> REGISTRO.CD_PESSOA_FISICA)THEN
		INSERT INTO PESSOA_DOMICILIO_MORADIA(  NR_SEQUENCIA,
							NR_SEQ_DOMICILIO,
							DT_ATUALIZACAO,
							NM_USUARIO,
							DT_ATUALIZACAO_NREC,
							NM_USUARIO_NREC,
							CD_PESSOA_FISICA,
							CD_PESSOA_FAMILIA,
							NR_SEQ_GRAU_PARENT,
							IE_MUDOU_SE)
						VALUES (nextval('pessoa_domicilio_moradia_seq'),
							NR_SEQ_DOMICILIO_P,
							clock_timestamp(),
							NM_USUARIO_P,
							clock_timestamp(),
							NM_USUARIO_P,
							CD_PESSOA_FISICA_P,
							REGISTRO.CD_PESSOA_FISICA,
							NR_SEQ_GRAU_PARENTESCO_P, 'N');
              END IF;
		END LOOP;

		INSERT
		INTO DOMICILIO_FAMILIA( NR_SEQUENCIA,
					DT_ATUALIZACAO,
					NM_USUARIO,
					DT_ATUALIZACAO_NREC,
					NM_USUARIO_NREC,
					DS_BAIRRO,
					DS_COMPLEMENTO,
					DS_ENDERECO,
					NR_ENDERECO,
					CD_DOMICILIO_MUNICIPIO,
					NR_TEL_RESIDENCIAL,
					CD_PESSOA_FISICA,
					CD_CEP,
					NM_PESSOA_RESPONSAVEL,
					IE_MUDOU_SE,
					DS_REFERENCIA,
					IE_TIPO_DOMICILIO,
					IE_TRATAMENTO_AGUA,
					IE_TIPO_AGUA,
					IE_DESTINO_LIXO,
					IE_ESGOTO_SANITARIO,
					IE_TIPO_COMUNICACAO,
					IE_TIPO_DOENCA,
					IE_TIPO_TRANSPORTE,
					IE_ENERGIA_ELETRICA,
					DS_REF_RESIDENCIAL,
					NR_DDI_RESIDENCIAL,
					NR_SEQ_AREA,
					NR_SEQ_EQUIPE,
					NR_SEQ_MICROAREA,
					QT_COMODO,
					NR_SEQ_TIPO_LOGRADOURO,
					CD_DOMICILIO)
				VALUES (NR_SEQ_DOMICILIO_W,
					clock_timestamp(),
					NM_USUARIO_P,
					clock_timestamp(),
					NM_USUARIO_P,
					substr(DS_BAIRRO_W,1,30),
					substr(DS_COMPLEMENTO_W,1,15),
					substr(DS_ENDERECO_W,1,50),
					NR_ENDERECO_W,
					CD_DOMICILIO_MUNICIPIO_W,
					NR_TEL_RESIDENCIAL_W,
					CD_PESSOA_FISICA_P,
					CD_CEP_W,
					NM_PESSOA_RESPONSAVEL_W,
					'N',
					DS_REFERENCIA_W,
					IE_TIPO_DOMICILIO_W,
					IE_TRATAMENTO_AGUA_W,
					IE_TIPO_AGUA_W,
					IE_DESTINO_LIXO_W,
					IE_ESGOTO_SANITARIO_W,
					IE_TIPO_COMUNICACAO_W,
					IE_TIPO_DOENCA_W,
					IE_TIPO_TRANSPORTE_W,
					IE_ENERGIA_ELETRICA_W,
					DS_REF_RESIDENCIAL_W,
					NR_DDI_RESIDENCIAL_W,
					NR_SEQ_AREA_W,
					NR_SEQ_EQUIPE_W,
					NR_SEQ_MICROAREA_W,
					QT_COMODO_W,
					NR_SEQ_TIPO_LOGRADOURO_W,
					CD_DOMICILIO_W);
					COMMIT;
		
    IF coalesce(CD_DOMICILIO_P::text, '') = '' THEN
			UPDATE DOMICILIO_FAMILIA
				SET CD_DOMICILIO = (NR_SEQUENCIA)
				WHERE CD_PESSOA_FISICA = CD_PESSOA_FISICA_P;
				COMMIT;
		END IF;
	END IF;
		

	IF INSERIR_SI_PROPRIO_P = 'S' THEN
		INSERT INTO PESSOA_DOMICILIO_MORADIA(  NR_SEQUENCIA,
							NR_SEQ_DOMICILIO,
							DT_ATUALIZACAO,
							NM_USUARIO,
							DT_ATUALIZACAO_NREC,
							NM_USUARIO_NREC,
							CD_PESSOA_FISICA,
							CD_PESSOA_FAMILIA,
							NR_SEQ_GRAU_PARENT,
							IE_MUDOU_SE)
						VALUES (NR_SEQ_PESSOA_DOMICILIO_W,
							NR_SEQ_DOMICILIO_P,
							clock_timestamp(),
							NM_USUARIO_ATIVO_W,
							clock_timestamp(),
							NM_USUARIO_ATIVO_W,
							CD_PESSOA_FISICA_P,
							CD_PESSOA_FISICA_P,
							NR_SEQ_GRAU_PARENTESCO_P,
							'N');
							COMMIT;

		
	IF coalesce(NR_SEQ_DOMICILIO_P::text, '') = '' THEN
		IF ACAO_P = 'MUDAR DOMICILIO' OR ACAO_P = 'ATUALIZA CD_DOMICILIO' OR ACAO_P = 'INSERIR DOMICILIO COMPL' OR ACAO_P = 'INSERIR NOVO' OR ACAO_P = 'ATUALIZA CD_DOMICILIO' THEN
			UPDATE PESSOA_DOMICILIO_MORADIA
				SET NR_SEQ_DOMICILIO = (SELECT CD_DOMICILIO
							FROM DOMICILIO_FAMILIA
							WHERE NR_SEQUENCIA = (  SELECT MAX(NR_SEQUENCIA)
							FROM DOMICILIO_FAMILIA))
							WHERE NR_SEQUENCIA = (SELECT MAX(NR_SEQUENCIA)
							FROM PESSOA_DOMICILIO_MORADIA);
			COMMIT;
		END IF;
	END IF;
	END IF;
END IF;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_pessoa_domicilio ( NM_USUARIO_P text, CD_PESSOA_FISICA_P text, NR_SEQ_DOMICILIO_P bigint DEFAULT NULL, NR_SEQ_GRAU_PARENTESCO_P bigint DEFAULT NULL, ACAO_P text DEFAULT 'OUTRA', NM_CONTATO_P text DEFAULT NULL, DS_BAIRRO_P text DEFAULT NULL, DS_COMPLEMENTO_P text DEFAULT NULL, DS_ENDERECO_P text DEFAULT NULL, NR_ENDERECO_P text DEFAULT NULL, DS_MUNICIPIO_P text DEFAULT NULL, NR_TELEFONE_P text DEFAULT NULL, CD_CEP_P text DEFAULT NULL, DS_REFERENCIA_P text DEFAULT NULL, IE_TIPO_DOMICILIO_P text DEFAULT NULL, IE_TRATAMENTO_AGUA_P text DEFAULT NULL, IE_TIPO_AGUA_P text DEFAULT NULL, IE_DESTINO_LIXO_P text DEFAULT NULL, IE_ESGOTO_SANITARIO_P text DEFAULT NULL, IE_TIPO_COMUNICACAO_P text DEFAULT NULL, IE_TIPO_DOENCA_P text DEFAULT NULL, IE_TIPO_TRANSPORTE_P text DEFAULT NULL, IE_ENERGIA_ELETRICA_P text DEFAULT NULL, DS_REF_RESIDENCIAL_P text DEFAULT NULL, NR_DDI_RESIDENCIAL_P text DEFAULT NULL, NR_SEQ_AREA_P bigint DEFAULT NULL, NR_SEQ_EQUIPE_P bigint DEFAULT NULL, NR_SEQ_MICROAREA_P bigint DEFAULT NULL, QT_COMODO_P bigint DEFAULT NULL, NR_SEQ_TIPO_LOGRADOURO_P bigint DEFAULT NULL, CD_DOMICILIO_P bigint DEFAULT NULL, INSERIR_SI_PROPRIO_P text DEFAULT 'N') FROM PUBLIC;
