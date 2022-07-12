-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION san_obter_entidade_atend ( nr_atendimento_p bigint) RETURNS bigint AS $body$
DECLARE

 
cd_setor_atendimento_w integer;
nr_sequencia_w bigint;


BEGIN 
 
IF (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') THEN 
 
 cd_setor_atendimento_w := coalesce(obter_setor_atendimento(nr_atendimento_p),0);
 
 SELECT MAX(nr_sequencia) 
 INTO STRICT nr_sequencia_w 
 FROM san_entidade 
 WHERE cd_setor_atendimento = cd_setor_atendimento_w;
 
END IF;
 
RETURN nr_sequencia_w;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION san_obter_entidade_atend ( nr_atendimento_p bigint) FROM PUBLIC;

