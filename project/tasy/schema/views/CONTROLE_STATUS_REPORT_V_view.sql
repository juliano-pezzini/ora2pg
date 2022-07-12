-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW controle_status_report_v (nr_pendencia, nr_sequencia, ds_pendencia) AS select	2 nr_pendencia,
	a.nr_sequencia,
	substr(obter_valor_dominio(4959,2),1,255)ds_pendencia
FROM	proj_projeto a
where	exists (select 1
		from	proj_documento x
		where	x.nr_seq_proj = a.nr_sequencia
		and	obter_se_anexo_proj(nr_seq_proj) = 'N');

