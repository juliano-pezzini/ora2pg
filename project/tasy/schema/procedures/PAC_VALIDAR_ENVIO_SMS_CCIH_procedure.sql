-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pac_validar_envio_sms_ccih ( nr_atendimento_p bigint, nr_seq_evento_p INOUT bigint, cd_medico_resp_p INOUT text, nm_medico_resp_p INOUT text, ds_titulo_p INOUT text, ds_mensagem_p INOUT text) AS $body$
DECLARE

 
nr_seq_evento_w		bigint;
cd_medico_resp_w		varchar(10)	:= '';
nm_medico_resp_w		varchar(255)	:= '';
ds_titulo_w		varchar(100)	:= '';
ds_mensagem_w		varchar(4000)	:= '';
			
 

BEGIN 
/* 
Obs: Procedure criada especificamente para utilização no Tasy Swing, para evitar acessos desnecessários ao Servidor 
*/
 
nr_seq_evento_w		:= obter_evento_regra_envio('GCIH');
cd_medico_resp_w		:= obter_medico_resp_atend(nr_atendimento_p, 'C'); --Buscar o médico responsável pelo atendimento 
nm_medico_resp_w		:= obter_nome_pf(cd_medico_resp_w); --Buscar o nome do médico 
select	max(a.ds_titulo), 
	max(a.ds_mensagem) 
into STRICT	ds_titulo_w, 
	ds_mensagem_w 
from	ev_evento a 
where	a.nr_sequencia	= nr_seq_evento_w;
 
nr_seq_evento_p		:= nr_seq_evento_w;
cd_medico_resp_p		:= cd_medico_resp_w;
nm_medico_resp_p		:= nm_medico_resp_w;
ds_titulo_p		:= ds_titulo_w;
ds_mensagem_p		:= ds_mensagem_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pac_validar_envio_sms_ccih ( nr_atendimento_p bigint, nr_seq_evento_p INOUT bigint, cd_medico_resp_p INOUT text, nm_medico_resp_p INOUT text, ds_titulo_p INOUT text, ds_mensagem_p INOUT text) FROM PUBLIC;
