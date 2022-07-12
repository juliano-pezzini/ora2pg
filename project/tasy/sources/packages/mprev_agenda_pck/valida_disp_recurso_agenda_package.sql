-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


	/*---------------------------------------------------------------------------------------------------------------------------------------------
	|			VALIDA_DISP_RECURSO_AGENDA				|
	*/
	/* Vai validar se o recurso esta disponivel para o horario do agendamento*/

CREATE OR REPLACE PROCEDURE mprev_agenda_pck.valida_disp_recurso_agenda (dados_agenda_p dados_agendamento, nm_usuario_p text) AS $body$
DECLARE


	cd_agenda_w		mprev_agendamento.cd_agenda%type;
	ds_recurso_w		varchar(255);
	ds_recurso_retorno_w	varchar(4000);
	ds_cd_agenda_retorno_w	varchar(4000);
	ie_mensagem_w		bigint := 1;

	C01 CURSOR FOR
		SELECT	b.nr_seq_recurso
		from	w_mprev_agendamento a,
			w_mprev_agendamento_rec b
		where	a.nr_sequencia = b.nr_seq_w_agendamento
		and	a.nr_sequencia = dados_agenda_p.nr_seq_w_agendamento
		and	b.ie_tipo_recurso <> 'G'
		order by b.nr_seq_recurso;

	
BEGIN

	for r_C01 in C01 loop
		begin
			select	mprev_obter_ds_recurso(b.nr_seq_recurso) ds_recurso,
				a.cd_agenda
			into STRICT	ds_recurso_w,
				cd_agenda_w
			from	mprev_agendamento a,
				mprev_agendamento_recurso b
			where	a.nr_sequencia = b.nr_seq_agendamento
			and	b.nr_seq_recurso = r_C01.nr_seq_recurso
			and	((dados_agenda_p.dt_final_agendamento - (60/86400)  between a.dt_agenda and  (a.dt_agenda + (a.nr_minuto_duracao * (1/24/60)))- (60/86400) )  --decrementa 1 minuto
			or	(dados_agenda_p.dt_agendamento between a.dt_agenda and (a.dt_agenda + (a.nr_minuto_duracao * (1/24/60)))- (60/86400) ))
			and	a.ie_status_agenda <> 'C'
			and	a.ie_status_agenda <> 'E'
			and	a.cd_agenda <> dados_agenda_p.cd_agenda  LIMIT 1;

			if (ds_recurso_w IS NOT NULL AND ds_recurso_w::text <> '') then
				if (coalesce(ds_recurso_retorno_w::text, '') = '') then
					ds_recurso_retorno_w := ds_recurso_w;
				else
					ds_recurso_retorno_w := ds_recurso_retorno_w ||', '|| ds_recurso_w;
					ie_mensagem_w := 2;
				end if;
			end if;

			if (cd_agenda_w IS NOT NULL AND cd_agenda_w::text <> '') then
				if (coalesce(ds_cd_agenda_retorno_w::text, '') = '') then
					ds_cd_agenda_retorno_w := cd_agenda_w;
				else
					ds_cd_agenda_retorno_w := ds_cd_agenda_retorno_w ||', '|| cd_agenda_w;
					ie_mensagem_w := 2;
				end if;
			end if;

		exception
			when others then
			cd_agenda_w	:= null;
			ds_recurso_w	:= null;
		end;
	end loop;

	if (ds_recurso_retorno_w IS NOT NULL AND ds_recurso_retorno_w::text <> '') and (ds_cd_agenda_retorno_w IS NOT NULL AND ds_cd_agenda_retorno_w::text <> '') then
		if (ie_mensagem_w = 1) then
		--O recurso #@DS_RECURSO#@ ja esta agendado na agenda #@CD_AGENDA#@ no mesmo dia e horario desse agendamento.
		CALL CALL CALL mprev_agenda_pck.gravar_inconsistencia(	dados_agenda_p,
					353249,
					'DS_RECURSO='||	ds_recurso_retorno_w || ';CD_AGENDA='||	ds_cd_agenda_retorno_w,
					'E',
					'9',
					null,
					nm_usuario_p);
		else
		--Os recursos (#@DS_RECURSO#@) ja estao agendados nas agendas (#@CD_AGENDA#@) no mesmo dia e horario desse agendamento.
		CALL CALL CALL mprev_agenda_pck.gravar_inconsistencia(	dados_agenda_p,
					353270,
					'DS_RECURSO='||	ds_recurso_retorno_w ||';CD_AGENDA='||	ds_cd_agenda_retorno_w,
					'E',
					'9',
					null,
					nm_usuario_p);
		end if;
	end if;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE mprev_agenda_pck.valida_disp_recurso_agenda (dados_agenda_p dados_agendamento, nm_usuario_p text) FROM PUBLIC;
