-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_endereco_img_laudo ( nr_sequencia_p bigint, nr_seq_imagem_p bigint, ds_arquivo_p text, nm_usuario_p text) AS $body$
BEGIN
	if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '')  and (ds_arquivo_p IS NOT NULL AND ds_arquivo_p::text <> '')  and (nr_seq_imagem_p IS NOT NULL AND nr_seq_imagem_p::text <> '') then
	   update laudo_paciente_imagem
	   set 	ds_arquivo_imagem = ds_arquivo_p,
		nm_usuario	=   nm_usuario_p,
		dt_atualizacao	=   clock_timestamp()
           where nr_sequencia = nr_sequencia_p
	   and	nr_seq_imagem = nr_seq_imagem_p;
	end if;

commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_endereco_img_laudo ( nr_sequencia_p bigint, nr_seq_imagem_p bigint, ds_arquivo_p text, nm_usuario_p text) FROM PUBLIC;
