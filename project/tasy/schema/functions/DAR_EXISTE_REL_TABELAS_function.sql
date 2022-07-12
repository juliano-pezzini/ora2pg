-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION dar_existe_rel_tabelas (NR_SEQ_FILTER_P bigint, NM_TABELA_P text) RETURNS varchar AS $body$
DECLARE

	EXISTE_RELACIONAMENTO bigint;

BEGIN
    SELECT COUNT(*)
    INTO STRICT EXISTE_RELACIONAMENTO
    FROM DAR_TABLES_RELAT
    WHERE NM_TABLE = NM_TABELA_P
    AND (NR_NIVEL IS NOT NULL AND NR_NIVEL::text <> '') 
    AND NM_RELATIONSHIP_TABLE IN (SELECT NM_TABELA from QUERY_BUILDER_DADOS WHERE NR_SEQ_FILTER = NR_SEQ_FILTER_P)
    AND ((NM_RELATIONSHIP_TABLE IN ('PESSOA_FISICA', 'PESSOA_JURIDICA', 'EMPRESA', 'ESTABELECIMENTO') AND NR_NIVEL = 0) 
       OR NM_RELATIONSHIP_TABLE NOT IN ('PESSOA_FISICA', 'PESSOA_JURIDICA', 'EMPRESA', 'ESTABELECIMENTO')) 
    AND ((NM_TABLE IN ('PESSOA_FISICA', 'PESSOA_JURIDICA', 'EMPRESA', 'ESTABELECIMENTO') AND NR_NIVEL = 0) 
       OR NM_TABLE NOT IN ('PESSOA_FISICA', 'PESSOA_JURIDICA', 'EMPRESA', 'ESTABELECIMENTO'));

	IF (EXISTE_RELACIONAMENTO > 0) THEN
		RETURN 'S';
	ELSE
		RETURN 'N';
	END IF;	

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION dar_existe_rel_tabelas (NR_SEQ_FILTER_P bigint, NM_TABELA_P text) FROM PUBLIC;
