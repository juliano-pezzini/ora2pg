-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_contrato_ordem_compra ( nr_ordem_compra_P bigint, nr_seq_tipo_contrato_p bigint, nr_seq_subtipo_contrato_p bigint, nr_seq_contrato_p INOUT bigint, nm_usuario_p text) AS $body$
DECLARE



cd_pessoa_solicitante_w		varchar(10);
cd_estabelecimento_w		integer;
nr_ordem_compra_w		bigint;
nr_ordem_compra_ww		bigint	:= 0;
nr_item_oci_w			integer;
cd_material_w			integer;
ds_observacao_w			varchar(255);
ds_marca_w			varchar(30) 	:= '';
vl_unitario_w			double precision 	:= 0;
cd_cgc_fornecedor_w		varchar(14);
cd_cond_pagto_w			bigint;
nr_seq_contrato_w		bigint;
nr_seq_tipo_contrato_w		bigint;
cd_pessoa_fisica_w		varchar(10);
nr_seq_marca_w			bigint;
nr_seq_subtipo_contrato_w	bigint;
vl_desconto_w			contrato_regra_nf.vl_desconto%type;
pr_desconto_w			contrato_regra_nf.pr_desconto%type;
cd_setor_atendimento_w	usuario.cd_setor_atendimento%type;
cd_cargo_w				pessoa_fisica.cd_cargo%type;
vl_total_ordem_w		contrato.vl_total_contrato%type;
nm_usuario_w			usuario.nm_usuario%type;
vl_motivo_baixa_w       funcao_param_usuario.vl_parametro%type;
vl_motivo_baixa_ww      motivo_cancel_sc_oc.nr_sequencia%type;
nr_seq_motivo_baixa_w   motivo_cancel_sc_oc.nr_sequencia%type;

c01 CURSOR FOR
SELECT	a.cd_pessoa_solicitante,
	a.cd_estabelecimento,
	a.nr_ordem_compra,
	b.nr_item_oci,
	b.cd_material,
	b.ds_observacao,
	b.ds_marca,
	b.vl_unitario_material,
	coalesce(a.cd_cgc_fornecedor, a.cd_pessoa_fisica),
	a.cd_condicao_pagamento,
	b.vl_desconto,
	b.pr_descontos
from	ordem_compra a,
	ordem_compra_item b
where	a.nr_ordem_compra = b.nr_ordem_compra
and	a.nr_ordem_compra = nr_ordem_compra_p
order by b.nr_item_oci;



BEGIN

nr_seq_tipo_contrato_w := nr_seq_tipo_contrato_p;

if (nr_seq_subtipo_contrato_p = 0) then
	nr_seq_subtipo_contrato_w := null;
else
	nr_seq_subtipo_contrato_w := nr_seq_subtipo_contrato_p;
end if;

