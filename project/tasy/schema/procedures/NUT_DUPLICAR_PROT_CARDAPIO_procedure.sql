-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE nut_duplicar_prot_cardapio ( nr_seq_protocolo_p bigint, ie_terceirizado_p text) AS $body$
DECLARE


ds_protocolo_copia_w		varchar(255);

nr_seq_protocolo_novo_w		nut_cardapio_protocolo.nr_sequencia%type;
cd_estabelecimento_w		nut_cardapio_protocolo.cd_estabelecimento%type;
ds_protocolo_w			nut_cardapio_protocolo.ds_procotolo%type;
ie_situacao_w			nut_cardapio_protocolo.ie_situacao%type;

nr_seq_prot_opcao_w		nut_cardapio_prot_opcao.nr_sequencia%type;
nr_seq_prot_opcao_novo_w	nut_cardapio_prot_opcao.nr_sequencia%type;
nr_seq_grupo_producao_w		nut_cardapio_prot_opcao.nr_seq_grupo_producao%type;
cd_dieta_w			nut_cardapio_prot_opcao.cd_dieta%type;
nr_seq_opcao_w			nut_cardapio_prot_opcao.nr_seq_opcao%type;
nr_seq_local_w			nut_cardapio_prot_opcao.nr_seq_local%type;
nr_seq_servico_w		nut_cardapio_prot_opcao.nr_seq_servico%type;
qt_refeicao_opcao_w		nut_cardapio_prot_opcao.qt_refeicao%type;
ie_cardapio_padrao_w		nut_cardapio_prot_opcao.ie_cardapio_padrao%type;
ie_dia_semana_w			nut_cardapio_prot_opcao.ie_dia_semana%type;

nr_seq_prot_cardapio_w		nut_cardapio_prot_cardapio.nr_sequencia%type;
nr_seq_comp_w			nut_cardapio_prot_cardapio.nr_seq_comp%type;
nr_seq_receita_w		nut_cardapio_prot_cardapio.nr_seq_receita%type;
qt_refeicao_w			nut_cardapio_prot_cardapio.qt_refeicao%type;

nr_seq_prot_refeicao_w		nut_cardapio_prot_refeicao.nr_sequencia%type;
nr_seq_refeicao_w		nut_cardapio_prot_refeicao.nr_seq_refeicao%type;

c01 CURSOR FOR
	SELECT 	nr_seq_grupo_producao,
		cd_dieta,
		nr_seq_opcao,
		nr_seq_local,
		nr_seq_servico,
		qt_refeicao,
		ie_cardapio_padrao,
		nr_sequencia,
		ie_dia_semana
	from   	nut_cardapio_prot_opcao
	where  	nr_seq_protocolo = nr_seq_protocolo_p;

c02 CURSOR FOR
	SELECT	nr_seq_comp,
		nr_seq_receita,
		qt_refeicao
	from  	nut_cardapio_prot_cardapio
	where	nr_seq_prot_opcao = nr_seq_prot_opcao_w;

c03 CURSOR FOR
	SELECT	nr_seq_refeicao
	from	nut_cardapio_prot_refeicao
	where	nr_seq_prot_opcao = nr_seq_prot_opcao_w;


BEGIN

