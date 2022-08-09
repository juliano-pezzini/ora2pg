-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_fluxo_caixa_lote_oc ( nr_seq_lote_fluxo_p bigint, cd_estabelecimento_p bigint, qt_dia_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, nm_usuario_p text, cd_empresa_p bigint) AS $body$
DECLARE


/*--------------------------------------------------------------- ATENCAO ----------------------------------------------------------------*/


/* Cuidado ao realizar alteracoes no fluxo de caixa em lote. Toda e qualquer alteracao realizada em qualquer uma */


/* das procedures do fluxo de caixa em lote deve ser cuidadosamente verificada e realizada no fluxo de caixa      */


/* convencional. Devemos garantir que os dois fluxos de caixa tragam os mesmos valores no resultado, evitando     */


/* assim que existam diferencas entre os fluxos de caixa.                                                                                                */


/*--------------- AO ALTERAR O FLUXO DE CAIXA EM LOTE ALTERAR TAMBEM O FLUXO DE CAIXA ---------------*/

nr_ordem_compra_w	bigint;
vl_item_liquido_w	double precision;
cd_cond_pagto_w		bigint;
cd_conta_financ_w	bigint;
nr_ordem_compra_ant_w	bigint		:= 0;
dt_entrega_w		timestamp;
vl_fluxo_w		double precision;
dt_referencia_w		timestamp;
dt_orig_referencia_w		timestamp;
cd_moeda_w		integer		:= 0;
cd_moeda_padrao_w	integer		:= 0;
qt_vencimento_w		integer;
ds_vencimento_w		varchar(2000);
ie_tratar_fim_semana_w	varchar(2);
vl_total_ordem_w	double precision;
vl_saldo_mercadoria_w	double precision		:= 0;
vl_venc_ant_w		double precision;
nr_item_oci_w		bigint;
ie_somente_futuro_w	varchar(255);
ie_oc_parcial_w		varchar(255);
ie_calc_fluxo_oc_w	varchar(255);
ie_oc_aprovada_w	varchar(255);
pr_desc_financ_w	double precision;
pr_desc_financ_ordem_w	double precision;
IE_ENTREGA_CANC_OC_W varchar(255);

c02 CURSOR FOR
SELECT	b.dt_vencimento,
	coalesce(a.cd_moeda, cd_moeda_padrao_w),		
	c.nr_seq_conta_financ,
	dividir_sem_round(c.vl_item_liquido, obter_valor_liquido_ordem(a.nr_ordem_compra)) * b.vl_vencimento,
	c.pr_desc_financ,
	a.pr_desc_financeiro,
	a.nr_ordem_compra
from	ordem_compra_item c,
	ordem_compra a,
	ORDEM_COMPRA_VENC b
where	a.nr_ordem_compra	= b.nr_ordem_compra
and	b.nr_ordem_compra	= c.nr_ordem_compra
and	a.cd_estabelecimento	= cd_estabelecimento_p
and	a.dt_ordem_compra	>= clock_timestamp() - qt_dia_p
and	coalesce(a.dt_baixa::text, '') = ''
and	(c.nr_seq_conta_financ IS NOT NULL AND c.nr_seq_conta_financ::text <> '')
and	b.dt_vencimento		between trunc(dt_inicial_p, 'dd') and fim_dia(dt_final_p)
and	((ie_oc_aprovada_w = 'N') or (a.dt_aprovacao IS NOT NULL AND a.dt_aprovacao::text <> ''))
and	ie_calc_fluxo_oc_w	= 'V'
and IE_ENTREGA_CANC_OC_W = 'N'

union
	
SELECT	
	d.dt_vencimento,
	coalesce(a.cd_moeda, cd_moeda_padrao_w),
	b.nr_seq_conta_financ,
	(c.QT_PREVISTA_ENTREGA * b.VL_UNITARIO_MATERIAL) vl_item,
  b.pr_desc_financ,
  a.pr_desc_financeiro,
  a.nr_ordem_compra
from 	Ordem_compra_item_entrega c,
	ordem_compra_item b,
	ordem_compra a,
  ORDEM_COMPRA_VENC d		
