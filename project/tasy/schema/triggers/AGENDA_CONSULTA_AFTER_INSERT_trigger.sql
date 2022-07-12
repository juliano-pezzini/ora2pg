-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS agenda_consulta_after_insert ON agenda_consulta CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_agenda_consulta_after_insert() RETURNS trigger AS $BODY$
DECLARE

cd_tipo_agenda_w		bigint;
qt_proc_w			bigint;
qt_regra_w			bigint;
ie_gravar_indicacao_pf_w	varchar(1);
cd_estabelecimento_w		integer;
ie_prontuario_w			varchar(1);
ie_gerar_w			varchar(1);
nr_prontuario_w			bigint;

ie_gerar_prof_hor_livre_w	varchar(1) := 'N';
ie_gerar_prof_ordem_w		varchar(1);
qt_regra_comunic_w		bigint;
ie_save_insurance_holder_w	varchar(1);
ie_gerar_consentimento_w	varchar(1);
ie_atual_proc_cons_w varchar(1) := 'N';
ds_param_integration_w	varchar(255);
json_data_w           	text;
old_nr_sequencia_w   	rp_implementation_reab.nr_seq_impl_agenda%TYPE;
nr_prescricao_w	     	prescr_procedimento.nr_prescricao%TYPE;

qt_tipo_evento_w     bigint;
qt_evento_tarefa_w   bigint;


C01 CURSOR FOR
	SELECT	'S'
	from	regra_prontuario
	where	cd_estabelecimento						= cd_estabelecimento_w
	and	ie_tipo_regra							= 4;

c02 CURSOR FOR
    SELECT  h.nr_seq_sub_grp nr_seq_sub_grp
    FROM    
        cpoe_procedimento a,
        prescr_procedimento b,
        rp_tratamento c,
        prescr_medica d,
        rp_pac_agend_individual e,
        cpoe_order_unit g,
        cpoe_tipo_pedido  h
    where   b.nr_seq_proc_cpoe = a.nr_sequencia 
            and     b.nr_prescricao = d.nr_prescricao
            and     a.nr_seq_cpoe_order_unit = g.nr_sequencia
            and     c.nr_seq_cpoe_procedimento = a.nr_sequencia
            and     e.nr_seq_tratamento = c.nr_sequencia
            and     e.nr_sequencia = NEW.nr_seq_rp_item_ind
            and     g.nr_seq_cpoe_tipo_pedido = h.nr_sequencia            
            and     h.nr_seq_sub_grp = 'RE';

BEGIN

ie_save_insurance_holder_w := obter_parametro_agenda(wheb_usuario_pck.get_cd_estabelecimento, 'IE_SAVE_INSURANCE_HOLDER', 'N');
if (ie_save_insurance_holder_w = 'S') and (NEW.cd_pessoa_fisica is not null) and (NEW.cd_convenio is not null) and
	((coalesce(NEW.cd_convenio, 0) <> coalesce(OLD.cd_convenio, 0)) or (coalesce(NEW.cd_pessoa_fisica, '0') <> coalesce(OLD.cd_pessoa_fisica, '0')) or (coalesce(NEW.cd_categoria, '0') <> coalesce(OLD.cd_categoria, '0')) or (coalesce(NEW.cd_usuario_convenio, '0') <> coalesce(OLD.cd_usuario_convenio, '0'))) then
		CALL insere_atualiza_titular_conv(
				NEW.nm_usuario,
				NEW.cd_convenio,
				NEW.cd_categoria,
				NEW.cd_pessoa_fisica,
				NEW.cd_plano,
				null,
				NEW.dt_validade_carteira,
				NEW.dt_validade_carteira,
				null,
				NEW.cd_usuario_convenio,
				null,
				'N',
				'2');
  end if;


