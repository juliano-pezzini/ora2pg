-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE html_registrar_operacao_terc ( id_sessao_p text, nm_terceiro_p text, ds_mat_proc_p text, cd_material_barras_p bigint, vl_operacao_p bigint, qt_material_p bigint, vl_total_op_p bigint, dt_operacao_p timestamp, ie_tipo_operacao_p text, cd_pessoa_fisica_p bigint, nr_seq_ordem_servico_p bigint, qt_peso_p bigint, ds_unidade_medida_p text, nr_seq_terceiro_p bigint, nm_usuario_p text, nr_seq_operacao_p bigint, ie_operacao_origem_p bigint, nr_codigo_barras_p text) AS $body$
DECLARE


nr_sequencia_w		reg_operacoes_terc_web.NR_SEQUENCIA%type;
cd_procedimento_w     	reg_operacoes_terc_web.CD_PROCEDIMENTO%type;
cd_material_barras_w 	reg_operacoes_terc_web.CD_MATERIAL_BARRAS%type;								
									

BEGIN

if (ie_tipo_operacao_p = 'P') then
  cd_procedimento_w := cd_material_barras_p;
  cd_material_barras_w := null;
else
  cd_procedimento_w := null;
  cd_material_barras_w := cd_material_barras_p;
end if;

select 	coalesce(max(nr_sequencia),0) + 1
into STRICT 	nr_sequencia_w
from 	reg_operacoes_terc_web;

insert into reg_operacoes_terc_web(	id_sessao,	
									nr_sequencia,
									nm_terceiro, 
									ds_mat_proc, 
									cd_material_barras, 
									cd_procedimento, 
									vl_operacao, 
									qt_material, 
									vl_total_op, 
									dt_operacao, 
									ie_tipo_operacao, 
									cd_pessoa_fisica, 
									nr_seq_ordem_servico, 
									dt_atualizacao, 
									nm_usuario, 
									dt_atualizacao_nrec, 
									nm_usuario_nrec, 
									qt_peso, 
									ds_unidade_medida, 
									nr_seq_terceiro,
									nr_seq_operacao,
									ie_origem_proced,
									nr_codigo_barras									
									) values (
									id_sessao_p,
									nr_sequencia_w,
									nm_terceiro_p , 
									ds_mat_proc_p , 
									cd_material_barras_w , 
									cd_procedimento_w, 
									vl_operacao_p , 
									qt_material_p , 
									vl_total_op_p , 
									dt_operacao_p , 
									ie_tipo_operacao_p , 
									cd_pessoa_fisica_p , 
									nr_seq_ordem_servico_p,
									trunc(clock_timestamp()),
									nm_usuario_p,
									null,
									null,
									qt_peso_p,
									ds_unidade_medida_p,
									nr_seq_terceiro_p,
									nr_seq_operacao_p,
									ie_operacao_origem_p,
									nr_codigo_barras_p);
									
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE html_registrar_operacao_terc ( id_sessao_p text, nm_terceiro_p text, ds_mat_proc_p text, cd_material_barras_p bigint, vl_operacao_p bigint, qt_material_p bigint, vl_total_op_p bigint, dt_operacao_p timestamp, ie_tipo_operacao_p text, cd_pessoa_fisica_p bigint, nr_seq_ordem_servico_p bigint, qt_peso_p bigint, ds_unidade_medida_p text, nr_seq_terceiro_p bigint, nm_usuario_p text, nr_seq_operacao_p bigint, ie_operacao_origem_p bigint, nr_codigo_barras_p text) FROM PUBLIC;
