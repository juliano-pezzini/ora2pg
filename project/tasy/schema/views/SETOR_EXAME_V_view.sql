-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW setor_exame_v (ie_prioridade, cd_setor_atendimento, ds_setor_atendimento, cd_estabelecimento, cd_procedimento, ie_origem_proced, ds_procedimento, nm_curto, ds_prescricao, ds_prescricao_setor, ie_situacao) AS select 0 ie_prioridade,
	a.cd_setor_atendimento,
	a.ds_setor_atendimento,
	a.cd_estabelecimento_base cd_estabelecimento,
	p.cd_procedimento,
	p.ie_origem_proced,
	p.ds_procedimento,
	a.nm_curto,
	p.ds_prescricao,
	a.ds_prescricao ds_prescricao_setor,
	p.ie_situacao
FROM  setor_atendimento a,
      Procedimento p
where p.cd_setor_exclusivo      = a.cd_setor_atendimento

union all

select b.ie_prioridade,
	a.cd_setor_atendimento,
	a.ds_setor_atendimento,
	a.cd_estabelecimento_base cd_estabelecimento,
	b.cd_procedimento,
	b.ie_origem_proced,
	c.ds_procedimento,
	a.nm_curto,
	c.ds_prescricao,
	a.ds_prescricao ds_prescricao_setor,
	c.ie_situacao
from setor_atendimento a,
     procedimento c,
     procedimento_setor_atend b
where a.cd_setor_atendimento  = b.cd_setor_atendimento
  and b.cd_procedimento		= c.cd_procedimento
  and b.ie_origem_proced	= c.ie_origem_proced;

