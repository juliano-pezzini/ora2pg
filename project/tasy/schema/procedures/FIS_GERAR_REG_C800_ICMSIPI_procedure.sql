-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fis_gerar_reg_c800_icmsipi (nr_seq_controle_p bigint) AS $body$
DECLARE


/*REGISTRO C800: REGISTRO CUPOM FISCAL ELETRNICO - CF-E (CDIGO 59)*/



-- VARIABLES
ie_gerou_dados_bloco_w varchar(1) := 'N';

nr_seq_icmsipi_C800_w	fis_efd_icmsipi_C800.nr_sequencia%type;
dt_inicio_apuracao_w	fis_efd_icmsipi_controle.dt_inicio_apuracao%type;
dt_fim_apuracao_w	fis_efd_icmsipi_controle.dt_fim_apuracao%type;
cd_estabelecimento_w	fis_efd_icmsipi_controle.cd_estabelecimento%type;
cd_operacao_nf_w	fis_efd_icmsipi_regra_c800.cd_operacao_nf%type;
cd_serie_nf_w		fis_efd_icmsipi_regra_c800.cd_serie_nf%type;
nr_sat_w		fis_efd_icmsipi_regra_c800.nr_sat%type;
cd_mod_w		fis_efd_icmsipi_C800.cd_mod%type;
cd_sit_w		fis_efd_icmsipi_C800.cd_sit%type;

qt_cursor_w bigint := 0;
nr_vetor_w  bigint := 0;

-- USUARIO
nm_usuario_w usuario.nm_usuario%type;

/*Cursor para trazer as regras para o c800*/

c_regras CURSOR FOR
	SELECT	trunc(a.dt_inicio_apuracao),
			trunc(a.dt_fim_apuracao),
			a.cd_estabelecimento,
			c.cd_operacao_nf,
			c.cd_serie_nf,
			c.nr_sat,
			'59' cd_mod,
			'00' cod_sit
	from	fis_efd_icmsipi_controle 	a,
			fis_efd_icmsipi_lote		b,
			fis_efd_icmsipi_regra_c800	c
	where	a.nr_seq_lote	= b.nr_sequencia
	and 	b.nr_sequencia	= c.nr_seq_lote
	and 	a.nr_sequencia 	= nr_seq_controle_p;

/*Cursor que retorna as informaes para o registro c800*/

c_sat_ecf CURSOR FOR
	SELECT	a.dt_emissao dt_doc,
			null vl_pis,
			coalesce(a.cd_cgc, obter_cpf_pessoa_fisica(a.cd_pessoa_fisica)) cd_cpf_cnpj,
			a.nr_nota_fiscal nr_cfe,
			sum(b.vl_liquido) vl_cfe,
			null vl_cofins,
			sum(b.vl_total_item_nf) vl_merc,
			coalesce(max(a.vl_despesa_acessoria), 0) vl_out_da,
			0 vl_icms,
			null vl_pis_st,
			null vl_cofins_st,
			coalesce(sum(b.vl_desconto), 0) vl_desc,
			a.nr_chave_cupom ds_chv_cfe,
			a.nr_sequencia nr_seq_nota
	from	nota_fiscal a,
			nota_fiscal_item b
	where	a.nr_Sequencia		= b.nr_Sequencia
	and 	(a.dt_atualizacao_estoque IS NOT NULL AND a.dt_atualizacao_estoque::text <> '')
	and		a.ie_situacao		= 1
	and 	a.cd_operacao_nf	= cd_operacao_nf_w
	and 	a.cd_serie_nf		= cd_serie_nf_w
	and 	trunc(a.dt_emissao) between dt_inicio_apuracao_w and dt_fim_apuracao_w
	and 	a.cd_estabelecimento	= cd_estabelecimento_w
	group	by	a.nr_sequencia,
			a.dt_emissao,
			a.nr_nota_fiscal,
			coalesce(a.cd_cgc, obter_cpf_pessoa_fisica(a.cd_pessoa_fisica)),
			a.nr_chave_cupom;


/*Criao do array com o tipo sendo do cursor especificado - c_sat_ecf*/

type reg_c_sat_ecf is table of c_sat_ecf%RowType;
vetSatECF reg_c_sat_ecf;

/*Criao do array com o tipo sendo da tabela eespecificada - FIS_EFD_ICMSIPI_C800 */

type registro is table of fis_efd_icmsipi_C800%rowtype index by integer;
fis_registros_w registro;
BEGIN

/*Obteo do usurio ativo no tasy*/

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
	cd_mod_w,
	cd_sit_w;