where 	a.cd_estabelecimento	= cd_estabelecimento_p
AND    a.nr_ordem_compra	= d.nr_ordem_compra
and	coalesce(a.dt_baixa::text, '') = ''
and	a.nr_ordem_compra	= b.nr_ordem_compra
and	b.nr_ordem_compra	= c.nr_ordem_compra
and	b.nr_item_oci		= c.nr_item_oci
and   coalesce(c.DT_CANCELAMENTO::text, '') = ''
and	(b.nr_seq_conta_financ IS NOT NULL AND b.nr_seq_conta_financ::text <> '')
and	((ie_oc_aprovada_w = 'N') or (a.dt_aprovacao IS NOT NULL AND a.dt_aprovacao::text <> ''))
and (not exists (	select	1
			from	ordem_compra_venc x
			where	x.nr_ordem_compra = a.nr_ordem_compra) or (ie_calc_fluxo_oc_w = 'V'))
and IE_ENTREGA_CANC_OC_W = 'S'	 
order	by nr_ordem_compra,
	dt_vencimento;	

c010 CURSOR FOR
SELECT	b.nr_ordem_compra,
	a.cd_condicao_pagamento,
	coalesce(a.cd_moeda, cd_moeda_padrao_w),
	b.nr_seq_conta_financ,
	b.vl_item_liquido,
	c.dt_prevista_entrega,
	b.nr_item_oci,
	b.pr_desc_financ,
	a.pr_desc_financeiro
from 	Ordem_compra_item_entrega c,
	ordem_compra_item b,
	ordem_compra a		
where 	a.cd_estabelecimento	= cd_estabelecimento_p
and	a.dt_ordem_compra	> clock_timestamp() - qt_dia_p
and	coalesce(a.dt_baixa::text, '') = ''
and	a.nr_ordem_compra	= b.nr_ordem_compra
and	b.nr_ordem_compra	= c.nr_ordem_compra
and	b.nr_item_oci		= c.nr_item_oci
and	b.qt_material		> coalesce(qt_material_entregue,0)
and	c.qt_prevista_entrega 	> coalesce(c.qt_real_entrega,0)
and	(b.nr_seq_conta_financ IS NOT NULL AND b.nr_seq_conta_financ::text <> '')
and	((ie_oc_aprovada_w = 'N') or (a.dt_aprovacao IS NOT NULL AND a.dt_aprovacao::text <> ''))
and (not exists (	SELECT	1 
			from	ordem_compra_venc x
			where	x.nr_ordem_compra = a.nr_ordem_compra) or (ie_calc_fluxo_oc_w	= 'E'))
and IE_ENTREGA_CANC_OC_W = 'N'	 

union
	
select	b.nr_ordem_compra,
	a.cd_condicao_pagamento,
	coalesce(a.cd_moeda, cd_moeda_padrao_w),
	b.nr_seq_conta_financ,
	(c.QT_PREVISTA_ENTREGA * b.VL_UNITARIO_MATERIAL) vl_item,
	c.dt_prevista_entrega,
	b.nr_item_oci,
	b.pr_desc_financ,
	a.pr_desc_financeiro
from 	Ordem_compra_item_entrega c,
	ordem_compra_item b,
	ordem_compra a		
where 	a.cd_estabelecimento	= cd_estabelecimento_p
and	a.dt_ordem_compra	> clock_timestamp() - qt_dia_p
and	coalesce(a.dt_baixa::text, '') = ''
and	a.nr_ordem_compra	= b.nr_ordem_compra
and	b.nr_ordem_compra	= c.nr_ordem_compra
and	b.nr_item_oci		= c.nr_item_oci
and coalesce(c.DT_CANCELAMENTO::text, '') = ''
and	b.qt_material		> coalesce(qt_material_entregue,0)
and	c.qt_prevista_entrega 	> coalesce(c.qt_real_entrega,0)
and	(b.nr_seq_conta_financ IS NOT NULL AND b.nr_seq_conta_financ::text <> '')
and	((ie_oc_aprovada_w = 'N') or (a.dt_aprovacao IS NOT NULL AND a.dt_aprovacao::text <> ''))
and (not exists (	select	1 
			from	ordem_compra_venc x
			where	x.nr_ordem_compra = a.nr_ordem_compra) or (ie_calc_fluxo_oc_w	= 'E'))
and IE_ENTREGA_CANC_OC_W = 'S';


BEGIN

select	obter_moeda_padrao(cd_estabelecimento_p, 'P')
into STRICT	cd_moeda_padrao_w
;

select	ie_tratar_fim_semana,
	ie_somente_futuro,
	coalesce(ie_oc_parcial, 'N'),
	coalesce(ie_oc_aprovada, 'N'),
	coalesce(ie_calc_fluxo_oc, 'V'),
	coalesce(IE_ENTREGA_CANC_OC, 'N')
