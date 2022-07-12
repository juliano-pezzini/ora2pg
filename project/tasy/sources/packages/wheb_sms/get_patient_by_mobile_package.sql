-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION wheb_sms.get_patient_by_mobile (nr_celular_p text, ds_resp_p text, dt_resp_p timestamp) RETURNS SETOF PESSOA_FISICA_REC_TABLE AS $body$
DECLARE


	pessoa_fisica_temp_w		pessoa_fisica_item_row;

	qt_dias_confirmacao_w		ageint_texto_confirm_sms.qt_dias_confirmacao%type;
	nr_celular_w			varchar(50);
	nr_ddd_celular_w		varchar(50);
	nr_telefone_celular_w		varchar(50);
	nr_celular_new_w		varchar(50);
	ie_retorno_DDI_w		varchar(1);
	ie_consist_destinatario_w	varchar(1);
	cd_estab_agenda_w		bigint;
	ie_tipo_retorno_w		varchar(1);
	nr_records_w			integer := 0;
	dt_agenda_temp_w		timestamp;
	ie_load_schedule_info_w		varchar(1);

	c01 CURSOR FOR
	
		SELECT	distinct cd_pessoa_fisica,
			cd_estabelecimento
		FROM	pessoa_fisica a
		WHERE	coalesce(dt_obito::text, '') = ''
		AND	((a.nr_telefone_celular = to_char(nr_celular_w))
		OR (coalesce(nr_ddd_celular, nr_ddi_celular)    = nr_ddd_celular_w
			AND    nr_telefone_celular                 = nr_telefone_celular_w)
		OR (wheb_sms.translate_mobile(nr_telefone_celular) = wheb_sms.translate_mobile(nr_ddd_celular_w || nr_telefone_celular_w))
		OR (wheb_sms.translate_mobile(nr_telefone_celular) = wheb_sms.translate_mobile(nr_celular_w))
		OR (wheb_sms.translate_mobile(nr_ddi_celular || nr_telefone_celular) = wheb_sms.translate_mobile(nr_celular_w))
		);

	
  sch RECORD;

