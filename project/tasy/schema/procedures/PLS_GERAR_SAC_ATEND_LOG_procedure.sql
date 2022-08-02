-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_sac_atend_log ( cd_pessoa_fisica_p text, cd_cgc_p text, ds_ocorrencia_p text, nr_seq_atendimento_p bigint, nr_seq_evento_atend_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, ie_origem_historico_p text) AS $body$
BEGIN

CALL pls_gerar_sac_atend(
	cd_pessoa_fisica_p,
	cd_cgc_p,
	ds_ocorrencia_p,
	nr_seq_atendimento_p,
	nr_seq_evento_atend_p,
	nm_usuario_p,
	cd_estabelecimento_p);

CALL pls_gerar_hist_log_atend(
	nr_seq_atendimento_p,
	ie_origem_historico_p,
	2000,
	nm_usuario_p,
	cd_estabelecimento_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_sac_atend_log ( cd_pessoa_fisica_p text, cd_cgc_p text, ds_ocorrencia_p text, nr_seq_atendimento_p bigint, nr_seq_evento_atend_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, ie_origem_historico_p text) FROM PUBLIC;

