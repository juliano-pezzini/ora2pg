-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_medico_consentido ( nr_atendimento_p bigint, cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w    atend_consent_carta_med.ie_consentiu%TYPE;


BEGIN
	  SELECT coalesce(MAX(ie_consentiu), 'N') ie_consentiu
    INTO STRICT ds_retorno_w
    FROM atend_consent_carta_med
    WHERE nr_atendimento = nr_atendimento_p
    AND cd_medico = cd_pessoa_fisica_p;

    RETURN ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_medico_consentido ( nr_atendimento_p bigint, cd_pessoa_fisica_p text) FROM PUBLIC;

