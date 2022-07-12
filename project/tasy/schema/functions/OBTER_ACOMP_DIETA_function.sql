-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_acomp_dieta ( nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


qt_dieta_acomp_w	smallint;
ds_dieta_w		varchar(2000);


BEGIN

select	max(coalesce(qt_dieta_acomp,0)),
	max(obter_valor_dominio(1396,ie_lib_dieta)) ds_dieta
into STRICT	qt_dieta_acomp_w,
	ds_dieta_w
from	atend_categoria_convenio
where	nr_atendimento = nr_atendimento_p
and	nr_seq_interno = obter_atecaco_atendimento(nr_atendimento_p);

if (qt_dieta_acomp_w > 0) then
	return	wheb_mensagem_pck.get_texto(799261) || ': ' || to_char(qt_dieta_acomp_w)  || '      ' || wheb_mensagem_pck.get_texto(799277) || ': ' || ds_dieta_w;
else
	return	'';
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_acomp_dieta ( nr_atendimento_p bigint) FROM PUBLIC;
