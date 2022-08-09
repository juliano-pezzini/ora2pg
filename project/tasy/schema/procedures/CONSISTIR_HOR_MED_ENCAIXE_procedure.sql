-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_hor_med_encaixe ( cd_medico_p text, nr_minuto_duracao_p bigint, dt_agenda_p timestamp, cd_agenda_p bigint, ds_erro_p INOUT text) AS $body$
DECLARE

									

dt_inicial_w		timestamp;
dt_final_w		timestamp;
nr_seq_agenda_w		                agenda_paciente.nr_sequencia%type;
nm_paciente_w		varchar(60);
ds_agenda_w		varchar(50);
dt_agenda_w		timestamp;
nm_medico_w		varchar(60);
cd_agenda_w		bigint;
cd_estabelecimento_w	integer;
ie_forma_cons_hor_medic_w	varchar(1);
cd_pessoa_fisica_w	varchar(10);
ie_somente_cirur_w		varchar(1);
cd_tipo_agenda_w		bigint;
ie_consiste_prof_cirurgia_w	varchar(1);
ie_medico_disp_w			varchar(15);









BEGIN

ie_somente_cirur_w := obter_param_usuario(871, 266, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_somente_cirur_w);

ie_medico_disp_w := obter_se_medico_disp_encaixe(dt_agenda_p, cd_medico_p, ie_medico_disp_w);
if (coalesce(ie_medico_disp_w,'S') = 'N') then
	CALL exibir_erro_abortar(Wheb_mensagem_pck.get_texto(282267),null);
end if;	

cd_pessoa_fisica_w 	:= cd_medico_p;
dt_inicial_w		:= dt_agenda_p;	
dt_final_w		:= dt_agenda_p + (nr_minuto_duracao_p / 1440) - (1/86400);
cd_agenda_w		:= cd_agenda_p;
	
SELECT	MAX(cd_estabelecimento)
INTO STRICT	cd_estabelecimento_w
FROM	agenda
WHERE	cd_agenda = cd_agenda_w;

SELECT	coalesce(max(ie_forma_cons_hor_medic),'R'),
		coalesce(max(ie_consiste_prof_cirur),'N')
INTO STRICT	ie_forma_cons_hor_medic_w,
		ie_consiste_prof_cirurgia_w
FROM	parametro_agenda
WHERE	cd_estabelecimento = cd_estabelecimento_w;

