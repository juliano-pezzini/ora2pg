-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_escala_servico ( nm_usuario_p text, ie_parametro_p text, cd_estabelecimento_p bigint, cd_mes_p text, cd_ano_p text, nr_seq_classif_p bigint, ie_controla_perfil_p text, ie_html5_p text default 'N') AS $body$
DECLARE

 
cd_pessoa_fisica_w		varchar(20);
ds_periodo_w			varchar(30);
nr_seq_escala_w			bigint;
ds_cor_padrao_w			varchar(20);
cd_dia_semana_w			smallint	:= 0;
ie_pertence_w			varchar(30);
nr_seq_classif_w			bigint;
qt_dia_w				bigint;
dt_escala_w			varchar(50);
nr_sequencia_w			bigint;
ds_cor_w				varchar(10);
qt_count_w			bigint;
ds_comando_w			varchar(255);

nm_pessoa_fisica_W		varchar(255);
ds_setor_w			varchar(255);
ds_classif_w			varchar(255);
ds_cargo_w			varchar(255);
hr_inicio_w			varchar(20);
hr_fim_w				varchar(20);
qt_existe_w			bigint;

nr_seq_escala_temp_w		bigint	:=	0;
cd_pessoa_fisica_temp_w		varchar(20)	:=	'X';
last_day_w			varchar(5);

ie_mostra_escala_w		varchar(1) 	:= 	'S';

 
c01 CURSOR FOR 
SELECT distinct f.cd_pessoa_fisica, 
	to_char(d.dt_inicio,'hh24:mi')||'/'||to_char(d.dt_fim,'hh24:mi') ds_periodo, 
	e.nr_sequencia nr_seq_escala, 
	c.nr_sequencia nr_seq_classif, 
	to_char(d.dt_inicio,'hh24:mi'), 
	to_char(d.dt_fim,'hh24:mi') 
from	escala_diaria d, 
	escala_grupo g, 
	escala_classif c, 
	escala	e, 
	escala_diaria_adic f 
where	c.nr_sequencia = g.nr_seq_classif 
and	g.nr_sequencia = e.nr_seq_grupo 
and	e.nr_sequencia = d.nr_seq_escala 
and	f.nr_seq_escala_diaria = d.nr_sequencia 
and   c.nr_sequencia = CASE WHEN nr_seq_classif_p=0 THEN c.nr_sequencia  ELSE nr_seq_classif_p END  
and	((c.ie_tipo_escala in ('S','L')) or (coalesce(e.nr_sequencia::text, '') = '')) 
and   to_char(d.dt_inicio,'mm')   = cd_mes_p 
and   to_char(d.dt_inicio,'yyyy')  = cd_ano_p 
order by e.nr_sequencia;


BEGIN 
 
if (ie_html5_p = 'S') then 
	select	'0' 
	into STRICT	ds_cor_padrao_w 
	;
else 
	select	max(ds_cor_fundo) 
	into STRICT	ds_cor_padrao_w 
	from	tasy_padrao_cor 
	where	nr_sequencia = 2072;
 
end if;
 
 
delete 	FROM w_escala_servico 
where	nm_usuario = nm_usuario_p;
 
