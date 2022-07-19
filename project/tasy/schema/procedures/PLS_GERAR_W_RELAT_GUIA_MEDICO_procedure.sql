-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_w_relat_guia_medico ( nr_seq_prestador_p bigint, cd_medico_p text, cd_item_p bigint, ie_origem_proced_p bigint, cd_municipio_ibge_p text, cd_especialidade_p bigint, ie_proc_especialidade_p text, nr_seq_tipo_prestador_p bigint, ie_tipo_p bigint, ie_origem_p text, nr_seq_tipo_guia_p text, nr_seq_plano_p bigint, sg_estado_p text, nr_seq_bairro_p bigint, ie_filtro_portal_p text, nr_seq_regiao_p text, ie_sem_tipo_guia_p text, ie_instituicao_acred_p text, ie_nivel_acreditacao_p bigint, cd_prestador_p text, ie_cd_prestador_p text, nm_prestador_p text, nm_medico_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

 
ds_campo_w			varchar(4000);
ds_especialidade_w		varchar(255);
cd_medico_w			varchar(10);
nr_seq_registro_w		bigint;
nr_seq_area_atuacao_w		bigint;
nr_seq_prestador_w		bigint;
cd_especialidade_w		integer;
qt_reg_espec_w			bigint := 0;
qt_reg_area_w			bigint := 0;
qt_registro_w			bigint := 0;
qt_linhas_w			bigint := 0;
ds_area_w			varchar(4000);
ds_complemento_w		varchar(255);

C01 CURSOR FOR 
	SELECT	distinct substr(a.ds_especialidade,1,40), 
		a.cd_especialidade 
	from	especialidade_medica		a 
	where	exists (	SELECT	1 
				from	w_pls_guia_medico 		z, 
					pls_prestador_med_espec		y, 
					pls_prestador_medico		x 
				where	x.cd_medico = z.cd_medico 
				and	x.cd_medico = y.cd_pessoa_fisica 
				and	y.cd_especialidade = a.cd_especialidade 
				and	z.cd_municipio_ibge = coalesce(cd_municipio_ibge_p,z.cd_municipio_ibge) 
				and	clock_timestamp() between trunc(coalesce(y.dt_inicio_vigencia, clock_timestamp())) and fim_dia(coalesce(y.dt_fim_vigencia, clock_timestamp())) 
				
union
 
				select	1 
				from	w_pls_guia_medico 	z, 
					pls_prestador_med_espec	y, 
					pls_prestador		x 
				where	z.cd_medico 		= x.cd_pessoa_fisica 
				and	x.cd_pessoa_fisica 	= y.cd_pessoa_fisica 
				and	(x.cd_pessoa_fisica IS NOT NULL AND x.cd_pessoa_fisica::text <> '') 
				and	y.cd_especialidade = a.cd_especialidade 
				and	z.cd_municipio_ibge = coalesce(cd_municipio_ibge_p,z.cd_municipio_ibge) 
				and	clock_timestamp() between trunc(coalesce(y.dt_inicio_vigencia, clock_timestamp())) and fim_dia(coalesce(y.dt_fim_vigencia, clock_timestamp())));
				
C02 CURSOR FOR 
	SELECT	distinct 
		coalesce(substr(obter_nome_pf(a.cd_medico),1,80),a.cd_medico) ds_campo, 
		a.cd_medico, 
		a.nr_seq_prestador 
	from	sus_municipio	b, 
		w_pls_guia_medico	a 
	where	a.cd_municipio_ibge	= b.cd_municipio_ibge 
	and	a.cd_municipio_ibge = coalesce(cd_municipio_ibge_p,a.cd_municipio_ibge) 
	and	a.cd_medico		in (SELECT	x.cd_medico 
					from	w_pls_guia_medico 		z, 
						pls_prestador_med_espec		y, 
						pls_prestador_medico		x 
					where	x.cd_medico = z.cd_medico 
					and	x.cd_medico = y.cd_pessoa_fisica 
					and	coalesce(y.nr_seq_area_atuacao::text, '') = '' 
					and	y.cd_especialidade = cd_especialidade_w 
					and	z.cd_municipio_ibge = coalesce(cd_municipio_ibge_p,z.cd_municipio_ibge) 
					and	clock_timestamp() between trunc(coalesce(y.dt_inicio_vigencia, clock_timestamp())) and fim_dia(coalesce(y.dt_fim_vigencia, clock_timestamp())) 
					
union
 
					select	x.cd_pessoa_fisica 
					from	w_pls_guia_medico 	z, 
						pls_prestador_med_espec	y, 
						pls_prestador		x 
					where	z.cd_medico 		= x.cd_pessoa_fisica 
					and	x.cd_pessoa_fisica 	= y.cd_pessoa_fisica 
					and	(x.cd_pessoa_fisica IS NOT NULL AND x.cd_pessoa_fisica::text <> '') 
					and	coalesce(y.nr_seq_area_atuacao::text, '') = '' 
					and	y.cd_especialidade = cd_especialidade_w 
					and	z.cd_municipio_ibge = coalesce(cd_municipio_ibge_p,z.cd_municipio_ibge) 
					and	clock_timestamp() between trunc(coalesce(y.dt_inicio_vigencia, clock_timestamp())) and fim_dia(coalesce(y.dt_fim_vigencia, clock_timestamp()))) 
	order by 1;
	
C03 CURSOR FOR 
	SELECT	distinct 
		trim(both substr(a.ds_endereco,1,35)) || CASE WHEN coalesce(a.ds_endereco::text, '') = '' THEN ''  ELSE chr(13) END  || 
		CASE WHEN coalesce(a.nr_endereco::text, '') = '' THEN ''  ELSE 'Nº ' END  || a.nr_endereco || CASE WHEN coalesce(a.nr_endereco::text, '') = '' THEN ''  ELSE chr(13) END  || 
		trim(both substr(a.ds_complemento,1,35)) || CASE WHEN coalesce(a.ds_complemento::text, '') = '' THEN ''  ELSE chr(13) END  || 
		trim(both substr(a.ds_bairro,1,35)) || CASE WHEN coalesce(a.ds_bairro::text, '') = '' THEN ''  ELSE chr(13) END  || 
		trim(both substr(obter_desc_municipio_ibge(a.cd_municipio_ibge),1,80)) || ' - ' || b.ds_unidade_federacao || CASE WHEN coalesce(a.cd_municipio_ibge::text, '') = '' THEN ''  ELSE chr(13) END  || 
		a.nr_telefone_prest || CASE WHEN coalesce(a.nr_telefone_prest::text, '') = '' THEN ''  ELSE chr(13) END  ds_campo, 
		(CASE WHEN coalesce(trim(both a.ds_endereco)::text, '') = '' THEN 0  ELSE 1 END  + CASE WHEN coalesce(trim(both a.nr_endereco)::text, '') = '' THEN 0  ELSE 1 END  + CASE WHEN coalesce(trim(both a.ds_complemento)::text, '') = '' THEN 0  ELSE 1 END  + 
		CASE WHEN coalesce(trim(both a.ds_bairro)::text, '') = '' THEN 0  ELSE 1 END  + CASE WHEN coalesce(trim(both a.cd_municipio_ibge)::text, '') = '' THEN 0  ELSE 1 END  + CASE WHEN coalesce(trim(both a.nr_telefone_prest)::text, '') = '' THEN 0  ELSE 1 END ) qt_linhas, 
		trim(both a.ds_complemento) 
	from	sus_municipio	b, 
		w_pls_guia_medico	a 
	where	a.cd_municipio_ibge	= b.cd_municipio_ibge 
	and	a.cd_medico		= cd_medico_w 
	and	a.nr_seq_prestador	= nr_seq_prestador_w 
	and	a.cd_municipio_ibge = coalesce(cd_municipio_ibge_p,a.cd_municipio_ibge) 
	and	a.cd_medico		IN (SELECT	x.cd_medico 
					from	w_pls_guia_medico 		z, 
						pls_prestador_med_espec		y, 
						pls_prestador_medico		x 
					where	x.cd_medico = z.cd_medico 
					and	x.cd_medico = y.cd_pessoa_fisica 
					and	coalesce(y.nr_seq_area_atuacao::text, '') = '' 
					and	y.cd_especialidade = cd_especialidade_w				 
					and	z.cd_municipio_ibge = coalesce(cd_municipio_ibge_p,z.cd_municipio_ibge) 
					and	clock_timestamp() between trunc(coalesce(y.dt_inicio_vigencia, clock_timestamp())) and fim_dia(coalesce(y.dt_fim_vigencia, clock_timestamp())) 
					
union
 
					select	x.cd_pessoa_fisica 
					from	w_pls_guia_medico 	z, 
						pls_prestador_med_espec	y, 
						pls_prestador		x 
					where	z.cd_medico 		= x.cd_pessoa_fisica 
					and	x.cd_pessoa_fisica 	= y.cd_pessoa_fisica 
					and	(x.cd_pessoa_fisica IS NOT NULL AND x.cd_pessoa_fisica::text <> '') 
					and	coalesce(y.nr_seq_area_atuacao::text, '') = '' 
					and	y.cd_especialidade = cd_especialidade_w 
					and	z.cd_municipio_ibge = coalesce(cd_municipio_ibge_p,z.cd_municipio_ibge) 
					and	clock_timestamp() between trunc(coalesce(y.dt_inicio_vigencia, clock_timestamp())) and fim_dia(coalesce(y.dt_fim_vigencia, clock_timestamp())))  
	order by 1 LIMIT 1;
	
C04 CURSOR FOR 
	SELECT	distinct 	 
		b.nr_seq_area_atuacao, 
		substr(obter_descricao_padrao_pk('AREA_ATUACAO_MEDICA','DS_AREA_ATUACAO','NR_SEQUENCIA',b.nr_seq_area_atuacao),1,255) ds_area_atuacao 
	from	pls_prestador_med_espec		b 
	where	b.cd_especialidade		= cd_especialidade_w 
	and	(b.nr_seq_area_atuacao IS NOT NULL AND b.nr_seq_area_atuacao::text <> '') 
	--and	b.nr_seq_prestador is null 
	and	clock_timestamp() between trunc(coalesce(b.dt_inicio_vigencia, clock_timestamp())) and fim_dia(coalesce(b.dt_fim_vigencia, clock_timestamp())) 
	and	exists (	SELECT	1 
				from	w_pls_guia_medico x, 
					pls_prestador_medico		a 
				where	x.cd_medico = a.cd_medico 
				and	a.cd_medico	= b.cd_pessoa_fisica 
				and	a.nr_seq_prestador	= x.nr_seq_prestador 
				and	x.cd_municipio_ibge = coalesce(cd_municipio_ibge_p,x.cd_municipio_ibge)) 
	
union
 
	select	distinct b.nr_seq_area_atuacao, 
		substr(obter_descricao_padrao_pk('AREA_ATUACAO_MEDICA','DS_AREA_ATUACAO','NR_SEQUENCIA',b.nr_seq_area_atuacao),1,255) ds_area_atuacao 
	from	pls_prestador_med_espec		b 
	where	b.cd_especialidade		= cd_especialidade_w 
	and	clock_timestamp() between trunc(coalesce(b.dt_inicio_vigencia, clock_timestamp())) and fim_dia(coalesce(b.dt_fim_vigencia, clock_timestamp())) 
	and	coalesce(b.cd_pessoa_fisica::text, '') = '' 
	and	(b.nr_seq_area_atuacao IS NOT NULL AND b.nr_seq_area_atuacao::text <> '') 
	and	exists (	select	1 
				from	w_pls_guia_medico x, 
					pls_prestador			a 
				where	x.cd_medico = a.cd_pessoa_fisica 
				and	a.nr_sequencia = b.nr_seq_prestador 
				and	(a.cd_pessoa_fisica IS NOT NULL AND a.cd_pessoa_fisica::text <> '') 
				and	a.nr_sequencia	= x.nr_seq_prestador 
				and	x.cd_municipio_ibge = coalesce(cd_municipio_ibge_p,x.cd_municipio_ibge));
				
C05 CURSOR FOR 
	SELECT	distinct 	 
		a.cd_medico, 
		substr(obter_nome_pf(a.cd_medico),1,80) ds_medico, 
		a.nr_seq_prestador 
	from	pls_prestador_med_espec		b, 
		pls_prestador_medico		a 
	where	a.cd_medico			= b.cd_pessoa_fisica 
	and	b.cd_especialidade		= cd_especialidade_w 
	and	b.nr_seq_area_atuacao 		= nr_seq_area_atuacao_w 
	and	clock_timestamp() between trunc(coalesce(b.dt_inicio_vigencia, clock_timestamp())) and fim_dia(coalesce(b.dt_fim_vigencia, clock_timestamp())) 
	and	exists (	SELECT	1 
				from	w_pls_guia_medico x 
				where	x.cd_medico = a.cd_medico 
				and	a.nr_seq_prestador	= x.nr_seq_prestador 
				and	x.cd_municipio_ibge = coalesce(cd_municipio_ibge_p,x.cd_municipio_ibge)) 
	
union all
 
	select	distinct 
		a.cd_pessoa_fisica, 
		substr(obter_nome_pf(a.cd_pessoa_fisica),1,80) ds_medico, 
		a.nr_sequencia 
	from	pls_prestador_med_espec		b, 
		pls_prestador			a 
	where	a.cd_pessoa_fisica		= b.cd_pessoa_fisica 
	and	b.cd_especialidade		= cd_especialidade_w 
	and	b.nr_seq_area_atuacao 		= nr_seq_area_atuacao_w 
	and	clock_timestamp() between trunc(coalesce(b.dt_inicio_vigencia, clock_timestamp())) and fim_dia(coalesce(b.dt_fim_vigencia, clock_timestamp())) 
	and	(a.cd_pessoa_fisica IS NOT NULL AND a.cd_pessoa_fisica::text <> '') 
	and	exists (	select	1 
				from	w_pls_guia_medico x 
				where	x.cd_medico = a.cd_pessoa_fisica 
				and	a.nr_sequencia	= x.nr_sequencia 
				and	x.cd_municipio_ibge = coalesce(cd_municipio_ibge_p,x.cd_municipio_ibge));
				
				 
C06 CURSOR FOR 
	SELECT	distinct 
		trim(both substr(a.ds_endereco,1,35)) || CASE WHEN coalesce(a.ds_endereco::text, '') = '' THEN ''  ELSE chr(13) END  || 
		CASE WHEN coalesce(a.nr_endereco::text, '') = '' THEN ''  ELSE 'Nº ' END  || a.nr_endereco || CASE WHEN coalesce(a.nr_endereco::text, '') = '' THEN ''  ELSE chr(13) END  || 
		trim(both substr(a.ds_complemento,1,35)) || CASE WHEN coalesce(a.ds_complemento::text, '') = '' THEN ''  ELSE chr(13) END  || 
		trim(both substr(a.ds_bairro,1,35)) || CASE WHEN coalesce(a.ds_bairro::text, '') = '' THEN ''  ELSE chr(13) END  || 
		trim(both substr(obter_desc_municipio_ibge(a.cd_municipio_ibge),1,80)) || ' - ' || b.ds_unidade_federacao || CASE WHEN coalesce(a.cd_municipio_ibge::text, '') = '' THEN ''  ELSE chr(13) END  || 
		a.nr_telefone_prest || CASE WHEN coalesce(a.nr_telefone_prest::text, '') = '' THEN ''  ELSE chr(13) END  ds_campo, 
		(CASE WHEN coalesce(trim(both a.ds_endereco)::text, '') = '' THEN 0  ELSE 1 END  + CASE WHEN coalesce(trim(both a.nr_endereco)::text, '') = '' THEN 0  ELSE 1 END  + CASE WHEN coalesce(trim(both a.ds_complemento)::text, '') = '' THEN 0  ELSE 1 END  + 
		CASE WHEN coalesce(trim(both a.ds_bairro)::text, '') = '' THEN 0  ELSE 1 END  + CASE WHEN coalesce(trim(both a.cd_municipio_ibge)::text, '') = '' THEN 0  ELSE 1 END  + CASE WHEN coalesce(trim(both a.nr_telefone_prest)::text, '') = '' THEN 0  ELSE 1 END ) qt_linhas, 
		trim(both a.ds_complemento) 
	from	sus_municipio	b, 
		w_pls_guia_medico	a 
	where	a.cd_municipio_ibge	= b.cd_municipio_ibge 
	and	a.cd_medico		= cd_medico_w 
	and	a.nr_seq_prestador	= nr_seq_prestador_w 
	and	(nr_seq_area_atuacao_w IS NOT NULL AND nr_seq_area_atuacao_w::text <> '')  
	order by 1 LIMIT 1;


BEGIN 
delete	from w_relat_guia_medico 
where	nm_usuario	= nm_usuario_p;
 
CALL pls_gerar_guia_medico(nr_seq_prestador_p,cd_medico_p,cd_item_p,ie_origem_proced_p,cd_municipio_ibge_p, 
				cd_especialidade_p,ie_proc_especialidade_p,nr_seq_tipo_prestador_p,ie_tipo_p, 
				ie_origem_p,nr_seq_tipo_guia_p,nr_seq_plano_p,sg_estado_p, 
				nr_seq_bairro_p,ie_filtro_portal_p,nr_seq_regiao_p,ie_sem_tipo_guia_p, 
				ie_instituicao_acred_p,ie_nivel_acreditacao_p,cd_prestador_p, 
				ie_cd_prestador_p,nm_prestador_p,nm_medico_p,nm_usuario_p,null,cd_estabelecimento_p,null,null,null, 'N',null, null, null, null);
	 
open C01;
loop 
fetch C01 into	 
	ds_especialidade_w, 
	cd_especialidade_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	qt_reg_espec_w	:= 2;
	 
	-- MEDICOS 
	open C02;
	loop 
	fetch C02 into	 
		ds_campo_w, 
		cd_medico_w, 
		nr_seq_prestador_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin		 
		if (ds_especialidade_w IS NOT NULL AND ds_especialidade_w::text <> '') then 
			ds_campo_w		:= 'Espec.: ' || ds_especialidade_w || chr(13) || '' || chr(13) || ds_campo_w;
			ds_especialidade_w	:= null;
		end if;
		 
		qt_registro_w := 1 + qt_reg_espec_w;
		qt_reg_espec_w := 0;
		 
		select	nextval('w_relat_guia_medico_seq') 
		into STRICT	nr_seq_registro_w 
		;
		 
		insert into w_relat_guia_medico(nr_sequencia, 
			nm_usuario, 
			dt_atualizacao, 
			nm_usuario_nrec, 
			dt_atualizacao_nrec, 
			ds_conteudo) 
		values (nr_seq_registro_w, 
			nm_usuario_p, 
			clock_timestamp(), 
			nm_usuario_p, 
			clock_timestamp(), 
			ds_campo_w || chr(13));
			 
		-- ENDEREÇOS 
		open C03;
		loop 
		fetch C03 into	 
			ds_campo_w, 
			qt_linhas_w, 
			ds_complemento_w;
		EXIT WHEN NOT FOUND; /* apply on C03 */
			begin			 
			qt_registro_w := qt_linhas_w + qt_registro_w;
			 
			update	w_relat_guia_medico 
			set	ds_conteudo	= ds_conteudo || ds_campo_w || chr(13) 
			where	nr_sequencia	= nr_seq_registro_w;
			 
			while(qt_registro_w < 9) loop 
				update	w_relat_guia_medico 
				set	ds_conteudo	= ds_conteudo || ' ' || chr(13) 
				where	nr_sequencia	= nr_seq_registro_w;
				 
				qt_registro_w := qt_registro_w + 1;
			end loop;
			end;
		end loop;
		close C03;
 
		end;
	end loop;
	close C02;
	 
	-- AREAS DE ATUAÇAO 
	open C04;
	loop 
	fetch C04 into	 
		nr_seq_area_atuacao_w, 
		ds_area_w;
	EXIT WHEN NOT FOUND; /* apply on C04 */
		begin	 
		qt_reg_area_w := 2;
		 
		-- MEDICOS 
		open C05;
		loop 
		fetch C05 into	 
			cd_medico_w, 
			ds_campo_w, 
			nr_seq_prestador_w;
		EXIT WHEN NOT FOUND; /* apply on C05 */
			begin			 
			 
			if (ds_especialidade_w IS NOT NULL AND ds_especialidade_w::text <> '') and (coalesce(ds_area_w::text, '') = '') then 
				ds_campo_w	:= 'Espec.: ' || ds_especialidade_w || chr(13) || '' || chr(13) || ds_campo_w;
			 
			elsif (ds_especialidade_w IS NOT NULL AND ds_especialidade_w::text <> '') and (ds_area_w IS NOT NULL AND ds_area_w::text <> '') then 
				ds_campo_w	:= 'Espec.: ' || ds_especialidade_w || chr(13) || 
							'Área: ' || ds_area_w || chr(13) || ds_campo_w;
			 
			elsif (coalesce(ds_especialidade_w::text, '') = '') and (ds_area_w IS NOT NULL AND ds_area_w::text <> '') then 
				ds_campo_w	:= 'Área: ' || ds_area_w || chr(13) || ' ' || chr(13) || ds_campo_w;
			end if;
			 
			ds_especialidade_w := null;
			ds_area_w := null;
			 
			qt_registro_w	:= 1 + qt_reg_espec_w + qt_reg_area_w;
			qt_reg_espec_w	:= 0;
			qt_reg_area_w	:= 0;
			 
			select	nextval('w_relat_guia_medico_seq') 
			into STRICT	nr_seq_registro_w 
			;
			 
			insert into w_relat_guia_medico(nr_sequencia, 
				nm_usuario, 
				dt_atualizacao, 
				nm_usuario_nrec, 
				dt_atualizacao_nrec, 
				ds_conteudo) 
			values (nr_seq_registro_w, 
				nm_usuario_p, 
				clock_timestamp(), 
				nm_usuario_p, 
				clock_timestamp(), 
				ds_campo_w || chr(13));
			 
			-- ENDERECOS 
			open C06;
			loop 
			fetch C06 into	 
				ds_campo_w, 
				qt_linhas_w, 
				ds_complemento_w;
			EXIT WHEN NOT FOUND; /* apply on C06 */
				begin				 
				qt_registro_w := qt_linhas_w + qt_registro_w;
				 
				update	w_relat_guia_medico 
				set	ds_conteudo	= ds_conteudo || ds_campo_w || chr(13) 
				where	nr_sequencia	= nr_seq_registro_w;
				 
				while(qt_registro_w < 9) loop 
					update	w_relat_guia_medico 
					set	ds_conteudo	= ds_conteudo || ' ' || chr(13) 
					where	nr_sequencia	= nr_seq_registro_w;
					 
					qt_registro_w := qt_registro_w + 1;
				end loop;
				end;
			end loop;
			close C06;
			 
			end;
		end loop;
		close C05;	
		 
		end;
	end loop;
	close C04;
	 
	end;
end loop;
close C01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_w_relat_guia_medico ( nr_seq_prestador_p bigint, cd_medico_p text, cd_item_p bigint, ie_origem_proced_p bigint, cd_municipio_ibge_p text, cd_especialidade_p bigint, ie_proc_especialidade_p text, nr_seq_tipo_prestador_p bigint, ie_tipo_p bigint, ie_origem_p text, nr_seq_tipo_guia_p text, nr_seq_plano_p bigint, sg_estado_p text, nr_seq_bairro_p bigint, ie_filtro_portal_p text, nr_seq_regiao_p text, ie_sem_tipo_guia_p text, ie_instituicao_acred_p text, ie_nivel_acreditacao_p bigint, cd_prestador_p text, ie_cd_prestador_p text, nm_prestador_p text, nm_medico_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

