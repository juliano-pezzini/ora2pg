-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE w_item_prescr_del_js ( nr_prescricao_p bigint) AS $body$
BEGIN

if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') then
	delete from w_item_prescr
	where  nr_prescricao 	= nr_prescricao_p
	and    ie_origem_inf 	in ('PI', 'P', 'PVPi');

	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE w_item_prescr_del_js ( nr_prescricao_p bigint) FROM PUBLIC;
