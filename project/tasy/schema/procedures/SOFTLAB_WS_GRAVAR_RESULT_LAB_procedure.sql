-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE softlab_ws_gravar_result_lab ( nr_prescricao_p bigint, nr_seq_prescr_p INOUT bigint, cd_material_coleta_p text, cd_exame_p text, nm_responsavel_p text, ds_resultado_p text, ds_observacao_coleta_p text, ie_resultado_critico_p text, nm_usuario_p text ) AS $body$
DECLARE




nr_seq_prescr_w					bigint;
nr_seq_exame_origem_w 			bigint;
ie_exame_w						smallint;
nr_seq_exame_w					bigint;
nr_seq_superior_w				bigint;
ds_resultado_w					varchar(32767);

nr_sequencia_result_w			bigint;
nr_prescricao_result_w			bigint;
nr_seq_prescricao_result_w		integer;
nm_usuario_result_w				varchar(15);
dt_atualizacao_result_w			timestamp;
ie_cobranca_result_w			varchar(15);
ie_origem_proced_result_w		bigint;
cd_procedimento_result_w		bigint;
ds_resultado_result_w			text;
dt_coleta_result_w				timestamp;
ie_status_conversao_result_w	smallint;
ds_result_codigo_result_w		varchar(2000);
ie_formato_texto_result_w		smallint;
nr_seq_exame_result_w			bigint;
nr_seq_pagina_result_w			bigint;

ie_status_receb_w				lab_parametro.ie_status_receb%TYPE;
ie_status_atend_w				prescr_procedimento.ie_status_atend%TYPE;
cd_estabelecimento_w			estabelecimento.cd_estabelecimento%TYPE;
nr_seq_resultado_w				exame_lab_resultado.nr_seq_resultado%TYPE;
nr_seq_exame_proc_w				exame_laboratorio.nr_seq_exame%TYPE;
nr_seq_material_w				exame_lab_result_item.nr_seq_material%TYPE;
nr_seq_formato_w				exame_lab_result_item.nr_seq_formato%TYPE;
nr_seq_metodo_w					exame_lab_result_item.nr_seq_metodo%TYPE;

nr_seq_formato_red_w			bigint;

/*CURSOR C01 IS
	SELECT	1,
		nr_seq_exame,
		nr_seq_superior,
		NULL
	FROM	exame_laboratorio
	WHERE NVL(cd_exame_integracao, cd_exame) = cd_exame_p
	UNION
	SELECT	2,
		c.nr_seq_exame,
		a.nr_seq_exame,
		c.nr_seq_exame AS nr_seq_exame_origem
	FROM	exame_lab_format a,
		exame_lab_format_item b,
		exame_laboratorio c
	WHERE	a.nr_seq_formato	= b.nr_seq_formato
	  AND	b.nr_seq_exame		= c.nr_seq_exame
	  AND	NVL(c.cd_exame_integracao, c.cd_exame) = cd_exame_p
	UNION
	SELECT	3,
		nr_seq_exame,
		nr_seq_superior,
		NULL
	FROM	exame_laboratorio
	WHERE NVL(cd_exame_integracao, cd_exame) = REPLACE(cd_exame_p, 'URG', '')
	UNION
	SELECT	4,
		c.nr_seq_exame,
		a.nr_seq_exame,
		c.nr_seq_exame AS nr_seq_exame_origem
	FROM	exame_lab_format a,
		exame_lab_format_item b,
		exame_laboratorio c
	WHERE	a.nr_seq_formato	= b.nr_seq_formato
	  AND	b.nr_seq_exame		= c.nr_seq_exame
	  AND	NVL(c.cd_exame_integracao, c.cd_exame) = REPLACE(cd_exame_p, 'URG', '')
	UNION
	SELECT	5,
		e.nr_seq_exame,
		e.nr_seq_superior,
		NULL
	FROM	exame_laboratorio e
	WHERE	e.nr_seq_exame 	= obter_equip_exame_integracao(cd_exame_p,'SOFTLABWS',1) --Tratamento utilizado pelo samaritano / fleury
	ORDER BY 1, 2;*/
c02 CURSOR FOR
 	SELECT	NR_SEQUENCIA,
			NR_PRESCRICAO,
			NR_SEQ_PRESCRICAO,
			NM_USUARIO,
			DT_ATUALIZACAO,
			IE_COBRANCA,
			IE_ORIGEM_PROCED,
			CD_PROCEDIMENTO,
			DS_RESULTADO,
			DT_COLETA,
			IE_STATUS_CONVERSAO,
			DS_RESULT_CODIGO,
			IE_FORMATO_TEXTO,
			NR_SEQ_EXAME,
			NR_SEQ_PAGINA
 	FROM	result_laboratorio
 	WHERE	nr_prescricao = nr_prescricao_p
	AND		nr_seq_prescricao = nr_seq_prescr_w;


