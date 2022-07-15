-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fis_gerar_reg_h010_icmsipi ( nr_seq_controle_p bigint, dt_inicio_apuracao_p timestamp, dt_fim_apuracao_p timestamp, cd_estabelecimento_p bigint) AS $body$
DECLARE


/*REGISTRO H010: TOTAIS DO INVENTÁRIO*/



-- VARIABLES
ie_gerou_dados_bloco_w varchar(1) := 'N';

nr_seq_icmsipi_H010_w	fis_efd_icmsipi_H010.nr_sequencia%type;
cd_conta_contabil_w	conta_contabil.cd_conta_contabil%type;
cd_centro_custo_w	centro_custo.cd_centro_custo%type;



qt_cursor_w bigint := 0;
nr_vetor_w  bigint := 0;

-- USUARIO
nm_usuario_w usuario.nm_usuario%type;

/*Cursor que retorna as informações para o registro H010 restringindo pela sequencia da nota fiscal*/
c_reg_H010 CURSOR FOR
	SELECT	a.cd_material cd_item,
		max(b.cd_unidade_medida_estoque) cd_unid,
		coalesce(sum(a.qt_estoque), '0') qt_item,
		coalesce(sum(a.vl_custo_medio), '0') vl_unit,
		coalesce(sum(a.vl_estoque), 0) vl_item,
		'0' cd_ind_prop,
		null cd_part,
		null ds_txt_compl,
		sum(a.vl_estoque) vl_item_ir
	from	saldo_estoque a,
		material b
	where	a.cd_material = b.cd_material
	and 	a.cd_estabelecimento = cd_estabelecimento_p
	and 	trunc(a.dt_mesano_referencia) = dt_inicio_apuracao_p
	group by	a.cd_material
	
union all

	SELECT	a.cd_material cd_item,
		max(b.cd_unidade_medida_estoque) cd_unid,
		coalesce(sum(a.qt_estoque), '0') qt_item,
		coalesce(sum(a.vl_custo_medio), '0') vl_unit,
		coalesce(sum(a.vl_estoque), 0) vl_item,
		'2' cd_ind_prop,
		a.cd_fornecedor cd_part,
		null ds_txt_compl,
		sum(a.vl_estoque) vl_item_ir
	from	fornecedor_mat_consignado a,
		material b
	where	a.cd_material = b.cd_material
	and 	a.cd_estabelecimento = cd_estabelecimento_p
	and 	trunc(a.dt_mesano_referencia) = dt_inicio_apuracao_p
	group by	a.cd_material,
			a.cd_fornecedor;

/*Criação do array com o tipo sendo do cursor eespecificado - c_reg_H010*/

type reg_c_reg_H010 is table of c_reg_H010%RowType;
vetRegH010 reg_c_reg_H010;

/*Criação do array com o tipo sendo da tabela eespecificada - FIS_EFD_ICMSIPI_H010 */

type registro is table of fis_efd_icmsipi_H010%rowtype index by integer;
fis_registros_w registro;

BEGIN
/*Obteção do usuário ativo no tasy*/

nm_usuario_w := Obter_Usuario_Ativo;

