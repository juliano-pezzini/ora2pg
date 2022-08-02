-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sup_agrupar_requisicao ( nr_requisicao_p bigint, ie_liberar_p text, nm_usuario_p text, nr_requisicao_dest_p INOUT bigint) AS $body$
DECLARE

	 
nr_requisicao_w			requisicao_material.nr_requisicao%type;
nr_sequencia_w			item_requisicao_material.nr_sequencia%type;
vl_unit_previsto_w			item_requisicao_material.vl_unit_previsto%type;
cd_motivo_baixa_w			item_requisicao_material.cd_motivo_baixa%type;
cd_pessoa_usuario_w		pessoa_fisica.cd_pessoa_fisica%type;

ie_momento_gerar_vl_item_req_w	varchar(1);
ie_valor_gerar_para_item_req_w	varchar(1);

c01 CURSOR FOR 
SELECT	nr_requisicao, 
	nr_sequencia, 
	cd_estabelecimento, 
	cd_material, 
	qt_material_requisitada, 
	qt_material_atendida, 
	vl_material, 
	cd_unidade_medida, 
	ie_acao, 
	cd_motivo_baixa, 
	qt_estoque, 
	cd_unidade_medida_estoque, 
	cd_conta_contabil, 
	cd_material_req, 
	nr_seq_lote_fornec, 
	cd_cgc_fornecedor, 
	ie_geracao, 
	cd_barras 
from	item_requisicao_material 
where	nr_requisicao = nr_requisicao_p 
and	coalesce(qt_material_atendida,0) = 0;

vet01	c01%rowtype;


BEGIN 
nr_requisicao_w := nr_requisicao_dest_p;
 
if (coalesce(nr_requisicao_dest_p::text, '') = '') then 
	begin 
	cd_pessoa_usuario_w	:= substr(obter_pessoa_fisica_usuario(nm_usuario_p,'C'),1,10);
	 
	if (coalesce(cd_pessoa_usuario_w,'X') = 'X') then 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(266463);
	end if;
	 
	select	nextval('requisicao_seq') 
	into STRICT	nr_requisicao_w 
	;
	 
	nr_requisicao_dest_p := nr_requisicao_w;	
	 
	insert into requisicao_material( 
		nr_requisicao, 
		cd_estabelecimento, 
		cd_local_estoque, 
		dt_solicitacao_requisicao, 
		dt_atualizacao, 
		nm_usuario, 
		cd_operacao_estoque, 
		cd_pessoa_requisitante, 
		cd_pessoa_atendente, 
		cd_setor_atendimento, 
		cd_local_estoque_destino, 
		cd_centro_custo, 
		ds_observacao, 
		ie_urgente, 
		cd_setor_entrega, 
		ie_geracao, 
		cd_pessoa_solicitante, 
		dt_atualizacao_nrec, 
		nm_usuario_nrec, 
		ie_origem_requisicao, 
		nr_requisicao_orig) 
	SELECT	nr_requisicao_w, 
		cd_estabelecimento, 
		cd_local_estoque, 
		clock_timestamp(), 
		clock_timestamp(), 
		nm_usuario_p, 
		cd_operacao_estoque, 
		cd_pessoa_usuario_w, 
		cd_pessoa_atendente, 
		cd_setor_atendimento, 
		cd_local_estoque_destino, 
		cd_centro_custo, 
		null, 
		ie_urgente, 
		cd_setor_entrega, 
		null, 
		cd_pessoa_usuario_w, 
		dt_atualizacao_nrec, 
		nm_usuario_nrec, 
		'AR', 
		null 
	from	requisicao_material 
	where	nr_requisicao = nr_requisicao_p;
							 
	CALL gerar_historico_requisicao(nr_requisicao_w,WHEB_MENSAGEM_PCK.get_texto(306698),WHEB_MENSAGEM_PCK.get_texto(306700),'GA',nm_usuario_p);
	end;
end if;
 
