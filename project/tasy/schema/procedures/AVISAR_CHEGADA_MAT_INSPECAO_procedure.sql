-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE avisar_chegada_mat_inspecao ( nr_seq_registro_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nm_usuarios_w			varchar(255);
ds_titulo_w			varchar(80);
ds_comunicado_w			text;
qt_usuario_w			bigint;
nr_solic_compra_w		bigint;
nr_ordem_compra_w		bigint;
nr_nota_fiscal_w		varchar(255);
cd_material_w			integer;
ds_material_w			varchar(255);
qt_inspecao_w			double precision;
nm_usuario_w			varchar(255) := '';
nm_usuario_delegacao_w		varchar(15) := '';
nm_usuario_destino_w		varchar(2000) := '';
nr_sequencia_w			bigint;
nr_seq_classif_w		bigint;
ds_fornecedor_w			varchar(100);
ds_compl_item_solic_w		varchar(255);
ds_local_estoque_w		varchar(40);
ds_cabecalho_w			varchar(100);
ds_rodape_w			varchar(100);
ds_materiais_w			text;
cd_materiais_w			text;
ds_mat_comp_w			text;
nr_seq_regra_comunic_w		bigint;
nm_pessoa_fisica_w		varchar(60);
qt_existe_w			smallint;
qt_regra_usuario_w		bigint;
cd_estabelecimento_w		smallint;
cd_setor_atendimento_w		integer;
nr_seq_regra_w			bigint;
cd_perfil_w			varchar(10);
ie_ci_lida_w			varchar(1);
nm_solicitante_w		varchar(200);
nm_pessoa_resp_insp_w		varchar(60);
dt_entrega_w			varchar(10);
dt_hora_entrega_w		varchar(5);
/* Se tiver setor na regra, envia CI para os setores */
ds_setor_adicional_w		varchar(2000) := '';
/* Campos da regra Usuário da Regra */
cd_setor_regra_usuario_w	integer;

 
c01 CURSOR FOR 
SELECT	distinct c.nr_solic_compra, 
	substr(obter_nome_pf(d.cd_pessoa_solicitante),1,60) nm_pessoa_fisica, 
	substr(obter_nome_pf(cd_pessoa_responsavel),1,60), 
	d.cd_estabelecimento 
from 	Solic_Compra d, 
	Solic_compra_item c, 
	Ordem_compra_item b, 
	inspecao_recebimento a 
where	a.nr_seq_registro = nr_seq_registro_p 
and	a.nr_ordem_compra = b.nr_ordem_compra 
and	a.nr_item_oci = b.nr_item_oci 
and	b.nr_cot_compra = c.nr_cot_compra 
and	b.nr_item_cot_compra = c.nr_item_cot_compra 
and	c.nr_solic_compra = d.nr_solic_compra 
and	(obter_usuario_pessoa(d.cd_pessoa_solicitante) IS NOT NULL AND (obter_usuario_pessoa(d.cd_pessoa_solicitante))::text <> '');

c02 CURSOR FOR 
SELECT	b.nr_ordem_compra, 
	a.cd_material, 
	substr(obter_desc_material(a.cd_material),1,255) ds_material, 
	substr(obter_desc_local_estoque(b.cd_local_estoque),1,40) ds_local_estoque, 
	a.qt_inspecao, 
	obter_dados_ordem_compra(b.nr_ordem_compra,'SA') 
from 	Solic_Compra d, 
	Solic_compra_item c, 
	Ordem_compra_item b, 
	inspecao_recebimento a 
where	a.nr_seq_registro = nr_seq_registro_p 
and	a.nr_ordem_compra = b.nr_ordem_compra 
and	a.nr_item_oci = b.nr_item_oci 
and	b.nr_cot_compra = c.nr_cot_compra 
and	b.nr_item_cot_compra = c.nr_item_cot_compra 
and	c.nr_solic_compra = d.nr_solic_compra 
and	c.nr_solic_compra = nr_solic_compra_w 
order by 
	substr(obter_usuario_pessoa(d.cd_pessoa_solicitante),1,15), 
	c.nr_solic_compra, 
	substr(obter_desc_material(a.cd_material),1,80);

c03 CURSOR FOR 
SELECT	b.nr_ordem_compra, 
	a.cd_material, 
	substr(obter_desc_material(a.cd_material),1,255) ds_material, 
	substr(obter_usuario_pessoa(c.cd_pessoa_solicitante),1,15) nm_usuario, 
	substr(obter_usuario_pessoa(obter_pessoa_delegacao(c.cd_pessoa_solicitante,'RC',clock_timestamp())),1,15) nm_usuario_delegacao, 
	a.qt_inspecao 
from 	ordem_compra c, 
	ordem_compra_item b, 
	inspecao_recebimento a 
where	a.nr_seq_registro = nr_seq_registro_p 
and	a.nr_ordem_compra = b.nr_ordem_compra 
and	a.nr_item_oci = b.nr_item_oci 
and	a.nr_ordem_compra = c.nr_ordem_compra 
order by 5, 1, 4;

c04 CURSOR FOR 
SELECT	b.nr_sequencia, 
	b.cd_perfil 
from	regra_envio_comunic_compra a, 
	regra_envio_comunic_evento b 
where	a.nr_sequencia = b.nr_seq_regra 
and	a.cd_funcao = 270 
and	b.cd_evento = 73 
and	b.ie_situacao = 'A' 
and	a.cd_estabelecimento = cd_estabelecimento_w 
and	((cd_setor_atendimento_w IS NOT NULL AND cd_setor_atendimento_w::text <> '' AND b.cd_setor_destino = cd_setor_atendimento_w) or 
	((coalesce(cd_setor_atendimento_w::text, '') = '') and (coalesce(b.cd_setor_destino::text, '') = '')) or (coalesce(b.cd_setor_destino::text, '') = '')) 
and	substr(obter_se_envia_ci_regra_compra(b.nr_sequencia,nr_seq_registro_p,'IR',obter_perfil_ativo,nm_usuario_p,null),1,1) = 'S';

c05 CURSOR FOR 
SELECT	coalesce(a.cd_setor_atendimento,0) cd_setor_atendimento 
from	regra_envio_comunic_usu a 
where	a.nr_seq_evento = nr_seq_regra_w;


BEGIN 
select	to_char(dt_registro,'dd/mm/yyyy'), 
	to_char(dt_registro,'hh24:mi') 
into STRICT	dt_entrega_w, 
	dt_hora_entrega_w 
from	inspecao_registro 
where	nr_sequencia = nr_seq_registro_p;
 
open c01;
loop 
fetch c01 
into	nr_solic_compra_w, 
	nm_pessoa_fisica_w, 
	nm_pessoa_resp_insp_w, 
	cd_estabelecimento_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
	cd_materiais_w		:= '';
	ds_materiais_w		:= '';
	ds_mat_comp_w		:= '';
	open c02;
	loop 
	fetch c02 
	into	nr_ordem_compra_w, 
		cd_material_w, 
		ds_material_w, 
		ds_local_estoque_w, 
		qt_inspecao_w, 
		cd_setor_atendimento_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin 
		cd_materiais_w := substr(WHEB_MENSAGEM_PCK.get_texto(297636,'PARAM_MAT_UM=' || substr(cd_materiais_w,1,3000) || ';' || 'PARAM_MAT_DOIS=' || substr(cd_material_w,1,50) || ';' || 
								'PARAM_MAT_TRES=' || substr(ds_material_w,1,450)),1,4000);
		ds_materiais_w := substr(WHEB_MENSAGEM_PCK.get_texto(297638,'PARAM_MAT_UM=' || substr(ds_materiais_w,1,3800) || ';' || 'PARAM_MAT_DOIS=' || substr(ds_material_w,1,4000)),1,4000);
		ds_mat_comp_w := substr(WHEB_MENSAGEM_PCK.get_texto(297636,'PARAM_MAT_UM=' || substr(ds_mat_comp_w,1,3000) || ';' || 'PARAM_MAT_DOIS=' || substr(cd_material_w,1,50) || ';' || 
								'PARAM_MAT_TRES=' || substr(ds_material_w,1,450)),1,4000);
		end;
	end loop;
	close c02;
	 
	select	count(*) 
	into STRICT	qt_existe_w 
	from	regra_envio_comunic_compra a, 
		regra_envio_comunic_evento b 
	where	a.nr_sequencia = b.nr_seq_regra 
	and	a.cd_funcao = 270 
	and	b.cd_evento = 73 
	and	b.ie_situacao = 'A' 
	and	cd_estabelecimento = cd_estabelecimento_w;
 
	if (qt_existe_w > 0) then 
 
		open C04;
		loop 
		fetch C04 into	 
			nr_seq_regra_w, 
			cd_perfil_w;
		EXIT WHEN NOT FOUND; /* apply on C04 */
			begin 
 
			open C05;
			loop 
			fetch C05 into	 
				cd_setor_regra_usuario_w;
			EXIT WHEN NOT FOUND; /* apply on C05 */
				begin 
				if (cd_setor_regra_usuario_w <> 0) and (obter_se_contido_char(cd_setor_regra_usuario_w, ds_setor_adicional_w) = 'N') then 
					ds_setor_adicional_w := substr(ds_setor_adicional_w || cd_setor_regra_usuario_w || ',',1,2000);
				end if;
				end;
			end loop;
			close C05;
 
			select	substr(obter_nome_pessoa_fisica(cd_pessoa_solicitante,null),1,200) 
			into STRICT	nm_solicitante_w 
			from 	solic_compra 
			where	nr_solic_compra = nr_solic_compra_w;
 
			select	max(substr(ds_titulo,1,80)), 
				max(substr(replace_macro( 
					replace_macro( 
					replace_macro( 
					replace_macro( 
					replace_macro( 
					replace_macro( 
					replace_macro( 
					replace_macro( 
					replace_macro(ds_comunicacao, 
						'@nr_registro',nr_Seq_registro_p), 
						'@nr_solic_compra', nr_solic_compra_w), 
						'@nm_solicitante', nm_solicitante_w), 
						'@nm_pf_recebimento', nm_pessoa_resp_insp_w), 
						'@dt_recebimento', dt_entrega_w), 
						'@hr_recebimento', dt_hora_entrega_w), 
						'@material', cd_materiais_w), 
						'@materiais', ds_materiais_w), 
						'@mat_completa',ds_mat_comp_w),1,4000)) ds_comunicacao 
			into STRICT	ds_titulo_w, 
				ds_comunicado_w 
			from	regra_envio_comunic_evento 
			where	nr_sequencia = nr_seq_regra_w;
 
			select	count(*) 
			into STRICT	qt_regra_usuario_w 
			from	regra_envio_comunic_compra a, 
				regra_envio_comunic_evento b, 
				regra_envio_comunic_usu c 
			where	a.nr_sequencia = b.nr_seq_regra 
			and	b.nr_sequencia = c.nr_seq_evento 
			and	b.nr_sequencia = nr_seq_regra_w;
 
			select	coalesce(ie_ci_lida,'N') 
			into STRICT	ie_ci_lida_w 
			from 	regra_envio_comunic_evento 
			where 	nr_sequencia = nr_seq_regra_w;
 
			if (qt_regra_usuario_w > 0) then 
				nm_usuario_destino_w := obter_usuarios_comunic_compras(nr_seq_registro_p,null,73,nr_seq_regra_w,'');
			end if;
 
			if (nm_usuario_destino_w IS NOT NULL AND nm_usuario_destino_w::text <> '') then 
 
				select	nextval('comunic_interna_seq') 
				into STRICT	nr_sequencia_w 
				;
 
				if (cd_perfil_w IS NOT NULL AND cd_perfil_w::text <> '') then 
					cd_perfil_w := cd_perfil_w ||',';
				end if;
 
				insert into comunic_interna( 
					dt_comunicado, 
					ds_titulo, 
					ds_comunicado, 
					nm_usuario, 
					dt_atualizacao, 
					ie_geral, 
					nm_usuario_destino, 
					nr_sequencia,	 
					ie_gerencial, 
					nr_seq_classif, 
					dt_liberacao,	 
					ds_perfil_adicional, 
					ds_setor_adicional) 
				values (	clock_timestamp(), 
					ds_titulo_w, 
					ds_comunicado_w, 
					nm_usuario_p, 
					clock_timestamp(), 
					'N', 
					nm_usuario_destino_w, 
					nr_sequencia_w, 
					'N', 
					nr_seq_classif_w, 
					clock_timestamp(), 
					cd_perfil_w, 
					ds_setor_adicional_w);
 
				if (ie_ci_lida_w = 'S') then 
					insert into comunic_interna_lida(nr_sequencia,nm_usuario,dt_atualizacao)values (nr_sequencia_w,nm_usuario_p,clock_timestamp());
				end if;
 
			end if;	
			end;
		end loop;
		close C04;
	end if;
	end;
end loop;
close c01;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE avisar_chegada_mat_inspecao ( nr_seq_registro_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
