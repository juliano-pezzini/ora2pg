-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW plussoft_agente_motiv_orig_v (nr_sequencia, nr_seq_agente_motivador, ds_origem_agente_motivador) AS select  nr_sequencia,
		nr_seq_agente_motivador,
		ds_origem_agente_motivador
	FROM	pls_agente_motivador_orig
	where	coalesce(ie_situacao,'A') = 'A';

