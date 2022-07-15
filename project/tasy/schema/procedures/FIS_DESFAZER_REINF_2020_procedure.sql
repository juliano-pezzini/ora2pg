-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fis_desfazer_reinf_2020 (nr_seq_superior_p bigint, nm_usuario_p text) AS $body$
DECLARE

ds_erro_w	varchar(1000);

BEGIN
  Begin
    delete from fis_reinf_notas_r2020 where nr_seq_superior = nr_seq_superior_p;
    update fis_reinf_r2020 set dt_geracao  = NULL where nr_sequencia = nr_seq_superior_p;
  exception
  when others then
	ds_erro_w	:= sqlerrm(SQLSTATE);
			/*Não foi possível cancelar o lote. Verifique se não existe um lote com data de referência posterior*/

			CALL wheb_mensagem_pck.exibir_mensagem_abort(195877,'DS_ERRO_W='||ds_erro_w);
	end;
Commit;
End;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_desfazer_reinf_2020 (nr_seq_superior_p bigint, nm_usuario_p text) FROM PUBLIC;

