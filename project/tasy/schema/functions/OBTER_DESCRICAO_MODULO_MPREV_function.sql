-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_descricao_modulo_mprev (nr_seq_modulo bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	MPREV_MODULO_ATEND.ds_modulo%type	:= null;


BEGIN

if (nr_seq_modulo IS NOT NULL AND nr_seq_modulo::text <> '') then
	select	ds_modulo
	into STRICT	ds_retorno_w
	from	MPREV_MODULO_ATEND
	where	nr_sequencia = nr_seq_modulo;
end if;


return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_descricao_modulo_mprev (nr_seq_modulo bigint) FROM PUBLIC;
