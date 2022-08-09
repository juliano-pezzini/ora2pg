-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE conferir_preparo_palm ( nr_seq_processo_p bigint, nr_seq_etiqueta_p text, nm_usuario_p text) AS $body$
DECLARE


nr_prescricao_w		prescr_mat_hor.nr_prescricao%type;
nr_prescricao_ww	prescr_mat_hor.nr_prescricao%type;
nr_seq_material_w	prescr_mat_hor.nr_seq_material%type;				
nr_atendimento_w	prescr_mat_hor.nr_atendimento%type;				
cd_material_w		prescr_mat_hor.cd_material%type;
ie_agrupador_w		prescr_mat_hor.ie_agrupador%type;
ie_tipo_item_w		varchar(3);
ie_tipo_item_ww		varchar(3);
nr_seq_horario_w	prescr_mat_hor.nr_sequencia%type;
nr_seq_digito_w		smallint;
nr_seq_frac_w		bigint;
ie_conf_prep_frac_w	varchar(1);
ie_alteracao_w		valor_dominio.vl_dominio%type;
ie_gera_evento_w	varchar(1) := 'S';

C01 CURSOR FOR
	SELECT	nr_prescricao,
			nr_seq_material,
			nr_atendimento,
			cd_material,
			ie_agrupador,
			nr_sequencia,
			'S'
	from	prescr_mat_hor
	where	nr_seq_processo = nr_seq_processo_p
	and		nr_seq_etiqueta = obter_etiqueta_barras_frac(nr_seq_etiqueta_p)
	
union all

	SELECT	nr_prescricao,
			nr_seq_material,
			nr_atendimento,
			cd_material,
			ie_agrupador,
			nr_sequencia,
			'N'
	from	prescr_mat_hor
	where	nr_sequencia = substr(nr_seq_etiqueta_p,1,length(nr_seq_etiqueta_p)-1)
	and		nr_seq_digito = substr(nr_seq_etiqueta_p,length(nr_seq_etiqueta_p),1)
	
union all

	select	nr_prescricao,
			nr_seq_solucao,
			nr_atendimento,
			cd_material,
			ie_agrupador,
			nr_sequencia,
			'N'
	from	prescr_mat_hor
	where	nr_prescricao = nr_prescricao_ww
	and		nr_prescricao||nr_seq_solucao||nr_etapa_sol = nr_seq_etiqueta_p;
				

BEGIN

nr_prescricao_ww := obter_nr_prescr_etq_sol(nr_seq_etiqueta_p);

open C01;
loop
fetch C01 into	
	nr_prescricao_w,
	nr_seq_material_w,
	nr_atendimento_w,
	cd_material_w,
	ie_agrupador_w,
	nr_seq_horario_w,
	ie_conf_prep_frac_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	
	if (ie_conf_prep_frac_w = 'S') then
		nr_seq_digito_w	:= (substr(nr_seq_etiqueta_p,12,1))::numeric;
		nr_seq_frac_w	:= (substr(nr_seq_etiqueta_p,2,10))::numeric;

		update 	adep_processo_frac
		set 	dt_conferencia_prep 	= clock_timestamp(),
				nm_usuario_conf_preparo = nm_usuario_p
		where   nr_seq_processo 		= nr_seq_processo_p
		and		nr_seq_digito 			= nr_seq_digito_w;
	end if;
	
	if (ie_agrupador_w = 1) then
		ie_tipo_item_w	:= 'M';
		ie_tipo_item_ww	:= 'M';
		ie_alteracao_w	:= 59;
		ie_gera_evento_w := 'S';
	elsif (ie_agrupador_w = 4) then
		ie_tipo_item_w	:= 'S';
		ie_tipo_item_ww	:= 'SOL';
		ie_alteracao_w	:= 55;

		select	coalesce(max('S'), 'N')
		into STRICT	ie_gera_evento_w
		from	prescr_mat_hor a
		where	a.nr_sequencia = nr_seq_horario_w
		and		a.cd_material = obter_medic_principal_sol(a.nr_prescricao, a.nr_seq_solucao);

	elsif (ie_agrupador_w = 5) then
		ie_tipo_item_w	:= 'IAG';
		ie_tipo_item_ww	:= 'M';
		ie_alteracao_w	:= 59;
		ie_gera_evento_w := 'S';
	end if;
	
	if (obter_se_item_hor_pendente(nr_prescricao_w, nr_seq_material_w, ie_tipo_item_ww) = 'S') and (ie_gera_evento_w = 'S') then

		CALL Gerar_Evento_Adep_Pend(nr_prescricao_w, nr_seq_material_w, ie_alteracao_w,  null, ie_tipo_item_w, nr_atendimento_w, cd_material_w, nm_usuario_p, null, 'N', nr_seq_horario_w);

	end if;
	
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE conferir_preparo_palm ( nr_seq_processo_p bigint, nr_seq_etiqueta_p text, nm_usuario_p text) FROM PUBLIC;
