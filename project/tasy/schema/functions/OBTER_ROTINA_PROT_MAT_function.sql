-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_rotina_prot_mat ( nr_prescricao_p bigint, nr_seq_material_p bigint) RETURNS varchar AS $body$
DECLARE


ds_rotina_w		varchar(255);
cd_protocolo_w		bigint;
nr_seq_protocolo_w	bigint;
cd_material_w		bigint;


BEGIN

select	max(cd_material),
	max(cd_protocolo),
	max(nr_seq_protocolo)
into STRICT	cd_material_w,
	cd_protocolo_w,
	nr_seq_protocolo_w
from	prescr_material
where	nr_prescricao	= nr_prescricao_p
and	nr_sequencia 	= nr_seq_material_p
and	ie_agrupador 	= 1
and	(cd_protocolo IS NOT NULL AND cd_protocolo::text <> '');

select 	max(ds_rotina)
into STRICT	ds_rotina_w
from	protocolo_medic_material
where	cd_protocolo 	= cd_protocolo_w
and	ie_agrupador 	= 1
and	cd_material 	= cd_material_w
and	nr_sequencia 	= nr_seq_protocolo_w;


return	ds_rotina_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_rotina_prot_mat ( nr_prescricao_p bigint, nr_seq_material_p bigint) FROM PUBLIC;
