-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION ish_pat_case_pck.obter_se_sem_acomod (cd_setor_atendimento_p unidade_atendimento.cd_setor_atendimento%type, cd_unidade_basica_p unidade_atendimento.cd_unidade_basica%type, cd_unidade_compl_p unidade_atendimento.cd_unidade_compl%type) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(1);


BEGIN

ds_retorno_w	:= 'N';

begin
select	'S'
into STRICT	ds_retorno_w
from	unidade_atendimento a,
	tipo_acomodacao b
where	a.cd_tipo_acomodacao      	= b.cd_tipo_acomodacao
and	b.ie_sem_acomodacao		= 'S'
and	a.cd_setor_atendimento	= cd_setor_atendimento_p
and	a.cd_unidade_basica 		= cd_unidade_basica_p
and	a.cd_unidade_compl 		= cd_unidade_compl_p  LIMIT 1;
exception
when others then
	ds_retorno_w := 'N';
end;

return	ds_retorno_w;

END;			

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION ish_pat_case_pck.obter_se_sem_acomod (cd_setor_atendimento_p unidade_atendimento.cd_setor_atendimento%type, cd_unidade_basica_p unidade_atendimento.cd_unidade_basica%type, cd_unidade_compl_p unidade_atendimento.cd_unidade_compl%type) FROM PUBLIC;