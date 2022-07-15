-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE encaminhar_aprovacao_saldo ( nr_seq_aprovacao_p bigint, nr_seq_proc_aprov_p bigint, nm_usuario_p text, nr_seq_novo_proc_p INOUT bigint) AS $body$
DECLARE

 
nr_seq_processo_w	bigint;
ie_tipo_doc_w		varchar(15);
cd_estabelecimento_w	integer;


BEGIN 
 
select	coalesce(min(nr_seq_proc_aprov),0) 
into STRICT	nr_seq_processo_w 
from	processo_aprov_compra 
where	nr_sequencia = nr_seq_aprovacao_p 
and	nr_seq_proc_aprov > nr_seq_proc_aprov_p;
 
if (nr_seq_processo_w > 0) then 
	begin 
 
	update	processo_aprov_compra 
	set	nm_usuario_aprov	 = NULL, 
		dt_definicao 	 = NULL, 
		ie_aprov_reprov 	= 'P', 
		ie_automatico 	 = NULL, 
		dt_liberacao	= clock_timestamp(), 
		ds_observacao	= wheb_mensagem_pck.get_Texto(312408) /*'Recebido pelo nível anterior de aprovação devido falta de saldo.'*/
 
	where	nr_sequencia	= nr_seq_aprovacao_p 
	and	nr_seq_proc_aprov = nr_seq_processo_w;
 
	update	processo_aprov_compra 
	set	nm_usuario_aprov	= nm_usuario_p, 
		dt_definicao 	= clock_timestamp(), 
		ie_aprov_reprov 	= 'A', 
		ie_automatico 	= 'S', 
		ds_observacao	= wheb_mensagem_pck.get_Texto(312409) /*'Enviado para próximo nível de aprovação devido falta de saldo.'*/
 
	where	nr_sequencia	= nr_seq_aprovacao_p 
	and	nr_seq_proc_aprov = nr_seq_proc_aprov_p;
 
	select	substr(obter_tipo_doc_origem_proc(nr_seq_aprovacao_p),1,10), 
		obter_estab_processo_aprov(nr_seq_aprovacao_p) 
	into STRICT	ie_tipo_doc_w, 
		cd_estabelecimento_w 
	;
 
	if (ie_tipo_doc_w = 'SC') then 
		CALL envia_email_encaminhar_solic(nr_seq_aprovacao_p,nr_seq_processo_w,cd_estabelecimento_w,nm_usuario_p);
	elsif (ie_tipo_doc_w = 'CC') then 
		avisar_encaminhar_aprov_cot(nr_seq_aprovacao_p,nr_seq_processo_w,cd_estabelecimento_w,nm_usuario_p);
	elsif (ie_tipo_doc_w = 'OC') then 
		avisar_encaminhar_aprov_oc(nr_seq_aprovacao_p,nr_seq_processo_w,cd_estabelecimento_w,nm_usuario_p);
	end if;
 
	commit;
 
	end;
end if;
 
nr_seq_novo_proc_p	:= nr_seq_processo_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE encaminhar_aprovacao_saldo ( nr_seq_aprovacao_p bigint, nr_seq_proc_aprov_p bigint, nm_usuario_p text, nr_seq_novo_proc_p INOUT bigint) FROM PUBLIC;

