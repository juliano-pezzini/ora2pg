-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pat_gerar_razao_aux ( cd_conta_contabil_p text, cd_estab_p bigint, cd_empresa_p bigint, ie_tipo_valor_p text, ie_imobilizado_p text, dt_referencia_p timestamp, cd_centro_custo_p bigint, nm_usuario_p text) AS $body$
DECLARE


dt_referencia_w			timestamp;
nr_sequencia_w			bigint;
dt_mes_anterior_w		timestamp;
vl_saldo_ant_w			double precision;
vl_deprec_mes_ant_w		double precision;
vl_transf_entrada_w		double precision;
vl_transf_saida_w		double precision;
vl_transf_ent_dep_acum_w	double precision;
vl_transf_saida_dep_acum_w	double precision;
ie_tipo_valor_w			varchar(255);

c01 CURSOR FOR
SELECT	a.cd_conta_contabil,
	substr(obter_desc_conta_contabil(a.cd_conta_contabil),1,255) ds_conta_contabil,
	coalesce(sum(CASE WHEN PKG_DATE_UTILS.start_of(b.dt_aquisicao, 'MONTH', 0)=PKG_DATE_UTILS.start_of(dt_referencia_p, 'MONTH', 0) THEN  vl_original  ELSE 0 END ),0) vl_entrada,
	coalesce(sum(vl_deprec_mes),0) vl_deprec_mes,
	coalesce(sum(a.vl_baixa_bem),0) vl_baixa,
	coalesce(sum(a.vl_base_deprec),0) vl_saldo_atual,
	coalesce(sum(a.vl_baixa_deprec),0) vl_baixa_deprec,
	coalesce(sum(a.vl_deprec_acum),0) vl_deprec_acum_mes,
	coalesce(sum(a.vl_contabil),0) vl_contabil,
	max(b.ie_situacao) ie_situacao
from	pat_valor_bem a,
	pat_bem b,
	estabelecimento e
where	a.nr_seq_bem		= b.nr_sequencia
and	e.cd_estabelecimento	= b.cd_estabelecimento
and	e.cd_empresa		= cd_empresa_p
and	a.dt_valor 		= dt_referencia_w
and	((ie_imobilizado_p = 'X') or b.ie_imobilizado	= ie_imobilizado_p)
and	((ie_tipo_valor_w = '0') or (Obter_Se_Contido_char(b.ie_tipo_valor,ie_tipo_valor_w) = 'S'))
and (a.cd_conta_contabil	= cd_conta_contabil_p or coalesce(cd_conta_contabil_p,'0') = '0')
and (e.cd_estabelecimento	= cd_estab_p or coalesce(cd_estab_p,0) = 0)
and	((b.cd_centro_custo	= cd_centro_custo_p) or (coalesce(cd_centro_custo_p::text, '') = ''))
group by a.cd_conta_contabil;

vet01 c01%rowtype;


BEGIN

ie_tipo_valor_w := coalesce(ie_tipo_valor_p,'0');
ie_tipo_valor_w := replace(ie_tipo_valor_w,'(','');
ie_tipo_valor_w := replace(ie_tipo_valor_w,')','');



dt_referencia_w		:= PKG_DATE_UTILS.start_of(fim_mes(dt_referencia_p),'dd', 0);
dt_mes_anterior_w	:= PKG_DATE_UTILS.start_of(fim_mes(PKG_DATE_UTILS.ADD_MONTH(dt_referencia_p, -1,0)),'dd', 0);

delete	FROM w_pat_razao
where	nm_usuario	= nm_usuario_p;
commit;

open C01;
loop
fetch C01 into
	vet01;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	select	nextval('w_pat_razao_seq')
	into STRICT	nr_sequencia_w
	;

	select	coalesce(sum(a.vl_base_deprec),0) vl_saldo_ant,
		coalesce(sum(a.vl_deprec_acum),0) vl_deprec_mes_ant
	into STRICT	vl_saldo_ant_w,
		vl_deprec_mes_ant_w
	from	pat_valor_bem a,
		pat_bem b,
		estabelecimento e
	where	a.nr_seq_bem		= b.nr_sequencia
	and	e.cd_estabelecimento	= b.cd_estabelecimento
	and	e.cd_empresa		= cd_empresa_p
	and	a.dt_valor 		= dt_mes_anterior_w
	and	((ie_tipo_valor_w = '0') or (Obter_Se_Contido_char(b.ie_tipo_valor,ie_tipo_valor_w) = 'S'))
	and	((ie_imobilizado_p = 'X') or b.ie_imobilizado	= ie_imobilizado_p)
	and (a.cd_conta_contabil	= vet01.cd_conta_contabil)
	and (e.cd_estabelecimento	= cd_estab_p or cd_estab_p = 0)
	and	((b.cd_centro_custo	= cd_centro_custo_p) or (coalesce(cd_centro_custo_p::text, '') = ''));

	vl_transf_entrada_w		:= pat_obter_valor_transf_conta(null, dt_referencia_w, vet01.cd_conta_contabil, 'E');
	vl_transf_saida_w		:= pat_obter_valor_transf_conta(null, dt_referencia_w, vet01.cd_conta_contabil, 'S');
	vl_transf_ent_dep_acum_w	:= pat_obter_valor_transf_conta(null, dt_referencia_w, vet01.cd_conta_contabil, 'EDA');
	vl_transf_saida_dep_acum_w	:= pat_obter_valor_transf_conta(null, dt_referencia_w, vet01.cd_conta_contabil, 'SDA');


	insert into w_pat_razao(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_bem,
		cd_conta_contabil,
		vl_saldo_ant,
		vl_entrada,
		vl_baixa,
		vl_saldo_atual,
		vl_transf_entrada,
		vl_transf_saida,
		vl_contabil,
		vl_deprec_mes_ant,
		vl_deprec_mes,
		vl_deprec_acum_mes,
		ds_gerencial,
		vl_baixa_deprec,
		vl_transf_ent_dep_acum,
		vl_transf_saida_dep_acum,
		ie_situacao)
	values (	nr_sequencia_w,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		null,
		vet01.cd_conta_contabil,
		vl_saldo_ant_w,
		vet01.vl_entrada,
		vet01.vl_baixa,
		vet01.vl_saldo_atual,
		coalesce(vl_transf_entrada_w,0),
		coalesce(vl_transf_saida_w,0),
		vet01.vl_contabil,
		vl_deprec_mes_ant_w,
		vet01.vl_deprec_mes,
		vet01.vl_deprec_acum_mes,
		vet01.cd_conta_contabil || ' - ' || vet01.ds_conta_contabil,
		vet01.vl_baixa_deprec,
		coalesce(vl_transf_ent_dep_acum_w,0),
		coalesce(vl_transf_saida_dep_acum_w,0),
		vet01.ie_situacao);

	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pat_gerar_razao_aux ( cd_conta_contabil_p text, cd_estab_p bigint, cd_empresa_p bigint, ie_tipo_valor_p text, ie_imobilizado_p text, dt_referencia_p timestamp, cd_centro_custo_p bigint, nm_usuario_p text) FROM PUBLIC;

