-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW tws_relatorio_parametro_v (nr_sequencia, dt_atualizacao, cd_parametro, ds_parametro, ie_tipo_atributo, ie_forma_apresent, qt_tamanho_campo, vl_padrao) AS select 	nr_sequencia,
	dt_atualizacao,
	cd_parametro,
	ds_parametro,
	ie_tipo_atributo,
	ie_forma_apresent,
	qt_tamanho_campo,
	vl_padrao
FROM	relatorio_parametro;

