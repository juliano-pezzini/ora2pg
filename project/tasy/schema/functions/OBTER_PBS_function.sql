-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_pbs ( cd_material_p item_requisicao_material.CD_MATERIAL%type, nr_requisicao_p item_requisicao_material.NR_REQUISICAO%type ) RETURNS varchar AS $body$
DECLARE


nr_atendimento_w        REQUISICAO_MATERIAL.NR_ATENDIMENTO%type;
ie_nopbs_w              MATERIAL.IE_NOPBS%type;
cd_convenio_w           ATEND_CATEGORIA_CONVENIO.CD_CONVENIO%type;
cd_plano_convenio_w     ATEND_CATEGORIA_CONVENIO.CD_PLANO_CONVENIO%type;
ie_eps_w                CONVENIO_PLANO.IE_EPS%type;


BEGIN

 SELECT coalesce(MAX(a.NR_ATENDIMENTO),0)
   INTO STRICT nr_atendimento_w
   FROM REQUISICAO_MATERIAL a
  WHERE a.NR_REQUISICAO = nr_requisicao_p;

  SELECT coalesce(MAX(a.IE_NOPBS), 'N')
    INTO STRICT ie_nopbs_w 
    FROM MATERIAL a
   WHERE a.CD_MATERIAL = cd_material_p;

   SELECT MAX(b.CD_CONVENIO),
          MAX(b.CD_PLANO_CONVENIO)
    INTO STRICT  cd_convenio_w,
          cd_plano_convenio_w
    FROM  ATEND_CATEGORIA_CONVENIO b
   WHERE  b.nr_atendimento = nr_atendimento_w;

   SELECT  coalesce(MAX(a.IE_EPS), 'N')
     INTO STRICT  ie_eps_w
     FROM  CONVENIO_PLANO a
    WHERE  a.CD_CONVENIO = cd_convenio_w
      AND  a.CD_PLANO = cd_plano_convenio_w;

  RETURN  CASE WHEN ie_nopbs_w = 'S' AND ie_eps_w = 'S' THEN 'S' ELSE 'N' END;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_pbs ( cd_material_p item_requisicao_material.CD_MATERIAL%type, nr_requisicao_p item_requisicao_material.NR_REQUISICAO%type ) FROM PUBLIC;
