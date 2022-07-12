-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_tree_node_code_config ( SI_CONFIGURABLE_P text, SI_COMPONENT_TYPE_P text, NR_SEQ_DIC_OBJECT_P bigint, NR_SEQ_OBJ_SCHEM_P bigint) RETURNS bigint AS $body$
DECLARE


CD_TREE_NODE_W		bigint := 918102;
SI_CONFIG_DIC_OBJ_W	varchar(1);
SI_HAVE_PARAMS_W	varchar(1);

BEGIN

IF (coalesce(SI_CONFIGURABLE_P,'S') = 'S') THEN
	CASE
		WHEN SI_COMPONENT_TYPE_P ='WDBP' THEN
			CD_TREE_NODE_W := 918196;
		WHEN SI_COMPONENT_TYPE_P ='WCP' THEN
			CD_TREE_NODE_W := 899741;
		WHEN SI_COMPONENT_TYPE_P IN ('TVN','T','IT','DDM','VMI','TDDM') THEN
			SELECT	CASE WHEN COUNT(1)=0 THEN  'N'  ELSE 'S' END
			INTO STRICT	SI_HAVE_PARAMS_W
			FROM	OBJETO_SCHEMATIC_PARAM
			WHERE	NR_SEQ_OBJ_SCH = NR_SEQ_OBJ_SCHEM_P;

			IF (SI_HAVE_PARAMS_W = 'S') THEN
				CD_TREE_NODE_W := 899741;
			END IF;
		WHEN SI_COMPONENT_TYPE_P ='MN' THEN
			CD_TREE_NODE_W := 918102;
		ELSE
			CD_TREE_NODE_W := 899741;
	END CASE;
END IF;

RETURN	CD_TREE_NODE_W;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_tree_node_code_config ( SI_CONFIGURABLE_P text, SI_COMPONENT_TYPE_P text, NR_SEQ_DIC_OBJECT_P bigint, NR_SEQ_OBJ_SCHEM_P bigint) FROM PUBLIC;
