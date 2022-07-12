-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hd_obter_dados_dialisador (nr_seq_dialisador_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

ds_retorno_w		varchar(255);
nr_seq_ult_dialise_w	bigint;

/*
S - Ultima sequencia de dialise gerada
*/
BEGIN

select 	max(nr_sequencia)
into STRICT	nr_seq_ult_dialise_w
from	hd_dialise_dialisador
where	nr_seq_dialisador = nr_seq_dialisador_p;


if (ie_opcao_p = 'S') then
	ds_retorno_w	:= nr_seq_ult_dialise_w;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hd_obter_dados_dialisador (nr_seq_dialisador_p bigint, ie_opcao_p text) FROM PUBLIC;
