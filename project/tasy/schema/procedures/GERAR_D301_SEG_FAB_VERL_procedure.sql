-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_d301_seg_fab_verl (nr_atendimento_p bigint, nr_seq_dataset_p bigint, nm_usuario_p text) AS $body$
DECLARE



ie_lado_depart_2_w	diagnostico_doenca.ie_lado%type;
cd_cid_depart_2_w	diagnostico_doenca.cd_doenca%type;
cd_departamento_w	atend_paciente_unidade.cd_departamento%type;
nr_seq_atepacu_w	atend_paciente_unidade.nr_seq_interno%type;

c01 CURSOR FOR
SELECT	max(d.cd_doenca) cd_doenca,
	max(d.ie_lado) ie_lado,
	max(d.dt_diagnostico) dt_diagnostico
from	atendimento_paciente a,
	medic_diagnostico_doenca b,
	classificacao_diagnostico c,
	diagnostico_doenca d
where	b.nr_seq_classificacao 		= c.nr_sequencia
and	b.nr_atendimento		= a.nr_atendimento
and	d.nr_atendimento		= a.nr_atendimento
and	b.cd_doenca			= d.cd_doenca
and	b.ie_situacao			= 'A'
--and	upper(c.ds_classificacao)	= 'FACHABTEILUNG DIAGNOSE'
and	'S'				= OBTER_SE_CLASSIF_DIAG_301(c.nr_sequencia,'FAC',d.DT_DIAGNOSTICO)
and	coalesce(d.dt_inativacao::text, '') = ''
and	(d.dt_liberacao IS NOT NULL AND d.dt_liberacao::text <> '')
and	coalesce(d.cd_doenca_superior::text, '') = ''
and	a.nr_atendimento 		= nr_atendimento_p;

c01_w	c01%rowtype;


BEGIN

open C01;
loop
fetch C01 into
	c01_w;
EXIT WHEN NOT FOUND; /* apply on C01 */

	nr_seq_atepacu_w	:= obter_atepacu_data(nr_atendimento_p,'A',c01_w.dt_diagnostico);

	select	max(cd_departamento)
	into STRICT	cd_departamento_w
	from	atend_paciente_unidade
	where	nr_seq_interno	= nr_seq_atepacu_w;

	/*select	obter_departamento_data(nr_atendimento_p,c01_w.dt_diagnostico)
	into	cd_departamento_w
	from	dual;*/
	select	max(a.ie_lado),
		max(a.cd_doenca)
	into STRICT	ie_lado_depart_2_w,
		cd_cid_depart_2_w
	from	diagnostico_doenca a,
		medic_diagnostico_doenca b,
		classificacao_diagnostico c
	where	b.nr_seq_classificacao 		= c.nr_sequencia
	and	b.nr_atendimento		= a.nr_atendimento
	and	b.cd_doenca			= a.cd_doenca
	and	b.ie_situacao			= 'A'
	--and	upper(c.ds_classificacao)	= 'FACHABTEILUNG DIAGNOSE'
	and	'S'				= OBTER_SE_CLASSIF_DIAG_301(c.nr_sequencia,'FAC',a.DT_DIAGNOSTICO)
	and	coalesce(a.dt_inativacao::text, '') = ''
	and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and	a.cd_doenca_superior 		= c01_w.cd_doenca
	and	a.nr_atendimento		= nr_atendimento_p;

	insert into d301_segmento_fab(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_dataset,
		nr_seq_301_depart,
		cd_cid_depart_1,
		nr_seq_301_local_depart_1,
		cd_cid_depart_2,
		nr_seq_301_local_depart_2)
	values (nextval('d301_segmento_fab_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_dataset_p,
		OBTER_SEQ_VALOR_301('C301_6_DEPARTAMENTO','CD_DEPARTAMENTO',OBTER_CONVERSAO_301('C301_6_DEPARTAMENTO','DEPARTAMENTO_MEDICO',NULL,CD_DEPARTAMENTO_W,'I')),
		c01_w.cd_doenca,
		OBTER_SEQ_VALOR_301('C301_16_LOCALIZACAO','IE_LOCALIZACAO',obter_conversao_301('C301_16_LOCALIZACAO',null,1372,c01_w.ie_lado,'I')),
		cd_cid_depart_2_w,
		OBTER_SEQ_VALOR_301('C301_16_LOCALIZACAO','IE_LOCALIZACAO',obter_conversao_301('C301_16_LOCALIZACAO',null,1372,ie_lado_depart_2_w,'I')));

end loop;
close C01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_d301_seg_fab_verl (nr_atendimento_p bigint, nr_seq_dataset_p bigint, nm_usuario_p text) FROM PUBLIC;

