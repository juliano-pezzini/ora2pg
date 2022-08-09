-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE adep_atualiza_prim_checagem ( nr_seq_horario_p adep_processo.nr_seq_horario%type, nr_seq_processo_p adep_processo.nr_sequencia%type ) AS $body$
DECLARE


ie_status_w varchar(1);
dt_prim_checagem_hor_w prescr_mat_hor.dt_primeira_checagem%type;


BEGIN

if (nr_seq_horario_p IS NOT NULL AND nr_seq_horario_p::text <> '' AND nr_seq_processo_p IS NOT NULL AND nr_seq_processo_p::text <> '') then
	begin
	select 	obter_status_prim_check(c.dt_primeira_checagem,c.dt_fim_horario,c.dt_suspensao,c.dt_recusa),
			c.dt_primeira_checagem
	into STRICT	ie_status_w,
			dt_prim_checagem_hor_w
	from 	prescr_mat_hor c
	where 	c.nr_sequencia = nr_seq_horario_p;
	
	if (ie_status_w = 'S') then
		update 	adep_processo
		set 	dt_primeira_checagem = dt_prim_checagem_hor_w
		where 	nr_sequencia = nr_seq_processo_p;
	end if;
	exception when others then
		CALL gravar_log_gedipa(	nr_log_p => 1010,
							nm_objeto_execucao_p => substr('adep_atualiza_prim_checagem', 50), 
							nm_objeto_chamado_p => substr('adep_atualiza_prim_checagem', 50), 
							DS_PARAMETROS_P => substr('nr_seq_horario_p : ' || nr_seq_horario_p || chr(10) || 'nr_seq_processo_p : ' || nr_seq_processo_p, 2000), 
							DS_LOG_P => substr('ie_status_w : ' || ie_status_w || chr(10) || 'dt_prim_checagem_hor_w : ' || dt_prim_checagem_hor_w || chr(10) ||
							'callstack : ' || dbms_utility.format_call_stack, 2000));
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE adep_atualiza_prim_checagem ( nr_seq_horario_p adep_processo.nr_seq_horario%type, nr_seq_processo_p adep_processo.nr_sequencia%type ) FROM PUBLIC;
