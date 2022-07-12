-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION san_obter_data_transf (nr_seq_transfusao_p bigint) RETURNS timestamp AS $body$
DECLARE

dt_transfusao_w	timestamp;

BEGIN

if (nr_seq_transfusao_p IS NOT NULL AND nr_seq_transfusao_p::text <> '') then

	select 	max(dt_transfusao)
	into STRICT	dt_transfusao_w
	from	san_transfusao
	where	nr_sequencia = nr_seq_transfusao_p
	and	ie_status <> 'C';

end if;

return	dt_transfusao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION san_obter_data_transf (nr_seq_transfusao_p bigint) FROM PUBLIC;
