-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_reembolso_v (nr_seq_reembolso, nr_seq_protocolo, ie_tipo_segurado, dt_mes_comp_protocolo, vl_liquido, vl_liberado) AS select	/*+ index(b PLSPRCO_I2) */	a.nr_sequencia nr_seq_reembolso,
	a.nr_seq_protocolo,
	a.ie_tipo_segurado,
	b.dt_mes_competencia dt_mes_comp_protocolo,
	coalesce(a.vl_total,0) vl_liquido,
	coalesce(a.vl_total,0)  + coalesce(a.vl_coparticipacao,0) vl_liberado
FROM	pls_protocolo_conta	b,
	pls_conta		a
where	a.nr_seq_protocolo	= b.nr_sequencia
and	b.ie_tipo_protocolo	= 'R';

