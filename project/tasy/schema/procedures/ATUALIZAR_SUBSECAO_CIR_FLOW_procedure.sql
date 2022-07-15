-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_subsecao_cir_flow (nr_sequencia_p bigint, nr_seq_conf_info_p bigint, nr_seq_cirur_agente_p bigint, nr_seq_sinal_vital_p bigint, nr_seq_conf_grupo_p bigint, nr_seq_mod_sec_agtm_p bigint, nr_seq_tipo_bh_p bigint, nr_seq_result_item_p bigint, nr_seq_resultado_p bigint, cd_evolucao_p bigint, ie_resumo_bh_p text, ie_checado_p text, nm_usuario_p text, nr_seq_exame_p bigint, nr_seq_dispositivo_p bigint) AS $body$
DECLARE


nr_seq_info_w bigint;


BEGIN
if (nr_seq_conf_info_p IS NOT NULL AND nr_seq_conf_info_p::text <> '') then
	update  w_flowsheet_config_info
	set 	ie_visivel 	   = ie_checado_p,
			dt_atualizacao = clock_timestamp(),
			nm_usuario     = nm_usuario_p
	where 	nr_sequencia   = nr_seq_conf_info_p;
	
	update  w_flowsheet_cirurgia_info
	set 	ie_visivel 	   = ie_checado_p,
			dt_atualizacao = clock_timestamp(),
			nm_usuario     = nm_usuario_p
	where   nr_sequencia   = nr_sequencia_p;
else
	select   nextval('w_flowsheet_config_info_seq')
	into STRICT     nr_seq_info_w
	;

	insert into w_flowsheet_config_info(nr_sequencia,
										dt_atualizacao,
										nm_usuario,
										dt_atualizacao_nrec,
										nm_usuario_nrec,
										nr_seq_config_grupo,
										nr_seq_cirur_agente,										
										nr_seq_sinal_vital,										
										nr_seq_mod_sec_agt_med,																				
										nr_seq_result_item,
										nr_seq_resultado,
										cd_evolucao,
										ie_resumo_bh,
										ie_visivel,
										nr_seq_tipo_bh,
										nr_seq_exame,
										nr_seq_dispositivo
										)
	values (nr_seq_info_w,
										clock_timestamp(),
										nm_usuario_p,
										clock_timestamp(),
										nm_usuario_p,
										nr_seq_conf_grupo_p,
										nr_seq_cirur_agente_p,
										nr_seq_sinal_vital_p,										
										nr_seq_mod_sec_agtm_p,																				
										nr_seq_result_item_p,
										nr_seq_resultado_p,
										cd_evolucao_p,
										ie_resumo_bh_p,										
										ie_checado_p,
										nr_seq_tipo_bh_p,
										nr_seq_exame_p,
										nr_seq_dispositivo_p);
	
	update  w_flowsheet_cirurgia_info
	   set 	nr_seq_conf_info = nr_seq_info_w,
			ie_visivel 	   = ie_checado_p,
			dt_atualizacao = clock_timestamp(),
			nm_usuario     = nm_usuario_p
	 where  nr_sequencia = nr_sequencia_p;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_subsecao_cir_flow (nr_sequencia_p bigint, nr_seq_conf_info_p bigint, nr_seq_cirur_agente_p bigint, nr_seq_sinal_vital_p bigint, nr_seq_conf_grupo_p bigint, nr_seq_mod_sec_agtm_p bigint, nr_seq_tipo_bh_p bigint, nr_seq_result_item_p bigint, nr_seq_resultado_p bigint, cd_evolucao_p bigint, ie_resumo_bh_p text, ie_checado_p text, nm_usuario_p text, nr_seq_exame_p bigint, nr_seq_dispositivo_p bigint) FROM PUBLIC;

