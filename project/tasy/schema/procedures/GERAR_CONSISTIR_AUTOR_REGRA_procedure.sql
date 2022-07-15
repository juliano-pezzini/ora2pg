-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_consistir_autor_regra ( nr_seq_agenda_proc_adic_p bigint, nr_seq_agenda_cons_p bigint, ds_retorno_p INOUT text, nm_usuario_p text) AS $body$
DECLARE

 
ds_retorno_w	varchar(4000);

BEGIN
if (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then 
	begin 
	CALL gerar_autor_regra(	null, null, null, null, null, null, 'AC', 
						nm_usuario_p, null, null, null, nr_seq_agenda_cons_p, 
						null, nr_seq_agenda_proc_adic_p, null, null, null);
 
	ds_retorno_w := consistir_gerar_autor_agrup(nr_seq_agenda_proc_adic_p, 'AP', nm_usuario_p, ds_retorno_w);
	end;
end if;
ds_retorno_p	:= ds_retorno_w;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_consistir_autor_regra ( nr_seq_agenda_proc_adic_p bigint, nr_seq_agenda_cons_p bigint, ds_retorno_p INOUT text, nm_usuario_p text) FROM PUBLIC;

