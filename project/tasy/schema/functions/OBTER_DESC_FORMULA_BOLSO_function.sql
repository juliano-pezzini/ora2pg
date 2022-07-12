-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_formula_bolso ( qt_peso_p bigint, ie_opcao_p text, ie_opcao_regra_p text DEFAULT 'N') RETURNS varchar AS $body$
DECLARE

  ie_uom_nut_asmnt varchar(5);

BEGIN
  /*
  11 a 24kcal/kg - reducao de peso
  25-29Kcal/kg  - manutencao de peso
  30-35 kcal/kg - ganho de peso
  40Kcal/kg - politrauma
  30-35Kcal/kg - Sepse
  20-25kcal/kg - Reducao de peso
  25-30kcal/kg - Manutencao de peso
  30-35kcal/kg - Ganho de peso
  30-35kcal/kg - Pre e pos TCTH
  */
  SELECT Obter_Param_Medico(wheb_usuario_pck.get_cd_estabelecimento,'IE_UNIDADE_NUT_AVAL')
  INTO STRICT ie_uom_nut_asmnt
;
  IF ( ie_uom_nut_asmnt = 'KJ') THEN
    BEGIN
      IF (ie_opcao_p = 'R') THEN
        RETURN converter_kcal_kjoules((11 * qt_peso_p),'KJ') || ' ' || obter_desc_expressao(318244 ) || ' '|| converter_kcal_kjoules((24 * qt_peso_p),'KJ') || ' '|| obter_desc_expressao(953912); -- 'KJ/dia';
      elsif (ie_opcao_p = 'M') THEN
        RETURN converter_kcal_kjoules((25 * qt_peso_p),'KJ') || ' ' || obter_desc_expressao(318244 ) || ' '|| converter_kcal_kjoules((29 * qt_peso_p),'KJ') ||' '|| obter_desc_expressao(953912); -- 'KJ/dia';
      elsif (ie_opcao_p = 'G') THEN
        RETURN converter_kcal_kjoules((30 * qt_peso_p),'KJ') || ' ' || obter_desc_expressao(318244 ) || ' '|| converter_kcal_kjoules((35 * qt_peso_p),'KJ') ||' '|| obter_desc_expressao(953912); -- 'KJ/dia';
      elsif (ie_opcao_p = 'P') THEN
        RETURN converter_kcal_kjoules((40 * qt_peso_p),'KJ')|| obter_desc_expressao(953912); --' KJ/dia';
      elsif (ie_opcao_p = 'S') THEN
        RETURN converter_kcal_kjoules((30 * qt_peso_p),'KJ') || ' ' || obter_desc_expressao(318244 ) || ' '|| converter_kcal_kjoules((35 * qt_peso_p),'KJ') || ' '||obter_desc_expressao(953912); -- 'KJ/dia';
      elsif (ie_opcao_regra_p = 'R') THEN
        RETURN converter_kcal_kjoules((20 * qt_peso_p),'KJ') || ' ' || obter_desc_expressao(318244 ) || ' '|| converter_kcal_kjoules((25 * qt_peso_p),'KJ') || ' '||obter_desc_expressao(953912); -- 'KJ/dia';
      elsif (ie_opcao_regra_p = 'M') THEN
        RETURN converter_kcal_kjoules((25 * qt_peso_p),'KJ') || ' ' || obter_desc_expressao(318244 ) || ' '|| converter_kcal_kjoules((30 * qt_peso_p),'KJ') || ' '||obter_desc_expressao(953912); -- 'KJ/dia';
      elsif (ie_opcao_regra_p = 'G') THEN
        RETURN converter_kcal_kjoules((30 * qt_peso_p),'KJ') || ' ' || obter_desc_expressao(318244 ) || ' '|| converter_kcal_kjoules((35 * qt_peso_p),'KJ') ||' '|| obter_desc_expressao(953912); -- 'KJ/dia';
      elsif (ie_opcao_regra_p = 'P') THEN
        RETURN converter_kcal_kjoules((30 * qt_peso_p),'KJ') || ' ' || obter_desc_expressao(318244 ) || ' '|| converter_kcal_kjoules((35 * qt_peso_p),'KJ') ||' '||obter_desc_expressao(953912); -- 'KJ/dia';
      END IF;
      RETURN NULL;
    END;
  ELSE
    BEGIN
      IF (ie_opcao_p = 'R') THEN
        RETURN(11 * qt_peso_p) || ' ' || obter_desc_expressao(318244 ) || ' '|| (24 * qt_peso_p) || ' '||obter_desc_expressao(710797); --' Kcal/dia';
      elsif (ie_opcao_p = 'M') THEN
        RETURN(25 * qt_peso_p) || ' ' || obter_desc_expressao(318244 ) || ' '|| (29 * qt_peso_p) ||' '|| obter_desc_expressao(710797); --' Kcal/dia';
      elsif (ie_opcao_p = 'G') THEN
        RETURN(30 * qt_peso_p) || ' ' || obter_desc_expressao(318244 ) || ' '|| (35 * qt_peso_p) || ' '||obter_desc_expressao(710797); --' Kcal/dia';
      elsif (ie_opcao_p = 'P') THEN
        RETURN(40 * qt_peso_p)|| obter_desc_expressao(710797); --' Kcal/dia';
      elsif (ie_opcao_p = 'S') THEN
        RETURN(30 * qt_peso_p) || ' ' || obter_desc_expressao(318244 ) || ' '|| (35 * qt_peso_p) ||' '|| obter_desc_expressao(710797); --' Kcal/dia';
      elsif (ie_opcao_regra_p = 'R') THEN
        RETURN(20 * qt_peso_p) || ' ' || obter_desc_expressao(318244 ) || ' '|| (25 * qt_peso_p) ||' '|| obter_desc_expressao(710797); --' Kcal/dia';
      elsif (ie_opcao_regra_p = 'M') THEN
        RETURN(25 * qt_peso_p) || ' ' || obter_desc_expressao(318244 ) || ' '|| (30 * qt_peso_p) || ' '||obter_desc_expressao(710797); --' Kcal/dia';
      elsif (ie_opcao_regra_p = 'G') THEN
        RETURN(30 * qt_peso_p) || ' ' || obter_desc_expressao(318244 ) || ' '|| (35 * qt_peso_p) || ' '||obter_desc_expressao(710797); --' Kcal/dia';
      elsif (ie_opcao_regra_p = 'P') THEN
        RETURN(30 * qt_peso_p) || ' ' || obter_desc_expressao(318244 ) || ' '|| (35 * qt_peso_p) ||' '|| obter_desc_expressao(710797); --' Kcal/dia';
      END IF;
      RETURN NULL;
    END;
  END IF;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_formula_bolso ( qt_peso_p bigint, ie_opcao_p text, ie_opcao_regra_p text DEFAULT 'N') FROM PUBLIC;
