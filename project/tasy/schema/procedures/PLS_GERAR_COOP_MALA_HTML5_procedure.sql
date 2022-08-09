-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_coop_mala_html5 ( nr_seq_situacao_cooperado_p bigint, nr_seq_especialidade_coop_p bigint, ie_vinc_contratual_coop_p text, nr_crm_cooperado_p text, area_atuacao_coop_p bigint, cd_municipio_cooperado_p text, ie_tipo_cooperado_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
BEGIN

CALL pls_gerar_mala_direta_pck.gerar_cooperado(	nr_seq_situacao_cooperado_p,
						nr_seq_especialidade_coop_p,
						ie_vinc_contratual_coop_p,
						nr_crm_cooperado_p,
						area_atuacao_coop_p,
						cd_municipio_cooperado_p,
						ie_tipo_cooperado_p,
						cd_estabelecimento_p,
						nm_usuario_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_coop_mala_html5 ( nr_seq_situacao_cooperado_p bigint, nr_seq_especialidade_coop_p bigint, ie_vinc_contratual_coop_p text, nr_crm_cooperado_p text, area_atuacao_coop_p bigint, cd_municipio_cooperado_p text, ie_tipo_cooperado_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
