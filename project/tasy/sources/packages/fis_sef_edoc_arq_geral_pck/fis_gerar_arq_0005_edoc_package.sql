-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE fis_sef_edoc_arq_geral_pck.fis_gerar_arq_0005_edoc () AS $body$
DECLARE


-- c_reg_0005
c_reg_0005 CURSOR FOR
SELECT 	*
from 	fis_sef_edoc_0005
where 	nr_seq_controle = current_setting('fis_sef_edoc_arq_geral_pck.nr_seq_controle_w')::bigint;

--Criação do array com o tipo sendo do cursor eespecificado - c_reg_0005
type reg_c_reg_0005 is table of fis_sef_edoc_0005%RowType;
vetReg0005 reg_c_reg_0005;

BEGIN

PERFORM set_config('fis_sef_edoc_arq_geral_pck.qt_cursor_w', 0, false);

open c_reg_0005;
loop
fetch c_reg_0005 bulk collect	into vetReg0005 limit 1000;
	for i in 1 .. vetReg0005.Count loop
	begin

	--Incrementa a variavel para o array
	PERFORM set_config('fis_sef_edoc_arq_geral_pck.qt_cursor_w', current_setting('fis_sef_edoc_arq_geral_pck.qt_cursor_w')::bigint + 1, false);

	PERFORM set_config('fis_sef_edoc_arq_geral_pck.nr_linha_w', current_setting('fis_sef_edoc_arq_geral_pck.nr_linha_w')::fis_sef_edoc_arquivo.nr_linha%type + 1, false);
	PERFORM set_config('fis_sef_edoc_arq_geral_pck.ds_linha_w', substr(current_setting('fis_sef_edoc_arq_geral_pck.ds_sep_w')::varchar(1) || vetReg0005[i].cd_reg 	|| --01
		       current_setting('fis_sef_edoc_arq_geral_pck.ds_sep_w')::varchar(1) || vetReg0005[i].ds_nome_resp 	|| --02
		       current_setting('fis_sef_edoc_arq_geral_pck.ds_sep_w')::varchar(1) || vetReg0005[i].cd_assin 	|| --03
		       current_setting('fis_sef_edoc_arq_geral_pck.ds_sep_w')::varchar(1) || vetReg0005[i].cd_cpf_resp 	|| --04
		       current_setting('fis_sef_edoc_arq_geral_pck.ds_sep_w')::varchar(1) || vetReg0005[i].cd_cep 	|| --05
		       current_setting('fis_sef_edoc_arq_geral_pck.ds_sep_w')::varchar(1) || vetReg0005[i].ds_end 	|| --06
		       current_setting('fis_sef_edoc_arq_geral_pck.ds_sep_w')::varchar(1) || vetReg0005[i].nr_num 	|| --07
		       current_setting('fis_sef_edoc_arq_geral_pck.ds_sep_w')::varchar(1) || vetReg0005[i].ds_compl 	|| --08
		       current_setting('fis_sef_edoc_arq_geral_pck.ds_sep_w')::varchar(1) || vetReg0005[i].ds_bairro 	|| --09
		       current_setting('fis_sef_edoc_arq_geral_pck.ds_sep_w')::varchar(1) || vetReg0005[i].cd_cep_cp 	|| --10
		       current_setting('fis_sef_edoc_arq_geral_pck.ds_sep_w')::varchar(1) || vetReg0005[i].cd_cp 		|| --11
		       current_setting('fis_sef_edoc_arq_geral_pck.ds_sep_w')::varchar(1) || vetReg0005[i].nr_fone 	|| --12
		       current_setting('fis_sef_edoc_arq_geral_pck.ds_sep_w')::varchar(1) || vetReg0005[i].nr_fax 	|| --13
		       current_setting('fis_sef_edoc_arq_geral_pck.ds_sep_w')::varchar(1) || vetReg0005[i].ds_email 	|| --14
		       current_setting('fis_sef_edoc_arq_geral_pck.ds_sep_w')::varchar(1), --15 vazio2
		       1,
		       8000), false);

	--   Atualiza o sequencial de ordenação de linhas do arquivo
	select nextval('fis_sef_edoc_arquivo_seq')	into STRICT current_setting('fis_sef_edoc_arq_geral_pck.nr_sequencia_w')::bigint	;

	current_setting('fis_sef_edoc_arq_geral_pck.fis_registros_w')::registro(current_setting('fis_sef_edoc_arq_geral_pck.qt_cursor_w')::bigint).nr_sequencia 		:= current_setting('fis_sef_edoc_arq_geral_pck.nr_sequencia_w')::bigint;
	current_setting('fis_sef_edoc_arq_geral_pck.fis_registros_w')::registro(current_setting('fis_sef_edoc_arq_geral_pck.qt_cursor_w')::bigint).dt_atualizacao_nrec 	:= clock_timestamp();
	current_setting('fis_sef_edoc_arq_geral_pck.fis_registros_w')::registro(current_setting('fis_sef_edoc_arq_geral_pck.qt_cursor_w')::bigint).nm_usuario_nrec 		:= current_setting('fis_sef_edoc_arq_geral_pck.nm_usuario_w')::usuario.nm_usuario%type;
	current_setting('fis_sef_edoc_arq_geral_pck.fis_registros_w')::registro(current_setting('fis_sef_edoc_arq_geral_pck.qt_cursor_w')::bigint).dt_atualizacao 		:= clock_timestamp();
	current_setting('fis_sef_edoc_arq_geral_pck.fis_registros_w')::registro(current_setting('fis_sef_edoc_arq_geral_pck.qt_cursor_w')::bigint).nm_usuario 		:= current_setting('fis_sef_edoc_arq_geral_pck.nm_usuario_w')::usuario.nm_usuario%type;
	current_setting('fis_sef_edoc_arq_geral_pck.fis_registros_w')::registro(current_setting('fis_sef_edoc_arq_geral_pck.qt_cursor_w')::bigint).nr_seq_controle 		:= current_setting('fis_sef_edoc_arq_geral_pck.nr_seq_controle_w')::bigint;
	current_setting('fis_sef_edoc_arq_geral_pck.fis_registros_w')::registro(current_setting('fis_sef_edoc_arq_geral_pck.qt_cursor_w')::bigint).nr_linha 			:= current_setting('fis_sef_edoc_arq_geral_pck.nr_linha_w')::fis_sef_edoc_arquivo.nr_linha%type;
	current_setting('fis_sef_edoc_arq_geral_pck.fis_registros_w')::registro(current_setting('fis_sef_edoc_arq_geral_pck.qt_cursor_w')::bigint).ds_arquivo 		:= substr(current_setting('fis_sef_edoc_arq_geral_pck.ds_linha_w')::varchar(8000),1,4000);
	current_setting('fis_sef_edoc_arq_geral_pck.fis_registros_w')::registro(current_setting('fis_sef_edoc_arq_geral_pck.qt_cursor_w')::bigint).ds_arquivo_compl 		:= substr(current_setting('fis_sef_edoc_arq_geral_pck.ds_linha_w')::varchar(8000),4001,4000);
	current_setting('fis_sef_edoc_arq_geral_pck.fis_registros_w')::registro(current_setting('fis_sef_edoc_arq_geral_pck.qt_cursor_w')::bigint).cd_registro 		:= vetReg0005[i].cd_reg;

	if (current_setting('fis_sef_edoc_arq_geral_pck.nr_vetor_w')::bigint >= 1000) then
	begin
		--Inserindo registros definitivamente na tabela especifica - FIS_EFD_ICMSIPI_0005
		forall i in current_setting('fis_sef_edoc_arq_geral_pck.fis_registros_w')::registro.first .. current_setting('fis_sef_edoc_arq_geral_pck.fis_registros_w')::registro.last

		insert into fis_sef_edoc_arquivo	values current_setting('fis_sef_edoc_arq_geral_pck.fis_registros_w')::registro(i);

		PERFORM set_config('fis_sef_edoc_arq_geral_pck.nr_vetor_w', 0, false);
		current_setting('fis_sef_edoc_arq_geral_pck.fis_registros_w')::registro.delete;

	commit;

	end;
	end if;

	--incrementa variavel para realizar o forall quando chegar no valor limite
	PERFORM set_config('fis_sef_edoc_arq_geral_pck.nr_vetor_w', current_setting('fis_sef_edoc_arq_geral_pck.nr_vetor_w')::bigint + 1, false);

	end;
	end loop;
EXIT WHEN NOT FOUND; /* apply on c_reg_0005 */
end loop;
close c_reg_0005;

if (current_setting('fis_sef_edoc_arq_geral_pck.fis_registros_w')::registro.count > 0) then
begin
	--Inserindo registro que não entraram outro for all devido a quantidade de registros no vetor
	forall i in current_setting('fis_sef_edoc_arq_geral_pck.fis_registros_w')::registro.first .. current_setting('fis_sef_edoc_arq_geral_pck.fis_registros_w')::registro.last

	insert into fis_sef_edoc_arquivo values current_setting('fis_sef_edoc_arq_geral_pck.fis_registros_w')::registro(i);
	current_setting('fis_sef_edoc_arq_geral_pck.fis_registros_w')::registro.delete;

	commit;

end;
end if;

--Libera memoria
dbms_session.free_unused_user_memory;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_sef_edoc_arq_geral_pck.fis_gerar_arq_0005_edoc () FROM PUBLIC;