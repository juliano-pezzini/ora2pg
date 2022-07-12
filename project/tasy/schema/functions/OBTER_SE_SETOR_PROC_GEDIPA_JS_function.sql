-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_setor_proc_gedipa_js (nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE

					 
ie_setor_processo_gedipa_w	varchar(1) := 'N';
					

BEGIN 
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then 
 
	ie_setor_processo_gedipa_w := obter_se_setor_processo_gedipa(obter_unidade_atendimento(nr_atendimento_p,'IAA','CS'));
 
end if;
 
return ie_setor_processo_gedipa_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_setor_proc_gedipa_js (nr_atendimento_p bigint) FROM PUBLIC;
