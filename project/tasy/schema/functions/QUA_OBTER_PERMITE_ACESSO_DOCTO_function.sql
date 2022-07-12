-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION qua_obter_permite_acesso_docto ( nr_seq_doc_p bigint, cd_perfil_p bigint, nm_usuario_lib_p text, cd_setor_p bigint) RETURNS varchar AS $body$
DECLARE

 
ie_retorno_w			varchar(1) := 'S';
qt_reg_w				bigint;
ie_setor_lib_usuario_w		varchar(255);
ie_regra_lib_doc_conj_w		varchar(255);
cd_classif_setor_w			varchar(2);
cd_cargo_w			bigint;

C01 CURSOR FOR 
	SELECT	a.ie_atualizacao 
	from	qua_doc_lib a 
	where	a.nr_seq_doc = nr_seq_doc_p 
	and	coalesce(a.nm_usuario_lib,coalesce(nm_usuario_lib_p,'0')) = coalesce(nm_usuario_lib_p,'0') 
	and	coalesce(a.cd_perfil,coalesce(cd_perfil_p,0)) = coalesce(cd_perfil_p,0) 
	and	coalesce(a.cd_cargo,coalesce(cd_cargo_w,0)) = coalesce(cd_cargo_w,0) 
	and	coalesce(a.cd_setor_atendimento,coalesce(cd_setor_p,0)) = coalesce(cd_setor_p,0) 
	and	coalesce(a.cd_classif_setor,coalesce(cd_classif_setor_w,'0')) = coalesce(cd_classif_setor_w,'0') 
	and (coalesce(a.nr_seq_grupo_usuario::text, '') = '' 
		or exists (		SELECT	1 
				from	usuario_grupo y, 
					grupo_usuario x 
				where	x.nr_sequencia = y.nr_seq_grupo 
				and	y.nr_seq_grupo = a.nr_seq_grupo_usuario 
				and	y.nm_usuario_grupo = nm_usuario_lib_p 
				and	x.ie_situacao = 'A' 
				and	y.ie_situacao = 'A')) 
	and (coalesce(a.nr_seq_grupo_perfil::text, '') = '' 
		or exists (		select	1 
				from	grupo_perfil_item y, 
					grupo_perfil x 
				where	x.nr_sequencia = y.nr_seq_grupo_perfil 
				and	y.nr_seq_grupo_perfil = a.nr_seq_grupo_perfil 
				and	y.cd_perfil = cd_perfil_p)) 
	and (coalesce(a.nr_seq_grupo_cargo::text, '') = '' 
		or exists (		select	1 
				from	qua_cargo_agrup y, 
					qua_grupo_cargo x 
				where	x.nr_sequencia = y.nr_seq_agrup 
				and	y.nr_seq_agrup = a.nr_seq_grupo_cargo 
				and	y.cd_cargo = cd_cargo_w 
				and	x.ie_situacao = 'A')) 
	and	clock_timestamp() between coalesce(a.dt_inicio_vigencia,clock_timestamp()) and coalesce(a.dt_fim_vigencia,clock_timestamp()) 
	and	((coalesce(a.nr_seq_grupo_gerencia::text, '') = '') or exists (	select	1 
							from	gerencia_wheb x, 
								gerencia_wheb_grupo y, 
								gerencia_wheb_grupo_usu z 
							where	x.nr_sequencia = y.nr_seq_gerencia 
							and	y.nr_sequencia = z.nr_seq_grupo 
							and	z.nm_usuario_grupo = nm_usuario_lib_p 
							and	z.nr_seq_grupo = a.nr_seq_grupo_gerencia 
							and	x.ie_situacao = 'A' 
							and	y.ie_situacao = 'A')) 
	and ((coalesce(a.nr_seq_funcao::text, '') = '') or exists (select 1 
											 from 	usuario t, 
													pessoa_fisica j 
											 where t.nm_usuario = nm_usuario_lib_p 
											 and	j.cd_pessoa_fisica = t.cd_pessoa_fisica 
											 and 	j.nr_seq_funcao_pf = a.nr_seq_funcao)) 
	order by a.nm_usuario_lib desc, 
		a.cd_perfil desc, 
		a.cd_cargo desc, 
		a.cd_setor_atendimento desc, 
		a.cd_classif_setor desc, 
		a.nr_seq_grupo_usuario desc, 
		a.nr_seq_grupo_perfil desc, 
		a.nr_seq_grupo_cargo desc, 
		a.nr_sequencia, 
		a.nr_seq_funcao;
		