if (wheb_usuario_pck.get_ie_executar_trigger	= 'S')  then


	select	max(cd_tipo_agenda),
		max(cd_estabelecimento),
		coalesce(max(ie_gerar_prof_hor),'N')
	into STRICT	cd_tipo_agenda_w,
		cd_estabelecimento_w,
		ie_gerar_prof_ordem_w
	from	agenda
	where 	cd_agenda	= NEW.cd_agenda;
	
	ie_gerar_prof_hor_livre_w := Obter_Param_Usuario(866, 141, obter_perfil_ativo, NEW.nm_usuario, cd_estabelecimento_w, ie_gerar_prof_hor_livre_w);

	if (not TG_OP = 'INSERT') then
			if (OLD.ie_status_agenda is not null) and (NEW.ie_status_agenda is not null) and (NEW.dt_copia_Trans is null) and (NEW.nm_paciente is not null) and (OLD.nm_paciente is null) then
				select	count(*)
				into STRICT	qt_regra_comunic_w
				from	agenda_regra_envio_ci
				where	coalesce(ie_agendamento,'N') = 'S'
				and	((cd_agenda = NEW.cd_agenda) or (cd_agenda is null));
				
				if (cd_tipo_agenda_w = 5) and (qt_regra_comunic_w > 0)then	
					CALL Gerar_comunic_ageserv('A',
							NEW.cd_agenda,
							NEW.nm_paciente,
							NEW.dt_agenda,
							NEW.nm_usuario,
							null,
							NEW.cd_convenio,
							NEW.ds_observacao,
							NEW.ie_classif_agenda);
				end if;
			end if;
	end if;
	
	if (cd_tipo_agenda_w = 5) and (ie_gerar_prof_ordem_w = 'N') and
		(((NEW.cd_pessoa_fisica is not null)  and (NEW.ie_status_agenda not in ('B','L','C')) and (obter_se_agenda_serv_prof(NEW.nr_sequencia) = 'N')) or (ie_gerar_prof_hor_livre_w = 'S')) then	

		CALL Gerar_Prof_Agenda_servico(NEW.cd_agenda, NEW.nr_sequencia, NEW.nr_seq_turno,NEW.dt_agenda, NEW.nm_usuario);	

	end if;

	if (cd_tipo_agenda_w in (3,5)) and (NEW.cd_pessoa_fisica is not null)  and (NEW.ie_status_agenda not in ('B','L','C')) then

    select	max(coalesce(ie_atual_proc_cons,'N'))
    into STRICT	   ie_atual_proc_cons_w
    from	   parametro_agenda
    where 	cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento;

    if (ie_atual_proc_cons_w	 = 'S') and (OLD.ie_classif_agenda	<> NEW.ie_classif_agenda) and (NEW.nr_Atendimento is null) then
      
			delete 	FROM agenda_consulta_proc a
			where	a.nr_seq_agenda = NEW.nr_sequencia 
			and (coalesce(a.ie_gerado_regra, 'N') =  'S'
			or		exists (SELECT 1 from agenda_regra_proced b 
							where b.cd_agenda 				= NEW.cd_agenda
							and		a.nr_Seq_proc_interno 	= b.nr_Seq_proc_interno
							and		coalesce(coalesce(cd_convenio,OLD.cd_convenio),'0') = coalesce(OLD.cd_convenio,'0')
							and		coalesce(coalesce(ie_classif_agenda,OLD.ie_classif_Agenda),'X') = coalesce(OLD.ie_classif_Agenda,'X')));

		end if;

    select	count(*)
    into STRICT	qt_proc_w
    from	agenda_consulta_proc
		where	nr_seq_agenda = NEW.nr_sequencia
		and (coalesce(ie_gerado_regra, 'N') =  'S' or ie_atual_proc_cons_w = 'N');

		if (qt_proc_w = 0) then
			CALL inserir_proc_regra_agenda_cons(NEW.cd_agenda, NEW.nr_sequencia, NEW.IE_CLASSIF_AGENDA, NEW.cd_convenio, NEW.cd_categoria, cd_estabelecimento_w, NEW.nm_usuario);

		end if;

	end if;

	ie_gravar_indicacao_pf_w := Obter_Param_Usuario(821, 57, obter_perfil_ativo, NEW.nm_usuario, 0, ie_gravar_indicacao_pf_w);

	if (ie_gravar_indicacao_pf_w = 'S') and (NEW.cd_pessoa_fisica is not null)  and (NEW.nr_seq_indicacao is not null) and (coalesce(NEW.nr_seq_indicacao,0) <> coalesce(OLD.nr_seq_indicacao,0)) then
		
		select 	count(*)
		into STRICT	qt_regra_w
		from	pessoa_fisica_indicacao
		where	nr_seq_tipo_indic_pf = NEW.NR_SEQ_INDICACAO
		and		cd_pessoa_indicada = NEW.cd_pessoa_fisica;
		
		if (qt_regra_w = 0) then
		
			insert into pessoa_fisica_indicacao(nr_sequencia,
							dt_atualizacao,
							nm_usuario,
							cd_pessoa_indicada,
							nr_seq_tipo_indic,
							cd_pessoa_fisica,
							ds_observacao,
							dt_atualizacao_nrec,
							nm_usuario_nrec,
							nr_seq_tipo_indic_pf,
							ie_cadastro,
							cd_especialidade,
							nr_seq_tipo_midia)
				values (nextval('pessoa_fisica_indicacao_seq'),
							LOCALTIMESTAMP,
							NEW.nm_usuario,
							NEW.cd_pessoa_fisica,
							null,
							NEW.cd_pessoa_indicacao, 
							null,
							LOCALTIMESTAMP,
							NEW.nm_usuario,
							NEW.NR_SEQ_INDICACAO,
							'P',
							null,
							NEW.nr_seq_tipo_midia);
		end if;

	end if;
	
	if (NEW.cd_pessoa_fisica is not null) and (OLD.cd_pessoa_fisica is null) then
		
		CALL gerar_regra_prontuario_gestao(null, cd_estabelecimento_w, null, NEW.cd_pessoa_fisica, NEW.nm_usuario,NEW.nr_sequencia, null, null, null, null, null, null);
		
		select 		coalesce(max(nr_prontuario),0)
		into STRICT		nr_prontuario_w
		from		Pessoa_fisica
		where		cd_pessoa_fisica	= NEW.cd_pessoa_fisica;
		
		if (nr_prontuario_w = 0) then
		
			SELECT	Obter_Valor_Param_Usuario(0,32,0,NEW.nm_usuario,cd_estabelecimento_w)
			into STRICT	ie_prontuario_w
			;
			
			if (ie_prontuario_w = 'R') then
				OPEN C01;
				LOOP
				FETCH C01 into ie_gerar_w;
				EXIT WHEN NOT FOUND; /* apply on c01 */
				END LOOP;
				CLOSE C01;	
			end if;
			if (ie_gerar_w = 'S') then
				/* Matheus OS 182242
				select	prontuario_seq.nextval
				into		nr_prontuario_w
				from		dual;

				update 	pessoa_fisica
				set		nr_prontuario	= nr_prontuario_w
				where		cd_pessoa_fisica	= :new.cd_pessoa_fisica;*/

				nr_prontuario_w := gerar_prontuario_pac(cd_estabelecimento_w, NEW.cd_pessoa_fisica, 'N', NEW.nm_usuario, nr_prontuario_w);
			end if;
		end if;
	end if;
	
	if (OLD.nm_paciente is not null) and (coalesce(NEW.nm_paciente,'X') <> OLD.nm_paciente) and (NEW.ie_status_agenda = 'C') then
		insert into agenda_log_pac_alt(	
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			ds_log)
		values (	nextval('agenda_log_pac_alt_seq'),
			LOCALTIMESTAMP,
			'Tasy',
			LOCALTIMESTAMP,
			'Tasy',
			substr(wheb_mensagem_pck.get_texto(791350) || ': ' || NEW.nr_sequencia || ' / '|| wheb_mensagem_pck.get_texto(791350) || ': ' || OLD.nm_paciente ||' / ' || NEW.nm_paciente || substr(dbms_utility.format_call_stack,1,1500),1,4000));
	end if;

	ie_gerar_consentimento_w := Obter_Param_Usuario(866, 317, obter_perfil_ativo, NEW.nm_usuario, cd_estabelecimento_w, ie_gerar_consentimento_w);
	/*
	S - Agendamento ou Proc. Adicional
	N - Nao gera
	A - Somente Agendamento
	P - Somente Proc. Adicional
	*/


	if (NEW.ie_status_agenda = 'N' and
		NEW.cd_pessoa_fisica is not null and
		((NEW.cd_procedimento is not null and (NEW.cd_procedimento <> OLD.cd_procedimento or NEW.ie_origem_proced <> OLD.ie_origem_proced or OLD.cd_procedimento is null)) or (NEW.nr_seq_proc_interno is not null and (OLD.nr_seq_proc_interno <> NEW.nr_seq_proc_interno or OLD.nr_Seq_proc_interno is null))) and
		ie_gerar_consentimento_w in ('S','A')) then
		
			CALL agendas_inserir_consentimentos(
					cd_tipo_agenda_w,
					NEW.nr_sequencia,
					NEW.cd_procedimento,
					NEW.ie_origem_proced,
					NEW.nr_seq_proc_interno,
					NEW.cd_pessoa_fisica,
					NEW.cd_medico,
					cd_estabelecimento_w,
					NEW.nr_atendimento);
	end if;
	
	if (not TG_OP = 'INSERT' and OLD.dt_agenda is not null and NEW.dt_agenda is not null and OLD.dt_agenda <> NEW.dt_agenda ) then
		CALL cpoe_exam_update_delete(OLD.nr_sequencia, NEW.dt_agenda,NEW.nr_sequencia);
	end if;
	
	if (coalesce(pkg_i18n.get_user_locale, 'pt_BR') = 'ja_JP') then          -- Locale Japan Check
		if (NEW.ie_status_agenda <> OLD.ie_status_agenda and NEW.ie_status_agenda in ('C','F','A','CN','RE')) or (OLD.dt_confirmacao is null and NEW.dt_confirmacao is not null) then
				ds_param_integration_w :=  '{"recordId" : "' || NEW.nr_sequencia|| '"' || '}';
				CALL execute_bifrost_integration(255,ds_param_integration_w); ------ to choose the event nais.appointment.consultation
				CALL execute_bifrost_integration(257,ds_param_integration_w); ------ to choose the event nais.appointment.service
		end if;
	end if;
	
	--  For Register Patient's arrival in Scheduling Check function

     if (coalesce(pkg_i18n.get_user_locale, 'pt_BR') = 'ja_JP') then 		-- Locale Japan Check
        if ((NEW.nr_seq_pac_senha_fila is not null) and (coalesce(NEW.nr_seq_pac_senha_fila, 0) <> coalesce(OLD.nr_seq_pac_senha_fila, 0))) then
                ds_param_integration_w := '{"recordId" : "' || NEW.nr_sequencia|| '"' || '}';
                CALL execute_bifrost_integration(258,ds_param_integration_w); ------ to choose the event nais.acceptance.consultation
        end if;
    end if;

    if (NEW.nr_seq_rp_item_ind <> coalesce(OLD.nr_seq_rp_item_ind,0)) and (NEW.nr_seq_rp_item_ind is not null) and (NEW.ie_status_agenda <> coalesce(OLD.ie_status_agenda,'L')) and (coalesce(OLD.ie_status_agenda,'L') = 'L') then
            for r_c02 in c02 loop
              BEGIN
                 ds_param_integration_w := '{"recordId" : "' || NEW.nr_sequencia || '"' || ',"typePrescription" : "' || r_c02.nr_seq_sub_grp || '"}';
                 json_data_w := bifrost.send_integration_content('nais.appointment.message.rehabilitation', ds_param_integration_w, NEW.nm_usuario);
                 json_data_w := bifrost.send_integration_content('nais.unexecutedOrder.message.rehabilitation', ds_param_integration_w, NEW.nm_usuario);
              end;
            end loop;
    end if;

    if (NEW.nr_seq_rp_item_ind is not null) and (NEW.ie_status_agenda <> coalesce(OLD.ie_status_agenda,'C')) and (coalesce(NEW.ie_status_agenda,'C') = 'C') then
            for r_c02 in c02 loop
              BEGIN
                 ds_param_integration_w := '{"recordId" : "' || NEW.nr_sequencia || '"' || ',"typePrescription" : "' || r_c02.nr_seq_sub_grp || '"}';
                 json_data_w := bifrost.send_integration_content('nais.itemOrder.cancelation', ds_param_integration_w, NEW.nm_usuario);
              end;
            end loop;
    end if;	
	
