-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE seta_data_certifi_sbis ( nr_sequencia_p bigint, ie_opcao_p text, nm_usuario_p text) AS $body$
DECLARE

/*
ie_opcao_p    = 'R' Data de recebimento
ie_opcao_p    = 'P' Data de pagamento
ie_opcao_p    =  'CT' confirmação da taxa
ie_opcao_p    =  'CP' Confirmação de pagamento
*/
BEGIN
if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	if (ie_opcao_p = 'R') then
		begin
		update	alteracao_tasy_sbis
		set	dt_receb_taxa		= clock_timestamp(),
			nm_usuario_receb_taxa	= nm_usuario_p
		where	nr_sequencia		= nr_sequencia_p;
		end;
	elsif (ie_opcao_p = 'P') then
		begin
		update	alteracao_tasy_sbis
		set	dt_pagto_taxa		= clock_timestamp(),
			nm_usuario_pagto_taxa	= nm_usuario_p
		where	nr_sequencia		= nr_sequencia_p;
		end;
	elsif (ie_opcao_p = 'CT') then
		begin
		update	alteracao_tasy_sbis
		set  	dt_conf_pagto_taxa	= clock_timestamp(),
			nm_usuario_conf_pagto	= nm_usuario_p
		where  nr_sequencia		= nr_sequencia_p;
		end;
	elsif (ie_opcao_p  = 'CP') then
		begin
		update	alteracao_tasy_sbis
		set	dt_conf_extensao        	= clock_timestamp(),
			nm_usuario_conf_extensao	= nm_usuario_p
		where	nr_sequencia		= nr_sequencia_p;
		end;
	end if;
	end;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE seta_data_certifi_sbis ( nr_sequencia_p bigint, ie_opcao_p text, nm_usuario_p text) FROM PUBLIC;
