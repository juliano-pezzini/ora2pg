-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE proj_gerar_modulo_funcoes2 (nm_usuario_P text) AS $body$
DECLARE


ie_tipo_consultor_w	varchar(10);
ie_tipo_funcao_w	varchar(10);
nr_seq_con_gest_fun_w	bigint;
nr_seq_con_gest_mod_w	bigint;
qt_registros_w		bigint;
nr_seq_mod_impl_w	bigint;
nr_seq_consultor_w	bigint;
cd_funcao_w		bigint;

--buscar os consultores
c01 CURSOR FOR
	SELECT	nr_sequencia,
		ie_tipo_consultor
	from	com_canal_consultor
	where	ie_funcao_exec in ('CONSULT','COORD');

--deletar as funções não pertencentes ao consultor
C02 CURSOR FOR
	SELECT 	b.nr_sequencia
	from	funcao a,
		com_cons_gest_con_fun b,
		com_cons_gest_con_mod c
	where	a.cd_funcao = b.cd_funcao
	and	b.nr_seq_conhecimento = c.nr_sequencia
	and	c.nr_seq_consultor = nr_seq_consultor_w
	AND (ie_tipo_consultor_w IS NOT NULL AND ie_tipo_consultor_w::text <> '')
	and (ie_classif_produto IS NOT NULL AND ie_classif_produto::text <> '')
	and (
		not exists (SELECT 1 from proj_gest_conhecimento p where a.cd_funcao = p.cd_funcao)
		--nvl(ie_gestao_conhecimento, 'N') = 'N'
		or (ie_tipo_consultor_w = 'CP' AND (ie_classif_produto not in ('P', 'A')))--CP= Prestador;P=Prestador;A=Ambos
		or (ie_tipo_consultor_w = 'CO' AND (ie_classif_produto not in ('O', 'A')))--CO=Operadora;O=Operadora
		or (ie_tipo_consultor_w = 'PO' AND (ie_classif_produto not in ('O', 'P', 'A')))--PO=Prestador + OPS
		);

--Deletar as funções que estão no cadastro como inativas ou para Wheb ou TasySys ou código negativo
C03 CURSOR FOR
	SELECT 	b.nr_sequencia
	from	funcao a,
		com_cons_gest_con_fun b,
		com_cons_gest_con_mod c
	where	a.cd_funcao = b.cd_funcao
	and	b.nr_seq_conhecimento = c.nr_sequencia
	and obter_dados_modulo_implantacao(c.nr_seq_mod_impl, 'S') <> 'A'
	and	((a.ie_situacao in ('W'))
	or (a.ds_aplicacao = 'TasySis')
	or (a.cd_funcao < 0)
	or not exists (SELECT 1 from proj_gest_conhecimento p where a.cd_funcao = p.cd_funcao))
	--or	nvl(ie_gestao_conhecimento, 'N') <> 'S')
	and	c.nr_seq_consultor = nr_seq_consultor_w;

--Buscar as  funções do cadastro, que não pertencem ao consultor
C04 CURSOR FOR

SELECT	cd_funcao,
		nr_seq_mod_impl
	FROM	funcao a
	WHERE (a.ie_situacao NOT('I','W'))
	AND (a.ds_aplicacao <> 'TasySis')
	AND (a.ds_aplicacao <> 'TasyRel')
	AND (a.cd_funcao > 0)
	AND	(nr_seq_mod_impl IS NOT NULL AND nr_seq_mod_impl::text <> '')
	AND	exists (SELECT 1 from proj_gest_conhecimento p where a.cd_funcao = p.cd_funcao)
	--AND	NVL(ie_gestao_conhecimento, 'N') = 'S'
	AND	NOT EXISTS (SELECT 1
				 FROM	com_cons_gest_con_fun b,
					com_cons_gest_con_mod c
				 WHERE	c.nr_sequencia = b.nr_seq_conhecimento
				 AND	b.cd_funcao = a.cd_funcao
				 AND	c.nr_seq_consultor = nr_seq_consultor_w)
	and (coalesce(ie_tipo_consultor_w::text, '') = ''
		or (coalesce(ie_classif_produto::text, '') = ''
			or (ie_tipo_consultor_w = 'CP' AND (ie_classif_produto IN ('P', 'A')))
				OR (ie_tipo_consultor_w = 'CO' and (ie_classif_produto IN ('O', 'A')))
				OR (ie_tipo_consultor_w = 'PO' and (ie_classif_produto IN ('O', 'P', 'A')))))
	and EXISTS (SELECT 1 FROM modulo_implantacao WHERE nr_sequencia =  nr_seq_mod_impl);


