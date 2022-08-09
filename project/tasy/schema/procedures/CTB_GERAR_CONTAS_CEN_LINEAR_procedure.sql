-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_gerar_contas_cen_linear ( nr_seq_cenario_p bigint, cd_estabelecimento_p bigint, cd_centro_custo_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_empresa_w				bigint;

c01 CURSOR FOR
SELECT	a.cd_conta_contabil
from	ctb_grupo_conta b,
	conta_contabil a
where	a.cd_grupo	= b.cd_grupo
and	a.cd_empresa	= b.cd_empresa
and	a.cd_empresa	= cd_empresa_w
and	a.ie_tipo	= 'A'
and	b.ie_tipo	in ('R','C','D')
and	a.ie_situacao	= 'A'
and	substr(ctb_obter_se_conta_ce_usuario(cd_empresa_w, cd_centro_custo_p, cd_conta_contabil, nm_usuario_p),1,1) = 'S'
and	substr(obter_se_conta_vigente2(a.cd_conta_contabil, a.dt_inicio_vigencia, a.dt_fim_vigencia, clock_timestamp()),1,1) = 'S'
and	not exists (	select	1
			from	ctb_orc_cen_valor_linear y
			where	y.nr_seq_cenario	= nr_seq_cenario_p
			and	y.cd_centro_custo	= cd_centro_custo_p
			and	y.cd_conta_contabil	= a.cd_conta_contabil);

vet01	c01%rowtype;


BEGIN

select	max(cd_empresa)
into STRICT	cd_empresa_w
from	ctb_orc_cenario
where	nr_sequencia	= nr_seq_cenario_p;

open C01;
loop
fetch C01 into
	vet01;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	insert into ctb_orc_cen_valor_linear(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_cenario,
		cd_estabelecimento,
		cd_centro_custo,
		cd_conta_contabil,
		vl_orcado_1,
		vl_orcado_2,
		vl_orcado_3,
		vl_orcado_4,
		vl_orcado_5,
		vl_orcado_6,
		vl_orcado_7,
		vl_orcado_8,
		vl_orcado_9,
		vl_orcado_10,
		vl_orcado_11,
		vl_orcado_12)
	values (	nextval('ctb_orc_cen_valor_linear_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_cenario_p,
		cd_estabelecimento_p,
		cd_centro_custo_p,
		vet01.cd_conta_contabil,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0);

	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_gerar_contas_cen_linear ( nr_seq_cenario_p bigint, cd_estabelecimento_p bigint, cd_centro_custo_p bigint, nm_usuario_p text) FROM PUBLIC;