------------------------------Rehabilitation cancel message Trigger Start--------------------------------------------------------

     if (coalesce(pkg_i18n.get_user_locale, 'pt_BR') = 'ja_JP') then
        old_nr_sequencia_w := OLD.nr_sequencia;
        if (NEW.IE_STATUS_AGENDA = 'C' and OLD.IE_STATUS_AGENDA = 'E')then 
            select  b.nr_prescricao
            into STRICT    nr_prescricao_w 
            from    cpoe_procedimento a,
                    prescr_procedimento b, 
                    rp_tratamento c,
                    prescr_medica d, 
                    rp_implementation_reab g
            where   a.nr_sequencia = b.nr_seq_proc_cpoe
            and     b.nr_prescricao = d.nr_prescricao
            and     c.nr_seq_cpoe_procedimento = a.nr_sequencia
            and     g.nr_seq_tratamento = c.nr_sequencia
            and     g.nr_seq_impl_agenda = old_nr_sequencia_w
            and     g.ie_exec_status = 'S';

            ds_param_integration_w := '{"recordId" : "' || nr_prescricao_w || '"' || '}';
			json_data_w := bifrost.send_integration_content('nais.rehabilitation', ds_param_integration_w, wheb_usuario_pck.get_nm_usuario);

            end if;
        end if;
