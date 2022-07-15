-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE deletar_titulo_escrit ( nr_seq_escrit_p banco_escritural.nr_sequencia%Type, nr_titulo_p titulo_pagar.nr_titulo%Type, ie_pagar_receber_p text) AS $body$
BEGIN
if (upper(ie_pagar_receber_p) = 'P')	then
	delete
	from	titulo_pagar_escrit
	where	nr_seq_escrit 	= 	nr_seq_escrit_p
	and	nr_titulo	=	nr_titulo_p
	and	coalesce(ie_selecionado,'N') = 'S';
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE deletar_titulo_escrit ( nr_seq_escrit_p banco_escritural.nr_sequencia%Type, nr_titulo_p titulo_pagar.nr_titulo%Type, ie_pagar_receber_p text) FROM PUBLIC;

