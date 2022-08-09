-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_liberar_solic_rescisao_web ( nr_seq_solicitacao_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, nr_protocolo_atend_p INOUT text) AS $body$
DECLARE

 
nr_seq_protocolo_atend_w	pls_protocolo_atendimento.nr_sequencia%type;
						

BEGIN	 
 
CALL pls_liberar_solic_rescisao( nr_seq_solicitacao_p , 'L' ,nm_usuario_p, cd_estabelecimento_p );
 
begin 
	select 	nr_seq_protocolo_atend 
	into STRICT	nr_seq_protocolo_atend_w 
	from	pls_solicitacao_rescisao 
	where	nr_sequencia	= nr_seq_solicitacao_p;
exception 
when others then 
	nr_seq_protocolo_atend_w	:= null;
end;
 
if (nr_seq_protocolo_atend_w IS NOT NULL AND nr_seq_protocolo_atend_w::text <> '') then 
	select	substr(pls_obter_nr_protocolo_atend(nr_seq_protocolo_atend_w,5),1,40) 
	into STRICT	nr_protocolo_atend_p 
	;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_liberar_solic_rescisao_web ( nr_seq_solicitacao_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, nr_protocolo_atend_p INOUT text) FROM PUBLIC;