open C01;
loop 
fetch C01 into 
	cd_pessoa_fisica_w, 
	ds_periodo_w, 
	nr_seq_escala_w, 
	nr_seq_classif_w, 
	hr_inicio_w, 
	hr_fim_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
 
	if (ie_controla_perfil_p = 'S') then 
		ie_mostra_escala_w := obter_se_mostra_escala(nm_usuario_p,nr_seq_escala_w);
	end if;
 
	if (ie_mostra_escala_w = 'S') then 
		qt_dia_w := 1;
		 
		select	to_char(last_day(to_date('01' || '/' || cd_mes_p || '/' || cd_ano_p,'dd/mm/yyyy')),'dd') 
		into STRICT	last_day_w 
		;
		 
		while(qt_dia_w <= last_day_w) loop 
		begin 
 
		ds_cor_w := '';
		dt_escala_w := (qt_dia_w||'/'||cd_mes_p||'/'||cd_ano_p);
 
		select	pkg_date_utils.get_WeekDay(to_date(dt_escala_w,'dd/mm/yyyy')) 
		into STRICT	cd_dia_semana_w 
		;
 
 
		if (ie_parametro_p = 'S') and 
			((cd_dia_semana_w in (1,7)) or (obter_se_feriado(cd_estabelecimento_p,to_date(dt_escala_w,'dd/mm/yyyy')) > 0)) then 
			ds_cor_w	:= ds_cor_padrao_w;
 
		end if;
 
		select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'X' END  
		into STRICT	ie_pertence_w 
		from	escala_diaria d, 
			escala_grupo g, 
			escala_classif c, 
			escala	e, 
			escala_diaria_adic f 
		where	c.nr_sequencia = g.nr_seq_classif 
		and	g.nr_sequencia = e.nr_seq_grupo 
		and	e.nr_sequencia = d.nr_seq_escala 
		and	f.nr_seq_escala_diaria = d.nr_sequencia 
		and   obter_tipo_classif_escala(e.nr_sequencia) in ('S','L') 
		and	trunc(dt_inicio) = dt_escala_w 
		and	f.cd_pessoa_fisica = cd_pessoa_fisica_w 
		and	e.nr_sequencia = nr_seq_escala_w 
		and 	to_char(d.dt_inicio, 'hh24:mi') = hr_inicio_w 
		and 	to_char(d.dt_fim, 'hh24:mi') = hr_fim_w 
		and	not exists (SELECT 	1 
				  from	escala_afastamento_prof a, 
						motivo_afast_escala b 
				  where	a.nr_seq_motivo_afast = b.nr_sequencia 
				  and		a.cd_profissional = cd_pessoa_fisica_w 
				  and		((a.nr_seq_escala = nr_seq_escala_w) or (coalesce(a.nr_seq_escala::text, '') = '')) 
				  and		dt_escala_w >= trunc(a.dt_inicio) 
				  and 	dt_escala_w <= trunc(a.dt_final));
 
		if (ie_pertence_w = 'N') then 
 
			if (ie_html5_p = 'S') then 
				begin 
					select	CASE WHEN count(*)=0 THEN ''  ELSE to_char(b.nr_sequencia) END  
					into STRICT	ds_cor_w 
					from	escala_afastamento_prof a, 
						motivo_afast_escala b 
					where	a.nr_seq_motivo_afast = b.nr_sequencia 
					and	a.cd_profissional = cd_pessoa_fisica_w 
					and	((a.nr_seq_escala = nr_seq_escala_w) or (coalesce(a.nr_seq_escala::text, '') = '')) 
					and	dt_escala_w >= trunc(a.dt_inicio) 
					and 	dt_escala_w <= trunc(a.dt_final) 
					group by b.nr_sequencia;
				exception 
					when others then 
					ie_pertence_w := '';
				end;
			else			 
				begin 
					select	CASE WHEN count(*)=0 THEN ''  ELSE b.ds_cor END  
					into STRICT	ds_cor_w 
					from	escala_afastamento_prof a, 
						motivo_afast_escala b 
					where	a.nr_seq_motivo_afast = b.nr_sequencia 
					and	a.cd_profissional = cd_pessoa_fisica_w 
					and	((a.nr_seq_escala = nr_seq_escala_w) or (coalesce(a.nr_seq_escala::text, '') = '')) 
					and	dt_escala_w >= trunc(a.dt_inicio) 
					and 	dt_escala_w <= trunc(a.dt_final) 
					group by b.ds_cor;
				exception 
					when others then 
					ie_pertence_w := '';
				end;
			 
			end if;
			 
 
		end if;
 
 
		if (nr_seq_escala_w <> nr_seq_escala_temp_w) then 
			ds_setor_w := substr(obter_setores_escala(nr_seq_escala_w),1,255);
 
			select	substr(CASE WHEN obter_tipo_classif_escala(nr_seq_escala_w)='S' THEN  PERFORM obter_desc_expressao(630808) WHEN obter_tipo_classif_escala(nr_seq_escala_w)='L' THEN  PERFORM obter_desc_expressao(736647) END ,1,50) 
			into STRICT	ds_classif_w 
			;
		end if;
 
		nr_seq_escala_temp_w := nr_seq_escala_w;
 
		if (cd_pessoa_fisica_w <> cd_pessoa_fisica_temp_w) then 
			select	substr(max(obter_nome_pf(cd_pessoa_fisica)),1,100) 
			into STRICT	nm_pessoa_fisica_W 
			from	PESSOA_FISICA 
			where	CD_PESSOA_FISICA = cd_pessoa_fisica_w;
			 
			ds_cargo_w := substr(obter_dados_pf(cd_pessoa_fisica_w,'CR'),1,90);
		end if;
 
		cd_pessoa_fisica_temp_w := cd_pessoa_fisica_w;
 
		select 	count(*) 
		into STRICT	qt_count_w 
		from 	w_escala_servico 
		where 	cd_pessoa_fisica = cd_pessoa_fisica_w 
		and	nr_seq_escala = nr_seq_escala_w 
		and	nr_seq_classif = nr_seq_classif_w 
		and	hr_inicio	= hr_inicio_w 
		and	hr_fim		= hr_fim_w 
		and	nm_usuario	= nm_usuario_p;
 
	 
