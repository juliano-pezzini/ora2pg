-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW plussoft_motivo_recusa_v (nr_seq_motivo_recusa, ds_motivo_recusa) AS select	nr_sequencia	nr_seq_motivo_recusa,
		ds_motivo	ds_motivo_recusa
	FROM	pls_portab_motivo_recusa;

