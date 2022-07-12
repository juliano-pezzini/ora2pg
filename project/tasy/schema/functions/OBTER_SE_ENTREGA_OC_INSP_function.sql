-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_entrega_oc_insp ( nr_ordem_compra_p bigint, dt_inicial_p timestamp, dt_final_p timestamp) RETURNS varchar AS $body$
DECLARE


/* Esta function verifica se todos os itens com entrega em data X foram inspecionados */

ie_retorno_w			varchar(1);
qt_retorno_w			smallint;
dt_inicial_w			timestamp;
dt_final_w			timestamp;


BEGIN

dt_inicial_w	:= trunc(dt_inicial_p,'dd');
dt_final_w	:= fim_dia(coalesce(dt_final_p,dt_inicial_w));
ie_retorno_w	:= 'S';

select	count(1)
into STRICT	qt_retorno_w
from	ordem_compra_item_entrega b,
	ordem_compra_item a
where	a.nr_ordem_compra	= b.nr_ordem_compra
and	a.nr_item_oci		= b.nr_item_oci
and	a.nr_ordem_compra	= nr_ordem_compra_p
and	b.dt_prevista_entrega between dt_inicial_w and dt_final_w
and	not exists (
		SELECT	1
		from	inspecao_recebimento x
		where	b.nr_sequencia = x.nr_seq_entrega  LIMIT 1)
and	coalesce(b.dt_cancelamento::text, '') = ''
and	coalesce(a.dt_reprovacao::text, '') = ''  LIMIT 1;


if (qt_retorno_w = 1) then
	begin
	ie_retorno_w := 'N';
	end;
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_entrega_oc_insp ( nr_ordem_compra_p bigint, dt_inicial_p timestamp, dt_final_p timestamp) FROM PUBLIC;