EXIT WHEN NOT FOUND; /* apply on c_regras */
	begin
	
	open c_sat_ecf;
	loop
	fetch c_sat_ecf bulk collect into vetSatECF limit 1000;
		for i in 1 .. vetSatECF.Count loop
			begin

			/*Incrementa a variavel para o array*/

			qt_cursor_w:=	qt_cursor_w + 1;
			
			CALL fis_gerar_reg_C850_icmsipi(	nr_seq_controle_p,
							vetSatECF[i].nr_seq_nota);

			if (ie_gerou_dados_bloco_w = 'N') then
				ie_gerou_dados_bloco_w := 'S';
			end if;

			/*Busca da sequencia da tabela especificada - fis_efd_icmsipi_C800 */

			select	nextval('fis_efd_icmsipi_c800_seq')
			into STRICT	nr_seq_icmsipi_C800_w
			;

			/*Inserindo valores no array para realizao do forall posteriormente*/

			fis_registros_w[qt_cursor_w].nr_sequencia        	:= nr_seq_icmsipi_C800_w;
			fis_registros_w[qt_cursor_w].dt_atualizacao      	:= clock_timestamp();
			fis_registros_w[qt_cursor_w].nm_usuario          	:= nm_usuario_w;
			fis_registros_w[qt_cursor_w].dt_atualizacao_nrec	:= clock_timestamp();
			fis_registros_w[qt_cursor_w].nm_usuario_nrec     	:= nm_usuario_w;
			fis_registros_w[qt_cursor_w].cd_reg              	:= 'C800';
			fis_registros_w[qt_cursor_w].cd_mod              	:= cd_mod_w;
			fis_registros_w[qt_cursor_w].nr_sat              	:= nr_sat_w;
			fis_registros_w[qt_cursor_w].cd_sit              	:= cd_sit_w;
			fis_registros_w[qt_cursor_w].nr_cfe		 			:= substr(vetSatECF[i].nr_cfe, 1, 6);
			fis_registros_w[qt_cursor_w].dt_doc		 			:= vetSatECF[i].dt_doc;
			fis_registros_w[qt_cursor_w].vl_cfe		 			:= vetSatECF[i].vl_cfe;
			fis_registros_w[qt_cursor_w].vl_pis		 			:= vetSatECF[i].vl_pis;
			fis_registros_w[qt_cursor_w].vl_cofins		 		:= vetSatECF[i].vl_cofins;
			fis_registros_w[qt_cursor_w].cd_cnpj_cpf	 		:= vetSatECF[i].cd_cpf_cnpj;
			fis_registros_w[qt_cursor_w].ds_chv_cfe		 		:= vetSatECF[i].ds_chv_cfe;
			fis_registros_w[qt_cursor_w].vl_desc		 		:= vetSatECF[i].vl_desc;
			fis_registros_w[qt_cursor_w].vl_merc		 		:= vetSatECF[i].vl_merc;
			fis_registros_w[qt_cursor_w].vl_out_da		 		:= vetSatECF[i].vl_out_da;
			fis_registros_w[qt_cursor_w].vl_icms		 		:= vetSatECF[i].vl_icms;
			fis_registros_w[qt_cursor_w].vl_pis_st		 		:= vetSatECF[i].vl_pis_st;
			fis_registros_w[qt_cursor_w].vl_cofins_st	 		:= vetSatECF[i].vl_cofins_st;
			fis_registros_w[qt_cursor_w].nr_seq_nota	 		:= vetSatECF[i].nr_seq_nota;
			fis_registros_w[qt_cursor_w].nr_seq_controle     	:= nr_seq_controle_p;

			if (nr_vetor_w >= 1000) then
				begin
				/*Inserindo registros definitivamente na tabela especifica - FIS_EFD_ICMSIPI_C800 */

				forall i in fis_registros_w.first .. fis_registros_w.last
					insert into fis_efd_icmsipi_C800 values fis_registros_w(i);

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
	/*Inserindo registro que no entraram outro for all devido a quantidade de registros no vetor*/

	forall i in fis_registros_w.first .. fis_registros_w.last
		insert into fis_efd_icmsipi_C800 values fis_registros_w(i);

	fis_registros_w.delete;

	commit;

	end;
end if;

/*Libera memoria*/

dbms_session.free_unused_user_memory;

/*Atualizao informao no controle de gerao de registro para SIM*/

if (ie_gerou_dados_bloco_w = 'S') then
	update	fis_efd_icmsipi_controle
	set		ie_mov_C 	= 'S'
	where	nr_sequencia 	= nr_seq_controle_p;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_gerar_reg_c800_icmsipi (nr_seq_controle_p bigint) FROM PUBLIC;

