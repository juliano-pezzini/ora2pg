-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lic_gerar_itens_recurso ( cd_estabelecimento_p bigint, nr_sequencia_p bigint, ie_opcao_p bigint, nr_seq_lic_item_p bigint, nm_usuario_p text) AS $body$
DECLARE


/* ie_opcao_p
0 = Somente os itens que foram selecionados na lista
1 = Todos os itens da licitação
2 = Somente os itens da regra do fornecedor*/
nr_seq_licitacao_w			bigint;
nr_seq_lic_item_w			integer;
cd_material_w			integer;
qt_existe_w			bigint;
nr_seq_parecer_w			bigint;
cd_cgc_fornec_w			varchar(14);
nr_seq_fornec_w			bigint;

c01 CURSOR FOR
SELECT	nr_seq_lic_item,
	cd_material
from	reg_lic_item
where	nr_seq_licitacao	= nr_seq_licitacao_w
and	ie_opcao_p	= 1
and	coalesce(nr_seq_lote::text, '') = ''

union all

select	nr_seq_lic_item,
	cd_material
from	reg_lic_item
where	nr_seq_licitacao	= nr_seq_licitacao_w
and	ie_opcao_p	= 2
and	coalesce(nr_seq_lote::text, '') = ''
and	obter_se_item_regra_fornec(cd_estabelecimento_p, cd_cgc_fornec_w, cd_material) = 'S';


BEGIN

select	a.nr_seq_licitacao,
	b.cd_cgc_fornec,
	a.nr_seq_fornec
into STRICT	nr_seq_licitacao_w,
	cd_cgc_fornec_w,
	nr_seq_fornec_w
from	reg_lic_recurso a,
	reg_lic_fornec b
where	a.nr_seq_fornec	= b.nr_sequencia
and	a.nr_sequencia = nr_sequencia_p;

if (ie_opcao_p = 0) then
	begin

	select	max(cd_material)
	into STRICT	cd_material_w
	from	reg_lic_item
	where	nr_seq_licitacao	= nr_seq_licitacao_w
	and	nr_seq_lic_item	= nr_seq_lic_item_p;


	insert into reg_lic_item_recurso(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_licitacao,
		nr_seq_recurso,
		nr_seq_lic_item,
		cd_material,
		ie_aceito)
	values (	nextval('reg_lic_item_recurso_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_licitacao_w,
		nr_sequencia_p,
		nr_seq_lic_item_p,
		cd_material_w,
		'P');
	end;

elsif (ie_opcao_p in (1,2)) then
	begin
	open C01;
	loop
	fetch C01 into
		nr_seq_lic_item_w,
		cd_material_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		select	count(*)
		into STRICT	qt_existe_w
		from	reg_lic_recurso a,
			reg_lic_item_recurso b
		where	a.nr_sequencia	= b.nr_seq_recurso
		and	b.nr_seq_lic_item	= nr_seq_lic_item_w
		and	a.nr_seq_fornec	= nr_seq_fornec_w;

		if (qt_existe_w = 0) then

			insert into reg_lic_item_recurso(
				nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_licitacao,
				nr_seq_recurso,
				nr_seq_lic_item,
				cd_material,
				ie_aceito)
			values (	nextval('reg_lic_item_recurso_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_licitacao_w,
				nr_sequencia_p,
				nr_seq_lic_item_w,
				cd_material_w,
				'P');
		end if;
		end;
	end loop;
	close C01;
	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lic_gerar_itens_recurso ( cd_estabelecimento_p bigint, nr_sequencia_p bigint, ie_opcao_p bigint, nr_seq_lic_item_p bigint, nm_usuario_p text) FROM PUBLIC;

