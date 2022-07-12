-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_conversao_tab_tiss ( ie_tipo_tabela_imp_p text, cd_estabelecimento_p bigint, cd_procedimento_p bigint, ie_tipo_despesa_mat_p text, ie_aplicacao_regra_p text, nr_seq_prestador_p bigint, ie_tipo_despesa_tiss_p bigint, cd_material_p pls_material.cd_material_ops%type default null) RETURNS PLS_CTA_VALORIZACAO_PCK.DADOS_TIPO_CONV_TISS AS $body$
DECLARE


/* Não é testado o IE_ORIGEM_PROCED, pois o objetivo da function é retornar a tabela TISS e consequentemente a origem */

pls_dados_conv_tiss_w		pls_cta_valorizacao_pck.dados_tipo_conv_tiss;
ie_tipo_tabela_w		varchar(10);
cd_area_procedimento_w		bigint;
cd_especialidade_w		bigint;
cd_grupo_proc_w			bigint;
ie_origem_proced_w		bigint;
nr_seq_grupo_rec_w		bigint;
cd_procedimento_w		bigint;
nr_seq_regra_w			bigint;
ie_tipo_tabela_ww		varchar(10);
nr_seq_material_w		bigint;
ie_tipo_despesa_tiss_conv_w	varchar(10);
ie_estrut_mat_w			varchar(1);
qt_regra_w			integer;
nr_seq_estrut_regra_w		pls_estrutura_material.nr_sequencia%type;
ie_tipo_despesa_tiss_w		pls_conversao_tabela_tiss.ie_tipo_despesa_tiss%type;
nr_seq_grupo_material_w		pls_conversao_tabela_tiss.nr_seq_grupo_material%type;
nr_seq_grupo_prestador_w	pls_conversao_tabela_tiss.nr_seq_grupo_prestador%type;
ie_ok_w				varchar(1) := 'S';
ie_grupo_mat_w			varchar(1) := 'S';


C01 CURSOR FOR
	SELECT	ie_tipo_tabela,
		ie_tipo_despesa_tiss_conv,
		nr_seq_estrutura_mat,
		nr_seq_grupo_material,
		nr_seq_grupo_prestador
	from	pls_conversao_tabela_tiss
	where	ie_situacao	= 'A'
	and	cd_estabelecimento 	= cd_estabelecimento_p
	and	((coalesce(ie_tipo_tabela_imp::text, '') = '') or ((ie_tipo_tabela_imp)::numeric  = (ie_tipo_tabela_imp_p)::numeric ))
	and	ie_aplicacao_regra	= coalesce(ie_aplicacao_regra_p,'C')
	and	((coalesce(cd_area_procedimento::text, '') = '') or (cd_area_procedimento = cd_area_procedimento_w ))
	and	((coalesce(cd_especialidade::text, '') = '') or (cd_especialidade = cd_especialidade_w))
	and	((coalesce(cd_grupo_proc::text, '') = '') or (cd_grupo_proc = cd_grupo_proc_w))
	and	((coalesce(cd_procedimento::text, '') = '') or (cd_procedimento = cd_procedimento_p ))
	and	((coalesce(ie_tipo_despesa_mat::text, '') = '') or (ie_tipo_despesa_mat = ie_tipo_despesa_mat_p))
	and	((coalesce(nr_seq_grupo_rec::text, '') = '') or (nr_seq_grupo_rec = nr_seq_grupo_rec_w))
	and	((coalesce(nr_seq_prestador::text, '') = '') or (nr_seq_prestador = nr_seq_prestador_p))
	and	((coalesce(nr_seq_material::text, '') = '') or (nr_seq_material = nr_seq_material_w))
	and	((coalesce(ie_tipo_despesa_tiss::text, '') = '') or (ie_tipo_despesa_tiss = ie_tipo_despesa_tiss_w))
	order by
		coalesce(nr_seq_prestador,0),
		coalesce(nr_seq_material,0),
		coalesce(ie_tipo_despesa_mat,'A'),
		coalesce(cd_procedimento,0),
		coalesce(cd_grupo_proc,0),
		coalesce(cd_especialidade,0),
		coalesce(cd_area_procedimento,0),
		coalesce(nr_seq_grupo_rec,0),
		coalesce(ie_tipo_tabela_imp,'A');
