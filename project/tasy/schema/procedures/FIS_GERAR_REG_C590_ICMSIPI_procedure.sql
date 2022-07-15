-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fis_gerar_reg_c590_icmsipi ( nr_seq_controle_p bigint, nr_seq_nota_p bigint) AS $body$
DECLARE


/*REGISTRO C590: REGISTRO ANALTICO DO DOCUMENTO (CDIGO 21 E 22).*/



-- VARIABLES
ie_gerou_dados_bloco_w varchar(1) := 'N';

nr_seq_icmsipi_C590_w fis_efd_icmsipi_C590.nr_sequencia%type;

qt_cursor_w bigint := 0;
nr_vetor_w  bigint := 0;

-- USUARIO
nm_usuario_w usuario.nm_usuario%type;

/*Cursor que retorna as informaes para o registro C590*/

c_reg_a_doc CURSOR FOR
	SELECT	a.cd_cst_icms,
		a.cd_cfop,
		CASE WHEN a.ie_tributacao_icms='00' THEN  a.tx_aliq_icms WHEN a.ie_tributacao_icms='10' THEN  a.tx_aliq_icms WHEN a.ie_tributacao_icms='20' THEN  a.tx_aliq_icms WHEN a.ie_tributacao_icms='70' THEN  a.tx_aliq_icms  ELSE 0 END  tx_aliq_icms,
		sum(a.vl_opr) vl_opr,
		sum(CASE WHEN a.ie_tributacao_icms='00' THEN  a.vl_bc_icms WHEN a.ie_tributacao_icms='10' THEN  a.vl_bc_icms WHEN a.ie_tributacao_icms='20' THEN  a.vl_bc_icms WHEN a.ie_tributacao_icms='70' THEN  a.vl_bc_icms  ELSE 0 END ) vl_bc_icms,
		sum(CASE WHEN a.ie_tributacao_icms='00' THEN  a.vl_icms WHEN a.ie_tributacao_icms='10' THEN  a.vl_icms WHEN a.ie_tributacao_icms='20' THEN  a.vl_icms WHEN a.ie_tributacao_icms='70' THEN  a.vl_icms  ELSE 0 END ) vl_icms,       
		sum(CASE WHEN a.ie_tributacao_icms='10' THEN  a.vl_base_icms_st WHEN a.ie_tributacao_icms='30' THEN  a.vl_base_icms_st WHEN a.ie_tributacao_icms='70' THEN  a.vl_base_icms_st  ELSE 0 END ) vl_bc_icms_st,
		sum(CASE WHEN a.ie_tributacao_icms='10' THEN  a.vl_icms_st WHEN a.ie_tributacao_icms='30' THEN  a.vl_icms_st WHEN a.ie_tributacao_icms='70' THEN  a.vl_icms_st  ELSE 0 END ) vl_icms_st,
		sum(CASE WHEN substr(a.cd_cst_icms, length(cd_cst_icms) -1, length(cd_cst_icms))='20' THEN  a.vl_red_bc WHEN substr(a.cd_cst_icms, length(cd_cst_icms) -1, length(cd_cst_icms))='70' THEN  a.vl_red_bc WHEN substr(a.cd_cst_icms, length(cd_cst_icms) -1, length(cd_cst_icms))='90' THEN  a.vl_red_bc  ELSE 0 END ) vl_red_bc,
		max(cd_obs) cd_obs
	from	(
		SELECT	coalesce(tax_get_active_cst(b.nr_sequencia, b.nr_item_nf, b.cd_estabelecimento), '010') cd_cst_icms,
			substr(Elimina_Caracter(obter_dados_natureza_operacao(a.cd_natureza_operacao, 'CF'), '.'), 1, 4) cd_cfop,
			nfe_obter_valor_trib_item(b.nr_sequencia, b.nr_item_nf, 'ICMS', 'TX') tx_aliq_icms,
			b.vl_total_item_nf vl_opr,
			nfe_obter_valor_trib_item(b.nr_sequencia, b.nr_item_nf, 'ICMS', 'BC') vl_bc_icms,   
			nfe_obter_valor_trib_item(b.nr_sequencia, b.nr_item_nf, 'ICMS', 'TRIB') vl_icms,
			nfe_obter_valor_trib_item(b.nr_sequencia, b.nr_item_nf, 'ICMS', 'RICMS') vl_red_bc,
			nfe_obter_valor_trib_item(b.nr_sequencia, b.nr_item_nf, 'ICMSST', 'BC') vl_base_icms_st,
			nfe_obter_valor_trib_item(b.nr_sequencia, b.nr_item_nf, 'ICMSST', 'TRIB') vl_icms_st,
			c.ie_tributacao_icms,
			(select	d.nr_sequencia
			from	fis_variacao_fiscal v,
				fis_dispositivo_legal d
			where	b.nr_seq_variacao_fiscal = v.nr_sequencia
			and	v.cd_dispositivo_legal = d.nr_sequencia) cd_obs
		FROM nota_fiscal a, nota_fiscal_item b
LEFT OUTER JOIN material_fiscal c ON (b.cd_material = c.cd_material)
WHERE a.nr_sequencia		= b.nr_sequencia  and a.nr_sequencia		= nr_seq_nota_p
	 ) a
	group by	a.cd_cst_icms,
			a.cd_cfop,
			CASE WHEN a.ie_tributacao_icms='00' THEN a.tx_aliq_icms WHEN a.ie_tributacao_icms='10' THEN a.tx_aliq_icms WHEN a.ie_tributacao_icms='20' THEN a.tx_aliq_icms WHEN a.ie_tributacao_icms='70' THEN  a.tx_aliq_icms  ELSE 0 END;
			
