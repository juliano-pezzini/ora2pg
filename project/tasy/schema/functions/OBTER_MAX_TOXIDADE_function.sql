-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_max_toxidade ( nr_atendimento_p bigint, dt_avalicao_p timestamp ) RETURNS bigint AS $body$
DECLARE

			 
ie_toxidade_w	bigint;


BEGIN 
 
Select 	max(a.ie_toxidade) 
into STRICT	ie_toxidade_w 
from	escala_mucosite a, 
	atendimento_paciente b 
where	a.nr_atendimento = b.nr_atendimento 
and	a.nr_atendimento = nr_atendimento_p 
and	trunc(dt_avaliacao) = trunc(dt_avalicao_p) 
and	((upper(obter_desc_classif_atend(b.nr_seq_classificacao)) like '%ONCOLOGIA%') or (upper(obter_desc_classif_atend(b.nr_seq_classificacao)) like '%HEMATOLOGIA%') or (upper(obter_desc_classif_atend(b.nr_seq_classificacao)) like '%TMO%') or (upper(obter_desc_classif_atend(b.nr_seq_classificacao)) like '%MEDULA%'));
 
return ie_toxidade_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_max_toxidade ( nr_atendimento_p bigint, dt_avalicao_p timestamp ) FROM PUBLIC;
