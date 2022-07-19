-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tratar_retorno_regra_uso_mat ( nr_atendimento_p bigint, cd_material_p bigint, cd_setor_atendimento_p bigint, cd_estabelecimento_p bigint, cd_plano_convenio_p text, cd_cgc_fornecedor_p text, cd_cgc_prestador_p text, dt_material_p timestamp, nr_seq_atepacu_p bigint, cd_local_estoque_p bigint, cd_motivo_exc_conta_p bigint, nm_usuario_p text, nr_seq_mat_p bigint, cd_categoria_p INOUT text, cd_convenio_p INOUT bigint, nr_interno_conta_p INOUT bigint, qt_lancamento_p INOUT bigint, ds_abort_p INOUT text, ie_valor_informado_p INOUT text) AS $body$
DECLARE
	
	
	
ie_acao_excesso_w	convenio_regra_qtde_mat.ie_acao_excesso%type;
qt_excedida_w		convenio_regra_qtde_mat.qt_permitida%type;
nr_seq_regra_uso_mat_w	convenio_regra_qtde_mat.nr_sequencia%type;
ds_erro_uso_w		varchar(255);
nr_seq_excedido_w	material_atend_paciente.nr_sequencia%type;
nr_conta_w		material_atend_paciente.nr_interno_conta%type;
ds_texto_w		varchar(255);
cd_convenio_glosa_w	convenio.cd_convenio_glosa%type;
cd_categoria_glosa_w	convenio.cd_categoria_glosa%type;


BEGIN	
	SELECT * FROM obter_regra_uso_mat(nr_atendimento_p, cd_material_p, qt_lancamento_p, cd_setor_atendimento_p, ie_acao_excesso_w, qt_excedida_w, nr_seq_regra_uso_mat_w, ds_erro_uso_w, cd_categoria_p, cd_plano_convenio_p, cd_cgc_fornecedor_p, cd_cgc_prestador_p, dt_material_p, nr_seq_mat_p, nr_interno_conta_p) INTO STRICT ie_acao_excesso_w, qt_excedida_w, nr_seq_regra_uso_mat_w, ds_erro_uso_w;	

	if (ie_acao_excesso_w = 'E') then
		if (qt_excedida_w   > 0) then

			if 	((qt_lancamento_p - qt_excedida_w) >= 0) then

				nr_seq_excedido_w := inserir_material_atend_pac(nr_atendimento_p, null, cd_material_p, dt_material_p, cd_convenio_p, cd_categoria_p, nr_seq_atepacu_p, nm_usuario_p, qt_excedida_w, cd_local_estoque_p, '1', 'N', nr_seq_excedido_w, null, null);

				CALL atualiza_preco_material(nr_seq_excedido_w, nm_usuario_p);

				select 	max(nr_interno_conta)
				into STRICT	nr_conta_w
				from 	material_atend_paciente
				where 	nr_sequencia = nr_seq_excedido_w;
				--Excluido pela regra de uso da funcao Cadastro de Convenios
				ds_texto_w := substr(wheb_mensagem_pck.get_texto(306744),1,255);
				CALL excluir_matproc_conta(nr_seq_excedido_w, nr_conta_w, coalesce(cd_motivo_exc_conta_p, 12), ds_texto_w, 'M', nm_usuario_p);

				if ((qt_lancamento_p - qt_excedida_w) = 0) then
					ds_abort_p := wheb_mensagem_pck.get_texto(152722);
				else
					qt_lancamento_p := qt_lancamento_p - qt_excedida_w;
				end if;
			end if;
		end if;

	elsif (ie_acao_excesso_w = 'P') then
	
		SELECT * FROM obter_convenio_particular_pf(cd_estabelecimento_p, cd_convenio_p, '', dt_material_p, cd_convenio_glosa_w, cd_categoria_glosa_w) INTO STRICT cd_convenio_glosa_w, cd_categoria_glosa_w;

		if (qt_excedida_w   >= qt_lancamento_p) then
			nr_interno_conta_p	:= null;
			cd_convenio_p		:= cd_convenio_glosa_w;
			cd_categoria_p		:= cd_categoria_glosa_w;
		else
			qt_lancamento_p := qt_lancamento_p - qt_excedida_w;

			nr_seq_excedido_w := inserir_material_atend_pac(	nr_atendimento_p, null, cd_material_p, dt_material_p, cd_convenio_glosa_w, cd_categoria_glosa_w, nr_seq_atepacu_p, nm_usuario_p, qt_excedida_w, cd_local_estoque_p, '1', 'N', nr_seq_excedido_w, null, null);

			CALL atualiza_preco_material(nr_seq_excedido_w, nm_usuario_p);
			CALL ajustar_conta_vazia(nr_atendimento_p, nm_usuario_p);
		end if;
		
	elsif (ie_acao_excesso_w = 'Z') then
	
		if (qt_excedida_w   >= qt_lancamento_p) then
			ie_valor_informado_p := 'S';
		else		
			qt_lancamento_p := qt_lancamento_p - qt_excedida_w;
			
			nr_seq_excedido_w := inserir_material_atend_pac(nr_atendimento_p, null, cd_material_p, dt_material_p, cd_convenio_p, cd_categoria_p, nr_seq_atepacu_p, nm_usuario_p, qt_excedida_w, cd_local_estoque_p, '1', 'S', nr_seq_excedido_w, null, null);
			
			CALL atualiza_preco_material(nr_seq_excedido_w, nm_usuario_p);
			CALL ajustar_conta_vazia(nr_atendimento_p, nm_usuario_p);			
		end if;
		
	elsif (ie_acao_excesso_w <> 'P' and (ds_erro_uso_w IS NOT NULL AND ds_erro_uso_w::text <> '')) then	
		ds_abort_p := ds_erro_uso_w;		
	end if;
	
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tratar_retorno_regra_uso_mat ( nr_atendimento_p bigint, cd_material_p bigint, cd_setor_atendimento_p bigint, cd_estabelecimento_p bigint, cd_plano_convenio_p text, cd_cgc_fornecedor_p text, cd_cgc_prestador_p text, dt_material_p timestamp, nr_seq_atepacu_p bigint, cd_local_estoque_p bigint, cd_motivo_exc_conta_p bigint, nm_usuario_p text, nr_seq_mat_p bigint, cd_categoria_p INOUT text, cd_convenio_p INOUT bigint, nr_interno_conta_p INOUT bigint, qt_lancamento_p INOUT bigint, ds_abort_p INOUT text, ie_valor_informado_p INOUT text) FROM PUBLIC;

