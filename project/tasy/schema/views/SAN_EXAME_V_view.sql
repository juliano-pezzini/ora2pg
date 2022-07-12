-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW san_exame_v (nr_seq_exame, nr_sequencia, dt_exame, ds_resultado, nr_ocor, nr_doac, nr_res, nr_transf, ie_exame, nm_paciente, nr_atendimento) AS select	c.nr_seq_exame,
	b.nr_sequencia,
	a.dt_doacao dt_exame,
	coalesce(ds_resultado, coalesce(to_char(vl_resultado), ie_resultado)) ds_resultado,
	1 nr_ocor,
	1 nr_doac,
	0 nr_res,
	0 nr_transf,
	1 ie_exame,
	substr(obter_nome_pf(a.CD_PESSOA_FISICA),1,255) nm_paciente,
	a.nr_atendimento nr_atendimento
FROM san_exame_realizado c,
     san_exame_lote b,
     san_doacao a
where a.nr_sequencia = b.nr_seq_doacao
  and b.nr_sequencia = c.nr_seq_exame_lote
  and somente_numero(a.nr_sangue) <> 0

union

select	c.nr_seq_exame,
	b.nr_sequencia,
	a.dt_transfusao,
	coalesce(ds_resultado, coalesce(to_char(vl_resultado), ie_resultado)) ds_resultado,
	1 nr_ocor,
	0,
	0,
	1 nr_transf,
	2 ie_exame,
	substr(obter_nome_pf(a.CD_PESSOA_FISICA),1,255) nm_paciente,
	a.nr_atendimento nr_atendimento
from san_exame_realizado c,
     san_exame_lote b,
     san_transfusao a
where a.nr_sequencia = b.nr_seq_transfusao
  and b.nr_sequencia = c.nr_seq_exame_lote
  and b.nr_seq_producao is null

union

select	c.nr_seq_exame,
	b.nr_sequencia,
	a.dt_transfusao,
	coalesce(ds_resultado, coalesce(to_char(vl_resultado), ie_resultado)) ds_resultado,
	1 nr_ocor,
	0,
	0,
	1 nr_transf,
	2 ie_exame,
	substr(coalesce(obter_nome_pf(san_obter_doador_producao(d.nr_sequencia)),obter_desc_expressao(892968)) ,1,255) nm_paciente,
	a.nr_atendimento nr_atendimento
from san_exame_realizado c,
     san_exame_lote b,
     san_producao d,
     san_transfusao a
where a.nr_sequencia = d.nr_seq_transfusao
  and d.nr_sequencia = b.nr_seq_producao
  and b.nr_sequencia = c.nr_seq_exame_lote
  and b.ie_origem = 'T'

union

select	c.nr_seq_exame,
	b.nr_sequencia,
	a.dt_cirurgia + 0.1,
	coalesce(ds_resultado, coalesce(to_char(vl_resultado), ie_resultado)) ds_resultado,
	1 nr_ocor,
	0,
	1 nr_res,
	0,
	3 ie_exame,
	substr(obter_nome_pf(a.CD_PESSOA_FISICA),1,255) nm_paciente,
	a.nr_atendimento nr_atendimento
from san_exame_realizado c,
     san_exame_lote b,
     san_reserva a
where a.nr_sequencia = b.nr_seq_reserva
  and b.nr_sequencia = c.nr_seq_exame_lote
  and b.nr_seq_res_prod is null

union

select	c.nr_seq_exame,
	b.nr_sequencia,
	a.dt_cirurgia + 0.1,
	coalesce(ds_resultado, coalesce(to_char(vl_resultado), ie_resultado)) ds_resultado,
	1 nr_ocor,
	0,
	1 nr_res,
	0,
	3 ie_exame,
	substr(coalesce(obter_nome_pf(san_obter_doador_producao(d.nr_seq_producao)),obter_desc_expressao(892968)) ,1,255) nm_paciente,
	a.nr_atendimento nr_atendimento
from san_exame_realizado c,
     san_exame_lote b,
     san_reserva_prod d,
     san_reserva a
where a.nr_sequencia = d.nr_seq_reserva
  and b.nr_seq_res_prod = d.nr_sequencia
  and b.nr_sequencia = c.nr_seq_exame_lote;

