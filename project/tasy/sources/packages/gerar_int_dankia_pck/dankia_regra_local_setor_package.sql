-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE gerar_int_dankia_pck.dankia_regra_local_setor ( nr_seq_regra_setor_p bigint, cd_local_estoque_p bigint, ie_operacao_p text, nm_usuario_p text) AS $body$
BEGIN
	if (get_ie_int_dankia = 'S') then
		select	max(cd_setor_atendimento)
		into STRICT 	current_setting('gerar_int_dankia_pck.cd_setor_atendimento_w')::dis_regra_setor.cd_setor_atendimento%type
		from	dis_regra_setor
		where 	nr_sequencia = nr_seq_regra_setor_p;
		
		select	coalesce(max('S'),'N')
		into STRICT 	current_setting('gerar_int_dankia_pck.ie_passagem_w')::varchar(1)
		from 	setor_atendimento
		where 	cd_setor_atendimento = current_setting('gerar_int_dankia_pck.cd_setor_atendimento_w')::dis_regra_setor.cd_setor_atendimento%type
		and 	cd_classif_setor not in (3,4,5);
		
		insert into dankia_disp_setor(
				 nr_sequencia,
				 cd_estabelecimento,
				 dt_atualizacao,
				 nm_usuario,
				 cd_setor_atendimento,
				 ds_setor_atendimento,
				 cd_local_estoque,
				 ie_passagem,
				 ie_operacao,
				 dt_lido_dankia,
				 ie_processado,
				 ds_stack,
				 ds_processado_observacao)
		values (nextval('dankia_disp_setor_seq'),
				gerar_int_dankia_pck.get_cd_estabelecimento(cd_local_estoque_p),
				clock_timestamp(),
				nm_usuario_p,
				current_setting('gerar_int_dankia_pck.cd_setor_atendimento_w')::dis_regra_setor.cd_setor_atendimento%type,
				substr(obter_desc_setor_atend(current_setting('gerar_int_dankia_pck.cd_setor_atendimento_w')::dis_regra_setor.cd_setor_atendimento%type),1,100),
				cd_local_estoque_p,
				current_setting('gerar_int_dankia_pck.ie_passagem_w')::varchar(1),
				ie_operacao_p,
				null,
				'N',
				substr(dbms_utility.format_call_stack,1,2000),
				null);
	end if;
	end;
	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_int_dankia_pck.dankia_regra_local_setor ( nr_seq_regra_setor_p bigint, cd_local_estoque_p bigint, ie_operacao_p text, nm_usuario_p text) FROM PUBLIC;