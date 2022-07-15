-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_encaixe_agenda_exame (cd_agenda_destino_p bigint, nr_seq_origem_p bigint, dt_encaixe_p timestamp, ie_encaixe_transf_p text, cd_estabelecimento_p bigint, nm_usuario_p text, hr_encaixe_p timestamp, cd_convenio_p bigint) AS $body$
DECLARE


qt_encaixe_w		bigint;
qt_encaixe_existe_w	bigint;
qt_permitida_regra_w	bigint;
dt_agenda_origem_w	timestamp;
ie_gerar_encaixe_hor_w	varchar(1);
qt_horario_w		integer;
ie_dia_semana_w		bigint;
hr_inicial_regra_w	timestamp;
hr_final_regra_w	timestamp;
qt_hor_per_w		bigint;
cd_tipo_Agenda_w	bigint;
nr_seq_regra_encaixe_w	bigint;
qt_se_existe_regra_agenda_w	bigint;
cd_perfil_regra_w	integer;
cd_convenio_regra_w	integer;
ds_retorno_w varchar(4000);


BEGIN

SELECT	coalesce(MAX(Obter_Valor_Param_Usuario(820,79, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p)),'N')
INTO STRICT	ie_gerar_encaixe_hor_w
;

SELECT	coalesce(MAX(qt_encaixe),0),
		MAX(cd_tipo_Agenda)
INTO STRICT	qt_encaixe_w,
		cd_tipo_Agenda_w
FROM	agenda
WHERE	cd_agenda = cd_agenda_destino_p;

SELECT	COUNT(*)
INTO STRICT	qt_horario_w
FROM	agenda_paciente
WHERE	cd_agenda = cd_agenda_destino_p
AND	TRUNC(dt_agenda,'dd') = TRUNC(dt_encaixe_p,'dd')
AND	TO_DATE(TO_CHAR(dt_encaixe_p,'dd/mm/yyyy') || ' ' || TO_CHAR(hr_encaixe_p,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss') = hr_inicio
AND	ie_status_agenda <> 'C';

IF (ie_gerar_encaixe_hor_w	= 'N' or ie_gerar_encaixe_hor_w	= 'A') AND (cd_tipo_Agenda_w	= 2) THEN
	SELECT	COUNT(*)
	INTO STRICT	qt_hor_per_w
	FROM	agenda_paciente
	WHERE	cd_agenda = cd_agenda_destino_p
	AND	TRUNC(dt_agenda,'dd') = TRUNC(dt_encaixe_p,'dd')
	AND	TO_DATE(TO_CHAR(dt_encaixe_p,'dd/mm/yyyy') || ' ' || TO_CHAR(hr_encaixe_p,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss')
		BETWEEN hr_inicio AND hr_inicio + (nr_minuto_duracao / 1440)
	AND	ie_status_agenda NOT IN ('C','L','B','LF');
	IF (qt_hor_per_w	> 0) THEN
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(251257);
	END IF;
END IF;

IF (qt_horario_w > 0) THEN
	IF (ie_gerar_encaixe_hor_w	 = 'N' or ie_gerar_encaixe_hor_w = 'H') THEN
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(251258);
	END IF;
END IF;

IF (qt_encaixe_w > 0) THEN
	SELECT	COUNT(*)
	INTO STRICT	qt_encaixe_existe_w
	FROM	agenda_paciente
	WHERE	ie_encaixe = 'S'
	AND	cd_agenda = cd_agenda_destino_p
	AND	TRUNC(dt_agenda) = TRUNC(dt_encaixe_p)
	AND	ie_status_agenda NOT IN ('C', 'F', 'I', 'II', 'B', 'R');

	IF (qt_encaixe_existe_w >= qt_encaixe_w) THEN
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(251259);
	END IF;
ELSE

	SELECT * FROM validar_regra_encaixe_agenda(cd_tipo_agenda_p => 2, dt_encaixe_p => dt_encaixe_p, hr_encaixe_p => hr_encaixe_p, dt_hr_encaixe_p => null, cd_agenda_p => cd_agenda_destino_p, cd_convenio_p => cd_convenio_p, ie_permite_p => ds_retorno_w, ds_erro_p => ds_retorno_w) INTO STRICT ie_permite_p => ds_retorno_w, ds_erro_p => ds_retorno_w;
END IF;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_encaixe_agenda_exame (cd_agenda_destino_p bigint, nr_seq_origem_p bigint, dt_encaixe_p timestamp, ie_encaixe_transf_p text, cd_estabelecimento_p bigint, nm_usuario_p text, hr_encaixe_p timestamp, cd_convenio_p bigint) FROM PUBLIC;

