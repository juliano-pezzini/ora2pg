-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lic_gerar_compra_licit_manter ( cd_estabelecimento_p bigint, nr_cot_compra_p bigint, nr_seq_licitacao_p bigint, nm_usuario_p text, ds_observacao_solic_p text) AS $body$
DECLARE

 
				 
nr_item_cot_compra_w			integer;
nr_item_solic_compra_w			integer;
cd_material_w				integer;
qt_material_w				double precision;
cd_unidade_medida_compra_w		varchar(30);
nr_seq_tipo_compra_w			bigint;
nr_seq_mod_compra_w			bigint;
nr_solic_compra_w				bigint;
nr_seq_forma_compra_w			bigint;
nr_seq_licitacao_w				bigint;
nr_seq_lic_item_w				integer;
nr_seq_estagio_w				bigint;

c01 CURSOR FOR 
SELECT	distinct  --traz os itens que não tem agrupamento 
	a.nr_solic_compra 
from	cot_compra_item a 
where	a.nr_cot_compra	= nr_cot_compra_p 
and	substr(lic_obter_tipo_compra(a.nr_seq_tipo_compra),1,1) = 'L' 
and	(a.nr_solic_compra IS NOT NULL AND a.nr_solic_compra::text <> '') 

union all
 
SELECT	distinct  --traz somente os itens que tem agrupamento 
	b.nr_solic_compra 
from	cot_compra_solic_agrup b, 
	cot_compra_item a 
where	a.nr_cot_compra	= nr_cot_compra_p 
and	a.nr_cot_compra	= b.nr_cot_compra 
and	a.nr_item_cot_compra = b.nr_item_cot_compra 
and	substr(lic_obter_tipo_compra(a.nr_seq_tipo_compra),1,1) = 'L' 
order by	nr_solic_compra desc;

c02 CURSOR FOR 
SELECT	nr_item_cot_compra, 
	cd_material, 
	qt_material, 
	cd_unidade_medida_compra, 
	nr_solic_compra, 
	nr_item_solic_compra 
from	cot_compra_item 
where	nr_cot_compra = nr_cot_compra_p 
order by nr_item_cot_compra;
	

BEGIN 
 
nr_seq_licitacao_w	:= coalesce(nr_seq_licitacao_p,0);
 
select	coalesce(min(nr_sequencia),0) 
into STRICT	nr_seq_forma_compra_w 
from	reg_lic_forma_compra 
where	ie_situacao	= 'A' 
and	ie_forma_compra	= 'L';
 
if (nr_seq_forma_compra_w = 0) then 
	/*'Não existe nenhuma forma de compra cadastrada do tipo: Licitação.' || 
	'Favor verificar em Cadastros Gerais > Suprimentos > Licitação > Formas de compra para solicitação.');*/
 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(193432);
end if;
 
open C01;
loop 
fetch C01 into	 
	nr_solic_compra_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	 
	update	solic_compra 
	set	nr_seq_forma_compra = nr_seq_forma_compra_w 
	where	nr_solic_compra = nr_solic_compra_w;
	 
	end;
end loop;
close C01;
 
CALL calcular_cot_compra_liquida(nr_cot_compra_p, nm_usuario_p);
CALL gerar_cot_compra_resumo(nr_cot_compra_p, nm_usuario_p);
	 
select	coalesce(max(nr_sequencia),0) 
into STRICT	nr_seq_tipo_compra_w 
from	reg_lic_tipo_compra 
where	ie_tipo_compra = 'L' 
and	ie_situacao = 'A';
	 
if (nr_seq_tipo_compra_w = 0) then 
	/*'Não existe nenhuma forma de compra cadastrada do tipo: Licitação.' || 
	'Favor verificar em Cadastros Gerais > Suprimentos > Licitação > Formas de compra para solicitação.');*/
 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(193432);
end if;
	 
select	max(nr_seq_mod_compra) 
into STRICT	nr_seq_mod_compra_w 
from	cot_compra_item 
where	nr_cot_compra = nr_cot_compra_p;
 
