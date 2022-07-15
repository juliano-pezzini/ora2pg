-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_solic_compra_requisicao ( nr_requisicao_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, nr_solic_compra_p INOUT bigint) AS $body$
DECLARE


cd_estabelecimento_w	requisicao_material.cd_estabelecimento%type;
cd_pessoa_requisitante_w	requisicao_material.cd_pessoa_requisitante%type;
cd_setor_entrega_w	requisicao_material.cd_setor_entrega%type;
ds_observacao_w		requisicao_material.ds_observacao%type;
dt_aprovacao_w		timestamp;
dt_atualizacao_w		timestamp;
dt_baixa_w		timestamp;
dt_liberacao_w		timestamp;
dt_solicitacao_requisicao_w	timestamp;
nm_usuario_req_mat_w	usuario.nm_usuario%type;

cd_setor_atendimento_w	solic_compra.cd_setor_atendimento%type;
cd_centro_custo_w		solic_compra.cd_centro_custo%type;
nr_solic_compra_w		solic_compra.nr_solic_compra%type;

cd_material_w		item_requisicao_material.cd_material%type;
cd_motivo_baixa_w		item_requisicao_material.cd_motivo_baixa%type;
cd_unidade_medida_w	item_requisicao_material.cd_unidade_medida%type;
dt_atendimento_w		timestamp;
dt_atuali_item_req_mat_w	timestamp;
nm_usuario_item_req_mat_w	usuario.nm_usuario%type;
nr_seq_item_requisicao_w	item_requisicao_material.nr_sequencia%type;
qt_material_requisitada_w	item_requisicao_material.qt_material_requisitada%type;

nr_item_solic_compra_w	solic_compra_item.nr_item_solic_compra%type;
qt_dias_obter_compra_w	bigint;
qt_conv_compra_est_orig_w	solic_compra_item.qt_conv_compra_est_orig%type;
cd_local_estoque_w	requisicao_material.cd_local_estoque%type;
qt_regra_w		integer;
cd_motivo_baixa_ww	sup_motivo_baixa_req.nr_sequencia%type;
qt_pendentes_w		integer;

c01 CURSOR FOR
SELECT	b.cd_material,
	b.cd_motivo_baixa,
	b.cd_unidade_medida,
	b.nr_sequencia,
	b.qt_material_requisitada
from	requisicao_material a,
	item_requisicao_material b
where	a.nr_requisicao = b.nr_requisicao
and	substr(sup_obter_se_gera_solic_req(a.cd_estabelecimento, b.cd_material),1,1) = 'S'
and	a.nr_requisicao = nr_requisicao_p;


BEGIN
begin
select	CD_MOTIVO_BAIXA_REQ_SOLIC
into STRICT	cd_motivo_baixa_ww
from	PARAMETRO_COMPRAS
where	cd_estabelecimento = cd_estabelecimento_p
and	(CD_MOTIVO_BAIXA_REQ_SOLIC IS NOT NULL AND CD_MOTIVO_BAIXA_REQ_SOLIC::text <> '');
exception
when others then
	begin
	select	min(nr_sequencia)
	into STRICT	cd_motivo_baixa_ww
	from	sup_motivo_baixa_req
	where	cd_motivo_baixa  = 5
	and	ie_situacao = 'A';
	end;
end;

if (coalesce(cd_motivo_baixa_ww::text, '') = '') then
	/*
	Deve ser informado o motivo de baixa padrão para os itens gerados na solicitação de compras.
	Verificar o cadastro dos Parâmetros de Compras!
	*/
	CALL wheb_mensagem_pck.exibir_mensagem_abort(289792);
end if;

