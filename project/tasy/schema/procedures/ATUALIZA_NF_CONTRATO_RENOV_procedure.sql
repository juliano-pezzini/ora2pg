-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_nf_contrato_renov ( nr_seq_renovacao_p bigint, nr_seq_contrato_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


dt_renovacao_w	contrato_renovacao.dt_renovacao%type;

/*contrato_regra_nf*/

nr_seq_contrato_nf_nova_w	contrato_regra_nf.nr_sequencia%type;
nr_seq_contrato_nf_atual_w	contrato_regra_nf.nr_sequencia%type;
cd_estab_regra_w		contrato_regra_nf.cd_estab_regra%type;
cd_material_w			contrato_regra_nf.cd_material%type;
nr_seq_equipamento_w		contrato_regra_nf.nr_seq_equipamento%type;
cd_conta_contabil_w		contrato_regra_nf.cd_conta_contabil%type;
cd_centro_custo_w		contrato_regra_nf.cd_centro_custo%type;
nr_seq_conta_financ_w		contrato_regra_nf.nr_seq_conta_financ%type;
nr_seq_proj_rec_w		contrato_regra_nf.nr_seq_proj_rec%type;
nr_seq_marca_w			contrato_regra_nf.nr_seq_marca%type;
cd_local_estoque_w		contrato_regra_nf.cd_local_estoque%type;
nr_seq_crit_rateio_w		contrato_regra_nf.nr_seq_crit_rateio%type;
cd_natureza_operacao_w		contrato_regra_nf.cd_natureza_operacao%type;
cd_unidade_medida_compra_w	contrato_regra_nf.cd_unidade_medida_compra%type;
vl_pagto_w			contrato_regra_nf.vl_pagto%type;
pr_variacao_valor_w		contrato_regra_nf.pr_variacao_valor%type;
qt_conversao_nf_w		contrato_regra_nf.qt_conversao_nf%type;
ie_conversao_nf_w		contrato_regra_nf.ie_conversao_nf%type;
vl_saldo_total_w		contrato_regra_nf.vl_saldo_total%type;
qt_material_fixa_w		contrato_regra_nf.qt_material_fixa%type;
ie_preco_w			contrato_regra_nf.ie_preco%type;
ie_quantidade_w			contrato_regra_nf.ie_quantidade%type;
qt_dias_entrega_w		contrato_regra_nf.qt_dias_entrega%type;
dt_entrega_w			contrato_regra_nf.dt_entrega%type;
ie_permite_adiant_w		contrato_regra_nf.ie_permite_adiant%type;
pr_permitido_adiant_w		contrato_regra_nf.pr_permitido_adiant%type;
dt_inicio_vigencia_w		contrato_regra_nf.dt_inicio_vigencia%type;
dt_inicio_vigencia_ww		contrato_regra_nf.dt_inicio_vigencia%type;
dt_fim_vigencia_ww		contrato_regra_nf.dt_fim_vigencia%type;
dt_rescisao_w			contrato.dt_fim%type;
dt_fim_vigencia_w			contrato_regra_nf.dt_fim_vigencia%type;
ds_observacao_w			contrato_regra_nf.ds_observacao%type;
ie_situacao_w			contrato.ie_situacao%type;
dt_fim_renovacao_w		contrato_renovacao.dt_fim_renovacao%type;
dt_fim_contrato_w		contrato.dt_fim%type;
ie_atualiza_vigencia_w		funcao_param_usuario.vl_parametro%type;
vl_desconto_w			contrato_regra_nf.vl_desconto%type;
pr_desconto_w			contrato_regra_nf.pr_desconto%type;

C01 CURSOR FOR
	SELECT	b.cd_estab_regra,
		b.cd_material,
		b.nr_seq_equipamento,
		b.cd_conta_contabil,
		b.cd_centro_custo,
		b.nr_seq_conta_financ,
		b.nr_seq_proj_rec,
		b.nr_seq_marca,
		b.cd_local_estoque,
		b.nr_seq_crit_rateio,
		b.cd_natureza_operacao,
		b.cd_unidade_medida_compra,
		b.vl_pagto,
		b.pr_variacao_valor,
		b.qt_conversao_nf,
		b.ie_conversao_nf,
		b.vl_saldo_total,
		b.qt_material_fixa,
		b.ie_preco,
		b.ie_quantidade,
		b.qt_dias_entrega,
		b.dt_entrega,
		b.ie_permite_adiant,
		b.pr_permitido_adiant,
		b.nr_sequencia,
		b.dt_inicio_vigencia,
		b.dt_fim_vigencia,
		b.ds_observacao,
		a.dt_fim,
		b.vl_desconto,
		b.pr_desconto
	FROM	contrato a,
		contrato_regra_nf b
	WHERE	a.nr_sequencia = b.nr_seq_contrato
	and	ie_atualiza_vigencia_w <> 'D'
	AND	b.nr_seq_contrato = nr_seq_contrato_p
	AND	coalesce(b.ie_tipo_regra,'NF') = 'NF'
	AND	((dt_renovacao_w >= b.dt_inicio_vigencia
	AND	b.dt_fim_vigencia >= TRUNC(clock_timestamp())
	AND	dt_renovacao_w <= b.dt_fim_vigencia	
	and	dt_fim_renovacao_w > trunc(clock_timestamp()))
	--and	((b.dt_fim_vigencia > dt_fim_renovacao_w) and (dt_fim_renovacao_w > trunc(sysdate)) and dt_fim_renovacao_w is not null))
	OR (coalesce(b.dt_fim_vigencia::text, '') = '' or coalesce(b.dt_inicio_vigencia::text, '') = ''))
    and (coalesce(b.ie_situacao::text, '') = '' or b.ie_situacao = 'A');
	