if (nr_seq_licitacao_w = 0) then 
	 
	select	nextval('reg_licitacao_seq') 
	into STRICT	nr_seq_licitacao_w 
	;
		 
	select	coalesce(min(nr_sequencia),0) 
	into STRICT	nr_seq_estagio_w 
	from	lic_estagio;
		 
	if (nr_seq_estagio_w = 0) then 
		/*'Não existe nenhum estágio cadastrado.' || 
		'Favor verificar em Cadastros Gerais > Suprimentos > Cadastros Compras > Estagio do processo Licitatório.');*/
 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(193433);
	end if;
		 
	insert into reg_licitacao( 
		nr_sequencia,			cd_estabelecimento,			dt_atualizacao, 
		nm_usuario,			dt_atualizacao_nrec,			nm_usuario_nrec, 
		cd_processo,			dt_emissao,				ds_objeto, 
		nr_seq_estagio,			nr_seq_tipo_compra,			nr_seq_mod_compra, 
		ie_registro_preco) 
	values (	nr_seq_licitacao_w,			cd_estabelecimento_p,			clock_timestamp(), 
		nm_usuario_p,			clock_timestamp(),					nm_usuario_p, 
		'0',				clock_timestamp(),					wheb_mensagem_pck.get_texto(303591,'NR_COT_COMPRA_P='||nr_cot_compra_p), 
		nr_seq_estagio_w,			nr_seq_tipo_compra_w,			nr_seq_mod_compra_w, 
		'N');
		 
	insert into reg_lic_historico( 
		nr_sequencia, 
		dt_atualizacao, 
		nm_usuario, 
		ie_tipo_historico, 
		ds_observacao, 
		nr_seq_licitacao) 
	values (	nextval('reg_lic_historico_seq'), 
		clock_timestamp(), 
		nm_usuario_p, 
		'AC', 
		wheb_mensagem_pck.get_texto(303586,'NR_COT_COMPRA_P='||nr_cot_compra_p), 
		nr_seq_licitacao_w);
end if;
	 
update	cot_compra 
set	nr_seq_reg_licitacao = nr_seq_licitacao_w 
where	nr_cot_compra = nr_cot_compra_p;
	 
open C02;
loop 
fetch C02 into 
	nr_item_cot_compra_w, 
	cd_material_w, 
	qt_material_w, 
	cd_unidade_medida_compra_w, 
	nr_solic_compra_w, 
	nr_item_solic_compra_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin 
	 
	select	coalesce(max(nr_seq_lic_item), 0) +1 
	into STRICT	nr_seq_lic_item_w 
	from	reg_lic_item 
	where	nr_seq_licitacao = nr_seq_licitacao_w;
	 
	insert into reg_lic_item( 
		dt_atualizacao, 
		nm_usuario, 
		nr_seq_licitacao, 
		nr_seq_lic_item, 
		cd_material, 
		cd_unid_medida, 
		qt_item) 
	values (	clock_timestamp(), 
		nm_usuario_p, 
		nr_seq_licitacao_w, 
		nr_seq_lic_item_w, 
		cd_material_w, 
		cd_unidade_medida_compra_w, 
		qt_material_w);
 
	update	cot_compra_item 
	set	nr_seq_licitacao	= nr_seq_licitacao_w, 
		nr_seq_lic_item		= nr_seq_lic_item_w 
	where	nr_cot_compra		= nr_cot_compra_p 
	and	nr_item_cot_compra	= nr_item_cot_compra_w;
 
	insert into reg_lic_solic_item( 
		nr_sequencia, 
		dt_atualizacao, 
		nm_usuario, 
		dt_atualizacao_nrec, 
		nm_usuario_nrec, 
		nr_seq_licitacao, 
		nr_seq_lic_item, 
		nr_solic_compra, 
		nr_item_solic_compra, 
		qt_item) 
	values (	nextval('reg_lic_solic_item_seq'), 
		clock_timestamp(), 
		nm_usuario_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		nr_seq_licitacao_w, 
		nr_seq_lic_item_w, 
		nr_solic_compra_w, 
		nr_item_solic_compra_w, 
		qt_material_w);			
	end;
end loop;
close C02;
 
update	cot_compra 
set	dt_fechamento_lic	= clock_timestamp() 
where	nr_cot_compra	= nr_cot_compra_p;
 
CALL gerar_historico_cotacao( 
		nr_cot_compra_p, 
		wheb_mensagem_pck.get_texto(303580), 
		wheb_mensagem_pck.get_texto(303582), 
		'S', 
		nm_usuario_p);
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lic_gerar_compra_licit_manter ( cd_estabelecimento_p bigint, nr_cot_compra_p bigint, nr_seq_licitacao_p bigint, nm_usuario_p text, ds_observacao_solic_p text) FROM PUBLIC;
