-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_limite_resc_pagador ( nr_seq_alteracao_motivo_p bigint, nr_seq_segurado_p bigint, dt_inicio_vigencia_p timestamp, qt_contribuicao_p bigint) RETURNS bigint AS $body$
DECLARE


qt_minima_meses_w	bigint;
qt_maximo_meses_w	bigint;
tx_fracao_w		smallint;
qt_meses_incluido_w	integer;
qt_meses_lancados_w	bigint := 0;
qt_tempo_operadora_w	bigint;


BEGIN

begin
select	coalesce(qt_minima_meses,0),
	coalesce(qt_maximo_meses,0),
	coalesce(tx_fracao,0),
	coalesce(qt_tempo_operadora,0)
into STRICT	qt_minima_meses_w,
	qt_maximo_meses_w,
	tx_fracao_w,
	qt_tempo_operadora_w
from	pls_motivo_alt_pagador
where	nr_sequencia	= nr_seq_alteracao_motivo_p
and	ie_situacao	= 'A';
exception
when others then
	qt_minima_meses_w	:= 0;
	qt_maximo_meses_w	:= 0;
	tx_fracao_w		:= 1;
end;

if (coalesce(qt_contribuicao_p,0) > 0) then
	qt_meses_incluido_w	:= qt_contribuicao_p;
else
	qt_meses_incluido_w	:= pls_obter_tempo_benef_contrib( nr_seq_segurado_p, nr_seq_alteracao_motivo_p, dt_inicio_vigencia_p);
end if;

if	((coalesce(qt_tempo_operadora_w,0) = 0) or (coalesce(qt_meses_incluido_w,0) < coalesce( qt_tempo_operadora_w,0))) then
	qt_meses_lancados_w := dividir(qt_meses_incluido_w,tx_fracao_w);

	if (qt_meses_lancados_w	< qt_minima_meses_w) then
		qt_meses_lancados_w	:= qt_minima_meses_w;
	elsif (qt_meses_lancados_w	> qt_maximo_meses_w) and (qt_maximo_meses_w	<> 0) then
		qt_meses_lancados_w	:= qt_maximo_meses_w;
	end if;
end if;

return	qt_meses_lancados_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_limite_resc_pagador ( nr_seq_alteracao_motivo_p bigint, nr_seq_segurado_p bigint, dt_inicio_vigencia_p timestamp, qt_contribuicao_p bigint) FROM PUBLIC;

