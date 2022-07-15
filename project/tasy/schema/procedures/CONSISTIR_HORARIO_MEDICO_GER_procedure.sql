-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_horario_medico_ger ( nr_seq_agenda_p bigint, cd_medico_p text, nr_minuto_duracao_p bigint, hr_inicio_p timestamp, cd_agenda_p bigint, ds_erro_p INOUT text) AS $body$
DECLARE


dt_inicial_w			timestamp;
dt_final_w			timestamp;
nr_seq_agenda_w			agenda_paciente.nr_sequencia%type;
nm_paciente_w			varchar(60);
ds_agenda_w			varchar(50);
dt_agenda_w			timestamp;
nm_medico_w			varchar(60);
cd_agenda_w			bigint;
cd_estabelecimento_w		integer;
ie_forma_cons_hor_medic_w	varchar(1);
ie_gerar_hor_bloq_med_w		varchar(1);
cd_pessoa_fisica_w		varchar(10);

BEGIN

dt_inicial_w	:= hr_inicio_p;
dt_final_w	:= hr_inicio_p + (nr_minuto_duracao_p / 1440) - (1/86400);
cd_agenda_w	:= cd_agenda_p;
cd_pessoa_fisica_w := cd_medico_p;


SELECT	MAX(cd_estabelecimento),
	max(ie_gerar_hor_bloq_med)
INTO STRICT	cd_estabelecimento_w,
	ie_gerar_hor_bloq_med_w
FROM	agenda a	
WHERE	cd_agenda = cd_agenda_w;

SELECT	coalesce(MAX(ie_forma_cons_hor_medic),'R')
INTO STRICT	ie_forma_cons_hor_medic_w
FROM	parametro_agenda
WHERE	cd_estabelecimento = cd_estabelecimento_w;

if (ie_gerar_hor_bloq_med_w = 'S') then

	SELECT	coalesce(MAX(nr_sequencia),0)
	INTO STRICT	nr_seq_agenda_w
	FROM	agenda_paciente
	WHERE	((hr_inicio BETWEEN dt_inicial_w AND dt_final_w) OR
		(hr_inicio + (nr_minuto_duracao / 1440) - (1/86400) BETWEEN dt_inicial_w AND dt_final_w) OR
		((hr_inicio < dt_inicial_w) AND (hr_inicio + (nr_minuto_duracao / 1440) - (1/86400) > dt_final_w)))
	--AND	NVL(cd_medico_exec,cd_medico)	= cd_pessoa_fisica_w
	and (coalesce(cd_medico_exec, cd_medico) = cd_pessoa_fisica_w)
	AND	nr_sequencia	<> nr_seq_agenda_p
	AND	ie_status_agenda NOT IN ('C','L','B')
	AND	ie_forma_cons_hor_medic_w = 'R';

	if (nr_seq_agenda_w = 0) then
		SELECT	coalesce(MAX(nr_sequencia),0)
		INTO STRICT	nr_seq_agenda_w
		FROM	agenda_paciente
		WHERE	((hr_inicio BETWEEN dt_inicial_w AND dt_final_w) OR
			(hr_inicio + (nr_minuto_duracao / 1440) - (1/86400) BETWEEN dt_inicial_w AND dt_final_w) OR
			((hr_inicio < dt_inicial_w) AND (hr_inicio + (nr_minuto_duracao / 1440) - (1/86400) > dt_final_w)))
		AND	cd_medico_exec	= cd_pessoa_fisica_w		
		AND	ie_status_agenda NOT IN ('C','L','B')
		AND	ie_forma_cons_hor_medic_w = 'E';
	end if;
	
	IF (nr_seq_agenda_w > 0) THEN
		BEGIN
		SELECT	SUBSTR(obter_nome_pf(cd_pessoa_fisica),1,60),
			hr_inicio,
			SUBSTR(obter_nome_agenda(cd_agenda),1,50),
			SUBSTR(obter_nome_pf(coalesce(cd_medico_exec,cd_medico)),1,60)
		INTO STRICT	nm_paciente_w,
			dt_agenda_w,
			ds_agenda_w,
			nm_medico_w
		FROM	agenda_paciente
		WHERE	nr_sequencia	= nr_seq_agenda_w;
		EXCEPTION
		WHEN OTHERS THEN
			nm_medico_w := NULL;
		END;

		IF (nm_medico_w IS NOT NULL AND nm_medico_w::text <> '') THEN
			ds_erro_p := wheb_mensagem_pck.get_texto(279029, 'NM_MEDICO_P=' || nm_medico_w ||
									';PACIENTE_P=' || nm_paciente_w ||
									';DT_AGENDA_P=' || TO_CHAR(dt_agenda_w,'dd/mm/yyyy hh24:mi') ||
									';DS_AGENDA_P=' || ds_agenda_w);
		END IF;	
	END IF;
end if;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_horario_medico_ger ( nr_seq_agenda_p bigint, cd_medico_p text, nr_minuto_duracao_p bigint, hr_inicio_p timestamp, cd_agenda_p bigint, ds_erro_p INOUT text) FROM PUBLIC;

