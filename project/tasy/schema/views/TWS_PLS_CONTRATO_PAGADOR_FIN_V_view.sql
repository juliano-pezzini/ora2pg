-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW tws_pls_contrato_pagador_fin_v (nr_sequencia, dt_atualizacao, dt_fim_vigencia, nr_seq_forma_cobranca, nr_seq_pagador) AS select 	nr_sequencia,
	dt_atualizacao,
	dt_fim_vigencia,
	nr_seq_forma_cobranca,
	nr_seq_pagador
FROM	pls_contrato_pagador_fin;