C02 CURSOR FOR 
	SELECT	a.ie_atualizacao 
	from	qua_doc_lib a 
	where	a.nr_seq_doc = nr_seq_doc_p 
	and	coalesce(a.nm_usuario_lib,coalesce(nm_usuario_lib_p,'0')) = coalesce(nm_usuario_lib_p,'0') 
	and	coalesce(a.cd_perfil,coalesce(cd_perfil_p,0)) = coalesce(cd_perfil_p,0) 
	and	coalesce(a.cd_cargo,coalesce(cd_cargo_w,0)) = coalesce(cd_cargo_w,0) 
	and (coalesce(a.cd_setor_atendimento::text, '') = '' 
		or obter_se_setor_usuario(a.cd_setor_atendimento,nm_usuario_lib_p) = 'S')	 
	and (coalesce(a.cd_classif_setor::text, '') = '' 
		or exists (		SELECT	1 
				from	setor_atendimento y, 
					usuario_setor_v x 
				where	y.cd_setor_atendimento = x.cd_setor_atendimento 
				and	x.nm_usuario = nm_usuario_lib_p 
				and	y.cd_classif_setor = a.cd_classif_setor))	 
	and (coalesce(a.nr_seq_grupo_usuario::text, '') = '' 
		or exists (		select	1 
				from	usuario_grupo y, 
					grupo_usuario x 
				where	x.nr_sequencia = y.nr_seq_grupo 
				and	y.nr_seq_grupo = a.nr_seq_grupo_usuario 
				and	y.nm_usuario_grupo = nm_usuario_lib_p 
				and	x.ie_situacao = 'A' 
				and	y.ie_situacao = 'A')) 
	and (coalesce(a.nr_seq_grupo_perfil::text, '') = '' 
		or exists (		select	1 
				from	grupo_perfil_item y, 
					grupo_perfil x 
				where	x.nr_sequencia = y.nr_seq_grupo_perfil 
				and	y.nr_seq_grupo_perfil = a.nr_seq_grupo_perfil 
				and	y.cd_perfil = cd_perfil_p)) 
	and (coalesce(a.nr_seq_grupo_cargo::text, '') = '' 
		or exists (		select	1 
				from	qua_cargo_agrup y, 
					qua_grupo_cargo x 
				where	x.nr_sequencia = y.nr_seq_agrup 
				and	y.nr_seq_agrup = a.nr_seq_grupo_cargo 
				and	y.cd_cargo = cd_cargo_w 
				and	x.ie_situacao = 'A')) 
	and	clock_timestamp() between coalesce(a.dt_inicio_vigencia,clock_timestamp()) and coalesce(a.dt_fim_vigencia,clock_timestamp()) 
	and	((coalesce(a.nr_seq_grupo_gerencia::text, '') = '') or exists (	select	1 
							from	gerencia_wheb x, 
								gerencia_wheb_grupo y, 
								gerencia_wheb_grupo_usu z 
							where	x.nr_sequencia = y.nr_seq_gerencia 
							and	y.nr_sequencia = z.nr_seq_grupo 
							and	z.nm_usuario_grupo = nm_usuario_lib_p 
							and	z.nr_seq_grupo = a.nr_seq_grupo_gerencia 
							and	x.ie_situacao = 'A' 
							and	y.ie_situacao = 'A')) 
	and ((coalesce(a.nr_seq_funcao::text, '') = '') or exists (select 1 
											 from 	usuario t, 
													pessoa_fisica j 
											 where t.nm_usuario = nm_usuario_lib_p 
											 and	j.cd_pessoa_fisica = t.cd_pessoa_fisica 
											 and 	j.nr_seq_funcao_pf = a.nr_seq_funcao))							 
	order by a.nm_usuario_lib desc, 
		a.cd_perfil desc, 
		a.cd_cargo desc, 
		a.cd_setor_atendimento desc, 
		a.cd_classif_setor desc, 
		a.nr_seq_grupo_usuario desc, 
		a.nr_seq_grupo_perfil desc, 
		a.nr_seq_grupo_cargo desc, 
		a.nr_sequencia, 
		a.nr_seq_funcao;


