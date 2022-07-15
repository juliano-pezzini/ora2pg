-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_prescr_autoriz_cirurgia ( nr_cirurgia_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, ie_html5_p text default 'N') AS $body$
DECLARE


nr_sequencia_w			bigint;
nr_seq_agenda_w			bigint;
nr_seq_agenda_ww		bigint;
nr_prescricao_w			bigint;
nr_seq_autorizacao_w		bigint;
cd_material_w			integer;
qt_material_w			double precision;
nr_seq_prescr_w			smallint;
cd_unidade_medida_w		varchar(30);
cd_intervalo_w			varchar(7);
qt_cotacao_w			integer;
cd_cgc_w			varchar(14);
ie_origem_inf_w			varchar(1);
ie_consignado_w			varchar(1);
CD_FORNEC_CONSIGNADO_w		varchar(14);
dt_inicio_real_w		timestamp;
ie_atualiza_dt_inicio_real_w 	varchar(1);
dt_prescricao_w			timestamp;
ie_gera_pelo_atendimento_w	varchar(1);
nr_atendimento_w		bigint:=0;
nr_seq_autor_w			bigint;
nr_prescricao_espec_w	bigint;
cd_setor_atendimento_w		integer;

C01 CURSOR FOR
	SELECT b.nr_seq_autorizacao,
		b.cd_material,
		b.qt_material,
		row_number() OVER () AS rownum,
		substr(obter_dados_material_estab(b.cd_material,cd_estabelecimento_p,'UMS'),1,30) cd_unidade_medida_consumo,
		b.nr_sequencia,
		c.ie_consignado,
		b.cd_cgc_fornec
	from	material c,
		material_autor_cirurgia b,
		autorizacao_cirurgia a
	where	a.nr_sequencia		= b.nr_seq_autorizacao
	and 	b.cd_material			= c.cd_material
	and	coalesce(b.ie_aprovacao,'S')	= 'S'
	and	((a.nr_seq_agenda = nr_seq_agenda_w) or (nr_atendimento = nr_atendimento_w))
	and	coalesce(a.nr_prescricao::text, '') = ''
	and 	coalesce(a.dt_cancelamento::text, '') = '';


BEGIN

ie_atualiza_dt_inicio_real_w := obter_param_usuario(900, 91, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_atualiza_dt_inicio_real_w);
ie_gera_pelo_atendimento_w := obter_param_usuario(900, 274, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_gera_pelo_atendimento_w);
cd_setor_atendimento_w := obter_param_usuario(900, 548, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, cd_setor_atendimento_w);

dt_prescricao_w	:= clock_timestamp();

if (ie_atualiza_dt_inicio_real_w = 'S') then
	select	dt_inicio_real
	into STRICT	dt_inicio_real_w
	from 	cirurgia
	where	nr_cirurgia = nr_cirurgia_p;

	if (dt_inicio_real_w IS NOT NULL AND dt_inicio_real_w::text <> '') then
		dt_prescricao_w := dt_inicio_real_w;
	end if;
end if;

select coalesce(max(nr_seq_agenda),0)
into STRICT nr_seq_agenda_w
from	autorizacao_cirurgia b,
	agenda_paciente a
where a.nr_sequencia	= b.nr_seq_agenda
  and coalesce(b.nr_prescricao::text, '') = ''
  and coalesce(b.dt_cancelamento::text, '') = ''
  and a.nr_cirurgia	= nr_cirurgia_p;

  
if (nr_seq_agenda_w = 0) and (ie_gera_pelo_atendimento_w = 'S') then
	select	coalesce(max(nr_atendimento),0)
	into STRICT	nr_atendimento_w
	from 	cirurgia
	where	nr_cirurgia = nr_cirurgia_p;
end if;


-- Obter ie_origem_inf se é médico ou não
select 	coalesce(max('1'),'3')
into STRICT	ie_origem_inf_w
from	Medico b,
	Usuario a
where 	a.nm_usuario		= nm_usuario_p
  and	a.cd_pessoa_fisica	= b.cd_pessoa_fisica;


  
select	max(nr_prescricao_espec)
into STRICT	nr_prescricao_espec_w
from	cirurgia
where	nr_cirurgia =  nr_cirurgia_p;

