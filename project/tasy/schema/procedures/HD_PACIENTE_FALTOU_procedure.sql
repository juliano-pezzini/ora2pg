-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hd_paciente_faltou (cd_pessoa_fisica_p text, ds_observacao_p text, cd_unid_dialise_p text, nr_atendimento_p bigint, nr_Seq_motivo_fim_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, dt_registro_p timestamp default clock_timestamp(), ds_erro_p INOUT text DEFAULT NULL) AS $body$
DECLARE


                                         		
nr_seq_hd_prc_chegada_w	bigint;
nr_dialise_pac_w	        bigint;
nr_seq_dialise_w	        bigint;
ie_obriga_atendimento_w	varchar(1);
nr_seq_dialise_gerada_w	bigint;
nr_prescricao_emergencia_w    bigint;
nr_prescricao_normal_w	bigint;
nr_prescricao_w		bigint;
nr_seq_dialise_atual_w	bigint;
ie_gerar_dialise_dialisador_w	varchar(1);
qt_dias_w		bigint;
dt_registro_w		timestamp;


BEGIN

dt_registro_w := dt_registro_p;

if (coalesce(dt_registro_w::text, '') = '') then
dt_registro_w := clock_timestamp();
end if;

ie_obriga_atendimento_w := obter_param_usuario(7009, 31, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_obriga_atendimento_w);

ie_gerar_dialise_dialisador_w := obter_param_usuario(7009, 174, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_gerar_dialise_dialisador_w);

select 	coalesce(max(nr_sequencia),0)
into STRICT	nr_seq_dialise_gerada_w
from	hd_dialise
where	coalesce(dt_fim_dialise::text, '') = ''
and	coalesce(dt_cancelamento::text, '') = ''
and	cd_pessoa_fisica = cd_pessoa_fisica_p;

if (ie_obriga_atendimento_w = 'S') and (coalesce(nr_atendimento_p::text, '') = '') then
	ds_erro_p	:= WHEB_MENSAGEM_PCK.get_texto(279772,null);
elsif (nr_seq_dialise_gerada_w > 0) and (ie_gerar_dialise_dialisador_w = 'N') then
	ds_erro_p	:= WHEB_MENSAGEM_PCK.get_texto(277462,'NR_SEQ_DIALISE_GERADA='||nr_seq_dialise_gerada_w);
else
  select nextval('hd_prc_chegada_seq')
  into STRICT nr_seq_hd_prc_chegada_w
;

  select	OBTER_DIAS_ENTRE_DATAS(clock_timestamp(), dt_registro_w)
  into STRICT	qt_dias_w