C02 CURSOR FOR
	    SELECT	a.ie_origem_proced
	    from	pls_regra_origem_proced		a
	    where	a.cd_estabelecimento	= cd_estabelecimento_p
	    and		((coalesce(a.ie_acao_regra,'A') = 'A') or (coalesce(a.ie_acao_regra,'A') = 'R'))
	    and  	exists ( SELECT	x.ie_origem_proced
				  from 		procedimento	x
				  where		x.ie_origem_proced = a.ie_origem_proced
				  and		x.cd_procedimento = cd_procedimento_p
				  and		x.ie_situacao	= 'A');

C03 CURSOR FOR
	SELECT	ie_tipo_tabela,
		ie_tipo_despesa_tiss_conv,
		nr_seq_estrutura_mat,
		nr_seq_grupo_material,
		nr_seq_grupo_prestador
	from	pls_conversao_tabela_tiss
	where	ie_situacao	= 'A'
	and	cd_estabelecimento 	= cd_estabelecimento_p
	and	((coalesce(ie_tipo_tabela_imp::text, '') = '') or ((ie_tipo_tabela_imp)::numeric  = (ie_tipo_tabela_imp_p)::numeric ))
	and	ie_aplicacao_regra	= coalesce(ie_aplicacao_regra_p,'C')
	and	((coalesce(cd_area_procedimento::text, '') = '') or (cd_area_procedimento = cd_area_procedimento_w ))
	and	((coalesce(cd_especialidade::text, '') = '') or (cd_especialidade = cd_especialidade_w))
	and	((coalesce(cd_grupo_proc::text, '') = '') or (cd_grupo_proc = cd_grupo_proc_w))
	and	((coalesce(cd_procedimento::text, '') = '') or (cd_procedimento = cd_procedimento_p ))
	and	((coalesce(ie_tipo_despesa_mat::text, '') = '') or (ie_tipo_despesa_mat = ie_tipo_despesa_mat_p))
	and	((coalesce(nr_seq_grupo_rec::text, '') = '') or (nr_seq_grupo_rec = nr_seq_grupo_rec_w))
	and	((coalesce(nr_seq_prestador::text, '') = '') or (nr_seq_prestador = nr_seq_prestador_p))
	and	((coalesce(nr_seq_material::text, '') = '') or (nr_seq_material = nr_seq_material_w))
	and	((coalesce(ie_tipo_despesa_tiss::text, '') = '') or (ie_tipo_despesa_tiss = ie_tipo_despesa_tiss_w))
	order by
		coalesce(nr_ordem_exec_regra,0) desc;


BEGIN

select	count(1)
into STRICT	qt_regra_w
from	pls_conversao_tabela_tiss
where	ie_situacao = 'A'
and	cd_estabelecimento = cd_estabelecimento_p
and	(nr_ordem_exec_regra IS NOT NULL AND nr_ordem_exec_regra::text <> '');

select	CASE WHEN ie_tipo_despesa_tiss_p='1' THEN  '01' WHEN ie_tipo_despesa_tiss_p='2' THEN  '02' WHEN ie_tipo_despesa_tiss_p='3' THEN  '03' WHEN ie_tipo_despesa_tiss_p='5' THEN  '05' WHEN ie_tipo_despesa_tiss_p='7' THEN  '07' WHEN ie_tipo_despesa_tiss_p='8' THEN  '08'  ELSE ie_tipo_despesa_tiss_p END
into STRICT	ie_tipo_despesa_tiss_w
;