------------------------------Rehabilitation cancel message Trigger End--------------------------------------------------------	


------------------------------WSuite Patient Portal - Routine for entering tasks in the patient preparation table---------------------

        select coalesce(max(1),0)
          into STRICT qt_evento_tarefa_w
          from wsuite_preparacao_paciente pp
         where pp.nr_seq_agenda = NEW.nr_sequencia
           and pp.ie_tipo_agenda in (3, 4, 5);

        select  coalesce(max(1),0)
          into STRICT qt_tipo_evento_w
          from wsuite_cad_prep_pac_evento pe
         where pe.ie_tipo_evento = 'ACO'
           and pe.ie_situacao = 'A';

        if (NEW.ie_status_agenda in ('CN','M','N','RE') and qt_evento_tarefa_w = 0 and qt_tipo_evento_w > 0) then

            CALL wsuite_gerar_prep_paciente('ACO',NEW.nr_sequencia,NEW.nm_usuario,cd_tipo_agenda_w, cd_estabelecimento_w, NEW.cd_pessoa_fisica);

        end if;

----------------------------------------------------------------------------------------------------------------------------------------



end if;

RETURN NEW;
END;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_agenda_consulta_after_insert() FROM PUBLIC;

CREATE TRIGGER agenda_consulta_after_insert
	AFTER INSERT OR UPDATE ON agenda_consulta FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_agenda_consulta_after_insert();

