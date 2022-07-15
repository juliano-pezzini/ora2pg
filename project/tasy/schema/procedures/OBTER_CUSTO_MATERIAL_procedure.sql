-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_custo_material ( cd_estabelecimento_p bigint, cd_material_p bigint, cd_estab_custo_p bigint, cd_tabela_custo_p bigint, cd_setor_atendimento_p bigint, cd_convenio_p bigint, vl_material_p bigint, ds_criterio_p text, qt_dia_p bigint, dt_referencia_p timestamp, ie_apuracao_custo_p INOUT text, vl_custo_p INOUT bigint, pr_imposto_p INOUT bigint, vl_original_p bigint, ie_tipo_atendimento_p bigint, nr_interno_conta_p bigint, ie_gerar_log_p text, nr_seq_item_p bigint, vl_repasse_terceiro_p bigint, vl_repasse_calc_p bigint, ie_responsavel_credito_p text) AS $body$
DECLARE


vl_custo_w			double precision	:= 0;
i				integer;
k				integer;
cd_material_w			integer	:= cd_material_p;
qt_conv_est_cons_w		double precision	:= 1;
dt_referencia_w			timestamp;
cd_grupo_material_w		smallint	:= 0;
cd_subgrupo_material_w		smallint	:= 0;
cd_classe_material_w		integer	:= 0;
pr_aplicar_w			regra_aloc_custo_setor.pr_aplicar%type := 100;
ie_calculo_custo_w		regra_aloc_custo_setor.ie_calculo_custo%type := 'S';
ds_criterio_w			varchar(3);
pr_imposto_w			regra_aloc_custo_setor.pr_imposto%type := 0;
cd_setor_atendimento_w		bigint	:= cd_setor_atendimento_p;
ie_tipo_atendimento_w		smallint	:= ie_tipo_atendimento_p;
cd_estab_execucao_w		estabelecimento.cd_estabelecimento%type;
cd_estab_custo_w		estabelecimento.cd_estabelecimento%type;
cd_tabela_custo_w		tabela_custo.cd_tabela_custo%type := cd_tabela_custo_p;
ie_somente_tab_real_w		parametro_custo.ie_somente_tab_real%type;
ds_log_w			varchar(4000);
ie_sobrepor_custo_consig_w	regra_aloc_custo_setor.ie_sobrepor_custo_consig%type := 'N';

c01 CURSOR FOR
SELECT	ie_calculo_custo,
	coalesce(pr_aplicar,100),
	coalesce(vl_custo,0),
	coalesce(ds_criterio_aloc_mat, ds_criterio_p),
	coalesce(pr_imposto, 0),
	coalesce(ie_sobrepor_custo_consig,'N') ie_sobrepor_custo_consig
from 	regra_aloc_custo_setor
where 	cd_setor_atendimento				= cd_setor_atendimento_w
and	cd_estabelecimento				= cd_estab_custo_w
and	coalesce(cd_convenio, cd_convenio_p)			= cd_convenio_p
and	coalesce(ie_tipo_atendimento, ie_tipo_atendimento_w)	= ie_tipo_atendimento_w
and	coalesce(cd_grupo_material, cd_grupo_material_w)	= cd_grupo_material_w
and	coalesce(cd_subgrupo_material,cd_subgrupo_material_w)= cd_subgrupo_material_w
and	coalesce(cd_classe_material, cd_classe_material_w)	= cd_classe_material_w
and	coalesce(cd_material, cd_material_w)			= cd_material_w
and (coalesce(cd_grupo_material, 0) + coalesce(cd_subgrupo_material, 0) + coalesce(cd_classe_material, 0) + coalesce(cd_material, 0)) > 0
and (coalesce(dt_inicio_vigencia, dt_referencia_p) <= dt_referencia_p and coalesce(dt_fim_vigencia, dt_referencia_p) >= dt_referencia_p)
and	coalesce(ie_responsavel_credito, coalesce(ie_responsavel_credito_p,'0')) = coalesce(ie_responsavel_credito_p,'0')
and	((coalesce(vl_custo_p,0) = 0) or (coalesce(ie_sobrepor_custo_consig,'N') = 'S'))
order by 	coalesce(ie_responsavel_credito,'A'),
		coalesce(cd_convenio,0),
		coalesce(cd_material,0),
		coalesce(cd_classe_material,0),
		coalesce(cd_subgrupo_material,0),
		coalesce(cd_grupo_material,0);


