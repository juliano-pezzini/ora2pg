-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_analise_producao_medica_v (nr_seq_lote_conta, dt_mes_competencia, nr_seq_prestador, nr_seq_segurado, nr_guia, ds_tipo_conta) AS select	b.nr_seq_lote_conta,
	b.dt_mes_competencia,
	b.nr_seq_prestador,
	a.nr_seq_segurado,
	coalesce(a.cd_guia_referencia,a.cd_guia) nr_guia,
	substr(CASE WHEN pls_obter_tipo_conta(a.nr_sequencia)=1 THEN 'Consulta' WHEN pls_obter_tipo_conta(a.nr_sequencia)=2 THEN 'Internação' WHEN pls_obter_tipo_conta(a.nr_sequencia)=3 THEN 'SP/SADT' END ,1,120) ds_tipo_conta
FROM	pls_protocolo_conta b,
	pls_conta a
where	a.nr_seq_protocolo = b.nr_sequencia
and	b.ie_tipo_guia <> 6
group by coalesce(a.cd_guia_referencia,a.cd_guia), b.nr_seq_lote_conta,b.dt_mes_competencia,
	b.nr_seq_prestador,a.nr_seq_segurado,pls_obter_tipo_conta(a.nr_sequencia)
order by b.nr_seq_lote_conta, coalesce(a.cd_guia_referencia,a.cd_guia), a.nr_seq_segurado;

