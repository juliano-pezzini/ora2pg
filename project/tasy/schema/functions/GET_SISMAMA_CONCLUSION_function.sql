-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_sismama_conclusion (nr_sequencia_sismama_p text, nr_categoria_p bigint, ie_lado_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(1) := 'N';
nr_sequencia_sismama_w	sismama_atendimento.nr_sequencia%type;
ie_pele_w		sismama_achado_rad.ie_pele%type;
ie_composicao_mama_w	sismama_achado_rad.ie_composicao_mama%type;
ie_nodulo1_w		sismama_achado_rad.ie_nodulo1%type;
ie_nodulo2_w		sismama_achado_rad.ie_nodulo2%type;
ie_nodulo3_w		sismama_achado_rad.ie_nodulo3%type;
ie_nod_localizacao1_w	sismama_achado_rad.ie_nod_localizacao1%type;
ie_nod_localizacao2_w	sismama_achado_rad.ie_nod_localizacao2%type;
ie_nod_localizacao3_w	sismama_achado_rad.ie_nod_localizacao3%type;
ie_nod_tamanho1_w	sismama_achado_rad.ie_nod_tamanho1%type;
ie_nod_tamanho2_w	sismama_achado_rad.ie_nod_tamanho2%type;
ie_nod_tamanho3_w	sismama_achado_rad.ie_nod_tamanho3%type;
ie_nod_contorno1_w	sismama_achado_rad.ie_nod_contorno1%type;
ie_nod_contorno2_w	sismama_achado_rad.ie_nod_contorno2%type;
ie_nod_contorno3_w	sismama_achado_rad.ie_nod_contorno3%type;
ie_nod_limite1_w	sismama_achado_rad.ie_nod_limite1%type;
ie_nod_limite2_w	sismama_achado_rad.ie_nod_limite2%type;
ie_nod_limite3_w	sismama_achado_rad.ie_nod_limite3%type;
ie_microcalcificacao1_w	sismama_achado_rad.ie_microcalcificacao1%type;
ie_microcalcificacao2_w	sismama_achado_rad.ie_microcalcificacao2%type;
ie_microcalcificacao3_w	sismama_achado_rad.ie_microcalcificacao3%type;
ie_micr_forma1_w	sismama_achado_rad.ie_micr_forma1%type;
ie_micr_forma2_w	sismama_achado_rad.ie_micr_forma2%type;
ie_micr_forma3_w	sismama_achado_rad.ie_micr_forma3%type;
ie_micr_distrib1_w	sismama_achado_rad.ie_micr_distrib1%type;
ie_micr_distrib2_w	sismama_achado_rad.ie_micr_distrib2%type;
ie_micr_distrib3_w	sismama_achado_rad.ie_micr_distrib3%type;
ie_micr_localizacao1_w	sismama_achado_rad.ie_micr_localizacao1%type;
ie_micr_localizacao2_w	sismama_achado_rad.ie_micr_localizacao2%type;
ie_micr_localizacao3_w	sismama_achado_rad.ie_micr_localizacao3%type;
ie_assim_focal1_w	sismama_achado_rad.ie_assim_focal1%type;
ie_assim_focal2_w	sismama_achado_rad.ie_assim_focal2%type;
ie_assim_difusa1_w	sismama_achado_rad.ie_assim_difusa1%type;
ie_assim_difusa2_w	sismama_achado_rad.ie_assim_difusa2%type;
ie_area_densa1_w	sismama_achado_rad.ie_area_densa1%type;
ie_area_densa2_w	sismama_achado_rad.ie_area_densa2%type;
ie_linf_visibilizado_w	sismama_achado_rad.ie_linf_visibilizado%type;
ie_linf_intramamario_w	sismama_achado_rad.ie_linf_intramamario%type;
ie_linf_confluentes_w	sismama_achado_rad.ie_linf_confluentes%type;
ie_linf_densos_w	sismama_achado_rad.ie_linf_densos%type;
ie_nod_dens_gordura_w	sismama_achado_rad.ie_nod_dens_gordura%type;
ie_calcificacao_vasc_w	sismama_achado_rad.ie_calcificacao_vasc%type;
ie_dist_arq_cirurg_w	sismama_achado_rad.ie_dist_arq_cirurg%type;
ie_dilatacao_ductal_w	sismama_achado_rad.ie_dilatacao_ductal%type;
ie_nod_calcificado_w	sismama_achado_rad.ie_nod_calcificado%type;
ie_implante_integro_w	sismama_achado_rad.ie_implante_integro%type;
ie_inf_aumentados_w	sismama_achado_rad.ie_inf_aumentados%type;
ie_nod_dens_het_w	sismama_achado_rad.ie_nod_dens_het%type;
ie_implante_ruptura_w	sismama_achado_rad.ie_implante_ruptura%type;
ie_outra_calcif_w	sismama_achado_rad.ie_outra_calcif%type;
ie_controle_rad_w	sismama_mam_ind_clinica.ie_controle_rad%type;
ie_lesao_diag_cancer_w	sismama_mam_ind_clinica.ie_lesao_diag_cancer%type;
ie_aval_qt_neo_adjuvante_w	sismama_mam_ind_clinica.ie_aval_qt_neo_adjuvante%type;
ie_radioterapia_w	sismama_anamnese_rad.ie_radioterapia%type;
ie_nao_fez_cirurgia_w	sismama_anamnese_rad.ie_nao_fez_cirurgia%type;


BEGIN

begin

	select 	a.nr_sequencia,
		ie_pele,
		ie_composicao_mama,
		ie_nodulo1,
		ie_nodulo2,
		ie_nodulo3,
		ie_nod_localizacao1,
		ie_nod_localizacao2,
		ie_nod_localizacao3,
		ie_nod_tamanho1,
		ie_nod_tamanho2,
		ie_nod_tamanho3,
		ie_nod_contorno1,
		ie_nod_contorno2,
		ie_nod_contorno3,
		ie_nod_limite1,
		ie_nod_limite2,
		ie_nod_limite3,
		ie_microcalcificacao1,
		ie_microcalcificacao2,
		ie_microcalcificacao3,
		ie_micr_forma1,
		ie_micr_forma2,
		ie_micr_forma3,
		ie_micr_distrib1,
		ie_micr_distrib2,
		ie_micr_distrib3,
		ie_micr_localizacao1,
		ie_micr_localizacao2,
		ie_micr_localizacao3,
		ie_assim_focal1,
		ie_assim_focal2,
		ie_assim_difusa1,
		ie_assim_difusa2,
		ie_area_densa1,
		ie_area_densa2,
		ie_linf_visibilizado,
		ie_linf_intramamario,
		ie_linf_confluentes,
		ie_linf_densos,
		ie_nod_dens_gordura,
		ie_calcificacao_vasc,
		ie_dist_arq_cirurg,
		ie_dilatacao_ductal,
		ie_nod_calcificado,
		ie_implante_integro,
		ie_inf_aumentados,
		ie_nod_dens_het,
		ie_implante_ruptura,
		ie_outra_calcif
	into STRICT	nr_sequencia_sismama_w,
		ie_pele_w,
		ie_composicao_mama_w,
		ie_nodulo1_w,
		ie_nodulo2_w,
		ie_nodulo3_w,
		ie_nod_localizacao1_w,
		ie_nod_localizacao2_w,
		ie_nod_localizacao3_w,
		ie_nod_tamanho1_w,
		ie_nod_tamanho2_w,
		ie_nod_tamanho3_w,
		ie_nod_contorno1_w,
		ie_nod_contorno2_w,
		ie_nod_contorno3_w,
		ie_nod_limite1_w,
		ie_nod_limite2_w,
		ie_nod_limite3_w,
		ie_microcalcificacao1_w,
		ie_microcalcificacao2_w,
		ie_microcalcificacao3_w,
		ie_micr_forma1_w,
		ie_micr_forma2_w,
		ie_micr_forma3_w,
		ie_micr_distrib1_w,
		ie_micr_distrib2_w,
		ie_micr_distrib3_w,
		ie_micr_localizacao1_w,
		ie_micr_localizacao2_w,
		ie_micr_localizacao3_w,
		ie_assim_focal1_w,
		ie_assim_focal2_w,
		ie_assim_difusa1_w,
		ie_assim_difusa2_w,
		ie_area_densa1_w,
		ie_area_densa2_w,
		ie_linf_visibilizado_w,
		ie_linf_intramamario_w,
		ie_linf_confluentes_w,
		ie_linf_densos_w,
		ie_nod_dens_gordura_w,
		ie_calcificacao_vasc_w,
		ie_dist_arq_cirurg_w,
		ie_dilatacao_ductal_w,
		ie_nod_calcificado_w,
		ie_implante_integro_w,
		ie_inf_aumentados_w,
		ie_nod_dens_het_w,
		ie_implante_ruptura_w,
		ie_outra_calcif_w
	from 	sismama_atendimento a,
		sismama_achado_rad b
	where 	a.nr_sequencia = b.nr_seq_sismama
	and 	a.nr_sequencia = nr_sequencia_sismama_p
	and	b.ie_lado = ie_lado_p;
	exception when others then
		nr_sequencia_sismama_w := null;
end;

if (coalesce(nr_sequencia_sismama_w::text, '') = '') then
        begin

        begin
                select 	a.nr_sequencia,
                        ie_pele,
                        ie_composicao_mama,
                        ie_nodulo1,
                        ie_nodulo2,
                        ie_nodulo3,
                        ie_nod_localizacao1,
                        ie_nod_localizacao2,
                        ie_nod_localizacao3,
                        ie_nod_tamanho1,
                        ie_nod_tamanho2,
                        ie_nod_tamanho3,
                        ie_nod_contorno1,
                        ie_nod_contorno2,
                        ie_nod_contorno3,
                        ie_nod_limite1,
                        ie_nod_limite2,
                        ie_nod_limite3,
                        ie_microcalcificacao1,
                        ie_microcalcificacao2,
                        ie_microcalcificacao3,
                        ie_micr_forma1,
                        ie_micr_forma2,
                        ie_micr_forma3,
                        ie_micr_distrib1,
                        ie_micr_distrib2,
                        ie_micr_distrib3,
                        ie_micr_localizacao1,
                        ie_micr_localizacao2,
                        ie_micr_localizacao3,
                        ie_assim_focal1,
                        ie_assim_focal2,
                        ie_assim_difusa1,
                        ie_assim_difusa2,
                        ie_area_densa1,
                        ie_area_densa2,
                        ie_linf_visibilizado,
                        ie_linf_intramamario,
                        ie_linf_confluentes,
                        ie_linf_densos,
                        ie_nod_dens_gordura,
                        ie_calcificacao_vasc,
                        ie_dist_arq_cirurg,
                        ie_dilatacao_ductal,
                        ie_nod_calcificado,
                        ie_implante_integro,
                        ie_inf_aumentados,
                        ie_nod_dens_het,
                        ie_implante_ruptura,
                        ie_outra_calcif
                into STRICT	nr_sequencia_sismama_w,
                        ie_pele_w,
                        ie_composicao_mama_w,
                        ie_nodulo1_w,
                        ie_nodulo2_w,
                        ie_nodulo3_w,
                        ie_nod_localizacao1_w,
                        ie_nod_localizacao2_w,
                        ie_nod_localizacao3_w,
                        ie_nod_tamanho1_w,
                        ie_nod_tamanho2_w,
                        ie_nod_tamanho3_w,
                        ie_nod_contorno1_w,
                        ie_nod_contorno2_w,
                        ie_nod_contorno3_w,
                        ie_nod_limite1_w,
                        ie_nod_limite2_w,
                        ie_nod_limite3_w,
                        ie_microcalcificacao1_w,
                        ie_microcalcificacao2_w,
                        ie_microcalcificacao3_w,
                        ie_micr_forma1_w,
                        ie_micr_forma2_w,
                        ie_micr_forma3_w,
                        ie_micr_distrib1_w,
                        ie_micr_distrib2_w,
                        ie_micr_distrib3_w,
                        ie_micr_localizacao1_w,
                        ie_micr_localizacao2_w,
                        ie_micr_localizacao3_w,
                        ie_assim_focal1_w,
                        ie_assim_focal2_w,
                        ie_assim_difusa1_w,
                        ie_assim_difusa2_w,
                        ie_area_densa1_w,
                        ie_area_densa2_w,
                        ie_linf_visibilizado_w,
                        ie_linf_intramamario_w,
                        ie_linf_confluentes_w,
                        ie_linf_densos_w,
                        ie_nod_dens_gordura_w,
                        ie_calcificacao_vasc_w,
                        ie_dist_arq_cirurg_w,
                        ie_dilatacao_ductal_w,
                        ie_nod_calcificado_w,
                        ie_implante_integro_w,
                        ie_inf_aumentados_w,
                        ie_nod_dens_het_w,
                        ie_implante_ruptura_w,
                        ie_outra_calcif_w
                from 	sismama_atendimento a,
                        sismama_ach_rad_siscan b
                where 	a.nr_sequencia = b.nr_seq_sismama
                and 	a.nr_sequencia = nr_sequencia_sismama_p
                and	b.ie_lado = ie_lado_p;
                exception when others then
                        nr_sequencia_sismama_w := null;
        end;

        end;
end if;

if (coalesce(nr_sequencia_sismama_w::text, '') = '') then
	return ds_retorno_w;
end if;

begin
	select	ie_radioterapia,
		ie_nao_fez_cirurgia
	into STRICT	ie_radioterapia_w,
		ie_nao_fez_cirurgia_w
	from	sismama_anamnese_rad
	where	nr_seq_sismama = nr_sequencia_sismama_w;
	exception when others then
		ie_radioterapia_w := null;
		ie_nao_fez_cirurgia_w := null;
end;

if (nr_categoria_p = 0) then

	if (ie_pele_w = 'N') then
		--cenario 19
		if	(((ie_nodulo1_w = 'S' and coalesce(ie_nod_localizacao1_w,'X') <> 'X' and coalesce(ie_nod_tamanho1_w,'0') <> '0' and  coalesce(ie_nod_contorno1_w,'X') in ('R','L') and coalesce(ie_nod_limite1_w,'X') <> 'X') or (ie_nodulo2_w = 'S' and coalesce(ie_nod_localizacao2_w,'X') <> 'X' and coalesce(ie_nod_tamanho2_w,'0') <> '0' and coalesce(ie_nod_contorno2_w,'X') in ('R','L') and coalesce(ie_nod_limite2_w,'X') <> 'X') or (ie_nodulo3_w = 'S' and coalesce(ie_nod_localizacao3_w,'X') <> 'X' and coalesce(ie_nod_tamanho3_w,'0') <> '0' and coalesce(ie_nod_contorno3_w,'X') in ('R','L') and coalesce(ie_nod_limite2_w,'X') <> 'X')) and (ie_linf_visibilizado_w = 'N' or ie_inf_aumentados_w = 'S') and
			((coalesce(ie_nod_dens_gordura_w,'N') <> 'S' and coalesce(ie_calcificacao_vasc_w,'N') <> 'S' and coalesce(ie_dist_arq_cirurg_w,'N') <> 'S' and coalesce(ie_nod_calcificado_w,'N') <> 'S' and coalesce(ie_implante_integro_w,'N') <> 'S' and coalesce(ie_nod_dens_het_w,'N') <> 'S' and coalesce(ie_nod_dens_het_w,'N') <> 'S' and coalesce(ie_linf_intramamario_w,'N') <> 'S' and coalesce(ie_implante_ruptura_w,'N') <> 'S' and coalesce(ie_outra_calcif_w,'N') <> 'S') or (ie_nod_dens_gordura_w = 'S' or ie_calcificacao_vasc_w = 'S' or ie_dist_arq_cirurg_w = 'S' or ie_nod_calcificado_w = 'S' or ie_implante_integro_w = 'S' or ie_nod_dens_het_w = 'S' or ie_nod_dens_het_w = 'S' or ie_linf_intramamario_w = 'S' or ie_implante_ruptura_w = 'S' or coalesce(ie_outra_calcif_w,'N') <> 'S'))) then
			ds_retorno_w := 'S';
		--cenario 20
		elsif	((ie_assim_focal1_w = 'S' or ie_assim_focal2_w = 'S' or ie_assim_difusa1_w = 'S' or ie_assim_difusa2_w = 'S' or ie_dilatacao_ductal_w = 'S') AND (ie_linf_visibilizado_w = 'N' or ie_inf_aumentados_w = 'S')) then
			ds_retorno_w := 'S';
		--cenario 21
		elsif	((coalesce(ie_nod_dens_gordura_w,'N') <> 'S' and coalesce(ie_calcificacao_vasc_w,'N') <> 'S' and coalesce(ie_dist_arq_cirurg_w,'N') <> 'S' and coalesce(ie_nod_calcificado_w,'N') <> 'S' and coalesce(ie_implante_integro_w,'N') <> 'S' and coalesce(ie_nod_dens_het_w,'N') <> 'S' and coalesce(ie_nod_dens_het_w,'N') <> 'S' and coalesce(ie_linf_intramamario_w,'N') <> 'S' and coalesce(ie_implante_ruptura_w,'N') <> 'S' and coalesce(ie_outra_calcif_w,'N') <> 'S') and (ie_inf_aumentados_w = 'S' or ie_linf_densos_w = 'S' or ie_linf_confluentes_w = 'S') and
			((coalesce(ie_nod_dens_gordura_w,'N') <> 'S' and coalesce(ie_calcificacao_vasc_w,'N') <> 'S' and coalesce(ie_dist_arq_cirurg_w,'N') <> 'S' and coalesce(ie_nod_calcificado_w,'N') <> 'S' and coalesce(ie_implante_integro_w,'N') <> 'S' and coalesce(ie_nod_dens_het_w,'N') <> 'S' and coalesce(ie_nod_dens_het_w,'N') <> 'S' and coalesce(ie_linf_intramamario_w,'N') <> 'S' and coalesce(ie_implante_ruptura_w,'N') <> 'S' and coalesce(ie_outra_calcif_w,'N') <> 'S') or (ie_nod_dens_gordura_w = 'S' or ie_calcificacao_vasc_w = 'S' or ie_dist_arq_cirurg_w = 'S' or ie_nod_calcificado_w = 'S' or ie_implante_integro_w = 'S' or ie_nod_dens_het_w = 'S' or ie_nod_dens_het_w = 'S' or ie_linf_intramamario_w = 'S' or ie_implante_ruptura_w = 'S' or coalesce(ie_outra_calcif_w,'N') <> 'S'))) then
			ds_retorno_w := 'S';
		end if;
	end if;

elsif (nr_categoria_p = 1) then

	--cenario 1
	if (ie_pele_w = 'N' and (coalesce(ie_nodulo1_w,'N') <> 'S' and coalesce(ie_nodulo2_w,'N') <> 'S' and coalesce(ie_nodulo3_w,'N') <> 'S' and coalesce(ie_microcalcificacao1_w,'N') <> 'S' and coalesce(ie_microcalcificacao2_w,'N') <> 'S' and coalesce(ie_microcalcificacao3_w,'N') <> 'S' and coalesce(ie_assim_focal1_w,'N') <> 'S' and coalesce(ie_assim_focal2_w,'N') <> 'S' and coalesce(ie_assim_difusa1_w,'N') <> 'S' and coalesce(ie_assim_difusa2_w,'N') <> 'S') and (ie_linf_visibilizado_w = 'N' or ie_inf_aumentados_w = 'S') and (coalesce(ie_nod_dens_gordura_w,'N') <> 'S' and coalesce(ie_calcificacao_vasc_w,'N') <> 'S' and coalesce(ie_dist_arq_cirurg_w,'N') <> 'S' and coalesce(ie_nod_calcificado_w,'N') <> 'S' and coalesce(ie_implante_integro_w,'N') <> 'S' and coalesce(ie_nod_dens_het_w,'N') <> 'S' and coalesce(ie_nod_dens_het_w,'N') <> 'S' and coalesce(ie_linf_intramamario_w,'N') <> 'S' and coalesce(ie_implante_ruptura_w,'N') <> 'S' and coalesce(ie_outra_calcif_w,'N') <> 'S')) then
		ds_retorno_w := 'S';
	end if;

elsif (nr_categoria_p = 2) then

	if (ie_pele_w = 'N') then
		--cenario 2
		if	((coalesce(ie_nodulo1_w,'N') <> 'S' and coalesce(ie_nodulo2_w,'N') <> 'S' and coalesce(ie_nodulo3_w,'N') <> 'S' and coalesce(ie_microcalcificacao1_w,'N') <> 'S' and coalesce(ie_microcalcificacao2_w,'N') <> 'S' and coalesce(ie_microcalcificacao3_w,'N') <> 'S' and coalesce(ie_assim_focal1_w,'N') <> 'S' and coalesce(ie_assim_focal2_w,'N') <> 'S' and coalesce(ie_assim_difusa1_w,'N') <> 'S' and coalesce(ie_assim_difusa2_w,'N') <> 'S') and (ie_linf_visibilizado_w = 'N' or ie_inf_aumentados_w = 'S') and (ie_nod_dens_gordura_w = 'S' or ie_calcificacao_vasc_w = 'S' or ie_dist_arq_cirurg_w = 'S' or ie_nod_calcificado_w = 'S' or ie_implante_integro_w = 'S' or ie_nod_dens_het_w = 'S' or ie_nod_dens_het_w = 'S' or ie_linf_intramamario_w = 'S' or ie_implante_ruptura_w = 'S' or coalesce(ie_outra_calcif_w,'N') <> 'S')) then
			ds_retorno_w := 'S';
		--cenario 4
		elsif	(((ie_nodulo1_w = 'S' and ie_nod_tamanho1_w = '1' and ie_nod_contorno1_w = 'l') or (ie_nodulo2_w = 'S' and ie_nod_tamanho2_w = '1' and ie_nod_contorno2_w = 'l')) or (ie_nodulo3_w = 'S' and ie_nod_tamanho3_w = '1' and ie_nod_contorno3_w = 'l') and (ie_linf_visibilizado_w = 'N' or ie_inf_aumentados_w = 'S') and
			((coalesce(ie_nod_dens_gordura_w,'N') <> 'S' and coalesce(ie_calcificacao_vasc_w,'N') <> 'S' and coalesce(ie_dist_arq_cirurg_w,'N') <> 'S' and coalesce(ie_nod_calcificado_w,'N') <> 'S' and coalesce(ie_implante_integro_w,'N') <> 'S' and coalesce(ie_nod_dens_het_w,'N') <> 'S' and coalesce(ie_nod_dens_het_w,'N') <> 'S' and coalesce(ie_linf_intramamario_w,'N') <> 'S' and coalesce(ie_implante_ruptura_w,'N') <> 'S' and coalesce(ie_outra_calcif_w,'N') <> 'S') or (ie_nod_dens_gordura_w = 'S' or ie_calcificacao_vasc_w = 'S' or ie_dist_arq_cirurg_w = 'S' or ie_nod_calcificado_w = 'S' or ie_implante_integro_w = 'S' or ie_nod_dens_het_w = 'S' or ie_nod_dens_het_w = 'S' or ie_linf_intramamario_w = 'S' or ie_implante_ruptura_w = 'S' or coalesce(ie_outra_calcif_w,'N') <> 'S'))) then

			select	ie_controle_rad
			into STRICT	ie_controle_rad_w
			from	sismama_mam_ind_clinica
			where	nr_seq_sismama = nr_sequencia_sismama_w;

			if (ie_controle_rad_w = 'S') then
				ds_retorno_w := 'S';
			end if;

		--cenario 5
		elsif	((coalesce(ie_nodulo1_w,'N') <> 'S' and coalesce(ie_nodulo2_w,'N') <> 'S' and coalesce(ie_nodulo3_w,'N') <> 'S' and coalesce(ie_microcalcificacao1_w,'N') <> 'S' and coalesce(ie_microcalcificacao2_w,'N') <> 'S' and coalesce(ie_microcalcificacao3_w,'N') <> 'S' and coalesce(ie_assim_focal1_w,'N') <> 'S' and coalesce(ie_assim_focal2_w,'N') <> 'S' and coalesce(ie_assim_difusa1_w,'N') <> 'S' and coalesce(ie_assim_difusa2_w,'N') <> 'S') and
			ie_inf_aumentados_w = 'S' and
			((coalesce(ie_nod_dens_gordura_w,'N') <> 'S' and coalesce(ie_calcificacao_vasc_w,'N') <> 'S' and coalesce(ie_dist_arq_cirurg_w,'N') <> 'S' and coalesce(ie_nod_calcificado_w,'N') <> 'S' and coalesce(ie_implante_integro_w,'N') <> 'S' and coalesce(ie_nod_dens_het_w,'N') <> 'S' and coalesce(ie_nod_dens_het_w,'N') <> 'S' and coalesce(ie_linf_intramamario_w,'N') <> 'S' and coalesce(ie_implante_ruptura_w,'N') <> 'S' and coalesce(ie_outra_calcif_w,'N') <> 'S') or (ie_nod_dens_gordura_w = 'S' or ie_calcificacao_vasc_w = 'S' or ie_dist_arq_cirurg_w = 'S' or ie_nod_calcificado_w = 'S' or ie_implante_integro_w = 'S' or ie_nod_dens_het_w = 'S' or ie_nod_dens_het_w = 'S' or ie_linf_intramamario_w = 'S' or ie_implante_ruptura_w = 'S' or coalesce(ie_outra_calcif_w,'N') <> 'S'))) then
			ds_retorno_w := 'S';
		end if;

	elsif (ie_pele_w in ('E', 'R')) then

		--cenario 3
		if	((coalesce(ie_nodulo1_w,'N') <> 'S' and coalesce(ie_nodulo2_w,'N') <> 'S' and coalesce(ie_nodulo3_w,'N') <> 'S' and coalesce(ie_microcalcificacao1_w,'N') <> 'S' and coalesce(ie_microcalcificacao2_w,'N') <> 'S' and coalesce(ie_microcalcificacao3_w,'N') <> 'S' and coalesce(ie_assim_focal1_w,'N') <> 'S' and coalesce(ie_assim_focal2_w,'N') <> 'S' and coalesce(ie_assim_difusa1_w,'N') <> 'S' and coalesce(ie_assim_difusa2_w,'N') <> 'S') and (ie_linf_visibilizado_w = 'N' or ie_inf_aumentados_w = 'S') and
			((coalesce(ie_nod_dens_gordura_w,'N') <> 'S' and coalesce(ie_calcificacao_vasc_w,'N') <> 'S' and coalesce(ie_dist_arq_cirurg_w,'N') <> 'S' and coalesce(ie_nod_calcificado_w,'N') <> 'S' and coalesce(ie_implante_integro_w,'N') <> 'S' and coalesce(ie_nod_dens_het_w,'N') <> 'S' and coalesce(ie_nod_dens_het_w,'N') <> 'S' and coalesce(ie_linf_intramamario_w,'N') <> 'S' and coalesce(ie_implante_ruptura_w,'N') <> 'S' and coalesce(ie_outra_calcif_w,'N') <> 'S') or (ie_nod_dens_gordura_w = 'S' or ie_calcificacao_vasc_w = 'S' or ie_dist_arq_cirurg_w = 'S' or ie_nod_calcificado_w = 'S' or ie_implante_integro_w = 'S' or ie_nod_dens_het_w = 'S' or ie_nod_dens_het_w = 'S' or ie_linf_intramamario_w = 'S' or ie_implante_ruptura_w = 'S' or coalesce(ie_outra_calcif_w,'N') <> 'S')) and (ie_radioterapia_w = 'S' or coalesce(ie_nao_fez_cirurgia_w,'N') = 'S')) then
			ds_retorno_w := 'S';
		end if;

	end if;

elsif (nr_categoria_p = 3) then

	if (ie_pele_w = 'N') then

		if (ie_composicao_mama_w in ('A', 'PA')) then

			--cenario 6
			if	((ie_nodulo1_w = 'S' and ie_nod_tamanho1_w = 1 and ie_nod_contorno1_w = 'R') or (ie_nodulo2_w = 'S' and ie_nod_tamanho2_w = 1 and ie_nod_contorno2_w = 'R') or (ie_nodulo3_w = 'S' and ie_nod_tamanho3_w = 1 and ie_nod_contorno3_w = 'R') and (ie_linf_visibilizado_w = 'N' or ie_inf_aumentados_w = 'S') and
				((coalesce(ie_nod_dens_gordura_w,'N') <> 'S' and coalesce(ie_calcificacao_vasc_w,'N') <> 'S' and coalesce(ie_dist_arq_cirurg_w,'N') <> 'S' and coalesce(ie_nod_calcificado_w,'N') <> 'S' and coalesce(ie_implante_integro_w,'N') <> 'S' and coalesce(ie_nod_dens_het_w,'N') <> 'S' and coalesce(ie_nod_dens_het_w,'N') <> 'S' and coalesce(ie_linf_intramamario_w,'N') <> 'S' and coalesce(ie_implante_ruptura_w,'N') <> 'S' and coalesce(ie_outra_calcif_w,'N') <> 'S') or (ie_nod_dens_gordura_w = 'S' or ie_calcificacao_vasc_w = 'S' or ie_dist_arq_cirurg_w = 'S' or ie_nod_calcificado_w = 'S' or ie_implante_integro_w = 'S' or ie_nod_dens_het_w = 'S' or ie_nod_dens_het_w = 'S' or ie_linf_intramamario_w = 'S' or ie_implante_ruptura_w = 'S' or coalesce(ie_outra_calcif_w,'N') <> 'S'))) then
				ds_retorno_w := 'S';
			end if;

		else

			--cenario 7
			if	(((ie_microcalcificacao1_w = 'S' and ie_micr_forma1_w = 'A' and ie_micr_distrib1_w = 'A') or (ie_microcalcificacao2_w = 'S' and ie_micr_forma2_w = 'A' and ie_micr_distrib2_w = 'A') or (ie_microcalcificacao3_w = 'S' and ie_micr_forma3_w = 'A' and ie_micr_distrib3_w = 'A')) and (ie_linf_visibilizado_w = 'N' or ie_inf_aumentados_w = 'S') and
				((coalesce(ie_nod_dens_gordura_w,'N') <> 'S' and coalesce(ie_calcificacao_vasc_w,'N') <> 'S' and coalesce(ie_dist_arq_cirurg_w,'N') <> 'S' and coalesce(ie_nod_calcificado_w,'N') <> 'S' and coalesce(ie_implante_integro_w,'N') <> 'S' and coalesce(ie_nod_dens_het_w,'N') <> 'S' and coalesce(ie_nod_dens_het_w,'N') <> 'S' and coalesce(ie_linf_intramamario_w,'N') <> 'S' and coalesce(ie_implante_ruptura_w,'N') <> 'S' and coalesce(ie_outra_calcif_w,'N') <> 'S') or (ie_nod_dens_gordura_w = 'S' or ie_calcificacao_vasc_w = 'S' or ie_dist_arq_cirurg_w = 'S' or ie_nod_calcificado_w = 'S' or ie_implante_integro_w = 'S' or ie_nod_dens_het_w = 'S' or ie_nod_dens_het_w = 'S' or ie_linf_intramamario_w = 'S' or ie_implante_ruptura_w = 'S' or coalesce(ie_outra_calcif_w,'N') <> 'S'))) then
				ds_retorno_w := 'S';
			end if;

			--cenario 8
			if	((ie_assim_focal1_w = 'S' or ie_assim_focal2_w = 'S' or ie_area_densa1_w = 'S' or ie_area_densa2_w = 'S' or ie_assim_difusa1_w = 'S' or ie_assim_difusa2_w = 'S' or ie_dilatacao_ductal_w = 'S') and (ie_linf_visibilizado_w = 'N' or ie_inf_aumentados_w = 'S') and
				((coalesce(ie_nod_dens_gordura_w,'N') <> 'S' and coalesce(ie_calcificacao_vasc_w,'N') <> 'S' and coalesce(ie_dist_arq_cirurg_w,'N') <> 'S' and coalesce(ie_nod_calcificado_w,'N') <> 'S' and coalesce(ie_implante_integro_w,'N') <> 'S' and coalesce(ie_nod_dens_het_w,'N') <> 'S' and coalesce(ie_nod_dens_het_w,'N') <> 'S' and coalesce(ie_linf_intramamario_w,'N') <> 'S' and coalesce(ie_implante_ruptura_w,'N') <> 'S' and coalesce(ie_outra_calcif_w,'N') <> 'S') or (ie_nod_dens_gordura_w = 'S' or ie_calcificacao_vasc_w = 'S' or ie_dist_arq_cirurg_w = 'S' or ie_nod_calcificado_w = 'S' or ie_implante_integro_w = 'S' or ie_nod_dens_het_w = 'S' or ie_nod_dens_het_w = 'S' or ie_linf_intramamario_w = 'S' or ie_implante_ruptura_w = 'S' or coalesce(ie_outra_calcif_w,'N') <> 'S'))) then
				ds_retorno_w := 'S';
			end if;

			--cenario 10
			if	(coalesce(ie_nodulo1_w,'N') <> 'S' and coalesce(ie_nodulo2_w,'N') <> 'S' and coalesce(ie_nodulo3_w,'N') <> 'S' and coalesce(ie_microcalcificacao1_w,'N') <> 'S' and coalesce(ie_microcalcificacao2_w,'N') <> 'S' and coalesce(ie_microcalcificacao3_w,'N') <> 'S' and coalesce(ie_assim_focal1_w,'N') <> 'S' and coalesce(ie_assim_focal2_w,'N') <> 'S' and coalesce(ie_assim_difusa1_w,'N') <> 'S' and coalesce(ie_assim_difusa2_w,'N') <> 'S' and
				ie_inf_aumentados_w = 'S' and
				((coalesce(ie_nod_dens_gordura_w,'N') <> 'S' and coalesce(ie_calcificacao_vasc_w,'N') <> 'S' and coalesce(ie_dist_arq_cirurg_w,'N') <> 'S' and coalesce(ie_nod_calcificado_w,'N') <> 'S' and coalesce(ie_implante_integro_w,'N') <> 'S' and coalesce(ie_nod_dens_het_w,'N') <> 'S' and coalesce(ie_nod_dens_het_w,'N') <> 'S' and coalesce(ie_linf_intramamario_w,'N') <> 'S' and coalesce(ie_implante_ruptura_w,'N') <> 'S' and coalesce(ie_outra_calcif_w,'N') <> 'S') or (ie_nod_dens_gordura_w = 'S' or ie_calcificacao_vasc_w = 'S' or ie_dist_arq_cirurg_w = 'S' or ie_nod_calcificado_w = 'S' or ie_implante_integro_w = 'S' or ie_nod_dens_het_w = 'S' or ie_nod_dens_het_w = 'S' or ie_linf_intramamario_w = 'S' or ie_implante_ruptura_w = 'S' or coalesce(ie_outra_calcif_w,'N') <> 'S'))) then
				ds_retorno_w := 'S';
			end if;

		end if;

	elsif (ie_pele_w IN ('E','R')) then

		--cenario 9
		if	(coalesce(ie_nodulo1_w,'N') <> 'S' and coalesce(ie_nodulo2_w,'N') <> 'S' and coalesce(ie_nodulo3_w,'N') <> 'S' and coalesce(ie_microcalcificacao1_w,'N') <> 'S' and coalesce(ie_microcalcificacao2_w,'N') <> 'S' and coalesce(ie_microcalcificacao3_w,'N') <> 'S' and coalesce(ie_assim_focal1_w,'N') <> 'S' and coalesce(ie_assim_focal2_w,'N') <> 'S' and coalesce(ie_assim_difusa1_w,'N') <> 'S' and coalesce(ie_assim_difusa2_w,'N') <> 'S' and (ie_linf_visibilizado_w = 'N' or ie_inf_aumentados_w = 'S') and
			((coalesce(ie_nod_dens_gordura_w,'N') <> 'S' and coalesce(ie_calcificacao_vasc_w,'N') <> 'S' and coalesce(ie_dist_arq_cirurg_w,'N') <> 'S' and coalesce(ie_nod_calcificado_w,'N') <> 'S' and coalesce(ie_implante_integro_w,'N') <> 'S' and coalesce(ie_nod_dens_het_w,'N') <> 'S' and coalesce(ie_nod_dens_het_w,'N') <> 'S' and coalesce(ie_linf_intramamario_w,'N') <> 'S' and coalesce(ie_implante_ruptura_w,'N') <> 'S' and coalesce(ie_outra_calcif_w,'N') <> 'S') or (ie_nod_dens_gordura_w = 'S' or ie_calcificacao_vasc_w = 'S' or ie_dist_arq_cirurg_w = 'S' or ie_nod_calcificado_w = 'S' or ie_implante_integro_w = 'S' or ie_nod_dens_het_w = 'S' or ie_nod_dens_het_w = 'S' or ie_linf_intramamario_w = 'S' or ie_implante_ruptura_w = 'S' or coalesce(ie_outra_calcif_w,'N') <> 'S')) and (ie_radioterapia_w = 'S' or coalesce(ie_nao_fez_cirurgia_w,'N') = 'S')) then
			ds_retorno_w := 'S';
		end if;

	end if;

elsif (nr_categoria_p = 4) then

	if (ie_pele_w = 'N') then

		--cenario 11
		if	(((ie_nodulo1_w = 'S' and ie_nod_contorno1_w in ('L','I')) or (ie_nodulo2_w = 'S' and ie_nod_contorno2_w in ('L','I')) or (ie_nodulo3_w = 'S' and ie_nod_contorno3_w in ('L','I'))) and (ie_linf_visibilizado_w = 'N' or ie_inf_aumentados_w = 'S') and
			((coalesce(ie_nod_dens_gordura_w,'N') <> 'S' and coalesce(ie_calcificacao_vasc_w,'N') <> 'S' and coalesce(ie_dist_arq_cirurg_w,'N') <> 'S' and coalesce(ie_nod_calcificado_w,'N') <> 'S' and coalesce(ie_implante_integro_w,'N') <> 'S' and coalesce(ie_nod_dens_het_w,'N') <> 'S' and coalesce(ie_nod_dens_het_w,'N') <> 'S' and coalesce(ie_linf_intramamario_w,'N') <> 'S' and coalesce(ie_implante_ruptura_w,'N') <> 'S' and coalesce(ie_outra_calcif_w,'N') <> 'S') or (ie_nod_dens_gordura_w = 'S' or ie_calcificacao_vasc_w = 'S' or ie_dist_arq_cirurg_w = 'S' or ie_nod_calcificado_w = 'S' or ie_implante_integro_w = 'S' or ie_nod_dens_het_w = 'S' or ie_nod_dens_het_w = 'S' or ie_linf_intramamario_w = 'S' or ie_implante_ruptura_w = 'S' or coalesce(ie_outra_calcif_w,'N') <> 'S'))) then
			ds_retorno_w := 'S';
		end if;

		--cenario 12
		if	(((ie_microcalcificacao1_w = 'S' and coalesce(ie_micr_localizacao1_w,'0') <> '0' and ((ie_micr_forma1_w = 'A' and ie_micr_distrib1_w = 'S') or (ie_micr_forma1_w = 'P' and ie_micr_distrib1_w in ('A','S')) or (ie_micr_forma1_w = 'I' and ie_micr_distrib1_w in ('A','S')))) or
			(ie_microcalcificacao2_w = 'S' and coalesce(ie_micr_localizacao2_w,'0') <> '0' and ((ie_micr_forma2_w = 'A' and ie_micr_distrib2_w = 'S') or (ie_micr_forma2_w = 'P' and ie_micr_distrib2_w in ('A','S')) or (ie_micr_forma2_w = 'I' and ie_micr_distrib2_w in ('A','S')))) or
			(ie_microcalcificacao3_w = 'S' and coalesce(ie_micr_localizacao3_w,'0') <> '0' and ((ie_micr_forma3_w = 'A' and ie_micr_distrib3_w = 'S') or (ie_micr_forma3_w = 'P' and ie_micr_distrib3_w in ('A','S')) or (ie_micr_forma3_w = 'I' and ie_micr_distrib3_w in ('A','S'))))) and (ie_linf_visibilizado_w = 'N' or ie_inf_aumentados_w = 'S') and
			((coalesce(ie_nod_dens_gordura_w,'N') <> 'S' and coalesce(ie_calcificacao_vasc_w,'N') <> 'S' and coalesce(ie_dist_arq_cirurg_w,'N') <> 'S' and coalesce(ie_nod_calcificado_w,'N') <> 'S' and coalesce(ie_implante_integro_w,'N') <> 'S' and coalesce(ie_nod_dens_het_w,'N') <> 'S' and coalesce(ie_nod_dens_het_w,'N') <> 'S' and coalesce(ie_linf_intramamario_w,'N') <> 'S' and coalesce(ie_implante_ruptura_w,'N') <> 'S' and coalesce(ie_outra_calcif_w,'N') <> 'S') or (ie_nod_dens_gordura_w = 'S' or ie_calcificacao_vasc_w = 'S' or ie_dist_arq_cirurg_w = 'S' or ie_nod_calcificado_w = 'S' or ie_implante_integro_w = 'S' or ie_nod_dens_het_w = 'S' or ie_nod_dens_het_w = 'S' or ie_linf_intramamario_w = 'S' or ie_implante_ruptura_w = 'S' or coalesce(ie_outra_calcif_w,'N') <> 'S'))) then
			ds_retorno_w := 'S';
		end if;

		--cenario 13
		if	((ie_assim_focal1_w = 'S' or ie_assim_focal2_w = 'S' or ie_assim_difusa1_w = 'S' or ie_assim_difusa2_w = 'S' or ie_dilatacao_ductal_w = 'S') and (ie_linf_visibilizado_w = 'N' or ie_inf_aumentados_w = 'S') and
			((coalesce(ie_nod_dens_gordura_w,'N') <> 'S' and coalesce(ie_calcificacao_vasc_w,'N') <> 'S' and coalesce(ie_dist_arq_cirurg_w,'N') <> 'S' and coalesce(ie_nod_calcificado_w,'N') <> 'S' and coalesce(ie_implante_integro_w,'N') <> 'S' and coalesce(ie_nod_dens_het_w,'N') <> 'S' and coalesce(ie_nod_dens_het_w,'N') <> 'S' and coalesce(ie_linf_intramamario_w,'N') <> 'S' and coalesce(ie_implante_ruptura_w,'N') <> 'S' and coalesce(ie_outra_calcif_w,'N') <> 'S') or (ie_nod_dens_gordura_w = 'S' or ie_calcificacao_vasc_w = 'S' or ie_dist_arq_cirurg_w = 'S' or ie_nod_calcificado_w = 'S' or ie_implante_integro_w = 'S' or ie_nod_dens_het_w = 'S' or ie_nod_dens_het_w = 'S' or ie_linf_intramamario_w = 'S' or ie_implante_ruptura_w = 'S' or coalesce(ie_outra_calcif_w,'N') <> 'S'))) then
			ds_retorno_w := 'S';
		end if;

		--cenario 15
		if	((coalesce(ie_nodulo1_w,'N') <> 'S' and coalesce(ie_nodulo2_w,'N') <> 'S' and coalesce(ie_nodulo3_w,'N') <> 'S' and coalesce(ie_microcalcificacao1_w,'N') <> 'S' and coalesce(ie_microcalcificacao2_w,'N') <> 'S' and coalesce(ie_microcalcificacao3_w,'N') <> 'S' and coalesce(ie_assim_focal1_w,'N') <> 'S' and coalesce(ie_assim_focal2_w,'N') <> 'S' and coalesce(ie_assim_difusa1_w,'N') <> 'S' and coalesce(ie_assim_difusa2_w,'N') <> 'S') and (ie_inf_aumentados_w = 'S' or ie_linf_densos_w = 'S' or ie_linf_confluentes_w = 'S') and
			((coalesce(ie_nod_dens_gordura_w,'N') <> 'S' and coalesce(ie_calcificacao_vasc_w,'N') <> 'S' and coalesce(ie_dist_arq_cirurg_w,'N') <> 'S' and coalesce(ie_nod_calcificado_w,'N') <> 'S' and coalesce(ie_implante_integro_w,'N') <> 'S' and coalesce(ie_nod_dens_het_w,'N') <> 'S' and coalesce(ie_nod_dens_het_w,'N') <> 'S' and coalesce(ie_linf_intramamario_w,'N') <> 'S' and coalesce(ie_implante_ruptura_w,'N') <> 'S' and coalesce(ie_outra_calcif_w,'N') <> 'S') or (ie_nod_dens_gordura_w = 'S' or ie_calcificacao_vasc_w = 'S' or ie_dist_arq_cirurg_w = 'S' or ie_nod_calcificado_w = 'S' or ie_implante_integro_w = 'S' or ie_nod_dens_het_w = 'S' or ie_nod_dens_het_w = 'S' or ie_linf_intramamario_w = 'S' or ie_implante_ruptura_w = 'S' or coalesce(ie_outra_calcif_w,'N') <> 'S'))) then
			ds_retorno_w := 'S';
		end if;

	elsif (ie_pele_w in ('E','R')) then
		--cenario 14
		if	((coalesce(ie_nodulo1_w,'N') <> 'S' and coalesce(ie_nodulo2_w,'N') <> 'S' and coalesce(ie_nodulo3_w,'N') <> 'S' and coalesce(ie_microcalcificacao1_w,'N') <> 'S' and coalesce(ie_microcalcificacao2_w,'N') <> 'S' and coalesce(ie_microcalcificacao3_w,'N') <> 'S' and coalesce(ie_assim_focal1_w,'N') <> 'S' and coalesce(ie_assim_focal2_w,'N') <> 'S' and coalesce(ie_assim_difusa1_w,'N') <> 'S' and coalesce(ie_assim_difusa2_w,'N') <> 'S') and (ie_linf_visibilizado_w = 'N' or ie_inf_aumentados_w = 'S') and
			((coalesce(ie_nod_dens_gordura_w,'N') <> 'S' and coalesce(ie_calcificacao_vasc_w,'N') <> 'S' and coalesce(ie_dist_arq_cirurg_w,'N') <> 'S' and coalesce(ie_nod_calcificado_w,'N') <> 'S' and coalesce(ie_implante_integro_w,'N') <> 'S' and coalesce(ie_nod_dens_het_w,'N') <> 'S' and coalesce(ie_nod_dens_het_w,'N') <> 'S' and coalesce(ie_linf_intramamario_w,'N') <> 'S' and coalesce(ie_implante_ruptura_w,'N') <> 'S' and coalesce(ie_outra_calcif_w,'N') <> 'S') or (ie_nod_dens_gordura_w = 'S' or ie_calcificacao_vasc_w = 'S' or ie_dist_arq_cirurg_w = 'S' or ie_nod_calcificado_w = 'S' or ie_implante_integro_w = 'S' or ie_nod_dens_het_w = 'S' or ie_nod_dens_het_w = 'S' or ie_linf_intramamario_w = 'S' or ie_implante_ruptura_w = 'S' or coalesce(ie_outra_calcif_w,'N') <> 'S')) and (ie_radioterapia_w = 'S' or coalesce(ie_nao_fez_cirurgia_w,'N') = 'S')) then
			ds_retorno_w := 'S';
		end if;
	end if;

elsif (nr_categoria_p = 5) then

	if (ie_pele_w = 'N') then
		--cenario 16
		if	(((ie_nodulo1_w = 'S' and coalesce(ie_nod_localizacao1_w,'X') <> 'X' and coalesce(ie_nod_tamanho1_w,'0') <> '0' and  coalesce(ie_nod_contorno1_w,'X') = 'E' and coalesce(ie_nod_limite1_w,'X') <> 'X') or (ie_nodulo2_w = 'S' and coalesce(ie_nod_localizacao2_w,'X') <> 'X' and coalesce(ie_nod_tamanho2_w,'0') <> '0' and coalesce(ie_nod_contorno2_w,'X') = 'E' and coalesce(ie_nod_limite2_w,'X') <> 'X') or (ie_nodulo3_w = 'S' and coalesce(ie_nod_localizacao3_w,'X') <> 'X' and coalesce(ie_nod_tamanho3_w,'0') <> '0' and coalesce(ie_nod_contorno3_w,'X') = 'E' and coalesce(ie_nod_limite2_w,'X') <> 'X')) and (ie_linf_visibilizado_w = 'N' or ie_inf_aumentados_w = 'S') and
			((coalesce(ie_nod_dens_gordura_w,'N') <> 'S' and coalesce(ie_calcificacao_vasc_w,'N') <> 'S' and coalesce(ie_dist_arq_cirurg_w,'N') <> 'S' and coalesce(ie_nod_calcificado_w,'N') <> 'S' and coalesce(ie_implante_integro_w,'N') <> 'S' and coalesce(ie_nod_dens_het_w,'N') <> 'S' and coalesce(ie_nod_dens_het_w,'N') <> 'S' and coalesce(ie_linf_intramamario_w,'N') <> 'S' and coalesce(ie_implante_ruptura_w,'N') <> 'S' and coalesce(ie_outra_calcif_w,'N') <> 'S') or (ie_nod_dens_gordura_w = 'S' or ie_calcificacao_vasc_w = 'S' or ie_dist_arq_cirurg_w = 'S' or ie_nod_calcificado_w = 'S' or ie_implante_integro_w = 'S' or ie_nod_dens_het_w = 'S' or ie_nod_dens_het_w = 'S' or ie_linf_intramamario_w = 'S' or ie_implante_ruptura_w = 'S' or coalesce(ie_outra_calcif_w,'N') <> 'S'))) then
			ds_retorno_w := 'S';
		end if;

		--cenario 17
		if	((ie_microcalcificacao1_w = 'S' or ie_microcalcificacao2_w = 'S' or ie_microcalcificacao3_w = 'S') and (ie_linf_visibilizado_w = 'N' or ie_inf_aumentados_w = 'S') and
			((coalesce(ie_nod_dens_gordura_w,'N') <> 'S' and coalesce(ie_calcificacao_vasc_w,'N') <> 'S' and coalesce(ie_dist_arq_cirurg_w,'N') <> 'S' and coalesce(ie_nod_calcificado_w,'N') <> 'S' and coalesce(ie_implante_integro_w,'N') <> 'S' and coalesce(ie_nod_dens_het_w,'N') <> 'S' and coalesce(ie_nod_dens_het_w,'N') <> 'S' and coalesce(ie_linf_intramamario_w,'N') <> 'S' and coalesce(ie_implante_ruptura_w,'N') <> 'S' and coalesce(ie_outra_calcif_w,'N') <> 'S') or (ie_nod_dens_gordura_w = 'S' or ie_calcificacao_vasc_w = 'S' or ie_dist_arq_cirurg_w = 'S' or ie_nod_calcificado_w = 'S' or ie_implante_integro_w = 'S' or ie_nod_dens_het_w = 'S' or ie_nod_dens_het_w = 'S' or ie_linf_intramamario_w = 'S' or ie_implante_ruptura_w = 'S' or coalesce(ie_outra_calcif_w,'N') <> 'S'))) then
			ds_retorno_w := 'S';
		end if;
	end if;

elsif (nr_categoria_p = 6) then

	--cenario 18
	if	(ie_pele_w = 'N' and (ie_nodulo1_w = 'S' or ie_nodulo2_w = 'S' or ie_nodulo3_w = 'S' or ie_microcalcificacao1_w = 'S' or ie_microcalcificacao2_w = 'S' or ie_microcalcificacao3_w = 'S' or ie_assim_focal1_w = 'S' or ie_assim_focal2_w = 'S' or ie_assim_difusa1_w = 'S' or ie_assim_difusa2_w = 'S') and (ie_linf_visibilizado_w = 'S' or ie_linf_visibilizado_w = 'N' or ie_inf_aumentados_w = 'S' or ie_linf_densos_w = 'S' or ie_linf_confluentes_w = 'S') and
		((coalesce(ie_nod_dens_gordura_w,'N') <> 'S' and coalesce(ie_calcificacao_vasc_w,'N') <> 'S' and coalesce(ie_dist_arq_cirurg_w,'N') <> 'S' and coalesce(ie_nod_calcificado_w,'N') <> 'S' and coalesce(ie_implante_integro_w,'N') <> 'S' and coalesce(ie_nod_dens_het_w,'N') <> 'S' and coalesce(ie_nod_dens_het_w,'N') <> 'S' and coalesce(ie_linf_intramamario_w,'N') <> 'S' and coalesce(ie_implante_ruptura_w,'N') <> 'S' and coalesce(ie_outra_calcif_w,'N') <> 'S') or (ie_nod_dens_gordura_w = 'S' or ie_calcificacao_vasc_w = 'S' or ie_dist_arq_cirurg_w = 'S' or ie_nod_calcificado_w = 'S' or ie_implante_integro_w = 'S' or ie_nod_dens_het_w = 'S' or ie_nod_dens_het_w = 'S' or ie_linf_intramamario_w = 'S' or ie_implante_ruptura_w = 'S' or coalesce(ie_outra_calcif_w,'N') <> 'S'))) then

		select	ie_lesao_diag_cancer,
			ie_aval_qt_neo_adjuvante
		into STRICT	ie_lesao_diag_cancer_w,
			ie_aval_qt_neo_adjuvante_w
		from	sismama_mam_ind_clinica
		where	nr_seq_sismama = nr_sequencia_sismama_w;

		if (ie_lesao_diag_cancer_w = 'S' or ie_aval_qt_neo_adjuvante_w = 'S') then
			ds_retorno_w := 'S';
		end if;

	end if;

end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_sismama_conclusion (nr_sequencia_sismama_p text, nr_categoria_p bigint, ie_lado_p text) FROM PUBLIC;
