-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_dic_expressao (cd_expressao_p bigint, nm_usuario_p text, ie_opcao_p text) AS $body$
DECLARE


nr_seq_log_atual_w	bigint;
ie_log_w		varchar(10);
dt_aprovacao_w		timestamp;
nm_usuario_aprov_w	varchar(15);

/*ie_opcao_p
A - Aprovar
D - Desfazer aprovação
*/
BEGIN

if (ie_opcao_p = 'A') then

	update	dic_expressao
	set	dt_aprovacao 		= clock_timestamp(),
		nm_usuario_aprov 	= nm_usuario_p,
		nm_usuario		= nm_usuario_p
	where	cd_expressao 		= cd_expressao_p;

	SELECT * FROM gravar_log_alteracao(null, to_char(clock_timestamp(),'dd/mm/yyyy hh24:mi:ss'), nm_usuario_p, nr_seq_log_atual_w, 'DT_APROVACAO', ie_log_w, null, 'DIC_EXPRESSAO', cd_expressao_p, NULL) INTO STRICT nr_seq_log_atual_w, ie_log_w;
	SELECT * FROM gravar_log_alteracao(null, nm_usuario_p, nm_usuario_p, nr_seq_log_atual_w, 'NM_USUARIO_APROV', ie_log_w, null, 'DIC_EXPRESSAO', cd_expressao_p, NULL) INTO STRICT nr_seq_log_atual_w, ie_log_w;

else
	select	dt_aprovacao,
		nm_usuario_aprov
	into STRICT	dt_aprovacao_w,
		nm_usuario_aprov_w
	from	dic_expressao
	where	cd_expressao 		= cd_expressao_p;

	SELECT * FROM gravar_log_alteracao(dt_aprovacao_w, null, nm_usuario_p, nr_seq_log_atual_w, 'DT_APROVACAO', ie_log_w, null, 'DIC_EXPRESSAO', cd_expressao_p, NULL) INTO STRICT nr_seq_log_atual_w, ie_log_w;
	SELECT * FROM gravar_log_alteracao(nm_usuario_aprov_w, null, nm_usuario_p, nr_seq_log_atual_w, 'NM_USUARIO_APROV', ie_log_w, null, 'DIC_EXPRESSAO', cd_expressao_p, NULL) INTO STRICT nr_seq_log_atual_w, ie_log_w;

	update	dic_expressao
	set	dt_aprovacao 		 = NULL,
		nm_usuario_aprov 	 = NULL,
		nm_usuario		= nm_usuario_p
	where	cd_expressao 		= cd_expressao_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_dic_expressao (cd_expressao_p bigint, nm_usuario_p text, ie_opcao_p text) FROM PUBLIC;

