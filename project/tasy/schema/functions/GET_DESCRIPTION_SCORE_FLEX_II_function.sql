-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_description_score_flex_ii (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(2000) := null;
qt_pontos_w     varchar(50);
nr_seq_escala_w     varchar(50);


BEGIN

	select	nr_seq_escala,
			qt_pontos
	into STRICT 	nr_seq_escala_w,
			qt_pontos_w
	from 	escala_eif_ii
	where 	nr_sequencia = nr_sequencia_p;

if (qt_pontos_w IS NOT NULL AND qt_pontos_w::text <> '') then
	begin

	select 	ds_resultado
	into STRICT	ds_retorno_w
	from   	eif_escala_ii_result
	where   qt_pontos_w between qt_pontos_min and qt_pontos_max
	and	nr_seq_escala = nr_seq_escala_w;

	exception
			when others then
				ds_retorno_w	:= null;
	end;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_description_score_flex_ii (nr_sequencia_p bigint) FROM PUBLIC;
