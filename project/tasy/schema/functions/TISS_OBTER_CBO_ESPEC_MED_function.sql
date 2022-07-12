-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION tiss_obter_cbo_espec_med (cd_convenio_p bigint, cd_medico_p text, ie_versao_p text, cd_cbo_saude_p text) RETURNS varchar AS $body$
DECLARE


/* lhalves OS 738017 em 30/06/2014.
Function desenvolvida para utilização na TISS_DADOS_SOLICITANTE_V
Quando é autorização convênio, o médico não tem especialidade, então verifica o parâmetro IE_CBO_AUTOR_ESPEC,
se habilitado, busca o CBO de acordo com todas as especidalides vinculadas ao médico, conforme a prioridade.
Se o parâmetro não estiver habiltiado, retorno o próprio CBO do médico CD_CBO_SAUDE_P, não afetando a configuração original.
*/
cd_especialidade_w	medico_especialidade.cd_especialidade%type;
nr_seq_cbo_saude_w	tiss_cbo_saude.nr_seq_cbo_saude%type;
cd_estabelecimento_w	estabelecimento.cd_estabelecimento%type := wheb_usuario_pck.get_cd_estabelecimento;
cd_cbo_saude_w		varchar(255);
ds_versao_w		varchar(20);
ie_cbo_autor_espec_w	varchar(1);

c01 CURSOR FOR
SELECT	cd_especialidade
from	medico_especialidade
where	cd_pessoa_fisica	= cd_medico_p
order by nr_seq_prioridade desc;


BEGIN

select	coalesce(max(ie_cbo_autor_espec),'N')
into STRICT	ie_cbo_autor_espec_w
from	tiss_parametros_convenio
where	cd_convenio		= cd_convenio_p
and	cd_estabelecimento	= cd_estabelecimento_w;


cd_cbo_saude_w	:= null;

if (ie_cbo_autor_espec_w = 'S') then

	open C01;
	loop
	fetch C01 into
		cd_especialidade_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		select	coalesce(max(b.nr_seq_cbo_saude),0)
		into STRICT	nr_seq_cbo_saude_w
		from	tiss_cbo_saude b
		where	cd_pessoa_fisica	= cd_medico_p
		and	cd_especialidade	= cd_especialidade_w
		and	b.ie_versao 		= ie_versao_p
		and	coalesce(cd_convenio,coalesce(cd_convenio_p,0)) = coalesce(cd_convenio_p,0);

		if (coalesce(nr_seq_cbo_saude_w,0) = 0) then
			select	coalesce(max(b.nr_seq_cbo_saude),0)
			into STRICT	nr_seq_cbo_saude_w
			from	tiss_cbo_saude b
			where	b.cd_pessoa_fisica	= cd_medico_p
			and	coalesce(b.cd_especialidade::text, '') = ''
			and	b.ie_versao 		= ie_versao_p
			and	coalesce(cd_convenio,coalesce(cd_convenio_p,0)) = coalesce(cd_convenio_p,0);

			if (coalesce(nr_seq_cbo_saude_w,0) = 0) then
				select	coalesce(max(b.nr_seq_cbo_saude),0)
				into STRICT	nr_seq_cbo_saude_w
				from	tiss_cbo_saude b
				where	cd_especialidade	= cd_especialidade_w
				and	coalesce(b.cd_pessoa_fisica::text, '') = ''
				and	b.ie_versao 		= ie_versao_p
				and	coalesce(cd_convenio,coalesce(cd_convenio_p,0)) = coalesce(cd_convenio_p,0);

				if (coalesce(nr_seq_cbo_saude_w,0) = 0) then
					select	coalesce(max(b.nr_seq_cbo_saude),0)
					into STRICT	nr_seq_cbo_saude_w
					from	pessoa_fisica b
					where	b.cd_pessoa_fisica	= cd_medico_p
					and	TISS_OBTER_SE_CBO_VERSAO(b.nr_seq_cbo_saude,ie_versao_p) = 'S';

					if (coalesce(nr_seq_cbo_saude_w,0) = 0) then	/*lhalves OS 369047 em 05/10/2011 - Buscar o CBO do cadastro da especialidade*/
						select	coalesce(max(b.nr_seq_cbo_saude),0)
						into STRICT	nr_seq_cbo_saude_w
						from	especialidade_medica b
						where	b.cd_especialidade	= cd_especialidade_w
						and	TISS_OBTER_SE_CBO_VERSAO(b.nr_seq_cbo_saude,ie_versao_p) = 'S';

					end if;
				end if;
			end if;

		end if;

		if (coalesce(nr_seq_cbo_saude_w, 0)	> 0) and (TISS_OBTER_SE_CBO_VERSAO(nr_seq_cbo_saude_w,ie_versao_p) = 'S') then
			select	cd_cbo
			into STRICT	cd_cbo_saude_w
			from	cbo_saude
			where	nr_sequencia	= nr_seq_cbo_saude_w;
		end if;

		end;
	end loop;
	close C01;
end if;

return 	coalesce(cd_cbo_saude_w,cd_cbo_saude_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION tiss_obter_cbo_espec_med (cd_convenio_p bigint, cd_medico_p text, ie_versao_p text, cd_cbo_saude_p text) FROM PUBLIC;
