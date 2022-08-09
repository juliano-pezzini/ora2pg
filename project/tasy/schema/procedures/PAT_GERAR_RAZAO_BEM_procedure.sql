-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pat_gerar_razao_bem (( cd_conta_contabil_p text, cd_estab_p bigint, cd_empresa_p bigint, ie_tipo_valor_p text, ie_imobilizado_p text, dt_referencia_p timestamp, nm_usuario_p text) is dt_referencia_w timestamp) RETURNS bigint AS $body$
DECLARE


vl_retorno_w			double precision;
vl_entrada_estab_w		double precision;
vl_saida_estab_w		double precision;
vl_entrada_deprec_estab_w	double precision;
vl_saida_deprec_estab_w		double precision;


BEGIN

if (ie_tipo_valor_p = 'E' or ie_tipo_valor_p = 'EDA') then
	begin
	/* Entrada */

	select	sum(a.vl_base_deprec),
			sum(a.vl_deprec_acum)
	into STRICT	vl_entrada_estab_w,
			vl_entrada_deprec_estab_w
	from	pat_valor_bem a,
			pat_bem b,
			estabelecimento e
	where	a.nr_seq_bem			= b.nr_sequencia
	and		e.cd_estabelecimento	= b.cd_estabelecimento
	and		e.cd_empresa			= cd_empresa_p
	and		a.dt_valor 				= dt_referencia_w
	and		((ie_imobilizado_p = 'X') or b.ie_imobilizado	= ie_imobilizado_p)
	and		((ie_tipo_valor_w = '0') or (Obter_Se_Contido_char(b.ie_tipo_valor,ie_tipo_valor_w) = 'S'))
	and (a.cd_conta_contabil	= vet01.cd_conta_contabil)
	and		pat_obter_estab_bem_periodo(b.nr_sequencia,dt_referencia_w) = cd_estab_p
	and		pat_obter_estab_bem_periodo(b.nr_sequencia,dt_mes_anterior_w) != cd_estab_p
	and		cd_estab_p <> 0
	and 	trunc(b.dt_inicio_uso,'mm') <> trunc(dt_referencia_w,'mm');
	
	if (ie_tipo_valor_p = 'E') then
		vl_retorno_w := coalesce(vl_entrada_estab_w, 0);
	else
		vl_retorno_w := coalesce(vl_entrada_deprec_estab_w, 0);
	end if;
	end;
end if;



if (ie_tipo_valor_p = 'S' or ie_tipo_valor_p = 'SDA') then
	/* Saida */

	select	sum(a.vl_base_deprec),
			sum(a.vl_deprec_acum)
	into STRICT	vl_saida_estab_w,
			vl_saida_deprec_estab_w
	from	pat_valor_bem a,
			pat_bem b,
			estabelecimento e
	where	a.nr_seq_bem		= b.nr_sequencia
	and		e.cd_estabelecimento	= b.cd_estabelecimento
	and		e.cd_empresa		= cd_empresa_p
	and		a.dt_valor 			= dt_mes_anterior_w
	and		((ie_imobilizado_p = 'X') or b.ie_imobilizado	= ie_imobilizado_p)
	and		((ie_tipo_valor_w = '0') or (Obter_Se_Contido_char(b.ie_tipo_valor,ie_tipo_valor_w) = 'S'))
	and (a.cd_conta_contabil	= vet01.cd_conta_contabil)
	and		pat_obter_estab_bem_periodo(b.nr_sequencia,dt_mes_anterior_w) = cd_estab_p
	and		pat_obter_estab_bem_periodo(b.nr_sequencia,dt_referencia_w) != cd_estab_p
	and		cd_estab_p <> 0;

	if (ie_tipo_valor_p = 'S') then
		vl_retorno_w := coalesce(vl_saida_estab_w, 0);

	else
		vl_retorno_w := coalesce(vl_saida_deprec_estab_w, 0);
	end if;

end if;


return vl_retorno_w;

end;

begin

