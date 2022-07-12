-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION gedipa_obter_itens_reval (nr_seq_processo_p adep_processo.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE


cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type;
cd_setor_atendimento_w		setor_atendimento.cd_setor_atendimento%type;
cd_perfil_w					perfil.cd_perfil%type;
nm_usuario_w				usuario.nm_usuario%type;
dt_validacao_w				cpoe_revalidation_events.dt_validacao%type;
ds_retorno_w				varchar(4000);
ie_valida_regra_w			varchar(1);

cItens CURSOR FOR
SELECT	a.nr_sequencia nr_seq_horario,
		a.dt_horario dt_horario,
		b.nr_seq_mat_cpoe nr_seq_mat_cpoe,
		obter_desc_material(a.cd_material) nm_material
from	prescr_mat_hor a,
		prescr_material b
where	a.nr_prescricao = b.nr_prescricao
and		a.nr_seq_material = b.nr_sequencia
and		a.nr_seq_processo = nr_seq_processo_p
and		Obter_se_horario_liberado(a.dt_lib_horario, a.dt_horario) = 'S'
group by
		a.nr_sequencia,
		a.dt_horario,
		b.nr_seq_mat_cpoe,
		a.cd_material;
	
BEGIN
cd_setor_atendimento_w := wheb_usuario_pck.get_cd_setor_atendimento;
cd_perfil_w := wheb_usuario_pck.get_cd_perfil;
nm_usuario_w := wheb_usuario_pck.get_nm_usuario;
cd_estabelecimento_w := wheb_usuario_pck.get_cd_estabelecimento;

select	coalesce(max('S'),'N') ie_valida_regra
into STRICT	ie_valida_regra_w
from	cpoe_revalidation_rule a
where	coalesce(a.ie_situacao, 'A') = 'A'
and 	((coalesce(a.cd_setor_atendimento::text, '') = '') or (a.cd_setor_atendimento = cd_setor_atendimento_w))
and		((coalesce(a.cd_perfil::text, '') = '') or (a.cd_perfil = cd_perfil_w))
and		((coalesce(a.nm_usuario_regra::text, '') = '') or (a.nm_usuario_regra = nm_usuario_w))
and     ((coalesce(a.cd_estabelecimento::text, '') = '') or (a.cd_estabelecimento = cd_estabelecimento_w));

if (ie_valida_regra_w = 'S') then
	ds_retorno_w := '';
	for cItens_w in cItens loop
		begin
			select	max(a.dt_validacao)
			into STRICT	dt_validacao_w
			from	cpoe_revalidation_events a
			where	a.nr_seq_material = cItens_w.nr_seq_mat_cpoe;

			if ((dt_validacao_w IS NOT NULL AND dt_validacao_w::text <> '') and
				cItens_w.dt_horario > dt_validacao_w) then
					ds_retorno_w := ds_retorno_w || cItens_w.nm_material || chr(10);
				exit;
			end if;
		end;
	end loop;
end if;

if (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '') then
	ds_retorno_w := substr(obter_desc_expressao(963816, '') || chr(10) ||
					ds_retorno_w || obter_desc_expressao(963818, ''),1,2000);
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION gedipa_obter_itens_reval (nr_seq_processo_p adep_processo.nr_sequencia%type) FROM PUBLIC;

