-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_veloc_variavel ( nr_prescricao_p prescr_medica.nr_prescricao%type, nr_seq_solucao_p prescr_material.nr_sequencia_solucao%type) RETURNS varchar AS $body$
DECLARE


nr_seq_mat_cpoe_w			prescr_material.nr_seq_mat_cpoe%type;
ie_tipo_solucao_w			cpoe_material.ie_tipo_solucao%type;
ds_retorno_w				cpoe_material.ds_observacao%type;
tipo_infusao_variavel_c		constant cpoe_material.ie_tipo_solucao%type := 'V';
cd_msg_tipo_infusao_variavel_c	constant dic_expressao.cd_expressao%type := 710533;


BEGIN

select	max(a.nr_seq_mat_cpoe)
into STRICT	nr_seq_mat_cpoe_w
from	prescr_material a
where	a.nr_prescricao		= nr_prescricao_p
and	a.nr_sequencia_solucao 	= nr_seq_solucao_p
and	a.ie_agrupador = 4;

select	max(a.ie_tipo_solucao)
into STRICT	ie_tipo_solucao_w
from	cpoe_material a
where	a.nr_sequencia		= nr_seq_mat_cpoe_w;

if (ie_tipo_solucao_w = tipo_infusao_variavel_c) then
	ds_retorno_w := obter_desc_expressao(cd_msg_tipo_infusao_variavel_c);
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_veloc_variavel ( nr_prescricao_p prescr_medica.nr_prescricao%type, nr_seq_solucao_p prescr_material.nr_sequencia_solucao%type) FROM PUBLIC;

