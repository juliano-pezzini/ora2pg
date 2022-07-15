-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE limpar_dup_mod_func ( nm_usuario_p text, nr_seq_consultor_p bigint default null) AS $body$
DECLARE


nr_seq_modulo_w		bigint;
qt_percentual		bigint;
nr_seq_w			bigint;
nr_seq_con_gest_fun_w	bigint;
ie_tipo_consultor_w	varchar(10);

c01 CURSOR FOR
SELECT	a.nr_sequencia
from	com_cons_gest_con_mod a
where	1 = 1
and	not exists (	select	1
			from	com_cons_gest_con_fun b
			where	b.nr_seq_conhecimento = a.nr_sequencia);

c02 CURSOR FOR
SELECT	nr_sequencia
from	com_cons_gest_con_mod;

c03 CURSOR FOR
SELECT	count(*)
from	com_cons_gest_con_fun
where	nr_seq_conhecimento = nr_seq_modulo_w
and	pr_conhecimento > 0;

--deletar as funções não pertencentes ao consultor
C04 CURSOR FOR
	SELECT 	b.nr_sequencia
	from	funcao a,
		com_cons_gest_con_fun b,
		com_cons_gest_con_mod c
	where	a.cd_funcao = b.cd_funcao
	and	b.nr_seq_conhecimento = c.nr_sequencia
	and	c.nr_seq_consultor = nr_seq_consultor_p
	and (ie_classif_produto IS NOT NULL AND ie_classif_produto::text <> '')
	and (
		not exists (SELECT 1 from proj_gest_conhecimento p where a.cd_funcao = p.cd_funcao)
		--nvl(ie_gestao_conhecimento, 'N') = 'N'
		or (ie_tipo_consultor_w = 'CP' AND (ie_classif_produto not in ('P', 'A')))--CP= Prestador;P=Prestador;A=Ambos
		or (ie_tipo_consultor_w = 'CO' AND (ie_classif_produto not in ('O', 'A')))--CO=Operadora;O=Operadora
		or (ie_tipo_consultor_w = 'PO' AND (ie_classif_produto not in ('O', 'P', 'A')))--PO=Prestador + OPS
		);

--Deletar as funções que estão no cadastro como inativas ou para Wheb ou TasySys ou código negativo
C05 CURSOR FOR
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
	or	not exists (SELECT 1 from proj_gest_conhecimento p where a.cd_funcao = p.cd_funcao))
	--or	nvl(ie_gestao_conhecimento, 'N') <> 'S')
	and	c.nr_seq_consultor = nr_seq_consultor_p;


BEGIN
if (nr_seq_consultor_p IS NOT NULL AND nr_seq_consultor_p::text <> '') then
	select	ie_tipo_consultor
	into STRICT	ie_tipo_consultor_w
	from	com_canal_consultor
	where	nr_sequencia = nr_seq_consultor_p;


	--Deletar as funções não pertencentes ao consultor
	open C04;
	loop
	fetch C04 into
		nr_seq_con_gest_fun_w;
	EXIT WHEN NOT FOUND; /* apply on C04 */
		begin
			delete
			from	com_cons_gest_con_fun
			where	nr_sequencia = nr_seq_con_gest_fun_w;
		end;
	end loop;
	close C04;

	--Deletar as funções inativas no cadastro de funções
	open C05;
	loop
	fetch C05 into
		nr_seq_con_gest_fun_w;
	EXIT WHEN NOT FOUND; /* apply on C05 */
		begin
			delete
			from	com_cons_gest_con_fun
			where	nr_sequencia = nr_seq_con_gest_fun_w;
		end;
	end loop;
	close C05;
end if;
	open C02;
	loop
	fetch C02 into
		nr_seq_modulo_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
	begin
		open C03;
		loop
		fetch C03 into
		qt_percentual;
		EXIT WHEN NOT FOUND; /* apply on C03 */
		begin
		if (qt_percentual = 0) then
			begin
			delete
			from	com_cons_gest_con_fun
			where	nr_seq_conhecimento = nr_seq_modulo_w;
			end;
		end if;
		end;
		end loop;
		close C03;
		end;
	end loop;
	close C02;

	open C01;
	loop
	fetch C01 into
		nr_seq_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		delete
		from	com_cons_gest_con_mod
		where	nr_sequencia = nr_seq_w;
		end;
	end loop;
	close C01;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE limpar_dup_mod_func ( nm_usuario_p text, nr_seq_consultor_p bigint default null) FROM PUBLIC;

