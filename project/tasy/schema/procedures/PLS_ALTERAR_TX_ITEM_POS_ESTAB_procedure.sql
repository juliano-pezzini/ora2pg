-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_alterar_tx_item_pos_estab ( nr_seq_conta_proc_p bigint, nr_seq_conta_p bigint, nr_seq_conta_pos_estab_p bigint, tx_item_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


ds_log_w	varchar(4000);
machine_w	varchar(100);
osuser_w	varchar(100);


BEGIN

begin

select	osuser,
	machine
into STRICT	osuser_w,
	machine_w
from  	v$session
where	audsid = userenv('SESSIONID');

ds_log_w := substr(	' Máquina: ' || machine_w || chr(13) ||chr(10)||
			' OS User: ' || osuser_w || chr(13) ||chr(10)||
			' Função ativa : '|| obter_funcao_ativa || chr(13) ||chr(10)||
			' CallStack: '|| chr(13) || chr(10)|| dbms_utility.format_call_stack || chr(13) ||chr(10) ,1,1500)||
                        ' Taxa informada: ' || tx_item_p;

update	pls_conta_pos_estabelecido
set	tx_item			= tx_item_p,
	ie_tx_item_manual	= 'S',
	dt_atualizacao		= clock_timestamp(),
	nm_usuario		= nm_usuario_p
where	nr_sequencia		= nr_seq_conta_pos_estab_p;

insert 	into	pls_log_pos_estabelecido(	nr_sequencia,
						dt_atualizacao,
                                                nm_usuario,
                                                dt_atualizacao_nrec,
                                                nm_usuario_nrec,
                                                nr_seq_conta,
                                                nr_seq_conta_pos,
                                                ie_tipo_registro,
					  	ds_log)
		values (	nextval('pls_log_pos_estabelecido_seq'),
                				clock_timestamp(),
                                                nm_usuario_p,
                                                clock_timestamp(),
                                                nm_usuario_p,
                                                nr_seq_conta_p,
                                                nr_seq_conta_pos_estab_p,
                                                'H',
					  	ds_log_w);

exception
when others then
	CALL wheb_mensagem_pck.exibir_mensagem_abort( 1076145, null );
end;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_alterar_tx_item_pos_estab ( nr_seq_conta_proc_p bigint, nr_seq_conta_p bigint, nr_seq_conta_pos_estab_p bigint, tx_item_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

