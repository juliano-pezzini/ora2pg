-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nome_instancia_servidor ( nr_seq_servidor_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(255)	:= null;

BEGIN
if (nr_seq_servidor_p IS NOT NULL AND nr_seq_servidor_p::text <> '') then
	select	ip_conexao || CASE WHEN coalesce(nr_porta, 0)=0 THEN  null  ELSE ':' || nr_porta END
	into STRICT	ds_retorno_w
	from	servidor_integracao
	where	nr_sequencia	= nr_seq_servidor_p;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nome_instancia_servidor ( nr_seq_servidor_p bigint) FROM PUBLIC;

