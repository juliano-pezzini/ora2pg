-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW plusoft_motivo_manut_tabela_v (nr_sequencia, ds_motivo) AS select	nr_sequencia,
		ds_motivo
	FROM	pls_motivo_man_tab_preco
	where	ie_situacao = 'A'
	order by 1;
