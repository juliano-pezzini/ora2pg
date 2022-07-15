-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE laudo_paciente_insert_colpox ( cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%TYPE, nr_atendimento_p prescr_medica.nr_atendimento%TYPE, nr_acesso_dicom_p prescr_procedimento.nr_acesso_dicom%TYPE, dt_laudo_p laudo_paciente.dt_laudo%TYPE, nm_medico_resp usuario.nm_usuario%type, ds_diretorio_p laudo_paciente.ds_arquivo%TYPE, cd_medico_p prescr_medica.cd_medico%TYPE, biopsia_colpox_p laudo_paciente_colpox.biopsia_colpox%TYPE, diagnostico_colpox_p laudo_paciente_colpox.biopsia_colpox%TYPE) AS $body$
DECLARE

         
nr_sequencia_w                  laudo_paciente.nr_sequencia%TYPE;
nr_prescricao_w		            prescr_procedimento.nr_prescricao%TYPE;
nr_seq_prescr_w		            prescr_procedimento.nr_sequencia%TYPE;
ds_titulo_laudo_w	            varchar(255);
cd_protocolo_w        		    prescr_procedimento.cd_protocolo%TYPE               := null;
nr_atendimento_w	            prescr_medica.nr_atendimento%TYPE;
dt_entrada_unidade_w	        laudo_paciente.dt_entrada_unidade%TYPE;
dt_resultado_w			        prescr_procedimento.dt_resultado%TYPE;
cd_estabelecimento_w	        prescr_medica.cd_estabelecimento%TYPE;
nr_seq_proc_interno_w	        prescr_procedimento.nr_seq_proc_interno%TYPE;
cd_procedimento_w	            prescr_procedimento.cd_procedimento%TYPE;
ie_origem_proced_w	            prescr_procedimento.ie_origem_proced%TYPE;
qt_procedimento_w	            prescr_procedimento.qt_procedimento%TYPE;
cd_setor_atend_prescr_w		    prescr_procedimento.cd_setor_atendimento%TYPE;
cd_medico_exec_prescr_w 	    prescr_procedimento.cd_medico_exec%TYPE;
nr_seq_exame_w		            prescr_procedimento.nr_seq_exame%TYPE;
ie_lado_w		                prescr_procedimento.ie_lado%TYPE;
DT_BAIXA_w			            prescr_procedimento.dt_baixa%TYPE;
dt_prev_execucao_w	            prescr_procedimento.dt_prev_execucao%TYPE;
cd_setor_atendimento_w	        prescr_procedimento.cd_setor_atendimento%TYPE;
nr_seq_propaci_w	            bigint;
cd_medico_exec_w	            prescr_procedimento.cd_medico_exec%TYPE;
nr_laudo_w        	            laudo_paciente.nr_laudo%TYPE;
nr_seq_laudo_w		            bigint;
ie_alterar_medico_conta_w 	    varchar(2);
ie_alterar_medico_exec_conta_w	varchar(2);
ie_status_execucao_w	        prescr_procedimento.ie_status_execucao%TYPE;
nr_sequencia_atual_w            laudo_paciente.nr_sequencia%TYPE;
justificativa_w                 varchar(100);


