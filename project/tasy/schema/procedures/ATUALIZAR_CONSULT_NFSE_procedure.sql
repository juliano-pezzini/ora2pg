-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_consult_nfse ( nr_seq_transmissao_p bigint) AS $body$
BEGIN

if (nr_seq_transmissao_p IS NOT NULL AND nr_seq_transmissao_p::text <> '') then

	update	nfe_transmissao
	set	ie_status_transmissao 	= 'EC'
	where	nr_sequencia 		= nr_seq_transmissao_p;
	commit;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_consult_nfse ( nr_seq_transmissao_p bigint) FROM PUBLIC;

