-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE rop_gerar_itens_inv_reposicao ( nr_sequencia_p bigint, ie_opcao_p bigint, nm_usuario_p text) AS $body$
DECLARE


/*ie_opcao_p
0 - Gerar itens conforme regra por setor*/
cd_estabelecimento_w			smallint;
cd_setor_atendimento_w			integer;
nr_seq_roupa_w				bigint;
qt_minimo_w				integer;
qt_maximo_w				integer;
nr_seq_kit_w				bigint;

c01 CURSOR FOR
SELECT	a.nr_seq_roupa,
	a.qt_minimo,
	a.qt_maximo
from	rop_regra_roupa_setor a
where	a.cd_estabelecimento	= cd_estabelecimento_w
and	a.cd_setor_atendimento	= cd_setor_atendimento_w
and	(a.nr_seq_roupa IS NOT NULL AND a.nr_seq_roupa::text <> '')
and not exists (
	SELECT	1
	from	rop_inv_reposicao_item x
	where	x.nr_seq_inventario	= nr_sequencia_p
	and	a.nr_seq_roupa		= x.nr_seq_roupa)

union

select	a.nr_seq_roupa,
	b.qt_minimo,
	b.qt_maximo
from	rop_regra_roupa_setor a,
	rop_regra_roupa_setores b
where	a.nr_sequencia = b.nr_seq_regra
and	a.cd_estabelecimento	= cd_estabelecimento_w
and	b.cd_setor_atendimento	= cd_setor_atendimento_w
and	a.cd_setor_atendimento <> b.cd_setor_atendimento
and	(a.nr_seq_roupa IS NOT NULL AND a.nr_seq_roupa::text <> '')
and not exists (
	select	1
	from	rop_inv_reposicao_item x
	where	x.nr_seq_inventario	= nr_sequencia_p
	and	a.nr_seq_roupa		= x.nr_seq_roupa);

c02 CURSOR FOR
SELECT	a.nr_seq_kit,
	a.qt_minimo,
	a.qt_maximo
from	rop_regra_roupa_setor a
where	a.cd_estabelecimento	= cd_estabelecimento_w
and	a.cd_setor_atendimento	= cd_setor_atendimento_w
and	(a.nr_seq_kit IS NOT NULL AND a.nr_seq_kit::text <> '')
and not exists (
	SELECT	1
	from	rop_inv_reposicao_item x
	where	x.nr_seq_inventario	= nr_sequencia_p
	and	a.nr_seq_kit		= x.nr_seq_kit)

union

select	a.nr_seq_kit,
	b.qt_minimo,
	b.qt_maximo
from	rop_regra_roupa_setor a,
	rop_regra_roupa_setores b
where	a.nr_sequencia = b.nr_seq_regra
and	a.cd_estabelecimento	= cd_estabelecimento_w
and	b.cd_setor_atendimento	= cd_setor_atendimento_w
and	a.cd_setor_atendimento <> b.cd_setor_atendimento
and	(a.nr_seq_kit IS NOT NULL AND a.nr_seq_kit::text <> '')
and not exists (
	select	1
	from	rop_inv_reposicao_item x
	where	x.nr_seq_inventario	= nr_sequencia_p
	and	a.nr_seq_roupa		= x.nr_seq_roupa);


BEGIN

select	cd_estabelecimento,
	cd_setor_atendimento
into STRICT	cd_estabelecimento_w,
	cd_setor_atendimento_w
from	rop_inv_reposicao
where	nr_sequencia = nr_sequencia_p;

if (ie_opcao_p = 0) then
	open C01;
	loop
	fetch C01 into
		nr_seq_roupa_w,
		qt_minimo_w,
		qt_maximo_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		insert into rop_inv_reposicao_item(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_inventario,
			nr_seq_roupa,
			qt_contagem,
			qt_minimo,
			qt_maximo,
			qt_repor)
		values (	nextval('rop_inv_reposicao_item_seq'),
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_sequencia_p,
			nr_seq_roupa_w,
			0,
			qt_minimo_w,
			qt_maximo_w,
			0);
		end;
	end loop;
	close C01;

	open C02;
	loop
	fetch C02 into
		nr_seq_kit_w,
		qt_minimo_w,
		qt_maximo_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin

		insert into rop_inv_reposicao_item(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_inventario,
			nr_seq_kit,
			qt_contagem,
			qt_minimo,
			qt_maximo,
			qt_repor)
		values (	nextval('rop_inv_reposicao_item_seq'),
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_sequencia_p,
			nr_seq_kit_w,
			0,
			qt_minimo_w,
			qt_maximo_w,
			0);
		end;
	end loop;
	close C02;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE rop_gerar_itens_inv_reposicao ( nr_sequencia_p bigint, ie_opcao_p bigint, nm_usuario_p text) FROM PUBLIC;

