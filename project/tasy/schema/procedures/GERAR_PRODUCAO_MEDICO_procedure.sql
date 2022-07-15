-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_producao_medico (cd_medico_p text, dt_inicial_p timestamp, dt_final_p timestamp, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w		bigint;
nr_seq_propaci_w	bigint;
nr_seq_partic_w		bigint;
vl_medico_w		double precision;
dt_proced_w		timestamp;

c01 CURSOR FOR
	SELECT	a.nr_sequencia,
		b.nr_seq_partic,
		b.vl_participante,
		a.dt_procedimento
	from	procedimento_participante b,
		procedimento_paciente a
	where	a.nr_sequencia		= b.nr_sequencia
	and	b.cd_pessoa_fisica	= cd_medico_p
	and	a.dt_procedimento between dt_inicial_p and fim_dia(dt_final_p)
	and	coalesce(b.vl_participante,0) > 0
	and	not exists (SELECT	1
		from	controle_proc_terceiro x
		where	x.nr_seq_propaci	= b.nr_sequencia
		and	x.nr_seq_partic		= b.nr_seq_partic
		and	x.cd_pessoa_fisica	= cd_medico_p)
	
union

	select	a.nr_sequencia,
		0,
		a.vl_medico,
		a.dt_procedimento
	from	procedimento_paciente a
	where	a.cd_medico_executor	= cd_medico_p
	and	a.dt_procedimento between dt_inicial_p and fim_dia(dt_final_p)
	and	coalesce(a.vl_medico,0) > 0
	and	not exists (select	1
		from	controle_proc_terceiro x
		where	x.nr_seq_propaci	= a.nr_sequencia
		and	x.cd_pessoa_fisica	= cd_medico_p
		and	coalesce(x.nr_seq_partic::text, '') = '');

BEGIN

open	c01;
loop
fetch	c01 into
	nr_seq_propaci_w,
	nr_seq_partic_w,
	vl_medico_w,
	dt_proced_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	select	nextval('controle_proc_terceiro_seq')
	into STRICT	nr_sequencia_w
	;


	insert 	into controle_proc_terceiro(nr_sequencia,
		cd_pessoa_fisica,
		dt_atualizacao,
		nm_usuario,
		nr_seq_propaci,
		nr_seq_partic,
		vl_producao,
		dt_producao,
		vl_recebido,
		dt_recebido)
	values (nr_sequencia_w,
		cd_medico_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_propaci_w,
		CASE WHEN nr_seq_partic_w=0 THEN  null  ELSE nr_seq_partic_w END ,
		vl_medico_w,
		dt_proced_w,
		null, null);

	end;
end loop;
close	c01;

CALL GERAR_CONTROLE_PROC_TERC_LOG(nm_usuario_p,dt_inicial_p,dt_final_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_producao_medico (cd_medico_p text, dt_inicial_p timestamp, dt_final_p timestamp, nm_usuario_p text) FROM PUBLIC;

