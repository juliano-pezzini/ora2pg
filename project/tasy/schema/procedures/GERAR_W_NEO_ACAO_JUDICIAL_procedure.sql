-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_neo_acao_judicial ( matricula text, prontuario text, codigo_motivo text, data_inicio text, data_fim text, nr_seq_acao_jud INOUT bigint) AS $body$
DECLARE


ds_erro_w	varchar(1);
nr_sequencia_w	bigint;


BEGIN


ds_erro_w:= 'N';

select 	nextval('w_neo_acao_judicial_seq')
into STRICT	nr_sequencia_w
;

begin
insert	into w_neo_acao_judicial(matricula,
	prontuario,
	codigo_motivo,
	data_inicio,
	data_fim,
	nr_sequencia)
values (replace(matricula,'¿',''),
	prontuario,
	codigo_motivo,
	data_inicio,
	data_fim,
	nr_sequencia_w);
exception
	when others then
	ds_erro_w:= 'S';
end;

if (ds_erro_w = 'N') then
	nr_seq_acao_jud:= nr_sequencia_w;
else
	nr_seq_acao_jud:= 0;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_neo_acao_judicial ( matricula text, prontuario text, codigo_motivo text, data_inicio text, data_fim text, nr_seq_acao_jud INOUT bigint) FROM PUBLIC;

