-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE justificativa_encerrar_etapa (NR_SEQ_CRONOGRAMA_P bigint, NR_SEQ_CRON_ETAPA_P bigint, DS_JUSTIFICATIVA_P text, NM_USUARIO_P text) AS $body$
DECLARE


  dt_atual_w          timestamp   := clock_timestamp();
  ds_justificativa_w  varchar(4000);
  nr_seq_projeto_w    proj_projeto.nr_sequencia%TYPE;
  nr_seq_cliente_w    proj_projeto.nr_seq_cliente%TYPE;


BEGIN

  BEGIN

    SELECT pj.nr_sequencia, pj.nr_seq_cliente INTO STRICT nr_seq_projeto_w, nr_seq_cliente_w FROM proj_projeto pj, proj_cronograma pc
    WHERE pj.nr_sequencia = pc.nr_seq_proj
    AND   pc.nr_sequencia = NR_SEQ_CRONOGRAMA_P;
  
  END;


  ds_justificativa_w := obter_texto_dic_objeto(1084095, wheb_usuario_pck.get_nr_seq_idioma, 'NR_SEQ_CRON_ETAPA='||NR_SEQ_CRON_ETAPA_P||';DT_ATUAL='||dt_atual_w||';NM_USUARIO='||nm_usuario_p||';DS_JUSTIFICATIVA='|| DS_JUSTIFICATIVA_P);

  BEGIN
     insert into com_cliente_hist(nr_sequencia,
                        nr_seq_tipo, 		
                        nr_seq_cliente,  	
                        nm_usuario,  		
                        dt_historico, 		
                        dt_atualizacao, 	
                        dt_atualizacao_nrec,
                        nm_usuario_nrec,	
                        nr_seq_projeto, 	
                        ds_titulo, 			
                        dt_liberacao, 		
                        ds_historico) 		
                     values (nextval('com_cliente_hist_seq'),	
                        8 ,
                        nr_seq_cliente_w,
                        nm_usuario_p,
                        clock_timestamp(),
                        clock_timestamp(), 
                        clock_timestamp(), 
                        nm_usuario_p,
                        nr_seq_projeto_w,
                        obter_texto_dic_objeto(1084096, wheb_usuario_pck.get_nr_seq_idioma, null),
                        clock_timestamp(),
                       ds_justificativa_w);
  END;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE justificativa_encerrar_etapa (NR_SEQ_CRONOGRAMA_P bigint, NR_SEQ_CRON_ETAPA_P bigint, DS_JUSTIFICATIVA_P text, NM_USUARIO_P text) FROM PUBLIC;
