-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS oft_refracao_bef_ins ON oft_refracao CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_oft_refracao_bef_ins() RETURNS trigger AS $BODY$
DECLARE
    param141_w                varchar(1);
    param117_w                varchar(1);
    cd_perfil_ativo_w         integer;
    cd_estabelecimento_w      integer;

    FUNCTION oft_obter_mascara_campo_form(
        nr_seq_consulta_form_p   bigint,
        nm_atributo_p            text
    ) RETURN text IS
        ie_mascara_dioptria_w oft_formulario_item.ie_mascara_dioptria%TYPE;
    BEGIN
        SELECT
            MAX(c.ie_mascara_dioptria)
        INTO STRICT ie_mascara_dioptria_w
        FROM
            oft_consulta_formulario   b,
            oft_formulario_item       c
        WHERE
            b.nr_seq_regra_form = c.nr_seq_regra_form
            AND b.nr_sequencia = nr_seq_consulta_form_p
            AND c.nm_atributo = nm_atributo_p;

        RETURN coalesce(ie_mascara_dioptria_w, 'X');
    END;

    FUNCTION obter_valor_conversao(
        valor_campo_p   NUMBER
    ) RETURN VARCHAR2 IS
        retorno_w NUMBER(1);
    BEGIN
        retorno_w := 1;
        IF ( valor_campo_p > 0 ) THEN
            retorno_w := -1;
        END IF;
        RETURN retorno_w;
    END;

    FUNCTION obter_valor_conversao_form(
        valor_campo_p   NUMBER,
        ie_mascara_p    VARCHAR2,
        param117_p      VARCHAR2,
        param141_p      VARCHAR2,
        nm_atributo_p   VARCHAR2
    ) RETURN VARCHAR2 IS
        retorno_w NUMBER(1);
    BEGIN
        retorno_w := 1;
        IF ( valor_campo_p > 0
            AND ie_mascara_p <> 'P'
            AND ( ( ie_mascara_p = 'N' ) 
            OR ( param117_p = 'D' AND param141_p = 'N' ) 
            OR ( param117_p = 'N' AND param141_p = 'N' ) 
            OR ( param117_p = 'N' AND param141_p = 'P' 
            AND ( UPPER(nm_atributo_p) IN ('VL_OD_PL_ARD_CIL', 'VL_OE_PL_ARD_CIL', 'VL_OD_PL_ARE_CIL', 'VL_OE_PL_ARE_CIL') ) ) ) ) THEN
            retorno_w := -1;
        END IF;

        RETURN retorno_w;
    END;

