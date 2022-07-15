-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fis_gerar_reg_e310_icmsipi ( nr_seq_controle_p bigint, sg_uf_p text) AS $body$
DECLARE


/*REGISTRO E310: AJUSTE/BENEFÍCIO/INCENTIVO DA APURAÇÃO DO ICMS SUBSTITUIÇÃO TRIBUTÁRIA.*/

-- VARIABLES
ie_gerou_dados_bloco_w varchar(1) := 'N';

nr_seq_icmsipi_E310_w fis_efd_icmsipi_E310.nr_sequencia%type;

qt_cursor_w bigint := 0;
nr_vetor_w  bigint := 0;

-- Totalizadores
vl_tot_debitos_difal		double precision 	:= 0;
vl_tot_creditos_difal		double precision 	:= 0;
vl_sld_dev_ant_difal_w		double precision 	:= 0;
vl_recol_difal_w		double precision 	:= 0;
vl_sld_cred_transp_difal_w	double precision 	:= 0;
vl_sld_cred_ant_fcp_w		double precision 	:= 0;
vl_sld_dev_ant_fcp_w		double precision 	:= 0;
vl_recol_fcp_w			double precision 	:= 0;
vl_sld_cred_transportar_fcp_w	double precision 	:= 0;
vl_tot_debitos_difal_w        	double precision 	:= 0;
vl_tot_deb_fcp_w        	double precision 	:= 0;
vl_tot_creditos_difal_w        	double precision 	:= 0;
vl_sld_cred_ant_difal_w        	double precision 	:= 0;
vl_tot_cred_fcp_w        	double precision 	:= 0;
sg_uf_0000_w			varchar(2);
ind_mov_fcp_difal_w 		smallint	:= 0;


-- USUARIO
nm_usuario_w usuario.nm_usuario%type;


/*Cursor que retorna a totalização dos Creditos de ICMS*/

c_vl_sld_ant CURSOR FOR
	SELECT 	a.vl_sld_cred_ant_fcp,
		a.vl_sld_cred_ant_fcp
	from 	fis_efd_icmsipi_E310 a ,
		fis_efd_icmsipi_e300 b ,
		fis_efd_icmsipi_controle c
	where 	a.nr_seq_controle = c.nr_seq_anterior
	and 	c.nr_sequencia = nr_seq_controle_p
	and     a.sg_uf = b.sg_uf
	and     b.sg_uf = sg_uf_p;

/*Cursor que retorna a totalização dos VL_OUT_DEB_DIFAL*/

c_vl_tot_debitos_difal CURSOR FOR
	SELECT 	coalesce(sum(vl_icms_uf_rem), 0) + coalesce(sum(vl_icms_uf_dest), 0) vl_tot_debitos_difal,
		coalesce(sum(vl_fcp_uf_dest), 0) vl_fcp_uf_dest
	from (
		/* C101 PF*/

		SELECT	b.vl_icms_uf_rem, b.vl_icms_uf_dest, b.vl_fcp_uf_dest
		from	fis_efd_icmsipi_c100 a,
			fis_efd_icmsipi_c101 b,
			pessoa_fisica        c,
			compl_pessoa_fisica  d
		where a.cd_part = c.cd_pessoa_fisica
		and a.nr_seq_nota = b.nr_seq_nota
		and a.nr_seq_controle = b.nr_seq_controle
		and a.cd_ind_oper = 1
		and c.cd_pessoa_fisica = d.cd_pessoa_fisica
		and a.nr_seq_controle = nr_seq_controle_p
		and d.sg_estado = sg_uf_p
		
union

		/* C101 PJ*/

		select	b.vl_icms_uf_rem, b.vl_icms_uf_dest, b.vl_fcp_uf_dest
		from	fis_efd_icmsipi_c100 a,
			fis_efd_icmsipi_c101 b,
			pessoa_juridica      c
		where a.cd_part = c.cd_cgc
		and a.nr_seq_nota = b.nr_seq_nota
		and a.nr_seq_controle = b.nr_seq_controle
		and a.cd_ind_oper = 1
		and a.nr_seq_controle = nr_seq_controle_p
		and c.sg_estado = sg_uf_p) alias6;

