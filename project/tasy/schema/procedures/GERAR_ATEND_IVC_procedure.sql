-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_atend_ivc ( nr_prescricao_p bigint, nr_seq_procedimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_medico_exec_w		varchar(10);
dt_prev_execucao_w		timestamp;
nr_atendimento_w		bigint;
nr_sequencia_w			bigint;


BEGIN

select	max(a.cd_medico_exec),
		max(a.dt_prev_execucao),
		max(b.nr_atendimento)
into STRICT	cd_medico_exec_w,
		dt_prev_execucao_w,
		nr_atendimento_w
from	prescr_medica b,
		prescr_procedimento a
where	a.nr_prescricao	= b.nr_prescricao
and		a.nr_prescricao	= nr_prescricao_p
and		a.nr_sequencia	= nr_seq_procedimento_p;

if (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') then

	select	nextval('adep_irrigacao_seq')
	into STRICT	nr_sequencia_w
	;

	insert into ADEP_IRRIGACAO(
			nr_sequencia,
			nm_usuario,
			dt_atualizacao,
			nr_atendimento,
			dt_inicio,
			cd_pessoa_fisica,
			nr_prescricao,
			nr_seq_procedimento,
			ie_status_ivc)
	values (
			nr_sequencia_w,
			nm_usuario_p,
			clock_timestamp(),
			nr_atendimento_w,
			null,
			cd_medico_exec_w,
			nr_prescricao_p,
			nr_seq_procedimento_p,
			'P');
end if;

if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_atend_ivc ( nr_prescricao_p bigint, nr_seq_procedimento_p bigint, nm_usuario_p text) FROM PUBLIC;

