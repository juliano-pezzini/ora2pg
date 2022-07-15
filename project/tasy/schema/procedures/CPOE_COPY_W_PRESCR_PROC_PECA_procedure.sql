-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_copy_w_prescr_proc_peca ( NR_CPOE_OLD_ANATOMIA_P bigint, NR_CPOE_NEW_ANATOMIA_P bigint ) AS $body$
DECLARE

qtde		bigint;	

BEGIN
	
	select count(*)
	into STRICT qtde
	FROM W_CPOE_PRESCR_PROC_PECA
	WHERE NR_SEQ_CPOE_PROC = NR_CPOE_OLD_ANATOMIA_P;
	
	if (qtde > 0) then
		INSERT INTO CPOE_PRESCR_PROC_PECA(NR_SEQUENCIA,
		CD_TOPOGRAFIA,                                      
		CD_MORFOLOGIA,                                     
		DT_ATUALIZACAO, 
		NM_USUARIO,                                
		DT_ATUALIZACAO_NREC,                                
		NM_USUARIO_NREC,                                    
		NR_SEQ_LAUDO,                                       
		CD_DOENCA_CID,                                      
		NR_SEQ_PECA,                                        
		NR_SEQ_PATO_EXAME,                                  
		IE_STATUS,                                          
		NR_SEQ_APRESENT,                                    
		NR_SEQ_TIPO,                                        
		NR_CONTROLE,                                        
		DS_AMOSTRA_PRINCIPAL,                               
		NR_SEQ_EXAME_COMPLEMENTAR,                          
		NR_SEQ_AMOSTRA_PRINC,                               
		NR_SEQ_CASO_CONGELACAO,                             
		NR_REVISAO,                                         
		NR_SEQUENCIA_PRINC,                                 
		NR_FRAGMENTOS,                                      
		DS_DESIGNACAO,                                      
		DS_OBSERVACAO,                                      
		IE_TIPO_DESIGNACAO,                                 
		IE_EXAME_COMPL,                                     
		NR_SEQ_DESIGNACAO,                                  
		IE_SITUACAO,                              
		IE_PECA_PRINCIPAL,                                  
		DT_INATIVACAO,                                      
		NR_SEQ_CPOE_PROC,                          
		IE_LADO,
		NR_SEQ_MORF_DESC_ADIC,
		NR_PECA_ETIQUETA
		) 
		SELECT 
		nextval('cpoe_prescr_proc_peca_seq'),
		CD_TOPOGRAFIA,                                      
		CD_MORFOLOGIA,                                     
		DT_ATUALIZACAO, 
		NM_USUARIO,                                
		DT_ATUALIZACAO_NREC,                                
		NM_USUARIO_NREC,                                    
		NR_SEQ_LAUDO,                                       
		CD_DOENCA_CID,                                      
		NR_SEQ_PECA,                                        
		NR_SEQ_PATO_EXAME,                                  
		IE_STATUS,                                          
		NR_SEQ_APRESENT,                                    
		NR_SEQ_TIPO,                                        
		NR_CONTROLE,                                        
		DS_AMOSTRA_PRINCIPAL,                               
		NR_SEQ_EXAME_COMPLEMENTAR,                          
		NR_SEQ_AMOSTRA_PRINC,                               
		NR_SEQ_CASO_CONGELACAO,                             
		NR_REVISAO,                                         
		NR_SEQUENCIA_PRINC,                                 
		NR_FRAGMENTOS,                                      
		DS_DESIGNACAO,                                      
		DS_OBSERVACAO,                                      
		IE_TIPO_DESIGNACAO,                                 
		IE_EXAME_COMPL,                                     
		NR_SEQ_DESIGNACAO,                                  
		IE_SITUACAO,                              
		IE_PECA_PRINCIPAL,                                  
		DT_INATIVACAO,                                      
		NR_CPOE_NEW_ANATOMIA_P,                          
		IE_LADO,
		NR_SEQ_MORF_DESC_ADIC,
		NR_PECA_ETIQUETA
		FROM W_CPOE_PRESCR_PROC_PECA
		WHERE NR_SEQ_CPOE_PROC = NR_CPOE_OLD_ANATOMIA_P;
	else
		INSERT INTO CPOE_PRESCR_PROC_PECA(NR_SEQUENCIA,
		CD_TOPOGRAFIA,                                      
		CD_MORFOLOGIA,                                     
		DT_ATUALIZACAO, 
		NM_USUARIO,                                
		DT_ATUALIZACAO_NREC,                                
		NM_USUARIO_NREC,                                    
		NR_SEQ_LAUDO,                                       
		CD_DOENCA_CID,                                      
		NR_SEQ_PECA,                                        
		NR_SEQ_PATO_EXAME,                                  
		IE_STATUS,                                          
		NR_SEQ_APRESENT,                                    
		NR_SEQ_TIPO,                                        
		NR_CONTROLE,                                        
		DS_AMOSTRA_PRINCIPAL,                               
		NR_SEQ_EXAME_COMPLEMENTAR,                          
		NR_SEQ_AMOSTRA_PRINC,                               
		NR_SEQ_CASO_CONGELACAO,                             
		NR_REVISAO,                                         
		NR_SEQUENCIA_PRINC,                                 
		NR_FRAGMENTOS,                                      
		DS_DESIGNACAO,                                      
		DS_OBSERVACAO,                                      
		IE_TIPO_DESIGNACAO,                                 
		IE_EXAME_COMPL,                                     
		NR_SEQ_DESIGNACAO,                                  
		IE_SITUACAO,                              
		IE_PECA_PRINCIPAL,                                  
		DT_INATIVACAO,                                      
		NR_SEQ_CPOE_PROC,                          
		IE_LADO,
		NR_SEQ_MORF_DESC_ADIC,
		NR_PECA_ETIQUETA
		) 
		SELECT 
		nextval('cpoe_prescr_proc_peca_seq'),
		CD_TOPOGRAFIA,                                      
		CD_MORFOLOGIA,                                     
		DT_ATUALIZACAO, 
		NM_USUARIO,                                
		DT_ATUALIZACAO_NREC,                                
		NM_USUARIO_NREC,                                    
		NR_SEQ_LAUDO,                                       
		CD_DOENCA_CID,                                      
		NR_SEQ_PECA,                                        
		NR_SEQ_PATO_EXAME,                                  
		IE_STATUS,                                          
		NR_SEQ_APRESENT,                                    
		NR_SEQ_TIPO,                                        
		NR_CONTROLE,                                        
		DS_AMOSTRA_PRINCIPAL,                               
		NR_SEQ_EXAME_COMPLEMENTAR,                          
		NR_SEQ_AMOSTRA_PRINC,                               
		NR_SEQ_CASO_CONGELACAO,                             
		NR_REVISAO,                                         
		NR_SEQUENCIA_PRINC,                                 
		NR_FRAGMENTOS,                                      
		DS_DESIGNACAO,                                      
		DS_OBSERVACAO,                                      
		IE_TIPO_DESIGNACAO,                                 
		IE_EXAME_COMPL,                                     
		NR_SEQ_DESIGNACAO,                                  
		IE_SITUACAO,                              
		IE_PECA_PRINCIPAL,                                  
		DT_INATIVACAO,                                      
		NR_CPOE_NEW_ANATOMIA_P,                          
		IE_LADO,
		NR_SEQ_MORF_DESC_ADIC,
		NR_PECA_ETIQUETA
		FROM CPOE_PRESCR_PROC_PECA
		WHERE NR_SEQ_CPOE_PROC = NR_CPOE_OLD_ANATOMIA_P;
	end if;
	
	DELETE FROM W_CPOE_PRESCR_PROC_PECA
	WHERE nr_seq_cpoe_proc = NR_CPOE_OLD_ANATOMIA_P;
	
	DELETE FROM W_CPOE_PRESCR_PROC_PECA
	WHERE DT_ATUALIZACAO_NREC <= clock_timestamp() - interval '2 days';
	
	DELETE FROM W_CPOE_PRESCR_HISTOPATOL
	WHERE DT_ATUALIZACAO_NREC <= clock_timestamp() - interval '2 days';
	
	DELETE FROM W_CPOE_PRESCR_CITOP
	WHERE DT_ATUALIZACAO_NREC <= clock_timestamp() - interval '2 days';
	
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_copy_w_prescr_proc_peca ( NR_CPOE_OLD_ANATOMIA_P bigint, NR_CPOE_NEW_ANATOMIA_P bigint ) FROM PUBLIC;