if (nr_seq_agenda_w > 0) or (nr_atendimento_w > 0) then

	
	if (nr_prescricao_espec_w IS NOT NULL AND nr_prescricao_espec_w::text <> '') and (ie_html5_p = 'S') then
		nr_prescricao_w	:= nr_prescricao_espec_w;
	else
	
		select nextval('prescr_medica_seq')
		into STRICT nr_prescricao_w
		;
		
		select	max(nr_seq_agenda)
		into STRICT	nr_seq_agenda_ww
		from	autorizacao_cirurgia b,
			agenda_paciente a
		where	a.nr_sequencia = b.nr_seq_agenda
		and	a.nr_cirurgia = nr_cirurgia_p;
		
		insert into prescr_medica(
			NR_PRESCRICAO            ,
			CD_PESSOA_FISICA         ,
			NR_ATENDIMENTO           ,
			CD_MEDICO                ,
			DT_PRESCRICAO            ,
			DT_ATUALIZACAO           ,
			NM_USUARIO               ,
			NM_USUARIO_ORIGINAL      ,
			DS_OBSERVACAO            ,
			NR_HORAS_VALIDADE        ,
			CD_MOTIVO_BAIXA          ,
			DT_BAIXA                 ,
			DT_PRIMEIRO_HORARIO      ,
			DT_LIBERACAO             ,
			DT_EMISSAO_SETOR         ,
			DT_EMISSAO_FARMACIA      ,
			CD_SETOR_ATENDIMENTO     ,
			DT_ENTRADA_UNIDADE       ,
			IE_RECEM_NATO		 ,
			IE_ORIGEM_INF  		 ,
			NR_PRESCRICAO_ANTERIOR   ,
			NR_PRESCRICAO_MAE,
			CD_PROTOCOLO,
			NR_SEQ_PROTOCOLO,
			nr_cirurgia,
			nr_seq_agenda,
			cd_estabelecimento,
			cd_prescritor)
		SELECT nr_prescricao_w,
			cd_pessoa_fisica,
			nr_atendimento,
			CD_MEDICO,
			dt_prescricao_w,
			clock_timestamp(),
			NM_USUARIO_P,
			NM_USUARIO_P,
			ds_observacao,
			nr_horas_validade,
			null,
			null,
			dt_primeiro_horario,
			null,
			null,
			null,
			cd_setor_atendimento_w,
			null,
			'N',
			ie_origem_inf_w,
			null,
			null,
			null,
			null,
			nr_cirurgia_p,
			nr_seq_agenda_ww,
			cd_estabelecimento_p,
			obter_dados_usuario_opcao(nm_usuario_p, 'C')
		from prescr_medica a
		where a.nr_prescricao =
			(SELECT x.nr_prescricao
			from	cirurgia x
			where 	x.nr_cirurgia	= nr_cirurgia_p);
			
			
		if (ie_html5_p = 'S') then
			update	cirurgia
			set		nr_prescricao_espec = nr_prescricao_w
			where	nr_cirurgia =  nr_cirurgia_p;
		end if;
	end if;
	commit;

	select min(cd_intervalo)
	into STRICT cd_intervalo_w
	from intervalo_prescricao;

	open C01;
	loop
		fetch C01 into	nr_seq_autorizacao_w,
					cd_material_w,
					qt_material_w,
					nr_seq_prescr_w,
					cd_unidade_medida_w,
					nr_sequencia_w,
					ie_consignado_w,
					CD_FORNEC_CONSIGNADO_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
		select	count(*), max(cd_cgc)
		into STRICT	qt_cotacao_w, cd_cgc_w
		from	material_autor_cir_cot
		where	nr_sequencia	= nr_sequencia_w;
		if (qt_cotacao_w <> 1) or (ie_consignado_w <> '1') then
			cd_cgc_w	:= '';
		end if;
		insert into prescr_material(	nr_prescricao,
				nr_sequencia,
				cd_material,
				cd_unidade_medida,
				qt_unitaria,
				qt_material,
				qt_total_dispensar,
				nm_usuario,
				dt_atualizacao,
				cd_intervalo,
				ie_origem_inf,
				ie_medicacao_paciente,
				ie_utiliza_kit,
				ie_urgencia,
				ie_bomba_infusao,
				ie_suspenso,
				ie_se_necessario,
				ie_status_cirurgia,
				cd_motivo_baixa,
				cd_fornec_consignado,
				ie_acm,
				ie_aplic_lenta,
				ie_aplic_bolus,
				ie_recons_diluente_fixo,
				ie_sem_aprazamento,
				nr_seq_material_autor)
		values (	nr_prescricao_w,
			  	nr_seq_prescr_w,
				cd_material_w,
				cd_unidade_medida_w,
				qt_material_w,
				qt_material_w,
				qt_material_w,
				nm_usuario_p,
				clock_timestamp(),
				cd_intervalo_w,
				ie_origem_inf_w,
				'N',
				'N',
				'N',
				'N',
				'N',
				'N',
				'GI',
				0,
				coalesce(cd_cgc_w,CD_FORNEC_CONSIGNADO_w),
				'N',
				'N',
				'N',
				'N',
				'N',
				nr_sequencia_w);

		update autorizacao_cirurgia
		set 	nr_prescricao 	= nr_prescricao_w,
			nm_usuario	  = nm_usuario_p,
			dt_atualizacao	  = clock_timestamp()
		where nr_sequencia = nr_seq_autorizacao_w;


		select	max(nr_sequencia)
		into STRICT	nr_seq_autor_w
		from	autorizacao_convenio
		where	nr_seq_autor_cirurgia = nr_seq_autorizacao_w;

		if (coalesce(nr_seq_autor_w,0) > 0) then
			begin
			update 	autorizacao_convenio
			set 	nr_prescricao 	= nr_prescricao_w,
				nm_usuario	= nm_usuario_p,
				dt_atualizacao	 = clock_timestamp()
			where 	nr_sequencia = nr_seq_autor_w;

			update	material_autorizado
			set	nr_seq_prescricao = nr_seq_prescr_w,
				nr_prescricao     = nr_prescricao_w,
				nm_usuario	  = nm_usuario_p,
				dt_atualizacao	  = clock_timestamp()
			where	nr_sequencia_autor = nr_seq_autor_w
			and	cd_material	   = cd_material_w
			and	coalesce(nr_prescricao::text, '') = '';

			end;
		end if;


	end loop;
	close C01;

end if;

commit;

end;	
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_prescr_autoriz_cirurgia ( nr_cirurgia_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, ie_html5_p text default 'N') FROM PUBLIC;

