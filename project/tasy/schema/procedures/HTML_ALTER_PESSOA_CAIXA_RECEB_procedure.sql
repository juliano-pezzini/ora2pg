-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE html_alter_pessoa_caixa_receb ( cd_pessoa_fisica_p text, cd_cgc_p text, nr_seq_receb_p bigint, nm_usuario_p text) AS $body$
BEGIN
if (nr_seq_receb_p IS NOT NULL AND nr_seq_receb_p::text <> '') then
	begin

	if (coalesce(cd_pessoa_fisica_p,'X') <> 'X') and (coalesce(cd_cgc_p,'X') <> 'X') then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(125733);
	end if;

	if (coalesce(cd_pessoa_fisica_p,'X') <> 'X') then

		update	caixa_receb
		set	cd_pessoa_fisica	= cd_pessoa_fisica_p,
			cd_cgc  			 = NULL,
			dt_atualizacao 		= clock_timestamp(),
			nm_usuario 		= nm_usuario_p
		where	nr_sequencia		= nr_seq_receb_p;

	elsif (coalesce(cd_cgc_p,'X') <> 'X') then

		update	caixa_receb
		set	cd_cgc  	= cd_cgc_p,
			cd_pessoa_fisica	 = NULL,
			dt_atualizacao 	= clock_timestamp(),
			nm_usuario 	= nm_usuario_p
		where	nr_sequencia	= nr_seq_receb_p;
	end if;

	commit;

	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE html_alter_pessoa_caixa_receb ( cd_pessoa_fisica_p text, cd_cgc_p text, nr_seq_receb_p bigint, nm_usuario_p text) FROM PUBLIC;
