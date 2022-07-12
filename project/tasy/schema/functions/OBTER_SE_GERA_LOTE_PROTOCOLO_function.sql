-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_gera_lote_protocolo ( nr_seq_protocolo_p bigint, nr_seq_lote_protocolo_p bigint) RETURNS varchar AS $body$
DECLARE

ie_retorno_w	varchar(1) := 'S';
dt_mesano_referencia_lote_w	timestamp;
dt_mesano_referencia_w	timestamp;


BEGIN

if (coalesce(nr_seq_protocolo_p,0) > 0) then

	select	max(dt_mesano_referencia)
	into STRICT	dt_mesano_referencia_w
	from	protocolo_convenio
	where	nr_seq_protocolo = nr_seq_protocolo_p;

end if;
	
if (coalesce(nr_seq_lote_protocolo_p,0) > 0) then

	select	max(dt_mesano_referencia)
	into STRICT	dt_mesano_referencia_lote_w
	from	lote_protocolo
	where	nr_sequencia = nr_seq_lote_protocolo_p;
end if;

if (pkg_date_utils.get_DiffDate(dt_mesano_referencia_w, dt_mesano_referencia_lote_w, 'DAY', 1) > 0) then
	ie_retorno_w := 'N';
end if;

return ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_gera_lote_protocolo ( nr_seq_protocolo_p bigint, nr_seq_lote_protocolo_p bigint) FROM PUBLIC;