BEGIN

ie_atualiza_vigencia_w	:= obter_valor_param_usuario(1200, 81, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p);

select	b.dt_renovacao,
	a.dt_fim, --dt_rescisao
	a.ie_situacao,
	coalesce(b.dt_fim_renovacao,dt_renovacao+365)	
into STRICT	dt_renovacao_w,
	dt_rescisao_w,
	ie_situacao_w,
	dt_fim_renovacao_w
from	contrato a,
	contrato_renovacao b
where	a.nr_sequencia = b.nr_seq_contrato
and	b.nr_sequencia = nr_seq_renovacao_p;


if (coalesce(ie_situacao_w,'A') = 'I') and (dt_fim_renovacao_w >= clock_timestamp()) then	
	
	update	contrato
	set	ie_situacao = 'A'
	where 	nr_sequencia = nr_seq_contrato_p;
	
end if;


open C01;
loop
fetch C01 into
	cd_estab_regra_w,
	cd_material_w,
	nr_seq_equipamento_w,
	cd_conta_contabil_w,
	cd_centro_custo_w,
	nr_seq_conta_financ_w,
	nr_seq_proj_rec_w,
	nr_seq_marca_w,
	cd_local_estoque_w,
	nr_seq_crit_rateio_w,
	cd_natureza_operacao_w,
	cd_unidade_medida_compra_w,
	vl_pagto_w,
	pr_variacao_valor_w,
	qt_conversao_nf_w,
	ie_conversao_nf_w,
	vl_saldo_total_w,
	qt_material_fixa_w,
	ie_preco_w,
	ie_quantidade_w,
	qt_dias_entrega_w,
	dt_entrega_w,
	ie_permite_adiant_w,
	pr_permitido_adiant_w,
	nr_seq_contrato_nf_atual_w,
	dt_inicio_vigencia_w,
	dt_fim_vigencia_w,
	ds_observacao_w,
	dt_fim_contrato_w,
	vl_desconto_w,
	pr_desconto_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	dt_inicio_vigencia_ww := null;
	dt_fim_vigencia_ww := null;
	
	if (ds_observacao_w IS NOT NULL AND ds_observacao_w::text <> '') then
		ds_observacao_w := substr(ds_observacao_w || chr(13) || chr(10) || wheb_mensagem_pck.get_texto(334455, 'NR_SEQ_RENOVACAO_W=' || nr_seq_renovacao_p),1,255);
	else
		ds_observacao_w := substr(wheb_mensagem_pck.get_texto(334455, 'NR_SEQ_RENOVACAO_W=' || nr_seq_renovacao_p),1,255);
	end if;
			
	dt_inicio_vigencia_ww := dt_inicio_vigencia_w;
	dt_fim_vigencia_ww := dt_fim_vigencia_w;

	
	if ((coalesce(dt_fim_vigencia_w::text, '') = '') and (coalesce(dt_inicio_vigencia_w::text, '') = '')) then
		dt_fim_vigencia_ww := dt_renovacao_w - 1;
		dt_inicio_vigencia_ww:= dt_renovacao_w - 1;
	elsif ((coalesce(dt_inicio_vigencia_w::text, '') = '') and (dt_fim_vigencia_w IS NOT NULL AND dt_fim_vigencia_w::text <> '')) then
		dt_inicio_vigencia_ww:= dt_fim_vigencia_w;	
		dt_fim_vigencia_ww := dt_fim_vigencia_w;
	elsif ((dt_inicio_vigencia_w IS NOT NULL AND dt_inicio_vigencia_w::text <> '') and (coalesce(dt_fim_vigencia_w::text, '') = '')) then
		dt_inicio_vigencia_ww := dt_inicio_vigencia_w;
		dt_fim_vigencia_ww := dt_renovacao_w - 1;
	elsif ((dt_inicio_vigencia_w IS NOT NULL AND dt_inicio_vigencia_w::text <> '') and (dt_fim_vigencia_w IS NOT NULL AND dt_fim_vigencia_w::text <> '') and (dt_fim_vigencia_w > clock_timestamp()) and (dt_fim_vigencia_w > dt_renovacao_w)) then
		--(dt_fim_vigencia_w < nvl(dt_rescisao_w,dt_renovacao_w+365))) then  --29/03/2016 - 30/12/2015
		--if (dt_inicio_vigencia_ww > dt_renovacao_w - 1) then --Para garantir que a data fim de vigencia nao seja menor que a data inicial, se for, foi tratado para deixar a adata fim igual a data inicial
		--if (dt_inicio_vigencia_ww = dt_renovacao_w - 1) then --Para garantir que a data fim de vigencia nao seja menor que a data inicial, se for, foi tratado para deixar a adata fim igual a data inicial		
		if (dt_inicio_vigencia_w = dt_renovacao_w) then
			dt_fim_vigencia_ww := coalesce(dt_rescisao_w,dt_renovacao_w+365);			
		elsif (dt_renovacao_w - 1 < dt_inicio_vigencia_ww) then
			dt_fim_vigencia_ww := dt_inicio_vigencia_ww;			
		else
			dt_fim_vigencia_ww := dt_renovacao_w - 1;
		end if;

	end if;
	
	
	update	contrato_regra_nf
	set 	dt_fim_vigencia = dt_fim_vigencia_ww,
		dt_inicio_vigencia = dt_inicio_vigencia_ww,
		nm_usuario = nm_usuario_p,
		dt_atualizacao = clock_timestamp(),
		ds_observacao = ds_observacao_w
	where	nr_sequencia = nr_seq_contrato_nf_atual_w;

	

