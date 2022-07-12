-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_regra_rep_mult_ponto ( nr_seq_regra_pontuacao_p mat_crit_rep_regra_mult.nr_seq_regra_rep_ponto%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, cd_empresa_p empresa.cd_empresa%type, cd_medico_p mat_crit_rep_regra_mult.cd_medico%type, cd_especialidade_p mat_crit_rep_regra_mult.cd_especialidade%type, dt_referencia_p timestamp) RETURNS bigint AS $body$
DECLARE


vl_retorno_w	mat_crit_rep_regra_mult.vl_multiplo%type;

regras_multiplos CURSOR FOR
SELECT	coalesce(vl_multiplo, 1) vl_multiplo
from	mat_crit_rep_regra_mult
where	nr_seq_regra_rep_ponto = nr_seq_regra_pontuacao_p
and (coalesce(cd_estabelecimento::text, '') = '' or cd_estabelecimento = cd_estabelecimento_p)
and (coalesce(cd_empresa, cd_empresa_p) = coalesce(cd_empresa_p, cd_empresa))
and (coalesce(cd_medico, cd_medico_p)  = coalesce(cd_medico_p, cd_medico))
and (coalesce(cd_especialidade, cd_especialidade_p) = coalesce(cd_especialidade_p, cd_especialidade))
and	(
	(coalesce(dt_inicio_vigencia::text, '') = '' and coalesce(dt_fim_vigencia::text, '') = '')
	or (dt_inicio_vigencia <= dt_referencia_p and coalesce(dt_fim_vigencia::text, '') = '')
	or (coalesce(dt_inicio_vigencia::text, '') = '' and dt_referencia_p <= dt_fim_vigencia)
	or (dt_referencia_p   between dt_inicio_vigencia and dt_fim_vigencia)
);


BEGIN

vl_retorno_w := 1;

for	regra in regras_multiplos loop
	vl_retorno_w := regra.vl_multiplo;
end loop;

return vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_regra_rep_mult_ponto ( nr_seq_regra_pontuacao_p mat_crit_rep_regra_mult.nr_seq_regra_rep_ponto%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, cd_empresa_p empresa.cd_empresa%type, cd_medico_p mat_crit_rep_regra_mult.cd_medico%type, cd_especialidade_p mat_crit_rep_regra_mult.cd_especialidade%type, dt_referencia_p timestamp) FROM PUBLIC;
