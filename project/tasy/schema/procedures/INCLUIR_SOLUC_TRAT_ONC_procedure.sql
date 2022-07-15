-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



CREATE TYPE campos AS (ds_dias_aplicacao	varchar(6));


CREATE OR REPLACE PROCEDURE incluir_soluc_trat_onc ( nr_seq_paciente_p bigint, nr_seq_solucao_p bigint, ie_operacao_p bigint, nm_usuario_p text) AS $body$
DECLARE


ds_dias_aplicacao_w	varchar(4000);
ds_texto_w		varchar(255);
k			integer;
x			varchar(1);
y 			integer;
z 			integer;
cont_w			bigint;
posicao_w		smallint;
type vetor is table of campos index by integer;
dias_w			vetor;
qt_count_w		bigint;
dia_w			varchar(5);
nr_seq_atendimento_w	bigint;
nr_seq_material_w	bigint;
nr_seq_interno_w	bigint;
ds_valido_dias_w 	varchar(13)	:= '0123456789D,-';
r			integer := 1;
nr_seq_material_ww	bigint;
ie_gerar_pend_quimio_w		varchar(1);

c01 CURSOR FOR
	SELECT	*
	from	paciente_protocolo_soluc
	where	nr_seq_paciente		= nr_seq_paciente_p
	and	nr_seq_solucao		= nr_seq_solucao_p;

C02 CURSOR FOR
	SELECT	nr_seq_atendimento
	from	paciente_atendimento
	where	nr_seq_paciente = nr_seq_paciente_p
	and		ds_dia_ciclo = dia_w
	and		coalesce(nr_prescricao::text, '') = ''
	and		coalesce(dt_cancelamento::text, '') = ''
	and		Obter_Se_Dia_Ciclo_Autorizado(nr_seq_atendimento,nr_ciclo) = 'N';

c01_w	c01%rowtype;


BEGIN

ie_gerar_pend_quimio_w := obter_param_usuario(865, 255, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_gerar_pend_quimio_w);