into STRICT	ie_tratar_fim_semana_w,
	ie_somente_futuro_w,
	ie_oc_parcial_w,
	ie_oc_aprovada_w,
	ie_calc_fluxo_oc_w,
	IE_ENTREGA_CANC_OC_W
from	parametro_fluxo_caixa
where	cd_estabelecimento	= cd_estabelecimento_p;

open c02;
loop
fetch c02 into
	dt_referencia_w,
	cd_moeda_w,
	cd_conta_financ_w,
	vl_fluxo_w,
	pr_desc_financ_w,
	pr_desc_financ_ordem_w,
	nr_ordem_compra_w;
EXIT WHEN NOT FOUND; /* apply on c02 */

	if (coalesce(pr_desc_financ_w,0) > 0) then
		vl_fluxo_w		:= vl_fluxo_w - ((pr_desc_financ_w / 100) * vl_fluxo_w);
	end if;

	if (coalesce(pr_desc_financ_ordem_w,0) > 0) then
		vl_fluxo_w		:= vl_fluxo_w - ((pr_desc_financ_ordem_w / 100) * vl_fluxo_w);
	end if;

	if (cd_moeda_padrao_w <> cd_moeda_w) then

		select	Obter_Valor_Moeda_Nac(cd_estabelecimento_p,
			vl_fluxo_w,
			cd_moeda_w,
			dt_referencia_w)
		into STRICT	vl_fluxo_w
		;

	end if;
	dt_orig_referencia_w := dt_referencia_w;
	if (ie_tratar_fim_semana_w = 'S') then
		dt_referencia_w			:= obter_proximo_dia_util(cd_estabelecimento_p, dt_referencia_w);
	end if;


	if (ie_somente_futuro_w = 'N') or (dt_referencia_w >= trunc(clock_timestamp(),'dd')) then

		if (ie_oc_parcial_w = 'S') then
			if (nr_ordem_compra_w <> nr_ordem_compra_ant_w) then
				select	coalesce(sum(vl_vencimento),0)
				into STRICT	vl_venc_ant_w
				from	ordem_compra_venc
				where	nr_ordem_compra	= nr_ordem_compra_w
				and	dt_vencimento	< dt_orig_referencia_w;

				select	coalesce(sum(a.vl_mercadoria),0)
				into STRICT	vl_saldo_mercadoria_w
				from	nota_fiscal a
				where	a.nr_ordem_compra	= nr_ordem_compra_w
				and	exists (SELECT	1 from titulo_pagar x where x.nr_seq_nota_fiscal = a.nr_sequencia);
				if (vl_venc_ant_w >= vl_saldo_mercadoria_w) then
					vl_saldo_mercadoria_w	:= 0;
				else
					vl_saldo_mercadoria_w	:= vl_saldo_mercadoria_w - vl_venc_ant_w;
				end if;
			end if;
			nr_ordem_compra_ant_w		:= nr_ordem_compra_w;
			if (vl_fluxo_w >= vl_saldo_mercadoria_w) then
				vl_fluxo_w		:= vl_fluxo_w - vl_saldo_mercadoria_w;
				vl_saldo_mercadoria_w	:= 0;
			else
				vl_saldo_mercadoria_w	:= vl_saldo_mercadoria_w - vl_fluxo_w;
				vl_fluxo_w		:= 0;
			end if;
		end if;
		
		CALL GERAR_FLUXO_CAIXA_LOTE(	dt_referencia_w,
					cd_conta_financ_w,
					'',
					'18',
					'OC',
					nm_usuario_p,
					null,
					null,
					nr_ordem_compra_w,
					null,
					null,
					null,
					null,
					null,
					nr_seq_lote_fluxo_p,
					null,
					null,
					null,
					null,
					null,
					null,
					null,
					coalesce(vl_fluxo_w,0));
	end if;
end loop;
close c02;	


nr_ordem_compra_ant_w			:= 0;
vl_saldo_mercadoria_w			:= 0;

open c010;
loop
fetch c010 into
	nr_ordem_compra_w,
	cd_cond_pagto_w,
	cd_moeda_w,
	cd_conta_financ_w,
	vl_item_liquido_w,
	dt_entrega_w,
	nr_item_oci_w,
	pr_desc_financ_w,
	pr_desc_financ_ordem_w;
