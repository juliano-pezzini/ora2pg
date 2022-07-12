-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_banheiro_barthel (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w 	varchar(255);


BEGIN

select 	CASE WHEN IE_BANHEIRO=0 THEN 'Dependente' WHEN IE_BANHEIRO=5 THEN 'Precisa de alguma ajuda mas pode fazer alguma coisa sozinho' WHEN IE_BANHEIRO=10 THEN 'Independente (entrar e sair se vestir e limpar-se)' END
into STRICT	ds_retorno_w
from	escala_barthel
where	nr_sequencia = nr_sequencia_p;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_banheiro_barthel (nr_sequencia_p bigint) FROM PUBLIC;

