-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fis_gerar_reg_b420_icmsipi ( nr_seq_controle_p bigint) AS $body$
DECLARE


-- VARIABLES
ie_gerou_dados_bloco_w 	varchar(1) 	:= 'N';
nr_vetor_w		bigint	:= 0;
qt_cursor_w		bigint	:= 0;

nr_seq_icmsipi_B420_w	fis_efd_icmsipi_B420.nr_sequencia%type;

-- USUARIO
nm_usuario_w			usuario.nm_usuario%type;

/*Cursor que retorna as informações para o registro B420*/

c_movimento_B CURSOR FOR
	SELECT 	tx_aliq_iss,
		cd_serv,
		sum(vl_cont) vl_cont,
		sum(vl_bc_iss) vl_bc_iss,
		sum(vl_isnt_iss) vl_isnt_iss,
		sum(vl_iss) vl_iss
	from (	SELECT	a.tx_aliq_iss,
			a.cd_serv,
			sum(a.vl_cont_p) vl_cont,
			sum(a.vl_bc_iss_p) vl_bc_iss,
			sum(a.vl_isnt_iss_p) vl_isnt_iss,
			sum(a.vl_iss_p) vl_iss
		from 	fis_efd_icmsipi_b035 a
		where 	a.nr_seq_controle = nr_seq_controle_p
		group by a.tx_aliq_iss, a.cd_serv
		
union all

		Select 	a.tx_aliq_iss,
			a.cd_serv,
			sum(a.vl_cont_p) vl_cont,
			sum(a.vl_bc_iss_p) vl_bc_iss,
			sum(a.vl_isnt_iss_p) vl_isnt_iss,
			sum(a.vl_iss_p) vl_iss
		from 	fis_efd_icmsipi_b025 a
		where 	a.nr_seq_controle = nr_seq_controle_p			
		and	coalesce(obter_dados_operacao_nota(obter_operacao_nota(a.nr_seq_nota), '6'), 'N') = 'S'
		group by a.tx_aliq_iss, a.cd_serv) alias15
	group by tx_aliq_iss, cd_serv;

/*Criação do array com o tipo sendo do cursor especificado - C_NOTA_FISCAL */

type reg_c_movimento_B is table of c_movimento_B%RowType;
vet_c_movimento_B_w 			reg_c_movimento_B;

/*Criação do array com o tipo sendo da tabela especificada - FIS_EFD_ICMSIPI_C170 */

type registro is table of fis_efd_icmsipi_B420%rowtype index by integer;
fis_registros_w			registro;

BEGIN

/*Obteção do usuário ativo no tasy*/

nm_usuario_w := Obter_Usuario_Ativo;

begin

open c_movimento_B;
loop
fetch c_movimento_B bulk collect into vet_c_movimento_B_w limit 1000;
	for i in 1..vet_c_movimento_B_w.Count loop
		begin

		/*Busca da sequencia da tabela especificada - fis_efd_icmsipi_B420 */

		select	nextval('fis_efd_icmsipi_b420_seq')
		into STRICT	nr_seq_icmsipi_B420_w
		;

		/*Incrementa a variavel para o array*/

		qt_cursor_w:=	qt_cursor_w + 1;

		if (ie_gerou_dados_bloco_w = 'N') then
			ie_gerou_dados_bloco_w:=	'S';
		end if;

		/*Inserindo valores no array para realização do forall posteriormente*/

		fis_registros_w[qt_cursor_w].nr_sequencia		:= nr_seq_icmsipi_B420_w;
		fis_registros_w[qt_cursor_w].dt_atualizacao		:= clock_timestamp();
		fis_registros_w[qt_cursor_w].nm_usuario			:= nm_usuario_w;
		fis_registros_w[qt_cursor_w].dt_atualizacao_nrec	:= clock_timestamp();
		fis_registros_w[qt_cursor_w].nm_usuario_nrec		:= nm_usuario_w;
		fis_registros_w[qt_cursor_w].cd_reg             	:= 'B420';
		fis_registros_w[qt_cursor_w].cd_ser			:= vet_c_movimento_B_w[i].cd_serv;
		fis_registros_w[qt_cursor_w].tx_aliq_iss		:= vet_c_movimento_B_w[i].tx_aliq_iss;
		fis_registros_w[qt_cursor_w].vl_cont			:= vet_c_movimento_B_w[i].vl_cont;
		fis_registros_w[qt_cursor_w].vl_isnt_iss             	:= vet_c_movimento_B_w[i].vl_isnt_iss;
		fis_registros_w[qt_cursor_w].vl_bc_iss             	:= vet_c_movimento_B_w[i].vl_bc_iss;
		fis_registros_w[qt_cursor_w].vl_iss             	:= vet_c_movimento_B_w[i].vl_iss;
		fis_registros_w[qt_cursor_w].nr_seq_controle    	:= nr_seq_controle_p;

		if (nr_vetor_w >= 1000) then
			/*Inserindo registros definitivamente na tabela especifica - FIS_EFD_ICMSIPI_B420 */

			forall j in fis_registros_w.first..fis_registros_w.last
				insert into fis_efd_icmsipi_B420 values fis_registros_w(j);

			nr_vetor_w	:= 0;
			fis_registros_w.delete;

			commit;
		end if;

		/*incrementa variavel para realizar o forall quando chegar no valor limite*/

		nr_vetor_w	:= nr_vetor_w 	+ 1;

		end;
	end loop;
EXIT WHEN NOT FOUND; /* apply on c_movimento_B */
end loop;
close c_movimento_B;

end;

if (fis_registros_w.count > 0) then
	/*Inserindo registro que não entraram outro for all devido a quantidade de registros no vetor*/

	forall l in fis_registros_w.first..fis_registros_w.last
		insert into fis_efd_icmsipi_B420 values fis_registros_w(l);

	fis_registros_w.delete;

	commit;
end if;

/*Libera memoria*/

dbms_session.free_unused_user_memory;

/*Atualização informação no controle de geração de registro para SIM*/

if (ie_gerou_dados_bloco_w = 'S') then
	update 	fis_efd_icmsipi_controle
	set		ie_mov_B = 'S'
	where 	nr_sequencia = nr_seq_controle_p;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_gerar_reg_b420_icmsipi ( nr_seq_controle_p bigint) FROM PUBLIC;
