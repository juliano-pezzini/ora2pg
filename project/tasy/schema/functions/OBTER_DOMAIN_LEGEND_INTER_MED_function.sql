-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_domain_legend_inter_med ( codigo_p bigint, tipo_p text DEFAULT 'M') RETURNS bigint AS $body$
DECLARE


cd_retorno_w            bigint;
codigo_w                bigint;
cd_classe_material_w    bigint;
cd_principio_w          bigint;


BEGIN

IF tipo_p = 'C' THEN
    select cd_material into STRICT codigo_w from cpoe_material where nr_sequencia = codigo_p;
END IF;

IF tipo_p = 'M' THEN
    codigo_w := codigo_p;
END IF;

cd_classe_material_w := obter_dados_material(codigo_w, 'CCLA');
cd_principio_w := obter_dados_material(codigo_w, 'FT');

BEGIN
  SELECT cd_retorno
  INTO STRICT   cd_retorno_w
  FROM (
        SELECT  coalesce(a.nr_dominio_legenda, 99) cd_retorno
        FROM    regra_legenda_inter_medic a
        WHERE   ((a.cd_material = codigo_w) or (coalesce(a.cd_material::text, '') = ''))
            AND   ((a.cd_principio_ativo = cd_principio_w) or (coalesce(a.cd_principio_ativo::text, '') = ''))
            AND   ((a.cd_classe_material = cd_classe_material_w) or (coalesce(a.cd_classe_material::text, '') = ''))
        ORDER BY coalesce(a.cd_material, 0) DESC,
                 coalesce(a.cd_principio_ativo, 0) DESC,
                 coalesce(a.cd_classe_material, 0) DESC ) alias16 LIMIT 1;
exception
 when no_data_found then
   cd_retorno_w := 99;
END;

RETURN cd_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_domain_legend_inter_med ( codigo_p bigint, tipo_p text DEFAULT 'M') FROM PUBLIC;
