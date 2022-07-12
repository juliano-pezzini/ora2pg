-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_local_equip (nr_seq_localizacao_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/*
A - Ander
B - Bloco

*/
ds_retorno_w	varchar(255);


BEGIN

if (ie_opcao_p = 'A') then
	select	substr(obter_desc_andar(nr_seq_andar),1,200)
	into STRICT	ds_retorno_w
	from	man_localizacao
	where	nr_sequencia = nr_seq_localizacao_p;
elsif (ie_opcao_p = 'B') then
	select	substr(obter_desc_bloco(nr_seq_bloco),1,200)
	into STRICT	ds_retorno_w
	from	man_localizacao
	where	nr_sequencia = nr_seq_localizacao_p;
end if;



return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_local_equip (nr_seq_localizacao_p bigint, ie_opcao_p text) FROM PUBLIC;
