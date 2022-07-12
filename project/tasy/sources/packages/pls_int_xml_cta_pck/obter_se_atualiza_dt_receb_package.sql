-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_int_xml_cta_pck.obter_se_atualiza_dt_receb ( nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, dt_recebimento_p timestamp, nm_usuario_p usuario.nm_usuario%type) RETURNS timestamp AS $body$
DECLARE


dt_recebimento_w	timestamp;


BEGIN

if (nm_usuario_p <> 'WebService') and (coalesce(dt_recebimento_p::text, '') = '') then
	dt_recebimento_w	:= clock_timestamp();
end if;	

return	dt_recebimento_w;

END;				

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_int_xml_cta_pck.obter_se_atualiza_dt_receb ( nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, dt_recebimento_p timestamp, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;