-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION ctb_regras_contabil.obter_coluna_chave_primaria ( nm_tabela_p text ) RETURNS varchar AS $body$
DECLARE


    nm_column_w		ALL_CONS_COLUMNS.COLUMN_NAME%type;


BEGIN
	BEGIN
		SELECT	 MAX(b.COLUMN_NAME)
		INTO STRICT	 nm_column_w
		FROM	 ALL_CONSTRAINTS a,
			 ALL_CONS_COLUMNS b
		WHERE	 b.TABLE_NAME 		= nm_tabela_p
		AND	 a.CONSTRAINT_TYPE 	= 'P'
		AND	 a.CONSTRAINT_NAME 	= b.CONSTRAINT_NAME
		AND	 a.OWNER 		= b.OWNER
		ORDER BY b.TABLE_NAME,
			 b.POSITION;
	EXCEPTION
		WHEN no_data_found THEN nm_column_w := NULL;
	END;
	RETURN nm_column_w;
    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION ctb_regras_contabil.obter_coluna_chave_primaria ( nm_tabela_p text ) FROM PUBLIC;