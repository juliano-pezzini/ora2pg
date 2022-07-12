-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE fis_sef_edoc_arq_lfpd05_pck.fis_gerar_arq_e003_edoc () AS $body$
DECLARE


-- VARIABLES
nr_sequencia_w    bigint := 0;
qt_cursor_w       bigint := 0;
nr_vetor_w        bigint := 0;

-- c_reg_E003
c_reg_E003 CURSOR FOR
SELECT   *
from   	fis_sef_edoc_E003
where   nr_seq_controle = current_setting('fis_sef_edoc_arq_lfpd05_pck.nr_seq_controle_w')::bigint;

--Criação do array com o tipo sendo do cursor eespecificado - c_reg_E003
type reg_e_reg_E003 is table of fis_sef_edoc_E003%RowType;

vetRegE003 reg_e_reg_E003;

--Criação do array com o tipo sendo da tabela eespecificada - fis_efd_icmsipi_arquivo
type registro is table of fis_sef_edoc_arquivo%rowtype index by integer;
fis_registros_w registro;

BEGIN

qt_cursor_w := 0;

open c_reg_E003;
loop
fetch c_reg_E003 bulk collect into vetRegE003 limit 1000;
	for i in 1 .. vetRegE003.Count loop
	begin

	--Incrementa a variavel para o array
	qt_cursor_w := qt_cursor_w + 1;

	PERFORM set_config('fis_sef_edoc_arq_lfpd05_pck.nr_linha_w', current_setting('fis_sef_edoc_arq_lfpd05_pck.nr_linha_w')::fis_sef_edoc_arquivo.nr_linha%type + 1, false);
	PERFORM set_config('fis_sef_edoc_arq_lfpd05_pck.ds_linha_w', substr(	current_setting('fis_sef_edoc_arq_lfpd05_pck.ds_sep_w')::varchar(1) || vetRegE003[i].cd_reg	|| --01
				current_setting('fis_sef_edoc_arq_lfpd05_pck.ds_sep_w')::varchar(1) || vetRegE003[i].sg_uf         || --02
				current_setting('fis_sef_edoc_arq_lfpd05_pck.ds_sep_w')::varchar(1) || vetRegE003[i].ds_lin_nom    || --03
				current_setting('fis_sef_edoc_arq_lfpd05_pck.ds_sep_w')::varchar(1) || vetRegE003[i].nr_campo_ini  || --04
				current_setting('fis_sef_edoc_arq_lfpd05_pck.ds_sep_w')::varchar(1) || vetRegE003[i].qt_campo      || --05
				current_setting('fis_sef_edoc_arq_lfpd05_pck.ds_sep_w')::varchar(1),
				1,
				8000), false);

	--   Atualiza o sequencial de ordenação de linhas do arquivo
	select nextval('fis_sef_edoc_arquivo_seq')  into STRICT nr_sequencia_w;

	fis_registros_w[qt_cursor_w].nr_sequencia     		:= nr_sequencia_w;
	fis_registros_w[qt_cursor_w].dt_atualizacao_nrec	:= clock_timestamp();
	fis_registros_w[qt_cursor_w].nm_usuario_nrec		:= current_setting('fis_sef_edoc_arq_lfpd05_pck.nm_usuario_w')::usuario.nm_usuario%type;
	fis_registros_w[qt_cursor_w].dt_atualizacao		:= clock_timestamp();
	fis_registros_w[qt_cursor_w].nm_usuario     		:= current_setting('fis_sef_edoc_arq_lfpd05_pck.nm_usuario_w')::usuario.nm_usuario%type;
	fis_registros_w[qt_cursor_w].nr_seq_controle     	:= current_setting('fis_sef_edoc_arq_lfpd05_pck.nr_seq_controle_w')::bigint;
	fis_registros_w[qt_cursor_w].nr_linha       		:= current_setting('fis_sef_edoc_arq_lfpd05_pck.nr_linha_w')::fis_sef_edoc_arquivo.nr_linha%type;
	fis_registros_w[qt_cursor_w].ds_arquivo     		:= substr(current_setting('fis_sef_edoc_arq_lfpd05_pck.ds_linha_w')::varchar(8000),1,4000);
	fis_registros_w[qt_cursor_w].ds_arquivo_compl     	:= substr(current_setting('fis_sef_edoc_arq_lfpd05_pck.ds_linha_w')::varchar(8000),4001,4000);
	fis_registros_w[qt_cursor_w].cd_registro     		:= vetRegE003[i].cd_reg;


	if (nr_vetor_w >= 1000) then
	begin
		--Inserindo registros definitivamente na tabela especifica - FIS_SEF_EDOC_E003
		forall i in fis_registros_w.first .. fis_registros_w.last

		insert into fis_sef_edoc_arquivo values fis_registros_w(i);

		nr_vetor_w := 0;
		fis_registros_w.delete;

		commit;

	end;
	end if;

	--Chamada da procedure que gera os dados no arquivo dos registros C300 dos arquivos
        CALL fis_sef_edoc_arq_lfpd05_pck.fis_gerar_arq_e025_edoc(vetRegE003[i].nr_sequencia);

	--incrementa variavel para realizar o forall quando chegar no valor limite
	nr_vetor_w := nr_vetor_w + 1;

	end;
	end loop;
EXIT WHEN NOT FOUND; /* apply on c_reg_E003 */
end loop;
close c_reg_E003;

if (fis_registros_w.count > 0) then
begin
	--Inserindo registro que não entraram outro for all devido a quantidade de registros no vetor
	forall i in fis_registros_w.first .. fis_registros_w.last

	insert into fis_sef_edoc_arquivo values fis_registros_w(i);

	fis_registros_w.delete;

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
-- REVOKE ALL ON PROCEDURE fis_sef_edoc_arq_lfpd05_pck.fis_gerar_arq_e003_edoc () FROM PUBLIC;
