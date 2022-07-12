-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_data_status_leito ( nr_seq_interno_p bigint, ie_status_p text) RETURNS timestamp AS $body$
DECLARE


dt_status_w		timestamp;


BEGIN

select	max(dt_historico)
into STRICT	dt_status_w
from	unidade_atend_hist
where	nr_seq_unidade		= nr_seq_interno_p
and	ie_status_unidade 	= ie_status_p;

return	dt_status_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_data_status_leito ( nr_seq_interno_p bigint, ie_status_p text) FROM PUBLIC;
