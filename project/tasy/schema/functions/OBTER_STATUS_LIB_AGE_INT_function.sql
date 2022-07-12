-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_status_lib_age_int (vl_dominio_p text) RETURNS varchar AS $body$
DECLARE

  ds_valor_dominio_w varchar(255) := null;

BEGIN
  if (vl_dominio_p IS NOT NULL AND vl_dominio_p::text <> '') then
	begin
    select max(ds_status)
      into STRICT ds_valor_dominio_w
      from AGENDA_REGRA_STATUS_LIB
     where ie_situacao = 'A' and
           ie_status = vl_dominio_p and
           cd_estabelecimento = coalesce(wheb_usuario_pck.get_cd_estabelecimento, 1) and
           ((nm_usuario_lib = wheb_usuario_pck.get_nm_usuario) or coalesce(nm_usuario_lib,' ') = ' ') and
           ((cd_perfil = obter_perfil_ativo) or coalesce(cd_perfil,0) = 0);

      if (coalesce(ds_valor_dominio_w::text, '') = '') then
        select substr(coalesce(ds_valor_dominio_cliente, obter_desc_expressao(cd_exp_valor_dominio, ds_valor_dominio)), 1, 255)
          into STRICT ds_valor_dominio_w
          from valor_dominio
         where cd_dominio	= 8453
           and vl_dominio	= vl_dominio_p;
      end if;

      exception
        when others then
          ds_valor_dominio_w := null;
      end;
  end	if;

  return ds_valor_dominio_w;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_status_lib_age_int (vl_dominio_p text) FROM PUBLIC;
