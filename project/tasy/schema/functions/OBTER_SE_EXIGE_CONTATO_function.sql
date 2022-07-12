-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_exige_contato (nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(5);
qt_reg_w		integer;


BEGIN

select 	count(*)
into STRICT	qt_reg_w
from	orientacao_alta_enf
where	nr_atendimento = nr_atendimento_p
and	ie_exige_contato = 'S'
and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
and	coalesce(dt_inativacao::text, '') = '';

if (qt_reg_w > 0) then
	ds_retorno_w	:= 	'S';
else
	ds_retorno_w	:= 	'N';
end if;


return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_exige_contato (nr_atendimento_p bigint) FROM PUBLIC;

