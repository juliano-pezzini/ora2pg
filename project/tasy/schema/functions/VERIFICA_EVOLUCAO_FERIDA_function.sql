-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION verifica_evolucao_ferida (NR_ATENDIMENTO_P bigint, NR_SEQ_FERIDA_P bigint) RETURNS varchar AS $body$
DECLARE


  RETORNO  varchar(1) := 'N';
  EVOLUCAO bigint := 0;


BEGIN

  IF (coalesce(NR_ATENDIMENTO_P, 0) > 0) AND (coalesce(NR_SEQ_FERIDA_P, 0) > 0) THEN
    select count(0)
      INTO STRICT EVOLUCAO
      from CUR_EVOLUCAO ce
     where ce.nr_atendimento = NR_ATENDIMENTO_P
       and nr_seq_ferida = NR_SEQ_FERIDA_P
       and (dt_liberacao IS NOT NULL AND dt_liberacao::text <> '');

  END IF;

 IF EVOLUCAO > 0 THEN
 RETORNO := 'S';
 END IF;

 RETURN RETORNO;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION verifica_evolucao_ferida (NR_ATENDIMENTO_P bigint, NR_SEQ_FERIDA_P bigint) FROM PUBLIC;
