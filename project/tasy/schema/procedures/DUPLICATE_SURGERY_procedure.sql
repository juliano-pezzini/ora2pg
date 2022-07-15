-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE duplicate_surgery (NR_CIRURGIA_P bigint, NM_USUARIO_P text) AS $body$
DECLARE


	id_versao_w                    CIRURGIA_HIST_JAPAO.ID_VERSAO%type;
	
	
BEGIN
    
	IF (NR_CIRURGIA_P IS NOT NULL AND NR_CIRURGIA_P::text <> '') THEN
		
		SELECT MAX(id_versao) 
		INTO STRICT id_versao_w
		FROM CIRURGIA_HIST_JAPAO
		WHERE NR_CIRURGIA = NR_CIRURGIA_P;			
		
		INSERT
		INTO CIRURGIA_HIST_JAPAO(   NR_SEQUENCIA,
			NR_CIRURGIA,
			CD_PESSOA_FISICA,             
			CD_MEDICO_CIRURGIAO,          
			CD_PROCEDIMENTO_PRINC,        
			CD_TIPO_ANESTESIA,            
			NM_USUARIO,                   
			DT_ATUALIZACAO,               
			DT_INICIO_PREVISTA,           
			DT_INICIO_REAL,               
			NR_MIN_DURACAO_PREV,          
			NR_MIN_DURACAO_REAL,          
			DT_TERMINO,                   
			NR_PRESCRICAO,                
			NR_ATENDIMENTO,               
			DT_ENTRADA_UNIDADE,           
			CD_MEDICO_ANESTESISTA,        
			CD_CONVENIO,                  
			DS_OBSERVACAO,                
			IE_ORIGEM_PROCED,             
			IE_STATUS_CIRURGIA,           
			IE_MOTIVO_CANCELAMENTO,       
			IE_CARATER_CIRURGIA,          
			CD_TIPO_CIRURGIA,             
			IE_ANAT_PATOL,                
			IE_TRAUMA,                    
			IE_ORTESE_PROTESE,            
			IE_ANTIBIOTICO,               
			IE_SANGUE,                    
			DS_ANTIBIOTICO,               
			CD_SETOR_ATENDIMENTO,         
			DT_TERMINO_PREVISTA,          
			DT_ENTRADA_RECUP,             
			DT_SAIDA_RECUP_PREV,          
			DT_SAIDA_RECUP,               
			NR_SEQ_STATUS,                
			DS_ANDAMENTO,                 
			DT_CHAMADA,                   
			DT_PREPARACAO,                
			DT_CHEGADA_SALA,              
			DT_CHEGADA_ANESTESISTA,       
			DT_INICIO_ANESTESIA,          
			DT_CHEGADA_CIRURGIAO,         
			DT_INICIO_CIRURGIA,           
			DT_FIM_CIRURGIA,              
			DT_FIM_EXTUBACAO,             
			DT_LIBERACAO_SALA,            
			IE_ASA_ESTADO_PACIENTE,       
			CD_MEDICO_REQ,                
			IE_LEITO_UTI,                 
			IE_PECA_ANAT_PATOL,           
			DT_CHEGADA_SRPA,              
			DT_ENTR_MATMED,               
			NM_USUARIO_MATMED,            
			DT_SAIDA_SALA,                
			CD_ESTABELECIMENTO,           
			DT_FIM_ANESTESIA,             
			IE_PORTE,                     
			IE_LADO,                      
			NR_SEQ_PROC_INTERNO,          
			QT_RIC,                       
			DT_LIB_NISS,                  
			IE_INFECCAO,                  
			DT_INFECCAO,                  
			NR_SEQ_PROCED_NISS,           
			DT_LIBERACAO,                 
			NM_USUARIO_LIB,               
			QT_PESO,                      
			NR_SEQ_INTERRUPCAO,           
			IE_SITIO_INFECCAO,            
			IE_CONTROLA_PESO,             
			IE_TIPO_CIRURGIA,             
			IE_REOPERACAO,                
			DT_CANCELAMENTO,              
			DT_LANC_AUTOMATICO,           
			NR_SEQ_SITIO_PRINC,           
			NR_SEQ_SITIO_ESPEC,           
			NR_CIRURGIA_SUPERIOR,         
			NR_SEQ_PEPO,                 
			IE_VIA_ACESSO,                
			NR_SEQ_VIA,                   
			NR_SEQ_AGENDA ,               
			IE_AVALIACAO_PRE,             
			NR_SEQ_MOTIVO_REOP ,          
			CD_CATEGORIA,                 
			IE_INTEGRACAO_OPME ,          
			DT_LIBERACAO_ANESTESISTA,     
			NM_USUARIO_LIB_ANEST,         
			DT_DESFEITA_LIB,              
			DS_JUSTIFICATIVA_ASA,         
			DT_FIM_CONFERENCIA,           
			NM_USUARIO_FIM_CONFERENCIA,   
			DT_BLOQUEIO_FATURAMENTO,      
			NM_USUARIO_BLOQUEIO_FAT,      
			NM_USUARIO_ANTIBIOTICO,       
			DT_INTERRUPCAO ,              
			NR_SEQ_MOTIVO ,               
			IE_VIDEO,                   
			NM_USUARIO_VIDEO,             
			IE_FINALIDADE,                
			NR_SEQ_TRANSPLANTE,           
			DS_JUST_TROCA_PROCED,         
			CD_PROCEDIMENTO_TUSS,         
			NR_PRESCRICAO_ESPEC,          
			IE_NIVEL_ATENCAO,             
			DS_UTC,                       
			IE_HORARIO_VERAO,             
			DS_UTC_ATUALIZACAO,           
			IE_EQUIP_VERIFICADO,          
			IE_AMOSTRA,                   
			QT_PATOLOGICO,                
			IE_MICROBIOLOGICO,            
			IE_PATOLOGICO,                
			QT_AMOSTRA ,                  
			QT_MICROBIOLOGICO,            
			DT_AMOSTRA,                   
			DT_REQUISICAO_LAB,            
			DT_AMOSTRA_PATO,              
			DT_AMOSTRA_MICRO,             
			DT_REQ_PATO_LAB,              
			DT_REQ_MICRO_LAB,             
			NR_SEQ_ATEND_CONS_PEPA,
			NR_ORIGEM,
			ID_VERSAO
		)
		SELECT 
		nextval('cirurgia_hist_japao_seq'),
		NR_CIRURGIA,
		CD_PESSOA_FISICA,             
		CD_MEDICO_CIRURGIAO,          
		CD_PROCEDIMENTO_PRINC,        
		CD_TIPO_ANESTESIA,            
		NM_USUARIO_P,                   
		clock_timestamp(), 
		DT_INICIO_PREVISTA,           
		DT_INICIO_REAL,               
		NR_MIN_DURACAO_PREV,          
		NR_MIN_DURACAO_REAL,          
		DT_TERMINO,                   
		NR_PRESCRICAO,                
		NR_ATENDIMENTO,               
		DT_ENTRADA_UNIDADE,           
		CD_MEDICO_ANESTESISTA,        
		CD_CONVENIO,                  
		DS_OBSERVACAO,                
		IE_ORIGEM_PROCED,             
		IE_STATUS_CIRURGIA,           
		IE_MOTIVO_CANCELAMENTO,       
		IE_CARATER_CIRURGIA,          
		CD_TIPO_CIRURGIA,             
		IE_ANAT_PATOL,                
		IE_TRAUMA,                    
		IE_ORTESE_PROTESE,            
		IE_ANTIBIOTICO,               
		IE_SANGUE,                    
		DS_ANTIBIOTICO,               
		CD_SETOR_ATENDIMENTO,         
		DT_TERMINO_PREVISTA,          
		DT_ENTRADA_RECUP,             
		DT_SAIDA_RECUP_PREV,          
		DT_SAIDA_RECUP,               
		NR_SEQ_STATUS,                
		DS_ANDAMENTO,                 
		DT_CHAMADA,                   
		DT_PREPARACAO,                
		DT_CHEGADA_SALA,              
		DT_CHEGADA_ANESTESISTA,       
		DT_INICIO_ANESTESIA,          
		DT_CHEGADA_CIRURGIAO,         
		DT_INICIO_CIRURGIA,           
		DT_FIM_CIRURGIA,              
		DT_FIM_EXTUBACAO,             
		DT_LIBERACAO_SALA,            
		IE_ASA_ESTADO_PACIENTE,       
		CD_MEDICO_REQ,                
		IE_LEITO_UTI,                 
		IE_PECA_ANAT_PATOL,           
		DT_CHEGADA_SRPA,              
		DT_ENTR_MATMED,               
		NM_USUARIO_MATMED,            
		DT_SAIDA_SALA,                
		CD_ESTABELECIMENTO,           
		DT_FIM_ANESTESIA,             
		IE_PORTE,                     
		IE_LADO,                      
		NR_SEQ_PROC_INTERNO,          
		QT_RIC,                       
		DT_LIB_NISS,                  
		IE_INFECCAO,                  
		DT_INFECCAO,                  
		NR_SEQ_PROCED_NISS,           
		DT_LIBERACAO,                 
		NM_USUARIO_LIB,               
		QT_PESO,                      
		NR_SEQ_INTERRUPCAO,           
		IE_SITIO_INFECCAO,            
		IE_CONTROLA_PESO,             
		IE_TIPO_CIRURGIA,             
		IE_REOPERACAO,                
		DT_CANCELAMENTO,              
		DT_LANC_AUTOMATICO,           
		NR_SEQ_SITIO_PRINC,           
		NR_SEQ_SITIO_ESPEC,           
		NR_CIRURGIA_SUPERIOR,         
		NR_SEQ_PEPO,                 
		IE_VIA_ACESSO,                
		NR_SEQ_VIA,                   
		NR_SEQ_AGENDA ,               
		IE_AVALIACAO_PRE,             
		NR_SEQ_MOTIVO_REOP ,          
		CD_CATEGORIA,                 
		IE_INTEGRACAO_OPME ,          
		DT_LIBERACAO_ANESTESISTA,     
		NM_USUARIO_LIB_ANEST,         
		DT_DESFEITA_LIB,              
		DS_JUSTIFICATIVA_ASA,         
		DT_FIM_CONFERENCIA,           
		NM_USUARIO_FIM_CONFERENCIA,   
		DT_BLOQUEIO_FATURAMENTO,      
		NM_USUARIO_BLOQUEIO_FAT,      
		NM_USUARIO_ANTIBIOTICO,       
		DT_INTERRUPCAO ,              
		NR_SEQ_MOTIVO ,               
		IE_VIDEO,                   
		NM_USUARIO_VIDEO,             
		IE_FINALIDADE,                
		NR_SEQ_TRANSPLANTE,           
		DS_JUST_TROCA_PROCED,         
		CD_PROCEDIMENTO_TUSS,         
		NR_PRESCRICAO_ESPEC,          
		IE_NIVEL_ATENCAO,             
		DS_UTC,                       
		IE_HORARIO_VERAO,             
		DS_UTC_ATUALIZACAO,           
		IE_EQUIP_VERIFICADO,          
		IE_AMOSTRA,                   
		QT_PATOLOGICO,                
		IE_MICROBIOLOGICO,            
		IE_PATOLOGICO,                
		QT_AMOSTRA ,                  
		QT_MICROBIOLOGICO,            
		DT_AMOSTRA,                   
		DT_REQUISICAO_LAB,            
		DT_AMOSTRA_PATO,              
		DT_AMOSTRA_MICRO,             
		DT_REQ_PATO_LAB,              
		DT_REQ_MICRO_LAB,             
		NR_SEQ_ATEND_CONS_PEPA,
		NR_CIRURGIA,
		id_versao_w + 1
		FROM CIRURGIA
		WHERE NR_CIRURGIA = NR_CIRURGIA_P;
	END IF;
	COMMIT;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE duplicate_surgery (NR_CIRURGIA_P bigint, NM_USUARIO_P text) FROM PUBLIC;

