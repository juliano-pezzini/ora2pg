-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW os_pendente_gerencia_v (nr_sequencia, nr_seq_gerencia, dt_ordem_servico, nr_seq_grupo_des, nr_seq_localizacao, cd_funcao, ie_plataforma, ie_terceiro) AS select	a.nr_sequencia,
	b.nr_Seq_gerencia,
	a.dt_ordem_servico,
	a.nr_seq_grupo_des,
	a.nr_seq_localizacao,
	a.cd_funcao,
	a.ie_plataforma,
	l.ie_terceiro
FROM man_localizacao l, man_estagio_processo c, man_ordem_servico a
LEFT OUTER JOIN grupo_desenvolvimento b ON (a.nr_seq_grupo_des = b.nr_sequencia)
WHERE c.nr_sequencia = a.nr_seq_estagio and l.nr_sequencia = a.nr_seq_localizacao and a.ie_status_ordem  <> '3' and (c.ie_tecnologia = 'S' or c.ie_desenv = 'S');
