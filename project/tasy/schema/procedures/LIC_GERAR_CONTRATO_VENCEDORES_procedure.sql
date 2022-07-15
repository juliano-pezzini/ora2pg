-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lic_gerar_contrato_vencedores ( nr_seq_licitacao_p bigint, nr_seq_fornec_p bigint, nr_seq_tipo_contrato_p bigint, nr_seq_subtipo_contrato_p text, cd_cond_pagto_p text, cd_setor_resp_p text, ie_renovacao_p text, cd_pessoa_resp_p text, qt_dias_rescisao_p bigint, dt_inicio_p timestamp, dt_final_p timestamp, cd_estab_regra_p text, cd_centro_custo_p text, nr_seq_proj_rec_p text, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_contrato_w			bigint;
ds_objeto_w			varchar(255);
cd_cgc_fornec_w			varchar(14);
cd_conta_contabil_w		varchar(20);
cd_centro_custo_w			integer;
ie_tipo_conta_w			smallint;
vl_item_w				double precision;
cd_material_w			integer;
nr_seq_lic_contrato_w		bigint;
nr_seq_conta_financeira_w		bigint;
nr_seq_lic_item_w			integer;
nr_seq_regra_contr_w		bigint;

c01 CURSOR FOR
SELECT	distinct
	cd_material,
	vl_item,
	nr_seq_lic_item
from (
	SELECT	a.cd_material,
		a.vl_item,
		b.nr_seq_lic_item
	from	reg_lic_vencedor a,
		reg_lic_homol_itens b
	where	a.nr_seq_licitacao = b.nr_Seq_licitacao
	and	a.nr_seq_lic_item = b.nr_seq_lic_item
	and	a.nr_seq_licitacao = nr_seq_licitacao_p
	and	a.nr_seq_fornec = nr_seq_fornec_p
	and	b.ie_homologado = 'S'
	and	coalesce(b.nr_seq_regra_contr::text, '') = ''
	and	coalesce(a.nr_lote_compra::text, '') = ''
	
union all

	select	distinct
		c.cd_material,
		lic_obter_vl_fim_item_lote(a.nr_seq_licitacao, c.nr_seq_lic_item, a.nr_seq_fornec) vl_item,
		c.nr_seq_lic_item
	from	reg_lic_vencedor a,
		reg_lic_homol_itens b,
		reg_lic_item c
	where	a.nr_seq_licitacao = b.nr_Seq_licitacao
	and	a.nr_seq_lic_item = b.nr_seq_lic_item
	and	a.nr_lote_compra = c.nr_lote_compra
	and	a.nr_seq_licitacao = c.nr_seq_licitacao
	and	a.nr_seq_licitacao = nr_seq_licitacao_p
	and	a.nr_seq_fornec = nr_seq_fornec_p
	and	b.ie_homologado = 'S'
	and	coalesce(b.nr_seq_regra_contr::text, '') = ''
	and	(a.nr_lote_compra IS NOT NULL AND a.nr_lote_compra::text <> '')
	and	(c.cd_material IS NOT NULL AND c.cd_material::text <> '')) alias6;


BEGIN

select	substr(ds_objeto,1,255)
into STRICT	ds_objeto_w
from	reg_licitacao
where	nr_sequencia = nr_seq_licitacao_p;

select	cd_cgc_fornec
into STRICT	cd_cgc_fornec_w
from	reg_lic_fornec
where	nr_sequencia = nr_seq_fornec_p;

select	nextval('contrato_seq')
into STRICT	nr_seq_contrato_w
;

insert into contrato(
	nr_sequencia,
	nr_seq_tipo_contrato,
	nr_seq_subtipo_contrato,
	cd_setor,
	cd_pessoa_resp,
	ds_objeto_contrato,
	dt_atualizacao,
	nm_usuario,
	dt_inicio,
	dt_fim,
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
	cd_condicao_pagamento,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	ie_periodo_nf)
values (	nr_seq_contrato_w,
	nr_seq_tipo_contrato_p,
	nr_seq_subtipo_contrato_p,
	cd_setor_resp_p,
	cd_pessoa_resp_p,
	ds_objeto_w,
	clock_timestamp(),
	nm_usuario_p,
	dt_inicio_p,
	dt_final_p,
	cd_estabelecimento_p,
	'N',
	'S',
	'AT',
	'N',
	'D',
	ie_renovacao_p,
	'A',
	qt_dias_rescisao_p,
	cd_cgc_fornec_w,
	cd_cond_pagto_p,
	clock_timestamp(),
	nm_usuario_p,
	'N');

open c01;
loop
fetch c01 into
	cd_material_w,
	vl_item_w,
	nr_seq_lic_item_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	nr_seq_conta_financeira_w := obter_conta_financeira(
		'S', cd_estabelecimento_p, cd_material_w, null, null, cd_setor_resp_p, null, cd_cgc_fornec_w, cd_centro_custo_w, nr_seq_conta_financeira_w, null, null, null, null, null, nr_seq_proj_rec_p, null, null, null, null, null, null, null, null, null, null, null, null, null);

	if (nr_seq_conta_financeira_w = 0) then
		nr_seq_conta_financeira_w := null;
	end if;

	SELECT * FROM SELECT * FROM define_conta_contabil(2, cd_estabelecimento_p, null, null, null, null, cd_material_w, null, null, null, cd_conta_contabil_w, cd_centro_custo_w, null, clock_timestamp()) INTO STRICT cd_conta_contabil_w, cd_centro_custo_w INTO cd_conta_contabil_w, cd_centro_custo_w;

	if (length(cd_conta_contabil_w) = 0) then
		begin
		ie_tipo_conta_w	:= 3;
		if (coalesce(cd_centro_custo_w::text, '') = '') then
			ie_tipo_conta_w	:= 2;
		end if;
		SELECT * FROM define_conta_material(	cd_estabelecimento_p, cd_material_w, ie_tipo_conta_w, null, null, null, null, null, null, null, null, Null, clock_timestamp(), cd_conta_contabil_w, cd_centro_custo_w, null) INTO STRICT cd_conta_contabil_w, cd_centro_custo_w;
		end;
	end if;

	select	nextval('contrato_regra_nf_seq')
	into STRICT	nr_seq_regra_contr_w
	;

	insert into contrato_regra_nf(
		nr_sequencia,
		nr_seq_contrato,
		dt_atualizacao,
		nm_usuario,
		cd_material,
		dt_inicio_vigencia,
		dt_fim_vigencia,
		vl_pagto,
		cd_estab_regra,
		cd_centro_custo,
		nr_seq_proj_rec,
		cd_conta_contabil,
		ie_gera_sc_automatico,
		ie_libera_solic)
	values (	nr_seq_regra_contr_w,
		nr_seq_contrato_w,
		clock_timestamp(),
		nm_usuario_p,
		cd_material_w,
		dt_inicio_p,
		dt_final_p,
		vl_item_w,
		cd_estab_regra_p,
		cd_centro_custo_p,
		nr_seq_proj_rec_p,
		cd_conta_contabil_w,
		'N',
		'S');

	update	reg_lic_homol_itens
	set	nr_seq_regra_contr	= nr_seq_regra_contr_w
	where	nr_seq_licitacao	= nr_Seq_licitacao_p
	and	nr_seq_lic_item		= nr_seq_lic_item_w;

	end;
end loop;
close c01;

select	nextval('reg_lic_contrato_seq')
into STRICT	nr_seq_lic_contrato_w
;

insert into reg_lic_contrato(
	nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	nr_seq_licitacao,
	nr_seq_contrato)
values (	nextval('reg_lic_contrato_seq'),
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	nr_seq_licitacao_p,
	nr_seq_contrato_w);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lic_gerar_contrato_vencedores ( nr_seq_licitacao_p bigint, nr_seq_fornec_p bigint, nr_seq_tipo_contrato_p bigint, nr_seq_subtipo_contrato_p text, cd_cond_pagto_p text, cd_setor_resp_p text, ie_renovacao_p text, cd_pessoa_resp_p text, qt_dias_rescisao_p bigint, dt_inicio_p timestamp, dt_final_p timestamp, cd_estab_regra_p text, cd_centro_custo_p text, nr_seq_proj_rec_p text, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

