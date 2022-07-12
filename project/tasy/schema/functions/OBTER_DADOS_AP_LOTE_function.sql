-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_ap_lote ( nr_seq_lote_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ie_tipo_lote_w		varchar(1);
cd_setor_atendimento_w	integer;

/*
ie_opcao_p
'C' = Controlado
'T' = Termolábil
'H' = CCIH
'N' = Normal
'A' = Alto Risco
*/
BEGIN

if (ie_opcao_p = 'C') then

	select	CASE WHEN coalesce(max(cd_material),0)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_tipo_lote_w
	from	prescr_mat_hor
	where	nr_seq_lote = nr_seq_lote_p
	and	coalesce(nr_seq_superior::text, '') = ''
	and	obter_se_medic_controlado(cd_material) = 'S';

elsif (ie_opcao_p = 'T') then

	select	CASE WHEN coalesce(max(cd_material),0)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_tipo_lote_w
	from	prescr_mat_hor
	where	nr_seq_lote = nr_seq_lote_p
	and	coalesce(nr_seq_superior::text, '') = ''
	and	obter_se_medic_termolabil(cd_material) = 'S';

elsif (ie_opcao_p = 'H') then

	select	CASE WHEN coalesce(max(cd_material),0)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_tipo_lote_w
	from	prescr_mat_hor
	where	nr_seq_lote = nr_seq_lote_p
	and	coalesce(nr_seq_superior::text, '') = ''
	and	obter_se_medic_ccih(cd_material) = 'S';

elsif (ie_opcao_p = 'A') then

	select	coalesce(cd_setor_atendimento,0)
	into STRICT	cd_setor_atendimento_w
	from	ap_lote
	where	nr_sequencia = nr_seq_lote_p;

	select	CASE WHEN coalesce(max(cd_material),0)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_tipo_lote_w
	from	prescr_mat_hor
	where	nr_seq_lote = nr_seq_lote_p
	and	coalesce(nr_seq_superior::text, '') = ''
	and	obter_se_material_risco(cd_setor_atendimento_w,cd_material) = 'S';

elsif (ie_opcao_p = 'N') then

	select	coalesce(cd_setor_atendimento,0)
	into STRICT	cd_setor_atendimento_w
	from	ap_lote
	where	nr_sequencia = nr_seq_lote_p;

	select	CASE WHEN coalesce(max(cd_material),0)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_tipo_lote_w
	from	prescr_mat_hor
	where	nr_seq_lote = nr_seq_lote_p
	and	coalesce(nr_seq_superior::text, '') = ''
	and	obter_se_medic_controlado(cd_material) = 'N'
	and	obter_se_medic_termolabil(cd_material) = 'N'
	and	obter_se_medic_ccih(cd_material) = 'N'
	and	obter_se_material_risco(cd_setor_atendimento_w,cd_material) = 'N';

elsif (ie_opcao_p = 'NE') then

	select	CASE WHEN coalesce(max(a.cd_material),0)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_tipo_lote_w
	from	prescr_mat_hor a,
		prescr_material b
	where	a.nr_prescricao = b.nr_prescricao
	and	a.nr_seq_material = b.nr_sequencia
	and	b.ie_agrupador in (8,12)
	and	a.nr_seq_lote = nr_seq_lote_p;

end if;

return	ie_tipo_lote_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_ap_lote ( nr_seq_lote_p bigint, ie_opcao_p text) FROM PUBLIC;

