-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_email_pessoa_inconsist ( nr_seq_lote_p bigint, cd_pessoa_fisica_p text, cd_cgc_p text, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
BEGIN

if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then
	update 	pls_pessoa_inconsistente
	set    	dt_envio_email 	= clock_timestamp()
	where  	nr_seq_lote    	= nr_seq_lote_p
	and    	cd_pessoa_fisica = cd_pessoa_fisica_p;
elsif (cd_cgc_p IS NOT NULL AND cd_cgc_p::text <> '') then
	update pls_pessoa_inconsistente
	set    dt_envio_email 	= clock_timestamp()
	where  nr_seq_lote    	= nr_seq_lote_p
	and    cd_cgc		= cd_cgc_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_email_pessoa_inconsist ( nr_seq_lote_p bigint, cd_pessoa_fisica_p text, cd_cgc_p text, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
