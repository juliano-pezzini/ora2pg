-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW cih_infeccao_obito_v (dt_alta_interno, cd_clinica, dt_mes_alta, cd_estabelecimento, nr_obito_ih, nr_obito_ic, nr_obito_outra) AS select a.dt_alta_interno,
	a.cd_clinica,
       trunc(a.dt_alta_interno,'MONTH') dt_mes_alta,
	   a.cd_estabelecimento,
       count(distinct a.nr_ficha_ocorrencia) nr_obito_ih,
       0 nr_obito_ic,
	 0 nr_obito_outra
FROM cih_tipo_evolucao c,
     cih_infeccao_v b,
     cih_ficha_ocorrencia_v a
where a.nr_ficha_ocorrencia = b.nr_ficha_ocorrencia
  and a.cd_tipo_evolucao = c.cd_tipo_evolucao
  and b.nr_ih > 0
  and c.ie_obito_ih = 'H'
group by a.dt_alta_interno,
	a.cd_clinica,
       	 trunc(a.dt_alta_interno,'MONTH'),
		 a.cd_estabelecimento

union

select a.dt_alta_interno,
	a.cd_clinica,
       trunc(a.dt_alta_interno,'MONTH') dt_mes_alta,
	   a.cd_estabelecimento,
       0 nr_obito_ih,
       count(distinct a.nr_ficha_ocorrencia) nr_obito_ic,
	 0 nr_obito_outra
from cih_tipo_evolucao c,
     cih_infeccao_v b,
     cih_ficha_ocorrencia_v a
where a.nr_ficha_ocorrencia = b.nr_ficha_ocorrencia
  and a.cd_tipo_evolucao = c.cd_tipo_evolucao
  and b.nr_ic > 0
  and c.ie_obito_ih = 'C'
group by a.dt_alta_interno,
	a.cd_clinica,
       	 trunc(a.dt_alta_interno,'MONTH'),
		 a.cd_estabelecimento

union

select a.dt_alta_interno,
	a.cd_clinica,
       trunc(a.dt_alta_interno,'MONTH') dt_mes_alta,
	   a.cd_estabelecimento,
       0 nr_obito_ih,
       0 nr_obito_ic,
	 count(distinct a.nr_ficha_ocorrencia) nr_obito_outra
from cih_tipo_evolucao c,
     cih_infeccao_v b,
     cih_ficha_ocorrencia_v a
where a.nr_ficha_ocorrencia = b.nr_ficha_ocorrencia
  and a.cd_tipo_evolucao = c.cd_tipo_evolucao
  and c.ie_obito_ih = 'O'
group by a.dt_alta_interno,
	a.cd_clinica,
       	 trunc(a.dt_alta_interno,'MONTH'),
		 a.cd_estabelecimento;

