-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fis_gerar_reg_c860_icmsipi (nr_seq_controle_p bigint) AS $body$
DECLARE


/*REGISTRO C860: IDENTIFICAÇÃO DO EQUIPAMENTO SAT-CF-E*/

-- VARIABLES
ie_gerou_dados_bloco_w varchar(1) := 'N';

nr_seq_icmsipi_C860_w	fis_efd_icmsipi_C860.nr_sequencia%type;
dt_inicio_apuracao_w	fis_efd_icmsipi_controle.dt_inicio_apuracao%type;
dt_fim_apuracao_w	fis_efd_icmsipi_controle.dt_fim_apuracao%type;
cd_estabelecimento_w	fis_efd_icmsipi_controle.cd_estabelecimento%type;
cd_operacao_nf_w	fis_efd_icmsipi_regra_c800.cd_operacao_nf%type;
cd_serie_nf_w		fis_efd_icmsipi_regra_c800.cd_serie_nf%type;
nr_sat_w		fis_efd_icmsipi_regra_c800.nr_sat%type;
cd_mod_w		fis_efd_icmsipi_C800.cd_mod%type;
nr_doc_ini_w		nota_fiscal.nr_nota_fiscal%type;
nr_doc_fim_w		nota_fiscal.nr_nota_fiscal%type;

qt_cursor_w bigint := 0;
nr_vetor_w  bigint := 0;

-- USUARIO
nm_usuario_w usuario.nm_usuario%type;

c_regras CURSOR FOR
	SELECT	trunc(a.dt_inicio_apuracao),
		trunc(a.dt_fim_apuracao),
		a.cd_estabelecimento,
		c.cd_operacao_nf,
		c.cd_serie_nf,
		c.nr_sat,
		'59' cd_mod
	from	fis_efd_icmsipi_controle 	a,
		fis_efd_icmsipi_lote		b,
		fis_efd_icmsipi_regra_c800	c
	where	a.nr_seq_lote	= b.nr_sequencia
	and 	b.nr_sequencia	= c.nr_seq_lote
	and 	a.nr_sequencia 	= nr_seq_controle_p;

/*Cursor que retorna as informações para o registro c860*/

c_sat_ecf CURSOR FOR
	SELECT	distinct a.dt_emissao dt_doc
	from	nota_fiscal a
	where	(a.dt_atualizacao_estoque IS NOT NULL AND a.dt_atualizacao_estoque::text <> '')
	and	a.ie_situacao		= 1
	and 	a.cd_operacao_nf	= cd_operacao_nf_w
	and 	a.cd_serie_nf		= cd_serie_nf_w
	and 	trunc(a.dt_emissao) between dt_inicio_apuracao_w and dt_fim_apuracao_w
	and 	a.cd_estabelecimento	= cd_estabelecimento_w;

/*Criação do array com o tipo sendo do cursor eespecificado - c_sat_ecf*/

type reg_c_sat_ecf is table of c_sat_ecf%RowType;
vetSatECF reg_c_sat_ecf;

/*Criação do array com o tipo sendo da tabela eespecificada - FIS_EFD_ICMSIPI_C860 */

type registro is table of fis_efd_icmsipi_C860%rowtype index by integer;
fis_registros_w registro;

BEGIN

/*Obteção do usuário ativo no tasy*/

nm_usuario_w := Obter_Usuario_Ativo;

open c_regras;
loop
fetch c_regras into	
	dt_inicio_apuracao_w,
	dt_fim_apuracao_w,
	cd_estabelecimento_w,
	cd_operacao_nf_w,
	cd_serie_nf_w,
	nr_sat_w,
	cd_mod_w;
