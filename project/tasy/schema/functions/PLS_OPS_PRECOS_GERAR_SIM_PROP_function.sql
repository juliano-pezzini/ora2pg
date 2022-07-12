-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_ops_precos_gerar_sim_prop ( nr_seq_proposta_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) RETURNS bigint AS $body$
DECLARE

 
vl_retorno	bigint;


BEGIN 
 
CALL pls_gerar_simulacao_proposta( 
	nr_seq_proposta_p, 
	nm_usuario_p, 
	cd_estabelecimento_p);
 
select	max(nr_sequencia) 
into STRICT	vl_retorno 
from	pls_simulacao_preco;
 
return	vl_retorno;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_ops_precos_gerar_sim_prop ( nr_seq_proposta_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

