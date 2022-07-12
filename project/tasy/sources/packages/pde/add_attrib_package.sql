-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pde.add_attrib (CD_ONTOLOGIA_P PDE_ATTRIBUTE.CD_ONTOLOGIA%TYPE, CD_ONTOLOGIA2_P PDE_ATTRIBUTE.CD_ONTOLOGIA2%TYPE, CD_ONTOLOGIA3_P PDE_ATTRIBUTE.CD_ONTOLOGIA3%TYPE, CD_ONTOLOGIA4_P PDE_ATTRIBUTE.CD_ONTOLOGIA4%TYPE, CD_ONTOLOGIA5_P PDE_ATTRIBUTE.CD_ONTOLOGIA5%TYPE, CD_ONTOLOGIA6_P PDE_ATTRIBUTE.CD_ONTOLOGIA6%TYPE, CD_ONTOLOGIA7_P PDE_ATTRIBUTE.CD_ONTOLOGIA7%TYPE, CD_EXP_ATRIBUTO_P PDE_ATTRIBUTE.CD_EXP_ATRIBUTO%TYPE, NM_TABELA_P PDE_STAGE.NM_TABELA%TYPE, NM_ATRIBUTO_P PDE_STAGE.NM_ATRIBUTO%TYPE, IE_DOMINIO_P PDE_ATTRIBUTE.IE_DOMINIO%TYPE, VL_ATRIBUTO_P PDE_STAGE.VL_ATRIBUTO%TYPE, VL_FK_1_P PDE_STAGE.VL_FK_1%TYPE, VL_FK_2_P PDE_STAGE.VL_FK_2%TYPE, VL_FK_3_P PDE_STAGE.VL_FK_3%TYPE, VL_FK_4_P PDE_STAGE.VL_FK_4%TYPE, DT_ATUALIZACAO_P PDE_STAGE.DT_ATUALIZACAO%TYPE) AS $body$
DECLARE

        DS_VALOR_W     varchar(255) := VL_ATRIBUTO_P;
        DS_VALOR_SNM_W varchar(255);

BEGIN
        IF (coalesce(IE_DOMINIO_P, 0) > 0) THEN
          DS_VALOR_SNM_W := pde.fnc_get_domain_snm_value(NM_TABELA_P,
                                                     NM_ATRIBUTO_P,
                                                     IE_DOMINIO_P,
                                                     VL_ATRIBUTO_P);

          DS_VALOR_W := pde.fnc_get_domain_descr_value(NM_TABELA_P,
                                                   NM_ATRIBUTO_P,
                                                   IE_DOMINIO_P,
                                                   VL_ATRIBUTO_P);
        END IF;

        CALL pde.add_vl_fk(NM_TABELA_P, VL_FK_1_P, VL_FK_2_P, VL_FK_3_P, VL_FK_4_P);

        IE_POSSUI_ATRIB_W := 'S';

        JSON_ATRIBUTO_W := PHILIPS_JSON();
        JSON_ATRIBUTO_W.PUT('code', CD_ONTOLOGIA_P);
        JSON_ATRIBUTO_W.PUT('name',
                            EXPRESSAO_PCK.OBTER_DESC_EXPRESSAO(CD_EXP_ATRIBUTO_P));
        JSON_ATRIBUTO_W.PUT('system', 'SNM');
        JSON_ATRIBUTO_W.PUT('date',
                            TO_CHAR(DT_ATUALIZACAO_P,
                                    'MM/DD/YYYY HH24:MI:SS'));
        JSON_ATRIBUTO_W.PUT('value', VL_ATRIBUTO_P);
        JSON_ATRIBUTO_W.PUT('valueSnm', DS_VALOR_SNM_W);
        JSON_ATRIBUTO_W.PUT('descriptiveValue', DS_VALOR_W);

        JSON_ATRIBUTOS_P.APPEND(JSON_ATRIBUTO_W.TO_JSON_VALUE());

        CALL pde.add_codicos_complementares(CD_ONTOLOGIA2_P);
        CALL pde.add_codicos_complementares(CD_ONTOLOGIA3_P);
        CALL pde.add_codicos_complementares(CD_ONTOLOGIA4_P);
        CALL pde.add_codicos_complementares(CD_ONTOLOGIA5_P);
        CALL pde.add_codicos_complementares(CD_ONTOLOGIA6_P);
        CALL pde.add_codicos_complementares(CD_ONTOLOGIA7_P);
      END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pde.add_attrib (CD_ONTOLOGIA_P PDE_ATTRIBUTE.CD_ONTOLOGIA%TYPE, CD_ONTOLOGIA2_P PDE_ATTRIBUTE.CD_ONTOLOGIA2%TYPE, CD_ONTOLOGIA3_P PDE_ATTRIBUTE.CD_ONTOLOGIA3%TYPE, CD_ONTOLOGIA4_P PDE_ATTRIBUTE.CD_ONTOLOGIA4%TYPE, CD_ONTOLOGIA5_P PDE_ATTRIBUTE.CD_ONTOLOGIA5%TYPE, CD_ONTOLOGIA6_P PDE_ATTRIBUTE.CD_ONTOLOGIA6%TYPE, CD_ONTOLOGIA7_P PDE_ATTRIBUTE.CD_ONTOLOGIA7%TYPE, CD_EXP_ATRIBUTO_P PDE_ATTRIBUTE.CD_EXP_ATRIBUTO%TYPE, NM_TABELA_P PDE_STAGE.NM_TABELA%TYPE, NM_ATRIBUTO_P PDE_STAGE.NM_ATRIBUTO%TYPE, IE_DOMINIO_P PDE_ATTRIBUTE.IE_DOMINIO%TYPE, VL_ATRIBUTO_P PDE_STAGE.VL_ATRIBUTO%TYPE, VL_FK_1_P PDE_STAGE.VL_FK_1%TYPE, VL_FK_2_P PDE_STAGE.VL_FK_2%TYPE, VL_FK_3_P PDE_STAGE.VL_FK_3%TYPE, VL_FK_4_P PDE_STAGE.VL_FK_4%TYPE, DT_ATUALIZACAO_P PDE_STAGE.DT_ATUALIZACAO%TYPE) FROM PUBLIC;