BEGIN

nr_seq_prescr_w   := nr_seq_prescr_p;

SELECT	MAX(a.cd_estabelecimento)
INTO STRICT	cd_estabelecimento_w
FROM	prescr_medica a
WHERE	a.nr_prescricao = nr_prescricao_p;

SELECT	MAX(a.ie_status_receb)
INTO STRICT	ie_status_receb_w
FROM	lab_parametro a
WHERE	a.cd_estabelecimento = cd_estabelecimento_w;

SELECT	MAX(a.nr_seq_resultado)
INTO STRICT	nr_seq_resultado_w
FROM	exame_lab_resultado a
WHERE	a.nr_prescricao = nr_prescricao_p;

/*IF	(nr_seq_prescr_w IS NULL) AND
	(cd_exame_p IS NOT NULL) THEN
	OPEN C01;
	LOOP
	FETCH C01 INTO	ie_exame_w,
			nr_seq_exame_w,
			nr_seq_superior_w,
			nr_seq_exame_origem_w;
		EXIT WHEN C01%NOTFOUND;
		insert into andrey(ds) values('1');

		SELECT	MIN(NVL(nr_sequencia, NULL))
		INTO	nr_seq_prescr_w
		FROM	prescr_procedimento
		WHERE 	nr_prescricao		= trim(nr_prescricao_p)
		  AND 	nr_seq_exame		= nr_seq_exame_w
		  AND	cd_material_exame	= cd_material_coleta_p;

		IF	(nr_seq_superior_w IS NOT NULL) AND
			(nr_seq_prescr_w IS NULL) THEN


			SELECT	MAX(NVL(nr_sequencia, NULL))
			INTO	nr_seq_prescr_w
			FROM	prescr_procedimento
			WHERE	nr_prescricao = trim(nr_prescricao_p)
			AND		ie_status_atend >= 30
			AND		nr_seq_exame = nr_seq_superior_w
			AND		cd_material_exame = cd_material_coleta_p;

			IF	(nr_seq_prescr_w IS NULL) THEN

				SELECT	MAX(NVL(nr_sequencia, NULL))
				INTO	nr_seq_prescr_w
				FROM	prescr_procedimento
				WHERE	nr_prescricao = trim(nr_prescricao_p)
				AND		nr_seq_exame = nr_seq_superior_w
				AND		cd_material_exame = cd_material_coleta_p;

			END IF;

			nr_seq_exame_w	:= nr_seq_superior_w;

		END IF;

		IF	(nr_seq_prescr_w IS NOT NULL) THEN
			EXIT;
		END IF;

	END LOOP;
	CLOSE C01;

END IF;*/
--insert into andrey(ds) values('NR_SEQ_EXAME=' || TO_CHAR(NVL(nr_seq_exame_origem_w,nr_seq_exame_w)) || ';' || ds_resultado_p);
ds_resultado_w	:= 'NR_SEQ_EXAME=' || TO_CHAR(coalesce(nr_seq_exame_origem_w,nr_seq_exame_w)) || ';' || ds_resultado_p;
--nr_seq_prescr_p	:= nr_seq_prescr_w;
OPEN C02;
LOOP
FETCH C02 INTO
		nr_sequencia_result_w,
		nr_prescricao_result_w,
		nr_seq_prescricao_result_w,
		nm_usuario_result_w,
		dt_atualizacao_result_w,
		ie_cobranca_result_w,
		ie_origem_proced_result_w,
		cd_procedimento_result_w,
		ds_resultado_result_w,
		dt_coleta_result_w,
		ie_status_conversao_result_w,
		ds_result_codigo_result_w,
		ie_formato_texto_result_w,
		nr_seq_exame_result_w,
		nr_seq_pagina_result_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
	BEGIN

	INSERT INTO result_laboratorio_copia(	NR_SEQUENCIA,
						NR_PRESCRICAO,
						NR_SEQ_PRESCRICAO,
						NM_USUARIO,
						DT_ATUALIZACAO,
						IE_COBRANCA,
						IE_ORIGEM_PROCED,
						CD_PROCEDIMENTO,
						DS_RESULTADO,
						IE_FORMATO_TEXTO,
						DT_COLETA,
						NR_SEQ_RESULT_ANT,
						IE_STATUS_CONVERSAO,
						DS_RESULT_CODIGO,
						NR_SEQ_PAGINA,
						NR_SEQ_EXAME,
						DT_DESAPROVACAO)
	VALUES (				nextval('result_laboratorio_copia_seq'),
						nr_prescricao_result_w,
						nr_seq_prescricao_result_w,
						nm_usuario_p,
						clock_timestamp(),
						ie_cobranca_result_w,
						ie_origem_proced_result_w,
						cd_procedimento_result_w,
						ds_resultado_result_w,
						ie_formato_texto_result_w,
						dt_coleta_result_w,
						nr_sequencia_result_w,
						ie_status_conversao_result_w,
						ds_result_codigo_result_w,
						nr_seq_pagina_result_w,
						nr_seq_exame_result_w,
						clock_timestamp());

	delete	FROM result_laboratorio
	where	nr_sequencia = nr_sequencia_result_w;

	END;