/*	update	contrato_regra_nf
	set 	dt_fim_vigencia = dt_renovacao_w - 1,
		--dt_inicio_vigencia = nvl(dt_inicio_vigencia_w,dt_renovacao_w-2),
		nm_usuario = nm_usuario_p,
		dt_atualizacao = clock_timestamp()
	where	nr_sequencia = nr_seq_contrato_nf_atual_w
	and	(dt_inicio_vigencia IS NOT NULL AND dt_inicio_vigencia::text <> '');
	--and	dt_fim_vigencia is null*/
	

		if (dt_inicio_vigencia_w <> dt_renovacao_w) then
	
			select nextval('contrato_regra_nf_seq')
			into STRICT nr_seq_contrato_nf_nova_w
			;
			
			insert into contrato_regra_nf(
					nr_sequencia,
					cd_estab_regra,
					cd_material,
					nr_seq_equipamento,
					cd_conta_contabil,
					cd_centro_custo,
					nr_seq_conta_financ,
					nr_seq_proj_rec,
					nr_seq_marca,
					cd_local_estoque,
					nr_seq_crit_rateio,
					cd_natureza_operacao,
					cd_unidade_medida_compra,
					vl_pagto,
					pr_variacao_valor,
					qt_conversao_nf,
					ie_conversao_nf,
					vl_saldo_total,
					qt_material_fixa,
					ie_preco,
					ie_quantidade,
					qt_dias_entrega,
					dt_entrega,
					ie_permite_adiant,
					pr_permitido_adiant,
					nm_usuario,
					dt_atualizacao,
					dt_inicio_vigencia,
					dt_fim_vigencia,
					nr_seq_contrato,
					ds_observacao,
					ie_gera_sc_automatico,
					vl_desconto,
					pr_desconto,
                    ie_situacao)
				values (	nr_seq_contrato_nf_nova_w,
					cd_estab_regra_w,
					cd_material_w,
					nr_seq_equipamento_w,
					cd_conta_contabil_w,
					cd_centro_custo_w,
					nr_seq_conta_financ_w,
					nr_seq_proj_rec_w,
					nr_seq_marca_w,
					cd_local_estoque_w,
					nr_seq_crit_rateio_w,
					cd_natureza_operacao_w,
					cd_unidade_medida_compra_w,
					vl_pagto_w,
					pr_variacao_valor_w,
					qt_conversao_nf_w,
					ie_conversao_nf_w,
					vl_saldo_total_w,
					qt_material_fixa_w,
					ie_preco_w,
					ie_quantidade_w,
					qt_dias_entrega_w,
					dt_entrega_w,
					ie_permite_adiant_w,
					pr_permitido_adiant_w,
					nm_usuario_p,
					clock_timestamp(),
					dt_renovacao_w,
					coalesce(dt_rescisao_w,dt_renovacao_w+365),
					nr_seq_contrato_p,
					wheb_mensagem_pck.get_texto(334454, 'NR_SEQ_RENOVACAO_W=' || nr_seq_renovacao_p),
					'N',
					vl_desconto_w,
					pr_desconto_w,
                    'A');
					
			if (nr_seq_contrato_nf_atual_w IS NOT NULL AND nr_seq_contrato_nf_atual_w::text <> '') and (coalesce(cd_estab_regra_w,0) > 0) then
				insert into contrato_regra_nf_estab(nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					nr_seq_regra_nf,
					cd_estab_regra)
				SELECT	nextval('contrato_regra_nf_estab_seq'),
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					nr_seq_contrato_nf_nova_w,
					cd_estab_regra
				from	contrato_regra_nf_estab
				where	nr_seq_regra_nf = nr_seq_contrato_nf_atual_w;
			end if;
	
		end if;
	
	end;
end loop;
close C01;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_nf_contrato_renov ( nr_seq_renovacao_p bigint, nr_seq_contrato_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

