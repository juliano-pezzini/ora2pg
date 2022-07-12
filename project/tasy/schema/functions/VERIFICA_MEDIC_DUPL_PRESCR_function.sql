-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION verifica_medic_dupl_prescr ( cd_material_p bigint, nr_prescricao_p bigint, nr_seq_mat_p bigint, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE


ie_duplicado_w		varchar(1);


BEGIN

select	CASE WHEN count(nr_sequencia)=0 THEN 'N'  ELSE 'S' END
into STRICT	ie_duplicado_w
from	prescr_material
where	nr_prescricao			= nr_prescricao_p
and	cd_material			= cd_material_p
and	nr_sequencia			< nr_seq_mat_p
and	ie_agrupador			= 1;

return	ie_duplicado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION verifica_medic_dupl_prescr ( cd_material_p bigint, nr_prescricao_p bigint, nr_seq_mat_p bigint, nm_usuario_p text) FROM PUBLIC;

