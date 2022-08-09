-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_d301_seg_fab_entl ( nr_atendimento_p atendimento_paciente.nr_atendimento%type, nr_seq_dataset_p bigint, nm_usuario_p text) AS $body$
DECLARE


c01 CURSOR FOR
SELECT	a.dt_entrada_unidade,
	a.dt_saida_unidade,
	a.cd_departamento,
	a.nr_seq_interno nr_seq_atepacu
from 	atend_paciente_unidade a,
	setor_atendimento      b
where 	a.nr_atendimento       = nr_atendimento_p
and 	a.cd_setor_atendimento = b.cd_setor_atendimento
and 	b.cd_classif_setor in (2,3,4);

c01_w	c01%rowtype;

c02 CURSOR FOR
SELECT  row_number() OVER () AS id_linha,
	a.cd_doenca cd_cid_depart_1,
	a.ie_lado
from 	diagnostico_doenca a,
	medic_diagnostico_doenca b,
	classificacao_diagnostico c
where 	a.nr_atendimento		= nr_atendimento_p
and   	b.nr_atendimento		= a.nr_atendimento
and   	a.cd_doenca			= b.cd_doenca
and   	c.nr_sequencia			= b.nr_seq_classificacao
and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
and	coalesce(a.dt_inativacao::text, '') = ''
and	a.dt_diagnostico		between c01_w.dt_entrada_unidade and c01_w.dt_saida_unidade
and   	coalesce(a.cd_doenca_superior::text, '') = ''
and	'S'				= OBTER_SE_CLASSIF_DIAG_301(c.nr_sequencia,'FAC',a.dt_diagnostico);

c02_w	c02%rowtype;

nr_seq_segmento_w	bigint;

	procedure insert_segmento_fab is
	;
BEGIN
	insert into d301_segmento_fab(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_dataset,
		nr_seq_301_depart)
	values (nextval('d301_segmento_fab_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_dataset_p,
		obter_seq_valor_301('C301_6_DEPARTAMENTO','CD_DEPARTAMENTO',obter_conversao_301('C301_6_DEPARTAMENTO','DEPARTAMENTO_MEDICO',NULL,c01_w.cd_departamento,'I')))
	returning nr_sequencia into nr_seq_segmento_w;

	end;

begin

open C01;
loop
fetch C01 into
	c01_w;
EXIT WHEN NOT FOUND; /* apply on C01 */

	insert_segmento_fab;

	--para cada departamento, busca os seus CIDs, com base na data de entrada e saida da unidade
	open C02;
	loop
	fetch C02 into
		c02_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */

		if (c02_w.id_linha > 1) then
			insert_segmento_fab;
		end if;

		update	d301_segmento_fab
		set	cd_cid_depart_1			= c02_w.cd_cid_depart_1,
			nr_seq_301_local_depart_1	= obter_seq_valor_301('C301_16_LOCALIZACAO','IE_LOCALIZACAO',obter_conversao_301('C301_16_LOCALIZACAO',null,1372,c02_w.ie_lado,'I'))
		where	nr_sequencia			= nr_seq_segmento_w;

	end loop;
	close C02;

end loop;
close C01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_d301_seg_fab_entl ( nr_atendimento_p atendimento_paciente.nr_atendimento%type, nr_seq_dataset_p bigint, nm_usuario_p text) FROM PUBLIC;