open c_reg_H010;
loop
fetch c_reg_H010 bulk collect into vetRegH010 limit 1000;
	for i in 1 .. vetRegH010.Count loop
		begin

		/*Incrementa a variavel para o array*/

		qt_cursor_w:=	qt_cursor_w + 1;

		if (ie_gerou_dados_bloco_w = 'N') then
			ie_gerou_dados_bloco_w := 'S';
		end if;
		
		begin
		/*Busca a conta contabil de estoque*/

		SELECT * FROM define_conta_material(	cd_estabelecimento_p, vetRegH010[i].cd_item, 2, null, null, null, null, null, null, null, null, null, dt_fim_apuracao_p, cd_conta_contabil_w, cd_centro_custo_w, null) INTO STRICT cd_conta_contabil_w, cd_centro_custo_w;
					
		exception
		when others then
			cd_conta_contabil_w :=	null;
			cd_centro_custo_w :=	null;	
		end;

		/*Busca da sequencia da tabela especificada - fis_efd_icmsipi_H010 */

		select	nextval('fis_efd_icmsipi_h010_seq')
		into STRICT	nr_seq_icmsipi_H010_w
		;

		/*Inserindo valores no array para realização do forall posteriormente*/
		fis_registros_w[qt_cursor_w].nr_sequencia 		:= nr_seq_icmsipi_H010_w;
		fis_registros_w[qt_cursor_w].dt_atualizacao 		:= clock_timestamp();
		fis_registros_w[qt_cursor_w].nm_usuario 		:= nm_usuario_w;
		fis_registros_w[qt_cursor_w].dt_atualizacao_nrec 	:= clock_timestamp();
		fis_registros_w[qt_cursor_w].nm_usuario_nrec 		:= nm_usuario_w;
		fis_registros_w[qt_cursor_w].cd_reg 			:= 'H010';
		fis_registros_w[qt_cursor_w].cd_item 			:= vetRegH010[i].cd_item;
		fis_registros_w[qt_cursor_w].cd_unid 			:= substr(vetRegH010[i].cd_unid,1,6);
		fis_registros_w[qt_cursor_w].qt_item 			:= vetRegH010[i].qt_item;
		fis_registros_w[qt_cursor_w].vl_unit 			:= vetRegH010[i].vl_unit;
		fis_registros_w[qt_cursor_w].vl_item 			:= vetRegH010[i].vl_item;
		fis_registros_w[qt_cursor_w].cd_ind_prop 		:= vetRegH010[i].cd_ind_prop;
		fis_registros_w[qt_cursor_w].cd_part 			:= vetRegH010[i].cd_part;
		fis_registros_w[qt_cursor_w].ds_txt_compl 		:= vetRegH010[i].ds_txt_compl;
		fis_registros_w[qt_cursor_w].cd_cta 			:= cd_conta_contabil_w;
		fis_registros_w[qt_cursor_w].vl_item_ir 		:= vetRegH010[i].vl_item_ir;
		fis_registros_w[qt_cursor_w].dt_inv			:= dt_fim_apuracao_p;
		fis_registros_w[qt_cursor_w].nr_seq_controle 		:= nr_seq_controle_p;

		if (nr_vetor_w >= 1000) then
			begin
			/*Inserindo registros definitivamente na tabela especifica - FIS_EFD_ICMSIPI_H010 */

			forall i in fis_registros_w.first .. fis_registros_w.last
				insert into fis_efd_icmsipi_H010 values fis_registros_w(i);

			nr_vetor_w := 0;
			fis_registros_w.delete;

			commit;

			end;
		end if;

		/*incrementa variavel para realizar o forall quando chegar no valor limite*/

		nr_vetor_w := nr_vetor_w + 1;

		end;
	end loop;
EXIT WHEN NOT FOUND; /* apply on c_reg_H010 */
end loop;
close c_reg_H010;

if (fis_registros_w.count > 0) then
	begin
	/*Inserindo registro que não entraram outro for all devido a quantidade de registros no vetor*/

	forall i in fis_registros_w.first .. fis_registros_w.last
		insert into fis_efd_icmsipi_H010 values fis_registros_w(i);

	fis_registros_w.delete;

	commit;

	end;
end if;

/*Libera memoria*/

dbms_session.free_unused_user_memory;

/*Atualização informação no controle de geração de registro para SIM*/

if (ie_gerou_dados_bloco_w = 'S') then
	update	fis_efd_icmsipi_controle
	set	ie_mov_H = 'S'
	where	nr_sequencia = nr_seq_controle_p;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_gerar_reg_h010_icmsipi ( nr_seq_controle_p bigint, dt_inicio_apuracao_p timestamp, dt_fim_apuracao_p timestamp, cd_estabelecimento_p bigint) FROM PUBLIC;

