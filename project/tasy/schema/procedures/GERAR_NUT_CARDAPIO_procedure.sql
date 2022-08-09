-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_nut_cardapio ( nr_sequencia_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w		bigint;
dt_cardapio_w		timestamp;
nr_seq_receita_w	bigint;
ds_receita_w		varchar(255);
qt_refeicao_w		bigint;
qt_g_pessoa_w		integer;
nr_seq_nut_cardapio_w	bigint;
qt_porcao_w		bigint;
qt_refeicao_real_w	bigint;
nr_seq_rec_duplo_w	bigint;


C01 CURSOR FOR
	SELECT	a.nr_seq_receita,
		a.nr_sequencia,
		coalesce(a.qt_porcao,0)
	from	nut_cardapio a
	where	a.nr_seq_card_dia = nr_sequencia_p
	and	not exists (	SELECT	1
				from	nut_receita_real b
				where	b.nr_seq_cardapio = a.nr_sequencia
				and	b.nr_seq_receita = a.nr_seq_receita);

C02 CURSOR FOR
	SELECT	nr_sequencia
	from	nut_receita_real
	where	nr_seq_cardapio = nr_seq_nut_cardapio_w;


BEGIN

open c01;
loop
	fetch c01 into
		nr_seq_receita_w,
		nr_seq_nut_cardapio_w,
		qt_porcao_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	open C02;
	loop
	fetch C02 into
		nr_seq_rec_duplo_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin

		delete	FROM nut_receita_real
		where	nr_sequencia = nr_seq_rec_duplo_w;

		end;
	end loop;
	close C02;

	select	dt_cardapio,
		QT_PESSOA_ATEND
	into STRICT	dt_cardapio_w,
		qt_refeicao_w
	from	nut_cardapio_dia
	where	nr_sequencia = nr_sequencia_p;

	select	nextval('nut_receita_real_seq')
	into STRICT	nr_sequencia_w
	;

	select	ds_receita, /*Bruna, OS102523 comentado a linha para gerar a quantidade de acordo com a informada no cardápio*/
--		qt_refeicao,
		qt_g_pessoa
	into STRICT	ds_receita_w,
--		qt_refeicao_w,
		qt_g_pessoa_w
	from	nut_receita
	where	nr_sequencia = nr_seq_receita_w;

	if (qt_porcao_w	> 0) then
		qt_refeicao_real_w	:= qt_porcao_w;
	else
		qt_refeicao_real_w	:= qt_refeicao_w;
	end if;

	insert into nut_receita_real(
		nr_sequencia,
		dt_receita,
		cd_estabelecimento,
		dt_atualizacao,
		nm_usuario,
		nr_seq_receita,
		qt_refeicao,
		ds_receita,
		qt_g_pessoa,
		nr_seq_cardapio)
	values (
		nr_sequencia_w,
		dt_cardapio_w,
		cd_estabelecimento_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_receita_w,
		qt_refeicao_real_w,
		ds_receita_w,
		qt_g_pessoa_w,
		nr_seq_nut_cardapio_w);

	CALL GERAR_COMPONENTES_REC_REAL(nm_usuario_p, nr_sequencia_w);
	end;
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_nut_cardapio ( nr_sequencia_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
