-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_req_reposicao ( nr_ordem_compra_p bigint, cd_local_destino_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, nr_requisicao_p INOUT bigint) AS $body$
DECLARE

 
/* Procedure utilizada no CorEtqTR */
 
 
/* Cursor c01 */
 
nr_ordem_compra_w		ordem_compra.nr_ordem_compra%type;
nr_item_oci_w			ordem_compra_item.nr_item_oci%type;
cd_material_w			material.cd_material%type;
qt_material_w			double precision;
qt_estoque_w			double precision;

cd_grupo_material_w		grupo_material.cd_grupo_material%type;
cd_subgrupo_w			subgrupo_material.cd_subgrupo_material%type;
cd_classe_material_w		classe_material.cd_classe_material%type;

/* Cursor c02 */
 
cd_local_estoque_w		local_estoque.cd_local_estoque%type;
cd_operacao_estoque_w		operacao_estoque.cd_operacao_estoque%type;

cd_local_estoque_ant_w		local_estoque.cd_local_estoque%type;
cd_operacao_estoque_ant_w	operacao_estoque.cd_operacao_estoque%type;
cd_pessoa_requisicao_w		pessoa_fisica.cd_pessoa_fisica%type;
nr_requisicao_w			requisicao_material.nr_requisicao%type;
nr_sequencia_w			item_requisicao_material.nr_sequencia%type;
ds_erro_w			varchar(2000);
dt_liberacao_w			timestamp;
qt_conv_estoque_cons_w		double precision;
cd_unidade_medida_w		unidade_medida.cd_unidade_medida%type;
cd_unidade_medida_estoque_w	unidade_medida.cd_unidade_medida%type;

c01 CURSOR FOR 
SELECT	a.nr_ordem_compra, 
	b.nr_item_oci, 
	b.cd_material, 
	obter_quantidade_convertida(b.cd_material, sum(x.qt_prevista_entrega) - (obter_qt_oci_trans_nota(a.nr_ordem_compra, b.nr_item_oci,'S')), b.cd_unidade_medida_compra, 'UME') 
from	ordem_compra_item b, 
	ordem_compra a, 
	ordem_compra_item_entrega x 
where	a.nr_ordem_compra = b.nr_ordem_compra 
and	x.nr_item_oci = b.nr_item_oci 
and	x.nr_ordem_compra = b.nr_ordem_compra 
and	coalesce(x.dt_cancelamento::text, '') = '' 
AND	a.ie_tipo_ordem = 'T' 
and	a.cd_estab_transf = cd_estabelecimento_p 
and	a.nr_ordem_compra = nr_ordem_compra_p 
having sum(x.qt_prevista_entrega) - (obter_qt_oci_trans_nota(a.nr_ordem_compra, b.nr_item_oci,'S')) > 0 
group by a.nr_ordem_compra, 
	b.nr_item_oci, 
	b.cd_material, 
	b.ds_material_direto, 
	b.nr_solic_compra, 
	b.cd_unidade_medida_compra;

c02 CURSOR FOR 
SELECT	cd_local_estoque, 
	cd_operacao_estoque 
from	regra_req_transf_estab 
where	cd_estabelecimento					= cd_estabelecimento_p 
and	cd_local_estoque_destino				= cd_local_destino_p 
and	coalesce(cd_grupo_material, cd_grupo_material_w)		= cd_grupo_material_w 
and	coalesce(cd_subgrupo_material, cd_subgrupo_w)		= cd_subgrupo_w 
and	coalesce(cd_classe_material, cd_classe_material_w)		= cd_classe_material_w 
and	coalesce(cd_material, cd_material_w)				= cd_material_w 
and	((coalesce(nr_seq_estrut_int::text, '') = '') or ((nr_seq_estrut_int IS NOT NULL AND nr_seq_estrut_int::text <> '') and consistir_se_mat_contr_estrut(nr_seq_estrut_int,cd_material_w) = 'S'));

c03 CURSOR FOR 
SELECT	nr_ordem_compra, 
	nr_item_oci, 
	cd_material, 
	qt_material, 
	cd_local_estoque, 
	cd_operacao_estoque 
from	w_itens_req_reposicao 
where	nm_usuario = nm_usuario_p 
group by nr_ordem_compra, 
	nr_item_oci, 
	cd_material, 
	qt_material, 
	cd_local_estoque, 
	cd_operacao_estoque;

c04 CURSOR FOR 
SELECT	coalesce(substr(wheb_mensagem_pck.get_texto(314232) || cd_material || ' - ' || ds_consistencia || '.',1,2000),null) 
from	requisicao_mat_consist 
where	nr_requisicao = nr_requisicao_w;


BEGIN 
select	coalesce(max(nr_requisicao),0) 
into STRICT	nr_requisicao_w 
from	item_requisicao_material 
where	nr_ordem_compra = nr_ordem_compra_p;
 
if (nr_requisicao_w > 0) then 
	/* Já existe a requisição ' || nr_requisicao_w || ' gerada para essa transferência! */
 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(323103,'NR_REQUISICAO='||nr_requisicao_w);
end if;
 
delete	FROM w_itens_req_reposicao 
where	nm_usuario = nm_usuario_p;
commit;
 