BEGIN

open C01;
loop
fetch C01 into
	nr_seq_consultor_w,
	ie_tipo_consultor_w;
EXIT WHEN NOT FOUND; /* apply on C01 */

	--Deletar as funções não pertencentes ao consultor
	open C02;
	loop
	fetch C02 into
		nr_seq_con_gest_fun_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
			delete
			from	com_cons_gest_con_fun
			where	nr_sequencia = nr_seq_con_gest_fun_w;
		end;
	end loop;
	close C02;

	--Deletar as funções inativas no cadastro de funções
	open C03;
	loop
	fetch C03 into
		nr_seq_con_gest_fun_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		begin
			delete
			from	com_cons_gest_con_fun
			where	nr_sequencia = nr_seq_con_gest_fun_w;
		end;
	end loop;
	close C03;

	--Deletar todos os módulos que não possuem função vinculada ao consultor
	delete
	from	com_cons_gest_con_mod a
	where	a.nr_seq_consultor = nr_seq_consultor_w
	and	not exists (SELECT 	1
			    from	com_cons_gest_con_fun b
			    where	a.nr_sequencia = b.nr_seq_conhecimento);

	--inserir as  funções que ainda não estão para os consultores
	open C04;
	loop
	fetch C04 into
		cd_funcao_w,
		nr_seq_mod_impl_w;
	EXIT WHEN NOT FOUND; /* apply on C04 */
		begin
			-- verifica se o consultor já possui o módulo
			select	count(*)
			into STRICT	qt_registros_w
			from	com_cons_gest_con_mod
			where	nr_seq_consultor = nr_seq_consultor_w
			and	nr_seq_mod_impl = nr_seq_mod_impl_w
			and obter_dados_modulo_implantacao(nr_seq_mod_impl, 'S') = 'A';

			-- caso já exista o sistema irá buscar  a sequência, caso não irá inserir o módulo para  o consultor
			if ( qt_registros_w > 0) then
				select	max(nr_sequencia)
				into STRICT	nr_seq_con_gest_mod_w
				from	com_cons_gest_con_mod
				where	nr_seq_consultor = nr_seq_consultor_w
				and	nr_seq_mod_impl = nr_seq_mod_impl_w;
			else
				select 	nextval('com_cons_gest_con_mod_seq')
				into STRICT	nr_seq_con_gest_mod_w
				;

				insert into com_cons_gest_con_mod(nr_sequencia,
								   dt_atualizacao,
								   nm_usuario,
								   dt_atualizacao_nrec,
								   nm_usuario_nrec,
								   nr_seq_consultor,
								   nr_seq_mod_impl,
								   nr_seq_gest_con)
				values (nr_seq_con_gest_mod_w,
								   clock_timestamp(),
								   nm_usuario_p,
								   clock_timestamp(),
								   nm_usuario_p,
								   nr_seq_consultor_w,
								   nr_seq_mod_impl_w,
								   null);
			end if;

			-- inserir a função para o módulo
			insert into com_cons_gest_con_fun(nr_sequencia		,
				nr_seq_conhecimento	,
				cd_funcao               ,
				dt_atualizacao          ,
				nm_usuario              ,
				dt_atualizacao_nrec     ,
				nm_usuario_nrec         ,
				dt_certificacao         ,
				pr_conhecimento         ,
				ie_implantou            ,
				ie_ead                  ,
				ie_treinamento_interno	,
				ie_situacao)
			values (	nextval('com_cons_gest_con_fun_seq'),
				nr_seq_con_gest_mod_w,
				cd_funcao_w,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p, null,
				0, 'N', 'N', 'N', 'A');

		end;
	end loop;
	close C04;
end loop;
close C01;




commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE proj_gerar_modulo_funcoes2 (nm_usuario_P text) FROM PUBLIC;
