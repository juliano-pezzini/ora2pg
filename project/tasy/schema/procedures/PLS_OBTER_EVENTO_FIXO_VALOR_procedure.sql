-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_obter_evento_fixo_valor ( nr_seq_evento_p bigint, nr_seq_regra_fixo_calc_p bigint, dt_referencia_p timestamp, nr_seq_regra_p INOUT bigint) AS $body$
DECLARE


ie_tipo_evento_w	varchar(3);
nr_sequencia_w		bigint;

C01 CURSOR FOR
	SELECT	a.nr_sequencia
	from	pls_evento_fixo_valor	a
	where	((a.nr_seq_evento = coalesce(nr_seq_evento_p,a.nr_seq_evento)) or (coalesce(a.nr_seq_evento::text, '') = ''))
	and	((a.ie_tipo_evento = coalesce(ie_tipo_evento_w,a.ie_tipo_evento)) or (coalesce(a.ie_tipo_evento,'A') = 'A'))
	and	dt_referencia_p between a.dt_inicio_vigencia and coalesce(a.dt_fim_vigencia,dt_referencia_p)
	and	a.nr_seq_regra_fixo	= nr_seq_regra_fixo_calc_p
	and not exists (	SELECT	1
			from	pls_evento_fixo_valor_exc z
			where	z.nr_seq_regra_fixo_valor = a.nr_sequencia
			and	z.nr_seq_evento	= nr_seq_evento_p)
	order by coalesce(a.nr_seq_evento,0),
		coalesce(a.ie_tipo_evento,' ');


BEGIN

select	coalesce(max(ie_tipo_evento),'P')
into STRICT	ie_tipo_evento_w
from	pls_evento
where	nr_sequencia	= nr_seq_evento_p;

open C01;
loop
fetch C01 into
	nr_sequencia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	null;
	end;
end loop;
close C01;

nr_seq_regra_p	:= nr_sequencia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_obter_evento_fixo_valor ( nr_seq_evento_p bigint, nr_seq_regra_fixo_calc_p bigint, dt_referencia_p timestamp, nr_seq_regra_p INOUT bigint) FROM PUBLIC;

