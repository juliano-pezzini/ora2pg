-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW adep_prescr_v (ie_tipo, nr_atendimento, nr_prescricao, cd_prescritor, nm_prescritor, dt_prescricao, dt_liberacao, dt_inicio_prescr, dt_validade_prescr, dt_assinatura, cd_pessoa_fisica) AS select	'M' ie_tipo,
	a.nr_atendimento nr_atendimento,
	a.nr_prescricao nr_prescricao,
	a.cd_prescritor cd_prescritor,
	substr(obter_nome_pf(a.cd_prescritor),1,60) nm_prescritor,
	a.dt_prescricao dt_prescricao,
	a.dt_liberacao dt_liberacao,
	a.dt_inicio_prescr dt_inicio_prescr,
	a.dt_validade_prescr dt_validade_prescr,
	OBTER_DATA_ASSINATURA_DIGITAL(a.nr_seq_assinatura) dt_assinatura,
	a.cd_pessoa_fisica
FROM	prescr_medica a
where	coalesce(a.ie_adep,'S') = 'S'
and	a.dt_liberacao is not null
--and	a.ie_origem_inf <> 1
union

select	'S' ie_tipo,
	b.nr_atendimento nr_atendimento,
	b.nr_sequencia nr_prescricao,
	b.cd_prescritor cd_prescritor,
	substr(obter_nome_pf(b.cd_prescritor),1,60) nm_prescritor,
	b.dt_prescricao dt_prescricao,
	b.dt_liberacao dt_liberacao,
	b.dt_inicio_prescr dt_inicio_prescr,
	b.dt_validade_prescr dt_validade_prescr,
	OBTER_DATA_ASSINATURA_DIGITAL(b.nr_seq_assinatura) dt_assinatura,
	b.cd_pessoa_fisica
from	pe_prescricao b
where	b.dt_liberacao is not null;

