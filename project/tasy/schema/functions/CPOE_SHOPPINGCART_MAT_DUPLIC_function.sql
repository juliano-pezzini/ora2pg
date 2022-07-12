-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cpoe_shoppingcart_mat_duplic (nr_sequencia_p bigint, nr_atendimento_p bigint, cd_setor_atendimento_p bigint, cd_pessoa_fisica_p text, cd_material_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp) RETURNS varchar AS $body$
DECLARE


ie_continuo_w	varchar(1) := 'N';
ds_retorno_w	varchar(1) := 'N';


BEGIN

if ((nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') and (cd_material_p IS NOT NULL AND cd_material_p::text <> '') and (dt_inicio_p IS NOT NULL AND dt_inicio_p::text <> '')) then

	if (dt_fim_p IS NOT NULL AND dt_fim_p::text <> '') then
		ie_continuo_w := 'S';
	end if;

	select	CASE WHEN count(*)=0 THEN  'N'  ELSE 'S' END  ie_duplicado
	into STRICT	ds_retorno_w
	from	cpoe_material a
	where	a.nr_sequencia <> coalesce(nr_sequencia_p,0)
	and		obter_se_cpoe_regra_duplic('M', wheb_usuario_pck.get_cd_perfil, cd_setor_atendimento_p, a.cd_material) = 'S'
	and		a.ie_material = 'S'
	and		a.cd_material = cd_material_p
	and		((a.nr_atendimento = nr_atendimento_p) or (a.cd_pessoa_fisica = cd_pessoa_fisica_p and coalesce(a.nr_atendimento::text, '') = ''))
	and		(((a.dt_lib_suspensao IS NOT NULL AND a.dt_lib_suspensao::text <> '') and (a.dt_suspensao > clock_timestamp())) or (coalesce(a.dt_lib_suspensao::text, '') = ''))
	and 	((a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '') or (a.nm_usuario = wheb_usuario_pck.get_nm_usuario))
	and 	((a.dt_inicio between dt_inicio_p and dt_fim_p) or (a.dt_fim between dt_inicio_p and dt_fim_p) or (coalesce(a.dt_fim::text, '') = '' and a.dt_inicio < dt_inicio_p) or (a.dt_fim > dt_fim_p and a.dt_inicio < dt_inicio_p) or	
			 (((a.dt_inicio >  dt_inicio_p) and (coalesce(ie_continuo_w,'N') = 'S')) or ((coalesce(ie_continuo_w,'N') = 'N') and (dt_inicio_p <= a.dt_inicio)  and dt_fim_p > a.dt_inicio)) or (a.ie_retrogrado = 'S' and coalesce(a.dt_liberacao::text, '') = ''));
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cpoe_shoppingcart_mat_duplic (nr_sequencia_p bigint, nr_atendimento_p bigint, cd_setor_atendimento_p bigint, cd_pessoa_fisica_p text, cd_material_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp) FROM PUBLIC;