if (nr_seq_protocolo_p IS NOT NULL AND nr_seq_protocolo_p::text <> '')then

	select	nextval('nut_cardapio_protocolo_seq')
	into STRICT	nr_seq_protocolo_novo_w
	;

	select	substr(obter_texto_tasy(519917, null), 1 ,255)
	into STRICT	ds_protocolo_copia_w
	;

	-- Cuidado com o campo ds_procotolo, nome esta assim na tabela
	select 	cd_estabelecimento,
		substr(ds_procotolo,1, 254-length(ds_protocolo_copia_w)),
		ie_situacao
	into STRICT	cd_estabelecimento_w,
		ds_protocolo_w,
		ie_situacao_w
	from	nut_cardapio_protocolo
	where	nr_sequencia = nr_seq_protocolo_p;

	insert into nut_cardapio_protocolo(
		nr_sequencia,
		cd_estabelecimento,
		ds_procotolo,
		ie_situacao,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		dt_atualizacao,
		nm_usuario)
	values (nr_seq_protocolo_novo_w,
		cd_estabelecimento_w,
		ds_protocolo_copia_w ||' '|| ds_protocolo_w,
		ie_situacao_w,
		clock_timestamp(),
		wheb_usuario_pck.get_nm_usuario,
		clock_timestamp(),
		wheb_usuario_pck.get_nm_usuario);

	open	c01;
		loop
		fetch	c01 into
			nr_seq_grupo_producao_w,
			cd_dieta_w,
			nr_seq_opcao_w,
			nr_seq_local_w,
			nr_seq_servico_w,
			qt_refeicao_opcao_w,
			ie_cardapio_padrao_w,
			nr_seq_prot_opcao_w,
			ie_dia_semana_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */

		select	nextval('nut_cardapio_prot_opcao_seq')
		into STRICT	nr_seq_prot_opcao_novo_w
		;

		insert into nut_cardapio_prot_opcao(
			nr_sequencia,
			nr_seq_protocolo,
			nr_seq_grupo_producao,
			cd_dieta,
			nr_seq_opcao,
			nr_seq_local,
			nr_seq_servico,
			qt_refeicao,
			ie_cardapio_padrao,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			dt_atualizacao,
			nm_usuario,
			ie_dia_semana)
		values (	nr_seq_prot_opcao_novo_w,
			nr_seq_protocolo_novo_w,
			nr_seq_grupo_producao_w,
			cd_dieta_w,
			nr_seq_opcao_w,
			nr_seq_local_w,
			nr_seq_servico_w,
			qt_refeicao_opcao_w,
			ie_cardapio_padrao_w,
			clock_timestamp(),
			wheb_usuario_pck.get_nm_usuario,
			clock_timestamp(),
			wheb_usuario_pck.get_nm_usuario,
			ie_dia_semana_w);


		if (ie_terceirizado_p = 'S') then
			open	c03;
				loop
				fetch	c03 into
					nr_seq_refeicao_w;
				EXIT WHEN NOT FOUND; /* apply on c03 */

				insert into nut_cardapio_prot_refeicao(nr_sequencia,
					nr_seq_prot_opcao,
					nr_seq_refeicao,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					dt_atualizacao,
					nm_usuario)
				values (	nextval('nut_cardapio_prot_refeicao_seq'),
					nr_seq_prot_opcao_novo_w,
					nr_seq_refeicao_w,
					clock_timestamp(),
					wheb_usuario_pck.get_nm_usuario,
					clock_timestamp(),
					wheb_usuario_pck.get_nm_usuario);

			end loop;
			close c03;
		else
			open	c02;
				loop
				fetch	c02 into
					nr_seq_comp_w,
					nr_seq_receita_w,
					qt_refeicao_w;
				EXIT WHEN NOT FOUND; /* apply on c02 */

				insert into nut_cardapio_prot_cardapio(nr_sequencia,
					nr_seq_prot_opcao,
					nr_seq_comp,
					nr_seq_receita,
					qt_refeicao,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					dt_atualizacao,
					nm_usuario)
				values (	nextval('nut_cardapio_prot_cardapio_seq'),
					nr_seq_prot_opcao_novo_w,
					nr_seq_comp_w,
					nr_seq_receita_w,
					qt_refeicao_w,
					clock_timestamp(),
					wheb_usuario_pck.get_nm_usuario,
					clock_timestamp(),
					wheb_usuario_pck.get_nm_usuario);

			end loop;
			close c02;
		end if;

	end loop;
	close c01;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE nut_duplicar_prot_cardapio ( nr_seq_protocolo_p bigint, ie_terceirizado_p text) FROM PUBLIC;