;

  if (qt_dias_w > 0) then
    ds_erro_p	:= obter_desc_expressao(500066);
	elsif (nr_seq_motivo_fim_p IS NOT NULL AND nr_seq_motivo_fim_p::text <> '') then
		insert into hd_prc_chegada(
					nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					cd_pessoa_fisica,
					dt_chegada,
					cd_estabelecimento,
					ie_pac_faltou
				) values (
					nr_seq_hd_prc_chegada_w,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					cd_pessoa_fisica_p,
					clock_timestamp(),
					cd_estabelecimento_p,
					'S');

		select	coalesce(max(nr_seq_paciente),0)+1
		into STRICT	nr_dialise_pac_w
		from 	hd_dialise 
		where 	cd_pessoa_fisica	= cd_pessoa_fisica_p;

		select	nextval('hd_dialise_seq')
		into STRICT	nr_seq_dialise_w
		;

		nr_seq_dialise_atual_w := hd_obter_dialise_atual(cd_pessoa_fisica_p,'I');
		
		if (coalesce(nr_seq_dialise_atual_w::text, '') = '') or (ie_gerar_dialise_dialisador_w = 'N') then
      insert into hd_dialise(
        nr_sequencia,
        dt_atualizacao,
        nm_usuario,
        dt_atualizacao_nrec,
        nm_usuario_nrec,
        cd_pessoa_fisica,
        dt_dialise,
        nr_seq_paciente,
        nr_seq_unid_dialise,
        nr_atendimento,
        dt_cancelamento,
        nr_seq_motivo_fim,
        ds_observacao,
        cd_pf_cancelamento,
        ie_paciente_agudo
      ) values (
        nr_seq_dialise_w,
        clock_timestamp(),
        nm_usuario_p,
        clock_timestamp(),
        nm_usuario_p,
        cd_pessoa_fisica_p,
        clock_timestamp(),
        nr_dialise_pac_w,
        cd_unid_dialise_p,
        nr_atendimento_p,
        dt_registro_w,
        nr_seq_motivo_fim_p,
        ds_observacao_p,
        substr(obter_pessoa_fisica_usuario(nm_usuario_p,'C'),1,10),
        substr(hd_obter_ie_agudo_pac(cd_pessoa_fisica_p),1,1)
      );
		elsif (nr_seq_dialise_atual_w IS NOT NULL AND nr_seq_dialise_atual_w::text <> '') then
			update	hd_dialise
			set	dt_cancelamento = clock_timestamp(),
				nr_seq_motivo_fim = nr_seq_motivo_fim_p,
				ds_observacao = ds_observacao_p,
				cd_pf_cancelamento = substr(obter_pessoa_fisica_usuario(nm_usuario_p,'C'),1,10)
			where	nr_sequencia = 	nr_seq_dialise_atual_w;
		end if;	
			update	hd_agenda_dialise
			set		ie_situacao = 'C',
					nm_usuario = nm_usuario_p,
					dt_atualizacao = clock_timestamp()
			where	trunc(dt_agenda) = trunc(clock_timestamp())
			and		cd_pessoa_fisica = cd_pessoa_fisica_p;
		
			select   max(nr_prescricao)
			into STRICT	 nr_prescricao_emergencia_w   
			from	 prescr_medica a
			where	 ie_hemodialise	         = 'E'
			and	 trunc(dt_prescricao)	 = trunc(clock_timestamp())
			and	 cd_pessoa_fisica        = cd_pessoa_fisica_p
			and	(coalesce(dt_liberacao_medico, dt_liberacao) IS NOT NULL AND (coalesce(dt_liberacao_medico, dt_liberacao))::text <> '')
			and	coalesce(dt_fim_prescricao::text, '') = ''
			and	not exists (SELECT 1 from prescr_mat_hor b where b.nr_prescricao = a.nr_prescricao and (nr_seq_dialise IS NOT NULL AND nr_seq_dialise::text <> ''));
			
			select  max(nr_prescricao)
			into STRICT	nr_prescricao_normal_w
			from	prescr_medica
			where	ie_hemodialise	         = 'S'
			and	cd_pessoa_fisica        = cd_pessoa_fisica_p
			and	(coalesce(dt_liberacao_medico, dt_liberacao) IS NOT NULL AND (coalesce(dt_liberacao_medico, dt_liberacao))::text <> '')
			and	coalesce(dt_fim_prescricao::text, '') = '';

			nr_prescricao_w	:= nr_prescricao_normal_w;
			
			if (nr_prescricao_emergencia_w IS NOT NULL AND nr_prescricao_emergencia_w::text <> '') then
				nr_prescricao_w	:= nr_prescricao_emergencia_w;
			end if;
			
			if (nr_prescricao_w IS NOT NULL AND nr_prescricao_w::text <> '') then
				CALL gerar_prescr_mat_hor_dialise(nr_prescricao_w,nr_seq_dialise_w,OBTER_PERFIL_ATIVO,clock_timestamp(),nm_usuario_p);
			end if;		
	else
		ds_erro_p	:= WHEB_MENSAGEM_PCK.get_texto(279770,null);
	end if;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hd_paciente_faltou (cd_pessoa_fisica_p text, ds_observacao_p text, cd_unid_dialise_p text, nr_atendimento_p bigint, nr_Seq_motivo_fim_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, dt_registro_p timestamp default clock_timestamp(), ds_erro_p INOUT text DEFAULT NULL) FROM PUBLIC;

