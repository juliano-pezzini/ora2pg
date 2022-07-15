-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_laudo_integracao_ws ( cd_laudo_Externo_p bigint, ds_titulo_p text, ie_status_Laudo_p text, dt_laudo_p timestamp, nr_prescr_Proc_Princ_p bigint, nr_seq_Prescr_Proc_Princ_p bigint, nr_seq_interno_Proc_Princ_p bigint, nr_acess_dicom_Proc_Princ_p text, cd_Medico_tasy_p text, nr_CRM_Laudante_p text, ds_UF_CRM_Laudante_p text, dt_liberacao_p timestamp, nr_seq_reg_laudo_p bigint, nm_usuario_p text, cd_Laudo_tasy_p INOUT bigint, ds_erro_p INOUT text) AS $body$
DECLARE


nr_prescricao_w		bigint;
nr_seq_prescricao_w	bigint;
nr_seq_propaci_w		bigint;
nr_seq_proc_interno_w	bigint;
cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;
qt_procedimento_w		bigint;
cd_setor_atendimento_w	bigint;
cd_medico_exec_w		varchar(10);
nr_seq_exame_w		bigint;
ie_lado_w		varchar(15);
dt_prev_execucao_w	timestamp;
nr_atendimento_w		bigint;
dt_entrada_unidade_w	timestamp;
nr_laudo_w        		bigint;
cd_medico_resp_w		varchar(10);
qt_existe_medico_w	bigint;
ds_laudo_w		text;
ds_laudo_copia_w		text;
nr_seq_laudo_w		bigint;
nr_seq_laudo_ant_w	bigint;
nr_seq_laudo_atual_w	bigint;
nr_seq_copia_w		bigint;
ds_titulo_laudo_w		varchar(255);
ie_aprov_laudo_w   	varchar(1);
dt_aprovacao_w		timestamp;
dt_liberacao_w		timestamp;
nm_usuario_aprov_w	varchar(15);
nm_usuario_lib_w		varchar(15);
cd_acao_w  			smallint;
qt_existe_w					bigint;

  nr_acesso_dicom_w      varchar(15);
  ie_status_execucao_w  prescr_procedimento.ie_status_execucao%TYPE;
  nm_pessoa_fisica_w     varchar(255);
  regra_conferencia smallint;

cd_estabelecimento_w                prescr_medica.cd_estabelecimento%TYPE;
ie_alterar_medico_conta_w 	        varchar(2);
ie_alterar_medico_exec_conta_w	    varchar(2);


BEGIN

if (nr_prescr_Proc_Princ_p IS NOT NULL AND nr_prescr_Proc_Princ_p::text <> '') and (nr_seq_Prescr_Proc_Princ_p IS NOT NULL AND nr_seq_Prescr_Proc_Princ_p::text <> '') then
	select	nr_prescricao,
		nr_sequencia,
		nr_seq_proc_interno,
		cd_procedimento,
		ie_origem_proced,
		qt_procedimento,
		cd_setor_atendimento,
		cd_medico_exec,
		nr_seq_exame,
		coalesce(ie_lado,'A'),
        dt_prev_execucao,
        nr_acesso_dicom,
        ie_status_execucao
	into STRICT	nr_prescricao_w,
		nr_seq_prescricao_w,
		nr_seq_proc_interno_w,
		cd_procedimento_w,
		ie_origem_proced_w,
		qt_procedimento_w,
		cd_setor_atendimento_w,
		cd_medico_exec_w,
		nr_seq_exame_w,
		ie_lado_w,
        dt_prev_execucao_w,
        nr_acesso_dicom_w,
        ie_status_execucao_w
	from	prescr_procedimento
	where	nr_prescricao = nr_prescr_Proc_Princ_p
	and 	nr_sequencia = nr_seq_Prescr_Proc_Princ_p;