open C01;
loop
fetch C01 into	
	cd_pessoa_solicitante_w,
	cd_estabelecimento_w,
	nr_ordem_compra_w,
	nr_item_oci_w,
	cd_material_w,
	ds_observacao_w,
	ds_marca_w,
	vl_unitario_w,
	cd_cgc_fornecedor_w,
	cd_cond_pagto_w,
	vl_desconto_w,
	pr_desconto_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	
	nr_seq_marca_w := null;
	if (ds_marca_w IS NOT NULL AND ds_marca_w::text <> '') then
		select	max(nr_sequencia)
		into STRICT	nr_seq_marca_w
		from	marca
		where	elimina_acentuacao(upper(ds_marca)) = elimina_acentuacao(upper(ds_marca_w));
	end if;
	
	if (nr_ordem_compra_ww <> nr_ordem_compra_w) then
		
		nr_ordem_compra_ww 	:= nr_ordem_compra_w;		
		
		if (length(cd_cgc_fornecedor_w) = 14) then
			cd_cgc_fornecedor_w	:= cd_cgc_fornecedor_w;
			cd_pessoa_fisica_w	:= '';
		else
			cd_pessoa_fisica_w	:= cd_cgc_fornecedor_w;
			cd_cgc_fornecedor_w	:= '';

		end if;
		
		select	nextval('contrato_seq')
		into STRICT	nr_seq_contrato_w
		;
		
		select  max(nm_usuario)
		into STRICT 	nm_usuario_w
		from    usuario
		where   cd_pessoa_fisica = cd_pessoa_solicitante_w;
		
		select 	obter_setor_usuario(nm_usuario_w),
				obter_cargo_usuario(nm_usuario_w, 'C')
		into STRICT 	cd_setor_atendimento_w,
				cd_cargo_w
		;
		
		select  round((coalesce(sum(obter_valor_liquido_ordem(nr_ordem_compra_w)),0))::numeric,2)
		into STRICT 	vl_total_ordem_w
		from    ordem_compra
		where   nr_ordem_compra = nr_ordem_compra_w;
		
		insert into contrato(
			nr_sequencia,
			nr_seq_tipo_contrato,
			nr_seq_subtipo_contrato,
			cd_pessoa_resp,
			ds_objeto_contrato,
			dt_atualizacao,
			nm_usuario,
			cd_estabelecimento,
			ie_avisa_vencimento,
			ie_avisa_venc_setor,
			ie_classificacao,
			ie_avisa_reajuste,
			ie_prazo_contrato,
			ie_renovacao,
			ie_situacao,
			qt_dias_rescisao,
			cd_cgc_contratado,
			cd_pessoa_contratada,
			cd_condicao_pagamento,
			dt_inicio,
			ie_periodo_nf,
			cd_setor,
			cd_cargo,
			vl_total_contrato)
		values (	nr_seq_contrato_w,
			nr_seq_tipo_contrato_w,
			nr_seq_subtipo_contrato_w,
			cd_pessoa_solicitante_w,
			Wheb_mensagem_pck.get_Texto(301315, 'NR_ORDEM_COMPRA_P='||NR_ORDEM_COMPRA_P),			
			clock_timestamp(),
			nm_usuario_p,
			cd_estabelecimento_w,
			'N',
			'S',
			'AT',
			'N',
			'D',
			'A',
			'A',
			90,
			cd_cgc_fornecedor_w,
			cd_pessoa_fisica_w,
			cd_cond_pagto_w,
			clock_timestamp(),
			'N',
			cd_setor_atendimento_w,
			cd_cargo_w,
			vl_total_ordem_w);
		
		insert into contrato_regra_nf(
			nr_sequencia,
			nr_seq_contrato,
			dt_atualizacao,
			nm_usuario,
			cd_material,
			cd_estab_regra,
			ie_tipo_regra,
			nr_ordem_compra,
			nr_item_oci,
			vl_pagto,
			nr_seq_marca,
			ie_gera_sc_automatico,
			IE_LIBERA_SOLIC,
			vl_desconto,
			pr_desconto)
		values (	nextval('contrato_regra_nf_seq'),
			nr_seq_contrato_w,
			clock_timestamp(),
			nm_usuario_p,
			cd_material_w,
			cd_estabelecimento_w,
			'NF',
			nr_ordem_compra_P,
			nr_item_oci_w,
			vl_unitario_w,
			nr_seq_marca_w,
			'N',
			'S',
			vl_desconto_w,
			pr_desconto_w);

	else
		
		insert into contrato_regra_nf(
			nr_sequencia,
			nr_seq_contrato,
			dt_atualizacao,
			nm_usuario,
			cd_material,
			cd_estab_regra,
			ie_tipo_regra,
			nr_ordem_compra,
			nr_item_oci,
			vl_pagto,
			nr_seq_marca,
			ie_gera_sc_automatico,
			IE_LIBERA_SOLIC,
			vl_desconto,
			pr_desconto)
		values (	nextval('contrato_regra_nf_seq'),
			nr_seq_contrato_w,
			clock_timestamp(),
			nm_usuario_p,
			cd_material_w,
			cd_estabelecimento_w,
			'NF',
			nr_ordem_compra_p,
			nr_item_oci_w,
			vl_unitario_w,
			nr_seq_marca_w,
			'N',
			'S',
			vl_desconto_w,
			pr_desconto_w);

	end if;
	end;
end loop;
close c01;

vl_motivo_baixa_w	:= Obter_Valor_Param_Usuario(917, 240, obter_perfil_ativo, nm_usuario_p, obter_estabelecimento_ativo);
nr_seq_motivo_baixa_w := null;

begin
    vl_motivo_baixa_ww := (vl_motivo_baixa_w)::numeric;
exception when others then
    vl_motivo_baixa_ww := null;
end;

if (vl_motivo_baixa_ww IS NOT NULL AND vl_motivo_baixa_ww::text <> '') then
    select max(nr_sequencia)
    into STRICT nr_seq_motivo_baixa_w
    from motivo_cancel_sc_oc
    where nr_sequencia = vl_motivo_baixa_ww
	and ie_situacao = 'A'
    and ie_ordem_compra = 'S';
end if;

if (nr_seq_motivo_baixa_w IS NOT NULL AND nr_seq_motivo_baixa_w::text <> '') then
    CALL baixar_ordem_compra(nr_ordem_compra_p, nr_seq_motivo_baixa_w, null, nm_usuario_p);
end if;

nr_seq_contrato_p := nr_seq_contrato_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_contrato_ordem_compra ( nr_ordem_compra_P bigint, nr_seq_tipo_contrato_p bigint, nr_seq_subtipo_contrato_p bigint, nr_seq_contrato_p INOUT bigint, nm_usuario_p text) FROM PUBLIC;
