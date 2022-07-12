-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_reaj_benef_coletivo ( nr_seq_reajuste_p bigint) RETURNS varchar AS $body$
DECLARE


qt_registros_w			bigint;
qt_reajustes_w			bigint;
qt_registros_def_w		bigint;


BEGIN

select	count(1)
into STRICT	qt_registros_w
from	PLS_LOTE_REAJ_SEGURADO
where	nr_seq_reajuste	= nr_seq_reajuste_p;

if (qt_registros_w = 0) then
	select	count(1)
	into STRICT	qt_registros_w
	from	PLS_LOTE_REAJ_SEGURADO
	where	nr_seq_lote_referencia	= nr_seq_reajuste_p;

	if (qt_registros_w = 0) then
		return '';
	else
		select	count(1)
		into STRICT	qt_registros_def_w
		from	PLS_LOTE_REAJ_SEGURADO
		where	nr_seq_lote_referencia	= nr_seq_reajuste_p
		and	IE_STATUS	= '2';

		if (qt_registros_def_w = qt_registros_w) then
			return 'Definitivo';
		else
			return 'Calculado';
		end if;
	end if;
else
	select	count(1)
	into STRICT	qt_registros_def_w
	from	PLS_LOTE_REAJ_SEGURADO
	where	nr_seq_reajuste	= nr_seq_reajuste_p
	and	IE_STATUS	= '2';

	if (qt_registros_def_w = qt_registros_w) then
		return 'Definitivo';
	else
		return 'Calculado';
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_reaj_benef_coletivo ( nr_seq_reajuste_p bigint) FROM PUBLIC;
