-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_score_pup_e_pim2_md (ie_resposta_pupilas_p text ) RETURNS bigint AS $body$
DECLARE


   qt_pontuacao_w	double precision;

BEGIN
	--- Inicio MD5
	if (ie_resposta_pupilas_p = 'N') then
		qt_pontuacao_w	:= 0;
	elsif (ie_resposta_pupilas_p = 'S') then
		qt_pontuacao_w	:= 3.0791;
	else
		qt_pontuacao_w	:= 0;
	end if;
	--- Fim MD5
    RETURN coalesce(qt_pontuacao_w,0);
   
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_score_pup_e_pim2_md (ie_resposta_pupilas_p text ) FROM PUBLIC;
