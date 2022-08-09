-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atender_barras_cirurgia ( nr_prescricao_p bigint, nr_cirurgia_p bigint, cd_material_p bigint, nr_seq_lote_fornec_p bigint, qt_material_p bigint, nr_seq_atepacu_p bigint, cd_local_estoque_p bigint, nm_usuario_p text) AS $body$
DECLARE

					 
ie_regra_uso_w			varchar(1):= 'N';
nr_atendimento_w		bigint;
ie_acao_excesso_w		varchar(10);
qt_excedida_w			double precision;
nr_seq_regra_uso_w		bigint;
ds_erro_uso_w			varchar(255);
cd_convenio_w 			integer;	
cd_categoria_w			bigint;
cd_convenio_pf_w		integer;
cd_categoria_pf_w		varchar(10);
nr_doc_convenio_w		varchar(20);
ie_tipo_guia_w			varchar(2);
cd_senha_w			varchar(20);
dt_entrada_unidade_w		timestamp;
cd_unidade_medida_w		varchar(30);
ie_via_aplicacao_w		varchar(5);
dt_prescricao_w			timestamp;
cd_estabelecimento_w		smallint;
qt_material_w			double precision;
cd_perfil_w			integer;	
cd_setor_atend_baixa_w		integer;
nr_seq_excedido_w		bigint;
nr_conta_w			bigint;
nr_sequencia_w			bigint;
ie_tipo_lancto_w		varchar(10)	:= '3';
cd_motivo_exc_conta_w		parametro_faturamento.cd_motivo_exc_conta%type;
	

BEGIN	 
cd_estabelecimento_w	:=	wheb_usuario_pck.get_cd_estabelecimento;
cd_perfil_w		:=	wheb_usuario_pck.get_cd_perfil;
qt_material_w		:= 	qt_material_p;
			 
ie_regra_uso_w := Obter_Param_Usuario(900, 359, cd_perfil_w, nm_usuario_p, cd_estabelecimento_w, ie_regra_uso_w);
ie_tipo_lancto_w := obter_param_usuario(901, 121, cd_perfil_w, nm_usuario_p, 0, ie_tipo_lancto_w);
if (ie_tipo_lancto_w <> 0) then 
	ie_tipo_lancto_w := obter_param_usuario(900, 258, cd_perfil_w, nm_usuario_p, cd_estabelecimento_w, ie_tipo_lancto_w);
	if (ie_tipo_lancto_w = 'S') then 
		ie_tipo_lancto_w := '0';
	end if;
end if;	
 
 
select	max(nr_atendimento), 
	max(dt_prescricao) 
into STRICT	nr_atendimento_w, 
	dt_prescricao_w 
from	prescr_medica 
where	nr_prescricao = nr_prescricao_p;
 
select	max(cd_setor_atendimento), 
	max(dt_entrada_unidade) 
into STRICT	cd_setor_atend_baixa_w, 
	dt_entrada_unidade_w 
from 	atend_paciente_unidade 
where 	nr_seq_interno = nr_seq_atepacu_p;
 
select	substr(obter_dados_material_estab(cd_material,cd_estabelecimento_w,'UMS'),1,30), 
	ie_via_aplicacao 
into STRICT	cd_unidade_medida_w, 
	ie_via_aplicacao_w 
from	material 
where	cd_material	= cd_material_p;	
 
SELECT * FROM obter_convenio_execucao(nr_atendimento_w, clock_timestamp(), cd_convenio_w, cd_categoria_w, nr_doc_convenio_w, ie_tipo_guia_w, cd_senha_w) INTO STRICT cd_convenio_w, cd_categoria_w, nr_doc_convenio_w, ie_tipo_guia_w, cd_senha_w;
 
select 	nextval('material_atend_paciente_seq') 
into STRICT 	nr_sequencia_w
;
 
