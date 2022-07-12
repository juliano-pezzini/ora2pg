-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_atend_medic_adm (nr_seq_atendimento_p bigint, nr_seq_material_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w  paciente_atend_medic.ie_administracao%type;


BEGIN

IF (nr_seq_atendimento_p IS NOT NULL AND nr_seq_atendimento_p::text <> '')
and (nr_seq_material_p IS NOT NULL AND nr_seq_material_p::text <> '') then

  SELECT ie_administracao
  INTO STRICT ds_retorno_w
  FROM paciente_atend_medic
  WHERE nr_seq_atendimento = nr_seq_atendimento_p
  AND nr_seq_material = nr_seq_material_p;

END IF;

return	ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_atend_medic_adm (nr_seq_atendimento_p bigint, nr_seq_material_p bigint) FROM PUBLIC;