/*Criao do array com o tipo sendo do cursor eespecificado - c_sat_ecf*/

type reg_c_reg_a_doc is table of c_reg_a_doc%RowType;
vetRegDoc reg_c_reg_a_doc;

/*Criao do array com o tipo sendo da tabela especificada - FIS_EFD_ICMSIPI_C590 */

type registro is table of fis_efd_icmsipi_C590%rowtype index by integer;
fis_registros_w registro;

BEGIN

/*Obteo do usurio ativo no tasy*/

nm_usuario_w := Obter_Usuario_Ativo;

open c_reg_a_doc;
loop
fetch c_reg_a_doc bulk collect into vetRegDoc limit 1000;
	for i in 1 .. vetRegDoc.Count loop
		begin

		/*Incrementa a variavel para o array*/

		qt_cursor_w:=	qt_cursor_w + 1;

		if (ie_gerou_dados_bloco_w = 'N') then
			ie_gerou_dados_bloco_w := 'S';
		end if;
		
		/*Busca da sequencia da tabela especificada - fis_efd_icmsipi_C590*/

		select	nextval('fis_efd_icmsipi_c590_seq')
		into STRICT	nr_seq_icmsipi_C590_w
		;

		/*Inserindo valores no array para realizao do forall posteriormente*/

		fis_registros_w[qt_cursor_w].nr_sequencia        := nr_seq_icmsipi_C590_w;
		fis_registros_w[qt_cursor_w].dt_atualizacao      := clock_timestamp();
		fis_registros_w[qt_cursor_w].nm_usuario          := nm_usuario_w;
		fis_registros_w[qt_cursor_w].dt_atualizacao_nrec := clock_timestamp();
		fis_registros_w[qt_cursor_w].nm_usuario_nrec     := nm_usuario_w;
		fis_registros_w[qt_cursor_w].cd_reg              := 'C590';
		fis_registros_w[qt_cursor_w].cd_cst_icms         := vetRegDoc[i].cd_cst_icms;
		fis_registros_w[qt_cursor_w].cd_cfop             := vetRegDoc[i].cd_cfop;
		fis_registros_w[qt_cursor_w].tx_aliq_icms        := vetRegDoc[i].tx_aliq_icms;
		fis_registros_w[qt_cursor_w].vl_opr              := vetRegDoc[i].vl_opr;
		fis_registros_w[qt_cursor_w].vl_bc_icms          := vetRegDoc[i].vl_bc_icms;
		fis_registros_w[qt_cursor_w].vl_icms             := vetRegDoc[i].vl_icms;
		fis_registros_w[qt_cursor_w].cd_cfop             := vetRegDoc[i].cd_cfop;
		fis_registros_w[qt_cursor_w].vl_bc_icms_st     := vetRegDoc[i].vl_bc_icms_st;
		fis_registros_w[qt_cursor_w].vl_icms_st		 := vetRegDoc[i].vl_icms_st;
		fis_registros_w[qt_cursor_w].vl_red_bc           := vetRegDoc[i].vl_red_bc;
		fis_registros_w[qt_cursor_w].cd_obs              := vetRegDoc[i].cd_obs;
		fis_registros_w[qt_cursor_w].nr_seq_controle     := nr_seq_controle_p;
		fis_registros_w[qt_cursor_w].nr_seq_nota	 := nr_seq_nota_p;

		if (nr_vetor_w >= 1000) then
			begin
				/*Inserindo registros definitivamente na tabela especifica - FIS_EFD_ICMSIPI_C590 */

				forall i in fis_registros_w.first .. fis_registros_w.last
					insert into fis_efd_icmsipi_C590 values fis_registros_w(i);

				nr_vetor_w := 0;
				fis_registros_w.delete;

				commit;

			end;
		end if;

		/*incrementa variavel para realizar o forall quando chegar no valor limite*/

		nr_vetor_w := nr_vetor_w + 1;

		end;
	end loop;
EXIT WHEN NOT FOUND; /* apply on c_reg_a_doc */
end loop;
close c_reg_a_doc;

if (fis_registros_w.count > 0) then
	begin
		/*Inserindo registro que no entraram outro for all devido a quantidade de registros no vetor*/

		forall i in fis_registros_w.first .. fis_registros_w.last
			insert into fis_efd_icmsipi_C590 values fis_registros_w(i);

		fis_registros_w.delete;

		commit;

	end;
end if;

/*Libera memoria*/

dbms_session.free_unused_user_memory;

/*Atualizao informao no controle de gerao de registro para SIM*/

if (ie_gerou_dados_bloco_w = 'S') then
	update fis_efd_icmsipi_controle
	set ie_mov_C 		= 'S'
	where nr_sequencia 	= nr_seq_controle_p;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_gerar_reg_c590_icmsipi ( nr_seq_controle_p bigint, nr_seq_nota_p bigint) FROM PUBLIC;