if (ie_regra_uso_w = 'S') then 
 
	SELECT * FROM Obter_regra_uso_mat(	nr_atendimento_w, cd_material_p, qt_material_w, cd_setor_atend_baixa_w, ie_acao_excesso_w, qt_excedida_w, nr_seq_regra_uso_w, ds_erro_uso_w, cd_categoria_w, null, null, null, clock_timestamp(), null) INTO STRICT ie_acao_excesso_w, qt_excedida_w, nr_seq_regra_uso_w, ds_erro_uso_w;
	 
	if (ie_acao_excesso_w = 'E') then 
		if (qt_excedida_w  > 0) then 
			if 	((qt_material_w - qt_excedida_w) >= 0) then 
 
				select	nextval('material_atend_paciente_seq') 
				into STRICT	nr_seq_excedido_w 
				;
 
				insert into material_atend_paciente( 
					nr_sequencia, 
					nr_atendimento, 
					dt_entrada_unidade, 
					cd_material, 
					dt_atendimento, 
					cd_unidade_medida, 
					qt_material, 
					dt_atualizacao, 
					nm_usuario, 
					cd_acao, 
					cd_setor_atendimento, 
					nr_seq_atepacu, 
					cd_material_prescricao, 
					cd_material_exec, 
					ie_via_aplicacao, 
					dt_prescricao, 
					nr_prescricao, 
					nr_sequencia_prescricao, 
					cd_cgc_fornecedor, 
					qt_executada, 
					nr_cirurgia, 
					cd_local_estoque, 
					vl_unitario, 
					qt_ajuste_conta, 
					ie_valor_informado, 
					ie_guia_informada, 
					ie_auditoria, 
					nm_usuario_original, 
					cd_situacao_glosa, 
					cd_convenio, 
					cd_categoria, 
					nr_doc_convenio, 
					ie_tipo_guia, 
					nr_seq_lote_fornec, 
					cd_senha, 
					dt_conta, 
					nr_seq_kit_estoque) 
				values ( 
					nr_seq_excedido_w, 
					nr_atendimento_w, 
					dt_entrada_unidade_w, 
					cd_material_p, 
					clock_timestamp(), 
					cd_unidade_medida_w, 
					qt_excedida_w, 
					clock_timestamp(), 
					nm_usuario_p, 
					'1', 
					cd_setor_atend_baixa_w, 
					nr_seq_atepacu_p, 
					cd_material_p, 
					cd_material_p, 
					ie_via_aplicacao_w, 
					dt_prescricao_w, 
					nr_prescricao_p, 
					null, 
					null,--cd_fornec_consignado_w, 
					qt_excedida_w, 
					nr_cirurgia_p, 
					cd_local_estoque_p, 
					0, 
					0, 
					'N', 
					'N', 
					'N', 
					nm_usuario_p, 
					0, 
					cd_convenio_w, 
					cd_categoria_w, 
					nr_doc_convenio_w, 
					ie_tipo_guia_w, 
					nr_seq_lote_fornec_p, 
					cd_senha_w, 
					clock_timestamp(), 
					null);
				commit;	
				CALL atualiza_preco_material(nr_seq_excedido_w, nm_usuario_p);
 
				select 	max(nr_interno_conta) 
				into STRICT	nr_conta_w 
				from 	material_atend_paciente 
				where 	nr_sequencia = nr_seq_excedido_w;
				 
				select	max(cd_motivo_exc_conta) 
				into STRICT	cd_motivo_exc_conta_w 
				from	parametro_faturamento 
				where	cd_estabelecimento = cd_estabelecimento_w;
				 
				CALL excluir_matproc_conta( 
					nr_seq_excedido_w, 
					nr_conta_w, 
					coalesce(cd_motivo_exc_conta_w, 12), 
					Wheb_mensagem_pck.get_Texto(301541), /*'Excluído pela regra de uso da função Cadastro de Convênios', */
 
					'M', 
					nm_usuario_p);
					 
			end if;
 
			qt_material_w := qt_material_w - qt_excedida_w;
			 
			 
		end if;
		 
	elsif (ie_acao_excesso_w = 'P') then 
	 
		if (qt_excedida_w  >= qt_material_w) then 
			SELECT * FROM Obter_Convenio_Particular_PF( 
				cd_estabelecimento_w, cd_convenio_w, null, clock_timestamp(), cd_convenio_pf_w, cd_categoria_pf_w) INTO STRICT cd_convenio_pf_w, cd_categoria_pf_w;
				 
			cd_convenio_w	:= cd_convenio_pf_w;
			cd_categoria_w	:= cd_categoria_pf_w;
			 
		else 
			qt_material_w	:= qt_material_w - qt_excedida_w;
			 
			SELECT * FROM Obter_Convenio_Particular_PF( 
				cd_estabelecimento_w, cd_convenio_w, null, clock_timestamp(), cd_convenio_pf_w, cd_categoria_pf_w) INTO STRICT cd_convenio_pf_w, cd_categoria_pf_w;
				 
			select	nextval('material_atend_paciente_seq') 
			into STRICT	nr_seq_excedido_w 
			;
			 
			insert into material_atend_paciente( 
					nr_sequencia, 
					nr_atendimento, 
					dt_entrada_unidade, 
					cd_material, 
					dt_atendimento, 
					cd_unidade_medida, 
					qt_material, 
					dt_atualizacao, 
					nm_usuario, 
					cd_acao, 
					cd_setor_atendimento, 
					nr_seq_atepacu, 
					cd_material_prescricao, 
					cd_material_exec, 
					ie_via_aplicacao, 
					dt_prescricao, 
					nr_prescricao, 
					nr_sequencia_prescricao, 
					cd_cgc_fornecedor, 
					qt_executada, 
					nr_cirurgia, 
					cd_local_estoque, 
					vl_unitario, 
					qt_ajuste_conta, 
					ie_valor_informado, 
					ie_guia_informada, 
					ie_auditoria, 
					nm_usuario_original, 
					cd_situacao_glosa, 
					cd_convenio, 
					cd_categoria, 
					nr_doc_convenio, 
					ie_tipo_guia, 
					nr_seq_lote_fornec, 
					cd_senha, 
					dt_conta, 
					nr_seq_kit_estoque) 
				values ( 
					nr_seq_excedido_w, 
					nr_atendimento_w, 
					dt_entrada_unidade_w, 
					cd_material_p, 
					clock_timestamp(), 
					cd_unidade_medida_w, 
					qt_excedida_w, 
					clock_timestamp(), 
					nm_usuario_p, 
					'1', 
					cd_setor_atend_baixa_w, 
					nr_seq_atepacu_p, 
					cd_material_p, 
					cd_material_p, 
					ie_via_aplicacao_w, 
					dt_prescricao_w, 
					nr_prescricao_p, 
					null, 
					null, 
					qt_excedida_w, 
					nr_cirurgia_p, 
					cd_local_estoque_p, 
					0, 
					0, 
					'N', 
					'N', 
					'N', 
					nm_usuario_p, 
					0, 
					cd_convenio_pf_w, 
					cd_categoria_pf_w, 
					nr_doc_convenio_w, 
					ie_tipo_guia_w, 
					nr_seq_lote_fornec_p, 
					cd_senha_w, 
					clock_timestamp(), 
					null);
			commit;		
			CALL atualiza_preco_material(nr_seq_excedido_w, nm_usuario_p);
		end if;
	 
	end if;
	 
	if (qt_material_w > 0) then 
		insert into material_atend_paciente( 
					nr_sequencia, 
					nr_atendimento, 
					dt_entrada_unidade, 
					cd_material, 
					dt_atendimento, 
					cd_unidade_medida, 
					qt_material, 
					dt_atualizacao, 
					nm_usuario, 
					cd_acao, 
					cd_setor_atendimento, 
					nr_seq_atepacu, 
					cd_material_prescricao, 
					cd_material_exec, 
					ie_via_aplicacao, 
					dt_prescricao, 
					nr_prescricao, 
					nr_sequencia_prescricao, 
					cd_cgc_fornecedor, 
					qt_executada, 
					nr_cirurgia, 
					cd_local_estoque, 
					vl_unitario, 
					qt_ajuste_conta, 
					ie_valor_informado, 
					ie_guia_informada, 
					ie_auditoria, 
					nm_usuario_original, 
					cd_situacao_glosa, 
					cd_convenio, 
					cd_categoria, 
					nr_doc_convenio, 
					ie_tipo_guia, 
					nr_seq_lote_fornec, 
					cd_senha, 
					dt_conta, 
					nr_seq_kit_estoque) 
				values ( 
					nr_sequencia_w, 
					nr_atendimento_w, 
					dt_entrada_unidade_w, 
					cd_material_p, 
					clock_timestamp(), 
					cd_unidade_medida_w, 
					qt_material_w, 
					clock_timestamp(), 
					nm_usuario_p, 
					'1', 
					cd_setor_atend_baixa_w, 
					nr_seq_atepacu_p, 
					cd_material_p, 
					cd_material_p, 
					ie_via_aplicacao_w, 
					dt_prescricao_w, 
					nr_prescricao_p, 
					null, 
					null, 
					qt_material_w, 
					nr_cirurgia_p, 
					cd_local_estoque_p, 
					0, 
					0, 
					'N', 
					'N', 
					'N', 
					nm_usuario_p, 
					0, 
					cd_convenio_w, 
					cd_categoria_w, 
					nr_doc_convenio_w, 
					ie_tipo_guia_w, 
					nr_seq_lote_fornec_p, 
					cd_senha_w, 
					clock_timestamp(), 
					null);
				commit;	
	end if;
 
