-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE gerar_int_dankia_pck.dankia_atualizar_funcionario ( ie_operacao_p text, ie_profissional_p text, nm_usuario_p text, nm_funcionario_p text, cd_barras_p text, ie_situacao_p text, cd_estabelecimento_p bigint) AS $body$
BEGIN
		if (get_ie_int_dankia = 'S') then
			insert into dankia_disp_funcionario(
					nr_sequencia,
					ie_profissional,
					dt_atualizacao,
					nm_usuario,
					nm_funcionario,
					cd_barras,
					ie_situacao,
					ie_operacao,
					cd_estabelecimento,
					dt_lido_dankia,
					ie_processado,
					ds_processado_observacao,
					ds_stack)
			values (nextval('dankia_disp_funcionario_seq'),
					ie_profissional_p,
					clock_timestamp(),
					nm_usuario_p,
					nm_funcionario_p,
					cd_barras_p,
					ie_situacao_p,
					ie_operacao_p,
					cd_estabelecimento_p,
					null,
					'N',
					null,
					substr(dbms_utility.format_call_stack,1,2000));
		end if;
		end;
	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_int_dankia_pck.dankia_atualizar_funcionario ( ie_operacao_p text, ie_profissional_p text, nm_usuario_p text, nm_funcionario_p text, cd_barras_p text, ie_situacao_p text, cd_estabelecimento_p bigint) FROM PUBLIC;