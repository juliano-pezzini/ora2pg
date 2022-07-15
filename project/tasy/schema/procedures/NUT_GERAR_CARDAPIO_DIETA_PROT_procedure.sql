-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE nut_gerar_cardapio_dieta_prot ( nr_seq_servico_p text, nr_seq_local_p text, ie_dia_semana_p bigint, nr_seq_opcao_p text, nr_seq_protocolo_p text, nr_seq_receita_p text ) AS $body$
DECLARE


nr_seq_prot_opcao_w		nut_cardapio_prot_opcao.nr_sequencia%type;
nr_seq_grupo_producao_w		nut_cardapio_prot_opcao.nr_seq_grupo_producao%type;
cd_dieta_w			nut_cardapio_prot_opcao.cd_dieta%type;
nr_seq_prot_cardapio_w		nut_cardapio_prot_cardapio.nr_Sequencia%type;
nr_seq_comp_w		      	nut_receita.nr_sequencia%type;

-- Dietas / Grupo de dietas
c01 CURSOR FOR
	SELECT 	cd_dieta,
		nr_seq_grupo
	from   	nut_dieta_rec
	where  	nr_seq_receita = nr_seq_receita_p;


BEGIN

if (nr_seq_protocolo_p IS NOT NULL AND nr_seq_protocolo_p::text <> '')then

	open	c01;
		loop
		fetch	c01 into
			cd_dieta_w,
			nr_seq_grupo_producao_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */

		-- verifica se já existe registro pra essa receita
		select 	max(nr_sequencia)
		into STRICT	nr_seq_prot_opcao_w
		from 	nut_cardapio_prot_opcao
		where 	nr_seq_servico = nr_seq_servico_p
		and	nr_seq_local = nr_seq_local_p
		and	ie_dia_semana =  ie_dia_semana_p
		and	nr_seq_protocolo = nr_seq_protocolo_p
		and    (((coalesce(nr_seq_grupo_producao::text, '') = '' and (cd_dieta IS NOT NULL AND cd_dieta::text <> '')) and (cd_dieta = cd_dieta_w)) or
		        ((coalesce(cd_dieta::text, '') = '' and (nr_seq_grupo_producao IS NOT NULL AND nr_seq_grupo_producao::text <> '')) and (nr_seq_grupo_producao = nr_seq_grupo_producao_w)));

		if (coalesce(nr_seq_prot_opcao_w::text, '') = '') then

			select	nextval('nut_cardapio_prot_opcao_seq')
			into STRICT	nr_seq_prot_opcao_w
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
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				dt_atualizacao,
				nm_usuario,
				ie_dia_semana,
				ie_cardapio_padrao)
			values (	nr_seq_prot_opcao_w,
				nr_seq_protocolo_p,
				nr_seq_grupo_producao_w,
				cd_dieta_w,
				nr_seq_opcao_p,
				nr_seq_local_p,
				nr_seq_servico_p,
				null,
				clock_timestamp(),
				wheb_usuario_pck.get_nm_usuario,
				clock_timestamp(),
				wheb_usuario_pck.get_nm_usuario,
				ie_dia_semana_p,
				'N');

		end if;

		SELECT 	nr_seq_composicao
		into STRICT 	nr_seq_comp_w
		FROM 	nut_receita
		WHERE nr_sequencia = nr_seq_receita_p;

		nr_seq_prot_cardapio_w := null;

		--Verifica se já existe
		select 	max(nr_sequencia)
		into STRICT   	nr_seq_prot_cardapio_w
		from 	nut_cardapio_prot_cardapio
		where 	nr_seq_receita = nr_seq_receita_p
		and	nr_seq_comp = nr_seq_comp_w
		and 	nr_seq_opcao = nr_seq_opcao_p
		and 	nr_seq_prot_opcao = nr_seq_prot_opcao_w;

		if (coalesce(nr_seq_prot_cardapio_w::text, '') = '') then

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
				nr_seq_prot_opcao_w,
				nr_seq_comp_w,
				nr_seq_receita_p,
				null,
				clock_timestamp(),
				wheb_usuario_pck.get_nm_usuario,
				clock_timestamp(),
				wheb_usuario_pck.get_nm_usuario);


		end if;

	end loop;
	close c01;

commit;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE nut_gerar_cardapio_dieta_prot ( nr_seq_servico_p text, nr_seq_local_p text, ie_dia_semana_p bigint, nr_seq_opcao_p text, nr_seq_protocolo_p text, nr_seq_receita_p text ) FROM PUBLIC;

