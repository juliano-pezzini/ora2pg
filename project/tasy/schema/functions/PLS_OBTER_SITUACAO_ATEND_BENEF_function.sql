-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_situacao_atend_benef ( nr_seq_segurado_p bigint, dt_referencia_p timestamp) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);
nr_seq_contrato_w	bigint;
qt_suspensao_w		bigint;
ie_situacao_atend_w	varchar(1);
nr_seq_congenere_w	bigint;


BEGIN
select	max(nr_seq_contrato),
	max(nr_seq_congenere)
into STRICT	nr_seq_contrato_w,
	nr_seq_congenere_w
from	pls_segurado
where	nr_sequencia	= nr_seq_segurado_p;

select	count(1)
into STRICT	qt_suspensao_w
from	pls_segurado_suspensao
where	nr_seq_segurado = nr_seq_segurado_p
and	trunc(dt_referencia_p,'dd') between trunc(dt_inicio_suspensao,'dd') and trunc(coalesce(dt_fim_suspensao,dt_referencia_p),'dd')
and	((trunc(dt_referencia_p,'dd') < trunc(dt_fim_suspensao,'dd')) or (coalesce(dt_fim_suspensao::text, '') = ''))
and	(dt_inicio_suspensao IS NOT NULL AND dt_inicio_suspensao::text <> '')  LIMIT 1;

if (qt_suspensao_w = 0) then
	select	count(1)
	into STRICT	qt_suspensao_w
	from	pls_segurado_suspensao
	where	nr_seq_contrato = nr_seq_contrato_w
	and	trunc(dt_referencia_p,'dd') between trunc(dt_inicio_suspensao,'dd') and trunc(coalesce(dt_fim_suspensao,dt_referencia_p),'dd')
	and	((trunc(dt_referencia_p,'dd') < trunc(dt_fim_suspensao,'dd')) or (coalesce(dt_fim_suspensao::text, '') = ''))
	and	(dt_inicio_suspensao IS NOT NULL AND dt_inicio_suspensao::text <> '')  LIMIT 1;

	if (qt_suspensao_w = 0) then
		select	count(1)
		into STRICT	qt_suspensao_w
		from	pls_segurado_suspensao
		where	nr_seq_congenere = nr_seq_congenere_w
		and	trunc(dt_referencia_p,'dd') between trunc(dt_inicio_suspensao,'dd') and trunc(coalesce(dt_fim_suspensao,dt_referencia_p),'dd')
		and	((trunc(dt_referencia_p,'dd') < trunc(dt_fim_suspensao,'dd')) or (coalesce(dt_fim_suspensao::text, '') = ''))
		and	(dt_inicio_suspensao IS NOT NULL AND dt_inicio_suspensao::text <> '')  LIMIT 1;
	end if;
end if;

if (qt_suspensao_w > 0) then
	ie_situacao_atend_w	:= 'S';
else
	begin
		select	ie_situacao_atend
		into STRICT	ie_situacao_atend_w
		from	pls_segurado
		where	nr_sequencia = nr_seq_segurado_p;
	exception
	when others then
		ie_situacao_atend_w := 'S';
	end;
end if;

ds_retorno_w	:= ie_situacao_atend_w;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_situacao_atend_benef ( nr_seq_segurado_p bigint, dt_referencia_p timestamp) FROM PUBLIC;