elsif (nr_seq_interno_Proc_Princ_p IS NOT NULL AND nr_seq_interno_Proc_Princ_p::text <> '') then
	select	nr_prescricao,
		nr_sequencia,
		nr_seq_proc_interno,
		cd_procedimento,
		ie_origem_proced,
		qt_procedimento,
		cd_setor_atendimento,
		cd_medico_exec,
		nr_seq_exame,
		coalesce(ie_lado,'A'),
        dt_prev_execucao,
        nr_acesso_dicom,
        ie_status_execucao
	into STRICT	nr_prescricao_w,
		nr_seq_prescricao_w,
		nr_seq_proc_interno_w,
		cd_procedimento_w,
		ie_origem_proced_w,
		qt_procedimento_w,
		cd_setor_atendimento_w,
		cd_medico_exec_w,
		nr_seq_exame_w,
		ie_lado_w,
 	    dt_prev_execucao_w,
 	    nr_acesso_dicom_w,
 	    ie_status_execucao_w
	from	prescr_procedimento
	where	nr_seq_interno	= nr_seq_interno_Proc_Princ_p;
elsif (nr_acess_dicom_Proc_Princ_p IS NOT NULL AND nr_acess_dicom_Proc_Princ_p::text <> '') then
	select	nr_prescricao,
		nr_sequencia,
		nr_seq_proc_interno,
		cd_procedimento,
		ie_origem_proced,
		qt_procedimento,
		cd_setor_atendimento,
		cd_medico_exec,
		nr_seq_exame,
		coalesce(ie_lado,'A'),
        dt_prev_execucao,
        nr_acesso_dicom,
        ie_status_execucao
	into STRICT	nr_prescricao_w,
		nr_seq_prescricao_w,
		nr_seq_proc_interno_w,
		cd_procedimento_w,
		ie_origem_proced_w,
		qt_procedimento_w,
		cd_setor_atendimento_w,
		cd_medico_exec_w,
		nr_seq_exame_w,
		ie_lado_w,
        dt_prev_execucao_w,
        nr_acesso_dicom_w,
        ie_status_execucao_w

	from	prescr_procedimento
	where	nr_acesso_dicom	= nr_acess_dicom_Proc_Princ_p;
end if;