BEGIN 
ie_setor_lib_usuario_w := obter_param_usuario(4000, 112, cd_perfil_p, nm_usuario_lib_p, wheb_usuario_pck.get_cd_estabelecimento, ie_setor_lib_usuario_w);
ie_regra_lib_doc_conj_w := obter_param_usuario(4000, 113, cd_perfil_p, nm_usuario_lib_p, wheb_usuario_pck.get_cd_estabelecimento, ie_regra_lib_doc_conj_w);
 
select	count(*) 
into STRICT	qt_reg_w 
from	qua_doc_lib 
where	nr_seq_doc = nr_seq_doc_p 
and	clock_timestamp() between coalesce(dt_inicio_vigencia,clock_timestamp()) and coalesce(dt_fim_vigencia,clock_timestamp());
 
if (qt_reg_w > 0) then 
	begin 
	select	substr(obter_classif_setor(cd_setor_p),1,2), 
		substr(obter_dados_usuario_opcao(nm_usuario_lib_p,'R'),1,10) 
	into STRICT	cd_classif_setor_w, 
		cd_cargo_w 
	;
	 
	if (coalesce(ie_regra_lib_doc_conj_w,'N') = 'N') then 
		begin 
		 
		begin 
		select	ie_atualizacao 
		into STRICT	ie_retorno_w 
		from	qua_doc_lib 
		where	nr_seq_doc = nr_seq_doc_p 
		and	nm_usuario_lib = nm_usuario_lib_p 
		and	clock_timestamp() between coalesce(dt_inicio_vigencia,clock_timestamp()) and coalesce(dt_fim_vigencia,clock_timestamp())  LIMIT 1;
		exception 
		when others then 
			ie_retorno_w := 'X';
		end;
		 
		if (ie_retorno_w = 'X') then 
			begin 
			 
			begin 
			select	ie_atualizacao 
			into STRICT	ie_retorno_w 
			from	qua_doc_lib 
			where	nr_seq_doc = nr_seq_doc_p 
			and	cd_perfil = cd_perfil_p 
			and	clock_timestamp() between coalesce(dt_inicio_vigencia,clock_timestamp()) and coalesce(dt_fim_vigencia,clock_timestamp())  LIMIT 1;
			exception 
			when others then 
				ie_retorno_w := 'X';
			end;
			 
			if (ie_retorno_w = 'X') then 
				begin 
				 
				begin 
				select	ie_atualizacao 
				into STRICT	ie_retorno_w 
				from	qua_doc_lib 
				where	nr_seq_doc = nr_seq_doc_p 
				and	cd_cargo = cd_cargo_w 
				and	clock_timestamp() between coalesce(dt_inicio_vigencia,clock_timestamp()) and coalesce(dt_fim_vigencia,clock_timestamp())  LIMIT 1;
				exception 
				when others then 
					ie_retorno_w := 'X';
				end;
				 
				if (ie_retorno_w = 'X') then 
					begin					 
					if (coalesce(ie_setor_lib_usuario_w,'S') = 'N') then 
						begin 
						 
						begin 
						select	ie_atualizacao 
						into STRICT	ie_retorno_w 
						from	qua_doc_lib 
						where	nr_seq_doc = nr_seq_doc_p 
						and	cd_setor_atendimento = cd_setor_p 
						and	clock_timestamp() between coalesce(dt_inicio_vigencia,clock_timestamp()) and coalesce(dt_fim_vigencia,clock_timestamp())  LIMIT 1;
						exception 
						when others then 
							ie_retorno_w := 'X';
						end;
						 
						if (ie_retorno_w = 'X') then 
							begin 
							select	ie_atualizacao 
							into STRICT	ie_retorno_w 
							from	qua_doc_lib 
							where	nr_seq_doc = nr_seq_doc_p 
							and	cd_classif_setor = cd_classif_setor_w 
							and	clock_timestamp() between coalesce(dt_inicio_vigencia,clock_timestamp()) and coalesce(dt_fim_vigencia,clock_timestamp())  LIMIT 1;
							exception 
							when others then 
								ie_retorno_w := 'X';
							end;
						end if;
						end;
					else 
						begin 
						 
						begin 
						select	ie_atualizacao 
						into STRICT	ie_retorno_w 
						from	qua_doc_lib 
						where	nr_seq_doc = nr_seq_doc_p 
						and	(cd_setor_atendimento IS NOT NULL AND cd_setor_atendimento::text <> '') 
						and	obter_se_setor_usuario(cd_setor_atendimento,nm_usuario_lib_p) = 'S' 
						and	clock_timestamp() between coalesce(dt_inicio_vigencia,clock_timestamp()) and coalesce(dt_fim_vigencia,clock_timestamp())  LIMIT 1;
						exception 
						when others then 
							ie_retorno_w := 'X';
						end;
 
						if (ie_retorno_w = 'X') then 
							begin 
							select	a.ie_atualizacao 
							into STRICT	ie_retorno_w 
							from	qua_doc_lib a 
							where	a.nr_seq_doc = nr_seq_doc_p 
							and	(a.cd_classif_setor IS NOT NULL AND a.cd_classif_setor::text <> '') 
							and	clock_timestamp() between coalesce(a.dt_inicio_vigencia,clock_timestamp()) and coalesce(a.dt_fim_vigencia,clock_timestamp()) 
							and exists (	SELECT	1 
									from	setor_atendimento y, 
										usuario_setor_v x 
									where	y.cd_setor_atendimento = x.cd_setor_atendimento 
									and	x.nm_usuario = nm_usuario_lib_p 
									and	y.cd_classif_setor = a.cd_classif_setor)  LIMIT 1;
							exception 
							when others then 
								ie_retorno_w := 'X';
							end;
						end if;
						end;
					end if;
					 
					if (ie_retorno_w = 'X') then 
						begin 
						 
						begin 
						select	a.ie_atualizacao 
						into STRICT	ie_retorno_w 
						from	qua_doc_lib a 
						where	a.nr_seq_doc = nr_seq_doc_p 
						and	(a.nr_seq_grupo_usuario IS NOT NULL AND a.nr_seq_grupo_usuario::text <> '') 
						and	clock_timestamp() between coalesce(a.dt_inicio_vigencia,clock_timestamp()) and coalesce(a.dt_fim_vigencia,clock_timestamp()) 
						and exists (	SELECT	1 
								from	usuario_grupo y, 
									grupo_usuario x 
								where	x.nr_sequencia = y.nr_seq_grupo 
								and	y.nr_seq_grupo = a.nr_seq_grupo_usuario 
								and	y.nm_usuario_grupo = nm_usuario_lib_p 
								and	x.ie_situacao = 'A' 
								and	y.ie_situacao = 'A')  LIMIT 1;
						exception 
						when others then 
							ie_retorno_w := 'X';
						end;
						 
						if (ie_retorno_w = 'X') then 
							begin 
							 
							begin 
							select	a.ie_atualizacao 
							into STRICT	ie_retorno_w 
							from	qua_doc_lib a 
							where	a.nr_seq_doc = nr_seq_doc_p 
							and	(a.nr_seq_grupo_perfil IS NOT NULL AND a.nr_seq_grupo_perfil::text <> '') 
							and	clock_timestamp() between coalesce(a.dt_inicio_vigencia,clock_timestamp()) and coalesce(a.dt_fim_vigencia,clock_timestamp()) 
							and exists (	SELECT	1 
									from	grupo_perfil_item y, 
										grupo_perfil x 
									where	x.nr_sequencia = y.nr_seq_grupo_perfil 
									and	y.nr_seq_grupo_perfil = a.nr_seq_grupo_perfil 
									and	y.cd_perfil = cd_perfil_p)  LIMIT 1;
							exception 
							when others then 
								ie_retorno_w := 'X';
							end;
							 
							if (ie_retorno_w = 'X') then 
								begin 
								 
								begin 
								select	a.ie_atualizacao 
								into STRICT	ie_retorno_w 
								from	qua_doc_lib a 
								where	a.nr_seq_doc = nr_seq_doc_p 
								and	(a.nr_seq_grupo_cargo IS NOT NULL AND a.nr_seq_grupo_cargo::text <> '') 
								and	clock_timestamp() between coalesce(a.dt_inicio_vigencia,clock_timestamp()) and coalesce(a.dt_fim_vigencia,clock_timestamp()) 
								and exists (	SELECT	1 
										from	qua_cargo_agrup y, 
											qua_grupo_cargo x 
										where	x.nr_sequencia = y.nr_seq_agrup 
										and	y.nr_seq_agrup = a.nr_seq_grupo_cargo 
										and	y.cd_cargo = cd_cargo_w 
										and	x.ie_situacao = 'A')  LIMIT 1;
								exception 
								when others then 
									ie_retorno_w := 'X';
								end;
								 
								if (ie_retorno_w = 'X') then --aqui 
									begin	 
									begin 
									select	a.ie_atualizacao 
									into STRICT	ie_retorno_w 
									from	qua_doc_lib a 
									where	a.nr_seq_doc = nr_seq_doc_p 
									and	clock_timestamp() between coalesce(a.dt_inicio_vigencia,clock_timestamp()) and coalesce(a.dt_fim_vigencia,clock_timestamp()) 
									and exists (	SELECT	1 
											from	gerencia_wheb x, 
												gerencia_wheb_grupo y, 
												gerencia_wheb_grupo_usu z 
											where	x.nr_sequencia = y.nr_seq_gerencia 
											and	y.nr_sequencia = z.nr_seq_grupo 
											and	z.nm_usuario_grupo = nm_usuario_lib_p 
											and	z.nr_seq_grupo = a.nr_seq_grupo_gerencia 
											and	x.ie_situacao = 'A' 
											and	y.ie_situacao = 'A'	)  LIMIT 1;
									exception 
									when others then 
										ie_retorno_w := 'X';
									end;
									end;
								end if;
								 
								if (ie_retorno_w = 'X') then 
									begin 
									select	ie_atualizacao 
									into STRICT	ie_retorno_w 
									from	qua_doc_lib 
									where	nr_seq_doc = nr_seq_doc_p 
									and	coalesce(cd_perfil::text, '') = '' 
									and	coalesce(cd_cargo::text, '') = '' 
									and	coalesce(nm_usuario_lib::text, '') = '' 
									and	coalesce(cd_setor_atendimento::text, '') = '' 
									and	coalesce(cd_classif_setor::text, '') = '' 
									and	coalesce(nr_seq_grupo_cargo::text, '') = '' 
									and 	coalesce(nr_seq_grupo_usuario::text, '') = '' 
									and	coalesce(nr_seq_grupo_perfil::text, '') = '' 
									and	coalesce(nr_seq_grupo_gerencia::text, '') = '' 
									and coalesce(nr_seq_funcao::text, '') = '' 
									and	clock_timestamp() between coalesce(dt_inicio_vigencia,clock_timestamp()) and coalesce(dt_fim_vigencia,clock_timestamp())  LIMIT 1;
									exception 
									when others then 
										ie_retorno_w := 'N';
									end;
								end if;
								end;
							end if;	
							end;
						end if;
						end;
					end if;
					end;
				end if;
				end;
			end if;
			end;
		end if;
		end;
	else 
		begin 
		ie_retorno_w := 'N';
		 
		if (coalesce(ie_setor_lib_usuario_w,'S') = 'N') then 
			begin			 
			open C01;
			loop 
			fetch C01 into	 
				ie_retorno_w;
			EXIT WHEN NOT FOUND; /* apply on C01 */
			end loop;
			close C01;
			end;
		else 
			begin 
			open C02;
			loop 
			fetch C02 into	 
				ie_retorno_w;
			EXIT WHEN NOT FOUND; /* apply on C02 */
			end loop;
			close C02;
			end;
		end if;
		end;
	end if;
	end;
end if;
 
return ie_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION qua_obter_permite_acesso_docto ( nr_seq_doc_p bigint, cd_perfil_p bigint, nm_usuario_lib_p text, cd_setor_p bigint) FROM PUBLIC;
