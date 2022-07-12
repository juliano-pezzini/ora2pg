-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW valores_atend_paciente_v2 (nr_atendimento, tipo, codigo, ds_tipo, valor, cd_motivo_exc_conta, cd_conta_contabil, nr_lote_contabil, ie_origem_proced) AS select 	a.nr_atendimento,
	1 tipo,
	a.cd_procedimento codigo,
	p.ds_procedimento ds_tipo,
	a.vl_procedimento valor,
	a.cd_motivo_exc_conta,	
	a.cd_conta_contabil,
	a.nr_lote_contabil,
	a.ie_origem_proced
FROM 	procedimento p,
	procedimento_paciente a
where	p.cd_procedimento	= a.cd_procedimento
and	p.ie_origem_proced	= a.ie_origem_proced
and	coalesce(a.nr_lote_contabil,0) != 0
and	a.cd_conta_contabil is not null
and	a.cd_motivo_exc_conta is null

union all

select	a.nr_atendimento,
	2 tipo,	
	m.cd_material codigo,
	m.ds_material ds_tipo,
	a.vl_material valor,
	a.cd_motivo_exc_conta,
	a.cd_conta_contabil,
	a.nr_lote_contabil,
	null
from	material m,
	material_atend_paciente a
where	m.cd_material	= a.cd_material
and	coalesce(a.nr_lote_contabil,0) != 0
and	a.cd_conta_contabil is not null
and	a.cd_motivo_exc_conta is null;