open C01;
loop
fetch C01 into
	c01_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	ds_dias_aplicacao_w	:= c01_w.ds_dias_aplicacao;
	ds_dias_aplicacao_w	:= replace(ds_dias_aplicacao_w,' ','');
	ds_texto_w		:= '';
	for y in 1..length(ds_dias_aplicacao_w) loop
		x	:= substr(upper(ds_dias_aplicacao_w), y, 1);
		if (position(x in ds_valido_dias_w) > 0) then
			ds_texto_w	:= ds_texto_w || x;
		else
			CALL wheb_mensagem_pck.exibir_mensagem_abort(238996);
			--(-20011,'Erro na padronização dos horários do mat/med ');
		end if;
	end loop;
	ds_dias_aplicacao_w	:= ds_texto_w;
	z	:= 0;
	ds_dias_aplicacao_w	:= ds_dias_aplicacao_w ||',';
	cont_w	:= 0;
	dias_w.delete;
	while	(ds_dias_aplicacao_w IS NOT NULL AND ds_dias_aplicacao_w::text <> '') loop
		begin
		posicao_w	:= position(',' in ds_dias_aplicacao_w);
		z := z + 1;
		dias_w[z].ds_dias_aplicacao	:= substr(ds_dias_aplicacao_w,1,posicao_w - 1);
		ds_dias_aplicacao_w		:= substr(ds_dias_aplicacao_w,posicao_w + 1,length(ds_dias_aplicacao_w));
		if (position('D' in dias_w[z].ds_dias_aplicacao)	= 0) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(238996);
			--(-20011,'Erro na padronização dos horários do mat/med ');
		end if;

		cont_w	:= cont_w + 1;
		if (cont_w > 100) then
			exit;
		end if;
		end;
	end loop;

	qt_count_w	:= dias_w.count;
	k := 1;
	r := 1;
	while(k <= qt_count_w) loop
	dia_w	:= dias_w[k].ds_dias_aplicacao;

		/*select	max(nr_seq_atendimento)
		into	nr_seq_atendimento_w
		from	paciente_atendimento
		where	nr_seq_paciente = nr_seq_paciente_p
		and	ds_dia_ciclo = dia_w;*/
		/*if 	(nr_seq_atendimento_w > 0) then
			begin

			if	(ie_operacao_p	= 3) then
				delete
				from	paciente_atend_soluc
				where	nr_seq_atendimento = nr_seq_atendimento_w
				and	nr_seq_solucao = nr_seq_solucao_p;

				commit;
			end if;*/
			open C02;
			loop
			fetch C02 into
				nr_seq_atendimento_w;
			EXIT WHEN NOT FOUND; /* apply on C02 */
				begin

				if (ie_operacao_p	= 3) then
					delete
					from	paciente_atend_soluc
					where	nr_seq_atendimento = nr_seq_atendimento_w
					and	nr_seq_solucao = nr_seq_solucao_p;

					commit;
				end if;

				if (ie_operacao_p	= 1) then
				insert into paciente_atend_soluc(
								nr_seq_atendimento,
								nr_seq_solucao,
								nr_agrupamento,
								dt_atualizacao,
								nm_usuario,
								dt_atualizacao_nrec,
								nm_usuario_nrec,
								ie_tipo_dosagem,
								qt_dosagem,
								qt_solucao_total,
								qt_tempo_aplicacao,
								nr_etapas,
								ie_bomba_infusao,
								ie_esquema_alternado,
								ie_calc_aut,
								ie_acm,
								qt_hora_fase,
								ds_solucao,
								ds_orientacao,
								ie_se_necessario,
								ie_solucao_pca,
								ie_tipo_analgesia,
								ie_pca_modo_prog,
								qt_dose_inicial_pca,
								qt_vol_infusao_pca,
								qt_bolus_pca,
								qt_intervalo_bloqueio,
								qt_limite_quatro_hora,
								qt_dose_ataque,
								ie_tipo_sol,
								ie_pre_medicacao,
								cd_intervalo,
								ie_via_aplicacao,
								ie_cancelada,
								ie_local_adm)
						values (		nr_seq_atendimento_w,
								nr_seq_solucao_p,
								c01_w.nr_agrupamento,
								clock_timestamp(),
								nm_usuario_p,
								clock_timestamp(),
								nm_usuario_p,
								c01_w.ie_tipo_dosagem,
								c01_w.qt_dosagem,
								c01_w.qt_solucao_total,
								c01_w.qt_tempo_aplicacao,
								c01_w.nr_etapas,
								c01_w.ie_bomba_infusao,
								c01_w.ie_esquema_alternado,
								c01_w.ie_calc_aut,
								c01_w.ie_acm,
								c01_w.qt_hora_fase,
								c01_w.ds_solucao,
								c01_w.ds_orientacao,
								c01_w.ie_se_necessario,
								c01_w.ie_solucao_pca,
								c01_w.ie_tipo_analgesia,
								c01_w.ie_pca_modo_prog,
								c01_w.qt_dose_inicial_pca,
								c01_w.qt_vol_infusao_pca,
								c01_w.qt_bolus_pca,
								c01_w.qt_intervalo_bloqueio,
								c01_w.qt_limite_quatro_hora,
								c01_w.qt_dose_ataque,
								c01_w.ie_tipo_sol,
								c01_w.ie_pre_medicacao,
								c01_w.cd_intervalo,
								c01_w.ie_via_aplicacao,
								'N',
								CASE WHEN ie_gerar_pend_quimio_w='S' THEN  coalesce(c01_w.IE_LOCAL_ADM,'H')  ELSE coalesce(c01_w.IE_LOCAL_ADM,'') END );
				end if;
				end;
			end loop;
			close C02;

		/*	if 	(ie_operacao_p	= 1) then
				insert into paciente_atend_soluc (
								nr_seq_atendimento,
								nr_seq_solucao,
								nr_agrupamento,
								dt_atualizacao,
								nm_usuario,
								dt_atualizacao_nrec,
								nm_usuario_nrec,
								ie_tipo_dosagem,
								qt_dosagem,
								qt_solucao_total,
								qt_tempo_aplicacao,
								nr_etapas,
								ie_bomba_infusao,
								ie_esquema_alternado,
								ie_calc_aut,
								ie_acm,
								qt_hora_fase,
								ds_solucao,
								ds_orientacao,
								ie_se_necessario,
								ie_solucao_pca,
								ie_tipo_analgesia,
								ie_pca_modo_prog,
								qt_dose_inicial_pca,
								qt_vol_infusao_pca,
								qt_bolus_pca,
								qt_intervalo_bloqueio,
								qt_limite_quatro_hora,
								qt_dose_ataque,
								ie_tipo_sol,
								ie_pre_medicacao,
								cd_intervalo,
								ie_via_aplicacao)
						values(		nr_seq_atendimento_w,
								nr_seq_solucao_p,
								c01_w.nr_agrupamento,
								sysdate,
								nm_usuario_p,
								sysdate,
								nm_usuario_p,
								c01_w.ie_tipo_dosagem,
								c01_w.qt_dosagem,
								c01_w.qt_solucao_total,
								c01_w.qt_tempo_aplicacao,
								c01_w.nr_etapas,
								c01_w.ie_bomba_infusao,
								c01_w.ie_esquema_alternado,
								c01_w.ie_calc_aut,
								c01_w.ie_acm,
								c01_w.qt_hora_fase,
								c01_w.ds_solucao,
								c01_w.ds_orientacao,
								c01_w.ie_se_necessario,
								c01_w.ie_solucao_pca,
								c01_w.ie_tipo_analgesia,
								c01_w.ie_pca_modo_prog,
								c01_w.qt_dose_inicial_pca,
								c01_w.qt_vol_infusao_pca,
								c01_w.qt_bolus_pca,
								c01_w.qt_intervalo_bloqueio,
								c01_w.qt_limite_quatro_hora,
								c01_w.qt_dose_ataque,
								c01_w.ie_tipo_sol,
								c01_w.ie_pre_medicacao,
								c01_w.cd_intervalo,
								c01_w.ie_via_aplicacao);



			end if;*/
			--end;
		--end if;
	k := k + 1;
	end loop;


	end;
end loop;
close C01;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE incluir_soluc_trat_onc ( nr_seq_paciente_p bigint, nr_seq_solucao_p bigint, ie_operacao_p bigint, nm_usuario_p text) FROM PUBLIC;

