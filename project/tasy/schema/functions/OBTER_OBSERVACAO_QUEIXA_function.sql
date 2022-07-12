-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_observacao_queixa ( nr_atendimento_p bigint ) RETURNS varchar AS $body$
DECLARE
 ds_retorno_w triagem_pronto_atend.ds_obs_queixa%TYPE;

BEGIN
    IF (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') THEN 
        SELECT tpa.ds_obs_queixa
       INTO STRICT ds_retorno_w
       FROM triagem_pronto_atend tpa
       WHERE tpa.nr_sequencia = ( SELECT MAX(tp.nr_sequencia)
                                  FROM triagem_pronto_atend tp
                                  WHERE tp.nr_atendimento = nr_atendimento_p
       );

    END IF;

    RETURN ds_retorno_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_observacao_queixa ( nr_atendimento_p bigint ) FROM PUBLIC;

