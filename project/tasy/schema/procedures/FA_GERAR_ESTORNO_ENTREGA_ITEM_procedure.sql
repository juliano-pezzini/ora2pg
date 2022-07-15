-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fa_gerar_estorno_entrega_item (nr_seq_entrega_item_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
				 
nr_seq_mat_w		bigint;
nr_seq_item_w		bigint;
nr_seq_lote_fornec_w	bigint;

C01 CURSOR FOR 
	SELECT 	a.nr_sequencia 
	from	material_atend_paciente a 
	where 	a.nr_seq_entrega_medic_fa = nr_seq_entrega_item_p 
	and		a.qt_material > 0 
	and		not exists (SELECT 1 
				from material_atend_paciente b 
				where	b.nr_seq_entrega_medic_fa	= a.nr_seq_entrega_medic_fa 
				and	coalesce(b.nr_seq_lote_fornec,-1)		= coalesce(a.nr_seq_lote_fornec,-1) 
				and	b.cd_acao = 2);
	--adicionada restrição para verificar se o item já não foi excluso 
				

BEGIN 
 
open C01;
loop 
fetch C01 into	 
	nr_seq_mat_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
		 
	if (nr_seq_mat_w > 0) then 
 
		select nextval('material_atend_paciente_seq') 
		into STRICT nr_seq_item_w 
		;
 
		insert into material_atend_paciente(	nr_sequencia, 
						cd_material, 
						dt_atendimento, 
						cd_convenio, 
						cd_categoria, 
						nr_seq_atepacu, 
						cd_setor_atendimento, 
						dt_entrada_unidade, 
						qt_material, 
						cd_local_estoque, 
						dt_Atualizacao, 
						nm_usuario, 
						nr_atendimento, 
						cd_unidade_medida, 
						cd_acao, 
						ie_valor_informado, 
						nr_seq_lote_fornec, 
						dt_atualizacao_nrec, 
						nm_usuario_nrec, 
						ds_observacao, 
						nr_seq_entrega_medic_fa, 
						cd_cgc_fornecedor) 
					SELECT nr_seq_item_w, 
						cd_material, 
						dt_atendimento, 
						cd_convenio, 
						cd_categoria, 
						nr_seq_atepacu, 
						cd_setor_atendimento, 
						dt_entrada_unidade, 
						qt_material * -1, 
						cd_local_estoque, 
						dt_Atualizacao, 
						nm_usuario, 
						nr_atendimento, 
						cd_unidade_medida, 
						'2', 
						ie_valor_informado, 
						nr_seq_lote_fornec, 
						clock_timestamp(), 
						nm_usuario_p, 
						wheb_mensagem_pck.get_texto(802105), 
						nr_seq_entrega_medic_fa, 
						cd_cgc_fornecedor 
						from	material_atend_paciente 
						where	nr_seq_entrega_medic_fa = nr_seq_entrega_item_p 
						and	nr_sequencia = nr_seq_mat_w;
 
		CALL atualiza_preco_material(nr_seq_item_w,nm_usuario_p);
 
	end if;
	end;
end loop;
close C01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fa_gerar_estorno_entrega_item (nr_seq_entrega_item_p bigint, nm_usuario_p text) FROM PUBLIC;

