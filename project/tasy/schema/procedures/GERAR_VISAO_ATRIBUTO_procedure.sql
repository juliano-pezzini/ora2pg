-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_visao_atributo (nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


nm_atributo_w	varchar(50);
nm_tabela_w	varchar(50);




BEGIN

select	nm_tabela
into STRICT 	nm_tabela_w
from 	tabela_visao
where 	nr_sequencia = nr_sequencia_p;


insert into tabela_visao_atributo(nr_sequencia,
	nm_atributo,
	dt_atualizacao,
	nm_usuario,
	nr_seq_apresent,
	qt_tam_delphi,
	qt_tam_grid,
	qt_desloc_direita,
	nr_seq_grid,
	nr_seq_tabstop,
	ds_label,
	cd_exp_label,
	ds_label_grid,
	cd_exp_label_grid,
	vl_padrao,
	ds_mascara,
	ie_readonly,
	ie_tabstop,
	qt_altura,
	cd_dominio,
	nr_seq_localizador,
	ds_valores,
	cd_exp_valores,
	nr_seq_ordem,
	qt_coluna,
	ie_criar_descricao,
	ie_componente,
	nm_atributo_pai,
	ds_label_longo,
	cd_exp_label_longo,
	ds_cor,
	qt_tam_fonte,
	ds_estilo_fonte,
	ie_aplicabilidade_estilo,
	ie_tipo_botao)
(SELECT	nr_sequencia_p,
	c.nm_atributo,
	clock_timestamp(),
	nm_usuario_p,
	nr_seq_apresent,
	qt_tam_delphi,
	qt_tam_grid,
	qt_desloc_direita,
	nr_seq_grid,
	nr_seq_tabstop,
	ds_label,
	cd_exp_label,
	ds_label_grid,
	cd_exp_label_grid,
	vl_default,
	ds_mascara,
	ie_readonly,
	ie_tabstop,
	qt_altura,
	cd_dominio,
	nr_seq_localizador,
	ds_valores,
	cd_exp_valores,
	nr_seq_ordem,
	qt_coluna,
	ie_criar_descricao,
	ie_componente,
	nm_atributo_pai,
	ds_label_longo,
	cd_exp_label_longo,
	ds_cor,
	qt_tam_fonte,
	ds_estilo_fonte,
	ie_aplicabilidade_estilo,
	ie_tipo_botao
from	tabela_atributo c
where	c.nm_tabela = nm_tabela_w
and not exists (select	b.nm_atributo
	from	tabela_visao_atributo b
	where 	b.nr_sequencia = nr_sequencia_p
	and	b.nm_atributo = c.nm_atributo));

commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_visao_atributo (nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;
