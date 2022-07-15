-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fis_gerar_reg_c113_icmsipi ( nr_seq_controle_p bigint, nr_seq_nota_p bigint) AS $body$
DECLARE


/*REGISTRO C113: DOCUMENTO FISCAL REFERENCIADO.*/

-- VARIABLES
ie_gerou_dados_bloco_w varchar(1) := 'N';

nr_seq_icmsipi_C113_w fis_efd_icmsipi_C113.nr_sequencia%type;

qt_cursor_w bigint := 0;
nr_vetor_w  bigint := 0;

-- USUARIO
nm_usuario_w usuario.nm_usuario%type;

/*Cursor que retorna as informações para o registro C113 restringindo pela sequencia da nota fiscal*/

c_reg_C113 CURSOR FOR
SELECT	CASE WHEN obter_dados_operacao_nota(a.cd_operacao_nf, '6')='S' THEN  1  ELSE 0 END  cd_ind_oper,
		CASE WHEN obter_dados_operacao_nota(a.cd_operacao_nf, '6')='S' THEN  0 WHEN obter_dados_operacao_nota(a.cd_operacao_nf, '6')='E' THEN  CASE WHEN ie_tipo_nota='EP' THEN  0  ELSE 1 END  END  cd_ind_emit,
		CASE WHEN obter_dados_operacao_nota(a.cd_operacao_nf, '6')='E' THEN  coalesce(a.cd_cgc_emitente, a.cd_pessoa_fisica)  ELSE coalesce(cd_cgc,a.cd_pessoa_fisica) END  cd_part,
		lpad(b.cd_modelo_nf, 2, 0) cd_mod,
		a.cd_serie_nf cd_ser,
		null cd_sub,
		a.nr_nota_fiscal nr_doc,
		a.dt_emissao dt_doc,
		a.nr_danfe ds_chv_doce
	FROM nota_fiscal a
LEFT OUTER JOIN nota_fiscal_transportadora c ON (a.nr_sequencia = c.nr_seq_nota)
, operacao_nota_modelo d
LEFT OUTER JOIN modelo_nota_fiscal b ON (d.nr_seq_modelo = b.nr_sequencia)
WHERE a.cd_operacao_nf	= d.cd_operacao_nf   and a.nr_sequencia		= (	select	nr_sequencia_ref
						from	nota_fiscal
						where	nr_Sequencia = nr_seq_nota_p  LIMIT 1);

/*Criação do array com o tipo sendo do cursor eespecificado - c_reg_C113*/

type reg_c_reg_C113 is table of c_reg_C113%RowType;
vetRegC113 reg_c_reg_C113;

/*Criação do array com o tipo sendo da tabela eespecificada - FIS_EFD_ICMSIPI_C113 */

type registro is table of fis_efd_icmsipi_C113%rowtype index by integer;
fis_registros_w registro;

BEGIN
/*Obteção do usuário ativo no tasy*/

nm_usuario_w := Obter_Usuario_Ativo;

open c_reg_C113;
loop
fetch c_reg_C113 bulk collect into vetRegC113 limit 1000;
	for i in 1 .. vetRegC113.Count loop

		begin

		/*Incrementa a variavel para o array*/

		qt_cursor_w:=	qt_cursor_w + 1;

		if (ie_gerou_dados_bloco_w = 'N') then
			ie_gerou_dados_bloco_w := 'S';
		end if;

		/*Busca da sequencia da tabela especificada - fis_efd_icmsipi_C113 */

		select nextval('fis_efd_icmsipi_c113_seq')
		into STRICT nr_seq_icmsipi_C113_w
		;

		/*Inserindo valores no array para realização do forall posteriormente*/

		fis_registros_w[qt_cursor_w].nr_sequencia 		:= nr_seq_icmsipi_C113_w;
		fis_registros_w[qt_cursor_w].dt_atualizacao 		:= clock_timestamp();
		fis_registros_w[qt_cursor_w].nm_usuario 		:= nm_usuario_w;
		fis_registros_w[qt_cursor_w].dt_atualizacao_nrec 	:= clock_timestamp();
		fis_registros_w[qt_cursor_w].nm_usuario_nrec 		:= nm_usuario_w;
		fis_registros_w[qt_cursor_w].cd_reg 			:= 'C113';
		fis_registros_w[qt_cursor_w].cd_ind_oper 		:= vetRegC113[i].cd_ind_oper;
		fis_registros_w[qt_cursor_w].cd_ind_emit 		:= vetRegC113[i].cd_ind_emit;
		fis_registros_w[qt_cursor_w].cd_part 			:= vetRegC113[i].cd_part;
		fis_registros_w[qt_cursor_w].cd_mod 			:= vetRegC113[i].cd_mod;
		fis_registros_w[qt_cursor_w].cd_ser 			:= substr(vetRegC113[i].cd_ser, 1, 4);
		fis_registros_w[qt_cursor_w].cd_sub 			:= vetRegC113[i].cd_sub;
		fis_registros_w[qt_cursor_w].nr_doc 			:= substr(vetRegC113[i].nr_doc, 1, 9);
		fis_registros_w[qt_cursor_w].dt_doc 			:= vetRegC113[i].dt_doc;
		fis_registros_w[qt_cursor_w].ds_chv_doce 		:= vetRegC113[i].ds_chv_doce;
		fis_registros_w[qt_cursor_w].nr_seq_controle 		:= nr_seq_controle_p;
		fis_registros_w[qt_cursor_w].nr_seq_nota 		:= nr_seq_nota_p;

		if (nr_vetor_w >= 1000) then
			begin

			/*Inserindo registros definitivamente na tabela especifica - FIS_EFD_ICMSIPI_C113 */

			forall i in fis_registros_w.first .. fis_registros_w.last
				insert into fis_efd_icmsipi_C113 values fis_registros_w(i);

			nr_vetor_w := 0;
			fis_registros_w.delete;

			commit;

			end;
		end if;

		/*incrementa variavel para realizar o forall quando chegar no valor limite*/

		nr_vetor_w := nr_vetor_w + 1;

		end;
	end loop;
EXIT WHEN NOT FOUND; /* apply on c_reg_C113 */
end loop;
close c_reg_C113;

if (fis_registros_w.count > 0) then
	begin
	/*Inserindo registro que não entraram outro for all devido a quantidade de registros no vetor*/

	forall i in fis_registros_w.first .. fis_registros_w.last
		insert into fis_efd_icmsipi_C113 values fis_registros_w(i);

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
-- REVOKE ALL ON PROCEDURE fis_gerar_reg_c113_icmsipi ( nr_seq_controle_p bigint, nr_seq_nota_p bigint) FROM PUBLIC;