BEGIN

if (nr_interno_conta_p IS NOT NULL AND nr_interno_conta_p::text <> '') and (ie_gerar_log_p = 'S') then
	insert into cus_log_custo_item(
			nr_sequencia,
			nr_seq_item,
			nr_interno_conta,
			nm_usuario,
			ie_informacao,
			dt_atualizacao,
			ds_log,
			ie_tipo)
	values (	nextval('cus_log_custo_item_seq'),
			nr_seq_item_p,
			nr_interno_conta_p,
			wheb_usuario_pck.get_nm_usuario,
			0,
			clock_timestamp(),
			'++Procedure OBTER_CUSTO_MATERIAL'
,
			2);

	ds_log_w :=	';cd_estabelecimento_p='||cd_estabelecimento_p||
			';cd_material_p='||cd_material_p||
			';cd_estab_custo_p='||cd_estab_custo_p||
			';cd_tabela_custo_p='||cd_tabela_custo_p||
			';cd_setor_atendimento_p='||cd_setor_atendimento_p||
			';cd_convenio_p='||cd_convenio_p||
			';vl_material_p='||vl_material_p||
			';ds_criterio_p='||ds_criterio_p||
			';qt_dia_p='||qt_dia_p||
			';dt_referencia_p='||dt_referencia_p||
			';vl_original_p='||vl_original_p||
			';ie_tipo_atendimento_p='||ie_tipo_atendimento_p||
			';ie_responsavel_credito_p='||
			';vl_custo_p=';
end if;

ie_tipo_atendimento_w	:= coalesce(ie_tipo_atendimento_p,1);

/* Matheus 10/07/2008 Controle Setor de Custo*/

select	coalesce(max(cd_setor_custo),cd_setor_atendimento_p)
into STRICT	cd_setor_atendimento_w
from	setor_atendimento
where	cd_setor_atendimento	= cd_setor_atendimento_p;

ds_criterio_w		:= ds_criterio_p;

if (length(ds_criterio_w) <> 3) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(198925);


end if;
dt_referencia_w			:= pkg_date_utils.start_of(dt_referencia_p,'MONTH', 0);

select	coalesce(cd_classe_material,0),
	coalesce(cd_subgrupo_material,0),
	coalesce(cd_grupo_material,0)
into STRICT	cd_classe_material_w,
	cd_subgrupo_material_w,
	cd_grupo_material_w
from	estrutura_material_v
where	cd_material	= cd_material_p;

vl_custo_w		:= 0;
ie_calculo_custo_w	:= 'X';

--estabelecimento do setor de execucao (setor do conta_paciente_resumo)
select	coalesce(max(cd_estabelecimento_base),cd_estabelecimento_p)
into STRICT	cd_estab_execucao_w
from	setor_atendimento
where	cd_setor_atendimento = cd_setor_atendimento_p;

--estabelecimento do setor de custo
select	coalesce(max(cd_estabelecimento_base),cd_estabelecimento_p)
into STRICT	cd_estab_custo_w
from	setor_atendimento
where	cd_setor_atendimento = cd_setor_atendimento_w;

begin
select	ie_somente_tab_real
into STRICT	ie_somente_tab_real_w
from 	parametro_custo
where	cd_estabelecimento = cd_estabelecimento_p;
exception when others then
	ie_somente_tab_real_w := 'N';
end;

if (cd_estab_execucao_w <> cd_estab_custo_w)	then
	select	max(cd_tabela_custo)
	into STRICT	cd_tabela_custo_w
	from	tabela_custo
	where	dt_mes_referencia 	= dt_referencia_w
	and	cd_tipo_tabela_custo	= 9
	and	cd_estabelecimento	= cd_estab_custo_w
	and	ie_situacao = 'A'
	and 	((ie_somente_tab_real_w = 'N') or (ie_somente_tab_real_w = 'S' AND ie_orcado_real = 'R'));
