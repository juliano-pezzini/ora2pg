-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_area_atendimento (cd_procedimento_p bigint) RETURNS bigint AS $body$
DECLARE

ie_retorno_w  bigint;


BEGIN
        SELECT  (obter_dados_estrut_proc(cd_procedimento,ie_origem_proced,'C','A'))::numeric
        INTO STRICT    ie_retorno_w
        FROM    procedimento
        WHERE   cd_procedimento = cd_procedimento;
RETURN ie_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_area_atendimento (cd_procedimento_p bigint) FROM PUBLIC;
