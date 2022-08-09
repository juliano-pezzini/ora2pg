-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_bsc_calculo ( nm_usuario_p text, cd_pessoa_fisica_p text) AS $body$
DECLARE


nr_sequencia_mensal_w		bsc_calculo.nr_sequencia%type;
cd_periodo_mensal_w			bsc_calculo.cd_periodo%type;

nr_sequencia_bimestral_w	bsc_calculo.nr_sequencia%type;
cd_periodo_bimestral_w		bsc_calculo.cd_periodo%type;

nr_sequencia_semestral_w	bsc_calculo.nr_sequencia%type;
cd_periodo_semestral_w		bsc_calculo.cd_periodo%type;

nr_sequencia_anual_w		bsc_calculo.nr_sequencia%type;
cd_ano_anual_w				bsc_calculo.cd_ano%type;

nr_sequencia_quadrim_w		bsc_calculo.nr_sequencia%type;
cd_periodo_quadrim_w		bsc_calculo.cd_periodo%type;

nr_sequencia_trimestral_w	bsc_calculo.nr_sequencia%type;
cd_periodo_trimestral_w		bsc_calculo.cd_periodo%type;

cd_mes_atual_w 				bsc_calculo.cd_periodo%type;

ie_base_corp_w 				varchar(1);


BEGIN

	ie_base_corp_w 		:= obter_se_base_corp;
	cd_mes_atual_w 		:= (TO_CHAR(clock_timestamp(),'mm'))::numeric;

	SELECT 	coalesce(MAX(nr_sequencia),0)
	INTO STRICT	nr_sequencia_mensal_w
	FROM 	bsc_calculo
	WHERE 	ie_periodo = 'M';

	SELECT 	coalesce(MAX(nr_sequencia),0)
	INTO STRICT	nr_sequencia_anual_w
	FROM 	bsc_calculo
	WHERE  	ie_periodo = 'A';

	SELECT 	coalesce(MAX(nr_sequencia),0)
	INTO STRICT	nr_sequencia_bimestral_w
	FROM 	bsc_calculo
	WHERE  	ie_periodo = 'B';

	SELECT 	coalesce(MAX(nr_sequencia),0)
	INTO STRICT	nr_sequencia_quadrim_w
	FROM 	bsc_calculo
	WHERE  	ie_periodo = 'Q';

	SELECT 	coalesce(MAX(nr_sequencia),0)
	INTO STRICT	nr_sequencia_semestral_w
	FROM 	bsc_calculo
	WHERE  	ie_periodo = 'S';

	SELECT 	coalesce(MAX(nr_sequencia),0)
	INTO STRICT	nr_sequencia_trimestral_w
	FROM 	bsc_calculo
	WHERE  	ie_periodo = 'T';

	IF (nr_sequencia_mensal_w > 0) THEN
		SELECT	coalesce(cd_periodo,0)
		INTO STRICT	cd_periodo_mensal_w
		FROM	bsc_calculo
		WHERE	nr_sequencia = nr_sequencia_mensal_w;
	END IF;

	IF (nr_sequencia_anual_w > 0) THEN
		SELECT	coalesce(cd_ano,0)
		INTO STRICT	cd_ano_anual_w
		FROM	bsc_calculo
		WHERE	nr_sequencia = nr_sequencia_anual_w;
	END IF;

	IF (nr_sequencia_bimestral_w > 0) THEN
		SELECT	coalesce(cd_periodo,0)
		INTO STRICT	cd_periodo_bimestral_w
		FROM	bsc_calculo
		WHERE	nr_sequencia = nr_sequencia_bimestral_w;
	END IF;

	IF (nr_sequencia_quadrim_w > 0) THEN
		SELECT	coalesce(cd_periodo,0)
		INTO STRICT	cd_periodo_quadrim_w
		FROM	bsc_calculo
		WHERE	nr_sequencia = nr_sequencia_quadrim_w;
	END IF;

	IF (nr_sequencia_semestral_w > 0) THEN
		SELECT	coalesce(cd_periodo,0)
		INTO STRICT	cd_periodo_semestral_w
		FROM	bsc_calculo
		WHERE	nr_sequencia = nr_sequencia_semestral_w;
	END IF;

	IF (nr_sequencia_trimestral_w > 0) THEN
		SELECT	coalesce(cd_periodo,0)
		INTO STRICT	cd_periodo_trimestral_w
		FROM	bsc_calculo
		WHERE	nr_sequencia = nr_sequencia_trimestral_w;
	END IF;



	IF (cd_periodo_mensal_w <> cd_mes_atual_w) THEN
		SELECT	nextval('bsc_calculo_seq')
		INTO STRICT	nr_sequencia_mensal_w
		;

		INSERT INTO bsc_calculo(	NR_SEQUENCIA,
						DT_ATUALIZACAO,
						NM_USUARIO,
						DT_ATUALIZACAO_NREC,
						NM_USUARIO_NREC,
						DT_CALCULO,
						CD_PESSOA_FISICA,
						CD_ANO,
						CD_PERIODO,
						IE_PERIODO,
						CD_EMPRESA)
		VALUES (nr_sequencia_mensal_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			cd_pessoa_fisica_p,
			(TO_CHAR(clock_timestamp(),'yyyy'))::numeric ,
			cd_mes_atual_w,
			'M',
			1);
		COMMIT;
	END IF;
	
	IF (nr_sequencia_mensal_w > 0) THEN
		CALL bsc_gerar_result_indicador(1,NULL, nr_sequencia_mensal_w, NULL, NULL, nm_usuario_p);
	END IF;

	IF	ie_base_corp_w = 'S' AND (cd_ano_anual_w <> (TO_CHAR(clock_timestamp(),'yyyy'))::numeric )
		AND (cd_mes_atual_w = 1)  THEN 
		
		SELECT	nextval('bsc_calculo_seq')
		INTO STRICT	nr_sequencia_anual_w
		;

		INSERT INTO bsc_calculo(	NR_SEQUENCIA,
						DT_ATUALIZACAO,
						NM_USUARIO,
						DT_ATUALIZACAO_NREC,
						NM_USUARIO_NREC,
						DT_CALCULO,
						CD_PESSOA_FISICA,
						CD_ANO,
						CD_PERIODO,
						IE_PERIODO,
						CD_EMPRESA)
		VALUES (nr_sequencia_anual_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			cd_pessoa_fisica_p,
			(TO_CHAR(clock_timestamp(),'yyyy'))::numeric ,
			1,
			'A',
			1);
		COMMIT;
	END IF;
	
	IF (nr_sequencia_anual_w > 0) THEN
		CALL bsc_gerar_result_indicador(1,NULL, nr_sequencia_anual_w, NULL, NULL, nm_usuario_p);
	END IF;

	IF	ie_base_corp_w = 'S' AND ((cd_periodo_bimestral_w*2) <> cd_mes_atual_w)
		AND (MOD(cd_mes_atual_w,2) = 0) THEN 
		
		SELECT	nextval('bsc_calculo_seq')
		INTO STRICT	nr_sequencia_bimestral_w
		;
		
		cd_periodo_bimestral_w := cd_mes_atual_w/2;

		INSERT INTO bsc_calculo(	NR_SEQUENCIA,
						DT_ATUALIZACAO,
						NM_USUARIO,
						DT_ATUALIZACAO_NREC,
						NM_USUARIO_NREC,
						DT_CALCULO,
						CD_PESSOA_FISICA,
						CD_ANO,
						CD_PERIODO,
						IE_PERIODO,
						CD_EMPRESA)
		VALUES (nr_sequencia_bimestral_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			cd_pessoa_fisica_p,
			(TO_CHAR(clock_timestamp(),'yyyy'))::numeric ,
			cd_periodo_bimestral_w,
			'B',
			1);
		COMMIT;
	END IF;
	
	IF (nr_sequencia_bimestral_w > 0) THEN
		CALL bsc_gerar_result_indicador(1,NULL, nr_sequencia_bimestral_w, NULL, NULL, nm_usuario_p);
	END IF;

	IF	ie_base_corp_w = 'S' AND (cd_periodo_quadrim_w*4 <> cd_mes_atual_w)
		AND (MOD(cd_mes_atual_w,4) = 0) THEN 
		
		SELECT	nextval('bsc_calculo_seq')
		INTO STRICT	nr_sequencia_quadrim_w
		;
		
		cd_periodo_quadrim_w := cd_mes_atual_w/4;

		INSERT INTO bsc_calculo(	NR_SEQUENCIA,
						DT_ATUALIZACAO,
						NM_USUARIO,
						DT_ATUALIZACAO_NREC,
						NM_USUARIO_NREC,
						DT_CALCULO,
						CD_PESSOA_FISICA,
						CD_ANO,
						CD_PERIODO,
						IE_PERIODO,
						CD_EMPRESA)
		VALUES (nr_sequencia_quadrim_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			cd_pessoa_fisica_p,
			(TO_CHAR(clock_timestamp(),'yyyy'))::numeric ,
			cd_periodo_quadrim_w,
			'Q',
			1);
		COMMIT;
	END IF;
	
	IF (nr_sequencia_quadrim_w > 0) THEN
		CALL bsc_gerar_result_indicador(1,NULL, nr_sequencia_quadrim_w, NULL, NULL, nm_usuario_p);
	END IF;

	IF ie_base_corp_w = 'S' AND (cd_periodo_semestral_w*6 <> cd_mes_atual_w)
		AND (MOD(cd_mes_atual_w,6) = 0) THEN 
		
		SELECT	nextval('bsc_calculo_seq')
		INTO STRICT	nr_sequencia_semestral_w
		;
		
		cd_periodo_semestral_w := cd_mes_atual_w/6;

		INSERT INTO bsc_calculo(	NR_SEQUENCIA,
						DT_ATUALIZACAO,
						NM_USUARIO,
						DT_ATUALIZACAO_NREC,
						NM_USUARIO_NREC,
						DT_CALCULO,
						CD_PESSOA_FISICA,
						CD_ANO,
						CD_PERIODO,
						IE_PERIODO,
						CD_EMPRESA)
		VALUES (nr_sequencia_semestral_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			cd_pessoa_fisica_p,
			(TO_CHAR(clock_timestamp(),'yyyy'))::numeric ,
			cd_periodo_semestral_w,
			'S',
			1);
		COMMIT;
	END IF;
	
	IF (nr_sequencia_semestral_w > 0) THEN
		CALL bsc_gerar_result_indicador(1,NULL, nr_sequencia_semestral_w, NULL, NULL, nm_usuario_p);
	END IF;

	IF	ie_base_corp_w = 'S' AND (cd_periodo_trimestral_w*3 <> cd_mes_atual_w)
		AND (MOD(cd_mes_atual_w,3) = 0) THEN
		
		SELECT	nextval('bsc_calculo_seq')
		INTO STRICT	nr_sequencia_trimestral_w
		;
		
		cd_periodo_trimestral_w := cd_mes_atual_w/3;

		INSERT INTO bsc_calculo(	NR_SEQUENCIA,
						DT_ATUALIZACAO,
						NM_USUARIO,
						DT_ATUALIZACAO_NREC,
						NM_USUARIO_NREC,
						DT_CALCULO,
						CD_PESSOA_FISICA,
						CD_ANO,
						CD_PERIODO,
						IE_PERIODO,
						CD_EMPRESA)
		VALUES (nr_sequencia_trimestral_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			cd_pessoa_fisica_p,
			(TO_CHAR(clock_timestamp(),'yyyy'))::numeric ,
			cd_periodo_trimestral_w,
			'T',
			1);
		COMMIT;
	END IF;
	
	IF (nr_sequencia_trimestral_w > 0) THEN
		CALL bsc_gerar_result_indicador(1,NULL, nr_sequencia_trimestral_w, NULL, NULL, nm_usuario_p);
	END IF;
	
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_bsc_calculo ( nm_usuario_p text, cd_pessoa_fisica_p text) FROM PUBLIC;
