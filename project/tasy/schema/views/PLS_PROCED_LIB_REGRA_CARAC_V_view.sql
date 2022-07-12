-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_proced_lib_regra_carac_v (nr_seq_regra, cd_procedimento, ie_origem_proced) AS select	item.nr_seq_regra,
	estrut.cd_procedimento,
	estrut.ie_origem_proced
FROM	pls_lib_item_regra_proc		item,
	estrutura_procedimento_v	estrut
where	item.cd_area_procedimento is not null
and	item.cd_especialidade is null
and	item.cd_grupo_proc is null
and	item.cd_procedimento is null
and	estrut.cd_area_procedimento = item.cd_area_procedimento

union

select	item.nr_seq_regra,
	estrut.cd_procedimento,
	estrut.ie_origem_proced
from	pls_lib_item_regra_proc		item,
	estrutura_procedimento_v	estrut
where	item.cd_area_procedimento is null
and	item.cd_especialidade is not null
and	item.cd_grupo_proc is null
and	item.cd_procedimento is null
and	estrut.cd_especialidade = item.cd_especialidade

union

select	item.nr_seq_regra,
	estrut.cd_procedimento,
	estrut.ie_origem_proced
from	pls_lib_item_regra_proc		item,
	estrutura_procedimento_v	estrut
where	item.cd_area_procedimento is null
and	item.cd_especialidade is null
and	item.cd_grupo_proc is not null
and	item.cd_procedimento is null
and	estrut.cd_grupo_proc = item.cd_grupo_proc

union

select	item.nr_seq_regra,
	item.cd_procedimento,
	item.ie_origem_proced
from	pls_lib_item_regra_proc		item
where	item.cd_area_procedimento is null
and	item.cd_especialidade is null
and	item.cd_grupo_proc is null
and	item.cd_procedimento is not null

union

select	item.nr_seq_regra,
	estrut.cd_procedimento,
	estrut.ie_origem_proced
from	pls_lib_item_regra_proc		item,
	estrutura_procedimento_v	estrut
where	item.cd_area_procedimento is null
and	item.cd_especialidade is null
and	item.cd_grupo_proc is null
and	item.cd_procedimento is null;