ie_tipo_valor_w := coalesce(ie_tipo_valor_p,'0');
ie_tipo_valor_w := replace(ie_tipo_valor_w,'(','');
ie_tipo_valor_w := replace(ie_tipo_valor_w,')','');



dt_referencia_w		:= PKG_DATE_UTILS.start_of(fim_mes(dt_referencia_p),'dd', 0);
dt_mes_anterior_w	:= PKG_DATE_UTILS.start_of(fim_mes(PKG_DATE_UTILS.ADD_MONTH(dt_referencia_p, -1, 0)),'dd', 0);

delete	FROM w_pat_razao
where	nm_usuario	= nm_usuario_p;
commit;

cd_conta_contabil_w := '0';

open C01;
loop
fetch C01 into
	vet01;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	nr_seq_bem_w	:= vet01.nr_sequencia;

	select	coalesce(sum(a.vl_base_deprec),0) + coalesce(sum(a.vl_residual),0) vl_saldo_ant,
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
	and (a.cd_conta_contabil	= vet01.cd_conta_contabil)
	and (e.cd_estabelecimento	= cd_estab_p or cd_estab_p = 0)
	and	b.nr_sequencia		= vet01.nr_sequencia;

	vl_transf_entrada_w		:= pat_obter_valor_transf_conta(nr_seq_bem_w, dt_referencia_w, vet01.cd_conta_contabil, 'E');
	vl_transf_saida_w		:= pat_obter_valor_transf_conta(nr_seq_bem_w, dt_referencia_w, vet01.cd_conta_contabil, 'S');
	vl_transf_ent_dep_acum_w	:= pat_obter_valor_transf_conta(nr_seq_bem_w, dt_referencia_w, vet01.cd_conta_contabil, 'EDA');
	vl_transf_saida_dep_acum_w	:= pat_obter_valor_transf_conta(nr_seq_bem_w, dt_referencia_w, vet01.cd_conta_contabil, 'SDA');


	if (cd_conta_contabil_w <> vet01.cd_conta_contabil) then
		select	nextval('w_pat_razao_seq')
		into STRICT	nr_sequencia_w
		;
		
		vl_transf_entr_estab_w				:= obter_val_transf_estab(cd_estab_p, dt_referencia_w,'E');
		vl_transf_saida_estab_w				:= obter_val_transf_estab(cd_estab_p, dt_referencia_w,'S');
		vl_deprec_transf_entr_estab_w		:= obter_val_transf_estab(cd_estab_p, dt_referencia_w,'EDA');
		vl_deprec_transf_saida_estab_w		:= obter_val_transf_estab(cd_estab_p, dt_referencia_w,'SDA');
		
		
		
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
			vl_transf_entrada_estab,
			vl_transf_saida_estab,
			vl_deprec_transf_entrada_estab,
			vl_deprec_transf_saida_estab)
		values (	nr_sequencia_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			0,
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
			vet01.cd_conta_contabil || ' - ' || vet01.ds_conta_contabil,
			0,
			0,
			0,
			vl_transf_entr_estab_w,
			vl_transf_saida_estab_w	,
			vl_deprec_transf_entr_estab_w,
			vl_deprec_transf_saida_estab_w);
		
	end if;
	
	cd_conta_contabil_w := vet01.cd_conta_contabil;
	
	select	nextval('w_pat_razao_seq')
	into STRICT	nr_sequencia_w
	;
	
	

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
		vl_transf_entrada_estab,
		vl_transf_saida_estab,
		vl_deprec_transf_entrada_estab,
		vl_deprec_transf_saida_estab)
	values (	nr_sequencia_w,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		vet01.nr_sequencia,
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
-- REVOKE ALL ON PROCEDURE pat_gerar_razao_bem (( cd_conta_contabil_p text, cd_estab_p bigint, cd_empresa_p bigint, ie_tipo_valor_p text, ie_imobilizado_p text, dt_referencia_p timestamp, nm_usuario_p text) is dt_referencia_w timestamp) FROM PUBLIC;
