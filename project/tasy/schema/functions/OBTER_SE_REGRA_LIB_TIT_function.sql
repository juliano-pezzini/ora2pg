-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_regra_lib_tit ( nr_titulo_p text, nm_usuario_p text, cd_perfil_p bigint, cd_estabelecimento_p bigint, ie_tipo_pessoa_p text, vl_titulo_p bigint, cd_tipo_pessoa_p bigint, nr_seq_nota_fiscal_p bigint, cd_cgc_p text, dt_emissao_p timestamp, nr_seq_proj_rec_p bigint, ie_tipo_titulo_p text, nr_seq_classe_p bigint, ie_origem_titulo_p text, cd_operacao_nf_p bigint, vl_total_nota_p bigint, nr_ordem_compra_p bigint) RETURNS varchar AS $body$
DECLARE


ds_resultado_w		varchar(1);
ds_result_usuario_w	varchar(1);
ds_result_perfil_w	varchar(1);

nr_seq_regra_w		bigint;
qt_usuario_w		bigint;
qt_perfil_w		bigint;
ie_nivel_w		bigint;
qt_nivel_menor_w	bigint;
ie_nivel_lib_w		varchar(1);
ie_nivel_menor_w	bigint;
ie_liberar_w		bigint;

dt_emissao_ini_w	timestamp;
dt_emissao_fim_w	timestamp;
ie_regra_obtida_w	varchar(1)	:= 'N';

qt_regra_w		bigint;
nr_seq_regra_tit_pagar_w	conta_pagar_lib.nr_seq_regra_tit_pagar%type;
qt_reg_w		bigint;


BEGIN

dt_emissao_ini_w	:= trunc(dt_emissao_p);
dt_emissao_fim_w	:= fim_dia(dt_emissao_p);

select	max(nr_seq_regra_tit_pagar)
into STRICT	nr_seq_regra_tit_pagar_w
from	conta_pagar_lib a
where	a.nr_titulo	= nr_titulo_p;

if (nr_seq_regra_tit_pagar_w IS NOT NULL AND nr_seq_regra_tit_pagar_w::text <> '') then
	select	coalesce(max(a.ie_nivel_lib),'T')
	into STRICT	ie_nivel_lib_w
	from	regra_lib_tit_pagar a
	where	a.nr_sequencia = nr_seq_regra_tit_pagar_w;
end if;

if (ie_nivel_lib_w = 'T') then -- Isso fazia antes, se for TODOS necessarios para liberar, esse ie_liberar_w sempre vai ser 1 caso tenha algum pendente para liberar, e na verificacao abaixo do ie_liberar_w is null vai dar false, ate que todos tenham liberado
	select	count(*),
		max(CASE WHEN coalesce(a.dt_liberacao::text, '') = '' THEN 1  ELSE null END )
	into STRICT	qt_usuario_w,
		ie_liberar_w
	from	regra_lib_tit_pagar b,
		conta_pagar_lib a
	where	dt_emissao_fim_w		>= coalesce(b.dt_inicio_vigencia,dt_emissao_fim_w)
	and	dt_emissao_ini_w		<= coalesce(b.dt_fim_vigencia,dt_emissao_ini_w)
	and	a.nr_seq_regra_tit_pagar	= b.nr_sequencia
	and	(a.nm_usuario_lib IS NOT NULL AND a.nm_usuario_lib::text <> '')
	and	(a.ie_nivel IS NOT NULL AND a.ie_nivel::text <> '')
	and	a.nr_titulo			= nr_titulo_p;

elsif (ie_nivel_lib_w = 'N') then -- Se for Uma liberacao de cada nivel, mesma verificacao que faz na rotina liberar_titulo_pagar, quando um usuario libera e verifica na regra se ja deve liberar o titulo ou nao.
	select	count(*)
	into STRICT	qt_usuario_w
	from	conta_pagar_lib a
	where	(ie_nivel IS NOT NULL AND ie_nivel::text <> '')
  and	(a.nm_usuario_lib IS NOT NULL AND a.nm_usuario_lib::text <> '')
	and	a.nr_titulo = nr_titulo_p
	and	not exists (SELECT	1
			from	conta_pagar_lib x
			where	x.nr_titulo = a.nr_titulo
			and	x.ie_nivel  = a.ie_nivel
			and	(x.dt_liberacao IS NOT NULL AND x.dt_liberacao::text <> ''));

	if (qt_usuario_w = 0) then
		ie_liberar_w := null;
	else
		ie_liberar_w := 1;
	end if;

