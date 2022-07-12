-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE tax_reinf_data_pck.update_batch_closing ( batch_code_p bigint, status_p bigint, error_code_p text, error_message_p text, protocol_p text, id_p text, hash_p text) AS $body$
BEGIN
    update  fis_reinf_r2099
    set     dt_transmissao = clock_timestamp(), 
            ie_status = CASE WHEN status_p=2 THEN  'P'  ELSE 'S' END ,  
            ds_codigo_retorno = error_code_p, 
            ds_descricao_retorno = error_message_p, 
            ds_protocolo = protocol_p, 
            ds_id_evento = id_p, 
            ds_hash = hash_p 
    where   nr_sequencia = batch_code_p;
    commit;
  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tax_reinf_data_pck.update_batch_closing ( batch_code_p bigint, status_p bigint, error_code_p text, error_message_p text, protocol_p text, id_p text, hash_p text) FROM PUBLIC;
