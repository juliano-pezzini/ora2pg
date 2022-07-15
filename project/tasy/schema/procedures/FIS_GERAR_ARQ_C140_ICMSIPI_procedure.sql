-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fis_gerar_arq_c140_icmsipi ( nr_seq_controle_p bigint, nr_seq_nota_p bigint, nr_linha_p INOUT bigint) AS $body$
DECLARE


-- VARIABLES
ds_linha_w  varchar(8000);
ds_sep_w    varchar(1) := '|';
qt_cursor_w bigint := 0;
nr_vetor_w  bigint := 0;
nr_sequencia_w bigint := 0;

-- USUARIO
nm_usuario_w usuario.nm_usuario%type;

-- FIS_EFD_ICMSIPI_ARQUIVO
nr_linha_w fis_efd_icmsipi_arquivo.nr_linha%type;

c_reg_C140 CURSOR FOR
SELECT 	*
from 	fis_efd_icmsipi_C140
where 	nr_seq_controle = nr_seq_controle_p
and 	nr_seq_nota = nr_seq_nota_p;

/*Criação do array com o tipo sendo do cursor eespecificado - c_reg_C140*/

type reg_c_reg_C140 is table of fis_efd_icmsipi_C140%RowType;
vetRegC140 reg_c_reg_C140;

/*Criação do array com o tipo sendo da tabela eespecificada - fis_efd_icmsipi_arquivo */

type registro is table of fis_efd_icmsipi_arquivo%rowtype index by integer;
fis_registros_w registro;

BEGIN

nm_usuario_w := Obter_Usuario_Ativo;
nr_linha_w   := nr_linha_p;

open c_reg_C140;
loop
fetch c_reg_C140 bulk collect into vetRegC140 limit 1000;
	for i in 1 .. vetRegC140.Count loop
	begin

	/*Incrementa a variavel para o array*/

	qt_cursor_w := qt_cursor_w + 1;

	nr_linha_w := nr_linha_w + 1;
	ds_linha_w := substr(ds_sep_w || vetRegC140[i].cd_reg ||
			     ds_sep_w || vetRegC140[i].cd_ind_emit ||
			     ds_sep_w || trim(both to_char(vetRegC140[i].cd_ind_tit, '09')) ||
			     ds_sep_w || vetRegC140[i].ds_tit ||
			     ds_sep_w || vetRegC140[i].nr_tit ||
			     ds_sep_w || vetRegC140[i].qt_parc ||
			     ds_sep_w || substr(sped_obter_campo_valor(vetRegC140[i].vl_tit), 1, 30) || ds_sep_w,
			     1,
			     8000);

	/*   Atualiza o sequencial de ordenação de linhas do arquivo */

	Select nextval('fis_efd_icmsipi_arquivo_seq')	into STRICT nr_sequencia_w	;

	fis_registros_w[qt_cursor_w].nr_sequencia 		:= nr_sequencia_w;
	fis_registros_w[qt_cursor_w].dt_atualizacao_nrec 	:= clock_timestamp();
	fis_registros_w[qt_cursor_w].nm_usuario_nrec 		:= nm_usuario_w;
	fis_registros_w[qt_cursor_w].dt_atualizacao 		:= clock_timestamp();
	fis_registros_w[qt_cursor_w].nm_usuario 		:= nm_usuario_w;
	fis_registros_w[qt_cursor_w].nr_seq_controle 		:= nr_seq_controle_p;
	fis_registros_w[qt_cursor_w].nr_linha 			:= nr_linha_w;
	fis_registros_w[qt_cursor_w].ds_arquivo 		:= substr(ds_linha_w,1,4000);
	fis_registros_w[qt_cursor_w].ds_arquivo_compl 		:= substr(ds_linha_w,4001,4000);
	fis_registros_w[qt_cursor_w].cd_registro 		:= vetRegC140[i].cd_reg;

		------->C141
	/* Gera registros do C110 */

	nr_linha_w := fis_gerar_arq_C141_icmsipi(nr_seq_controle_p, vetRegC140[i].nr_seq_nota, nr_linha_w);

	if (nr_vetor_w >= 1000) then
	begin
	/*Inserindo registros definitivamente na tabela especifica - FIS_EFD_ICMSIPI_C140 */

	forall i in fis_registros_w.first .. fis_registros_w.last
		insert into fis_efd_icmsipi_arquivo	values fis_registros_w(i);

		nr_vetor_w := 0;
		fis_registros_w.delete;

		commit;

	end;
	end if;

	/*incrementa variavel para realizar o forall quando chegar no valor limite*/

	nr_vetor_w := nr_vetor_w + 1;

	end;
	end loop;
EXIT WHEN NOT FOUND; /* apply on c_reg_C140 */
end loop;
close c_reg_C140;

if (fis_registros_w.count > 0) then
begin
/*Inserindo registro que não entraram outro for all devido a quantidade de registros no vetor*/

forall i in fis_registros_w.first .. fis_registros_w.last
	insert into fis_efd_icmsipi_arquivo values fis_registros_w(i);

	fis_registros_w.delete;

	commit;

end;
end if;

/*Libera memoria*/

dbms_session.free_unused_user_memory;

nr_linha_p := nr_linha_w;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_gerar_arq_c140_icmsipi ( nr_seq_controle_p bigint, nr_seq_nota_p bigint, nr_linha_p INOUT bigint) FROM PUBLIC;