end if;

if (qt_usuario_w	> 0) then	/* ahoffelder - OS 388850 - 30/01/2012 */
	if (coalesce(ie_liberar_w::text, '') = '') then	/* se todos os usuario ja liberaram o titulo */
		ds_result_usuario_w	:= 'S';
	else

		select	min(a.ie_nivel)
		into STRICT	ie_nivel_w
		from	regra_lib_tit_pagar b,
			conta_pagar_lib a
		where	dt_emissao_fim_w		>= coalesce(b.dt_inicio_vigencia,dt_emissao_fim_w)
		and	dt_emissao_ini_w		<= coalesce(b.dt_fim_vigencia,dt_emissao_ini_w)
		and	a.nr_seq_regra_tit_pagar	= b.nr_sequencia
		and	coalesce(a.dt_liberacao::text, '') = ''
		and	a.nm_usuario_lib		= nm_usuario_p
		and	(a.ie_nivel IS NOT NULL AND a.ie_nivel::text <> '')
		and	a.nr_titulo			= nr_titulo_p;

		if (coalesce(ie_nivel_w::text, '') = '') then	/* se nao tiver regra de liberacao para o usuario */
			ds_result_usuario_w	:= 'N';

		else

			SELECT * FROM obter_regra_nivel_tit_pag(	nr_seq_nota_fiscal_p, nr_seq_proj_rec_p, dt_emissao_ini_w, dt_emissao_fim_w, cd_estabelecimento_p, vl_titulo_p, ie_tipo_pessoa_p, cd_tipo_pessoa_p, cd_cgc_p, ie_tipo_titulo_p, nr_seq_classe_p, ie_origem_titulo_p, cd_operacao_nf_p, vl_total_nota_p, nr_ordem_compra_p, nr_seq_regra_w, ie_nivel_lib_w) INTO STRICT nr_seq_regra_w, ie_nivel_lib_w;

			ie_regra_obtida_w	:= 'S';

			if (ie_nivel_lib_w = 'N') then	/* exige liberacao de pelo menos um usuario de cada nivel */


				/* verificar se existe algum usuario com nivel de liberacao inferior */

				select	max(a.ie_nivel)
				into STRICT	ie_nivel_menor_w
				from	regra_lib_tit_pagar b,
					conta_pagar_lib a
				where	dt_emissao_fim_w		>= coalesce(b.dt_inicio_vigencia,dt_emissao_fim_w)
				and	dt_emissao_ini_w		<= coalesce(b.dt_fim_vigencia,dt_emissao_ini_w)
				and	a.nr_seq_regra_tit_pagar	= b.nr_sequencia
				and	(a.nm_usuario_lib IS NOT NULL AND a.nm_usuario_lib::text <> '')
				and	a.ie_nivel			< ie_nivel_w
				and	a.nr_titulo			= nr_titulo_p;

				if (coalesce(ie_nivel_menor_w::text, '') = '') then

					ds_result_usuario_w	:= 'S';

				else

					/* veririficar se pelo menos um dos usuarios do nivel inferior ja liberou o titulo */

					select	count(*)
					into STRICT	qt_nivel_menor_w
					from	regra_lib_tit_pagar b,
						conta_pagar_lib a
					where	dt_emissao_fim_w		>= coalesce(b.dt_inicio_vigencia,dt_emissao_fim_w)
					and	dt_emissao_ini_w		<= coalesce(b.dt_fim_vigencia,dt_emissao_ini_w)
					and	a.nr_seq_regra_tit_pagar	= b.nr_sequencia
					and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
					and	(a.nm_usuario_lib IS NOT NULL AND a.nm_usuario_lib::text <> '')
					and	a.ie_nivel			= ie_nivel_menor_w
					and	a.nr_titulo			= nr_titulo_p;

					if (qt_nivel_menor_w = 0) then
						ds_result_usuario_w	:= 'N';
					else
						ds_result_usuario_w	:= 'S';
					end if;

				end if;

			else	/* exige liberacao de todos os usuarios do nivel */
				select	count(*)
				into STRICT	qt_nivel_menor_w
				from	regra_lib_tit_pagar b,
					conta_pagar_lib a
				where	dt_emissao_fim_w		>= coalesce(b.dt_inicio_vigencia,dt_emissao_fim_w)
				and	dt_emissao_ini_w		<= coalesce(b.dt_fim_vigencia,dt_emissao_ini_w)
				and	a.nr_seq_regra_tit_pagar	= b.nr_sequencia
				and	coalesce(a.dt_liberacao::text, '') = ''
				and	(a.nm_usuario_lib IS NOT NULL AND a.nm_usuario_lib::text <> '')
				and	a.ie_nivel			< ie_nivel_w
				and	a.nr_titulo			= nr_titulo_p;

				if (qt_nivel_menor_w = 0) then
					ds_result_usuario_w	:= 'S';
				else
					ds_result_usuario_w	:= 'N';
				end if;
			end if;

		end if;

	end if;