open c01;
loop
fetch c01 into
	cd_material_w,
	cd_motivo_baixa_w,
	cd_unidade_medida_w,
	nr_seq_item_requisicao_w,
	qt_material_requisitada_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	if (coalesce(nr_solic_compra_w::text, '') = '') then
		begin
		qt_dias_obter_compra_w := obter_param_usuario(913, 11, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, qt_dias_obter_compra_w);

		select	cd_estabelecimento,
			cd_pessoa_requisitante,
			cd_setor_entrega,
			ds_observacao,
			dt_aprovacao,
			dt_atualizacao,
			dt_baixa,
			dt_liberacao,
			dt_solicitacao_requisicao,
			nm_usuario,
			cd_local_estoque,
			cd_centro_custo
		into STRICT	cd_estabelecimento_w,
			cd_pessoa_requisitante_w,
			cd_setor_entrega_w,
			ds_observacao_w,
			dt_aprovacao_w,
			dt_atualizacao_w,
			dt_baixa_w,
			dt_liberacao_w,
			dt_solicitacao_requisicao_w,
			nm_usuario_req_mat_w,
			cd_local_estoque_w,
			cd_centro_custo_w
		from	requisicao_material
		where	nr_requisicao = nr_requisicao_p;

		select	nextval('solic_compra_seq')
		into STRICT	nr_solic_compra_w
		;

		insert into solic_compra(
			nr_solic_compra,
			cd_centro_custo,
			cd_estabelecimento,
			cd_pessoa_solicitante,
			cd_setor_atendimento,
			cd_setor_entrega,
			ds_observacao,
			dt_autorizacao,
			dt_atualizacao,
			dt_baixa,
			dt_liberacao,
			dt_solicitacao_compra,
			nm_usuario,
			ie_aviso_aprov_oc,
			ie_situacao,
			ie_urgente,
			ie_aviso_chegada,
			ie_tipo_solicitacao,
			ie_comodato,
			ie_semanal,
			cd_local_estoque,
			nm_usuario_nrec,
			dt_atualizacao_nrec)
		values (	nr_solic_compra_w,
			cd_centro_custo_w,
			cd_estabelecimento_w,
			cd_pessoa_requisitante_w,
			cd_setor_atendimento_w,
			cd_setor_entrega_w,
			ds_observacao_w,
			dt_aprovacao_w,
			dt_atualizacao_w,
			dt_baixa_w,
			dt_liberacao_w,
			dt_solicitacao_requisicao_w,
			nm_usuario_req_mat_w,
			'N',
			'A',
			'N',
			'N',
			'4',
			'N',
			'N',
			cd_local_estoque_w,
			nm_usuario_p,
			clock_timestamp());
		end;
	end if;

	select	coalesce(max(nr_item_solic_compra),0) + 1
	into STRICT	nr_item_solic_compra_w
	from	solic_compra_item
	where	nr_solic_compra = nr_solic_compra_w;

	qt_conv_compra_est_orig_w :=	obter_dados_material(cd_material_w,'QCE');

	insert into solic_compra_item(
		nr_solic_compra,
		nr_item_solic_compra,
		cd_material,
		cd_unidade_medida_compra,
		qt_material,
		cd_motivo_baixa,
		dt_atualizacao,
		ie_geracao,
		ie_situacao,
		nm_usuario,
		nr_requisicao,
		nr_seq_item_requisicao,
		qt_conv_compra_est_orig,
		dt_solic_item)
	values (	nr_solic_compra_w,
		nr_item_solic_compra_w,
		cd_material_w,
		cd_unidade_medida_w,
		qt_material_requisitada_w,
		cd_motivo_baixa_w,
		clock_timestamp(),
		'S',
		'A',
		nm_usuario_p,
		nr_requisicao_p,
		nr_seq_item_requisicao_w,
		qt_conv_compra_est_orig_w,
		clock_timestamp());

	CALL gerar_solic_item_entrega(nr_solic_compra_w, nr_item_solic_compra_w, nm_usuario_p);

	CALL baixar_item_req_motivo(nm_usuario_p, nr_requisicao_p, nr_seq_item_requisicao_w, cd_motivo_baixa_ww, qt_material_requisitada_w);
	end;
end loop;
close c01;

select	count(1)
into STRICT	qt_pendentes_w
from	item_requisicao_material
where	nr_requisicao = nr_requisicao_p
and	coalesce(dt_atendimento::text, '') = '';

if (qt_pendentes_w = 0) then
	update	requisicao_material
	set	dt_baixa = clock_timestamp()
	where	nr_requisicao = nr_requisicao_p;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_solic_compra_requisicao ( nr_requisicao_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, nr_solic_compra_p INOUT bigint) FROM PUBLIC;

