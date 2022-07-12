-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_volume_elem_regra_dec ( nr_seq_elemento_p bigint, qt_elemento_p bigint, ie_tipo_npt_p text) RETURNS bigint AS $body$
DECLARE

nr_casas_w	bigint;
ie_existe_w	varchar(1);
qt_retorno_w	double precision;

BEGIN
qt_retorno_w := qt_elemento_p;
if (nr_seq_elemento_p IS NOT NULL AND nr_seq_elemento_p::text <> '') then
	/* Verifica se existe alguma regra para arredondar as casas decimais da quantidade de elemento */

	select	coalesce(max('S'),'N')
	into STRICT	ie_existe_w
	from	nut_arredonda_volume
	where	nr_seq_elemento = nr_seq_elemento_p
	and	ie_npt 		= ie_tipo_npt_p
	and	qt_elemento_p	between qt_inicial and qt_final;
	/* Se existir busca a quantidade de casas para arredondar */

	if (ie_existe_w = 'S') then
		select	coalesce(max(nr_casas),0)
		into STRICT	nr_casas_w
		from	nut_arredonda_volume
		where	nr_seq_elemento = nr_seq_elemento_p
		and	ie_npt 		= ie_tipo_npt_p
		and	qt_elemento_p	between qt_inicial and qt_final;
		qt_retorno_w := round(qt_elemento_p,nr_casas_w);
	end if;
end if;
return	qt_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_volume_elem_regra_dec ( nr_seq_elemento_p bigint, qt_elemento_p bigint, ie_tipo_npt_p text) FROM PUBLIC;

