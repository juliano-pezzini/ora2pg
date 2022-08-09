-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE com_obter_historico_email ( nr_seq_historico_p INOUT bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_historico_w	bigint;


BEGIN
if (nr_seq_historico_p IS NOT NULL AND nr_seq_historico_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	nr_seq_historico_w := converte_rtf_string('select ds_historico from com_cliente_hist where nr_sequencia = :nr', nr_seq_historico_p, nm_usuario_p, nr_seq_historico_w);
	end;
end if;
nr_seq_historico_p := nr_seq_historico_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE com_obter_historico_email ( nr_seq_historico_p INOUT bigint, nm_usuario_p text) FROM PUBLIC;
