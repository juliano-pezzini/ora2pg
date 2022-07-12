-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_apres_fluxograma ( nr_fluxograma_p bigint) RETURNS bigint AS $body$
DECLARE



nr_retorno_w	bigint;
nr_fluxo_w 		bigint;


BEGIN

	if (nr_fluxograma_p > 0) then

		select count(*)
		into STRICT nr_fluxo_w
		from MANCHESTER_FLUXOGRAMA_CLI
		where NR_SEQ_FLUXO = nr_fluxograma_p;

		if (nr_fluxo_w > 0) then

			select max(NR_SEQ_APRESENTACAO)
			into STRICT nr_retorno_w
			from MANCHESTER_FLUXOGRAMA_CLI
			where NR_SEQ_FLUXO = nr_fluxograma_p;

		else

			select max(NR_SEQ_APRESENTACAO)
			into STRICT nr_retorno_w
			from MANCHESTER_FLUXOGRAMA
			where nr_sequencia = nr_fluxograma_p;

		end if;
	end if;

return	nr_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_apres_fluxograma ( nr_fluxograma_p bigint) FROM PUBLIC;

