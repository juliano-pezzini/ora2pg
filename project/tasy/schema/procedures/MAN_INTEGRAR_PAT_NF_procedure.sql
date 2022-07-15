-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_integrar_pat_nf ( nr_sequencia_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, nr_seq_local_p bigint, nr_seq_tipo_equip_p bigint, nr_seq_planej_p bigint, nr_seq_trab_p bigint, cd_centro_custo_p bigint, ie_prioridade_p text) AS $body$
DECLARE

 
ds_equipamento_w		varchar(80);
dt_aquisicao_w		timestamp;
vl_aquisicao_w		double precision;
cd_moeda_w		bigint;
nr_sequencia_w		bigint;
nr_seq_bem_w		bigint;
cd_fornecedor_w		varchar(14);
cd_bem_w		varchar(20);
ds_marca_w		varchar(50);
nr_seq_nota_w		bigint;
nr_seq_item_w		integer;
cd_imobilizado_w		varchar(20);
cd_serie_w		varchar(20);
dt_inicio_garantia_w	timestamp;
dt_fim_garantia_w		timestamp;
nr_seq_modelo_w		bigint;
nr_seq_marca_w		bigint;
nr_seq_fabricante_w	bigint;
ds_modelo_w		varchar(50);
nr_nota_fiscal_w		varchar(20);
cd_lote_fabricacao_w	varchar(20);
nr_seq_lote_fornec_w	bigint;
cd_material_w		integer;

 

BEGIN 
 
select	cd_moeda_padrao 
into STRICT	cd_moeda_w 
from	parametro_compras 
where	cd_estabelecimento = cd_estabelecimento_p;
 
select	nextval('man_equipamento_seq') 
into STRICT	nr_sequencia_w
;
 
select	substr(obter_desc_material(obter_dados_nf_item(nr_seq_nota,nr_seq_item,1)),1,80) ds_equipamento, 
	obter_dados_nota_fiscal(nr_seq_nota,13) dt_aquisicao, 
	obter_dados_nota_fiscal(nr_seq_nota,2) cd_fornecedor, 
	obter_dados_nf_item(nr_seq_nota,nr_seq_item,4) cd_serie, 
	obter_dados_nf_item(nr_seq_nota,nr_seq_item,8) vl_aquisicao, 
	substr(obter_marca_material(obter_dados_nf_item(nr_seq_nota,nr_seq_item,1),'D'),1,50) ds_marca, 
	nr_seq_nota, 
	nr_seq_item 
into STRICT	ds_equipamento_w, 
	dt_aquisicao_w, 
	cd_fornecedor_w, 
	cd_serie_w, 
	vl_aquisicao_w, 
	ds_marca_w, 
	nr_seq_nota_w, 
	nr_seq_item_w 
from	nf_integracao_pat_equip 
where	nr_sequencia = nr_sequencia_p;
 
select	max(a.dt_inicio_garantia), 
	max(a.dt_fim_garantia), 
	coalesce(max(a.nr_seq_modelo),0), 
	coalesce(max(a.cd_imobilizado), 'X'), 
	max(b.nr_nota_fiscal), 
	max(a.cd_lote_fabricacao), 
	max(a.nr_seq_lote_fornec), 
	max(a.cd_material) 
into STRICT	dt_inicio_garantia_w, 
	dt_fim_garantia_w, 
	nr_seq_modelo_w, 
	cd_imobilizado_w, 
	nr_nota_fiscal_w, 
	cd_lote_fabricacao_w, 
	nr_seq_lote_fornec_w, 
	cd_material_w 
from	nota_fiscal b, 
	nota_fiscal_item a 
where	a.nr_sequencia	= nr_seq_nota_w 
and	a.nr_sequencia	= b.nr_sequencia 
and	a.nr_item_nf	= nr_seq_item_w;
 
if (nr_seq_modelo_w <> 0) then 
	 
	select	a.nr_sequencia, 
		b.nr_sequencia, 
		substr(c.ds_modelo,1,50) 
	into STRICT	nr_seq_fabricante_w, 
		nr_seq_marca_w, 
		ds_modelo_w 
	from	man_fabricante a, 
		man_marca b, 
		man_modelo c 
	where	c.nr_sequencia = nr_seq_modelo_w 
	and	b.nr_sequencia = c.nr_seq_marca 
	and	a.nr_sequencia = b.nr_seq_fabricante;
	 
else 
	nr_seq_modelo_w		:= null;
	ds_modelo_w		:= null;
	nr_seq_fabricante_w	:= null;
	nr_seq_marca_w		:= null;
