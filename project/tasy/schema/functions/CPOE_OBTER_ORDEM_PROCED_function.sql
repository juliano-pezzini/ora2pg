-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cpoe_obter_ordem_proced ( nr_seq_proc_interno_p cpoe_procedimento.nr_seq_proc_interno%type, cd_estabelecimento_p bigint, cd_perfil_p bigint, cd_setor_usuario_p bigint, nm_usuario_p text, ie_funcao_p text default 'C') RETURNS bigint AS $body$
DECLARE


/*
Tipos de procedimentos:
G	- Controle de glicemia
I	- Irrigação vesical contínua
L	- Coletas
P	- Procedimentos
*/
ie_tipo_w					proc_interno.ie_tipo%type;
ie_ivc_w					proc_interno.ie_ivc%type;
ie_ctrl_glic_w				proc_interno.ie_ctrl_glic%type;
nr_seq_exame_lab_w			proc_interno.nr_seq_exame_lab%type;

ie_tipo_proc_w				cpoe_regra_ordem_itens.ie_tipo_proc%type;
nr_seq_apresentacao_w		cpoe_regra_ordem_itens.nr_seq_apresentacao%type;

nr_seq_ordem_grupo_w		cpoe_regra_ordem_grupo.nr_sequencia%type;
nr_seq_ordem_subgrupo_w		cpoe_regra_ordem_subgrupo.nr_sequencia%type;

c01 CURSOR FOR
SELECT	b.nr_sequencia
from	cpoe_regra_ordem_lib_v a,
		cpoe_regra_ordem_grupo b,
		cpoe_regra_ordem_subgrupo c
where	a.nr_seq_regra_ordem = b.nr_seq_regra_ordem
and		c.nr_seq_ordem_grupo = b.nr_sequencia
and		b.ie_grupo = 'P'
and		coalesce(a.cd_estabelecimento, cd_estabelecimento_p) = cd_estabelecimento_p
and		coalesce(a.cd_setor_atendimento, cd_setor_usuario_p) = cd_setor_usuario_p
and		coalesce(a.nm_usuario_regra, nm_usuario_p) = nm_usuario_p
and		coalesce(a.cd_perfil, cd_perfil_p) = cd_perfil_p
and		coalesce(a.ie_situacao,'A') = 'A'
and (a.ie_funcao_cpoe = 'A' or a.ie_funcao_cpoe = ie_funcao_p)
order by	coalesce(a.nm_usuario_regra,'') desc,
			coalesce(a.cd_setor_atendimento,0),
			coalesce(a.cd_perfil,0),
			coalesce(a.cd_estabelecimento,0);


BEGIN

open c01;
loop
fetch c01 into nr_seq_ordem_grupo_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
end loop;
close c01;

select 	max(nr_sequencia)
into STRICT	nr_seq_ordem_subgrupo_w
from	cpoe_regra_ordem_subgrupo
where	nr_seq_ordem_grupo = nr_seq_ordem_grupo_w;

select	coalesce(ie_tipo,'O'),
		coalesce(ie_ivc,'N'),
		coalesce(ie_ctrl_glic,'NC'),
		nr_seq_exame_lab
into STRICT	ie_tipo_w,
		ie_ivc_w,
		ie_ctrl_glic_w,
		nr_seq_exame_lab_w
from	proc_interno
where	nr_sequencia = nr_seq_proc_interno_p;

if (ie_tipo_w not in ('G','BS')) and (ie_ivc_w = 'N') and (ie_ctrl_glic_w <> 'NC') then
	ie_tipo_proc_w := 'G';
elsif (ie_tipo_w not in ('G','BS')) and (ie_ivc_w = 'S') then
	ie_tipo_proc_w := 'I';
elsif (ie_tipo_w not in ('G','BS')) and (ie_ivc_w = 'N') and (ie_ctrl_glic_w <> 'CIG') and (nr_seq_exame_lab_w IS NOT NULL AND nr_seq_exame_lab_w::text <> '') then
	ie_tipo_proc_w := 'L';
else
	ie_tipo_proc_w := 'P';
end if;


select	coalesce(max(nr_seq_apresentacao),9999)
into STRICT	nr_seq_apresentacao_w
from	cpoe_regra_ordem_itens
where	nr_seq_ordem_subgrupo = nr_seq_ordem_subgrupo_w
and		ie_tipo_proc = ie_tipo_proc_w;

return coalesce(nr_seq_apresentacao_w,9999);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cpoe_obter_ordem_proced ( nr_seq_proc_interno_p cpoe_procedimento.nr_seq_proc_interno%type, cd_estabelecimento_p bigint, cd_perfil_p bigint, cd_setor_usuario_p bigint, nm_usuario_p text, ie_funcao_p text default 'C') FROM PUBLIC;

