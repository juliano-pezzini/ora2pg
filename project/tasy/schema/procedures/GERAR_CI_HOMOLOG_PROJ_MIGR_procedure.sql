-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_ci_homolog_proj_migr ( nr_seq_projeto_p bigint, nm_usuario_homolog_p text, nm_usuario_p text) AS $body$
DECLARE

		 
nm_usuario_migracao_w		varchar(15);
nr_seq_funcao_w			bigint;
nm_recurso_migracao_w		varchar(60);
nm_analista_migracao_w		varchar(60);
nm_programador_migracao_w	varchar(60);
nm_usuario_gerente_w		varchar(15);
nm_usuario_analista_w		varchar(15);
ds_grupo_desenvolvimento_w	varchar(80);
nm_usuarios_destino_w		varchar(4000);
ds_funcao_w			varchar(80);
ds_form_w			varchar(10);
ds_comunicado_w			varchar(32000);
		
c01 CURSOR FOR 
SELECT	obter_usuario_pf(p.cd_pessoa_fisica), 
	p.nr_seq_funcao, 
	obter_nome_pf(p.cd_pessoa_fisica) 
from	proj_equipe_papel p, 
	proj_equipe e 
where	p.nr_seq_equipe = e.nr_sequencia 
and	e.nr_seq_proj = nr_seq_projeto_p 
and	e.nr_seq_equipe_funcao = 11 
and	((coalesce(p.ie_funcao_rec_migr,'M') in ('M','T','C')) or (p.nr_seq_funcao in (46,45))) 
and	coalesce(p.ie_situacao,'A') = 'A';

c02 CURSOR FOR 
SELECT	obter_usuario_pf(m.cd_responsavel), 
	g.nm_usuario_lider, 
	g.ds_grupo 
from	gerencia_wheb m, 
	grupo_desenvolvimento g, 
	funcao_grupo_des f, 
	proj_projeto p 
where	m.nr_sequencia = g.nr_seq_gerencia 
and	g.nr_sequencia = f.nr_seq_grupo 
and	p.cd_funcao = f.cd_funcao 
and	p.nr_sequencia = nr_seq_projeto_p;
		

BEGIN 
if (nr_seq_projeto_p IS NOT NULL AND nr_seq_projeto_p::text <> '') and (nm_usuario_homolog_p IS NOT NULL AND nm_usuario_homolog_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then 
	begin 
	open c01;
	loop 
	fetch c01 into	nm_usuario_migracao_w, 
			nr_seq_funcao_w, 
			nm_recurso_migracao_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin 
		nm_usuarios_destino_w := nm_usuarios_destino_w || nm_usuario_migracao_w || ', ';
		end;
	end loop;
	close c01;
	 
	open c02;
	loop 
	fetch c02 into	nm_usuario_gerente_w, 
			nm_usuario_analista_w, 
			ds_grupo_desenvolvimento_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin 
		nm_usuarios_destino_w := nm_usuarios_destino_w || nm_usuario_gerente_w || ', ' || nm_usuario_analista_w || ', ';
		end;
	end loop;
	close c02;
	 
	nm_usuarios_destino_w := nm_usuarios_destino_w || 'Marcus' || ', ';
	 
	select	f.ds_funcao, 
		f.ds_form 
	into STRICT	ds_funcao_w, 
		ds_form_w 
	from	funcao f, 
		proj_projeto p 
	where	f.cd_funcao = p.cd_funcao 
	and	p.nr_sequencia = nr_seq_projeto_p;
	 
	ds_comunicado_w	:=	'{\rtf1\ansi\deff0{\fonttbl{\f0\fnil\fcharset0 Verdana;}{\f1\fnil Verdana;}} ' || 
				'{\colortbl ;\red0\green0\blue0;} ' || 
				'\viewkind4\uc1\pard\cf1\lang1046\f0\fs20 ' || 
				'\par ' || 'Prezados, ' || 
				'\par ' || 
				'\par ' || 'É com enorme alegria que comunicamos a homologação do projeto de migração da função ' || ds_funcao_w || ' (' || ds_form_w || ') por ' || obter_pessoa_fisica_usuario(nm_usuario_homolog_p,'N') || ' em ' || to_char(trunc(clock_timestamp(),'dd'),'dd/mm/yyyy') || '.' || 
				'\par ' || 
				'\par ' || 'Muito obrigado pela colaboração, comprometimento e dedicação de todos durante todo o processo nesse sentido.' || 
				'\par ' || 
				'\par ' || 'Obrigado e bom trabalho a todos :)' || 
				'\pard\cf1\f1\fs20 \f1 \par } ';
				 
	CALL gerar_comunic_padrao( 
		clock_timestamp(), 
		'Homologação do Projeto de Migração - ' || ds_funcao_w, 
		ds_comunicado_w, 
		nm_usuario_p, 
		'N', 
		nm_usuarios_destino_w, 
		'N', 
		null, 
		null, 
		1, 
		null, 
		clock_timestamp(), 
		null, 
		null);
	end;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_ci_homolog_proj_migr ( nr_seq_projeto_p bigint, nm_usuario_homolog_p text, nm_usuario_p text) FROM PUBLIC;
