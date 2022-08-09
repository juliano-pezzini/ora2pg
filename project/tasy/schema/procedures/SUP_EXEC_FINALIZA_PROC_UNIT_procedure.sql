-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sup_exec_finaliza_proc_unit (nr_sequencia_p bigint, nm_usuario_p text, ie_consiste_ativ_p text) AS $body$
DECLARE


/* Procedure criada para o HTML para pegar o retorno da procedure original e realizar a validação do processo,
     permitindo a execução da mesma através do schematics. */
ds_erro_w		varchar(4000);


BEGIN

	ds_erro_w := sup_finalizar_proc_unit(nr_sequencia_p, nm_usuario_p, ie_consiste_ativ_p, ds_erro_w);

	if (ds_erro_w IS NOT NULL AND ds_erro_w::text <> '') then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(ds_erro_w);
	end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sup_exec_finaliza_proc_unit (nr_sequencia_p bigint, nm_usuario_p text, ie_consiste_ativ_p text) FROM PUBLIC;