end if;
	 
 
insert into man_equipamento( 
	nr_sequencia, 
	ds_equipamento, 
	nr_seq_local, 
	nr_seq_tipo_equip, 
	dt_atualizacao, 
	nm_usuario, 
	nr_seq_planej, 
	nr_seq_trab, 
	ie_situacao, 
	cd_imobilizado, 
	cd_fornecedor, 
	dt_aquisicao, 
	vl_aquisicao, 
	cd_moeda, 
	ie_disponibilidade, 
	ie_rotina_seguranca, 
	cd_estab_contabil, 
	cd_centro_custo, 
	ie_propriedade, 
	ds_marca, 
	ie_parado, 
	ie_controle_setor, 
	nr_serie, 
	dt_inicio_garantia, 
	dt_fim_garantia, 
	ie_consiste_os_duplic, 
	nr_seq_modelo, 
	nr_seq_fabricante, 
	nr_seq_marca, 
	ds_modelo, 
	nr_doc_garantia, 
	ie_prioridade, 
	nr_seq_nf_integ, 
	nr_seq_item_nf_integ, 
	cd_lote_fabricacao, 
	nr_seq_lote_fornec, 
	cd_material) 
values (	nr_sequencia_w, 
	ds_equipamento_w, 
	nr_seq_local_p, 
	nr_seq_tipo_equip_p, 
	clock_timestamp(), 
	nm_usuario_p, 
	nr_seq_planej_p, 
	nr_seq_trab_p, 
	'A', 
	nr_sequencia_w, 
	cd_fornecedor_w, 
	dt_aquisicao_w, 
	vl_aquisicao_w, 
	cd_moeda_w, 
	'N', 
	'N', 
	cd_estabelecimento_p, 
	cd_centro_custo_p, 
	'P', 
	ds_marca_w, 
	'N', 
	'S', 
	cd_serie_w, 
	dt_inicio_garantia_w, 
	dt_fim_garantia_w, 
	'N', 
	nr_seq_modelo_w, 
	nr_seq_fabricante_w, 
	nr_seq_marca_w, 
	ds_modelo_w, 
	nr_nota_fiscal_w, 
	ie_prioridade_p, 
	nr_seq_nota_w, 
	nr_seq_item_w, 
	cd_lote_fabricacao_w, 
	nr_seq_lote_fornec_w, 
	cd_material_w);
 
update	nf_integracao_pat_equip 
set	nr_seq_equipamento	= nr_sequencia_w 
where	nr_sequencia		= nr_sequencia_p;
 
if (cd_imobilizado_w = 'X') then 
	begin 
	select	coalesce(max(nr_seq_bem),0) 
	into STRICT	nr_seq_bem_w 
	from	nf_integracao_pat_equip 
	where	nr_sequencia	= nr_sequencia_p;
 
	if (nr_seq_bem_w > 0) then 
		select	cd_bem 
		into STRICT	cd_bem_w 
		from	pat_bem 
		where	nr_sequencia = nr_seq_bem_w;
 
		update	man_equipamento 
		set		cd_imobilizado	= cd_bem_w, 
				nr_seq_bem	= nr_seq_bem_w 
		where	nr_sequencia	= nr_sequencia_w;
		 
	end if;
	 
	if (coalesce(dt_inicio_garantia_w::text, '') = '' and coalesce(dt_fim_garantia_w::text, '') = '') then 
 
		select	max(dt_aquisicao), 
				max(dt_garantia) 
		into STRICT	dt_inicio_garantia_w, 
				dt_fim_garantia_w 
		from	pat_bem 	 
		where	nr_sequencia = nr_seq_bem_w;
 
		update	man_equipamento 
		set		dt_inicio_garantia = dt_inicio_garantia_w, 
				dt_fim_garantia	= dt_fim_garantia_w 
		where	nr_sequencia	= nr_sequencia_w;
 
	end if;
	end;
elsif (cd_imobilizado_w <> 'X') then 
 
	update	man_equipamento 
	set	cd_imobilizado	= cd_imobilizado_w 
	where	nr_sequencia	= nr_sequencia_w;
 
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_integrar_pat_nf ( nr_sequencia_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, nr_seq_local_p bigint, nr_seq_tipo_equip_p bigint, nr_seq_planej_p bigint, nr_seq_trab_p bigint, cd_centro_custo_p bigint, ie_prioridade_p text) FROM PUBLIC;

