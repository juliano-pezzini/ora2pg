-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gpi_enviar_alerta_etapa ( cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
cd_estabelecimento_w		gpi_projeto.cd_estabelecimento%type;

cd_pessoa_fisica_w		varchar(10);
qt_dia_w			bigint;
nr_seq_equipe_w			bigint;
nm_usuario_dest_w		varchar(4000);
nr_seq_cronograma_w		bigint;
ie_repetir_w			varchar(1);
nr_seq_etapa_w			bigint;
cd_pessoa_fisica_equipe_w	varchar(10);
nm_pessoa_fisica_w		varchar(4000);
nm_projeto_w			gpi_projeto.nm_projeto%type;
ds_titulo_w			gpi_cronograma.ds_titulo%type;
nm_etapa_w			varchar(100);
dt_inicio_prev_w		timestamp;
dt_fim_prev_w			timestamp;
ds_texto_w			varchar(4000);
ie_regra_w			varchar(15);
ds_titulo_regra_w		varchar(255);

/*CRONOGRAMAS QUE TEM REGRA*/
		 
c01 CURSOR FOR 
SELECT	a.nr_sequencia nr_seq_cronograma, 
	b.nm_projeto, 
	a.ds_titulo, 
	c.cd_estabelecimento 
from	estabelecimento c, 
	gpi_cronograma a, 
	gpi_projeto b 
where	b.nr_sequencia		= a.nr_seq_projeto 
and	c.cd_estabelecimento	= b.cd_estabelecimento 
and (b.cd_estabelecimento	= cd_estabelecimento_p or cd_estabelecimento_p = 0) 
and	c.ie_situacao		= 'A' 
and	exists (	SELECT	1 
			from 	gpi_cron_regra_aviso y 
			where	y.nr_seq_cronograma 	= a.nr_sequencia);

vet01	C01%RowType;

/*REGRA DO CRONOGRAMA*/
 
c02 CURSOR FOR 
SELECT	a.nr_sequencia, 
	a.ie_regra, 
	a.ds_titulo, 
	a.ds_texto, 
	coalesce(a.qt_dia,0) qt_dia, 
	a.ie_repetir 
from	gpi_cron_regra_aviso a 
where	a.nr_seq_cronograma	= nr_seq_cronograma_w;

vet02 c02%rowtype;

/*ETAPAS DO CRONOGRAMA*/
 
c03 CURSOR FOR 
SELECT	a.nr_sequencia, 
	a.dt_inicio_prev, 
	a.dt_fim_prev, 
	a.nm_etapa 
from	gpi_cron_etapa a 
where	a.nr_seq_cronograma		= nr_seq_cronograma_w 
and	trunc(a.dt_inicio_prev,'dd')	= trunc(clock_timestamp(),'dd') + qt_dia_w 
and	coalesce(a.dt_inicio_real::text, '') = '' 
and	ie_repetir_w			= 'N' 

union
 
SELECT	a.nr_sequencia, 
	a.dt_inicio_prev, 
	a.dt_fim_prev, 
	a.nm_etapa 
from	gpi_cron_etapa a 
where	a.nr_seq_cronograma		= nr_seq_cronograma_w 
and	trunc(clock_timestamp(),'dd') between trunc(a.dt_inicio_prev,'dd') - qt_dia_w and trunc(a.dt_inicio_prev,'dd') 
and	coalesce(a.dt_inicio_real::text, '') = '' 
and	ie_repetir_w			= 'S';

 
vet03 c03%rowtype;

 
c04 CURSOR FOR 
SELECT	b.nm_usuario, 
	substr(obter_nome_pf(b.cd_pessoa_fisica),1,60) nm_pessoa_fisica 
from	usuario b, 
	gpi_cron_etapa_equipe a	 
where	a.cd_pessoa_fisica	= b.cd_pessoa_fisica 
and	a.nr_seq_etapa		= nr_seq_etapa_w 
and	coalesce(a.nr_seq_equipe::text, '') = '' 

union
 
SELECT	d.nm_usuario, 
	substr(obter_nome_pf(d.cd_pessoa_fisica),1,60) nm_pessoa_fisica 
from	usuario d, 
	gpi_proj_equipe_membro c, 
	gpi_proj_equipe b, 
	gpi_cron_etapa_equipe a 
where	a.nr_seq_etapa		= nr_seq_etapa_w 
and	a.nr_seq_equipe		= b.nr_sequencia 
and	b.nr_sequencia		= c.nr_seq_equipe 
and	c.cd_pessoa_fisica	= d.cd_pessoa_fisica 
and	d.ie_situacao		= 'A' 
and	coalesce(a.cd_pessoa_fisica::text, '') = '';

vet04 c04%rowtype;

/*ETAPA DOS ATRASADOS*/
 
c06 CURSOR FOR 
SELECT	a.nr_sequencia, 
	a.dt_inicio_prev, 
	a.dt_fim_prev, 
	a.nm_etapa 
from	gpi_cron_etapa a 
where	a.nr_seq_cronograma		= nr_seq_cronograma_w 
and	trunc(a.dt_inicio_prev,'dd')	< trunc(clock_timestamp(),'dd') 
and	coalesce(a.dt_inicio_real::text, '') = '';

vet06 c06%rowtype;


BEGIN 
 
open c01;
loop 
fetch c01 into	 
	vet01;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
	nr_seq_cronograma_w	:= vet01.nr_seq_cronograma;
	nm_projeto_w		:= vet01.nm_projeto;
	ds_titulo_w		:= vet01.ds_titulo;
	cd_estabelecimento_w	:= vet01.cd_estabelecimento;
	 
	open c02;
	loop 
	fetch c02 into	 
		vet02;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin 
		qt_dia_w		:= vet02.qt_dia;
		ie_repetir_w		:= vet02.ie_repetir;
		ds_texto_w		:= vet02.ds_texto;
		ds_titulo_regra_w	:= vet02.ds_titulo;
		ie_regra_w		:= vet02.ie_regra;
		 
 
		 
		if (ie_regra_w = 'AIP') then 
			 
			open c03;
			loop 
			fetch c03 into	 
				vet03;
			EXIT WHEN NOT FOUND; /* apply on c03 */
				begin 
				nr_seq_etapa_w		:= vet03.nr_sequencia;
				nm_etapa_w		:= vet03.nm_etapa;
				dt_inicio_prev_w	:= vet03.dt_inicio_prev;
				dt_fim_prev_w		:= vet03.dt_fim_prev;
				ds_texto_w		:= vet02.ds_texto;
				 
				if (position('@nm_projeto' in lower(ds_texto_w)) > 0) then 
					ds_texto_w	:= substr(replace_macro(ds_texto_w, '@NM_PROJETO', nm_projeto_w),1,4000);
				end if;
				if (position('@ds_cronograma' in lower(ds_texto_w)) > 0) then 
					ds_texto_w	:= substr(replace_macro(ds_texto_w, '@DS_CRONOGRAMA', ds_titulo_w),1,4000);
				end if;
				 
				if (position('@nm_etapa' in lower(ds_texto_w)) > 0) then 
					ds_texto_w	:= substr(replace_macro(ds_texto_w, '@NM_ETAPA', nm_etapa_w),1,4000);
				end if;
				if (position('@dt_inicio_prev' in lower(ds_texto_w)) > 0) then 
					ds_texto_w	:= substr(replace_macro(ds_texto_w, '@DT_INICIO_PREV', dt_inicio_prev_w),1,4000);
				end if;
				if (position('@dt_fim_prev' in lower(ds_texto_w)) > 0) then 
					ds_texto_w	:= substr(replace_macro(ds_texto_w, '@DT_FIM_PREV', dt_fim_prev_w),1,4000);
				end if;
				 
				open c04;
				loop 
				fetch c04 into	 
					vet04;
				EXIT WHEN NOT FOUND; /* apply on c04 */
					begin 
					nm_usuario_dest_w	:= substr(nm_usuario_dest_w || vet04.nm_usuario || ', ',1,4000);
					nm_pessoa_fisica_w 	:= substr(nm_pessoa_fisica_w || vet04.nm_pessoa_fisica || ', ', 1,4000);
					end;
				end loop;
				close c04;
				 
				if (position('@nm_pessoa' in lower(ds_texto_w)) > 0) then 
					ds_texto_w	:= substr(replace_macro(ds_texto_w, '@NM_PESSOA', nm_pessoa_fisica_w),1,4000);
				end if;
				 
				if (coalesce(nm_usuario_dest_w, 'X') <> 'X') then 
					CALL gerar_comunic_padrao(	clock_timestamp(), 
								ds_titulo_regra_w, 
								ds_texto_w, 
								nm_usuario_p, 
								'N', --ie_geral 
								nm_usuario_dest_w, 
								'N', --ie_gerencial 
								null, --nr_seq_classif 
								null, --ds_perfil_adicional 
								cd_estabelecimento_w, 
								null, --ds_setor_adicional 
								clock_timestamp(), 
								null, --ds_grupo 
								null /*nm_usuario*/
);
				end if;
				nm_usuario_dest_w	:= '';
				nm_pessoa_fisica_w	:= '';
				end;
			end loop;
			close c03;
			 
		elsif (ie_regra_w = 'AIA') then 
			begin 
			 
			open c06;
			loop 
			fetch c06 into	 
				vet06;
			EXIT WHEN NOT FOUND; /* apply on c06 */
				begin 
				nr_seq_etapa_w		:= vet06.nr_sequencia;
				nm_etapa_w		:= vet06.nm_etapa;
				dt_inicio_prev_w	:= vet06.dt_inicio_prev;
				dt_fim_prev_w		:= vet06.dt_fim_prev;
				ds_texto_w		:= vet02.ds_texto;
				if (position('@nm_projeto' in lower(ds_texto_w)) > 0) then 
					ds_texto_w	:= substr(replace_macro(ds_texto_w, '@NM_PROJETO', nm_projeto_w),1,4000);
				end if;
				if (position('@ds_cronograma' in lower(ds_texto_w)) > 0) then 
					ds_texto_w	:= substr(replace_macro(ds_texto_w, '@DS_CRONOGRAMA', ds_titulo_w),1,4000);
				end if;
				 
				if (position('@nm_etapa' in lower(ds_texto_w)) > 0) then 
					ds_texto_w	:= substr(replace_macro(ds_texto_w, '@NM_ETAPA', nm_etapa_w),1,4000);
				end if;
				if (position('@dt_inicio_prev' in lower(ds_texto_w)) > 0) then 
					ds_texto_w	:= substr(replace_macro(ds_texto_w, '@DT_INICIO_PREV', dt_inicio_prev_w),1,4000);
				end if;
				if (position('@dt_fim_prev' in lower(ds_texto_w)) > 0) then 
					ds_texto_w	:= substr(replace_macro(ds_texto_w, '@DT_FIM_PREV', dt_fim_prev_w),1,4000);
				end if;
				 
				open c04;
				loop 
				fetch c04 into	 
					vet04;
				EXIT WHEN NOT FOUND; /* apply on c04 */
					begin 
					nm_usuario_dest_w	:= substr(nm_usuario_dest_w || vet04.nm_usuario || ', ',1,4000);
					nm_pessoa_fisica_w 	:= substr(nm_pessoa_fisica_w || vet04.nm_pessoa_fisica || ', ', 1,4000);
					end;
				end loop;
				close c04;
				 
				if (position('@nm_pessoa' in lower(ds_texto_w)) > 0) then 
					 
					ds_texto_w	:= substr(replace_macro(ds_texto_w, '@NM_PESSOA', nm_pessoa_fisica_w),1,4000);
				end if;
				 
				if (coalesce(nm_usuario_dest_w, 'X') <> 'X') then 
					 
					CALL gerar_comunic_padrao(	clock_timestamp(), 
								ds_titulo_regra_w, 
								ds_texto_w, 
								nm_usuario_p, 
									'N', --ie_geral 
								nm_usuario_dest_w, 
								'N', --ie_gerencial	 
								null, --nr_seq_classif 
								null, --ds_perfil_adicional 
								cd_estabelecimento_w, 
								null, --ds_setor_adicional 
								clock_timestamp(), 
								null, --ds_grupo 
								null /*nm_usuario*/
);
								 
				end if;
				nm_pessoa_fisica_w	:= '';
				nm_usuario_dest_w	:= '';
				 
				end;
			end loop;
			close c06;
			end;
		end if;	
		 
		end;
	end loop;
	close c02;
	 
	end;
end loop;
close c01;
 
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gpi_enviar_alerta_etapa ( cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
