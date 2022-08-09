-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE san_inutil_bolsa_campanha ( nr_sequencia_p bigint, nr_seq_inutil_p bigint, ds_observacao_inutil_p text) AS $body$
BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then

	update	san_doacao_campanha
	set		ds_observacao_inutil	= ds_observacao_inutil_p,
			nr_seq_inutil			= nr_seq_inutil_p
	where	nr_sequencia	= nr_sequencia_p;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE san_inutil_bolsa_campanha ( nr_sequencia_p bigint, nr_seq_inutil_p bigint, ds_observacao_inutil_p text) FROM PUBLIC;
