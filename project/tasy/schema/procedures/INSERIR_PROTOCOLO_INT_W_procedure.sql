-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_protocolo_int_w ( nr_seq_proc_p bigint, nr_seq_protocolo_p bigint, nr_seq_subtipo_p bigint, ie_obr_top_p text, ie_opcao_p text, nr_seq_topografia_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w		bigint;


BEGIN
	if (ie_opcao_p = 'DA') then
		delete from w_pe_protocolo_proc;
		commit;
	end if;

	if (ie_opcao_p = 'D') then
		delete from w_pe_protocolo_proc
		where nr_seq_proc = nr_seq_proc_p;

		commit;
	end if;

	if (ie_opcao_p = 'I') then
		select	nextval('w_pe_protocolo_proc_seq')
		into STRICT	nr_sequencia_w
		;

		insert into w_pe_protocolo_proc(nr_sequencia, dt_atualizacao, nm_usuario, nr_seq_proc, nr_seq_protocolo, nr_seq_subtipo, ie_obriga_topografia, nr_seq_topografica)
		values ( nr_sequencia_w, clock_timestamp(), nm_usuario_p, nr_seq_proc_p, nr_seq_protocolo_p, nr_seq_subtipo_p, ie_obr_top_p, nr_seq_topografia_p);

		commit;
	end if;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_protocolo_int_w ( nr_seq_proc_p bigint, nr_seq_protocolo_p bigint, nr_seq_subtipo_p bigint, ie_obr_top_p text, ie_opcao_p text, nr_seq_topografia_p bigint, nm_usuario_p text) FROM PUBLIC;

