-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE estornar_liberacao_reg_lic ( nr_seq_licitacao_p bigint, nm_usuario_p text) AS $body$
DECLARE



cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type;
nr_seq_aprovacao_w		processo_aprov_compra.nr_sequencia%type;

c01 CURSOR FOR
SELECT	distinct nr_seq_aprovacao
from	reg_lic_item
where	nr_seq_licitacao	= nr_seq_licitacao_p;


BEGIN

select	cd_estabelecimento
into STRICT	cd_estabelecimento_w
from	reg_licitacao
where	nr_sequencia	= nr_seq_licitacao_p;

update	reg_licitacao
set	dt_lib_aprovacao	 = NULL,
	nm_usuario_lib_aprov	= '',
	dt_aprovacao		 = NULL,
	nm_usuario_aprov	= ''
where	nr_sequencia		= nr_seq_licitacao_p;

open C01;
loop
fetch C01 into
	nr_seq_aprovacao_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	delete
	from	processo_aprov_compra
	where	nr_sequencia 	= nr_seq_aprovacao_w;

	end;
end loop;
close C01;

update	reg_lic_item
set	nr_seq_aprovacao	 = NULL,
	dt_aprovacao		 = NULL,
	nm_usuario_aprov	= '',
	dt_reprovacao		 = NULL,
	ie_motivo_reprovacao	 = NULL,
	ds_justificativa_reprov	= ''
where	nr_seq_licitacao	= nr_seq_licitacao_p;

insert into reg_lic_historico(
	nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	ie_tipo_historico,
	ds_observacao,
	nr_seq_licitacao)
values (	nextval('reg_lic_historico_seq'),
	clock_timestamp(),
	nm_usuario_p,
	'ELA',
	wheb_mensagem_pck.get_texto(313407,'DT_REF_W='|| to_char(clock_timestamp(),'dd/mm/yyyy hh24:mi:ss') ||';NM_USUARIO_P='|| NM_USUARIO_P), /*'Foi estornado a liberação da aprovação no dia ' || to_char(clock_timestamp(),'dd/mm/yyyy hh24:mi:ss') || ' pelo usuário ' || nm_usuario_p || '.',*/
	nr_seq_licitacao_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE estornar_liberacao_reg_lic ( nr_seq_licitacao_p bigint, nm_usuario_p text) FROM PUBLIC;

