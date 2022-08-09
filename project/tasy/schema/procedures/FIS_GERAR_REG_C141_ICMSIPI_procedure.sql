-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fis_gerar_reg_c141_icmsipi ( nr_seq_controle_p bigint, nr_seq_nota_p bigint) AS $body$
DECLARE


/*REGISTRO C141: VENCIMENTO DA FATURA (CÓDIGO 01)*/

-- VARIABLES
ie_gerou_dados_bloco_w varchar(1) := 'N';

nr_seq_icmsipi_C141_w fis_efd_icmsipi_C141.nr_sequencia%type;

qt_cursor_w bigint := 0;
nr_vetor_w  bigint := 0;

-- USUARIO
nm_usuario_w usuario.nm_usuario%type;

/*Cursor que retorna as informações para o registro C141 restringindo pela sequencia da nota fiscal*/

c_reg_C141 CURSOR FOR
SELECT	dt_vencimento dt_vcto,
	vl_vencimento vl_parc
from	nota_fiscal_venc a
where 	a.nr_sequencia	= nr_seq_nota_p;

/*Criação do array com o tipo sendo do cursor eespecificado - c_reg_C141*/

type reg_c_reg_C141 is table of c_reg_C141%RowType;
vetRegC141 reg_c_reg_C141;

/*Criação do array com o tipo sendo da tabela eespecificada - FIS_EFD_ICMSIPI_C141 */

type registro is table of fis_efd_icmsipi_C141%rowtype index by integer;
fis_registros_w registro;

BEGIN
/*Obteção do usuário ativo no tasy*/

nm_usuario_w := Obter_Usuario_Ativo;

open c_reg_C141;
loop
fetch c_reg_C141 bulk collect into vetRegC141 limit 1000;
	for i in 1 .. vetRegC141.Count loop

	begin

	/*Incrementa a variavel para o array*/

	qt_cursor_w:=	qt_cursor_w + 1;

	if (ie_gerou_dados_bloco_w = 'N') then
		ie_gerou_dados_bloco_w := 'S';
	end if;

	/*Busca da sequencia da tabela especificada - fis_efd_icmsipi_C141 */

	select	nextval('fis_efd_icmsipi_c141_seq')
	into STRICT	nr_seq_icmsipi_C141_w
	;

	/*Inserindo valores no array para realização do forall posteriormente*/

	fis_registros_w[qt_cursor_w].nr_sequencia 		:= nr_seq_icmsipi_C141_w;
	fis_registros_w[qt_cursor_w].dt_atualizacao 		:= clock_timestamp();
	fis_registros_w[qt_cursor_w].nm_usuario 		:= nm_usuario_w;
	fis_registros_w[qt_cursor_w].dt_atualizacao_nrec 	:= clock_timestamp();
	fis_registros_w[qt_cursor_w].nm_usuario_nrec 		:= nm_usuario_w;
	fis_registros_w[qt_cursor_w].cd_reg 			:= 'C141';
	fis_registros_w[qt_cursor_w].nr_parc 			:= qt_cursor_w;
	fis_registros_w[qt_cursor_w].dt_vcto 			:= vetRegC141[i].dt_vcto;
	fis_registros_w[qt_cursor_w].vl_parc 			:= vetRegC141[i].vl_parc;
	fis_registros_w[qt_cursor_w].nr_seq_controle 		:= nr_seq_controle_p;
	fis_registros_w[qt_cursor_w].nr_seq_nota 		:= nr_seq_nota_p;

	if (nr_vetor_w >= 1000) then
		begin
		/*Inserindo registros definitivamente na tabela especifica - FIS_EFD_ICMSIPI_C141 */

		forall i in fis_registros_w.first .. fis_registros_w.last
			insert into fis_efd_icmsipi_C141 values fis_registros_w(i);

		nr_vetor_w := 0;
		fis_registros_w.delete;

		commit;

		end;
	end if;

	/*incrementa variavel para realizar o forall quando chegar no valor limite*/

	nr_vetor_w := nr_vetor_w + 1;

	end;
	end loop;
EXIT WHEN NOT FOUND; /* apply on c_reg_C141 */
end loop;
close c_reg_C141;

if (fis_registros_w.count > 0) then
	begin
	/*Inserindo registro que não entraram outro for all devido a quantidade de registros no vetor*/

	forall i in fis_registros_w.first .. fis_registros_w.last
		insert into fis_efd_icmsipi_C141 values fis_registros_w(i);

	fis_registros_w.delete;

	commit;

	end;
end if;

/*Libera memoria*/

dbms_session.free_unused_user_memory;

/*Atualização informação no controle de geração de registro para SIM*/

if (ie_gerou_dados_bloco_w = 'S') then
	update	fis_efd_icmsipi_controle
	set	ie_mov_C = 'S'
	where	nr_sequencia = nr_seq_controle_p;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_gerar_reg_c141_icmsipi ( nr_seq_controle_p bigint, nr_seq_nota_p bigint) FROM PUBLIC;
