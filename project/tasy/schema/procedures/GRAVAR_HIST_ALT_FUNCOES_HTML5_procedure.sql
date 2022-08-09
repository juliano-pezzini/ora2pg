-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_hist_alt_funcoes_html5 () AS $body$
BEGIN

insert into funcoes_html5_hist(
		nr_sequencia                 ,
		dt_referencia                ,
		dt_atualizacao               ,
		nm_usuario                   ,
		dt_atualizacao_nrec          ,
		nm_usuario_nrec              ,
		nr_seq_funcao                ,
		cd_funcao                    ,
		cd_pessoa_analista_neg       ,
		cd_pessoa_analista_oper      ,
		cd_pessoa_dev_led            ,
		cd_pessoa_fisica             ,
		cd_tester                    ,
		ds_versao_java               ,
		ds_versao_test_case          ,
		dt_aprov_check_point         ,
		dt_entrega_desej_analise     ,
		dt_entrega_desejada          ,
		dt_prev_aprov_gerente        ,
		dt_prev_checkpoint           ,
		dt_prev_entrega_analise      ,
		dt_prev_entrega_progr        ,
		dt_prev_fim_anal_fun         ,
		dt_prev_fim_analise          ,
		dt_prev_fim_fun              ,
		dt_prev_fim_prog             ,
		dt_prev_fim_prog_fun         ,
		dt_prev_fim_teste            ,
		dt_prev_fim_teste_fun        ,
		dt_prev_inicio_anal_fun      ,
		dt_prev_inicio_analise       ,
		dt_prev_inicio_fun           ,
		dt_prev_inicio_prog          ,
		dt_prev_inicio_prog_fun      ,
		dt_prev_inicio_teste         ,
		dt_prev_inicio_teste_fun     ,
		dt_real_aprov_gerente        ,
		dt_real_checkpoint           ,
		dt_real_fim_analise          ,
		dt_real_fim_fun              ,
		dt_real_fim_prog             ,
		dt_real_fim_teste            ,
		dt_real_inicio_analise       ,
		dt_real_inicio_fun           ,
		dt_real_inicio_prog          ,
		dt_real_inicio_teste         ,
		ie_escopo_atual              ,
		ie_mercado_global            ,
		ie_ppc                       ,
		ie_ppc_original              ,
		ie_prioridade                ,
		ie_quarter_entrega           ,
		ie_site_desenv               ,
		ie_situacao                  ,
		ie_status                    ,
		ie_status_vv                 ,
		ie_tamanho_funcao            ,
		ie_tamanho_teste             ,
		ie_tipo_funcao               ,
		nr_round_vv                  ,
		nr_seq_agrupamento           ,
		nr_seq_proj_analise          ,
		nr_seq_proj_prog             ,
		nr_seq_proj_teste            ,
		pr_aderencia_vv              ,
		pr_conclusao                 ,
		pr_conclusao_analis          ,
		pr_conclusao_desenv          ,
		pr_conclusao_prog            ,
		pr_conclusao_teste           ,
		pr_horas_analise             ,
		pr_horas_prog                ,
		pr_horas_teste               ,
		pr_itens_sche_aval           ,
		pr_os_analise                ,
		pr_os_prog                   ,
		pr_os_teste                  ,
		pr_perform_analista          ,
		pr_perform_prog              ,
		pr_perform_teste             ,
		pr_prev_conclus_analise      ,
		pr_prev_conclus_prog         ,
		pr_prev_conclus_teste        ,
		pr_previsto_conclusao        ,
		pr_reprov_vv                 ,
		pr_total_horas_nec_prog      ,
		pr_var_horas_analise         ,
		pr_var_horas_funcao          ,
		pr_var_horas_prog            ,
		pr_var_horas_teste           ,
		qt_gap_os                    ,
		qt_horas_cron_ana_exe        ,
		qt_horas_cron_ana_ext        ,
		qt_horas_cron_analise        ,
		qt_horas_cron_pend_ana_exe   ,
		qt_horas_cron_pend_ana_ext   ,
		qt_horas_cron_pend_analise   ,
		qt_horas_cron_pend_pro_exe   ,
		qt_horas_cron_pend_pro_ext   ,
		qt_horas_cron_pend_prog      ,
		qt_horas_cron_pend_tes_exe   ,
		qt_horas_cron_pend_tes_ext   ,
		qt_horas_cron_pend_teste     ,
		qt_horas_cron_prog           ,
		qt_horas_cron_prog_exe       ,
		qt_horas_cron_prog_ext       ,
		qt_horas_cron_prog_ret       ,
		qt_horas_cron_teste          ,
		qt_horas_cron_teste_exe      ,
		qt_horas_cron_teste_ext      ,
		qt_horas_pend_analista       ,
		qt_horas_pend_analista_exe   ,
		qt_horas_pend_analista_ext   ,
		qt_horas_pend_prog           ,
		qt_horas_pend_prog_exe       ,
		qt_horas_pend_prog_ext       ,
		qt_horas_pend_teste          ,
		qt_horas_pend_teste_exe      ,
		qt_horas_pend_teste_ext      ,
		qt_horas_robo_analise        ,
		qt_horas_robo_prog           ,
		qt_horas_total_ajustado      ,
		qt_horas_total_ana_exe       ,
		qt_horas_total_ana_ext       ,
		qt_horas_total_analista      ,
		qt_horas_total_prog          ,
		qt_horas_total_prog_exe      ,
		qt_horas_total_prog_ext      ,
		qt_horas_total_robo          ,
		qt_horas_total_teste         ,
		qt_horas_total_teste_exe     ,
		qt_horas_total_teste_ext     ,
		qt_linhas_angular_back       ,
		qt_linhas_angular_front      ,
		qt_linhas_java_back          ,
		qt_linhas_java_front         ,
		qt_linhas_previstas_ang_back ,
		qt_linhas_previstas_ang_front,
		qt_os_design                 ,
		qt_os_pend_analista          ,
		qt_os_pend_analista_exe      ,
		qt_os_pend_analista_ext      ,
		qt_os_pend_prog              ,
		qt_os_pend_prog_exe          ,
		qt_os_pend_prog_ext          ,
		qt_os_pend_vv                ,
		qt_os_pend_vv_exe            ,
		qt_os_pend_vv_ext            ,
		qt_os_tec                    ,
		qt_os_tec_defeito            ,
		qt_os_total_analista         ,
		qt_os_total_analista_exe     ,
		qt_os_total_analista_ext     ,
		qt_os_total_prog             ,
		qt_os_total_prog_exe         ,
		qt_os_total_prog_ext         ,
		qt_os_vv                     ,
		qt_os_vv_aguar_v             ,
		qt_os_vv_exe                 ,
		qt_os_vv_ext                 ,
		qt_os_vv_pend_dev            ,
		qt_os_vv_pend_tec            ,
		qt_os_vv_pend_test           ,
		qt_tempo_total               ,
		qt_total_horas_aval          ,
		qt_total_horas_nec_prog      ,
		qt_total_itens_sche_aval     ,
		qt_total_itens_schematic     ,
		qt_tx_conversao              ,
		qt_tx_conversao_back         ,
		qt_tx_conversao_front        ,
		tempo_gap_os                 ,
		nr_ordem_serv_tre			 ,
		nr_ordem_serv_tre_en		 ,
		dt_ordem_serv_tre			 ,
		dt_ordem_serv_tre_en		 ,
		dt_inicio_prev_tre			 ,
		dt_inicio_real_tre			 ,
		dt_inicio_prev_tre_en		 ,
		dt_fim_prev_tre			 	 ,
		dt_fim_prev_tre_en			 ,
		dt_inicio_real_tre_en		 ,
		dt_fim_real_tre				 ,
		dt_fim_real_tre_en			 ,
		qt_ordem_serv_tre			 ,
		qt_ordem_serv_tre_en   )
