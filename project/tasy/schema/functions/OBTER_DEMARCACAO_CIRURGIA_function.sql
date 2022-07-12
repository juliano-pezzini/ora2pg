-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_demarcacao_cirurgia (nr_cirurgia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w varchar(255);


BEGIN

if (coalesce(nr_cirurgia_p,0) > 0)  then

	SELECT MAX(substr(Obter_Valor_Dominio(5718,ie_demarcacao),1,255))
	into STRICT   ds_retorno_w
	FROM   pepo_confirm_demarcacao
	WHERE  nr_cirurgia = nr_cirurgia_p
	and     dt_registro = (SELECT max(dt_registro)
				FROM   pepo_confirm_demarcacao
				WHERE  nr_cirurgia = nr_cirurgia_p);

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_demarcacao_cirurgia (nr_cirurgia_p bigint) FROM PUBLIC;
