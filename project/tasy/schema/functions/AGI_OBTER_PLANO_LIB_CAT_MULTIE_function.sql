-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION agi_obter_plano_lib_cat_multie (cd_convenio_p bigint, cd_categoria_p text, cd_plano_p text, cd_estabelecimento_p bigint, dt_atendimento_p timestamp, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE


  ie_liberado_w varchar(01) := 'S';
  ie_parametro  varchar(01) := 'S';


BEGIN

  select coalesce(max(pa.ie_ativa_categ_plano), 'N')
  into STRICT 	ie_parametro
  from 	parametro_agenda pa
  where pa.cd_estabelecimento = cd_estabelecimento_p;

  if ie_parametro = 'S' and (cd_plano_p IS NOT NULL AND cd_plano_p::text <> '') then

    ie_liberado_w := obter_plano_lib_categ_agi(cd_convenio_p,
                                               cd_categoria_p,
                                               cd_plano_p,
                                               cd_estabelecimento_p,
                                               dt_atendimento_p,
                                               nm_usuario_p);

  end if;

  return ie_liberado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION agi_obter_plano_lib_cat_multie (cd_convenio_p bigint, cd_categoria_p text, cd_plano_p text, cd_estabelecimento_p bigint, dt_atendimento_p timestamp, nm_usuario_p text) FROM PUBLIC;
