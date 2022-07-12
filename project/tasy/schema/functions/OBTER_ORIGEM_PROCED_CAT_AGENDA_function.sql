-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_origem_proced_cat_agenda ( cd_convenio_p bigint, cd_categoria_p text, ie_tipo_atendimento_p bigint, cd_estabelecimento_p bigint) RETURNS bigint AS $body$
DECLARE


ie_tipo_convenio_w	smallint;
ie_origem_proced_w	bigint;


BEGIN

ie_tipo_convenio_w	:= obter_tipo_convenio(cd_convenio_p);

ie_origem_proced_w	:= Obter_Origem_Proced_Cat(cd_estabelecimento_p, ie_tipo_atendimento_p, ie_tipo_convenio_w, cd_convenio_p, cd_categoria_p);

return	ie_origem_proced_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_origem_proced_cat_agenda ( cd_convenio_p bigint, cd_categoria_p text, ie_tipo_atendimento_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;
