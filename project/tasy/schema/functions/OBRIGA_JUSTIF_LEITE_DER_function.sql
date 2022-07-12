-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obriga_justif_leite_der (cd_material_p bigint, cd_setor_atendimento_p bigint, ie_justificativa_padrao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w 		varchar(1);
cd_estabelecimento_w 	bigint;
cd_perfil_w 		bigint;


BEGIN

cd_estabelecimento_w 	:= obter_estabelecimento_ativo;
cd_perfil_w 		:= obter_perfil_ativo;


select	coalesce(MAX('S'), 'N')
into STRICT	ds_retorno_w
from 	regra_obriga_just_prod
where 	coalesce(cd_material, cd_material_p) 		 	= cd_material_p
and	coalesce(cd_setor_atendimento, cd_setor_atendimento_p) 	= cd_setor_atendimento_p
and	coalesce(cd_estabelecimento, cd_estabelecimento_w ) 	 	= cd_estabelecimento_w
and	coalesce(cd_perfil, cd_perfil_w)			 	= cd_perfil_w
and 	coalesce(ie_justificativa_padrao,'N')				= ie_justificativa_padrao_p;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obriga_justif_leite_der (cd_material_p bigint, cd_setor_atendimento_p bigint, ie_justificativa_padrao_p text) FROM PUBLIC;

