-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fis_gerar_reg_c420_icmsipi ( nr_seq_controle_p bigint, nr_ecf_cx_P text) AS $body$
DECLARE


/*REGISTRO C420: REGISTRO DOS TOTALIZADORES PARCIAIS DA REDUÇÃO Z (COD 02, 2D e 60).*/

-- VARIABLES
ie_gerou_dados_bloco_w	varchar(1) := 'N';

nr_seq_icmsipi_C420_w	fis_efd_icmsipi_C420.nr_sequencia%type;

qt_cursor_w 		bigint := 0;
nr_vetor_w  		bigint := 0;

-- USUARIO
nm_usuario_w usuario.nm_usuario%type;

/*Cursor que retorna as informações para o registro C420 restringindo pela sequencia da nota fiscal*/

c_c420 CURSOR FOR
	SELECT 'I1' cd_tot_par,
		b.nr_sequencia,
		b.dt_doc,
		sum(a.vl_doc) vl_acum_tot
	from 	fis_efd_icmsipi_c460 a, fis_efd_icmsipi_c405 b
	where 	a.nr_seq_controle = b.nr_seq_controle
	and 	trunc(a.dt_doc) = trunc(b.dt_doc)
	and 	a.nr_seq_controle = nr_seq_controle_p
	and     a.nr_ecf_cx = nr_ecf_cx_P
	and 	a.nr_ecf_cx = b.nr_ecf_cx
	group by b.nr_sequencia, b.dt_doc;


/*Criação do array com o tipo sendo do cursor eespecificado - c_itens_cupom_fiscal*/

type reg_c420 is table of c_c420%RowType;
vet_c420 reg_c420;

/*Criação do array com o tipo sendo da tabela eespecificada - fis_efd_icmsipi_C420 */

type registro is table of fis_efd_icmsipi_C420%rowtype index by integer;
fis_registros_w registro;

BEGIN
/*Obteção do usuário ativo no tasy*/

nm_usuario_w := Obter_Usuario_Ativo;

open c_c420;
loop
fetch c_c420 bulk collect into vet_c420 limit 1000;
	for i in 1 .. vet_c420.Count loop
		begin

		/*Incrementa a variavel para o array*/

		qt_cursor_w:=	qt_cursor_w + 1;

		if (ie_gerou_dados_bloco_w = 'N') then
			ie_gerou_dados_bloco_w := 'S';
		end if;

		/*Busca da sequencia da tabela especificada - fis_efd_icmsipi_C420 */

		select	nextval('fis_efd_icmsipi_c420_seq')
		into STRICT	nr_seq_icmsipi_C420_w
		;

		/*Inserindo valores no array para realização do forall posteriormente*/

		fis_registros_w[qt_cursor_w].nr_sequencia         := nr_seq_icmsipi_C420_w;
		fis_registros_w[qt_cursor_w].dt_atualizacao       := clock_timestamp();
		fis_registros_w[qt_cursor_w].nm_usuario           := nm_usuario_w;
		fis_registros_w[qt_cursor_w].dt_atualizacao_nrec  := clock_timestamp();
		fis_registros_w[qt_cursor_w].nm_usuario_nrec      := nm_usuario_w;
		fis_registros_w[qt_cursor_w].cd_reg               := 'C420';
		fis_registros_w[qt_cursor_w].cd_tot_par		  := vet_c420[i].cd_tot_par;
  		fis_registros_w[qt_cursor_w].vl_acum_tot	  := vet_c420[i].vl_acum_tot;
		fis_registros_w[qt_cursor_w].nr_seq_controle	  := nr_seq_controle_p;
		fis_registros_w[qt_cursor_w].nr_seq_superior  	  := vet_c420[i].nr_sequencia;

		if (nr_vetor_w >= 1000) then
			begin
			/*Inserindo registros definitivamente na tabela especifica - fis_efd_icmsipi_C420 */

			forall i in fis_registros_w.first .. fis_registros_w.last
				insert into fis_efd_icmsipi_C420 values fis_registros_w(i);

			nr_vetor_w := 0;
			fis_registros_w.delete;

			commit;

			end;
		end if;

		/*incrementa variavel para realizar o forall quando chegar no valor limite*/

		nr_vetor_w := nr_vetor_w + 1;

		end;
	end loop;
EXIT WHEN NOT FOUND; /* apply on c_c420 */
end loop;
close c_c420;

if (fis_registros_w.count > 0) then
	begin
	/*Inserindo registro que não entraram outro for all devido a quantidade de registros no vetor*/

	forall i in fis_registros_w.first .. fis_registros_w.last
		insert into fis_efd_icmsipi_C420 values fis_registros_w(i);

	fis_registros_w.delete;

	commit;
	end;
end if;

/*Libera memoria*/

dbms_session.free_unused_user_memory;

/*Atualização informação no controle de geração de registro para SIM*/

if (ie_gerou_dados_bloco_w = 'S') then
	update	fis_efd_icmsipi_controle
	set	ie_mov_C 	= 'S'
	where	nr_sequencia 	= nr_seq_controle_p;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_gerar_reg_c420_icmsipi ( nr_seq_controle_p bigint, nr_ecf_cx_P text) FROM PUBLIC;