end	if;

if (nr_interno_conta_p IS NOT NULL AND nr_interno_conta_p::text <> '') and (ie_gerar_log_p = 'S') then
	ds_log_w :=	substr(ds_log_w || ';cd_classe_material='||cd_classe_material_w||
			';cd_subgrupo_material='||cd_subgrupo_material_w||
			';cd_grupo_material'||cd_grupo_material_w||
			';cd_setor_atendimento_w='||cd_setor_atendimento_w||
			';cd_estab_custo_w='||cd_estab_custo_w||
			';cd_estab_execucao_w='||cd_estab_execucao_w||
			';ie_somente_tab_real_w='||ie_somente_tab_real_w||
			';cd_tabela_custo_w='||cd_tabela_custo_w,1,4000);

	insert into cus_log_custo_item(
			nr_sequencia,
			nr_seq_item,
			nr_interno_conta,
			nm_usuario,
			ie_informacao,
			dt_atualizacao,
			ds_log,
			ie_tipo)
	values (	nextval('cus_log_custo_item_seq'),
			nr_seq_item_p,
			nr_interno_conta_p,
			wheb_usuario_pck.get_nm_usuario,
			1,
			clock_timestamp(),
			substr(ds_log_w,1,4000),
			2);

	insert into cus_log_custo_item(
			nr_sequencia,
			nr_seq_item,
			nr_interno_conta,
			nm_usuario,
			ie_informacao,
			dt_atualizacao,
			ds_log,
			ie_tipo)
	values (	nextval('cus_log_custo_item_seq'),
			nr_seq_item_p,
			nr_interno_conta_p,
			wheb_usuario_pck.get_nm_usuario,
			2,
			clock_timestamp(),
			'++Procedure ATUALIZAR_CUSTO_CONTA - Cursor C01'
,
			2);
end if;

open c01;
loop
fetch c01 into
	ie_calculo_custo_w,
	pr_aplicar_w,
	vl_custo_w,
	ds_criterio_w,
	pr_imposto_w,
	ie_sobrepor_custo_consig_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	ie_calculo_custo_w	:= ie_calculo_custo_w;
	if (nr_interno_conta_p IS NOT NULL AND nr_interno_conta_p::text <> '') and (ie_gerar_log_p = 'S') then
		ds_log_w := 	';ie_calculo_custo_w='||ie_calculo_custo_w||
				';pr_aplicar_w='||pr_aplicar_w||
				';vl_custo_w='||vl_custo_w||
				';ds_criterio_w='||ds_criterio_w||
				';pr_imposto_w='||pr_imposto_w||
				';ie_sobrepor_custo_consig_w='||ie_sobrepor_custo_consig_w;

	insert into cus_log_custo_item(
			nr_sequencia,
			nr_seq_item,
			nr_interno_conta,
			nm_usuario,
			ie_informacao,
			dt_atualizacao,
			ds_log)
	values (	nextval('cus_log_custo_item_seq'),
			nr_seq_item_p,
			nr_interno_conta_p,
			wheb_usuario_pck.get_nm_usuario,
			3,
			clock_timestamp(),
			substr(ds_log_w,1,4000));
	end if;
	end;
end loop;
close c01;

for i in 1.. 3 loop
	begin
	dt_referencia_w			:= pkg_date_utils.start_of(dt_referencia_p,'MONTH', 0);
	/*    obter o custo da tabela de custo */

	if (vl_custo_w = 0) and (substr(ds_criterio_w,i,1) = 'T') then
		begin
		qt_conv_est_cons_w		:= 1;

		select	coalesce(max(vl_custo_total),0)
		into STRICT	vl_custo_w
		from	preco_padrao_mat_v
		where	cd_estabelecimento	= cd_estab_custo_w
		and	cd_tabela_custo		= cd_tabela_custo_w
		and	cd_material	 	= cd_material_p
		and	ie_calcula_conta	= 'S';
		end;
	end if;
	/*    obter o ultima compra (reposicao) ou estoque */

	if (vl_custo_w = 0) and (substr(ds_criterio_w,i,1) <> 'T') then
		begin

		select	coalesce(max(qt_conv_estoque_consumo),1),
			coalesce(max(cd_material_estoque), cd_material_p)
		into STRICT	qt_conv_est_cons_w,
			cd_material_w
		from 	material
		where	cd_material	= cd_material_p;

		for k in 1..4 loop
			begin
			if (vl_custo_w = 0) then
				select	coalesce(max(vl_custo),0)
				into STRICT	vl_custo_w
				from	custo_mensal_material
				where	cd_estabelecimento	= cd_estab_custo_w
				and	dt_referencia		= dt_referencia_w
				and	cd_material		= cd_material_w
				and	ie_tipo_custo		= substr(ds_criterio_w,i,1);
			end if;
			dt_referencia_w		:= pkg_date_utils.add_month(dt_referencia_w, -1, 0);
			end;
		end loop;
		end;
	end if;
	end;
