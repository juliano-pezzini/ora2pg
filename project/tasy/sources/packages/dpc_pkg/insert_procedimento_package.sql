-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE dpc_pkg.insert_procedimento ( cd_procedimento_p bigint, ds_procedimento_p text, ie_situacao_p text, cd_grupo_proc_p bigint, ie_classificacao_p text, ie_origem_proced_p bigint, ie_exige_autor_sus_p text, qt_exec_barra_p bigint, ie_ativ_prof_bpa_p text, ie_alta_complexidade_p text, ie_ignora_origem_p text, ie_classif_custo_p text, ie_localizador_p text, cd_procedimento_loc_p text, nm_usuario_p text) AS $body$
BEGIN
        insert into procedimento(
                                        cd_procedimento,
				        ds_procedimento,
				        ie_situacao,
				        cd_grupo_proc,
				        ie_classificacao,
				        ie_origem_proced,
				        ie_exige_autor_sus,
				        qt_exec_barra,
				        ie_ativ_prof_bpa,
				        ie_alta_complexidade,
				        ie_ignora_origem,
				        ie_classif_custo,
				        ie_localizador,
				        cd_procedimento_loc,
					nm_usuario,
					dt_atualizacao
                                )
			values (       cd_procedimento_p,
                                        ds_procedimento_p,
                                        ie_situacao_p,
                                        cd_grupo_proc_p,
                                        ie_classificacao_p,
                                        ie_origem_proced_p,
                                        ie_exige_autor_sus_p,
                                        qt_exec_barra_p,
                                        ie_ativ_prof_bpa_p,
                                        ie_alta_complexidade_p,
                                        ie_ignora_origem_p,
                                        ie_classif_custo_p,
                                        ie_localizador_p,
                                        cd_procedimento_loc_p,
                                        nm_usuario_p,
                                        clock_timestamp()
                                );
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE dpc_pkg.insert_procedimento ( cd_procedimento_p bigint, ds_procedimento_p text, ie_situacao_p text, cd_grupo_proc_p bigint, ie_classificacao_p text, ie_origem_proced_p bigint, ie_exige_autor_sus_p text, qt_exec_barra_p bigint, ie_ativ_prof_bpa_p text, ie_alta_complexidade_p text, ie_ignora_origem_p text, ie_classif_custo_p text, ie_localizador_p text, cd_procedimento_loc_p text, nm_usuario_p text) FROM PUBLIC;
