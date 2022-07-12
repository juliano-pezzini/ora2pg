-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cta_obter_se_existe_resp ( nr_seq_tipo_p bigint, nr_seq_estagio_p bigint, dt_pendencia_p timestamp) RETURNS varchar AS $body$
DECLARE


nr_seq_resp_pend_w		bigint;
nr_seq_estagio_w		bigint;
ie_retorno_w			varchar(1);

C01 CURSOR FOR
	SELECT	nr_seq_regra_pend
	from	cta_tipo_regra_resp
	where	nr_seq_tipo_pend = nr_seq_tipo_p
	and 	coalesce(dt_pendencia_p, clock_timestamp()) between dt_inicio_vigencia and coalesce(dt_fim_vigencia,clock_timestamp())
	and 	dt_inicio_vigencia = 	(SELECT max(dt_inicio_vigencia)
					from 	cta_tipo_regra_resp
					where	nr_seq_tipo_pend = nr_seq_tipo_p
					and 	coalesce(dt_pendencia_p, clock_timestamp()) between dt_inicio_vigencia and coalesce(dt_fim_vigencia,clock_timestamp()))
	order by nr_sequencia;

C02 CURSOR FOR
	SELECT	nr_seq_estagio
	from	cta_regra_resp_item
	where	nr_seq_regra = nr_seq_resp_pend_w
	order by coalesce(nr_seq_estagio,0);


BEGIN

ie_retorno_w:= 'N';

open C01;
loop
fetch C01 into
	nr_seq_resp_pend_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	open C02;
	loop
	fetch C02 into
		nr_seq_estagio_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		if (coalesce(nr_seq_estagio_w,nr_seq_estagio_p) = nr_seq_estagio_p) then
			ie_retorno_w:= 'S';
		end if;
		end;
	end loop;
	close C02;

	end;
end loop;
close C01;

return ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cta_obter_se_existe_resp ( nr_seq_tipo_p bigint, nr_seq_estagio_p bigint, dt_pendencia_p timestamp) FROM PUBLIC;