else 
	insert into material_atend_paciente( 
				nr_sequencia, 
				nr_atendimento, 
				dt_entrada_unidade, 
				cd_material, 
				dt_atendimento, 
				cd_unidade_medida, 
				qt_material, 
				dt_atualizacao, 
				nm_usuario, 
				cd_acao, 
				cd_setor_atendimento, 
				nr_seq_atepacu, 
				cd_material_prescricao, 
				cd_material_exec, 
				ie_via_aplicacao, 
				dt_prescricao, 
				nr_prescricao, 
				nr_sequencia_prescricao, 
				cd_cgc_fornecedor, 
				qt_executada, 
				nr_cirurgia, 
				cd_local_estoque, 
				vl_unitario, 
				qt_ajuste_conta, 
				ie_valor_informado, 
				ie_guia_informada, 
				ie_auditoria, 
				nm_usuario_original, 
				cd_situacao_glosa, 
				cd_convenio, 
				cd_categoria, 
				nr_doc_convenio, 
				ie_tipo_guia, 
				nr_seq_lote_fornec, 
				cd_senha, 
				dt_conta, 
				nr_seq_kit_estoque) 
			values ( 
				nr_sequencia_w, 
				nr_atendimento_w, 
				dt_entrada_unidade_w, 
				cd_material_p, 
				clock_timestamp(), 
				cd_unidade_medida_w, 
				qt_material_w, 
				clock_timestamp(), 
				nm_usuario_p, 
				'1', 
				cd_setor_atend_baixa_w, 
				nr_seq_atepacu_p, 
				cd_material_p, 
				cd_material_p, 
				ie_via_aplicacao_w, 
				dt_prescricao_w, 
				nr_prescricao_p, 
				null, 
				null, 
				qt_material_w, 
				nr_cirurgia_p, 
				cd_local_estoque_p, 
				0, 
				0, 
				'N', 
				'N', 
				'N', 
				nm_usuario_p, 
				0, 
				cd_convenio_w, 
				cd_categoria_w, 
				nr_doc_convenio_w, 
				ie_tipo_guia_w, 
				nr_seq_lote_fornec_p, 
				cd_senha_w, 
				clock_timestamp(), 
				null);
	commit;			
end if;
 
CALL atualiza_preco_material(nr_sequencia_w, nm_usuario_p);				
CALL gerar_autor_regra(	nr_atendimento_w, 
		nr_sequencia_w, 
		null, 
		null, 
		null, 
		null, 
		'PC', 
		nm_usuario_p, 
		null, 
		null, 
		null, 
		null, 
		null,	 
		null, 
		'', 
		'', 
		'');
		 
if (ie_tipo_lancto_w	= '0') then 
	CALL Gerar_Lanc_Automatico_Mat(nr_atendimento_w,cd_local_estoque_p,132,nm_usuario_p,nr_sequencia_w,null,null);
end if;
 
CALL atualiza_atend_barras_cirurgia(nr_prescricao_p,cd_material_p,nr_seq_lote_fornec_p,qt_material_p,nm_usuario_p);
 
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atender_barras_cirurgia ( nr_prescricao_p bigint, nr_cirurgia_p bigint, cd_material_p bigint, nr_seq_lote_fornec_p bigint, qt_material_p bigint, nr_seq_atepacu_p bigint, cd_local_estoque_p bigint, nm_usuario_p text) FROM PUBLIC;