if (coalesce(cd_procedimento_p,0) > 0) then

	open C02;
	loop
	fetch C02 into
		ie_origem_proced_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		if (coalesce(ie_origem_proced_w,0) > 0) then
			begin
				select	nr_seq_grupo_rec
				into STRICT	nr_seq_grupo_rec_w
				from	procedimento
				where	cd_procedimento_p = cd_procedimento
				and	ie_origem_proced = ie_origem_proced_w
				and	ie_situacao = 'A';
			exception
			when others then
				nr_seq_grupo_rec_w := null;
			end;
			SELECT * FROM pls_obter_estrut_proc(cd_procedimento_p, ie_origem_proced_w, cd_area_procedimento_w, cd_especialidade_w, cd_grupo_proc_w, ie_origem_proced_w) INTO STRICT cd_area_procedimento_w, cd_especialidade_w, cd_grupo_proc_w, ie_origem_proced_w;
		end if;

		if (qt_regra_w > 0) then
			open C03;
			loop
			fetch C03 into
				ie_tipo_tabela_ww,
				ie_tipo_despesa_tiss_conv_w,
				nr_seq_estrut_regra_w,
				nr_seq_grupo_material_w,
				nr_seq_grupo_prestador_w;
			EXIT WHEN NOT FOUND; /* apply on C03 */
				begin

				ie_ok_w := 'S';
				ie_grupo_mat_w := 'S';
				--Aqui nesse ponto, caso tiver grupo material na regra, então já é inválida, pois a seq material certamente estará nula
				if (nr_seq_grupo_material_w IS NOT NULL AND nr_seq_grupo_material_w::text <> '') then
					ie_grupo_mat_w := 'N';
				end if;

				--nr_seq_prestador_p
				if ((nr_seq_grupo_prestador_w IS NOT NULL AND nr_seq_grupo_prestador_w::text <> '') and ie_grupo_mat_w = 'S') then

					if (pls_obter_se_grupo_prestador(nr_seq_prestador_p, nr_seq_grupo_prestador_w) = 'S') then
						ie_ok_w	:= 'S';
					else
						ie_ok_w := 'N';
					end if;
				else
					ie_ok_w := 'S';
				end if;

				if (ie_ok_w = 'S') and (nr_seq_estrut_regra_w IS NOT NULL AND nr_seq_estrut_regra_w::text <> '') then
					ie_ok_w	:= 'N';
				end if;

				if (ie_ok_w = 'S' and ie_grupo_mat_w = 'S') then
					ie_tipo_tabela_w := ie_tipo_tabela_ww;
					pls_dados_conv_tiss_w.ie_tipo_tabela := ie_tipo_tabela_w;
					pls_dados_conv_tiss_w.ie_tipo_despesa_tiss := ie_tipo_despesa_tiss_conv_w;
				end if;

				exit;
				end;
			end loop;
			close C03;
		else
			open C01;
			loop
			fetch C01 into
				ie_tipo_tabela_ww,
				ie_tipo_despesa_tiss_conv_w,
				nr_seq_estrut_regra_w,
				nr_seq_grupo_material_w	,
				nr_seq_grupo_prestador_w;
			EXIT WHEN NOT FOUND; /* apply on C01 */
				begin

				ie_ok_w := 'S';
				ie_grupo_mat_w := 'S';
				--Aqui nesse ponto, caso tiver grupo material na regra, então já é inválida, pois a seq material certamente estará nula
				if (nr_seq_grupo_material_w IS NOT NULL AND nr_seq_grupo_material_w::text <> '') then
					ie_grupo_mat_w := 'N';
				end if;

				--nr_seq_prestador_p
				if ((nr_seq_grupo_prestador_w IS NOT NULL AND nr_seq_grupo_prestador_w::text <> '') and ie_grupo_mat_w = 'S') then

					if (pls_obter_se_grupo_prestador(nr_seq_prestador_p, nr_seq_grupo_prestador_w) = 'S') then
						ie_ok_w	:= 'S';
					else
						ie_ok_w := 'N';
					end if;
				else
					ie_ok_w := 'S';
				end if;

				if (ie_ok_w = 'S') and (nr_seq_estrut_regra_w IS NOT NULL AND nr_seq_estrut_regra_w::text <> '') then
					ie_ok_w	:= 'N';
				end if;

				if (ie_ok_w = 'S' and ie_grupo_mat_w = 'S') then
					ie_tipo_tabela_w := ie_tipo_tabela_ww;
					pls_dados_conv_tiss_w.ie_tipo_tabela := ie_tipo_tabela_w;
					pls_dados_conv_tiss_w.ie_tipo_despesa_tiss := ie_tipo_despesa_tiss_conv_w;
				end if;

				end;
			end loop;
			close C01;
		end if;

		end;
	end loop;
	close C02;

	if (coalesce(ie_tipo_tabela_w,'X') ='X' ) then
		begin
			select	max(ie_origem_proced)
			into STRICT	ie_origem_proced_w
			from	procedimento
			where	cd_procedimento = cd_procedimento_p;
		exception
		when others then
			ie_origem_proced_w := null;
		end;
		if (ie_origem_proced_w > 0 ) then
			begin
				select	nr_seq_grupo_rec
				into STRICT	nr_seq_grupo_rec_w
				from	procedimento
				where	cd_procedimento_p = cd_procedimento
				and	ie_origem_proced = ie_origem_proced_w
				and	ie_situacao = 'A';
			exception
			when others then
				nr_seq_grupo_rec_w := null;
			end;

			SELECT * FROM pls_obter_estrut_proc(cd_procedimento_p, ie_origem_proced_w, cd_area_procedimento_w, cd_especialidade_w, cd_grupo_proc_w, ie_origem_proced_w) INTO STRICT cd_area_procedimento_w, cd_especialidade_w, cd_grupo_proc_w, ie_origem_proced_w;
		end if;

		if (qt_regra_w > 0) then
			open C03;
			loop
			fetch C03 into
				ie_tipo_tabela_ww,
				ie_tipo_despesa_tiss_conv_w,
				nr_seq_estrut_regra_w,
				nr_seq_grupo_material_w	,
				nr_seq_grupo_prestador_w;
			EXIT WHEN NOT FOUND; /* apply on C03 */

				ie_ok_w := 'S';

				ie_grupo_mat_w := 'S';
				--Aqui nesse ponto, caso tiver grupo material na regra, então já é inválida, pois a seq material certamente estará nula
				if (nr_seq_grupo_material_w IS NOT NULL AND nr_seq_grupo_material_w::text <> '') then
					ie_grupo_mat_w := 'N';
				end if;

				--nr_seq_prestador_p
				if ((nr_seq_grupo_prestador_w IS NOT NULL AND nr_seq_grupo_prestador_w::text <> '') and ie_grupo_mat_w = 'S') then

					if (pls_obter_se_grupo_prestador(nr_seq_prestador_p, nr_seq_grupo_prestador_w) = 'S') then
						ie_ok_w	:= 'S';
					else
						ie_ok_w := 'N';
					end if;
				else
					ie_ok_w := 'S';
				end if;

				if (ie_ok_w = 'S') and (nr_seq_estrut_regra_w IS NOT NULL AND nr_seq_estrut_regra_w::text <> '') then
					ie_ok_w	:= 'N';
				end if;

				if (ie_ok_w = 'S' and ie_grupo_mat_w = 'S') then
					ie_tipo_tabela_w := ie_tipo_tabela_ww;
					pls_dados_conv_tiss_w.ie_tipo_tabela := ie_tipo_tabela_w;
					pls_dados_conv_tiss_w.ie_tipo_despesa_tiss := ie_tipo_despesa_tiss_conv_w;
				end if;

				exit;
			end loop;
			close C03;
		else
			open C01;
			loop
			fetch C01 into
				ie_tipo_tabela_ww,
				ie_tipo_despesa_tiss_conv_w,
				nr_seq_estrut_regra_w,
				nr_seq_grupo_material_w	,
				nr_seq_grupo_prestador_w;
			EXIT WHEN NOT FOUND; /* apply on C01 */

				ie_grupo_mat_w := 'S';
				--Aqui nesse ponto, caso tiver grupo material na regra, então já é inválida, pois a seq material certamente estará nula
				if (nr_seq_grupo_material_w IS NOT NULL AND nr_seq_grupo_material_w::text <> '') then
					ie_grupo_mat_w := 'N';
				end if;

				ie_ok_w := 'S';
				if ((nr_seq_grupo_prestador_w IS NOT NULL AND nr_seq_grupo_prestador_w::text <> '') and ie_grupo_mat_w = 'S') then

					if (pls_obter_se_grupo_prestador(nr_seq_prestador_p, nr_seq_grupo_prestador_w) = 'S') then
						ie_ok_w	:= 'S';
					else
						ie_ok_w := 'N';
					end if;
				else
					ie_ok_w := 'S';
				end if;

				if (ie_ok_w = 'S') and (nr_seq_estrut_regra_w IS NOT NULL AND nr_seq_estrut_regra_w::text <> '') then
					ie_ok_w	:= 'N';
				end if;

				if (ie_ok_w = 'S' and ie_grupo_mat_w = 'S') then
					ie_tipo_tabela_w := ie_tipo_tabela_ww;
					pls_dados_conv_tiss_w.ie_tipo_tabela := ie_tipo_tabela_w;
					pls_dados_conv_tiss_w.ie_tipo_despesa_tiss := ie_tipo_despesa_tiss_conv_w;
				end if;

			end loop;
			close C01;
		end if;

		if (coalesce(ie_tipo_tabela_w,'X') ='X' ) then
			begin
				select	pls_obter_seq_codigo_material(null,cd_procedimento_p)
				into STRICT	nr_seq_material_w
				;
			exception
			when others then
				nr_seq_material_w := null;
			end;

			if (qt_regra_w > 0) then
				open C03;
				loop
				fetch C03 into
					ie_tipo_tabela_ww,
					ie_tipo_despesa_tiss_conv_w,
					nr_seq_estrut_regra_w,
					nr_seq_grupo_material_w	,
					nr_seq_grupo_prestador_w;
				EXIT WHEN NOT FOUND; /* apply on C03 */

					ie_grupo_mat_w := 'S';
					if (nr_seq_grupo_material_w IS NOT NULL AND nr_seq_grupo_material_w::text <> '') then

						if (nr_seq_material_w IS NOT NULL AND nr_seq_material_w::text <> '') then
							ie_grupo_mat_w :=  pls_se_grupo_preco_material(nr_seq_grupo_material_w, nr_seq_material_w);
						else
							ie_grupo_mat_w := 'N';
						end if;

					end if;

					ie_ok_w := 'S';
					--se grupo material chegar aqui como nulo, nem precisa verificar grupo prestador pois regra de conversão já é inválida
					if ((nr_seq_grupo_prestador_w IS NOT NULL AND nr_seq_grupo_prestador_w::text <> '') and ie_grupo_mat_w = 'S') then

						if (pls_obter_se_grupo_prestador(nr_seq_prestador_p, nr_seq_grupo_prestador_w) = 'S') then
							ie_ok_w	:= 'S';
						else
							ie_ok_w := 'N';
						end if;
					else
						ie_ok_w := 'S';
					end if;

					if (ie_ok_w = 'S' and ie_grupo_mat_w = 'S') then
						ie_estrut_mat_w := 'S';
						if (nr_seq_estrut_regra_w IS NOT NULL AND nr_seq_estrut_regra_w::text <> '') then
							ie_estrut_mat_w	:= pls_obter_se_mat_estrut_conv(nr_seq_material_w, nr_seq_estrut_regra_w, cd_material_p);
						end if;

						if (ie_estrut_mat_w = 'S') then
							pls_dados_conv_tiss_w.ie_tipo_tabela := ie_tipo_tabela_w;
							pls_dados_conv_tiss_w.ie_tipo_despesa_tiss := ie_tipo_despesa_tiss_conv_w;
							exit;
						end if;
					end if;

				end loop;
				close C03;
			else
				open C01;
				loop
				fetch C01 into
					ie_tipo_tabela_ww,
					ie_tipo_despesa_tiss_conv_w,
					nr_seq_estrut_regra_w,
					nr_seq_grupo_material_w	,
					nr_seq_grupo_prestador_w;
				EXIT WHEN NOT FOUND; /* apply on C01 */

					ie_grupo_mat_w := 'S';
					if (nr_seq_grupo_material_w IS NOT NULL AND nr_seq_grupo_material_w::text <> '') then

						if (nr_seq_material_w IS NOT NULL AND nr_seq_material_w::text <> '') then
							ie_grupo_mat_w :=  pls_se_grupo_preco_material(nr_seq_grupo_material_w, nr_seq_material_w);
						else
							ie_grupo_mat_w := 'N';
						end if;

					end if;

					ie_ok_w := 'S';
					--se grupo material chegar aqui como nulo, nem precisa verificar grupo prestador pois regra de conversão já é inválida
					if ((nr_seq_grupo_prestador_w IS NOT NULL AND nr_seq_grupo_prestador_w::text <> '') and ie_grupo_mat_w = 'S') then

						if (pls_obter_se_grupo_prestador(nr_seq_prestador_p, nr_seq_grupo_prestador_w) = 'S') then
							ie_ok_w	:= 'S';
						else
							ie_ok_w := 'N';
						end if;
					else
						ie_ok_w := 'S';
					end if;

					if (ie_ok_w = 'S' and ie_grupo_mat_w = 'S') then
						ie_estrut_mat_w := 'S';
						if (nr_seq_estrut_regra_w IS NOT NULL AND nr_seq_estrut_regra_w::text <> '') then
							ie_estrut_mat_w	:= pls_obter_se_mat_estrut_conv(nr_seq_material_w, nr_seq_estrut_regra_w, cd_material_p);
						end if;

						if (ie_estrut_mat_w = 'S') then
							pls_dados_conv_tiss_w.ie_tipo_tabela := ie_tipo_tabela_w;
							pls_dados_conv_tiss_w.ie_tipo_despesa_tiss := ie_tipo_despesa_tiss_conv_w;
							exit;
						end if;
					end if;

				end loop;
				close C01;
			end if;
		end if;
	end if;