/*Cursor que retorna a totalização dos VL_TOT_CREDITOS_DIFAL*/

c_vl_tot_creditos_difal CURSOR FOR
	SELECT 	coalesce(sum(vl_icms_uf_rem), 0) + coalesce(sum(vl_icms_uf_dest), 0) vl_tot_creditos_difal,
		coalesce(sum(vl_fcp_uf_dest), 0) vl_fcp_uf_dest
	from (
		/* C101 PF*/

		SELECT	b.vl_icms_uf_rem, b.vl_icms_uf_dest, b.VL_FCP_UF_DEST
		from	fis_efd_icmsipi_c100 a,
			fis_efd_icmsipi_c101 b,
			pessoa_fisica        c,
			compl_pessoa_fisica  d
		where a.cd_part = c.cd_pessoa_fisica
		and a.nr_seq_nota = b.nr_seq_nota
		and a.nr_seq_controle = b.nr_seq_controle
		and a.cd_ind_oper = 0
		and c.cd_pessoa_fisica = d.cd_pessoa_fisica
		and a.nr_seq_controle = nr_seq_controle_p
		and d.sg_estado = sg_uf_p
		
union

		/* C101 PJ*/

		select	b.vl_icms_uf_rem, b.vl_icms_uf_dest, b.VL_FCP_UF_DEST
		from	fis_efd_icmsipi_c100 a,
			fis_efd_icmsipi_c101 b,
			pessoa_juridica      c
		where a.cd_part = c.cd_cgc
		and a.nr_seq_nota = b.nr_seq_nota
		and a.nr_seq_controle = b.nr_seq_controle
		and a.cd_ind_oper = 0
		and a.nr_seq_controle = nr_seq_controle_p
		and c.sg_estado = sg_uf_p) alias6;

/*Cursor que retorna o bloco 0000*/

c_0000_uf CURSOR FOR
	SELECT sg_uf
	from fis_efd_icmsipi_0000
	where nr_seq_controle = nr_seq_controle;


/*Cursor que retorna as informações para o registro E310 restringindo pela sequencia da nota fiscal*/

  c_reg_E310 CURSOR FOR
	SELECT  'E310' cd_reg,
		'0' ind_mov_fcp_difal,
		null vl_sld_cred_ant_difal,
		null vl_tot_debitos_difal,
		0 vl_out_deb_difal,
		null vl_tot_creditos_difal,
		0 vl_out_cred_difal,
		null vl_sld_dev_ant_difal,
		0 vl_deducoes_difal,
		null vl_recol_difal,
		null vl_sld_cred_transportar_difal,
		0 deb_esp_difal,
		null vl_sld_cred_ant_fcp,
		null vl_tot_deb_fcp,
		0 vl_out_deb_fcp,
		null vl_tot_cred_fcp,
		0 vl_out_cred_fcp,
		null vl_sld_dev_ant_fcp,
		0 vl_deducoes_fcp,
		null vl_recol_fcp,
		null vl_sld_cred_transportar_fcp,
		0 deb_esp_fcp
	;

  /*Criação do array com o tipo sendo do cursor eespecificado - c_reg_E310*/

  type reg_c_reg_E310 is table of c_reg_E310%RowType;
  vetRegE310 reg_c_reg_E310;

  /*Criação do array com o tipo sendo da tabela eespecificada - FIS_EFD_ICMSIPI_E310 */

  type registro is table of fis_efd_icmsipi_E310%rowtype index by integer;
  fis_registros_w registro;

BEGIN
/*Obteção do usuário ativo no tasy*/

nm_usuario_w := Obter_Usuario_Ativo;

