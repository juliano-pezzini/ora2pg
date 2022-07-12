-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_estabelecimento_fila (nr_seq_fila_p bigint) RETURNS varchar AS $body$
DECLARE


ds_estabelecimento_w	varchar(255);


BEGIN
if (coalesce(nr_seq_fila_p,0) > 0) then
	select	max(substr(obter_nome_estab(cd_estabelecimento),1,255))
	into STRICT	ds_estabelecimento_w
	from	fila_espera_senha
	where	nr_sequencia = nr_seq_fila_p;
end if;


return	ds_estabelecimento_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_estabelecimento_fila (nr_seq_fila_p bigint) FROM PUBLIC;