if (coalesce(nr_prescricao_w,0) > 0) and (coalesce(nr_seq_prescricao_w,0) > 0) then

	select 	coalesce(MAX(ie_aprov_laudo_webservice),'N'),
			CASE WHEN coalesce(max(b.ie_altera_status_exec),'N')='S' THEN 1  ELSE 9 END ,
            a.cd_estabelecimento
	into STRICT	ie_aprov_laudo_w,
			cd_acao_w,
            cd_estabelecimento_w
	from	prescr_medica a,
			parametro_integracao_pacs b
	where   a.cd_estabelecimento = b.cd_estabelecimento
	and		a.nr_prescricao = nr_prescricao_w group by a.cd_estabelecimento;

	if (cd_Medico_tasy_p IS NOT NULL AND cd_Medico_tasy_p::text <> '') then
		select	count(*)
		into STRICT	qt_existe_medico_w
		from	medico
		where	cd_pessoa_fisica	= cd_Medico_tasy_p;

		if (qt_existe_medico_w = 0) then
			select	coalesce(max(cd_pessoa_fisica),'0')
			into STRICT	cd_medico_resp_w
			from	medico
			where	nr_crm	= to_char(nr_CRM_Laudante_p)
			and	uf_crm	= ds_UF_CRM_Laudante_p;
		else
			cd_medico_resp_w	:= cd_Medico_tasy_p;
		end if;
	else
		select	coalesce(max(cd_pessoa_fisica),'0')
		into STRICT	cd_medico_resp_w
		from	medico
		where	nr_crm	= to_char(nr_CRM_Laudante_p)
		and	uf_crm	= ds_UF_CRM_Laudante_p;
	end if;

	if (coalesce(cd_medico_resp_w,'0') = '0') then
		ds_erro_p := ds_erro_p || WHEB_MENSAGEM_PCK.get_texto(1131747,null);
	else
		select	coalesce(max(nr_sequencia),0),
			max(nr_atendimento),
			max(dt_entrada_unidade)
		into STRICT	nr_seq_propaci_w,
			nr_atendimento_w,
			dt_entrada_unidade_w
		from	procedimento_paciente
		where	nr_prescricao		= nr_prescricao_w
		and	nr_sequencia_prescricao	= nr_seq_prescricao_w
		and qt_procedimento > 0;

		if (nr_seq_propaci_w = 0) then
			CALL Gerar_Proc_Pac_item_Prescr(	nr_prescricao_w,
							nr_seq_prescricao_w,
							null,
							null,
							nr_seq_proc_interno_w,
							cd_procedimento_w,
							ie_origem_proced_w,
							qt_procedimento_w,
							cd_setor_atendimento_w,
							cd_acao_w,
							dt_prev_execucao_w,
							'IntegracaoWS',
							cd_medico_exec_w,
							null,
							ie_lado_w,
							null);

			select	max(nr_sequencia),
				max(nr_atendimento),
				max(dt_entrada_unidade)
			into STRICT	nr_seq_propaci_w,
				nr_atendimento_w,
				dt_entrada_unidade_w
			from	procedimento_paciente
			where	nr_prescricao		= nr_prescricao_w
			and	nr_sequencia_prescricao	= nr_seq_prescricao_w
			and qt_procedimento > 0;

		else
			begin

			select	count(*)
			into STRICT	qt_existe_w
			from	procedimento_paciente a,
				prescr_procedimento b
			where	a.nr_prescricao			= nr_prescricao_w
			and	a.nr_sequencia_prescricao	= nr_seq_prescricao_w
			and	a.nr_prescricao 		= b.nr_prescricao
			and	a.nr_sequencia_prescricao 	= b.nr_sequencia
			and	coalesce(b.dt_cancelamento::text, '') = ''
			and	b.ie_status_execucao 		< '20';

			if (qt_existe_w > 0) then
				begin

				select	coalesce(max(nr_seq_exame),0)
				into STRICT	nr_seq_exame_w
				from	prescr_procedimento
				where	nr_prescricao = nr_prescricao_w
				and		nr_sequencia  = nr_seq_prescricao_w;

				CALL atualiza_status_proced_exec(nr_seq_prescricao_w,
											nr_prescricao_w,
											nr_seq_exame_w,
											nm_usuario_p);

				end;
			end if;



			end;
		end if;

		select	coalesce(max(nr_laudo),0) + 1
		into STRICT	nr_laudo_w
		from	laudo_paciente
		where	nr_atendimento	= nr_atendimento_w;

		select 	coalesce(max(nr_sequencia),0)
		into STRICT	nr_seq_laudo_ant_w
		from	laudo_paciente
		where	cd_laudo_externo = cd_laudo_Externo_p
		and	nr_seq_proc <> nr_seq_propaci_w;

		if (nr_seq_laudo_ant_w > 0) then

			update	procedimento_paciente
			set	nr_laudo = nr_seq_laudo_ant_w
			where	nr_sequencia	= nr_seq_propaci_w;
			cd_Laudo_tasy_p := nr_seq_laudo_ant_w;
		else
			select	nextval('laudo_paciente_seq')
			into STRICT	nr_seq_laudo_w
			;

			cd_Laudo_tasy_p := nr_seq_laudo_w;

			select 	coalesce(max(nr_sequencia),0)
			into STRICT	nr_seq_laudo_atual_w
			from	laudo_paciente
			where	cd_laudo_externo = cd_laudo_Externo_p
			and	nr_seq_proc = nr_seq_propaci_w;
			/*
			select	dbms_lob.substr(:new.ds_laudo, dbms_lob.GetLength(:new.ds_laudo), 1)
			into	ds_laudo_w
			from	dual;
			exception
				when others then
					select	dbms_lob.substr(:new.ds_laudo, 4000, 1)
					into	ds_laudo_w
					from	dual;
			end;
			*/
			begin
				Select	ds_laudo
				into STRICT	ds_laudo_w
				from 	W_REGISTRO_LAUDO
				where	nr_sequencia = nr_seq_reg_laudo_p;
			exception
			when others then
				ds_laudo_w := '';
			end;

			ds_titulo_laudo_w := ds_titulo_p;
			if (coalesce(ds_titulo_laudo_w::text, '') = '') then
				Select	substr(obter_desc_prescr_proc_laudo(p.cd_procedimento,
					p.ie_origem_proced,
					p.nr_seq_proc_interno,
					p.ie_lado,
					nr_seq_propaci_w),1,255)
				into STRICT	ds_titulo_laudo_w
				from	prescr_procedimento p
				where	nr_prescricao	= nr_prescricao_w
				and 	nr_sequencia	= nr_seq_prescricao_w;
			end if;

        if (ie_aprov_laudo_w = 'S') then
          dt_aprovacao_w     := clock_timestamp();

            select nm_usuario
              into STRICT nm_usuario_aprov_w
              from usuario p
             where p.cd_pessoa_fisica = cd_medico_resp_w and p.ie_situacao = 'A';
          if (coalesce(dt_liberacao_p::text, '') = '') then
            dt_liberacao_w   := clock_timestamp();
            nm_usuario_lib_w := nm_usuario_p;
          end if;

        end if;

			insert into laudo_paciente(
				nr_sequencia,
				nr_atendimento,
				dt_entrada_unidade,
				nr_laudo,
				nm_usuario,
				dt_atualizacao,
				cd_medico_resp,
				ds_titulo_laudo,
				dt_laudo,
				nr_prescricao,
				ds_laudo,
				nr_seq_proc,
				nr_seq_prescricao,
				dt_liberacao,
				qt_imagem,
				ie_status_laudo,
				cd_laudo_externo,
				dt_aprovacao,
				nm_usuario_aprovacao,
				nm_usuario_liberacao,
				dt_exame)
			values (	nr_seq_laudo_w,
				nr_atendimento_w,
				dt_entrada_unidade_w,
				nr_laudo_w,
				'IntegracaoWS',
				clock_timestamp(),
				cd_medico_resp_w,
				ds_titulo_laudo_w,
				dt_laudo_p,
				nr_prescricao_w,
				ds_laudo_w,
				nr_seq_propaci_w,
				nr_seq_prescricao_w,
				coalesce(dt_liberacao_p,dt_liberacao_w),
				0,
				ie_status_Laudo_p,
				cd_laudo_Externo_p,
				dt_aprovacao_w,
				nm_usuario_aprov_w,
				nm_usuario_lib_w,
				clock_timestamp());

			update	procedimento_paciente
			set	nr_laudo	= nr_seq_laudo_w
			where	nr_sequencia	= nr_seq_propaci_w;

			if (nr_seq_laudo_atual_w > 0) then

				select	ds_laudo
				into STRICT	ds_laudo_copia_w
				from	laudo_paciente
				where 	nr_sequencia = nr_seq_laudo_atual_w;

				CALL gerar_copia_laudo_registro(nr_seq_laudo_atual_w, nr_seq_laudo_w, 'IntegracaoWS', obter_desc_expressao(779496));

				update	laudo_paciente_copia
				set	nr_seq_laudo = nr_seq_laudo_w
				where	nr_seq_laudo = nr_seq_laudo_atual_w;

				update	LAUDO_PACIENTE_MEDICO
				set	nr_seq_laudo = nr_seq_laudo_w
				where	nr_seq_laudo = nr_seq_laudo_atual_w;

				delete  FROM laudo_paciente_pdf_serial
				where   nr_seq_laudo = nr_seq_laudo_atual_w;

				delete 	FROM laudo_paciente
				where	nr_sequencia = nr_seq_laudo_atual_w;
			end if;
		end if;
	end if;

  else
    ds_erro_p := ds_erro_p || WHEB_MENSAGEM_PCK.get_texto(281556, null);

  end if;

  if ie_aprov_laudo_w = 'S' then

      SELECT coalesce(MAX(1), 0) QTD
      INTO STRICT   regra_conferencia
      FROM   regra_conferencia_laudo rcl
      WHERE  coalesce(rcl.cd_estabelecimento, obter_estabelecimento_ativo) = obter_estabelecimento_ativo
      AND    coalesce(rcl.cd_procedimento, coalesce(cd_procedimento_w, 0)) = coalesce(cd_procedimento_w, 0)
      AND    coalesce(rcl.ie_origem_proced, coalesce(ie_origem_proced_w, 0)) = coalesce(ie_origem_proced_w, 0)
      AND    coalesce(rcl.nr_seq_proc_interno, coalesce(nr_seq_proc_interno_w, 0)) = coalesce(nr_seq_proc_interno_w, 0)
      AND    coalesce(rcl.cd_setor_atendimento, coalesce(cd_setor_atendimento_w, 0)) = coalesce(cd_setor_atendimento_w, 0)
      AND    coalesce(rcl.ie_ativo, 'N') = 'S';

      if (regra_conferencia > 0) then
        UPDATE prescr_procedimento a
          SET a.ie_status_execucao = '37',
            a.nm_usuario  = nm_usuario_p
          WHERE a.nr_prescricao = nr_prescricao_w
          AND a.NR_ACESSO_DICOM  IN (nr_acesso_dicom_w)
            AND EXISTS ( SELECT 1
                   FROM procedimento_paciente b
                   WHERE b.nr_prescricao = a.nr_prescricao
                   AND b.nr_sequencia_prescricao = a.nr_sequencia);
      else      
        UPDATE prescr_procedimento a
        SET a.ie_status_execucao = '40',
          a.nm_usuario  = nm_usuario_p
        WHERE a.nr_prescricao = nr_prescricao_w
        AND a.NR_ACESSO_DICOM  IN (nr_acesso_dicom_w)
          AND EXISTS ( SELECT 1
                 FROM procedimento_paciente b
                 WHERE b.nr_prescricao = a.nr_prescricao
                 AND b.nr_sequencia_prescricao = a.nr_sequencia);

        select   max(ie_status_execucao)
        into STRICT  ie_status_execucao_w
        from  prescr_procedimento a
        where  a.nr_prescricao = nr_prescricao_w
        and  a.nr_sequencia  = nr_seq_prescricao_w;

          if (ie_status_execucao_w <> '40') then
  
          UPDATE prescr_procedimento a
          SET a.ie_status_execucao = '40',
              a.nm_usuario  = nm_usuario_p
          WHERE a.nr_prescricao = nr_prescricao_w
          AND a.NR_ACESSO_DICOM  IN (nr_acesso_dicom_w)
          AND EXISTS ( SELECT 1
                FROM procedimento_paciente b
                WHERE b.nr_prescricao = a.nr_prescricao
                AND b.nr_sequencia_prescricao = nr_seq_prescricao_w);

        end if;

        ie_alterar_medico_conta_w 	    := obter_valor_param_usuario(99010, 55, obter_perfil_ativo, obter_usuario_ativo, cd_estabelecimento_w);
		ie_alterar_medico_exec_conta_w 	:= obter_valor_param_usuario(99010, 56, obter_perfil_ativo, obter_usuario_ativo, cd_estabelecimento_w);

        if (ie_alterar_medico_conta_w = 'S') then
            CALL atualiza_med_propaci_integra(nr_seq_laudo_w,'EX','IntegracaoWS',99010);
        end if;

    	if	((ie_alterar_medico_exec_conta_w = 'S') or (ie_alterar_medico_exec_conta_w = 'M')) then
			CALL atualiza_med_propaci_integra(nr_seq_laudo_w,'EXC','IntegracaoWS',99010);
        end if;

      end if;
  end if;

  commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_laudo_integracao_ws ( cd_laudo_Externo_p bigint, ds_titulo_p text, ie_status_Laudo_p text, dt_laudo_p timestamp, nr_prescr_Proc_Princ_p bigint, nr_seq_Prescr_Proc_Princ_p bigint, nr_seq_interno_Proc_Princ_p bigint, nr_acess_dicom_Proc_Princ_p text, cd_Medico_tasy_p text, nr_CRM_Laudante_p text, ds_UF_CRM_Laudante_p text, dt_liberacao_p timestamp, nr_seq_reg_laudo_p bigint, nm_usuario_p text, cd_Laudo_tasy_p INOUT bigint, ds_erro_p INOUT text) FROM PUBLIC;

