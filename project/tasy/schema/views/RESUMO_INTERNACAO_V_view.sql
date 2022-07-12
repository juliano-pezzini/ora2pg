-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW resumo_internacao_v (dt_registro, ie_tipo, ds_resumo, nr_atendimento) AS SELECT	a.DT_REGISTRO dt_registro,
		wheb_mensagem_pck.get_texto(308212) ie_tipo,
		a.DS_ORIENTACAO ds_resumo,
		a.nr_atendimento nr_atendimento
FROM 	ATENDIMENTO_ALTA a

UNION all

SELECT	a.DT_ATUALIZACAO_NREC dt_registro,
		wheb_mensagem_pck.get_texto(308212) ie_tipo,
		a.DS_RESUMO ds_resumo,
		b.nr_atendimento nr_atendimento
FROM 	ATEND_SUMARIO_ALTA_RESUMO a,
		ATEND_SUMARIO_ALTA b
where a.nr_seq_atend_sumario = b.nr_sequencia;