EXIT WHEN NOT FOUND; /* apply on c010 */

	select	coalesce(sum(obter_valor_liquido_ordem(nr_ordem_compra)),0)
	into STRICT	vl_total_ordem_w
	from	ordem_compra
	where	nr_ordem_compra = nr_ordem_compra_w;

	SELECT * FROM Calcular_Vencimento(
		cd_estabelecimento_p, cd_cond_pagto_w, dt_entrega_w, qt_vencimento_w, ds_vencimento_w) INTO STRICT qt_vencimento_w, ds_vencimento_w;		

	vl_fluxo_w	:= dividir_sem_round(vl_item_liquido_w, qt_vencimento_w);

	if (coalesce(pr_desc_financ_w,0) > 0) then
		vl_fluxo_w		:= vl_fluxo_w - ((pr_desc_financ_w / 100) * vl_fluxo_w);
	end if;

	if (coalesce(pr_desc_financ_ordem_w,0) > 0) then
		vl_fluxo_w		:= vl_fluxo_w - ((pr_desc_financ_ordem_w / 100) * vl_fluxo_w);
	end if;

	WHILE(length(ds_vencimento_w) > 3) LOOP

		dt_referencia_w	:= To_Date(substr(ds_vencimento_w,1,10),'dd/mm/yyyy');
		ds_vencimento_w	:= substr(ds_vencimento_w, 12, length(ds_vencimento_w));		

		if (cd_moeda_padrao_w <> cd_moeda_w) then
			select	Obter_Valor_Moeda_Nac(cd_estabelecimento_p,
				vl_fluxo_w,
				cd_moeda_w,
				dt_referencia_w)
			into STRICT	vl_fluxo_w
			;

		end if;
		dt_orig_referencia_w := dt_referencia_w;
		if (ie_tratar_fim_semana_w = 'S') then
			dt_referencia_w			:= obter_proximo_dia_util(cd_estabelecimento_p, dt_referencia_w);
		end if;

		if (ie_somente_futuro_w = 'N') or (dt_referencia_w >= trunc(clock_timestamp(),'dd')) then

			if (ie_oc_parcial_w = 'S') then
				if (nr_ordem_compra_w <> nr_ordem_compra_ant_w) then
					select	coalesce(sum(vl_vencimento),0)
					into STRICT	vl_venc_ant_w
					from	ordem_compra_venc
					where	nr_ordem_compra	= nr_ordem_compra_w
					and	dt_vencimento	< dt_orig_referencia_w;

					select	coalesce(sum(a.vl_mercadoria),0)
					into STRICT	vl_saldo_mercadoria_w
					from	nota_fiscal a
					where	a.nr_ordem_compra	= nr_ordem_compra_w
					and	exists (SELECT	1 from titulo_pagar x where x.nr_seq_nota_fiscal = a.nr_sequencia);
					if (vl_venc_ant_w > vl_saldo_mercadoria_w) then
						vl_saldo_mercadoria_w	:= 0;
					else
						vl_saldo_mercadoria_w	:= vl_saldo_mercadoria_w - vl_venc_ant_w;
					end if;
				end if;
				nr_ordem_compra_ant_w		:= nr_ordem_compra_w;
				if (vl_fluxo_w >= vl_saldo_mercadoria_w) then
					vl_fluxo_w		:= vl_fluxo_w - vl_saldo_mercadoria_w;
					vl_saldo_mercadoria_w	:= 0;
				else
					vl_saldo_mercadoria_w	:= vl_saldo_mercadoria_w - vl_fluxo_w;
					vl_fluxo_w		:= 0;
				end if;
			end if;
			
			CALL GERAR_FLUXO_CAIXA_LOTE(	dt_referencia_w,
						cd_conta_financ_w,
						'',
						'18',
						'OC',
						nm_usuario_p,
						null,
						null,
						nr_ordem_compra_w,
						null,
						null,
						null,
						null,
						null,
						nr_seq_lote_fluxo_p,
						null,
						null,
						null,
						null,
						null,
						null,
						null,
						coalesce(vl_fluxo_w,0));
		end if;

	end loop;

end loop;
close c010;

/*NAO COLOCAR COMMIT NESTA PROCEDURE*/

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_fluxo_caixa_lote_oc ( nr_seq_lote_fluxo_p bigint, cd_estabelecimento_p bigint, qt_dia_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, nm_usuario_p text, cd_empresa_p bigint) FROM PUBLIC;
