-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION san_formata_qtd_doacao (nr_seq_doacao_p bigint) RETURNS varchar AS $body$
DECLARE


cd_pessoa_fisica_w  	varchar(10);
qt_doacao_w		integer;
ds_retorno_w		varchar(20);

BEGIN

select 	cd_pessoa_fisica
into STRICT	cd_pessoa_fisica_w
from 	san_doacao
where 	nr_sequencia = nr_seq_doacao_p;

qt_doacao_w := obter_qtd_doacoes(cd_pessoa_fisica_w,nr_seq_doacao_p);

if (qt_doacao_w < 10) then
	ds_retorno_w := 0||qt_doacao_w;
else
	ds_retorno_w := qt_doacao_w;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION san_formata_qtd_doacao (nr_seq_doacao_p bigint) FROM PUBLIC;
