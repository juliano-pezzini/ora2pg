-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cpoe_obter_se_programado ( nr_atendimento_p atendimento_paciente.nr_atendimento%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, cd_perfil_p perfil.cd_perfil%type, cd_setor_atendimento_p setor_atendimento.cd_setor_atendimento%type, cd_convenio_p convenio.cd_convenio%type, cd_material_p material.cd_material%type, nr_seq_proc_interno_p proc_interno.nr_sequencia%type) RETURNS bigint AS $body$
DECLARE


ie_tipo_item_w		cpoe_regra_dias_padroes.ie_tipo_item%type;
qt_dias_padrao_w	cpoe_regra_dias_padroes.qt_dias_padrao%type;


BEGIN

if (cd_material_p IS NOT NULL AND cd_material_p::text <> '') then
	ie_tipo_item_w := 'M';
else
	ie_tipo_item_w := 'P';
end if;

select 	coalesce(max(qt_dias_padrao),0)
into STRICT	qt_dias_padrao_w
from 	cpoe_regra_dias_padroes
where	ie_duracao = 'P'
and 	coalesce(cpoe_obter_lib_dia_padrao(nr_sequencia,
				      nr_atendimento_p, 
				      cd_estabelecimento_p, 
				      cd_perfil_p, 
				      ie_tipo_item_w, 
				      cd_setor_atendimento_p, 
				      cd_convenio_p, 
				      cd_material_p, 
				      nr_seq_proc_interno_p),'N') = 'S';

return qt_dias_padrao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cpoe_obter_se_programado ( nr_atendimento_p atendimento_paciente.nr_atendimento%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, cd_perfil_p perfil.cd_perfil%type, cd_setor_atendimento_p setor_atendimento.cd_setor_atendimento%type, cd_convenio_p convenio.cd_convenio%type, cd_material_p material.cd_material%type, nr_seq_proc_interno_p proc_interno.nr_sequencia%type) FROM PUBLIC;