open c01;
loop 
fetch c01 into 
	nr_ordem_compra_w, 
	nr_item_oci_w, 
	cd_material_w, 
	qt_material_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
	select	cd_grupo_material, 
		cd_subgrupo_material, 
		cd_classe_material 
	into STRICT	cd_grupo_material_w, 
		cd_subgrupo_w, 
		cd_classe_material_w 
	from	estrutura_material_v 
	where 	cd_material = cd_material_w;
	 
	cd_local_estoque_w	:= 0;
	cd_operacao_estoque_w	:= 0;
	 
	open c02;
	loop 
	fetch c02 into 
		cd_local_estoque_w, 
		cd_operacao_estoque_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin 
		cd_local_estoque_w	:= cd_local_estoque_w;
		cd_operacao_estoque_w	:= cd_operacao_estoque_w;
		end;
	end loop;
	close c02;
	 
	if (coalesce(cd_local_estoque_w,0) > 0) and (coalesce(cd_operacao_estoque_w,0) > 0) then 
		insert into w_itens_req_reposicao( 
			nr_ordem_compra, 
			nr_item_oci, 
			cd_material, 
			qt_material, 
			cd_local_estoque, 
			cd_operacao_estoque, 
			nm_usuario) 
		values (	nr_ordem_compra_w, 
			nr_item_oci_w, 
			cd_material_w, 
			qt_material_w, 
			cd_local_estoque_w, 
			cd_operacao_estoque_w, 
			nm_usuario_p);
	end if;
	end;
end loop;
close c01;
 
cd_pessoa_requisicao_w	:= obter_pf_usuario(nm_usuario_p,'C');
nr_requisicao_w		:= 0;
 
open c03;
loop 
fetch c03 into 
	nr_ordem_compra_w, 
	nr_item_oci_w, 
	cd_material_w, 
	qt_material_w, 
	cd_local_estoque_w, 
	cd_operacao_estoque_w;
EXIT WHEN NOT FOUND; /* apply on c03 */
	begin 
	if (nr_requisicao_w = 0) or (cd_local_estoque_w <> cd_local_estoque_ant_w) or (cd_operacao_estoque_w <> cd_operacao_estoque_ant_w) then 
		select	nextval('requisicao_seq') 
		into STRICT	nr_requisicao_w 
		;
		 
		insert into requisicao_material( 
			nr_requisicao, 
			cd_estabelecimento, 
			cd_local_estoque, 
			dt_solicitacao_requisicao, 
			dt_atualizacao, 
			nm_usuario, 
			cd_operacao_estoque, 
			cd_pessoa_requisitante, 
			cd_local_estoque_destino, 
			nm_usuario_lib, 
			dt_atualizacao_nrec, 
			nm_usuario_nrec, 
			ie_geracao, 
			ie_urgente) 
		values (	nr_requisicao_w, 
			cd_estabelecimento_p, 
			cd_local_estoque_w, 
			clock_timestamp(), 
			clock_timestamp(), 
			nm_usuario_p, 
			cd_operacao_estoque_w, 
			cd_pessoa_requisicao_w, 
			cd_local_destino_p, 
			nm_usuario_p, 
			clock_timestamp(), 
			nm_usuario_p, 
			'I', 
			'N');
		 
		cd_local_estoque_ant_w		:= cd_local_estoque_w;
		cd_operacao_estoque_ant_w	:= cd_operacao_estoque_w;
	end if;
	 
	if (nr_requisicao_w > 0) then 
		select	coalesce(max(nr_sequencia),0) + 1 
		into STRICT	nr_sequencia_w 
		from	item_requisicao_material 
		where	nr_requisicao = nr_requisicao_w;
		 
		cd_unidade_medida_w 		:= obter_dados_material_estab(cd_material_w,cd_estabelecimento_p,'UMS');
		cd_unidade_medida_estoque_w 	:= obter_dados_material_estab(cd_material_w,cd_estabelecimento_p,'UME');
		qt_estoque_w			:= qt_material_w;
		qt_material_w			:= obter_quantidade_convertida(cd_material_w, qt_estoque_w, cd_unidade_medida_estoque_w, 'UMC');
		 
		begin 
		qt_conv_estoque_cons_w 		:= qt_material_w / qt_estoque_w;
		exception 
		when others then 
			qt_conv_estoque_cons_w 		:= obter_conversao_material(cd_material_w,'CE');
		end;
		 
		insert into item_requisicao_material( 
			nr_requisicao, 
			nr_sequencia, 
			cd_estabelecimento, 
			cd_material, 
			qt_material_requisitada, 
			qt_estoque, 
			vl_material, 
			dt_atualizacao, 
			nm_usuario, 
			cd_unidade_medida, 
			cd_unidade_medida_estoque, 
			nr_ordem_compra, 
			nr_item_oci) 
		values ( nr_requisicao_w, 
			nr_sequencia_w, 
			cd_estabelecimento_p, 
			cd_material_w, 
			qt_material_w, 
			qt_estoque_w, 
			0, 
			clock_timestamp(), 
			nm_usuario_p, 
			cd_unidade_medida_w, 
			cd_unidade_medida_estoque_w, 
			nr_ordem_compra_w, 
			nr_item_oci_w);
	end if;
	end;
end loop;
close c03;
 
commit;
 
if (nr_requisicao_w > 0) then 
	ds_erro_w := consistir_requisicao(nr_requisicao_w, nm_usuario_p, cd_local_destino_p, null, 'N', 'N', 'N', 'N', 'S', 'N', 'N', cd_operacao_estoque_w, ds_erro_w);
	commit;
end if;
 
nr_requisicao_p := nr_requisicao_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_req_reposicao ( nr_ordem_compra_p bigint, cd_local_destino_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, nr_requisicao_p INOUT bigint) FROM PUBLIC;
