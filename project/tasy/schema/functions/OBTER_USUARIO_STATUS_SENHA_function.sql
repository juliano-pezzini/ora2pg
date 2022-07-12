-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_usuario_status_senha (nr_seq_status_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);


BEGIN

if (nr_seq_status_p IS NOT NULL AND nr_seq_status_p::text <> '') then

	begin

	select	max(ds_status)
	into STRICT	ds_retorno_w
	from	status_atendente_senha
	where	nr_sequencia = nr_seq_status_p;

	end;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_usuario_status_senha (nr_seq_status_p bigint) FROM PUBLIC;