/*	select nvl(max(nr_sequencia),0) + 1 
		into	nr_sequencia_w 
		from 	w_escala_servico;*/
 
		 
		 
		 
		if (qt_count_w = 0) then 
				begin 
				insert into w_escala_servico( 
						nr_sequencia, 
						dt_mes, 
						dt_ano, 
						nr_seq_classif, 
						nr_seq_escala, 
						cd_pessoa_fisica, 
						NM_PROFISSIONAL, 
						DS_SETOR, 
						DS_TIPO_ESCALA, 
						DS_CARGO, 
						ds_periodo, 
						nm_usuario, 
						dia1, 
						dia2, 
						dia3, 
						dia4, 
						dia5, 
						dia6, 
						dia7, 
						dia8, 
						dia9, 
						dia10, 
						dia11, 
						dia12, 
						dia13, 
						dia14, 
						dia15, 
						dia16, 
						dia17, 
						dia18, 
						dia19, 
						dia20, 
						dia21, 
						dia22, 
						dia23, 
						dia24, 
						dia25, 
						dia26, 
						dia27, 
						dia28, 
						dia29, 
						dia30, 
						dia31, 
						cor1, 
						cor2, 
						cor3, 
						cor4, 
						cor5, 
						cor6, 
						cor7, 
						cor8, 
						cor9, 
						cor10, 
						cor11, 
						cor12, 
						cor13, 
						cor14, 
						cor15, 
						cor16, 
						cor17, 
						cor18, 
						cor19, 
						cor20, 
						cor21, 
						cor22, 
						cor23, 
						cor24, 
						cor25, 
						cor26, 
						cor27, 
						cor28, 
						cor29, 
						cor30, 
						cor31, 
						hr_inicio, 
						hr_fim) 
						values ( 
						nextval('w_escala_servico_seq'), 
--						nr_sequencia_w, 
						cd_mes_p, 
						cd_ano_p, 
						nr_seq_classif_w, 
						nr_seq_escala_w, 
						cd_pessoa_fisica_w, 
						nm_pessoa_fisica_W, 
						ds_setor_w, 
						ds_classif_w, 
						ds_cargo_w, 
						ds_periodo_w, 
						nm_usuario_p, 
						ie_pertence_w, 
						ie_pertence_w, 
						ie_pertence_w, 
						ie_pertence_w, 
						ie_pertence_w, 
						ie_pertence_w, 
						ie_pertence_w, 
						ie_pertence_w, 
						ie_pertence_w, 
						ie_pertence_w, 
						ie_pertence_w, 
						ie_pertence_w, 
						ie_pertence_w, 
						ie_pertence_w, 
						ie_pertence_w, 
						ie_pertence_w, 
						ie_pertence_w, 
						ie_pertence_w, 
						ie_pertence_w, 
						ie_pertence_w, 
						ie_pertence_w, 
						ie_pertence_w, 
						ie_pertence_w, 
						ie_pertence_w, 
						ie_pertence_w, 
						ie_pertence_w, 
						ie_pertence_w, 
						ie_pertence_w, 
						ie_pertence_w, 
						ie_pertence_w, 
						ie_pertence_w, 
						ds_cor_w, 
						ds_cor_w, 
						ds_cor_w, 
						ds_cor_w, 
						ds_cor_w, 
						ds_cor_w, 
						ds_cor_w, 
						ds_cor_w, 
						ds_cor_w, 
						ds_cor_w, 
						ds_cor_w, 
						ds_cor_w, 
						ds_cor_w, 
						ds_cor_w, 
						ds_cor_w, 
						ds_cor_w, 
						ds_cor_w, 
						ds_cor_w, 
						ds_cor_w, 
						ds_cor_w, 
						ds_cor_w, 
						ds_cor_w, 
						ds_cor_w, 
						ds_cor_w, 
						ds_cor_w, 
						ds_cor_w, 
						ds_cor_w, 
						ds_cor_w, 
						ds_cor_w, 
						ds_cor_w, 
						ds_cor_w, 
						hr_inicio_w, 
						hr_fim_w);
				end;
			else 
				begin 
				ds_comando_w	:=	' update w_escala_servico ' || 
							' set dia' || qt_dia_w || ' = ' || chr(39)||ie_pertence_w||chr(39) || 
							'   ,cor' || qt_dia_w || ' = '|| chr(39)||ds_cor_w||chr(39)    || 
							' where cd_pessoa_fisica = '|| cd_pessoa_fisica_w || 
							' and nr_seq_escala = ' || nr_seq_escala_w || 
							' and nr_seq_classif = ' || nr_seq_classif_w || 
							' and hr_inicio = ' || chr(39) || hr_inicio_w || chr(39) || 
							' and hr_fim = ' || chr(39) || hr_fim_w || chr(39);
 
				CALL exec_sql_dinamico('TASY', ds_comando_w);
				end;
			end if;
 
		qt_dia_w	:= qt_dia_w + 1;
		end;
		end loop;
	end if;
	end;
end loop;
close C01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_escala_servico ( nm_usuario_p text, ie_parametro_p text, cd_estabelecimento_p bigint, cd_mes_p text, cd_ano_p text, nr_seq_classif_p bigint, ie_controla_perfil_p text, ie_html5_p text default 'N') FROM PUBLIC;
