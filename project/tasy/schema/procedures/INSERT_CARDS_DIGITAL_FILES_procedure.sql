-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE insert_cards_digital_files (nm_usuario_p text, ds_arquivo_p text, ie_opcao_p text) AS $body$
DECLARE


nr_sequencia_dashboard_w		bigint;
nr_total_w 				bigint;


BEGIN
	if (ie_opcao_p = 'D') then
		delete from dashboard_cards where nr_seq_dashboard = 551; commit;
	end if;

	SELECT 		count(1)
	into STRICT 		nr_total_w
	FROM 		dashboard_base
	WHERE 		nr_sequencia = 551;

	if (nr_total_w < 1)then
		INSERT INTO dashboard_base(nr_sequencia, dt_atualizacao, nm_usuario, dt_atualizacao_nrec, ds_nome, ds_descricao)
		       VALUES (551,clock_timestamp(), nm_usuario_p, clock_timestamp(), 'Ordem Compra', 'Arquivos digitalizados da ordem de compra');
		commit;
	end if;

	SELECT 		count(1)
	into STRICT 		nr_total_w
	FROM 		ind_base
	WHERE	 	nr_sequencia = 760;

	if (nr_total_w < 1)then
		INSERT INTO ind_base(nr_sequencia, dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, ds_indicador, nr_seq_ordem_serv, ie_padrao_sistema, ds_sql_where, ds_origem_inf, cd_exp_indicador, ds_objetivo, ie_situacao)
			values (760, clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p, 'Arquivos digitalizados', null, 'S', 'and', 'ordem_compra', 0, '', 'A');
		commit;
	end if;

	SELECT 		count(1)
	into STRICT 		nr_total_w
	FROM 		ind_informacao
	WHERE 		nr_sequencia = 3679;

	if (nr_total_w < 1)then
		INSERT INTO ind_informacao(nr_sequencia, dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, ds_informacao, nr_seq_indicador, ds_atributo, cd_exp_informacao, ds_objetivo) values (3679, clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p, 'Ordem compra', 760, 'DS_ARQUIVO', 0, '');
		commit;
	end if;


	SELECT count(1)
	into STRICT nr_total_w
	FROM ind_dimensao
	WHERE nr_sequencia = 4198;

	if (nr_total_w < 1)then
		insert into ind_dimensao(nr_sequencia, dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, ds_dimensao, nr_seq_indicador, ds_atributo, ds_sql_where, cd_exp_dimensao, ds_objetivo, nr_seq_dim_drill)
			                values (4198, clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p, 'Arquivos Digitalizados', 760, 'DS_ARQUIVO', 'and', 0, '', null);
		commit;
	end if;

	select 		coalesce(MAX(nr_sequencia), 0)
	into STRICT 		nr_sequencia_dashboard_w
	from  		dashboard_cards;

	insert into dashboard_cards(NR_SEQUENCIA, dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_dashboard, nr_seq_indicator, nr_seq_dimension, nr_seq_information, ds_title,   qt_colspan, qt_rowspan, ie_chart_type, ie_load_from_bi)
	      values (nr_sequencia_dashboard_w + 1, clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p, 551, 760, 4198, 3679, ds_arquivo_p, 1, 1, 'pie', 'N');

	commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE insert_cards_digital_files (nm_usuario_p text, ds_arquivo_p text, ie_opcao_p text) FROM PUBLIC;
