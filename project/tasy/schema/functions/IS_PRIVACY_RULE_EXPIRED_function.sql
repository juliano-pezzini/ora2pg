-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION is_privacy_rule_expired (nr_seq_privacy_rule_p bigint) RETURNS varchar AS $body$
DECLARE


ie_return_w	varchar(1) := 'N';


BEGIN

select	CASE WHEN count(*)=0 THEN  'Y'  ELSE 'N' END
into STRICT	ie_return_w
from	privacy_rule
where	nr_sequencia	= nr_seq_privacy_rule_p
and	clock_timestamp() between dt_vality_start and coalesce(dt_vality_end, clock_timestamp());

return ie_return_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION is_privacy_rule_expired (nr_seq_privacy_rule_p bigint) FROM PUBLIC;
