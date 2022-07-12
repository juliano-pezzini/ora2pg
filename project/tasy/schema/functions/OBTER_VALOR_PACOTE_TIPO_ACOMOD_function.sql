-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_pacote_tipo_acomod (nr_seq_pacote_p bigint, cd_tipo_acomodacao_p bigint, nm_usuario_p text, dt_vigencia_p timestamp) RETURNS bigint AS $body$
DECLARE


vl_pacote_w			double precision;

c01 CURSOR FOR
	SELECT	vl_pacote
	from 	pacote_tipo_acomodacao
	where 	nr_seq_pacote	= nr_seq_pacote_p
	and	dt_vigencia_p between dt_vigencia and coalesce(dt_vigencia_final, clock_timestamp() + interval '99999 days')
	and 	ie_tipo_acomod	= cd_tipo_acomodacao_p
	order by dt_vigencia;


BEGIN

open c01;
loop
fetch c01 into
	vl_pacote_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	vl_pacote_w	:= vl_pacote_w;
end loop;
close c01;

return	vl_pacote_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_pacote_tipo_acomod (nr_seq_pacote_p bigint, cd_tipo_acomodacao_p bigint, nm_usuario_p text, dt_vigencia_p timestamp) FROM PUBLIC;
