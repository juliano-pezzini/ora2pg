-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_msg_conv_copartipacao ( cd_estabelecimento_p bigint, cd_empresa_p bigint, cd_convenio_p bigint, cd_categoria_p bigint, cd_plano_conv_p text, cd_funcao_p bigint, ie_tipo_atendimento_p bigint, ie_tipo_atend_tiss_p bigint) RETURNS varchar AS $body$
DECLARE


msgretorno_w	varchar(255);
qt_regra_w	bigint;


BEGIN

msgRetorno_w := '';

if (cd_funcao_p = 916) then /* entrada única */
	select	count(*)
	into STRICT	qt_regra_w
	from	regra_msg_cooparticipacao
	where	cd_estabelecimento = cd_estabelecimento_p
	and	cd_empresa_ref = cd_empresa_p
	and	coalesce(ie_Tipo_Atendimento, coalesce(ie_tipo_atendimento_p,0)) = coalesce(ie_tipo_atendimento_p,0)
	and	coalesce(cd_convenio,  coalesce(cd_convenio_p,0)) = coalesce(cd_convenio_p,0)
	and	coalesce(cd_categoria, coalesce(cd_categoria_p,0)) = coalesce(cd_categoria_p,0)
	and	coalesce(ie_tipo_atend_tiss, coalesce(ie_tipo_atend_tiss_p,0)) = coalesce(ie_tipo_atend_tiss_p,0)
	and	coalesce(cd_plano_convenio, cd_plano_conv_p) = cd_plano_conv_p
	and	cd_funcao = cd_funcao_p;

	if (qt_regra_w > 0) then
		select	substr(ds_mensagem,1,255)
		into STRICT	msgretorno_w
		from	regra_msg_cooparticipacao
		where	cd_estabelecimento = cd_estabelecimento_p
		and	cd_empresa_ref = cd_empresa_p
		and	coalesce(ie_Tipo_Atendimento, coalesce(ie_tipo_atendimento_p,0)) = coalesce(ie_tipo_atendimento_p,0)
		and	coalesce(cd_convenio,  coalesce(cd_convenio_p,0)) = coalesce(cd_convenio_p,0)
		and	coalesce(cd_categoria, coalesce(cd_categoria_p,0)) = coalesce(cd_categoria_p,0)
		and	coalesce(ie_tipo_atend_tiss, coalesce(ie_tipo_atend_tiss_p,0)) = coalesce(ie_tipo_atend_tiss_p,0)
		and	coalesce(cd_plano_convenio, cd_plano_conv_p) = cd_plano_conv_p
		and	cd_funcao = cd_funcao_p;
	end if;
end if;

return	msgretorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_msg_conv_copartipacao ( cd_estabelecimento_p bigint, cd_empresa_p bigint, cd_convenio_p bigint, cd_categoria_p bigint, cd_plano_conv_p text, cd_funcao_p bigint, ie_tipo_atendimento_p bigint, ie_tipo_atend_tiss_p bigint) FROM PUBLIC;

