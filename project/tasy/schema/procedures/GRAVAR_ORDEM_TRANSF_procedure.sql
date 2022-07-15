-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_ordem_transf ( cd_estabelecimento_p bigint, cd_local_estoque_p bigint, cd_estab_atende_p bigint, cd_local_atende_p bigint, cd_pessoa_requisitante_p text, nr_seq_protocolo_p bigint, nm_usuario_p text, nr_ordem_compra_p INOUT text) AS $body$
DECLARE

			 
dt_atualizacao_w      		timestamp     	:= clock_timestamp();
dt_mesano_referencia_w   		timestamp;
cd_material_w        		integer  	:= 0;
nr_ordem_compra_w       		bigint  	:= 0;
nr_sequencia_w       		integer  	:= 0;
qt_estoque_minimo_w     		double precision 	:= 0;
qt_estoque_maximo_w     		double precision 	:= 0;
qt_estoque_w        		double precision 	:= 0;
qt_estoque_req_w      		double precision 	:= 0;
qt_multiplo_w			double precision	:= 0;
qt_minimo_multiplo_solic_w 		double precision 	:= 0;
qt_requisitada_w      		double precision 	:= 0;
qt_prescr_cirurgia_w      		double precision 	:= 0;
qt_lancado_cirurgia_w		double precision 	:= 0;
qt_agenda_cirurgia_w		double precision 	:= 0;
qt_conv_estoque_consumo_w  	double precision 	:= 0;
cd_unidade_medida_consumo_w 	varchar(30) 	:= '';
cd_unidade_medida_estoque_w 	varchar(30) 	:= '';
cd_unidade_medida_solic_w		varchar(30) 	:= '';
cd_conta_contabil_w		varchar(20) 	:= '';
qt_itens_desdobra_req_w		bigint 	:= 0;
qt_itens_gerados_w			bigint 	:= 0;
qt_existe_w			bigint;
ds_requisicoes_geradas_w		varchar(4000);
nr_sequencia_ww    		integer  	:= 0;

cd_comprador_w			bigint;
cd_condicao_pagamento_w		bigint;
cd_condicao_pagamento_ww		bigint;
qt_dias_entrega_w			varchar(1);
dt_entrega_w			timestamp;
cd_moeda_w			integer;
cd_cgc_w			varchar(14);

c01 CURSOR FOR 
SELECT	w.nr_sequencia, 
	w.cd_material, 
	w.qt_estoque, 
   	w.cd_unidade_medida_estoque, 
	w.cd_conta_contabil 
from	w_requisicao_material w 
where	w.nm_usuario = nm_usuario_p 
order by w.nr_sequencia;


BEGIN	 
select	count(*) 
into STRICT	qt_existe_w 
from	w_requisicao_material w 
where	w.nm_usuario = nm_usuario_p;
 
