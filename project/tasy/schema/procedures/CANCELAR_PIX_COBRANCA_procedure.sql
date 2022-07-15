-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cancelar_pix_cobranca ( nr_seq_cobranca_p bigint, nm_usuario_p text) AS $body$
DECLARE


  ie_status_w pix_cobranca.ds_status%type;


BEGIN

  select c.ds_status
  into STRICT ie_status_w
  from pix_cobranca c
  where c.nr_sequencia = nr_seq_cobranca_p;

  exception
    when no_data_found or too_many_rows then 
      ie_status_w := null;
  
  if ((ie_status_w = 'NAO_REGISTRADA') or (ie_status_w = 'ATIVA')) then  
    update	pix_cobranca
            set	ds_status = 'REMOVIDA_PELO_USUARIO_RECEBEDOR',
                dt_cancelamento = clock_timestamp(),
                nm_usuario	= nm_usuario_p, 
                dt_atualizacao	= clock_timestamp() 
            where	nr_sequencia	= nr_seq_cobranca_p;
  end if;
       
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cancelar_pix_cobranca ( nr_seq_cobranca_p bigint, nm_usuario_p text) FROM PUBLIC;

