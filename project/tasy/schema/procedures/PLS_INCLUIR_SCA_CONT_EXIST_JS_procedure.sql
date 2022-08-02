-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_incluir_sca_cont_exist_js ( nr_seq_proposta_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, nr_seq_contrato_p bigint, nr_contrato_p INOUT bigint) AS $body$
BEGIN
 
CALL pls_incluir_sca_cont_exist( 
	nr_seq_proposta_p, 
	nm_usuario_p, 
	cd_estabelecimento_p);
 
nr_contrato_p	:= pls_obter_seq_contrato(nr_seq_contrato_p);
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_incluir_sca_cont_exist_js ( nr_seq_proposta_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, nr_seq_contrato_p bigint, nr_contrato_p INOUT bigint) FROM PUBLIC;