EXIT WHEN NOT FOUND; /* apply on c_regras */
	begin
	open c_sat_ecf;
	loop
	fetch c_sat_ecf bulk collect into vetSatECF limit 1000;
		for i in 1 .. vetSatECF.Count loop
			begin

			/*Incrementa a variavel para o array*/

			qt_cursor_w	:= qt_cursor_w + 1;
			
			/*Limpeza de variavel*/

			nr_doc_ini_w	:= null;
			nr_doc_fim_w	:= null;
			
			CALL fis_gerar_reg_C890_icmsipi(	nr_seq_controle_p,
							vetsatecf[i].dt_doc);
			
			/*Pega o menor numero da nota do dia*/

			begin
			
			select	min(a.nr_nota_fiscal)
			into STRICT	nr_doc_ini_w
			from	nota_fiscal a
			where	(a.dt_atualizacao_estoque IS NOT NULL AND a.dt_atualizacao_estoque::text <> '')
			and	a.ie_situacao		= 1
			and 	a.cd_operacao_nf	= cd_operacao_nf_w
			and 	a.cd_serie_nf		= cd_serie_nf_w
			and 	a.cd_estabelecimento	= cd_estabelecimento_w
			and 	a.dt_emissao 		= vetsatecf[i].dt_doc;
			
			exception
			when others then
				nr_doc_ini_w:= null;
			end;
			
			/*Pega o maior numero da nota do dia*/

			begin
			
			select	max(nr_nota_fiscal)
			into STRICT	nr_doc_fim_w
			from	nota_fiscal a
			where	(a.dt_atualizacao_estoque IS NOT NULL AND a.dt_atualizacao_estoque::text <> '')
			and	a.ie_situacao		= 1
			and 	a.cd_operacao_nf	= cd_operacao_nf_w
			and 	a.cd_serie_nf		= cd_serie_nf_w
			and 	a.cd_estabelecimento	= cd_estabelecimento_w
			and 	a.dt_emissao 		= vetsatecf[i].dt_doc;
			
			exception
			when others then
				nr_doc_fim_w:= null;
			end;

			if (ie_gerou_dados_bloco_w = 'N') then
				ie_gerou_dados_bloco_w := 'S';
			end if;

			/*Busca da sequencia da tabela especificada - fis_efd_icmsipi_C860 */

			select	nextval('fis_efd_icmsipi_c860_seq')
			into STRICT	nr_seq_icmsipi_C860_w
			;

			/*Inserindo valores no array para realização do forall posteriormente*/

			fis_registros_w[qt_cursor_w].nr_sequencia        := nr_seq_icmsipi_C860_w;
			fis_registros_w[qt_cursor_w].dt_atualizacao      := clock_timestamp();
			fis_registros_w[qt_cursor_w].nm_usuario          := nm_usuario_w;
			fis_registros_w[qt_cursor_w].dt_atualizacao_nrec := clock_timestamp();
			fis_registros_w[qt_cursor_w].nm_usuario_nrec     := nm_usuario_w;
			fis_registros_w[qt_cursor_w].cd_reg              := 'C860';
			fis_registros_w[qt_cursor_w].cd_mod              := cd_mod_w;
			fis_registros_w[qt_cursor_w].nr_sat              := nr_sat_w;
			fis_registros_w[qt_cursor_w].dt_doc              := vetsatecf[i].dt_doc;
			fis_registros_w[qt_cursor_w].nr_doc_ini          := substr(nr_doc_ini_w, 1, 6);
			fis_registros_w[qt_cursor_w].nr_doc_fim          := substr(nr_doc_fim_w, 1, 6);
			fis_registros_w[qt_cursor_w].nr_seq_controle     := nr_seq_controle_p;

			if (nr_vetor_w >= 1000) then
				begin
				/*Inserindo registros definitivamente na tabela especifica - FIS_EFD_ICMSIPI_C860 */

				forall i in fis_registros_w.first .. fis_registros_w.last
					insert into fis_efd_icmsipi_C860 values fis_registros_w(i);

				nr_vetor_w := 0;
				fis_registros_w.delete;

				commit;

				end;
			end if;

			/*incrementa variavel para realizar o forall quando chegar no valor limite*/

			nr_vetor_w := nr_vetor_w + 1;

			end;
		end loop;
	EXIT WHEN NOT FOUND; /* apply on c_sat_ecf */
	end loop;
	close c_sat_ecf;
	end;
end loop;
close c_regras;



if (fis_registros_w.count > 0) then
	begin
	/*Inserindo registro que não entraram outro for all devido a quantidade de registros no vetor*/

	forall i in fis_registros_w.first .. fis_registros_w.last
		insert into fis_efd_icmsipi_C860 values fis_registros_w(i);

	fis_registros_w.delete;

	commit;

	end;
end if;

/*Libera memoria*/

dbms_session.free_unused_user_memory;

/*Atualização informação no controle de geração de registro para SIM*/

if (ie_gerou_dados_bloco_w = 'S') then
	update	fis_efd_icmsipi_controle
	set	ie_mov_C	= 'S'
	where	nr_sequencia	= nr_seq_controle_p;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_gerar_reg_c860_icmsipi (nr_seq_controle_p bigint) FROM PUBLIC;

