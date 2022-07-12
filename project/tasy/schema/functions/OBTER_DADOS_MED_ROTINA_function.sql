-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_med_rotina ( cd_protocolo_p bigint, nr_seq_material_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ie_intervalo_w					varchar(1);
ie_unidade_medida_w				varchar(1);
ie_obriga_justificativa_w		varchar(1);
ie_dados_atb_w					varchar(1);
ie_dados_medicamento_w			varchar(1);
ie_questionar_obs_w				varchar(1);
ie_retorno_w					varchar(1);


BEGIN

select	coalesce(max(a.ie_intervalo),'N'),
		coalesce(max(a.ie_unidade_medida),'N'),
		coalesce(max(CASE WHEN a.ie_justificativa='S' THEN a.ie_justificativa  ELSE PERFORM obter_dados_medic_atb_var(b.cd_material,wheb_usuario_pck.get_cd_estabelecimento,b.ie_obriga_justificativa,'OJ',null,null,null) END ),'N'),
		coalesce(max(a.ie_dados_atb),'N'),
		coalesce(max(a.ie_dados_medicamento),'N'),
		coalesce(max(a.ie_questionar_obs),'N')
into STRICT		ie_intervalo_w,
		ie_unidade_medida_w,
		ie_obriga_justificativa_w,
		ie_dados_atb_w,
		ie_dados_medicamento_w,
		ie_questionar_obs_w
from 	protocolo_medic_material a,
		material b
where	a.cd_material = b.cd_material
and		coalesce(a.ie_medic_rotina,'N') = 'S'
and		a.cd_protocolo = cd_protocolo_p
and		a.nr_seq_material = nr_seq_material_p;

if (ie_opcao_p = 'INT') then
	ie_retorno_w := ie_intervalo_w;
elsif (ie_opcao_p = 'UMD') then
	ie_retorno_w := ie_unidade_medida_w;
elsif (ie_opcao_p = 'JUS') then
	ie_retorno_w := ie_obriga_justificativa_w;
elsif (ie_opcao_p = 'ATB') then
	ie_retorno_w := ie_dados_atb_w;
elsif (ie_opcao_p = 'MED') then
	ie_retorno_w := ie_dados_medicamento_w;
elsif (ie_opcao_p = 'OBS') then
	ie_retorno_w := ie_questionar_obs_w;
end if;

return ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_med_rotina ( cd_protocolo_p bigint, nr_seq_material_p bigint, ie_opcao_p text) FROM PUBLIC;

