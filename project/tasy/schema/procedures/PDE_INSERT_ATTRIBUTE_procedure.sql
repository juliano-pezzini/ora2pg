-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pde_insert_attribute (NR_SEQ_PDE_MAIN_P bigint, NR_SEQ_PARENT_P bigint, VL_GROUP_DOMAIN_P text, NR_SEQ_ONTOL_TAB_P bigint, NR_SEQ_ONTOL_TAB_ATT_P bigint, NR_SEQ_ONTOL_ATT_GROUP_P bigint, NM_TABLE_P text, NM_ATTRIBUTE_P text, CD_ONTOLOGY_P text, CD_ONTOLOGY2_P text, CD_ONTOLOGY3_P text, CD_ONTOLOGY4_P text, CD_ONTOLOGY5_P text, CD_ONTOLOGY6_P text, CD_ONTOLOGY7_P text, NM_USER_P text, NR_NEW_SEQUENCE_P INOUT bigint) AS $body$
BEGIN
  NULL;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pde_insert_attribute (NR_SEQ_PDE_MAIN_P bigint, NR_SEQ_PARENT_P bigint, VL_GROUP_DOMAIN_P text, NR_SEQ_ONTOL_TAB_P bigint, NR_SEQ_ONTOL_TAB_ATT_P bigint, NR_SEQ_ONTOL_ATT_GROUP_P bigint, NM_TABLE_P text, NM_ATTRIBUTE_P text, CD_ONTOLOGY_P text, CD_ONTOLOGY2_P text, CD_ONTOLOGY3_P text, CD_ONTOLOGY4_P text, CD_ONTOLOGY5_P text, CD_ONTOLOGY6_P text, CD_ONTOLOGY7_P text, NM_USER_P text, NR_NEW_SEQUENCE_P INOUT bigint) FROM PUBLIC;

