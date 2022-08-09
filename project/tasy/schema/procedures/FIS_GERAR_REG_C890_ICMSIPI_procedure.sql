-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fis_gerar_reg_c890_icmsipi ( nr_seq_controle_p bigint, dt_doc_p timestamp) AS $body$
DECLARE


/*REGISTRO C860: IDENTIFICAÇÃO DO EQUIPAMENTO SAT-CF-E*/

-- VARIABLES
ie_gerou_dados_bloco_w varchar(1) := 'N';

nr_seq_icmsipi_C890_w fis_efd_icmsipi_C890.nr_sequencia%type;

qt_cursor_w bigint := 0;
nr_vetor_w  bigint := 0;

-- USUARIO
nm_usuario_w usuario.nm_usuario%type;

/*Cursor que retorna as informações para o registro c890*/

c_resumo_d_cfesat CURSOR FOR
	SELECT	a.cd_cst_icms,
		a.cd_cfop,
		a.tx_aliq_icms,
		sum(a.vl_total_item_nf) vl_opr,
		max(a.vl_bc_icms) vl_bc_icms,
		max(a.vl_icms) vl_icms,
		max(a.cd_obs) cd_obs
	from	(	SELECT	substr(c.ie_origem_mercadoria, 1, 1) || substr(c.ie_tributacao_icms, 1, 2) cd_cst_icms,
				substr(Elimina_Caracter(obter_dados_natureza_operacao(a.cd_natureza_operacao, 'CF'), '.'), 1, 4) cd_cfop,
				0 tx_aliq_icms,
				b.vl_total_item_nf,
				0 vl_bc_icms,
				0 vl_icms,
				(select	d.nr_sequencia
				from	fis_variacao_fiscal v,
					fis_dispositivo_legal d
				where	b.nr_seq_variacao_fiscal = v.nr_sequencia
				and	v.cd_dispositivo_legal = d.nr_sequencia) cd_obs
			FROM fis_efd_icmsipi_c800 d, nota_fiscal a, nota_fiscal_item b
LEFT OUTER JOIN material_fiscal c ON (b.cd_material = c.cd_material)
WHERE a.nr_sequencia	= b.nr_Sequencia  and a.nr_sequencia	= d.nr_seq_nota and trunc(a.dt_emissao)	= trunc(d.dt_doc) and trunc(d.dt_doc)	= trunc(dt_doc_p) ) a
	group by	a.cd_cst_icms,
			a.cd_cfop,
			a.tx_aliq_icms;

/*Criação do array com o tipo sendo do cursor eespecificado - c_itens_cupom_fiscal*/

type reg_c_resumo_d_cfesat is table of c_resumo_d_cfesat%RowType;
vetResCFESAT reg_c_resumo_d_cfesat;

/*Criação do array com o tipo sendo da tabela eespecificada - FIS_EFD_ICMSIPI_C890 */

type registro is table of fis_efd_icmsipi_C890%rowtype index by integer;
fis_registros_w registro;

BEGIN

/*Obteção do usuário ativo no tasy*/

nm_usuario_w := Obter_Usuario_Ativo;

open c_resumo_d_cfesat;
loop
fetch c_resumo_d_cfesat bulk collect
into vetResCFESAT limit 1000;
	for i in 1 .. vetResCFESAT.Count loop
	begin

	/*Incrementa a variavel para o array*/

	qt_cursor_w:=	qt_cursor_w + 1;

	if (ie_gerou_dados_bloco_w = 'N') then
	ie_gerou_dados_bloco_w := 'S';
	end if;

	/*Busca da sequencia da tabela especificada - fis_efd_icmsipi_C860 */

	select	nextval('fis_efd_icmsipi_c890_seq')
	into STRICT	nr_seq_icmsipi_C890_w
	;

	/*Inserindo valores no array para realização do forall posteriormente*/

	fis_registros_w[qt_cursor_w].nr_sequencia        := nr_seq_icmsipi_C890_w;
	fis_registros_w[qt_cursor_w].dt_atualizacao      := clock_timestamp();
	fis_registros_w[qt_cursor_w].nm_usuario          := nm_usuario_w;
	fis_registros_w[qt_cursor_w].dt_atualizacao_nrec := clock_timestamp();
	fis_registros_w[qt_cursor_w].nm_usuario_nrec     := nm_usuario_w;
	fis_registros_w[qt_cursor_w].cd_reg              := 'C890';
	fis_registros_w[qt_cursor_w].cd_cst_icms         := vetResCFESAT[i].cd_cst_icms;
	fis_registros_w[qt_cursor_w].cd_cfop             := vetResCFESAT[i].cd_cfop;
	fis_registros_w[qt_cursor_w].tx_aliq_icms        := vetResCFESAT[i].tx_aliq_icms;
	fis_registros_w[qt_cursor_w].vl_opr              := vetResCFESAT[i].vl_opr;
	fis_registros_w[qt_cursor_w].vl_bc_icms          := vetResCFESAT[i].vl_bc_icms;
	fis_registros_w[qt_cursor_w].vl_icms             := vetResCFESAT[i].vl_icms;
	fis_registros_w[qt_cursor_w].cd_obs              := vetResCFESAT[i].cd_obs;
	fis_registros_w[qt_cursor_w].dt_doc              := dt_doc_p;
	fis_registros_w[qt_cursor_w].nr_seq_controle     := nr_seq_controle_p;

	if (nr_vetor_w >= 1000) then
		begin
		/*Inserindo registros definitivamente na tabela especifica - FIS_EFD_ICMSIPI_C470 */

		forall i in fis_registros_w.first .. fis_registros_w.last
			insert into fis_efd_icmsipi_C890 values fis_registros_w(i);

		nr_vetor_w := 0;
		fis_registros_w.delete;

		commit;

		end;
	end if;

	/*incrementa variavel para realizar o forall quando chegar no valor limite*/

	nr_vetor_w := nr_vetor_w + 1;

	end;
	end loop;
EXIT WHEN NOT FOUND; /* apply on c_resumo_d_cfesat */
end loop;
close c_resumo_d_cfesat;

if (fis_registros_w.count > 0) then
	begin
	/*Inserindo registro que não entraram outro for all devido a quantidade de registros no vetor*/

	forall i in fis_registros_w.first .. fis_registros_w.last
		insert into fis_efd_icmsipi_C890 values fis_registros_w(i);

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
-- REVOKE ALL ON PROCEDURE fis_gerar_reg_c890_icmsipi ( nr_seq_controle_p bigint, dt_doc_p timestamp) FROM PUBLIC;
