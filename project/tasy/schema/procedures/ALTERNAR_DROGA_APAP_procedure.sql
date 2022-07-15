-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alternar_droga_apap (nr_prescricao_p bigint, nr_seq_solucao_p bigint, nm_usuario_p text) AS $body$
BEGIN
if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_solucao_p IS NOT NULL AND nr_seq_solucao_p::text <> '') then

	update	prescr_solucao
	set	ie_apap		= CASE WHEN coalesce(ie_apap,'N')='N' THEN 'SV' WHEN coalesce(ie_apap,'N')='S' THEN 'SV' WHEN coalesce(ie_apap,'N')='DU' THEN 'SV' WHEN coalesce(ie_apap,'N')='NV' THEN 'SV' WHEN coalesce(ie_apap,'N')='SV' THEN 'NV' END
	where	nr_prescricao	= nr_prescricao_p
	and	nr_seq_solucao	= nr_seq_solucao_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alternar_droga_apap (nr_prescricao_p bigint, nr_seq_solucao_p bigint, nm_usuario_p text) FROM PUBLIC;

