-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_atendida_farmacia ( nr_prescricao_p bigint) RETURNS varchar AS $body$
DECLARE


ie_atendida_farmacia_w	varchar(3);

expressao1_w	varchar(255) := obter_desc_expressao_idioma(327113, null, wheb_usuario_pck.get_nr_seq_idioma);--Sim
expressao2_w	varchar(255) := obter_desc_expressao_idioma(327114, null, wheb_usuario_pck.get_nr_seq_idioma);--Não
BEGIN
if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') then

	select	CASE WHEN count(*)=0 THEN expressao1_w  ELSE expressao2_w END
	into STRICT	ie_atendida_farmacia_w
	from	prescr_material
	where	NR_PRESCRICAO 	= nr_prescricao_p
	and	ie_agrupador 	= 1
	and	cd_motivo_baixa <> 0;

end if;

return ie_atendida_farmacia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_atendida_farmacia ( nr_prescricao_p bigint) FROM PUBLIC;
