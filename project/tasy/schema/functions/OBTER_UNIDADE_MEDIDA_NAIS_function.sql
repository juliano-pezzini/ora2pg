-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_unidade_medida_nais (nr_prescricao_p bigint, nr_seq_solucao_p bigint) RETURNS varchar AS $body$
DECLARE


ds_unidade_medida_nais_w	varchar(40);


BEGIN
if (coalesce(nr_prescricao_p,0) > 0) then
	select	substr(max(n.ds_unidade_medida),1,40) ds_unid_medida_nais
	into STRICT	ds_unidade_medida_nais_w
	from	prescr_material pm,
			material m,
			unidade_medida n
	where 	pm.nr_prescricao = nr_prescricao_p
	and 	pm.nr_sequencia = nr_seq_solucao_p
	and 	pm.cd_material = m.cd_material
	and 	substr(m.cd_unid_medida_nais,3,40) = n.cd_unidade_medida;
end if;

return	ds_unidade_medida_nais_w;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_unidade_medida_nais (nr_prescricao_p bigint, nr_seq_solucao_p bigint) FROM PUBLIC;

