-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE agenda_pac_proc_afterpost ( nr_sequencia_p bigint, nr_seq_agenda_p bigint, nm_usuario_p text, ds_retorno_p INOUT text) AS $body$
DECLARE

					 
ds_retorno_w		varchar(255);


BEGIN 
 
if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') and (nr_seq_agenda_p IS NOT NULL AND nr_seq_agenda_p::text <> '') then 
	begin 
 
	CALL gerar_autor_regra(null, null, null, null, null, null, 'AP', nm_usuario_p, nr_sequencia_p, null, null, null, null, nr_seq_agenda_p,'','','');
 
	ds_retorno_w := consistir_gerar_autor_agrup(nr_sequencia_p, 'AP', nm_usuario_p, ds_retorno_w);
 
	end;
end if;
 
ds_retorno_p		:= ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE agenda_pac_proc_afterpost ( nr_sequencia_p bigint, nr_seq_agenda_p bigint, nm_usuario_p text, ds_retorno_p INOUT text) FROM PUBLIC;