elsif ((ie_tipo_despesa_mat_p IS NOT NULL AND ie_tipo_despesa_mat_p::text <> '') or (ie_tipo_despesa_tiss_p IS NOT NULL AND ie_tipo_despesa_tiss_p::text <> '') or (cd_material_p IS NOT NULL AND cd_material_p::text <> '')) then

	begin
		select	pls_obter_seq_codigo_material(null,cd_material_p)
		into STRICT	nr_seq_material_w
		;
	exception
	when others then
		nr_seq_material_w := null;
	end;

	if (qt_regra_w > 0) then
		open C03;
		loop
		fetch C03 into
			ie_tipo_tabela_w,
			ie_tipo_despesa_tiss_conv_w,
			nr_seq_estrut_regra_w,
			nr_seq_grupo_material_w	,
			nr_seq_grupo_prestador_w;
		EXIT WHEN NOT FOUND; /* apply on C03 */

			ie_grupo_mat_w := 'S';
			if (nr_seq_grupo_material_w IS NOT NULL AND nr_seq_grupo_material_w::text <> '') then

				if (nr_seq_material_w IS NOT NULL AND nr_seq_material_w::text <> '') then
					ie_grupo_mat_w :=  pls_se_grupo_preco_material(nr_seq_grupo_material_w, nr_seq_material_w);
				else
					ie_grupo_mat_w := 'N';
				end if;

			end if;

			ie_ok_w := 'S';
			--se grupo material chegar aqui como nulo, nem precisa verificar grupo prestador pois regra de conversão já é inválida
			if ((nr_seq_grupo_prestador_w IS NOT NULL AND nr_seq_grupo_prestador_w::text <> '') and ie_grupo_mat_w = 'S') then

				if (pls_obter_se_grupo_prestador(nr_seq_prestador_p, nr_seq_grupo_prestador_w) = 'S') then
					ie_ok_w	:= 'S';
				else
					ie_ok_w := 'N';
				end if;
			else
				ie_ok_w := 'S';
			end if;

			if (ie_ok_w = 'S' and ie_grupo_mat_w = 'S') then
				ie_estrut_mat_w := 'S';
				if (nr_seq_estrut_regra_w IS NOT NULL AND nr_seq_estrut_regra_w::text <> '') then
					ie_estrut_mat_w	:= pls_obter_se_mat_estrut_conv(nr_seq_material_w, nr_seq_estrut_regra_w, cd_material_p);
				end if;

				if (ie_estrut_mat_w = 'S') then
					pls_dados_conv_tiss_w.ie_tipo_tabela := ie_tipo_tabela_w;
					pls_dados_conv_tiss_w.ie_tipo_despesa_tiss := ie_tipo_despesa_tiss_conv_w;
					exit;
				end if;
			end if;

		end loop;
		close C03;
	else
		open C01;
		loop
		fetch C01 into
			ie_tipo_tabela_w,
			ie_tipo_despesa_tiss_conv_w,
			nr_seq_estrut_regra_w,
			nr_seq_grupo_material_w	,
			nr_seq_grupo_prestador_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */

			ie_grupo_mat_w := 'S';
			if (nr_seq_grupo_material_w IS NOT NULL AND nr_seq_grupo_material_w::text <> '') then

				if (nr_seq_material_w IS NOT NULL AND nr_seq_material_w::text <> '') then
					ie_grupo_mat_w :=  pls_se_grupo_preco_material(nr_seq_grupo_material_w, nr_seq_material_w);
				else
					ie_grupo_mat_w := 'N';
				end if;

			end if;

			ie_ok_w := 'S';
			--se grupo material chegar aqui como nulo, nem precisa verificar grupo prestador pois regra de conversão já é inválida
			if ((nr_seq_grupo_prestador_w IS NOT NULL AND nr_seq_grupo_prestador_w::text <> '') and ie_grupo_mat_w = 'S') then

				if (pls_obter_se_grupo_prestador(nr_seq_prestador_p, nr_seq_grupo_prestador_w) = 'S') then
					ie_ok_w	:= 'S';
				else
					ie_ok_w := 'N';
				end if;
			else
				ie_ok_w := 'S';
			end if;

			if (ie_ok_w = 'S' and ie_grupo_mat_w = 'S') then
				ie_estrut_mat_w := 'S';
				if (nr_seq_estrut_regra_w IS NOT NULL AND nr_seq_estrut_regra_w::text <> '') then
					ie_estrut_mat_w	:= pls_obter_se_mat_estrut_conv(nr_seq_material_w, nr_seq_estrut_regra_w, cd_material_p);
				end if;

				if (ie_estrut_mat_w = 'S') then
					pls_dados_conv_tiss_w.ie_tipo_tabela := ie_tipo_tabela_w;
					pls_dados_conv_tiss_w.ie_tipo_despesa_tiss := ie_tipo_despesa_tiss_conv_w;
					exit;
				end if;
			end if;

		end loop;
		close C01;

	end if;
end if;

if (coalesce(ie_tipo_tabela_w::text, '') = '' or coalesce(pls_dados_conv_tiss_w.ie_tipo_tabela::text, '') = '')	then
	ie_tipo_tabela_w	:= ie_tipo_tabela_imp_p;
	pls_dados_conv_tiss_w.ie_tipo_tabela := ie_tipo_tabela_imp_p;
end if;

return	pls_dados_conv_tiss_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_conversao_tab_tiss ( ie_tipo_tabela_imp_p text, cd_estabelecimento_p bigint, cd_procedimento_p bigint, ie_tipo_despesa_mat_p text, ie_aplicacao_regra_p text, nr_seq_prestador_p bigint, ie_tipo_despesa_tiss_p bigint, cd_material_p pls_material.cd_material_ops%type default null) FROM PUBLIC;