end loop;

/*	ie_calculo_custo
	s - obter custo com base no valor
	p - percentual sobre a receita
*/
if (ie_calculo_custo_w = 'P') then
	begin
	vl_custo_w 			:= pr_aplicar_w * vl_material_p / 100;
	ie_apuracao_custo_p		:= 'P';
	end;
elsif (ie_calculo_custo_w = 'S') then
	begin
	vl_custo_w			:= (vl_custo_w * pr_aplicar_w / 100);
	end;
elsif (ie_calculo_custo_w = 'O') then
	begin
	vl_custo_w 			:= dividir(pr_aplicar_w * coalesce(vl_original_p,vl_material_p),100);
	ie_apuracao_custo_p		:= 'P';
	end;
elsif (ie_calculo_custo_w = 'R') then
	begin
	vl_custo_w := coalesce(vl_repasse_terceiro_p,0);
	ie_apuracao_custo_p		:= 'P';
	end;
elsif (ie_calculo_custo_w = 'C') then
	begin
	vl_custo_w := coalesce(vl_repasse_calc_p,0);
	ie_apuracao_custo_p		:= 'P';
	end;
end if;

if (ie_apuracao_custo_p = 'P') then
	vl_custo_w			:= vl_custo_w;
else
	vl_custo_w			:= dividir(vl_custo_w, qt_conv_est_cons_w);
end if;
if (ie_sobrepor_custo_consig_w = 'N') and (coalesce(vl_custo_p,0) <> 0) then
	begin
	vl_custo_p	:= vl_custo_p;
	pr_imposto_p	:= 0;
	end;
else
	begin
	vl_custo_p	:= coalesce(vl_custo_w,0);
	pr_imposto_p	:= pr_imposto_w;
	end;
end if;

if (nr_interno_conta_p IS NOT NULL AND nr_interno_conta_p::text <> '') and (ie_gerar_log_p = 'S') then
	ds_log_w :=	';vl_custo_p='||vl_custo_p||
			';pr_imposto_p='||pr_imposto_p;

	insert into cus_log_custo_item(
			nr_sequencia,
			nr_seq_item,
			nr_interno_conta,
			nm_usuario,
			ie_informacao,
			dt_atualizacao,
			ds_log,
			ie_tipo)
	values (	nextval('cus_log_custo_item_seq'),
			nr_seq_item_p,
			nr_interno_conta_p,
			wheb_usuario_pck.get_nm_usuario,
			4,
			clock_timestamp(),
			substr(ds_log_w,1,4000),
			2);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_custo_material ( cd_estabelecimento_p bigint, cd_material_p bigint, cd_estab_custo_p bigint, cd_tabela_custo_p bigint, cd_setor_atendimento_p bigint, cd_convenio_p bigint, vl_material_p bigint, ds_criterio_p text, qt_dia_p bigint, dt_referencia_p timestamp, ie_apuracao_custo_p INOUT text, vl_custo_p INOUT bigint, pr_imposto_p INOUT bigint, vl_original_p bigint, ie_tipo_atendimento_p bigint, nr_interno_conta_p bigint, ie_gerar_log_p text, nr_seq_item_p bigint, vl_repasse_terceiro_p bigint, vl_repasse_calc_p bigint, ie_responsavel_credito_p text) FROM PUBLIC;

