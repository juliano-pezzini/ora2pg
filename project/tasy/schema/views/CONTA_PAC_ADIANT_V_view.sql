-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW conta_pac_adiant_v (ie_tipo, nr_atendimento, dt_adiantamento, nr_adiantamento, cd_tipo_recebimento, vl_disponivel, vl_saldo, vl_adiantamento, vl_especie, nr_interno_conta, ie_emite_conta) AS select	(OBTER_SALDO_ADIANTAMENTO_CONTA(a.nr_adiantamento,1))::numeric  ie_tipo,
	a.nr_atendimento,		 
	a.dt_adiantamento,		 
	a.nr_adiantamento,		 
	a.cd_tipo_recebimento,		 
	(OBTER_SALDO_ADIANTAMENTO_CONTA(a.nr_adiantamento,2))::numeric  vl_disponivel, 
	a.vl_saldo, 
	a.VL_ADIANTAMENTO, 
	a.VL_ESPECIE, 
	c.nr_interno_conta, 
	'14' ie_emite_conta 
FROM adiantamento a
LEFT OUTER JOIN conta_paciente c ON (a.nr_atendimento = c.nr_atendimento);