open c01;
loop 
fetch c01 into	 
	vet01;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
	select	max(nr_sequencia) 
	into STRICT	nr_sequencia_w 
	from	item_requisicao_material 
	where	nr_requisicao = nr_requisicao_w 
	and	cd_material = vet01.cd_material 
	and	cd_unidade_medida = vet01.cd_unidade_medida 
	and	coalesce(nr_seq_lote_fornec,0) = coalesce(vet01.nr_seq_lote_fornec,0) 
	and	coalesce(cd_cgc_fornecedor,'X') = coalesce(vet01.cd_cgc_fornecedor,'X') 
	and	coalesce(cd_barras,'X') = coalesce(vet01.cd_barras,'X')  LIMIT 1;
	 
	if (nr_sequencia_w > 0) then 
		update	item_requisicao_material 
		set	qt_material_requisitada = qt_material_requisitada + vet01.qt_material_requisitada, 
			qt_material_atendida = qt_material_atendida + vet01.qt_material_atendida, 
			qt_estoque = qt_estoque + vet01.qt_estoque 
		where	nr_requisicao = nr_requisicao_w 
		and	nr_sequencia = nr_sequencia_w;		
	else	 
		begin 
		/* 
		obter_param_usuario(919,82, obter_perfil_ativo, nm_usuario_p, vet01.cd_estabelecimento, ie_valor_gerar_para_item_req_w); 
		obter_param_usuario(919,83, obter_perfil_ativo, nm_usuario_p, vet01.cd_estabelecimento, ie_momento_gerar_vl_item_req_w); 
 
		if	(nvl(ie_momento_gerar_vl_item_req_w,'L') = 'S') and 
			(nvl(ie_valor_gerar_para_item_req_w, 'U') <> 'N') then 
			vl_unit_previsto_w := nvl(sup_obter_valores_material_req(nr_requisicao_w, nr_sequencia_w, ie_valor_gerar_para_item_req_w),0); 
		end if; 
		*/
 
		 
		select	coalesce(max(nr_sequencia),0) + 1 
		into STRICT	nr_sequencia_w 
		from	item_requisicao_material 
		where	nr_requisicao = nr_requisicao_w;
		 
		insert into item_requisicao_material( 
			nr_requisicao, 
			nr_sequencia, 
			cd_estabelecimento, 
			cd_material, 
			qt_material_requisitada, 
			qt_material_atendida, 
			vl_material, 
			cd_unidade_medida, 
			ie_acao, 
			cd_motivo_baixa, 
			qt_estoque, 
			cd_unidade_medida_estoque, 
			cd_conta_contabil, 
			cd_material_req, 
			nr_seq_lote_fornec, 
			cd_cgc_fornecedor, 
			ie_geracao, 
			cd_barras, 
			dt_atualizacao, 
			nm_usuario, 
			vl_unit_previsto) 
		SELECT	nr_requisicao_w, 
			nr_sequencia_w, 
			cd_estabelecimento, 
			cd_material, 
			qt_material_requisitada, 
			qt_material_atendida, 
			vl_material, 
			cd_unidade_medida, 
			ie_acao, 
			cd_motivo_baixa, 
			qt_estoque, 
			cd_unidade_medida_estoque, 
			cd_conta_contabil, 
			cd_material_req, 
			nr_seq_lote_fornec, 
			cd_cgc_fornecedor, 
			ie_geracao, 
			cd_barras, 
			clock_timestamp(), 
			nm_usuario_p, 
			vl_unit_previsto_w 
		from	item_requisicao_material 
		where	nr_requisicao = vet01.nr_requisicao 
		and	nr_sequencia = vet01.nr_sequencia;
		end;
	end if;
	 
	select	max(nr_sequencia) 
	into STRICT	cd_motivo_baixa_w 
	from	sup_motivo_baixa_req 
	where	cd_motivo_baixa = 6;
	 
	update	item_requisicao_material 
	set	cd_motivo_baixa = cd_motivo_baixa_w, 
		dt_atendimento = clock_timestamp(), 
		qt_material_atendida = 0 
	where	nr_requisicao = vet01.nr_requisicao 
	and	nr_sequencia = vet01.nr_sequencia;
	end;
end loop;
close c01;
 
if (ie_liberar_p = 'S') then 
	update	requisicao_material 
	set	dt_liberacao = clock_timestamp(), 
		dt_aprovacao = clock_timestamp() 
	where	nr_requisicao = nr_requisicao_w;
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sup_agrupar_requisicao ( nr_requisicao_p bigint, ie_liberar_p text, nm_usuario_p text, nr_requisicao_dest_p INOUT bigint) FROM PUBLIC;