else

	ds_result_usuario_w	:= 'S';

end if;

/* se tiver usuario na regra e o usuario nao estiver lirado, nao precisa verificar o perfil */

if (ds_result_usuario_w	= 'N') and (qt_usuario_w		> 0) then

	ds_resultado_w	:= 'N';

else

	if (ie_nivel_lib_w = 'T') then -- Isso fazia antes, se for TODOS necessarios para liberar, esse ie_liberar_w sempre vai ser 1 caso tenha algum pendente para liberar, e na verificacao abaixo do ie_liberar_w is null vai dar false, ate que todos tenham liberado
		select	count(*),
			max(CASE WHEN coalesce(a.dt_liberacao::text, '') = '' THEN 1  ELSE null END )
		into STRICT	qt_perfil_w,
			ie_liberar_w
		from	regra_lib_tit_pagar b,
			conta_pagar_lib a
		where	dt_emissao_fim_w		>= coalesce(b.dt_inicio_vigencia,dt_emissao_fim_w)
		and	dt_emissao_ini_w		<= coalesce(b.dt_fim_vigencia,dt_emissao_ini_w)
		and	a.nr_seq_regra_tit_pagar	= b.nr_sequencia
		and	(a.cd_perfil IS NOT NULL AND a.cd_perfil::text <> '')
		and	(a.ie_nivel IS NOT NULL AND a.ie_nivel::text <> '')
		and	a.nr_titulo			= nr_titulo_p;

	elsif (ie_nivel_lib_w = 'N') then -- Se for Uma liberacao de cada nivel, mesma verificacao que faz na rotina liberar_titulo_pagar, quando um usuario libera e verifica na regra se ja deve liberar o titulo ou nao.
		select	count(*)
		into STRICT	qt_perfil_w
		from	conta_pagar_lib a
		where	(ie_nivel IS NOT NULL AND ie_nivel::text <> '')
		and	a.nr_titulo = nr_titulo_p
		and	(a.cd_perfil IS NOT NULL AND a.cd_perfil::text <> '')
		and	not exists (SELECT	1
				from	conta_pagar_lib x
				where	x.nr_titulo = a.nr_titulo
				and	x.ie_nivel  = a.ie_nivel
				and	(x.cd_perfil IS NOT NULL AND x.cd_perfil::text <> '')
				and	(x.dt_liberacao IS NOT NULL AND x.dt_liberacao::text <> ''));

		if (qt_perfil_w = 0) then
			ie_liberar_w := null;
		else
			ie_liberar_w := 1;
		end if;

	end if;

	if (qt_perfil_w	> 0) then	/* ahoffelder - OS 419900 - 09/05/2012 */
		if (coalesce(ie_liberar_w::text, '') = '') then	/* se todos os perfis ja liberaram o titulo */
			ds_result_perfil_w	:= 'S';
		else

			select	min(a.ie_nivel)
			into STRICT	ie_nivel_w
			from	regra_lib_tit_pagar b,
				conta_pagar_lib a
			where	dt_emissao_fim_w		>= coalesce(b.dt_inicio_vigencia,dt_emissao_fim_w)
			and	dt_emissao_ini_w		<= coalesce(b.dt_fim_vigencia,dt_emissao_ini_w)
			and	a.nr_seq_regra_tit_pagar	= b.nr_sequencia
			and	coalesce(a.dt_liberacao::text, '') = ''
			and	a.cd_perfil			= cd_perfil_p
			and	(a.ie_nivel IS NOT NULL AND a.ie_nivel::text <> '')
			and	a.nr_titulo			= nr_titulo_p;

			if (coalesce(ie_nivel_w::text, '') = '') then	/* se nao tiver regra de liberacao para o perfil */
				ds_result_perfil_w	:= 'N';

			else

				if (ie_regra_obtida_w	= 'N') then

					SELECT * FROM obter_regra_nivel_tit_pag(	nr_seq_nota_fiscal_p, nr_seq_proj_rec_p, dt_emissao_ini_w, dt_emissao_fim_w, cd_estabelecimento_p, vl_titulo_p, ie_tipo_pessoa_p, cd_tipo_pessoa_p, cd_cgc_p, ie_tipo_titulo_p, nr_seq_classe_p, ie_origem_titulo_p, cd_operacao_nf_p, vl_total_nota_p, nr_ordem_compra_p, nr_seq_regra_w, ie_nivel_lib_w) INTO STRICT nr_seq_regra_w, ie_nivel_lib_w;

					ie_regra_obtida_w	:= 'S';

				end if;
				if (ie_nivel_lib_w = 'N') then	/* exige liberacao de pelo menos um perfil de cada nivel */


					/* verificar se existe algum perfil com nivel de liberacao inferior */

					select	max(a.ie_nivel)
					into STRICT	ie_nivel_menor_w
					from	regra_lib_tit_pagar b,
						conta_pagar_lib a
					where	dt_emissao_fim_w		>= coalesce(b.dt_inicio_vigencia,dt_emissao_fim_w)
					and	dt_emissao_ini_w		<= coalesce(b.dt_fim_vigencia,dt_emissao_ini_w)
					and	a.nr_seq_regra_tit_pagar	= b.nr_sequencia
					and	(a.cd_perfil IS NOT NULL AND a.cd_perfil::text <> '')
					and	a.ie_nivel			< ie_nivel_w
					and	a.nr_titulo			= nr_titulo_p;

					if (coalesce(ie_nivel_menor_w::text, '') = '') then

						ds_result_perfil_w	:= 'S';

					else

						/* veririficar se pelo menos um dos perfis do nivel inferior ja liberou o titulo */

						select	count(*)
						into STRICT	qt_nivel_menor_w
						from	regra_lib_tit_pagar b,
							conta_pagar_lib a
						where	dt_emissao_fim_w		>= coalesce(b.dt_inicio_vigencia,dt_emissao_fim_w)
						and	dt_emissao_ini_w		<= coalesce(b.dt_fim_vigencia,dt_emissao_ini_w)
						and	a.nr_seq_regra_tit_pagar	= b.nr_sequencia
						and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
						and	(a.cd_perfil IS NOT NULL AND a.cd_perfil::text <> '')
						and	a.ie_nivel			= ie_nivel_menor_w
						and	a.nr_titulo			= nr_titulo_p;

						if (qt_nivel_menor_w = 0) then
							ds_result_perfil_w	:= 'N';
						else
							ds_result_perfil_w	:= 'S';
						end if;

					end if;

				else	/* exige liberacao de todos os perfis do nivel */
					select	count(*)
					into STRICT	qt_nivel_menor_w
					from	regra_lib_tit_pagar b,
						conta_pagar_lib a
					where	dt_emissao_fim_w		>= coalesce(b.dt_inicio_vigencia,dt_emissao_fim_w)
					and	dt_emissao_ini_w		<= coalesce(b.dt_fim_vigencia,dt_emissao_ini_w)
					and	a.nr_seq_regra_tit_pagar	= b.nr_sequencia
					and	coalesce(a.dt_liberacao::text, '') = ''
					and	(a.cd_perfil IS NOT NULL AND a.cd_perfil::text <> '')
					and	a.ie_nivel			< ie_nivel_w
					and	a.nr_titulo			= nr_titulo_p;

					if (qt_nivel_menor_w = 0) then
						ds_result_perfil_w	:= 'S';
					else
						ds_result_perfil_w	:= 'N';
					end if;
				end if;

			end if;

		end if;

	else

		ds_result_perfil_w	:= 'S';

		if (qt_usuario_w = 0) then

			/* verifica se existe regra para o tipo de pessoa do titulo */

			select	count(*)
			into STRICT	qt_regra_w
			from	regra_lib_tit_pagar a
			where	dt_emissao_fim_w		>= coalesce(a.dt_inicio_vigencia,dt_emissao_fim_w)
			and	dt_emissao_ini_w		<= coalesce(a.dt_fim_vigencia,dt_emissao_ini_w)
			and	a.cd_estabelecimento		= cd_estabelecimento_p
			and (a.ie_tipo_pessoa = 'A' or a.ie_tipo_pessoa = ie_tipo_pessoa_p);

			if (qt_regra_w	> 0) then

				if (ie_regra_obtida_w	= 'N') then

					SELECT * FROM obter_regra_nivel_tit_pag(	nr_seq_nota_fiscal_p, nr_seq_proj_rec_p, dt_emissao_ini_w, dt_emissao_fim_w, cd_estabelecimento_p, vl_titulo_p, ie_tipo_pessoa_p, cd_tipo_pessoa_p, cd_cgc_p, ie_tipo_titulo_p, nr_seq_classe_p, ie_origem_titulo_p, cd_operacao_nf_p, vl_total_nota_p, nr_ordem_compra_p, nr_seq_regra_w, ie_nivel_lib_w) INTO STRICT nr_seq_regra_w, ie_nivel_lib_w;

					ie_regra_obtida_w	:= 'S';

				end if;

				if (coalesce(nr_seq_regra_w::text, '') = '') then
					ds_resultado_w	:= 'N';
				else
					select	count(*)
					into STRICT	qt_regra_w
					from	regra_lib_tit_usuario a
					where	a.nr_seq_regra	= nr_seq_regra_w;

					/* verifica se o usuario tem permissao para liberar o titulo */

					if (qt_regra_w	> 0) then
						select	coalesce(max('S'),'N')
						into STRICT	ds_resultado_w
						from	regra_lib_tit_usuario a
						where	a.nr_seq_regra		= nr_seq_regra_w
						and	a.nm_usuario_lib	= nm_usuario_p;
					else
						ds_resultado_w	:= 'S';
					end if;

					if (ds_resultado_w = 'S') then

						select	count(*)
						into STRICT	qt_regra_w
						from	regra_lib_tit_perfil a
						where	a.nr_seq_regra	= nr_seq_regra_w;

						/* verifica se o perfil tem permissao para liberar o titulo */

						if (qt_regra_w > 0) then

							select	coalesce(max('S'),'N')
							into STRICT	ds_resultado_w
							from	regra_lib_tit_perfil a
							where	a.cd_perfil	= cd_perfil_p
							and	a.nr_seq_regra	= nr_seq_regra_w;
						end if;
					end if;
				end if;

			else
				ds_resultado_w	:= 'S';
			end if;

		end if;
	end if;

  if (ds_result_usuario_w  = 'S') and (ds_result_perfil_w  = 'S') and (coalesce(ds_resultado_w::text, '') = '') then
      ds_resultado_w  := 'S';
  elsif ((ds_resultado_w IS NOT NULL AND ds_resultado_w::text <> '') and ds_resultado_w = 'S') then
      ds_resultado_w  := 'S';
  else
      ds_resultado_w  := 'N';
  end if;
end if;

RETURN ds_resultado_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_regra_lib_tit ( nr_titulo_p text, nm_usuario_p text, cd_perfil_p bigint, cd_estabelecimento_p bigint, ie_tipo_pessoa_p text, vl_titulo_p bigint, cd_tipo_pessoa_p bigint, nr_seq_nota_fiscal_p bigint, cd_cgc_p text, dt_emissao_p timestamp, nr_seq_proj_rec_p bigint, ie_tipo_titulo_p text, nr_seq_classe_p bigint, ie_origem_titulo_p text, cd_operacao_nf_p bigint, vl_total_nota_p bigint, nr_ordem_compra_p bigint) FROM PUBLIC;

