-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_titulo_cooperado_js ( nr_seq_escrituracao_p bigint, ie_tipo_escrituracao_p bigint, cd_pessoa_fisica_p text, cd_cgc_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
BEGIN
 
if (ie_tipo_escrituracao_p = 'IQ') then 
 
	CALL pls_gerar_tit_quota_part(nr_seq_escrituracao_p, cd_pessoa_fisica_p, cd_cgc_p, cd_estabelecimento_p, nm_usuario_p);
 
elsif (ie_tipo_escrituracao_p = 'DQ') then 
 
	CALL pls_gerar_tit_pagar_quota_part(nr_seq_escrituracao_p, cd_pessoa_fisica_p, cd_cgc_p, cd_estabelecimento_p, nm_usuario_p);
	 
end if;
 
CALL pls_liberar_escrituracao_quota(nr_seq_escrituracao_p, nm_usuario_p);
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_titulo_cooperado_js ( nr_seq_escrituracao_p bigint, ie_tipo_escrituracao_p bigint, cd_pessoa_fisica_p text, cd_cgc_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
