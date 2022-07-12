-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cpoe_consiste_severidade_bloq ( cd_perfil_p bigint, nr_atendimento_p text, ie_severidade_p text) RETURNS varchar AS $body$
DECLARE


/*
	A ideia eh pegar o menor nivel cadastrado para o perfil e setor e bloquear para ele e severidades superiores.
	O order by garante que primeiro serao checadas regras que atendam essas condicoes, apos isso ira pegar regras gerais.
	Se exisitir uma regra para este perfil, porem nao obrigar para a severidade do parametro, nao precisa olhar as outras regras gerais, basta pular fora.
*/
	cd_setor_atendimento_w	integer;
	cd_estabelecimento_w   	estabelecimento.cd_estabelecimento%type;

	c01 CURSOR FOR
		SELECT x.ie_severidade_bloq,
			   x.cd_perfil,
			   x.cd_setor_atendimento,
			   x.nr_severidade
		  from (
				SELECT coalesce(b.ie_severidade_bloq, 'X') ie_severidade_bloq,
					   coalesce(a.cd_perfil, 99999) cd_perfil,
					   coalesce(a.cd_setor_atendimento, 99999) cd_setor_atendimento,
					   case b.ie_severidade_bloq
							when 'L' then 10
							when 'M' then 20
							when 'S' then 30
							when 'I' then 40
							else 0
					   end nr_severidade
				  from cpoe_regra_consistencia a,
					   cpoe_regra_interacao b
				 where coalesce(a.cd_perfil,cd_perfil_p) = cd_perfil_p
				   and ((coalesce(a.cd_setor_atendimento,cd_setor_atendimento_w) = cd_setor_atendimento_w) or (coalesce(a.cd_setor_atendimento::text, '') = '' and coalesce(nr_atendimento_p::text, '') = ''))
				   and b.nr_seq_regra = a.nr_sequencia
           and   coalesce(b.ie_situacao, 'A') = 'A'
				   and coalesce(a.cd_estabelecimento, cd_estabelecimento_w) = cd_estabelecimento_w
				) x
		 order by x.cd_perfil,
				  x.cd_setor_atendimento,
				  x.nr_severidade;

BEGIN

	cd_estabelecimento_w   := obter_estabelecimento_ativo;
	cd_setor_atendimento_w := obter_setor_atendimento(nr_atendimento_p);

	for c01_w in c01
	loop
		if (c01_w.ie_severidade_bloq = 'L') then
			return 'S';
		elsif ((c01_w.ie_severidade_bloq = 'M') and (ie_severidade_p in ('M', 'S', 'I'))) then
			return 'S';
		elsif ((c01_w.ie_severidade_bloq = 'S') and (ie_severidade_p in ('S', 'I'))) then
			return 'S';
		elsif (c01_w.ie_severidade_bloq = 'I' AND ie_severidade_p = 'I') then
			return 'S';
		elsif (c01_w.ie_severidade_bloq = ie_severidade_p) then
			return 'S';
		/* Se existe regra especifica para este perfil mas nao se enquadrou na condicao acima, entao nao podera olhar para as regras gerais */

		elsif (c01_w.cd_perfil = cd_perfil_p) then
			return 'N';
		end if;
	end loop;

	return 'N';

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cpoe_consiste_severidade_bloq ( cd_perfil_p bigint, nr_atendimento_p text, ie_severidade_p text) FROM PUBLIC;