open c_reg_E310;
loop
fetch c_reg_E310 bulk collect  into vetRegE310 limit 1000;
	for i in 1 .. vetRegE310.Count loop
	begin

	/*Incrementa a variavel para o array*/

	qt_cursor_w:=  qt_cursor_w + 1;

	ind_mov_fcp_difal_w := vetRegE310[i].ind_mov_fcp_difal;

	if (ie_gerou_dados_bloco_w = 'N') then
	ie_gerou_dados_bloco_w := 'S';
	end if;


	/*UF 0000*/

	open  c_0000_uf;
	fetch  c_0000_uf  into sg_uf_0000_w;
	close  c_0000_uf;

	/* c_vl_sld_ant */

	open  c_vl_sld_ant;
	fetch  c_vl_sld_ant  into vl_sld_dev_ant_difal_w, vl_recol_difal_w;
	close  c_vl_sld_ant;

	/* c_vl_tot_debitos_difal */

	open c_vl_tot_debitos_difal;
	fetch c_vl_tot_debitos_difal into vl_tot_debitos_difal_w, vl_tot_deb_fcp_w;
	close c_vl_tot_debitos_difal;

	/* c_vl_tot_creditos_difal */

	open c_vl_tot_creditos_difal;
	fetch c_vl_tot_creditos_difal into vl_tot_creditos_difal_w, vl_tot_cred_fcp_w;
	close c_vl_tot_creditos_difal;

	SELECT * FROM fis_efd_icmsipi_calcula_e310(	vl_tot_debitos_difal_w, vetRegE310[i].vl_out_deb_difal, vl_sld_dev_ant_difal_w, vl_tot_creditos_difal_w, vetRegE310[i].vl_out_cred_difal, vetRegE310[i].vl_deducoes_difal, vl_tot_deb_fcp_w, vl_tot_cred_fcp_w, vetRegE310[i].vl_out_deb_fcp, vl_sld_cred_ant_fcp_w, vetRegE310[i].vl_out_cred_fcp, vetRegE310[i].vl_deducoes_fcp, sg_uf_0000_w, sg_uf_p, vl_sld_dev_ant_difal_w, vl_recol_difal_w, vl_sld_cred_transp_difal_w, vl_recol_fcp_w, vl_sld_dev_ant_fcp_w, vl_sld_cred_transportar_fcp_w, ind_mov_fcp_difal_w) INTO STRICT vl_tot_deb_fcp_w, vl_tot_cred_fcp_w, vl_sld_dev_ant_difal_w, vl_recol_difal_w, vl_sld_cred_transp_difal_w, vl_recol_fcp_w, vl_sld_dev_ant_fcp_w, vl_sld_cred_transportar_fcp_w, ind_mov_fcp_difal_w;
	/*Busca da sequencia da tabela especificada - fis_efd_icmsipi_E310 */

	select nextval('fis_efd_icmsipi_e310_seq')  into STRICT nr_seq_icmsipi_E310_w;

	/*Inserindo valores no array para realização do forall posteriormente*/

	fis_registros_w[qt_cursor_w].nr_sequencia         		:= nr_seq_icmsipi_E310_w;
	fis_registros_w[qt_cursor_w].dt_atualizacao       		:= clock_timestamp();
	fis_registros_w[qt_cursor_w].nm_usuario         		:= nm_usuario_w;
	fis_registros_w[qt_cursor_w].dt_atualizacao_nrec     		:= clock_timestamp();
	fis_registros_w[qt_cursor_w].nm_usuario_nrec       		:= nm_usuario_w;
	fis_registros_w[qt_cursor_w].cd_reg           		:= 'E310';
	fis_registros_w[qt_cursor_w].cd_ind_mov_difal			:= ind_mov_fcp_difal_w;
	fis_registros_w[qt_cursor_w].vl_sld_cred_ant_difal  		:= vl_sld_cred_ant_difal_w;
	fis_registros_w[qt_cursor_w].vl_tot_debitos_difal  		:= vl_tot_debitos_difal_w;
	fis_registros_w[qt_cursor_w].vl_out_deb_difal         	:= vetRegE310[i].vl_out_deb_difal;
	fis_registros_w[qt_cursor_w].vl_tot_creditos_difal  		:= vl_tot_creditos_difal_w;
	fis_registros_w[qt_cursor_w].vl_out_cred_difal		:= vetRegE310[i].vl_out_cred_difal;
	fis_registros_w[qt_cursor_w].vl_sld_dev_ant_difal		:= vl_sld_dev_ant_difal_w;
	fis_registros_w[qt_cursor_w].vl_deducoes_difal		:= vetRegE310[i].vl_deducoes_difal;
	fis_registros_w[qt_cursor_w].vl_recol				:= vl_recol_difal_w;
	fis_registros_w[qt_cursor_w].vl_sld_cred_transportar  	:= vl_sld_cred_transp_difal_w;
	fis_registros_w[qt_cursor_w].VL_DEB_ESP_DIFAL         	:= vetRegE310[i].deb_esp_difal;
	fis_registros_w[qt_cursor_w].vl_sld_cred_ant_fcp  		:= vl_sld_cred_ant_fcp_w;
	fis_registros_w[qt_cursor_w].vl_tot_deb_fcp    		:= vl_tot_deb_fcp_w;
	fis_registros_w[qt_cursor_w].vl_out_deb_fcp         		:= vetRegE310[i].vl_out_deb_fcp;
	fis_registros_w[qt_cursor_w].vl_tot_cred_fcp    		:= vl_tot_cred_fcp_w;
	fis_registros_w[qt_cursor_w].vl_out_cred_fcp         		:= vetRegE310[i].vl_out_cred_fcp;
	fis_registros_w[qt_cursor_w].vl_sld_dev_ant_fcp    		:= vl_sld_dev_ant_fcp_w;
	fis_registros_w[qt_cursor_w].vl_deducoes_fcp         			:= vetRegE310[i].vl_deducoes_fcp;
	fis_registros_w[qt_cursor_w].vl_recol_fcp    			:= vl_recol_fcp_w;
	fis_registros_w[qt_cursor_w].vl_sld_cred_transportar_fcp  	:=vl_sld_cred_transportar_fcp_w;
	fis_registros_w[qt_cursor_w].vl_deb_esp_fcp    		:= vetRegE310[i].deb_esp_fcp;
	fis_registros_w[qt_cursor_w].sg_uf          			:= sg_uf_p;
	fis_registros_w[qt_cursor_w].nr_seq_controle       		:= nr_seq_controle_p;

	if (nr_vetor_w >= 1000) then
	begin
	/*Inserindo registros definitivamente na tabela especifica - FIS_EFD_ICMSIPI_E310 */

	forall i in fis_registros_w.first .. fis_registros_w.last
	insert into fis_efd_icmsipi_E310 values fis_registros_w(i);

	nr_vetor_w := 0;
	fis_registros_w.delete;

	commit;

	end;
	end if;

	/*incrementa variavel para realizar o forall quando chegar no valor limite*/

	nr_vetor_w := nr_vetor_w + 1;

	end;
	end loop;
EXIT WHEN NOT FOUND; /* apply on c_reg_E310 */
end loop;
close c_reg_E310;

if (fis_registros_w.count > 0) then
begin
/*Inserindo registro que não entraram outro for all devido a quantidade de registros no vetor*/

forall i in fis_registros_w.first .. fis_registros_w.last
	insert into fis_efd_icmsipi_E310 values fis_registros_w(i);

	fis_registros_w.delete;

	commit;

end;
end if;

/*Libera memoria*/

dbms_session.free_unused_user_memory;

/*Atualização informação no controle de geração de registro para SIM*/

if (ie_gerou_dados_bloco_w = 'S') then
	update fis_efd_icmsipi_controle
	set ie_mov_E = 'S'
	where nr_sequencia = nr_seq_controle_p;
	end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_gerar_reg_e310_icmsipi ( nr_seq_controle_p bigint, sg_uf_p text) FROM PUBLIC;

