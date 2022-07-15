-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_prescr_diagnostika ( id_diagnostika_p text, id_origem_p text,--nr_seq_interno da prescr_procedimento
 dt_prevista_exec_p text, nm_usuario_p text) AS $body$
DECLARE


dt_prevista_w 	timestamp;
nr_prescricao_w 	bigint;


BEGIN

dt_prevista_w := to_date(dt_prevista_exec_p,'yyyy-mm-dd');

if (id_diagnostika_p IS NOT NULL AND id_diagnostika_p::text <> '') and (id_origem_p IS NOT NULL AND id_origem_p::text <> '') and (dt_prevista_exec_p IS NOT NULL AND dt_prevista_exec_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then

	select max(nr_prescricao)
	into STRICT nr_prescricao_w
	from prescr_procedimento
	where nr_seq_interno = id_origem_p;

	update	prescr_procedimento
	set 	nr_controle 	 = id_diagnostika_p,
		dt_prev_execucao	 = dt_prevista_w
	where 	nr_seq_interno 	 = id_origem_p;

	update	integracao_diagnostika
	set	dt_envio 	= clock_timestamp(),
		dt_atualizacao 	= clock_timestamp(),
		nm_usuario	= nm_usuario_p
	where	nr_seq_interno 	= id_origem_p;

	CALL gera_log_lab(nr_prescricao_w,'executou procedure atualizar_prescr_diagnostika - id_diagnostika: '
||id_diagnostika_p||
	' id_origem: '||id_origem_p||' dt_prevista_exec: '||dt_prevista_exec_p,'',13,nm_usuario_p);

	commit;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_prescr_diagnostika ( id_diagnostika_p text, id_origem_p text, dt_prevista_exec_p text, nm_usuario_p text) FROM PUBLIC;

