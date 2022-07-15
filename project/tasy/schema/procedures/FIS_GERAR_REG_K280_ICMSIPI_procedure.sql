-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fis_gerar_reg_k280_icmsipi ( nr_seq_controle_p bigint, nr_seq_superior_p bigint) AS $body$
DECLARE


/*REGISTRO K280: ESTOQUE ESCRITURADO*/



-- VARIABLES
ie_gerou_dados_bloco_w 	varchar(1) := 'N';
qt_cursor_w 			bigint := 0;
nr_vetor_w  			bigint := 0;
qt_cor_calc_w			double precision := 0;

-- FIS_EFD_ICMSIPI_K280
nr_seq_icmsipi_K280_w 	fis_efd_icmsipi_K280.nr_sequencia%type;

-- USUARIO
nm_usuario_w 			usuario.nm_usuario%type;

/*Cursor que retorna as informações para o registro K280 restringindo pela sequencia da nota fiscal*/
c_reg_K280 CURSOR FOR
SELECT 	to_date(a.dt_movimento_estoque, 'dd-mm-rrrr') dt_est,
		b.dt_fim_apuracao dt_fim_apuracao,
		a.cd_material cd_item,
		sum(CASE WHEN d.ie_entrada_saida='E' THEN a.qt_estoque  ELSE 0 END ) qt_cor_pos,
		sum(CASE WHEN d.ie_entrada_saida='S' THEN a.qt_estoque  ELSE 0 END ) qt_cor_neg
FROM material_estab e, operacao_estoque d, fis_efd_icmsipi_controle b, movimento_estoque a
LEFT OUTER JOIN material_fiscal c ON (a.cd_material = c.cd_material)
WHERE trunc(a.dt_processo) between trunc(add_months(b.dt_inicio_apuracao, -1)) and trunc(add_months(b.dt_fim_apuracao, -1)) and a.dt_movimento_estoque <  b.dt_inicio_apuracao and e.cd_material = a.cd_material and e.cd_estabelecimento = a.cd_estabelecimento and a.cd_estabelecimento = b.cd_estabelecimento and e.ie_material_estoque = 'S' and b.nr_sequencia = nr_seq_controle_p and d.cd_operacao_estoque = a.cd_operacao_estoque and a.ie_origem_documento = 5  and c.ie_tipo_fiscal in ('00', '01', '02', '03', '04', '05', '06', '10') group by 	to_date(a.dt_movimento_estoque, 'dd-mm-rrrr'), 
		b.dt_fim_apuracao, 
		a.cd_material
having(sum(CASE WHEN d.ie_entrada_saida='E' THEN a.qt_estoque  ELSE 0 END ) - sum(CASE WHEN d.ie_entrada_saida='S' THEN a.qt_estoque  ELSE 0 END )) <> 0
order by 1, 2;

/*Criação do array com o tipo sendo do cursor eespecificado - c_reg_K280*/

type reg_c_reg_K280 is table of c_reg_K280%RowType;
vetRegK280 reg_c_reg_K280;

/*Criação do array com o tipo sendo da tabela eespecificada - FIS_EFD_ICMSIPI_K280 */

type registro is table of fis_efd_icmsipi_K280%rowtype index by integer;
fis_registros_w registro;

BEGIN
/*Obteção do usuário ativo no tasy*/

nm_usuario_w := Obter_Usuario_Ativo;

open c_reg_K280;
loop
fetch c_reg_K280 bulk collect      into vetRegK280 limit 1000;
	for i in 1 .. vetRegK280.Count loop

	begin

	/*Incrementa a variavel para o array*/

	qt_cursor_w:=	qt_cursor_w + 1;

	if (ie_gerou_dados_bloco_w = 'N') then
		ie_gerou_dados_bloco_w := 'S';
	end if;

	/*Busca da sequencia da tabela especificada - fis_efd_icmsipi_K280 */

	select nextval('fis_efd_icmsipi_k280_seq')	into STRICT nr_seq_icmsipi_K280_w	;
	
	qt_cor_calc_w := vetRegK280[i].qt_cor_pos - vetRegK280[i].qt_cor_neg;
	
	if (qt_cor_calc_w > 0) then
		vetRegK280[i].qt_cor_neg := null;
		vetRegK280[i].qt_cor_pos := qt_cor_calc_w;
		
	elsif (qt_cor_calc_w < 0) then
		vetRegK280[i].qt_cor_pos := null;
		vetRegK280[i].qt_cor_neg := abs(qt_cor_calc_w);
		
	end if;
		
	/*Inserindo valores no array para realização do forall posteriormente*/
	fis_registros_w[qt_cursor_w].nr_sequencia 			:= nr_seq_icmsipi_K280_w;
	fis_registros_w[qt_cursor_w].dt_atualizacao 		:= clock_timestamp();
	fis_registros_w[qt_cursor_w].nm_usuario 			:= nm_usuario_w;
	fis_registros_w[qt_cursor_w].dt_atualizacao_nrec 	:= clock_timestamp();
	fis_registros_w[qt_cursor_w].nm_usuario_nrec 		:= nm_usuario_w;
	fis_registros_w[qt_cursor_w].cd_reg 				:= 'K280';
	fis_registros_w[qt_cursor_w].dt_est 				:= vetRegK280[i].dt_est;
	fis_registros_w[qt_cursor_w].cd_item 				:= vetRegK280[i].cd_item;
	fis_registros_w[qt_cursor_w].qt_cor_pos 			:= vetRegK280[i].qt_cor_pos;
	fis_registros_w[qt_cursor_w].qt_cor_neg 			:= vetRegK280[i].qt_cor_neg;
	fis_registros_w[qt_cursor_w].cd_ind_est 			:= 0;
	fis_registros_w[qt_cursor_w].cd_part 				:= null;
	fis_registros_w[qt_cursor_w].nr_seq_controle 		:= nr_seq_controle_p;
	fis_registros_w[qt_cursor_w].nr_seq_superior 		:= nr_seq_superior_p;
	

	if (nr_vetor_w >= 1000) then
	begin
		/*Inserindo registros definitivamente na tabela especifica - FIS_EFD_ICMSIPI_K280 */

		forall i in fis_registros_w.first .. fis_registros_w.last
		insert into fis_efd_icmsipi_K280 values fis_registros_w(i);

		nr_vetor_w := 0;
		fis_registros_w.delete;

		commit;

	end;
	end if;

	/*incrementa variavel para realizar o forall quando chegar no valor limite*/

	nr_vetor_w := nr_vetor_w + 1;

	end;
	end loop;
EXIT WHEN NOT FOUND; /* apply on c_reg_K280 */
end loop;
close c_reg_K280;

if (fis_registros_w.count > 0) then
begin
	/*Inserindo registro que não entraram outro for all devido a quantidade de registros no vetor*/

	forall i in fis_registros_w.first .. fis_registros_w.last
	insert into fis_efd_icmsipi_K280 values fis_registros_w(i);

	fis_registros_w.delete;

	commit;

end;
end if;

/*Libera memoria*/

dbms_session.free_unused_user_memory;

/*Atualização informação no controle de geração de registro para SIM*/

if (ie_gerou_dados_bloco_w = 'S') then
	update fis_efd_icmsipi_controle set ie_mov_K = 'S' where nr_sequencia = nr_seq_controle_p;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_gerar_reg_k280_icmsipi ( nr_seq_controle_p bigint, nr_seq_superior_p bigint) FROM PUBLIC;