BEGIN

	cd_estab_agenda_w := coalesce(wheb_usuario_pck.get_cd_estabelecimento, coalesce(obter_estabelecimento_ativo,1));
	Obter_param_Usuario(821, 501, obter_perfil_ativo, obter_usuario_ativo, cd_estab_agenda_w, ie_retorno_DDI_w);
	Obter_Param_Usuario(0, 214, obter_perfil_ativo, obter_usuario_ativo, cd_estab_agenda_w, ie_consist_destinatario_w);
	Obter_Param_Usuario(866, 320, obter_perfil_ativo, obter_usuario_ativo, cd_estab_agenda_w, ie_load_schedule_info_w);

	SELECT	validate_sms_response_text(ds_resp_p)
	INTO STRICT	ie_tipo_retorno_w
	;

	SELECT	coalesce(MAX(qt_dias_confirmacao), 0)
	INTO STRICT	qt_dias_confirmacao_w
	FROM	ageint_texto_confirm_sms
	WHERE	ie_tipo_retorno			= ie_tipo_retorno_w
	AND	cd_estabelecimento		= coalesce(wheb_usuario_pck.get_cd_estabelecimento, 1);

	IF (qt_dias_confirmacao_w = 0)	THEN
		qt_dias_confirmacao_w	:= 30;
	ELSE
		qt_dias_confirmacao_w	:= qt_dias_confirmacao_w + 1;
	END IF;

	nr_celular_w			:= trim(both nr_celular_p);
	nr_celular_new_w		:= nr_celular_w;
	nr_ddd_celular_w		:= trim(both SUBSTR(nr_celular_w,3,2));
	nr_telefone_celular_w		:= trim(both SUBSTR(nr_celular_w,5,50));

	IF (coalesce(ie_retorno_DDI_w,'S')  = 'N')	THEN
		IF (SUBSTR(nr_celular_w,1,2) = '55')	THEN
			SELECT SUBSTR(nr_celular_p,3,12) INTO STRICT nr_celular_w;
		END IF;
		nr_ddd_celular_w      := trim(both SUBSTR(nr_celular_w,1,2));
		nr_telefone_celular_w := trim(both SUBSTR(nr_celular_w,3,50));
	ELSE
		IF (SUBSTR(nr_celular_w,1,2) <> '55')	THEN
			nr_celular_w               := '55'||nr_celular_p;
			nr_ddd_celular_w           := trim(both SUBSTR(nr_celular_w,3,2));
			nr_telefone_celular_w      := trim(both SUBSTR(nr_celular_w,5,50));
		END IF;
	END IF;
	IF (ie_consist_destinatario_w = 'I')	THEN
		nr_celular_w               := nr_celular_new_w;
	ELSE
		IF ((ie_consist_destinatario_w <> 'N') AND (SUBSTR(nr_celular_new_w,1,2) = '55') AND ( LENGTH(nr_celular_new_w) > 11)) THEN
			nr_celular_w                 := SUBSTR(nr_celular_new_w,3,LENGTH(nr_celular_new_w));
		ELSE
			BEGIN
				IF	(((SUBSTR(nr_celular_new_w,1,3)   = '055')
					OR (SUBSTR(nr_celular_new_w,1,3) = '+55')
					OR (SUBSTR(nr_celular_new_w,1,2) = '55'))
					AND (LENGTH(nr_celular_new_w) > 11))	THEN
					IF	((SUBSTR(nr_celular_new_w,1,3) = '055')
						OR (SUBSTR(nr_celular_new_w,1,3) = '+55'))	THEN
						nr_celular_w		:= SUBSTR(nr_celular_new_w, 4, LENGTH(nr_celular_new_w));
					ELSE
						nr_celular_w		:= SUBSTR(nr_celular_new_w, 3, LENGTH(nr_celular_new_w));
					END IF;
				END IF;
			END;
		END IF;
		nr_telefone_celular_w := trim(both SUBSTR(nr_celular_w,3,50));
	END IF;

	FOR rec IN c01
	LOOP

		nr_records_w := nr_records_w + 1;
		pessoa_fisica_temp_w.cd_pessoa_fisica := rec.cd_pessoa_fisica;
		pessoa_fisica_temp_w.cd_establishment := rec.cd_estabelecimento;

		IF (coalesce(ie_load_schedule_info_w, 'N') = 'S')	THEN
			FOR sch IN (SELECT	nr_sequencia_ai,
					nr_sequencia,
					cd_agenda,
					dt_agenda,
					ds_type
				FROM	find_schedules_v
				WHERE	cd_pessoa_fisica = rec.cd_pessoa_fisica
				AND	trunc(dt_agenda) <= trunc(clock_timestamp() + qt_dias_confirmacao_w)
				ORDER BY	dt_agenda)
			LOOP
				pessoa_fisica_temp_w.agenda_int_seq := sch.nr_sequencia_ai;
				pessoa_fisica_temp_w.agend_seq := sch.nr_sequencia;
				pessoa_fisica_temp_w.cd_agenda := sch.cd_agenda;
				pessoa_fisica_temp_w.dt_agenda := sch.dt_agenda;
				pessoa_fisica_temp_w.ds_type := sch.ds_type;

				IF (coalesce(dt_agenda_temp_w::text, '') = '')	THEN
					dt_agenda_temp_w := trunc(sch.dt_agenda);
				END IF;

				IF ((dt_agenda_temp_w IS NOT NULL AND dt_agenda_temp_w::text <> '') AND dt_agenda_temp_w = trunc(sch.dt_agenda))	THEN
					RETURN NEXT pessoa_fisica_temp_w;
				END IF;
			END LOOP;
		END IF;
	END LOOP;

	IF nr_records_w > 0 AND (coalesce(pessoa_fisica_temp_w.agend_seq, coalesce(pessoa_fisica_temp_w.agenda_int_seq, 0)) = 0) THEN
		IF nr_records_w > 1 THEN
			pessoa_fisica_temp_w.cd_pessoa_fisica := NULL;
		END IF;
		RETURN NEXT pessoa_fisica_temp_w;
	END IF;

	END;


$body$
LANGUAGE PLPGSQL
 STABLE;
-- REVOKE ALL ON FUNCTION wheb_sms.get_patient_by_mobile (nr_celular_p text, ds_resp_p text, dt_resp_p timestamp) FROM PUBLIC;
