-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cih_obter_se_tecnica ( nr_seq_dados_hig_p bigint) RETURNS varchar AS $body$
DECLARE


is_11_tec_w             varchar(1) := 'N';

BEGIN
IF (coalesce(nr_seq_dados_hig_p,0) > 0) THEN

        SELECT  CASE WHEN COUNT(1)=11 THEN 'S'  ELSE 'N' END
        INTO STRICT    is_11_tec_w
        FROM    cih_tecnica_hig_maos
        WHERE   nr_seq_dados_hig  = nr_seq_dados_hig_p;

END IF;

RETURN	is_11_tec_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cih_obter_se_tecnica ( nr_seq_dados_hig_p bigint) FROM PUBLIC;