if (qt_existe_w > 0) then 
	begin 
	select	coalesce(max(QT_ITENS_REQUISICAO),0) 
	into STRICT	qt_itens_desdobra_req_w 
	from 	parametro_estoque 
	where	cd_estabelecimento	= cd_estab_atende_p;
 
	qt_dias_entrega_w := Obter_Param_Usuario(146, 8, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, qt_dias_entrega_w);
	cd_condicao_pagamento_w := Obter_Param_Usuario(146, 2, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, cd_condicao_pagamento_w);
 
	dt_entrega_w := trunc(clock_timestamp()) + coalesce(somente_numero(qt_dias_entrega_w),0);
 
	begin 
	select	cd_comprador_padrao, 
		cd_condicao_pagamento_padrao, 
		cd_moeda_padrao 
	into STRICT	cd_comprador_w, 
		cd_condicao_pagamento_ww, 
		cd_moeda_w 
	from	parametro_compras 
	where	cd_Estabelecimento = cd_estabelecimento_p;	
	exception 
	when others then 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(266043);
		--'Não encontrado Parâmetros de compras para este estabelecimento. Verifique!' 
	end;
 
	if (coalesce(somente_numero(cd_condicao_pagamento_w),0) = 0) then 
		cd_condicao_pagamento_w := cd_condicao_pagamento_ww;
	end if;
 
	if (coalesce(cd_condicao_pagamento_w,0) = 0) then 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(266045);
		--'Não encontrado condição de pagamento, verifique os parâmetros de compras ou o parâmetro [2] da função.' 
	end if;
 
	if (coalesce(cd_comprador_w,0) = 0) then 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(266046);
		--'Não encontrado comprador, verifique os parâmetros de compras.' 
	end if;
	 
	if (coalesce(cd_moeda_w,0) = 0) then 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(266047);
		--Não encontrado Moeda padrão, verifique os parâmetros de compras.' 
	end if;
 
	select	cd_cgc 
	into STRICT	cd_cgc_w 
	from	estabelecimento 
	where	cd_estabelecimento = cd_estab_atende_p;
 
	select	nextval('ordem_compra_seq') 
	into STRICT	nr_ordem_compra_w 
	;
 
	begin 
	insert into ordem_compra( 
		nr_ordem_compra, 
		cd_estabelecimento, 
		cd_condicao_pagamento, 
		cd_comprador, 
		dt_ordem_compra, 
		dt_atualizacao, 
		nm_usuario, 
		cd_moeda, 
		ie_situacao, 
		dt_inclusao, 
		cd_pessoa_solicitante, 
		ie_frete, 
		dt_entrega, 
		ie_aviso_chegada, 
		ie_emite_obs, 
		ie_urgente, 
		cd_cgc_fornecedor, 
		ie_tipo_ordem, 
		cd_local_entrega, 
		cd_local_transf, 
		cd_estab_transf, 
		nr_seq_protocolo) 
	values (	nr_ordem_compra_w, 
		cd_estabelecimento_p, 
		cd_condicao_pagamento_w, 
		cd_comprador_w, 
		clock_timestamp(), 
		clock_timestamp(), 
		nm_usuario_p, 
		cd_moeda_w, 
		'A', 
		clock_timestamp(), 
		cd_pessoa_requisitante_p, 
		'C', 
		dt_entrega_w, 
		'N', 
		'N', 
		'N', 
		cd_cgc_w, 
		'T', 
		cd_local_estoque_p, 
		cd_local_atende_p, 
		cd_estab_atende_p, 
		nr_seq_protocolo_p);
	exception when others then 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(266048,'DS_ERRO=' || SQLERRM);
		--'Erro ao gravar solicitação de transferência' || chr(13) || chr(10) || SQLERRM); 
	end;
 
	ds_requisicoes_geradas_w := nr_ordem_compra_w;
 
	open c01;
	loop 
	fetch c01 into 
		nr_sequencia_w, 
		cd_material_w, 
		qt_estoque_req_w, 
		cd_unidade_medida_estoque_w, 
		cd_conta_contabil_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin 
		if (qt_itens_desdobra_req_w > 0) and (qt_itens_gerados_w = qt_itens_desdobra_req_w) then 
			begin 
			select	nextval('ordem_compra_seq') 
			into STRICT	nr_ordem_compra_w 
			;
			 
			begin 
			insert into ordem_compra( 
				nr_ordem_compra, 
				cd_estabelecimento, 
				cd_condicao_pagamento, 
				cd_comprador, 
				dt_ordem_compra, 
				dt_atualizacao, 
				nm_usuario, 
				cd_moeda, 
				ie_situacao, 
				dt_inclusao, 
				cd_pessoa_solicitante, 
				ie_frete, 
				dt_entrega, 
				ie_aviso_chegada, 
				ie_emite_obs, 
				ie_urgente, 
				cd_cgc_fornecedor, 
				ie_tipo_ordem, 
				cd_local_entrega, 
				cd_local_transf, 
				cd_estab_transf, 
				nr_seq_protocolo) 
			values (	nr_ordem_compra_w, 
				cd_estabelecimento_p, 
				cd_condicao_pagamento_w, 
				cd_comprador_w, 
				clock_timestamp(), 
				clock_timestamp(), 
				nm_usuario_p, 
				cd_moeda_w, 
				'A', 
				clock_timestamp(), 
				cd_pessoa_requisitante_p, 
				'C', 
				dt_entrega_w, 
				'N', 
				'N', 
				'N', 
				cd_cgc_w, 
				'T', 
				cd_local_estoque_p, 
				cd_local_atende_p, 
				cd_estab_atende_p, 
				nr_seq_protocolo_p);
			exception when others then 
				CALL wheb_mensagem_pck.exibir_mensagem_abort(266048,'DS_ERRO=' || SQLERRM);
				--'Erro ao gravar solicitação de transferência' || chr(13) || chr(10) || SQLERRM); 
			end;
			 
			ds_requisicoes_geradas_w := substr(ds_requisicoes_geradas_w || ', ' || nr_ordem_compra_w,1,4000);
			nr_sequencia_ww	:= 0;
			qt_itens_gerados_w := 0;
			end;
		end if;
		 
		nr_sequencia_ww	:= coalesce(nr_sequencia_ww,0) + 1;
		nr_sequencia_w	:= nr_sequencia_ww;
		 
		insert into ordem_compra_item( 
			nr_ordem_compra, 
			nr_item_oci, 
			cd_material, 
			qt_material, 
			qt_original, 
			vl_unitario_material, 
			dt_atualizacao, 
			nm_usuario, 
			cd_unidade_medida_compra, 
			cd_local_estoque, 
			ie_situacao, 
			vl_total_item) 
		values (	nr_ordem_compra_w, 
			nr_sequencia_w, 
			cd_material_w, 
			qt_estoque_req_w, 
			qt_estoque_req_w, 
			0, 
			clock_timestamp(), 
			nm_usuario_p, 
			cd_unidade_medida_estoque_w, 
			cd_local_estoque_p, 
			'A', 
			round((qt_estoque_req_w * 0)::numeric,4));	
		 
		insert into ordem_compra_item_entrega( 
			nr_ordem_compra, 
			nr_item_oci, 
			qt_prevista_entrega, 
			dt_prevista_entrega, 
			nm_usuario, 
			dt_atualizacao, 
			nr_sequencia) 
		values (	nr_ordem_compra_w, 
			nr_sequencia_w, 
			qt_estoque_req_w, 
			dt_entrega_w, 
			nm_usuario_p, 
			clock_timestamp(), 
			nextval('ordem_compra_item_entrega_seq'));
		 
		qt_itens_gerados_w	:= coalesce(qt_itens_gerados_w,0) + 1;
		end;		
	end loop;
	close c01;
		 
	if (qt_itens_desdobra_req_w > 0) then 
		begin 
		update	ordem_compra 
		set	ds_observacao = substr(wheb_mensagem_pck.get_texto(302766,'DS_REQUISICOES_GERADAS_W='||ds_requisicoes_geradas_w),1,255) 
		where	substr(obter_se_contido(nr_ordem_compra, ds_requisicoes_geradas_w),1,1) = 'S';
		end;
	end if;	
 
	delete	FROM w_requisicao_material w 
	where	w.nm_usuario = nm_usuario_p;
 
	nr_ordem_compra_p := substr(replace(ds_requisicoes_geradas_w,' ',null),1,255);
	commit;
	end;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_ordem_transf ( cd_estabelecimento_p bigint, cd_local_estoque_p bigint, cd_estab_atende_p bigint, cd_local_atende_p bigint, cd_pessoa_requisitante_p text, nr_seq_protocolo_p bigint, nm_usuario_p text, nr_ordem_compra_p INOUT text) FROM PUBLIC;