BEGIN

    IF ( wheb_usuario_pck.get_ie_executar_trigger = 'S' ) THEN
        cd_perfil_ativo_w       := wheb_usuario_pck.get_cd_perfil;
        cd_estabelecimento_w    := wheb_usuario_pck.get_cd_estabelecimento;
        param141_w := obter_param_usuario(3010, 141, cd_perfil_ativo_w, NEW.nm_usuario, cd_estabelecimento_w, param141_w);
        param117_w := obter_param_usuario(3010, 117, cd_perfil_ativo_w, NEW.nm_usuario, cd_estabelecimento_w, param117_w);

        IF ( NEW.nr_seq_consulta_form IS NULL ) THEN
            IF ( ( param117_w = 'D' AND param141_w = 'N' ) OR ( param117_w = 'N' AND param141_w = 'N' ) ) THEN
                    NEW.vl_od_pl_ard_esf := NEW.vl_od_pl_ard_esf * obter_valor_conversao(NEW.vl_od_pl_ard_esf);
                    NEW.vl_od_pl_ard_cil := NEW.vl_od_pl_ard_cil * obter_valor_conversao(NEW.vl_od_pl_ard_cil);
                    NEW.vl_oe_pl_ard_esf := NEW.vl_oe_pl_ard_esf * obter_valor_conversao(NEW.vl_oe_pl_ard_esf);
                    NEW.vl_oe_pl_ard_cil := NEW.vl_oe_pl_ard_cil * obter_valor_conversao(NEW.vl_oe_pl_ard_cil);
                    NEW.vl_od_pl_are_esf := NEW.vl_od_pl_are_esf * obter_valor_conversao(NEW.vl_od_pl_are_esf);
                    NEW.vl_od_pl_are_cil := NEW.vl_od_pl_are_cil * obter_valor_conversao(NEW.vl_od_pl_are_cil);
                    NEW.vl_oe_pl_are_esf := NEW.vl_oe_pl_are_esf * obter_valor_conversao(NEW.vl_oe_pl_are_esf);
                    NEW.vl_oe_pl_are_cil := NEW.vl_oe_pl_are_cil * obter_valor_conversao(NEW.vl_oe_pl_are_cil);
            ELSIF ( param117_w = 'N' AND param141_w = 'P' ) THEN
                    NEW.vl_od_pl_ard_cil := NEW.vl_od_pl_ard_cil * obter_valor_conversao(NEW.vl_od_pl_ard_cil);
                    NEW.vl_oe_pl_ard_cil := NEW.vl_oe_pl_ard_cil * obter_valor_conversao(NEW.vl_oe_pl_ard_cil);
                    NEW.vl_od_pl_are_cil := NEW.vl_od_pl_are_cil * obter_valor_conversao(NEW.vl_od_pl_are_cil);
                    NEW.vl_oe_pl_are_cil := NEW.vl_oe_pl_are_cil * obter_valor_conversao(NEW.vl_oe_pl_are_cil);
            END IF;

        ELSE
            NEW.vl_od_pl_ard_esf := NEW.vl_od_pl_ard_esf * obter_valor_conversao_form(NEW.vl_od_pl_ard_esf, oft_obter_mascara_campo_form(NEW.nr_seq_consulta_form, 'VL_OD_PL_ARD_ESF'), param117_w, param141_w, 'VL_OD_PL_ARD_ESF');

            NEW.vl_od_pl_ard_cil := NEW.vl_od_pl_ard_cil * obter_valor_conversao_form(NEW.vl_od_pl_ard_cil, oft_obter_mascara_campo_form(NEW.nr_seq_consulta_form, 'VL_OD_PL_ARD_CIL'), param117_w, param141_w, 'VL_OD_PL_ARD_CIL');

            NEW.vl_oe_pl_ard_esf := NEW.vl_oe_pl_ard_esf * obter_valor_conversao_form(NEW.vl_oe_pl_ard_esf, oft_obter_mascara_campo_form(NEW.nr_seq_consulta_form, 'VL_OE_PL_ARD_ESF'), param117_w, param141_w, 'VL_OE_PL_ARD_ESF');

            NEW.vl_oe_pl_ard_cil := NEW.vl_oe_pl_ard_cil * obter_valor_conversao_form(NEW.vl_oe_pl_ard_cil, oft_obter_mascara_campo_form(NEW.nr_seq_consulta_form, 'VL_OE_PL_ARD_CIL'), param117_w, param141_w, 'VL_OE_PL_ARD_CIL');

            NEW.vl_od_pl_are_esf := NEW.vl_od_pl_are_esf * obter_valor_conversao_form(NEW.vl_od_pl_are_esf, oft_obter_mascara_campo_form(NEW.nr_seq_consulta_form, 'VL_OD_PL_ARE_ESF'), param117_w, param141_w, 'VL_OD_PL_ARE_ESF');

            NEW.vl_od_pl_are_cil := NEW.vl_od_pl_are_cil * obter_valor_conversao_form(NEW.vl_od_pl_are_cil, oft_obter_mascara_campo_form(NEW.nr_seq_consulta_form, 'VL_OD_PL_ARE_CIL'), param117_w, param141_w, 'VL_OD_PL_ARE_CIL');

            NEW.vl_oe_pl_are_esf := NEW.vl_oe_pl_are_esf * obter_valor_conversao_form(NEW.vl_oe_pl_are_esf, oft_obter_mascara_campo_form(NEW.nr_seq_consulta_form, 'VL_OE_PL_ARE_ESF'), param117_w, param141_w, 'VL_OE_PL_ARE_ESF');

            NEW.vl_oe_pl_are_cil := NEW.vl_oe_pl_are_cil * obter_valor_conversao_form(NEW.vl_oe_pl_are_cil, oft_obter_mascara_campo_form(NEW.nr_seq_consulta_form, 'VL_OE_PL_ARE_CIL'), param117_w, param141_w, 'VL_OE_PL_ARE_CIL');

        END IF;

    END IF;

RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_oft_refracao_bef_ins() FROM PUBLIC;

CREATE TRIGGER oft_refracao_bef_ins
	BEFORE INSERT OR UPDATE ON oft_refracao FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_oft_refracao_bef_ins();

