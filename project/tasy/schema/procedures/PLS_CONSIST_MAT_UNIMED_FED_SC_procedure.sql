-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_consist_mat_unimed_fed_sc ( nm_usuario_p text) AS $body$
DECLARE



cd_unidade_medida_w		varchar(30);
unid_med_atualizada_w		varchar(5);
ie_unidade_utilizacao_w		varchar(5);
ie_opme_w			varchar(1);
cd_simpro_w			bigint;
cd_fornecedor_fed_sc_w		bigint;
cd_grupo_estoque_w		bigint;
nr_seq_mat_unimed_w		bigint;
ie_possui_grupo_est_w		integer;
ie_possui_estrutura_w		integer;
ie_possui_fornec_w		integer;
ie_inconsistente_w		integer;
ie_possui_unid_medida_w		integer;
ie_possui_simpro_w		integer;
ie_inconsist_vinculo_w		integer;
ie_existe_unidade_simpro_w	integer;


C01 CURSOR FOR
SELECT	nr_sequencia,
	cd_grupo_estoque,
	cd_simpro
from	pls_mat_unimed_fed_sc;



BEGIN

open C01;
loop
fetch C01 into
	nr_seq_mat_unimed_w,
	cd_grupo_estoque_w,
	cd_simpro_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	ie_inconsistente_w	:= 0;
	ie_inconsist_vinculo_w	:= 0;

	delete from	pls_mat_unid_fed_sc_inc
	where		nr_seq_mat_unimed	= nr_seq_mat_unimed_w;

	--Verifica se o material está no Grupo de Estoque
	select	count(*)
	into STRICT	ie_possui_grupo_est_w
	from	pls_grupo_est_fed_sc
	where	cd_grupo_estoque	= cd_grupo_estoque_w;

	if (ie_possui_grupo_est_w	= 0) then
		insert into	pls_mat_unid_fed_sc_inc(nr_sequencia,
			nm_usuario,
			dt_atualizacao,
			nm_usuario_nrec,
			dt_atualizacao_nrec,
			ds_inconsistencia,
			ie_tipo_inconsistencia,
			nr_seq_mat_unimed)
		values (nextval('pls_mat_unid_fed_sc_inc_seq'),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			'O Grupo de Estoque deste material não está cadastrado. (Aba Federação SC -> Estrutura)',
			'GE',
			nr_seq_mat_unimed_w);

		ie_inconsist_vinculo_w	:= 1;

	end if;

	--Verifica se o material está na estrutura (Aba estrutura)
	select	count(*)
	into STRICT	ie_possui_estrutura_w
	from    pls_estrutura_material
	where   cd_externo  = to_char(cd_grupo_estoque_w);

	if (ie_possui_estrutura_w	= 0) then
		insert into	pls_mat_unid_fed_sc_inc(nr_sequencia,
			nm_usuario,
			dt_atualizacao,
			nm_usuario_nrec,
			dt_atualizacao_nrec,
			ds_inconsistencia,
			ie_tipo_inconsistencia,
			nr_seq_mat_unimed)
		values (nextval('pls_mat_unid_fed_sc_inc_seq'),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			'Não existe cadastro da Estrutura (Aba Estrutura)',
			'E',
			nr_seq_mat_unimed_w);

		ie_inconsistente_w	:= 1;

	end if;

	--Verifica se o material possui Unidade de Medida válida (cadastrada no sistema)
	select	trim(both ie_unidade_utilizacao)
	into STRICT	ie_unidade_utilizacao_w
	from	pls_mat_unimed_fed_sc
	where	nr_sequencia	= nr_seq_mat_unimed_w;

	select	max(cd_unidade_medida)
	into STRICT	cd_unidade_medida_w
	from	unidade_medida
	where	ie_situacao	= 'A'
	and	upper(cd_sistema_ant)	= upper(ie_unidade_utilizacao_w);

	if (coalesce(cd_unidade_medida_w::text, '') = '') then
		select	max(cd_unidade_medida)
		into STRICT	cd_unidade_medida_w
		from	unidade_medida
		where	ie_situacao	= 'A'
		and	upper(cd_unidade_medida)	= upper(ie_unidade_utilizacao_w);
	end if;

	if (coalesce(cd_unidade_medida_w::text, '') = '') then
		insert into	pls_mat_unid_fed_sc_inc(nr_sequencia,
			nm_usuario,
			dt_atualizacao,
			nm_usuario_nrec,
			dt_atualizacao_nrec,
			ds_inconsistencia,
			ie_tipo_inconsistencia,
			nr_seq_mat_unimed)
		values (nextval('pls_mat_unid_fed_sc_inc_seq'),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			'A unidade de medida não está cadastrada no sistema.',
			'E',
			nr_seq_mat_unimed_w);

		ie_inconsistente_w	:= 1;
	end if;

	--Verifica se existe um fornecedor para o preço do produto
	/*select	max(cd_fornecedor_fed_sc)
	into	cd_fornecedor_fed_sc_w
	from	pls_mat_uni_fed_sc_preco
	where	nr_seq_mat_unimed	= nr_seq_mat_unimed_w
	and	cd_fornecedor_fed_sc	is not null;

	if	(cd_fornecedor_fed_sc_w	is not null) then
		select	count(*)
		into	ie_possui_fornec_w
		from	pls_fornec_mat_fed_sc
		where	cd_fornecedor	= cd_fornecedor_fed_sc_w;
	else
		ie_possui_fornec_w	:= 1;
	end if;

	if	(ie_possui_fornec_w	= 0) then

		select	ie_opme
		into	ie_opme_w
		from	pls_mat_unimed_fed_sc
		where	nr_sequencia	= nr_seq_mat_unimed_w;

		if	(ie_opme_w = 'S') then
			ie_inconsistente_w	:= 1;
		end if;

		ds_erro_w	:= sqlerrm;
		ds_erro_w	:= 'Não foi importado o arquivo de fornecedores, isto impede o processo, favor verifique.';

		insert into	pls_mat_unid_fed_sc_inc
			(nr_sequencia,
			nm_usuario,
			dt_atualizacao,
			nm_usuario_nrec,
			dt_atualizacao_nrec,
			ds_inconsistencia,
			ie_tipo_inconsistencia,
			nr_seq_mat_unimed)
		values	(pls_mat_unid_fed_sc_inc_seq.nextval,
			nm_usuario_p,
			sysdate,
			nm_usuario_p,
			sysdate,
			'Existe(m) preço(s) sem o cadastro de fornecedor(es)',
			'UM',
			nr_seq_mat_unimed_w);

		ie_inconsist_vinculo_w	:= 1;
	end if;*/
	if (cd_simpro_w IS NOT NULL AND cd_simpro_w::text <> '') then
		--Verifica se Existe o cadastro do simpro do produto
		select	count(*)
		into STRICT	ie_possui_simpro_w
		from	simpro_cadastro
		where	cd_simpro	= cd_simpro_w;

		if (ie_possui_simpro_w = 0) then

			insert into	pls_mat_unid_fed_sc_inc(nr_sequencia,
				nm_usuario,
				dt_atualizacao,
				nm_usuario_nrec,
				dt_atualizacao_nrec,
				ds_inconsistencia,
				ie_tipo_inconsistencia,
				nr_seq_mat_unimed)
			values (nextval('pls_mat_unid_fed_sc_inc_seq'),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				'O Simpro do produto não está cadastrado.',
				'SI',
				nr_seq_mat_unimed_w);

			ie_inconsist_vinculo_w	:= 1;

		end if;
	end if;

	--Verifica se a unidade de medida importada é igual à cadastrada no sistema (verificação através do Simpro)
	if (cd_simpro_w IS NOT NULL AND cd_simpro_w::text <> '') then

		select	count(*)
		into STRICT	ie_existe_unidade_simpro_w
		from	simpro_preco
		where	cd_simpro		= cd_simpro_w
		and	upper(ie_tipo_fracao)	= upper(cd_unidade_medida_w);

		if (ie_existe_unidade_simpro_w	= 0) then
			insert into	pls_mat_unid_fed_sc_inc(nr_sequencia,
				nm_usuario,
				dt_atualizacao,
				nm_usuario_nrec,
				dt_atualizacao_nrec,
				ds_inconsistencia,
				ie_tipo_inconsistencia,
				nr_seq_mat_unimed)
			values (nextval('pls_mat_unid_fed_sc_inc_seq'),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				'A unidade de medida do produto não confere com a cadastrada no simpro.',
				'UDS',
				nr_seq_mat_unimed_w);

			ie_inconsist_vinculo_w	:= 1;
		end if;
	end if;

	--Cadastra o status de consistência
	if (ie_inconsistente_w = 1) then
		update	pls_mat_unimed_fed_sc
		set	ie_inconsistente	= 'S'
		where	nr_sequencia		= nr_seq_mat_unimed_w;

	elsif (ie_inconsist_vinculo_w	= 1) then
		update	pls_mat_unimed_fed_sc
		set	ie_inconsistente	= 'V'
		where	nr_sequencia		= nr_seq_mat_unimed_w;
	else
		update	pls_mat_unimed_fed_sc
		set	ie_inconsistente	= 'N'
		where	nr_sequencia		= nr_seq_mat_unimed_w;
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
-- REVOKE ALL ON PROCEDURE pls_consist_mat_unimed_fed_sc ( nm_usuario_p text) FROM PUBLIC;

