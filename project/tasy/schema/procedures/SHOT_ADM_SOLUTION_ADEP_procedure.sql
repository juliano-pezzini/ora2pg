-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE shot_adm_solution_adep (nr_prescricao_p prescr_medica.nr_prescricao%type, nr_atendimento_p prescr_medica.nr_atendimento%type, ie_acao_p text) AS $body$
DECLARE



nr_seq_solucao_w            prescr_solucao.nr_seq_solucao%type;
cd_intervalo_w				intervalo_prescricao.cd_intervalo%type;
cd_unidade_medida_w			prescr_material.cd_unidade_medida%type;
ds_retorno_w				varchar(255);
nr_etapas_adep_w			bigint;
nr_etapas_solucao_w			varchar(255);
ds_erro_w					varchar(255) := '';		
			

BEGIN

select  max(a.nr_sequencia_solucao),
		max(a.cd_intervalo),
		max(a.cd_unidade_medida)
into STRICT	nr_seq_solucao_w,
		cd_intervalo_w,
		cd_unidade_medida_w
from    prescr_material a
where 	a.nr_prescricao = nr_prescricao_p;


if (ie_acao_p = 'A') then
	CALL aprazar_etapa_sol(nr_atendimento_p,1,nr_prescricao_p,nr_seq_solucao_w,/*c01_w.dt_inicio_adm*/
clock_timestamp(),null,null,
			wheb_usuario_pck.get_nm_usuario,null, 'N');

	ds_retorno_w := gerar_alteracao_sol_prescr(wheb_usuario_pck.get_cd_estabelecimento, nr_atendimento_p, 1, nr_prescricao_p, nr_seq_solucao_w, 1, /*c01_w.dt_inicio_adm*/
clock_timestamp(), 'V', null, cd_unidade_medida_w, null, /*c01_w.qt_velocidade_inf*/
null, null, null, null, null, null, wheb_usuario_pck.get_nm_usuario, null, null, 'N', 'N', ds_retorno_w, 0, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null);

	ds_retorno_w := gerar_alteracao_sol_prescr(wheb_usuario_pck.get_cd_estabelecimento, nr_atendimento_p, 1, nr_prescricao_p, nr_seq_solucao_w, 4, /*c01_w.dt_inicio_adm*/
clock_timestamp(), 'V', null, cd_unidade_medida_w, null, /*c01_w.qt_velocidade_inf*/
null, null, null, null, null, null, wheb_usuario_pck.get_nm_usuario, null, null, 'N', 'N', ds_retorno_w, 0, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null);
else
	select (obter_etapas_adep_sol(1,nr_prescricao,nr_seq_solucao) + coalesce(nr_etapas_suspensa,0))
	into STRICT	nr_etapas_adep_w
	from    prescr_solucao
	where   nr_seq_solucao = nr_seq_solucao_w
	and		nr_prescricao  = nr_prescricao_p;

	nr_etapas_solucao_w := substr(obter_etapas_solucao(nr_prescricao_p, nr_seq_solucao_w, nr_etapas_adep_w),1,255);

	ds_erro_w := suspender_etapa_solucao(1, nr_prescricao_p, nr_seq_solucao_w, /*nr_seq_motivo_p*/
null, 12, /*ds_observacao_w*/
null, wheb_usuario_pck.get_nm_usuario, null, null, nr_etapas_solucao_w, ds_erro_w, 0, obter_perfil_ativo);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE shot_adm_solution_adep (nr_prescricao_p prescr_medica.nr_prescricao%type, nr_atendimento_p prescr_medica.nr_atendimento%type, ie_acao_p text) FROM PUBLIC;

