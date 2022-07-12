-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION adep_dados_horarios_pck.get_ds_componente_dialise ( nr_prescricao_p bigint, nr_seq_solucao_p bigint, nr_seq_dialise_cpoe_p bigint, nr_seq_dialise_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint ) RETURNS varchar AS $body$
DECLARE

	
	ds_retorno_w 		varchar(2000)	:= null;
	
BEGIN
	ds_retorno_w := adep_dados_horarios_pck.get_value_concat(ds_retorno_w, obter_componentes_solucao(nr_prescricao_p, nr_seq_solucao_p, 'S' , nm_usuario_p, cd_estabelecimento_p));
	ds_retorno_w := adep_dados_horarios_pck.get_value_concat(ds_retorno_w, Obter_Desc_Vol_Sol_etapa_adep(nr_prescricao_p, nr_seq_solucao_p));
	
	if (pkg_i18n.get_user_locale() = 'en_AU') then
		ds_retorno_w := adep_dados_horarios_pck.get_value_concat(obter_orientacao_dialise(nr_seq_dialise_cpoe_p, nr_prescricao_p, nr_seq_dialise_p), ds_retorno_w);
	else	
		ds_retorno_w := adep_dados_horarios_pck.get_value_concat(ds_retorno_w, obter_orientacao_dialise(nr_seq_dialise_cpoe_p, nr_prescricao_p, nr_seq_dialise_p));
	end if;

	return substr(ds_retorno_w,1,2000);
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION adep_dados_horarios_pck.get_ds_componente_dialise ( nr_prescricao_p bigint, nr_seq_solucao_p bigint, nr_seq_dialise_cpoe_p bigint, nr_seq_dialise_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint ) FROM PUBLIC;
