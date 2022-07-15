-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE desdobrar_item_requisicao ( nr_requisicao_p bigint, nr_sequencia_p bigint, qt_desdobrar_p bigint, nr_seq_lote_fornec_p bigint, nm_usuario_p text, nr_sequencia_out_p INOUT bigint) AS $body$
DECLARE


qt_material_w			double precision;
qt_conv_estoque_consumo_w	double precision;


BEGIN

nr_sequencia_out_p	:= nr_sequencia_p;


select	coalesce(max(qt_material_requisitada),0),
	coalesce(max(b.qt_conv_estoque_consumo),1)
into STRICT	qt_material_w,
	qt_conv_estoque_consumo_w
from	material b,
	item_requisicao_material a
where	nr_requisicao = nr_requisicao_p
and	nr_sequencia  = nr_sequencia_p
and	a.cd_material = b.cd_material;

if (qt_material_w > 0) and (qt_material_w >= qt_desdobrar_p) then
	if (qt_material_w = qt_desdobrar_p) then
		update	item_requisicao_material
		set	nr_seq_lote_fornec = nr_seq_lote_fornec_p
		where	nr_requisicao = nr_requisicao_p
		and	nr_sequencia  = nr_sequencia_p;
	else		
		select max(nr_sequencia)+1
		  into STRICT nr_sequencia_out_p
		  from item_requisicao_material
		 where nr_requisicao = nr_requisicao_p;
		
		if (coalesce(qt_desdobrar_p,0) = 0) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(265968,'NR_REQUISICAO=' || nr_requisicao_p ||
								';NR_SEQUENCIA=' || nr_sequencia_p);	
			--'Erro ao desdobrar o item da requisicao: ' || nr_requisicao_p || '/' || nr_sequencia_p || chr(13) ||

			--'A quantidade a desdobrar e igual a zero!'
		end if;
		insert into item_requisicao_material(
			nr_requisicao,
			nr_sequencia,
			cd_estabelecimento,
			cd_material,
			qt_material_requisitada,
 			qt_material_atendida,
 			vl_material,
			dt_atualizacao,
			nm_usuario,
			cd_unidade_medida,
			dt_atendimento,
			cd_pessoa_recebe,
			cd_pessoa_atende,
			ie_acao,
			cd_motivo_baixa,
			qt_estoque,
			cd_unidade_medida_estoque,
			cd_conta_contabil,
			cd_material_req,
			nr_seq_lote_fornec,
			cd_cgc_fornecedor,
			ds_observacao,
			ie_geracao,
			nr_seq_kit_estoque)
		SELECT	nr_requisicao,
			nr_sequencia_out_p,
			cd_estabelecimento,
			cd_material,
			qt_desdobrar_p,
			0, /*Deve ser como zero, pois esta quantidade sera ajustada na baixa efetiva*/
			vl_material,
			clock_timestamp(),
			nm_usuario_p,
			cd_unidade_medida,
			null, 
			cd_pessoa_recebe,
			cd_pessoa_atende,
			'1',
			0,
			dividir(qt_desdobrar_p, qt_conv_estoque_consumo_w),
			cd_unidade_medida_estoque,
			cd_conta_contabil,
			cd_material_req,
			nr_seq_lote_fornec_p,
			cd_cgc_fornecedor, 
			ds_observacao,
			'S',
			nr_seq_kit_estoque

		from	item_requisicao_material
		where	nr_requisicao = nr_requisicao_p
		and	nr_sequencia  = nr_sequencia_p;
		
		update item_requisicao_material
		set	qt_material_requisitada	= (qt_material_requisitada - qt_desdobrar_p),
			qt_estoque		= (dividir((qt_material_requisitada - qt_desdobrar_p), qt_conv_estoque_consumo_w))
		where	nr_requisicao		= nr_requisicao_p
		and	nr_sequencia		= nr_sequencia_p;


	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE desdobrar_item_requisicao ( nr_requisicao_p bigint, nr_sequencia_p bigint, qt_desdobrar_p bigint, nr_seq_lote_fornec_p bigint, nm_usuario_p text, nr_sequencia_out_p INOUT bigint) FROM PUBLIC;

