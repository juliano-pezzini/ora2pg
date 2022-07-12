-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_setor_lib_funcao (cd_funcao_p bigint, cd_setor_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


ie_retorno_w	varchar(255);


BEGIN

select	coalesce(max('S'), 'N')
into STRICT	ie_retorno_w
FROM regra_setor_funcao a
LEFT OUTER JOIN regra_setor_funcao_lib b ON (a.nr_sequencia = b.nr_seq_regra)
WHERE a.cd_funcao = cd_funcao_p and coalesce(b.cd_setor_atendimento, cd_setor_atendimento_p) = cd_setor_atendimento_p;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_setor_lib_funcao (cd_funcao_p bigint, cd_setor_atendimento_p bigint) FROM PUBLIC;

