-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION qtd_usu_lib_hist (nr_sequencia_hist_p bigint) RETURNS bigint AS $body$
DECLARE


qtd_usuarios_w bigint;


BEGIN

SELECT COUNT(a.NM_USUARIO_LIB)
INTO STRICT	qtd_usuarios_w
FROM 	cml_prospect_hist_lib a,
	cml_prospect_hist b,
	cml_prospect c
WHERE 	a.nr_seq_historico = b.nr_sequencia
AND	b.nr_seq_prospect = c.nr_sequencia
AND	b.nr_sequencia = nr_sequencia_hist_p;

RETURN	qtd_usuarios_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION qtd_usu_lib_hist (nr_sequencia_hist_p bigint) FROM PUBLIC;
