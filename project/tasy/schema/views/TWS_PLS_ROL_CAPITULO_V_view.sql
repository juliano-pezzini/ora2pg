-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW tws_pls_rol_capitulo_v (nr_sequencia, dt_atualizacao, ds_capitulo, nr_seq_rol) AS select 	nr_sequencia,
	dt_atualizacao,
	ds_capitulo,
	nr_seq_rol
FROM 	pls_rol_capitulo;

