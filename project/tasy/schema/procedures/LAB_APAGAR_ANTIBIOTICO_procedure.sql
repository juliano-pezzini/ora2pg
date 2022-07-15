-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lab_apagar_antibiotico (cd_microorganismo_destino_p bigint, nr_seq_material_destino_p bigint) AS $body$
BEGIN

delete	from cih_microorg_medic
where	cd_microorganismo = cd_microorganismo_destino_p
and	nr_seq_material	  = CASE WHEN coalesce(nr_seq_material_destino_p, 0)=0 THEN  nr_seq_material  ELSE nr_seq_material_destino_p END;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lab_apagar_antibiotico (cd_microorganismo_destino_p bigint, nr_seq_material_destino_p bigint) FROM PUBLIC;

