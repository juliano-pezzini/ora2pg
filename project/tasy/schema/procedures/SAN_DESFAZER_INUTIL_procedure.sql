-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE san_desfazer_inutil ( nr_seq_producao_p bigint, nm_usuario_p text) AS $body$
BEGIN
if (nr_seq_producao_p IS NOT NULL AND nr_seq_producao_p::text <> '') then
	update 	san_producao
	set	nr_seq_inutil 		 = NULL,
		ie_local_inutilizacao	 = NULL
	where	nr_sequencia		= nr_seq_producao_p;

CALL gravar_log_tasy(88759, wheb_mensagem_pck.get_texto(803060,
					'NM_USUARIO='||nm_usuario_p||
					';NR_SEQ_PRODUCAO='||nr_seq_producao_p), nm_usuario_p);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE san_desfazer_inutil ( nr_seq_producao_p bigint, nm_usuario_p text) FROM PUBLIC;