if (ie_forma_cons_hor_medic_w = 'R') then
	begin	
	
	SELECT	coalesce(MAX(nr_sequencia),0)
	INTO STRICT	nr_seq_agenda_w
	FROM	agenda_paciente
	WHERE	(
			(hr_inicio BETWEEN dt_inicial_w AND dt_final_w)
				OR	(hr_inicio + (nr_minuto_duracao / 1440) - (1/86400) BETWEEN dt_inicial_w AND dt_final_w)
				OR	((hr_inicio < dt_inicial_w) AND (hr_inicio + (nr_minuto_duracao / 1440) - (1/86400) > dt_final_w))
			)	
	and 	((coalesce(cd_medico_exec, cd_medico) = cd_pessoa_fisica_w)
	or		cd_anestesista = cd_pessoa_fisica_w)
	AND		ie_status_agenda NOT IN ('C','L','B','II');
		exception
		when SQLSTATE '50004' then
			null;
		when SQLSTATE '50002' then
			--Formato de data invalido (ORA-01830). Favor verificar com o setor de TI as configuracoes de idiomas da maquina/servidor e do banco de dados Oracle (parametro NLS_DATE_FORMAT=dd.mm.yyyy hh24:mi:ss e NLS_LANG=BRAZILIAN PORTUGUESE_BRAZIL.WE8ISO8859P1.
			CALL Wheb_mensagem_pck.exibir_mensagem_abort(232641);
		when SQLSTATE '50003' then
			--Formato de data invalido (ORA-01861). Favor verificar com o setor de TI as configuracoes de idiomas da maquina/servidor e do banco de dados Oracle (parametro NLS_DATE_FORMAT=dd.mm.yyyy hh24:mi:ss e NLS_LANG=BRAZILIAN PORTUGUESE_BRAZIL.WE8ISO8859P1.
			CALL Wheb_mensagem_pck.exibir_mensagem_abort(232642);
	
	end;				
else
	nr_seq_agenda_w := 0;	
end if;

if (nr_seq_agenda_w = 0) then
	
	if (ie_forma_cons_hor_medic_w = 'E') then
		
		SELECT	coalesce(MAX(nr_sequencia),0)
		INTO STRICT	nr_seq_agenda_w
		FROM	agenda_paciente
		WHERE	(
				(hr_inicio BETWEEN dt_inicial_w AND dt_final_w)
					OR (hr_inicio + (nr_minuto_duracao / 1440) - (1/86400) BETWEEN dt_inicial_w AND dt_final_w)
					OR	((hr_inicio < dt_inicial_w) AND (hr_inicio + (nr_minuto_duracao / 1440) - (1/86400) > dt_final_w))
				)
		AND		cd_medico_exec	= cd_pessoa_fisica_w
		AND		ie_status_agenda NOT IN ('C','L','B','II');
	else
		nr_seq_agenda_w := 0;
	end if;
	
	if (nr_seq_agenda_w = 0) and (ie_consiste_prof_cirurgia_w = 'S') then
		begin
		if (ie_forma_cons_hor_medic_w in ('E', 'R')) then
			begin
			
			SELECT	coalesce(MAX(a.nr_sequencia),0)
			INTO STRICT	nr_seq_agenda_w
			FROM	agenda_paciente a,
					profissional_agenda b
			WHERE	a.nr_sequencia = b.nr_seq_agenda
			and		(
					(a.hr_inicio BETWEEN dt_inicial_w AND dt_final_w)
						OR (a.hr_inicio + (nr_minuto_duracao / 1440) - (1/86400) BETWEEN dt_inicial_w AND dt_final_w)
						OR ((a.hr_inicio < dt_inicial_w) AND (a.hr_inicio + (a.nr_minuto_duracao / 1440) - (1/86400) > dt_final_w))
					)
			AND		b.cd_profissional	= cd_pessoa_fisica_w
			AND		a.ie_status_agenda NOT IN ('C','L','B','II');			
				exception
				when SQLSTATE '50004' then
					null;
				when SQLSTATE '50002' then
					--Formato de data invalido (ORA-01830). Favor verificar com o setor de TI as configuracoes de idiomas da maquina/servidor e do banco de dados Oracle (parametro NLS_DATE_FORMAT=dd.mm.yyyy hh24:mi:ss e NLS_LANG=BRAZILIAN PORTUGUESE_BRAZIL.WE8ISO8859P1.
					CALL Wheb_mensagem_pck.exibir_mensagem_abort(232641);
				when SQLSTATE '50003' then
					--Formato de data invalido (ORA-01861). Favor verificar com o setor de TI as configuracoes de idiomas da maquina/servidor e do banco de dados Oracle (parametro NLS_DATE_FORMAT=dd.mm.yyyy hh24:mi:ss e NLS_LANG=BRAZILIAN PORTUGUESE_BRAZIL.WE8ISO8859P1.
					CALL Wheb_mensagem_pck.exibir_mensagem_abort(232642);		
			end;			
		else
			nr_seq_agenda_w := 0;
		end if;
		end;
	end if;
end if;

IF (nr_seq_agenda_w > 0) THEN
	BEGIN

	SELECT SUBSTR(obter_nome_pf(cd_pessoa_fisica_w),1,60)
	INTO STRICT nm_medico_w 
	;
	
	SELECT	SUBSTR(coalesce(obter_nome_pf(cd_pessoa_fisica),nm_paciente),1,60),
			hr_inicio,
			SUBSTR(obter_nome_agenda(cd_agenda),1,50),
			obter_tipo_agenda(cd_agenda)
	INTO STRICT	nm_paciente_w,
			dt_agenda_w,
			ds_agenda_w,
			cd_tipo_agenda_w
	FROM	agenda_paciente
	WHERE	nr_sequencia	= nr_seq_agenda_w;
		EXCEPTION
		WHEN OTHERS THEN
			nm_medico_w := NULL;
	END;

	if (ie_somente_cirur_w = 'S') and (cd_tipo_agenda_w <> 1) then
		nm_medico_w := null;
	end if;
	
	IF (nm_medico_w IS NOT NULL AND nm_medico_w::text <> '') THEN
		ds_erro_p := wheb_mensagem_pck.get_texto(376326, 'NM_MEDICO_P=' || nm_medico_w ||
						';NM_PACIENTE_P=' || nm_paciente_w ||
						';DT_AGENDA_P=' ||  TO_CHAR(dt_agenda_w,'dd/mm/yyyy hh24:mi') ||
						';DS_AGENDA_P=' || ds_agenda_w);
	END IF;
ELSE
	begin
		if (ie_forma_cons_hor_medic_w IN ('E','R')) then
			begin
			
			SELECT	coalesce(MAX(nr_sequencia),0)
			INTO STRICT	nr_seq_agenda_w
			FROM	agenda b,
					agenda_consulta a
			WHERE	a.cd_agenda = b.cd_agenda
			and		(
					(dt_agenda BETWEEN dt_inicial_w AND dt_final_w)
						OR	(dt_agenda + (nr_minuto_duracao / 1440) - (1/86400) BETWEEN dt_inicial_w AND dt_final_w)
						OR	((dt_agenda < dt_inicial_w) AND (dt_agenda + (nr_minuto_duracao / 1440) - (1/86400) > dt_final_w))
					)
			AND		B.cd_pessoa_FISica	= cd_pessoa_fisica_w
			AND		ie_status_agenda NOT IN ('C','L','B','II')		
			and		coalesce(ie_somente_cirur_w,'N') = 'N';
				exception
				when SQLSTATE '50004' then
					null;
				when SQLSTATE '50002' then
					--Formato de data invalido (ORA-01830). Favor verificar com o setor de TI as configuracoes de idiomas da maquina/servidor e do banco de dados Oracle (parametro NLS_DATE_FORMAT=dd.mm.yyyy hh24:mi:ss e NLS_LANG=BRAZILIAN PORTUGUESE_BRAZIL.WE8ISO8859P1.
					CALL Wheb_mensagem_pck.exibir_mensagem_abort(232641);
				when SQLSTATE '50003' then
					--Formato de data invalido (ORA-01861). Favor verificar com o setor de TI as configuracoes de idiomas da maquina/servidor e do banco de dados Oracle (parametro NLS_DATE_FORMAT=dd.mm.yyyy hh24:mi:ss e NLS_LANG=BRAZILIAN PORTUGUESE_BRAZIL.WE8ISO8859P1.
					CALL Wheb_mensagem_pck.exibir_mensagem_abort(232642);
			end;
		else
			nr_seq_agenda_w := 0;
		end if;

		IF (nr_seq_agenda_w > 0) THEN
			BEGIN
			
			SELECT SUBSTR(obter_nome_pf(cd_pessoa_fisica_w),1,60)
			INTO STRICT nm_medico_w 
			;
			
			SELECT	SUBSTR(obter_nome_pf(a.cd_pessoa_fisica),1,60),
					dt_agenda,
					SUBSTR(obter_nome_agenda(b.cd_agenda),1,50)
			INTO STRICT	nm_paciente_w,
					dt_agenda_w,
					ds_agenda_w
			FROM	agenda b,
					agenda_consulta a				
			WHERE	a.cd_agenda 	= b.cd_agenda
			and		nr_sequencia	= nr_seq_agenda_w;
				EXCEPTION
				WHEN OTHERS THEN
					nm_medico_w := NULL;
			END;

			IF (nm_medico_w IS NOT NULL AND nm_medico_w::text <> '') THEN
				ds_erro_p := wheb_mensagem_pck.get_texto(376326, 'NM_MEDICO_P=' || nm_medico_w ||
						';NM_PACIENTE_P=' || nm_paciente_w ||
						';DT_AGENDA_P=' ||  TO_CHAR(dt_agenda_w,'dd/mm/yyyy hh24:mi') ||
						';DS_AGENDA_P=' || ds_agenda_w);
			END IF;
			
		END IF;
	end;
END IF;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_hor_med_encaixe ( cd_medico_p text, nr_minuto_duracao_p bigint, dt_agenda_p timestamp, cd_agenda_p bigint, ds_erro_p INOUT text) FROM PUBLIC;
