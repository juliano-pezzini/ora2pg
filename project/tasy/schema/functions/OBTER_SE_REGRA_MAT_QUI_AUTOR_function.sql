-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_regra_mat_qui_autor ( cd_material_p bigint, cd_convenio_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


				
ds_retorno_w	varchar(1) := 'S';


BEGIN

if (cd_material_p IS NOT NULL AND cd_material_p::text <> '') then
     select coalesce(max('N'),'S')
     into STRICT   ds_retorno_w
     from   regra_apresent_quimio_excl a,
	    regra_apresentacao_quimio  b
     where  a.cd_material 	   = cd_material_p
     and    a.nr_seq_regra	   = b.nr_sequencia
     and    b.cd_estabelecimento   = wheb_usuario_pck.get_cd_estabelecimento
     and    b.ie_regra_aplicacao   in ('P','D')
     and   ((coalesce(ie_opcao_p,'X') = 'P' and coalesce(b.ie_prescricao,'N') = 'S') or (coalesce(ie_opcao_p,'X') <> 'P'))
     and   ((coalesce(b.cd_convenio,0)  = coalesce(cd_convenio_p,0)) or (coalesce(b.cd_convenio::text, '') = ''))
     and   coalesce(ie_situacao,'A') = 'A'
      and (clock_timestamp() between coalesce(dt_inicio_vigencia,clock_timestamp()) and coalesce(dt_fim_vigencia,clock_timestamp()));
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_regra_mat_qui_autor ( cd_material_p bigint, cd_convenio_p bigint, ie_opcao_p text) FROM PUBLIC;

