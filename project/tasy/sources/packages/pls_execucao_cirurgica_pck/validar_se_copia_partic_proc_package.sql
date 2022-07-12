-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_execucao_cirurgica_pck.validar_se_copia_partic_proc ( nr_seq_proc_original_p pls_exec_cirurgica_proc.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
Valida se as participacoes do novo procedimento sao compativeis com o procedimento substituido
para realizar a copia.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
nr_seq_exec_cirurgica_proc_w	pls_exec_cirurgica_proc.nr_sequencia%type;
qt_partic_w			integer	:= 0;
ds_retorno_w			varchar(1)	:= 'N';

C01 CURSOR FOR
	SELECT	nr_seq_grau_partic
	from	pls_exec_cirurg_bio_partic
	where	nr_seq_exec_cirurg_proc	= nr_seq_exec_cirurgica_proc_w
	order	by nr_seq_grau_partic;
		
BEGIN

begin
	select	a.nr_sequencia
	into STRICT	nr_seq_exec_cirurgica_proc_w
	from	pls_exec_cirurgica_proc a
	where	a.nr_seq_exec_proc_original	= nr_seq_proc_original_p;
exception
when others then
	nr_seq_exec_cirurgica_proc_w	:= null;
end;

for C01_w in C01 loop
	begin	
		ds_retorno_w	:= 'S';
		
		select	count(1)
		into STRICT	qt_partic_w
		from	pls_exec_cirurg_bio_partic
		where	nr_seq_exec_cirurg_proc	= nr_seq_proc_original_p
		and	nr_seq_grau_partic	= C01_w.nr_seq_grau_partic;
		
		if (qt_partic_w = 0) then
			ds_retorno_w	:= 'N';
			exit;
		end if;
	end;
end loop;

return	ds_retorno_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_execucao_cirurgica_pck.validar_se_copia_partic_proc ( nr_seq_proc_original_p pls_exec_cirurgica_proc.nr_sequencia%type) FROM PUBLIC;