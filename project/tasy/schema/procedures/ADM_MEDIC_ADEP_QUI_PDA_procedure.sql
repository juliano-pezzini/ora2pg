-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE adm_medic_adep_qui_pda ( nr_seq_atendimento_p bigint, dt_referencia_p timestamp, nr_prescricao_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, ie_acao_p text, nr_seq_horario_p bigint, cd_cracha_p text default null) AS $body$
DECLARE



nr_sequencia_w    prescr_mat_hor.nr_sequencia%type;
nr_seq_alteracao_w  prescr_mat_alteracao.nr_sequencia%type;
nr_seq_material_w  prescr_material.nr_sequencia%type;
ie_acm_sn_w      prescr_material.ie_acm%type;
cd_material_w    prescr_material.cd_material%type;
qt_dose_w      prescr_material.qt_dose%type;
ie_agrupador_w    prescr_material.ie_agrupador%type;
nr_atendimento_w  prescr_medica.nr_atendimento%type;
dt_horario_w    prescr_mat_hor.dt_horario%type;
ie_realizaDuplaChecagem_w varchar(1);
ds_msgDP_w varchar(1);
nm_usuario_w 	usuario.nm_usuario%type;


C01 CURSOR FOR
  SELECT  	a.nr_sequencia,
		a.nr_seq_material,
		obter_se_acm_sn(b.ie_acm, b.ie_se_necessario),
		b.cd_material,
		b.qt_dose,
		a.ie_agrupador,
		a.nr_atendimento,
		a.dt_horario
  from  	prescr_mat_hor a,
		prescr_material b
  where  	a.nr_prescricao = nr_prescricao_p
  and    	a.nr_prescricao = b.nr_prescricao
  and    	b.nr_sequencia = a.nr_seq_material
  and   	a.nr_sequencia = nr_seq_horario_p
  and    	ie_acao_p = 'A';


BEGIN

ie_realizaDuplaChecagem_w := obter_param_usuario(88, 349, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_realizaDuplaChecagem_w);

open C01;
loop
fetch C01 into
	nr_sequencia_w,
	nr_seq_material_w,
	ie_acm_sn_w,
	cd_material_w,
	qt_dose_w,
	ie_agrupador_w,
	nr_atendimento_w,
	dt_horario_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
  begin
	

  nm_usuario_w :=nm_usuario_p;
  if((ie_realizaDuplaChecagem_w = 'S') and (exige_dupla_checagem(cd_material_w)='S'))then			
				ds_msgDP_w := Gerar_primeira_checagem(nr_seq_horario_p, '', '', 'M', clock_timestamp(), nm_usuario_p, obter_perfil_ativo, ds_msgDP_w);
        nm_usuario_w:=OBTER_USUARIO_BARRAS(cd_cracha_p);
  end if;

  update  prescr_mat_hor
	set    	dt_fim_horario = clock_timestamp(),
		nm_usuario_adm = nm_usuario_w
	where  	nr_sequencia = nr_sequencia_w
	and    	coalesce(coalesce(dt_fim_horario, dt_suspensao)::text, '') = '';

	select  nextval('prescr_mat_alteracao_seq')
	into STRICT  nr_seq_alteracao_w
	;

	insert into prescr_mat_alteracao(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_prescricao,
		nr_seq_prescricao,
		dt_alteracao,
		cd_pessoa_fisica,
		ie_alteracao,
		nr_atendimento,
		qt_dose_original,
		ie_acm_sn,
		cd_item,
		ie_mostra_adep,
		ie_tipo_item,
		dt_horario_acao,
        nr_seq_horario
	) values (
		nr_seq_alteracao_w,
		clock_timestamp(),
		nm_usuario_w,
		clock_timestamp(),
		nm_usuario_w,
		nr_prescricao_p,
		nr_seq_material_w,
		clock_timestamp(),
		obter_dados_usuario_opcao(nm_usuario_w,'C'),
		3,
		nr_atendimento_w,
		qt_dose_w,
		ie_acm_sn_w,
		cd_material_w,
		'S',
		CASE WHEN ie_agrupador_w=2 THEN  'MAT'  ELSE 'M' END ,
		dt_horario_w,
        nr_seq_horario_p
	);
  end;
end loop;
close C01;

commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE adm_medic_adep_qui_pda ( nr_seq_atendimento_p bigint, dt_referencia_p timestamp, nr_prescricao_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, ie_acao_p text, nr_seq_horario_p bigint, cd_cracha_p text default null) FROM PUBLIC;
