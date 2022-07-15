-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fis_gerar_reg_c195_icmsipi ( nr_seq_controle_p bigint, nr_seq_nota_p bigint) AS $body$
DECLARE


/*REGISTRO C195: OBSERVAÇÕES DO LANÇAMENTO FISCAL (CÓDIGO 01, 1B, 04 E 55)*/

-- VARIABLES
ie_gerou_dados_bloco_w varchar(1) := 'N';

nr_seq_icmsipi_C195_w fis_efd_icmsipi_C195.nr_sequencia%type;

qt_cursor_w bigint := 0;
nr_vetor_w  bigint := 0;

-- USUARIO
nm_usuario_w usuario.nm_usuario%type;

/*Cursor que retorna as informações para o registro C195 restringindo pela sequencia da nota fiscal*/

c_reg_C195 CURSOR FOR
	SELECT	d.nr_sequencia cd_obs,
		null ds_txt_compl
	from	nota_fiscal_item n,
		natureza_operacao o,
		fis_variacao_fiscal v,
		fis_dispositivo_legal d
	where	n.cd_natureza_operacao = o.cd_natureza_operacao
	and	n.nr_seq_variacao_fiscal = v.nr_sequencia
	and	v.cd_dispositivo_legal = d.nr_sequencia
	and	n.nr_sequencia = nr_seq_nota_p;

/*Criação do array com o tipo sendo do cursor eespecificado - c_reg_C195*/

type reg_c_reg_C195 is table of c_reg_C195%RowType;
vetRegC195 reg_c_reg_C195;

/*Criação do array com o tipo sendo da tabela eespecificada - FIS_EFD_ICMSIPI_C195 */

type registro is table of fis_efd_icmsipi_C195%rowtype index by integer;
fis_registros_w registro;

BEGIN
/*Obteção do usuário ativo no tasy*/

nm_usuario_w := Obter_Usuario_Ativo;

open c_reg_C195;
loop
fetch c_reg_C195 bulk collect into vetRegC195 limit 1000;
	for i in 1 .. vetRegC195.Count loop
		begin

		/*Incrementa a variavel para o array*/

		qt_cursor_w:=	qt_cursor_w + 1;

		if (ie_gerou_dados_bloco_w = 'N') then
			ie_gerou_dados_bloco_w := 'S';
		end if;

		/*Busca da sequencia da tabela especificada - fis_efd_icmsipi_C195 */

		select	nextval('fis_efd_icmsipi_c195_seq')
		into STRICT	nr_seq_icmsipi_C195_w
		;

		/*Inserindo valores no array para realização do forall posteriormente*/

		fis_registros_w[qt_cursor_w].nr_sequencia 		:= nr_seq_icmsipi_C195_w;
		fis_registros_w[qt_cursor_w].dt_atualizacao 		:= clock_timestamp();
		fis_registros_w[qt_cursor_w].nm_usuario 		:= nm_usuario_w;
		fis_registros_w[qt_cursor_w].dt_atualizacao_nrec 	:= clock_timestamp();
		fis_registros_w[qt_cursor_w].nm_usuario_nrec 		:= nm_usuario_w;
		fis_registros_w[qt_cursor_w].cd_reg 			:= 'C195';
		fis_registros_w[qt_cursor_w].cd_obs 			:= vetRegC195[i].cd_obs;
		fis_registros_w[qt_cursor_w].ds_txt_compl 		:= vetRegC195[i].ds_txt_compl;
		fis_registros_w[qt_cursor_w].nr_seq_nota		:= nr_seq_nota_p;
		fis_registros_w[qt_cursor_w].nr_seq_controle 		:= nr_seq_controle_p;

		if (nr_vetor_w >= 1000) then
			begin
			/*Inserindo registros definitivamente na tabela especifica - FIS_EFD_ICMSIPI_C195 */

			forall i in fis_registros_w.first .. fis_registros_w.last
				insert into fis_efd_icmsipi_C195 values fis_registros_w(i);

			nr_vetor_w := 0;
			fis_registros_w.delete;

			commit;

			end;
		end if;

		/*incrementa variavel para realizar o forall quando chegar no valor limite*/

		nr_vetor_w := nr_vetor_w + 1;

		end;
	end loop;
EXIT WHEN NOT FOUND; /* apply on c_reg_C195 */
end loop;
close c_reg_C195;

if (fis_registros_w.count > 0) then
	begin
	/*Inserindo registro que não entraram outro for all devido a quantidade de registros no vetor*/

	forall i in fis_registros_w.first .. fis_registros_w.last
		insert into fis_efd_icmsipi_C195 values fis_registros_w(i);

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
-- REVOKE ALL ON PROCEDURE fis_gerar_reg_c195_icmsipi ( nr_seq_controle_p bigint, nr_seq_nota_p bigint) FROM PUBLIC;

