-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE qua_gerar_pessoas_tre ( nr_seq_treinamento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_seq_documento_w		bigint;
cd_setor_atendimento_w		bigint;
cd_setor_usuario_w			bigint;
cd_perfil_w			bigint;
cd_cargo_w			bigint;
nm_usuario_w			varchar(25);
cd_pessoa_fisica_w		varchar(10);
cd_estabelecimento_w		smallint;
ie_somente_funcionario_w		varchar(01);
qt_regra_lib_w			bigint;
nr_seq_grupo_cargo_w		bigint;
nr_seq_grupo_usuario_w		bigint;
cd_classif_setor_w			varchar(02);
nr_seq_grupo_gerencia_w		qua_doc_lib.nr_seq_grupo_gerencia%Type;

 
C01 CURSOR FOR 
	SELECT	a.cd_pessoa_fisica, 
		a.cd_setor_atendimento 
	from	usuario a 
	where	a.ie_situacao		= 'A' 
	and	(a.cd_pessoa_fisica IS NOT NULL AND a.cd_pessoa_fisica::text <> '') 
	and	a.cd_setor_Atendimento	= cd_setor_Atendimento_w 
	and	((coalesce(substr(obter_dados_pf(a.cd_pessoa_fisica,'F'),1,1),'S') = ie_somente_funcionario_w) or (ie_somente_funcionario_w = 'N')) 
	and	not exists (	SELECT	1 
				from	qua_doc_trein_pessoa x 
				where	x.cd_pessoa_fisica		= a.cd_pessoa_fisica 
				and	x.nr_seq_treinamento	= nr_seq_treinamento_p);
	
C02 CURSOR FOR 
	SELECT	distinct 
		a.cd_pessoa_fisica, 
		a.cd_setor_atendimento 
	from	usuario a, 
		usuario_perfil b 
	where	a.ie_situacao	= 'A' 
	and	b.nm_usuario	= a.nm_usuario 
	and	(a.cd_pessoa_fisica IS NOT NULL AND a.cd_pessoa_fisica::text <> '') 
	and	b.cd_perfil	= cd_perfil_w 
	and	((coalesce(substr(obter_dados_pf(a.cd_pessoa_fisica,'F'),1,1),'S') = ie_somente_funcionario_w) or (ie_somente_funcionario_w = 'N')) 
	and	not exists (	SELECT	1 
				from	qua_doc_trein_pessoa x 
				where	x.cd_pessoa_fisica		= a.cd_pessoa_fisica 
				and	x.nr_seq_treinamento	= nr_seq_treinamento_p);

c03 CURSOR FOR 
	SELECT	cd_perfil, 
		nm_usuario_lib, 
		cd_setor_Atendimento, 
		cd_cargo, 
		nr_seq_grupo_cargo, 
		nr_seq_grupo_usuario, 
		cd_classif_setor, 
		nr_seq_grupo_gerencia 
	from	qua_doc_lib 
	where	nr_seq_doc	= nr_seq_documento_w;
	
	 
C04 CURSOR FOR 
	SELECT	a.cd_pessoa_fisica, 
		a.cd_setor_atendimento 
	from	usuario a 
	where	a.ie_situacao	= 'A' 
	and	(a.cd_pessoa_fisica IS NOT NULL AND a.cd_pessoa_fisica::text <> '') 
	and	((coalesce(substr(obter_dados_pf(a.cd_pessoa_fisica,'F'),1,1),'S')	= ie_somente_funcionario_w) or (ie_somente_funcionario_w = 'N')) 
	and	a.nm_usuario	= nm_usuario_w 
	and	not exists (	SELECT	1 
				from	qua_doc_trein_pessoa x 
				where	x.cd_pessoa_fisica		= a.cd_pessoa_fisica 
				and	x.nr_seq_treinamento	= nr_seq_treinamento_p);

C05 CURSOR FOR 
	SELECT	cd_pessoa_fisica, 
		cd_setor_atendimento 
	from	usuario 
	where	ie_situacao = 'A' 
	and	(cd_pessoa_fisica IS NOT NULL AND cd_pessoa_fisica::text <> '');
	
C06 CURSOR FOR 
	SELECT	a.cd_pessoa_fisica, 
		a.cd_setor_atendimento 
	from	pessoa_fisica b, 
		usuario a 
	where	a.ie_situacao	= 'A' 
	and	(a.cd_pessoa_fisica IS NOT NULL AND a.cd_pessoa_fisica::text <> '') 
	and	a.cd_pessoa_fisica = b.cd_pessoa_fisica 
	and	b.cd_cargo = cd_cargo_w 
	and	not exists (	SELECT	1 
				from	qua_doc_trein_pessoa x 
				where	x.cd_pessoa_fisica		= a.cd_pessoa_fisica 
				and	x.nr_seq_treinamento	= nr_seq_treinamento_p);

C07 CURSOR FOR 
	SELECT	distinct 
		b.cd_pessoa_fisica, 
		b.cd_setor_atendimento 
	from  usuario b, 
		usuario_grupo a 
	where  a.nm_usuario_grupo= b.nm_usuario 
	and   b.ie_situacao   = 'A' 
	and   a.ie_situacao   = 'A' 
	and	(b.cd_pessoa_fisica IS NOT NULL AND b.cd_pessoa_fisica::text <> '') 
	and	a.nr_seq_grupo = nr_seq_grupo_usuario_w 
	and not exists (	SELECT	1 
			from	qua_doc_trein_pessoa x 
			where	x.cd_pessoa_fisica		= b.cd_pessoa_fisica 
			and	x.nr_seq_treinamento	= nr_seq_treinamento_p);
			
c08 CURSOR FOR 
SELECT	cd_cargo 
from	qua_cargo_agrup 
where	nr_seq_agrup = nr_seq_grupo_cargo_w;

c09 CURSOR FOR 
SELECT	cd_setor_atendimento 
from	setor_atendimento 
where	cd_classif_setor = cd_classif_setor_w;

c10 CURSOR FOR 
	SELECT	a.cd_pessoa_fisica, 
		a.cd_setor_atendimento 
	from	usuario a, 
		gerencia_wheb e, 
		gerencia_wheb_grupo b, 
		gerencia_wheb_grupo_usu c 
	where	b.nr_sequencia = nr_seq_grupo_gerencia_w 
	and	e.nr_sequencia = b.nr_seq_gerencia 
	and	b.nr_sequencia = c.nr_seq_grupo 
	and	c.nm_usuario_grupo = a.nm_usuario 
	and	e.ie_situacao = 'A' 
	and	b.ie_situacao = 'A' 
	and	not exists (	SELECT	1 
					from	qua_doc_trein_pessoa x 
					where	x.cd_pessoa_fisica		= a.cd_pessoa_fisica 
					and	x.nr_seq_treinamento	= nr_seq_treinamento_p);

 

BEGIN 
 
select	nr_seq_documento 
into STRICT	nr_seq_documento_w 
from	qua_doc_treinamento 
where	nr_sequencia	= nr_seq_treinamento_p;
 
select	count(*) 
into STRICT	qt_regra_lib_w 
from	qua_doc_lib 
where	nr_seq_doc 	= nr_seq_documento_w;
 
select	cd_estabelecimento 
into STRICT	cd_estabelecimento_w 
from	qua_documento 
where	nr_sequencia 	= nr_seq_documento_w;
 
select	substr(coalesce(obter_valor_param_usuario(4000, 75, Obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w),'N'),1,1) 
into STRICT	ie_somente_funcionario_w
;
 
RAISE NOTICE '%', nr_seq_documento_w;
open C03;
loop 
fetch C03 into	 
	cd_perfil_w, 
	nm_usuario_w, 
	cd_setor_atendimento_w, 
	cd_cargo_w, 
	nr_seq_grupo_cargo_w, 
	nr_seq_grupo_usuario_w, 
	cd_classif_setor_w, 
	nr_seq_grupo_gerencia_w;
EXIT WHEN NOT FOUND; /* apply on C03 */
	begin 
	 
	if (cd_setor_atendimento_w IS NOT NULL AND cd_setor_atendimento_w::text <> '') then 
		open C01;
		loop 
		fetch C01 into	 
			cd_pessoa_fisica_w, 
			cd_setor_usuario_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin 
			insert 	into 	qua_doc_trein_pessoa(	nr_sequencia, 
							dt_atualizacao, 
							nm_usuario, 
							nr_seq_treinamento, 
							cd_pessoa_fisica, 
							ie_faltou, 
							cd_setor_atendimento) 
					values (	nextval('qua_doc_trein_pessoa_seq'), 
							clock_timestamp(), 
							nm_usuario_p, 
							nr_seq_treinamento_p, 
							cd_pessoa_fisica_w, 
							'N', 
							cd_setor_usuario_w);
			end;
		end loop;
		close C01;
	end if;
	 
	if (cd_classif_setor_w IS NOT NULL AND cd_classif_setor_w::text <> '') then 
		open C09;
		loop 
		fetch C09 into	 
			cd_setor_atendimento_w;
		EXIT WHEN NOT FOUND; /* apply on C09 */
			begin 
			open C01;
			loop 
			fetch C01 into	 
				cd_pessoa_fisica_w, 
				cd_setor_usuario_w;
			EXIT WHEN NOT FOUND; /* apply on C01 */
				begin 
				insert into qua_doc_trein_pessoa(	nr_sequencia, 
								dt_atualizacao, 
								nm_usuario, 
								nr_seq_treinamento, 
								cd_pessoa_fisica, 
								ie_faltou, 
								cd_setor_atendimento) 
						values (	nextval('qua_doc_trein_pessoa_seq'), 
								clock_timestamp(), 
								nm_usuario_p, 
								nr_seq_treinamento_p, 
								cd_pessoa_fisica_w, 
								'N', 
								cd_setor_usuario_w);
				end;
			end loop;
			close C01;
			end;
		end loop;
		close C09;
	end if;
	if (cd_perfil_w IS NOT NULL AND cd_perfil_w::text <> '') then 
		open C02;
		loop 
		fetch C02 into	 
			cd_pessoa_fisica_w, 
			cd_setor_usuario_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin 
			insert into qua_doc_trein_pessoa(	nr_sequencia, 
							dt_atualizacao, 
							nm_usuario, 
							nr_seq_treinamento, 
							cd_pessoa_fisica, 
							ie_faltou, 
							cd_setor_atendimento) 
					values (	nextval('qua_doc_trein_pessoa_seq'), 
							clock_timestamp(), 
							nm_usuario_p, 
							nr_seq_treinamento_p, 
							cd_pessoa_fisica_w, 
							'N', 
							cd_setor_usuario_w);
			end;
		end loop;
		close C02;
	end if;
	if (nm_usuario_w IS NOT NULL AND nm_usuario_w::text <> '') then 
		open C04;
		loop 
		fetch C04 into	 
			cd_pessoa_fisica_w, 
			cd_setor_usuario_w;
		EXIT WHEN NOT FOUND; /* apply on C04 */
			begin 
			insert into qua_doc_trein_pessoa(	nr_sequencia, 
							dt_atualizacao, 
							nm_usuario, 
							nr_seq_treinamento, 
							cd_pessoa_fisica, 
							ie_faltou, 
							cd_setor_atendimento) 
					values (	nextval('qua_doc_trein_pessoa_seq'), 
							clock_timestamp(), 
							nm_usuario_p, 
							nr_seq_treinamento_p, 
							cd_pessoa_fisica_w, 
							'N', 
							cd_setor_usuario_w);
			end;
		end loop;
		close C04;
	end if;
	if (cd_cargo_w IS NOT NULL AND cd_cargo_w::text <> '') then 
		open C06;
		loop 
		fetch C06 into	 
			cd_pessoa_fisica_w, 
			cd_setor_usuario_w;
		EXIT WHEN NOT FOUND; /* apply on C06 */
			begin 
			insert into qua_doc_trein_pessoa(	nr_sequencia, 
							dt_atualizacao, 
							nm_usuario, 
							nr_seq_treinamento, 
							cd_pessoa_fisica, 
							ie_faltou, 
							cd_setor_atendimento) 
					values (	nextval('qua_doc_trein_pessoa_seq'), 
							clock_timestamp(), 
							nm_usuario_p, 
							nr_seq_treinamento_p, 
							cd_pessoa_fisica_w, 
							'N', 
							cd_setor_usuario_w);
			end;
		end loop;
		close C06;
	end if;	
	 
	if (nr_seq_grupo_cargo_w IS NOT NULL AND nr_seq_grupo_cargo_w::text <> '') then 
		open C08;
		loop 
		fetch C08 into	 
			cd_cargo_w;
		EXIT WHEN NOT FOUND; /* apply on C08 */
			begin 
			open C06;
			loop 
			fetch C06 into	 
				cd_pessoa_fisica_w, 
				cd_setor_usuario_w;
			EXIT WHEN NOT FOUND; /* apply on C06 */
				begin 
				insert into qua_doc_trein_pessoa(	nr_sequencia, 
								dt_atualizacao, 
								nm_usuario, 
								nr_seq_treinamento, 
								cd_pessoa_fisica, 
								ie_faltou, 
								cd_setor_atendimento) 
						values (	nextval('qua_doc_trein_pessoa_seq'), 
								clock_timestamp(), 
								nm_usuario_p, 
								nr_seq_treinamento_p, 
								cd_pessoa_fisica_w, 
								'N', 
								cd_setor_usuario_w);
				end;
			end loop;
			close C06;
			end;
		end loop;
		close C08;
	end if;
	 
	if (nr_seq_grupo_usuario_w IS NOT NULL AND nr_seq_grupo_usuario_w::text <> '') then 
		open C07;
		loop 
		fetch C07 into	 
			cd_pessoa_fisica_w, 
			cd_setor_usuario_w;
		EXIT WHEN NOT FOUND; /* apply on C07 */
			begin 
			insert into qua_doc_trein_pessoa(	nr_sequencia, 
							dt_atualizacao, 
							nm_usuario, 
							nr_seq_treinamento, 
							cd_pessoa_fisica, 
							ie_faltou, 
							cd_setor_atendimento) 
					values (	nextval('qua_doc_trein_pessoa_seq'), 
							clock_timestamp(), 
							nm_usuario_p, 
							nr_seq_treinamento_p, 
							cd_pessoa_fisica_w, 
							'N', 
							cd_setor_usuario_w);
			end;
		end loop;
		close C07;
	end if;
	 
	if (nr_seq_grupo_gerencia_w IS NOT NULL AND nr_seq_grupo_gerencia_w::text <> '') then 
	 
		open	c10;
		loop	 
		fetch 	c10 into	 
			cd_pessoa_fisica_w, 
			cd_setor_usuario_w;
		EXIT WHEN NOT FOUND; /* apply on C10 */
			begin 
			insert 	into 	qua_doc_trein_pessoa(	nr_sequencia, 
						dt_atualizacao, 
						nm_usuario, 
						nr_seq_treinamento, 
						cd_pessoa_fisica, 
						ie_faltou, 
						cd_setor_atendimento) 
				values (	nextval('qua_doc_trein_pessoa_seq'), 
						clock_timestamp(), 
						nm_usuario_p, 
						nr_seq_treinamento_p, 
						cd_pessoa_fisica_w, 
						'N', 
						cd_setor_usuario_w);
			 
			end;
		end loop;
		close c10;
	 
	end if;
	end;
end loop;
close C03;
 
if (qt_regra_lib_w = 0) then 
	begin 
	open C05;
	loop 
	fetch C05 into	 
		cd_pessoa_fisica_w, 
		cd_setor_usuario_w;
	EXIT WHEN NOT FOUND; /* apply on C05 */
		begin 
		insert into qua_doc_trein_pessoa(	nr_sequencia, 
						dt_atualizacao, 
						nm_usuario, 
						nr_seq_treinamento, 
						cd_pessoa_fisica, 
						ie_faltou, 
						cd_setor_atendimento) 
				values (	nextval('qua_doc_trein_pessoa_seq'), 
						clock_timestamp(), 
						nm_usuario_p, 
						nr_seq_treinamento_p, 
						cd_pessoa_fisica_w, 
						'N', 
						cd_setor_usuario_w);
		end;
	end loop;
	close C05;
	end;
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE qua_gerar_pessoas_tre ( nr_seq_treinamento_p bigint, nm_usuario_p text) FROM PUBLIC;