SELECT
		nextval('funcoes_html5_hist_seq')	,
		trunc(clock_timestamp())				 	,
		dt_atualizacao               	,
		nm_usuario                   	,
		dt_atualizacao_nrec          	,
		nm_usuario_nrec              	,
		nr_sequencia                 	,
		cd_funcao                    	,
		cd_pessoa_analista_neg       	,
		cd_pessoa_analista_oper      	,
		cd_pessoa_dev_led            	,
		cd_pessoa_fisica             	,
		cd_tester                    	,
		ds_versao_java               	,
		ds_versao_test_case          	,
		dt_aprov_check_point         	,
		dt_entrega_desej_analise     	,
		dt_entrega_desejada          	,
		dt_prev_aprov_gerente        	,
		dt_prev_checkpoint           	,
		dt_prev_entrega_analise      	,
		dt_prev_entrega_progr        	,
		dt_prev_fim_anal_fun         	,
		dt_prev_fim_analise          	,
		dt_prev_fim_fun              	,
		dt_prev_fim_prog             	,
		dt_prev_fim_prog_fun         	,
		dt_prev_fim_teste            	,
		dt_prev_fim_teste_fun        	,
		dt_prev_inicio_anal_fun      	,
		dt_prev_inicio_analise       	,
		dt_prev_inicio_fun           	,
		dt_prev_inicio_prog          	,
		dt_prev_inicio_prog_fun      	,
		dt_prev_inicio_teste         	,
		dt_prev_inicio_teste_fun     	,
		dt_real_aprov_gerente        	,
		dt_real_checkpoint           	,
		dt_real_fim_analise          	,
		dt_real_fim_fun              	,
		dt_real_fim_prog             	,
		dt_real_fim_teste            	,
		dt_real_inicio_analise       	,
		dt_real_inicio_fun           	,
		dt_real_inicio_prog          	,
		dt_real_inicio_teste         	,
		ie_escopo_atual              	,
		ie_mercado_global            	,
		ie_ppc                       	,
		ie_ppc_original              	,
		ie_prioridade                	,
		ie_quarter_entrega           	,
		ie_site_desenv               	,
		ie_situacao                  	,
		ie_status                    	,
		ie_status_vv                 	,
		ie_tamanho_funcao            	,
		ie_tamanho_teste             	,
		ie_tipo_funcao               	,
		nr_round_vv                  	,
		nr_seq_agrupamento           	,
		nr_seq_proj_analise          	,
		nr_seq_proj_prog             	,
		nr_seq_proj_teste            	,
		pr_aderencia_vv              	,
		pr_conclusao                 	,
		pr_conclusao_analis          	,
		pr_conclusao_desenv          	,
		pr_conclusao_prog            	,
		pr_conclusao_teste           	,
		pr_horas_analise             	,
		pr_horas_prog                	,
		pr_horas_teste               	,
		pr_itens_sche_aval           	,
		pr_os_analise                	,
		pr_os_prog                   	,
		pr_os_teste                  	,
		pr_perform_analista          	,
		pr_perform_prog              	,
		pr_perform_teste             	,
		pr_prev_conclus_analise      	,
		pr_prev_conclus_prog         	,
		pr_prev_conclus_teste        	,
		pr_previsto_conclusao        	,
		pr_reprov_vv                 	,
		pr_total_horas_nec_prog      	,
		pr_var_horas_analise         	,
		pr_var_horas_funcao          	,
		pr_var_horas_prog            	,
		pr_var_horas_teste           	,
		qt_gap_os                    	,
		qt_horas_cron_ana_exe        	,
		qt_horas_cron_ana_ext        	,
		qt_horas_cron_analise        	,
		qt_horas_cron_pend_ana_exe   	,
		qt_horas_cron_pend_ana_ext   	,
		qt_horas_cron_pend_analise   	,
		qt_horas_cron_pend_pro_exe   	,
		qt_horas_cron_pend_pro_ext   	,
		qt_horas_cron_pend_prog      	,
		qt_horas_cron_pend_tes_exe   	,
		qt_horas_cron_pend_tes_ext   	,
		qt_horas_cron_pend_teste     	,
		qt_horas_cron_prog           	,
		qt_horas_cron_prog_exe       	,
		qt_horas_cron_prog_ext       	,
		qt_horas_cron_prog_ret       	,
		qt_horas_cron_teste          	,
		qt_horas_cron_teste_exe      	,
		qt_horas_cron_teste_ext      	,
		qt_horas_pend_analista       	,
		qt_horas_pend_analista_exe   	,
		qt_horas_pend_analista_ext   	,
		qt_horas_pend_prog           	,
		qt_horas_pend_prog_exe       	,
		qt_horas_pend_prog_ext       	,
		qt_horas_pend_teste          	,
		qt_horas_pend_teste_exe      	,
		qt_horas_pend_teste_ext      	,
		qt_horas_robo_analise        	,
		qt_horas_robo_prog           	,
		qt_horas_total_ajustado      	,
		qt_horas_total_ana_exe       	,
		qt_horas_total_ana_ext       	,
		qt_horas_total_analista      	,
		qt_horas_total_prog          	,
		qt_horas_total_prog_exe      	,
		qt_horas_total_prog_ext      	,
		qt_horas_total_robo          	,
		qt_horas_total_teste         	,
		qt_horas_total_teste_exe     	,
		qt_horas_total_teste_ext     	,
		qt_linhas_angular_back       	,
		qt_linhas_angular_front      	,
		qt_linhas_java_back          	,
		qt_linhas_java_front         	,
		qt_linhas_previstas_ang_back 	,
		qt_linhas_previstas_ang_front	,
		qt_os_design                 	,
		qt_os_pend_analista          	,
		qt_os_pend_analista_exe      	,
		qt_os_pend_analista_ext      	,
		qt_os_pend_prog              	,
		qt_os_pend_prog_exe          	,
		qt_os_pend_prog_ext          	,
		qt_os_pend_vv                	,
		qt_os_pend_vv_exe            	,
		qt_os_pend_vv_ext            	,
		qt_os_tec                    	,
		qt_os_tec_defeito            	,
		qt_os_total_analista         	,
		qt_os_total_analista_exe     	,
		qt_os_total_analista_ext     	,
		qt_os_total_prog             	,
		qt_os_total_prog_exe         	,
		qt_os_total_prog_ext         	,
		qt_os_vv                     	,
		qt_os_vv_aguar_v             	,
		qt_os_vv_exe                 	,
		qt_os_vv_ext                 	,
		qt_os_vv_pend_dev            	,
		qt_os_vv_pend_tec            	,
		qt_os_vv_pend_test           	,
		qt_tempo_total               	,
		qt_total_horas_aval          	,
		qt_total_horas_nec_prog      	,
		qt_total_itens_sche_aval     	,
		qt_total_itens_schematic     	,
		qt_tx_conversao              	,
		qt_tx_conversao_back         	,
		qt_tx_conversao_front        	,
		tempo_gap_os                    ,
		nr_ordem_serv_tre			 ,
		nr_ordem_serv_tre_en		 ,
		dt_ordem_serv_tre			 ,
		dt_ordem_serv_tre_en		 ,
		dt_inicio_prev_tre			 ,
		dt_inicio_real_tre			 ,
		dt_inicio_prev_tre_en		 ,
		dt_fim_prev_tre			 	 ,
		dt_fim_prev_tre_en			 ,
		dt_inicio_real_tre_en		 ,
		dt_fim_real_tre				 ,
		dt_fim_real_tre_en			 ,
		qt_ordem_serv_tre			 ,
		qt_ordem_serv_tre_en
from	funcoes_html5;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_hist_alt_funcoes_html5 () FROM PUBLIC;
