-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_imc ( qt_imc_p bigint, qt_idade_p bigint default null, qt_ig_semana_p bigint default null) RETURNS varchar AS $body$
DECLARE

  ds_retorno_w	varchar(255);
  ie_result_imc_w	varchar(10);
  sql_w varchar(250);

BEGIN

  /*Fonte OMS 2000*/

  if (qt_imc_p IS NOT NULL AND qt_imc_p::text <> '') then
    
    select 	max(ie_result_imc) 
    into STRICT	ie_result_imc_w
    from	regra_padrao_imc
    where	qt_idade_p between qt_idade_min and qt_idade_max;

    if (coalesce(ie_result_imc_w::text, '') = '') then
      select	coalesce(max(ie_result_imc),'O')
      into STRICT	ie_result_imc_w
      from	parametro_medico
      where	cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento;
    end if;

    --INICIO MD1
    begin
      sql_w := 'CALL OBTER_DESC_IMC_MD(:1, :2, :3, :4) INTO :ds_retorno_w';
      EXECUTE sql_w USING IN qt_imc_p,
                                    IN qt_idade_p, 
                                    IN qt_ig_semana_p,
                                    IN ie_result_imc_w,
                                    OUT ds_retorno_w;
    exception
      when others then
        ds_retorno_w := null;
      end;
    --FIM MD 1
  end if;

  return	ds_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_imc ( qt_imc_p bigint, qt_idade_p bigint default null, qt_ig_semana_p bigint default null) FROM PUBLIC;