BEGIN

    select	
		coalesce(max(a.nr_prescricao),null),
		coalesce(max(a.nr_sequencia),null),
		coalesce(max(substr(obter_desc_prescr_proc(cd_procedimento, ie_origem_proced, nr_seq_proc_interno),1,255)), null),
		coalesce(max(a.cd_protocolo),null),
		coalesce(max(b.nr_atendimento),null),
		coalesce(max(b.dt_prescricao),null),
		max(a.dt_baixa),
		max(a.dt_resultado),
		max(b.cd_estabelecimento),
		max(a.nr_seq_proc_interno),
		max(a.cd_procedimento),
		max(a.ie_origem_proced),
		max(a.qt_procedimento),
		max(a.cd_setor_atendimento),
		max(a.cd_medico_exec),
		max(a.nr_seq_exame),
		max(a.ie_lado),
        coalesce(max(dt_prev_execucao), null)
	into STRICT	
		NR_PRESCRICAO_W,		
		NR_SEQ_PRESCR_W,
		DS_TITULO_LAUDO_W,
		cd_protocolo_w,
		NR_ATENDIMENTO_W,
		dt_entrada_unidade_w,
		DT_BAIXA_W,
		DT_RESULTADO_W,
		cd_estabelecimento_w,
		NR_SEQ_PROC_INTERNO_W,
		CD_PROCEDIMENTO_W,	
		IE_ORIGEM_PROCED_W,
		QT_PROCEDIMENTO_W,	
		CD_SETOR_ATEND_PRESCR_W,
		CD_MEDICO_EXEC_PRESCR_W,
		NR_SEQ_EXAME_W,
		IE_LADO_W,
        DT_PREV_EXECUCAO_W
	from prescr_medica b,
		 prescr_procedimento a
	where 	
        a.nr_acesso_dicom = nr_acesso_dicom_p
        and	a.nr_prescricao = b.nr_prescricao;

    if (nr_prescricao_w IS NOT NULL AND nr_prescricao_w::text <> '') then	
        select
			coalesce(max(cd_setor_atendimento), null),
			coalesce(max(cd_medico_executor), null)
		into STRICT    
			CD_SETOR_ATENDIMENTO_W,
			cd_medico_exec_w
		from procedimento_paciente
		where   
			nr_prescricao = nr_prescricao_w
			and     nr_sequencia_prescricao = nr_seq_prescr_w;

            if (coalesce(CD_SETOR_ATENDIMENTO_W::text, '') = '') then

                CALL gerar_proc_pac_item_prescr_up(
                    nr_prescricao_w,
                    nr_seq_prescr_w, 
                    null, 
                    null,
                    nr_seq_proc_interno_w,
                    cd_procedimento_w, 
                    ie_origem_proced_w,
                    qt_procedimento_w, 
                    cd_setor_atend_prescr_w,
                    9, 
                    dt_prev_execucao_w,
                    'COLPOX', 
                    cd_medico_exec_prescr_w, 
                    nr_seq_exame_w, 
                    coalesce(ie_lado_w,'A'), 
                    null);			
            end if;
    end if;

    select coalesce(max(nr_sequencia), null)
	into STRICT NR_SEQ_PROPACI_W
	from procedimento_paciente
	where   
		nr_prescricao = nr_prescricao_w
		and nr_sequencia_prescricao = nr_seq_prescr_w;

	select 	coalesce(max(nr_laudo),0) + 1
	into STRICT	nr_laudo_w
	from	laudo_paciente
	where	
        nr_atendimento = nr_atendimento_w;

        if (dt_resultado_w	> clock_timestamp())then
			dt_resultado_w	:= clock_timestamp();
		end if;

        select MAX(nr_sequencia)
        into STRICT   nr_sequencia_atual_w
        from   laudo_paciente
        where  nr_prescricao = nr_prescricao_w
        and    nr_seq_prescricao = nr_seq_prescr_w;

		select 	nextval('laudo_paciente_seq')
		into STRICT	nr_sequencia_w
		;

		insert into laudo_paciente(	
				NR_SEQUENCIA,
				NR_ATENDIMENTO,
				DT_ENTRADA_UNIDADE,    		  
				NR_LAUDO,
				NM_USUARIO,        			  
				DT_ATUALIZACAO,
				cd_medico_resp,        		  
				ds_titulo_laudo,
				dt_laudo,        			  
				ie_normal,        			  
				dt_exame,
				nr_prescricao,        		  
				ds_laudo,
				dt_aprovacao,        		  
				nm_usuario_aprovacao,
				cd_protocolo,        		  
				nr_seq_proc,        		  
				nr_seq_prescricao,
				dt_liberacao,   
				nm_usuario_liberacao,
				cd_setor_atendimento,    	  
				dt_integracao,        		  
				nm_medico_solicitante,
				ds_arquivo,
				ie_formato,
				QT_IMAGEM,
                ie_status_laudo)
			values (
				NR_SEQUENCIA_W,   	  
				NR_ATENDIMENTO_W,
				DT_ENTRADA_UNIDADE_W,         	  
				NR_LAUDO_W,
				'COLPOX',            	  
				clock_timestamp(),
				cd_medico_p,
				DS_TITULO_LAUDO_W,
				dt_laudo_p,
				'S',                		  
				coalesce(DT_BAIXA_W,dt_laudo_p),
				NR_PRESCRICAO_W,        	  
				null,
				clock_timestamp(),    			  
				'COLPOX',
				CD_PROTOCOLO_W,            	  
				NR_SEQ_PROPACI_W,        	  
				NR_SEQ_PRESCR_W,
				clock_timestamp(),   
				'COLPOX',
				CD_SETOR_ATENDIMENTO_W,         
				clock_timestamp(),            		  
				'COLPOX',
				DS_DIRETORIO_P,
				3,
				0,
                'LL');

            select	coalesce(max(nr_sequencia),0)
            into STRICT	nr_seq_laudo_w
            from	laudo_paciente
            where	
               nr_atendimento	= nr_atendimento_w
               and	nr_seq_proc	= nr_seq_propaci_w;

            if (nr_seq_laudo_w > 0) then 
                insert into laudo_paciente_colpox(	
                    NR_SEQUENCIA,        
                    DT_ATUALIZACAO,
                    NM_USUARIO,    		  
                    DT_ATUALIZACAO_NREC,
                    NM_USUARIO_NREC,        			  
                    NR_SEQ_LAUDO,
                    BIOPSIA_COLPOX,        		  
                    DIAGNOSTICO_COLPOX)
                values (
                    nextval('laudo_paciente_colpox_seq'),   	  
                    clock_timestamp(),
                    'COLPOX',         	  
                    clock_timestamp(),
                    'COLPOX',            	  
                    NR_SEQ_LAUDO_W,
                    BIOPSIA_COLPOX_P,
                    DIAGNOSTICO_COLPOX_P);
             end if;

				ie_alterar_medico_conta_w 	    := obter_valor_param_usuario(99010, 55, obter_perfil_ativo, obter_usuario_ativo, cd_estabelecimento_w);
				ie_alterar_medico_exec_conta_w 	:= obter_valor_param_usuario(99010, 56, obter_perfil_ativo, obter_usuario_ativo, cd_estabelecimento_w);

                if (ie_alterar_medico_conta_w = 'S') then
					CALL atualiza_med_propaci_integra(nr_seq_laudo_w,'EX','COLPOX',99010);
				end if;

				if	((ie_alterar_medico_exec_conta_w = 'S') or (ie_alterar_medico_exec_conta_w = 'M')) then
					CALL atualiza_med_propaci_integra(nr_seq_laudo_w,'EXC','COLPOX',99010);
				end if;

                if (nr_sequencia_atual_w > 0) then
                    justificativa_w := wheb_mensagem_pck.get_texto(299648);
                    CALL GERAR_COPIA_LAUDO_PADRAO(nr_sequencia_atual_w, nr_seq_laudo_w, null, 'COLPOX', justificativa_w);

                    delete 	FROM laudo_paciente
					where	nr_sequencia = nr_sequencia_atual_w;
                end if;

				/* *****  Atualiza status execucao na prescricao ***** */

        		UPDATE prescr_procedimento a
				SET a.ie_status_execucao = '40',
					a.nm_usuario  = 'COLPOX'
				WHERE
					a.nr_prescricao = nr_prescricao_w 
					AND a.NR_ACESSO_DICOM  IN (nr_acesso_dicom_p)
					AND EXISTS ( SELECT 1
								 FROM procedimento_paciente b
								 WHERE b.nr_prescricao = a.nr_prescricao
								 AND b.nr_sequencia_prescricao = a.nr_sequencia);

				select max(ie_status_execucao)
				into STRICT ie_status_execucao_w
				from prescr_procedimento a
				where
					a.nr_prescricao = nr_prescricao_w
					and  a.nr_sequencia  = NR_SEQ_PRESCR_W;

				if (ie_status_execucao_w <> '40') then			
					UPDATE prescr_procedimento a
					SET a.ie_status_execucao = '40',
						a.nm_usuario  = 'COLPOX'
					WHERE 
						a.nr_prescricao = nr_prescricao_w
						AND a.NR_ACESSO_DICOM  IN (nr_acesso_dicom_p)
						AND EXISTS ( SELECT 1
								FROM procedimento_paciente b
								WHERE b.nr_prescricao = a.nr_prescricao
								AND b.nr_laudo = NR_SEQ_LAUDO_W);		
				end if;

				 /* ***** FIM Atualiza status execucao na prescricao ***** */

                update	procedimento_paciente
                set	nr_laudo =  nr_sequencia_w
                where nr_sequencia = nr_seq_propaci_w;	

				CALL gravar_auditoria_mmed(nr_prescricao_w,nr_seq_prescr_w,'COLPOX',39,null);

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE laudo_paciente_insert_colpox ( cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%TYPE, nr_atendimento_p prescr_medica.nr_atendimento%TYPE, nr_acesso_dicom_p prescr_procedimento.nr_acesso_dicom%TYPE, dt_laudo_p laudo_paciente.dt_laudo%TYPE, nm_medico_resp usuario.nm_usuario%type, ds_diretorio_p laudo_paciente.ds_arquivo%TYPE, cd_medico_p prescr_medica.cd_medico%TYPE, biopsia_colpox_p laudo_paciente_colpox.biopsia_colpox%TYPE, diagnostico_colpox_p laudo_paciente_colpox.biopsia_colpox%TYPE) FROM PUBLIC;