END LOOP;
CLOSE C02;

UPDATE 	prescr_procedimento
SET		ie_status_atend = obter_valor_menor(ie_status_receb_w, 30),
		cd_motivo_baixa = 0,
		ds_observacao_coleta = ds_observacao_coleta_p,
		nm_usuario  = nm_usuario_p
WHERE 	nr_prescricao = nr_prescricao_p
  AND 	nr_sequencia  = nr_seq_prescr_w;

UPDATE	exame_lab_result_item
SET		dt_aprovacao  = NULL
WHERE	nr_seq_resultado = nr_seq_resultado_w
and		nr_seq_prescr  = nr_seq_prescr_w
AND		(nr_seq_material IS NOT NULL AND nr_seq_material::text <> '');

CALL Gravar_Result_Laboratorio(   nr_prescricao_p,  	nr_seq_prescr_w,
                             ds_resultado_w,	nm_usuario_p);

UPDATE 	result_laboratorio
SET		ie_resultado_critico = ie_resultado_critico_p
WHERE	nr_prescricao = nr_prescricao_p
AND 	nr_seq_prescricao = nr_seq_prescr_w;

SELECT	MAX(a.nr_seq_exame)
INTO STRICT	nr_seq_exame_proc_w
FROM 	prescr_procedimento a
WHERE 	a.nr_prescricao = nr_prescricao_p
AND 	a.nr_sequencia  = nr_seq_prescr_w;

SELECT	MAX(nr_seq_material),
		MAX(nr_seq_formato),
		MAX(nr_seq_metodo)
INTO STRICT	nr_seq_material_w,
		nr_seq_formato_w,
		nr_seq_metodo_w
FROM	exame_lab_result_item
WHERE	nr_seq_prescr  = nr_seq_prescr_w
AND		nr_seq_resultado = nr_seq_resultado_w
AND		(nr_seq_material IS NOT NULL AND nr_seq_material::text <> '');


IF (coalesce(nr_seq_formato_w,0) = 0) THEN

	SELECT	coalesce(MAX(obter_formato_exame(nr_seq_exame_proc_w, nr_seq_material_w, nr_seq_metodo_w, 'L')),0),
			coalesce(MAX(obter_formato_exame(nr_seq_exame_proc_w, nr_seq_material_w, nr_seq_metodo_w, 'R')),0)
	INTO STRICT	nr_seq_formato_w,
			nr_seq_formato_red_w
	;

	UPDATE 	exame_lab_result_item
	SET		nr_seq_formato = nr_seq_formato_w,
			nr_seq_formato_red = nr_seq_formato_red_w
	WHERE	nr_seq_resultado = nr_seq_resultado_w
	AND		nr_seq_prescr = nr_seq_prescr_w
	AND		(nr_seq_material IS NOT NULL AND nr_seq_material::text <> '');

END IF;

UPDATE 	prescr_procedimento
SET		ie_status_atend = coalesce(ie_status_receb_w, 30)
WHERE 	nr_prescricao = nr_prescricao_p
  AND 	nr_sequencia  = nr_seq_prescr_w;

if (coalesce(ie_resultado_critico_p,'N') = 'S') then

	UPDATE 	prescr_procedimento
	SET		DS_OBSERVACAO_COLETA = substr(obter_texto_tasy(763957, wheb_usuario_pck.get_nr_seq_idioma)||' '||DS_OBSERVACAO_COLETA,1,255)
	WHERE 	nr_prescricao = nr_prescricao_p
	AND 	nr_sequencia  = nr_seq_prescr_w;

end if;

SELECT	MAX(a.ie_status_atend)
INTO STRICT	ie_status_atend_w
FROM	prescr_procedimento a
WHERE 	a.nr_prescricao = nr_prescricao_p
  AND 	a.nr_sequencia  = nr_seq_prescr_w;

IF (ie_status_atend_w >= 35) THEN

	UPDATE	exame_lab_result_item
	SET		dt_aprovacao = clock_timestamp()
	WHERE	nr_seq_resultado = nr_seq_resultado_w
	and		nr_seq_prescr  = nr_seq_prescr_w
	AND		(nr_seq_material IS NOT NULL AND nr_seq_material::text <> '');

END IF;

COMMIT;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE softlab_ws_gravar_result_lab ( nr_prescricao_p bigint, nr_seq_prescr_p INOUT bigint, cd_material_coleta_p text, cd_exame_p text, nm_responsavel_p text, ds_resultado_p text, ds_observacao_coleta_p text, ie_resultado_critico_p text, nm_usuario_p text ) FROM PUBLIC;
