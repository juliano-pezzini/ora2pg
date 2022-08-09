-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fis_gerar_reg_c490_icmsipi ( nr_seq_controle_p bigint, nr_ecf_cx_p text, dt_doc_p timestamp) AS $body$
DECLARE


/*REGISTRO C490: REGISTRO ANALÍTICO DO MOVIMENTO DIÁRIO (CÓDIGO 02, 2D e60).*/

-- VARIABLES
ie_gerou_dados_bloco_w 	varchar(1) := 'N';

nr_seq_icmsipi_C490_w	fis_efd_icmsipi_C490.nr_sequencia%type;

qt_cursor_w				bigint := 0;
nr_vetor_w				bigint := 0;

-- USUARIO
nm_usuario_w usuario.nm_usuario%type;

/*Cursor que retorna as informações para o registro c490 restringindo pela sequencia da nota fiscal*/

c_reg_C490 CURSOR FOR
SELECT	a.cd_cst_icms,
		a.cd_cfop,
		a.tx_aliq_icms,
		sum(a.vl_item) vl_opr,
		0 vl_bc_icms,
		0 vl_icms,
		max(a.cd_obs) cod_obs,
		sum(((coalesce(b.vl_despesa_acessoria,0) + coalesce(b.vl_frete,0) + coalesce(b.vl_seguro,0)) - coalesce(b.vl_descontos,0))) vl_despesas
from	fis_efd_icmsipi_c470 a,
		fis_efd_icmsipi_C460 c,
		nota_fiscal b
where	a.nr_seq_nota		= b.nr_sequencia
and 	a.nr_Seq_nota		= c.nr_seq_nota
and 	a.nr_Seq_controle	= c.nr_Seq_controle
and 	trunc(b.dt_emissao)	= trunc(dt_doc_p)
and		c.nr_ecf_cx		= nr_ecf_cx_p
and 	a.nr_seq_controle	= nr_seq_controle_p
group by a.cd_cst_icms,
		a.cd_cfop,
		a.tx_aliq_icms
order by	sum(a.vl_item) desc;

/*Criação do array com o tipo sendo do cursor eespecificado - c_itens_cupom_fiscal*/

type reg_c_reg_C490 is table of c_reg_C490%RowType;
vetRegC490 reg_c_reg_C490;

/*Criação do array com o tipo sendo da tabela eespecificada - FIS_EFD_ICMSIPI_C490 */

type registro is table of fis_efd_icmsipi_C490%rowtype index by integer;
fis_registros_w registro;

BEGIN
/*Obteção do usuário ativo no tasy*/

nm_usuario_w := Obter_Usuario_Ativo;

open c_reg_C490;
loop
fetch c_reg_C490 bulk collect into vetRegC490 limit 1000;
	for i in 1 .. vetRegC490.Count loop
		begin

		/*Incrementa a variavel para o array*/

		qt_cursor_w:=	qt_cursor_w + 1;

		if (ie_gerou_dados_bloco_w = 'N') then
			ie_gerou_dados_bloco_w := 'S';
		end if;
		
		if (i = 1) then
			vetRegC490[i].vl_opr := vetRegC490[i].vl_opr + coalesce(vetRegC490[i].vl_despesas,0);
		end if;

		/*Busca da sequencia da tabela especificada - fis_efd_icmsipi_C490 */

		select	nextval('fis_efd_icmsipi_c490_seq')
		into STRICT	nr_seq_icmsipi_C490_w
		;

		/*Inserindo valores no array para realização do forall posteriormente*/
		fis_registros_w[qt_cursor_w].nr_sequencia 			:= nr_seq_icmsipi_C490_w;
		fis_registros_w[qt_cursor_w].dt_atualizacao 		:= clock_timestamp();
		fis_registros_w[qt_cursor_w].nm_usuario 			:= nm_usuario_w;
		fis_registros_w[qt_cursor_w].dt_atualizacao_nrec 	:= clock_timestamp();
		fis_registros_w[qt_cursor_w].nm_usuario_nrec 		:= nm_usuario_w;
		fis_registros_w[qt_cursor_w].cd_reg 				:= 'C490';
		fis_registros_w[qt_cursor_w].cd_cst_icms 			:= vetRegC490[i].cd_cst_icms;
		fis_registros_w[qt_cursor_w].cd_cfop 				:= vetRegC490[i].cd_cfop;
		fis_registros_w[qt_cursor_w].tx_aliq_icms 			:= vetRegC490[i].tx_aliq_icms;
		fis_registros_w[qt_cursor_w].vl_opr 				:= vetRegC490[i].vl_opr;
		fis_registros_w[qt_cursor_w].vl_bc_icms 			:= vetRegC490[i].vl_bc_icms;
		fis_registros_w[qt_cursor_w].vl_icms 				:= vetRegC490[i].vl_icms;
		fis_registros_w[qt_cursor_w].cod_obs 				:= vetRegC490[i].cod_obs;
		fis_registros_w[qt_cursor_w].nr_seq_controle 		:= nr_seq_controle_p;
		fis_registros_w[qt_cursor_w].nr_ecf_cx				:= nr_ecf_cx_p;
		fis_registros_w[qt_cursor_w].dt_doc					:= dt_doc_p;

		if (nr_vetor_w >= 1000) then
			begin
			/*Inserindo registros definitivamente na tabela especifica - FIS_EFD_ICMSIPI_C490 */

			forall i in fis_registros_w.first .. fis_registros_w.last
				insert into fis_efd_icmsipi_C490 values fis_registros_w(i);

			nr_vetor_w := 0;
			fis_registros_w.delete;

			commit;

			end;
		end if;

		/*incrementa variavel para realizar o forall quando chegar no valor limite*/

		nr_vetor_w := nr_vetor_w + 1;

		end;
	end loop;
EXIT WHEN NOT FOUND; /* apply on c_reg_C490 */
end loop;
close c_reg_C490;

if (fis_registros_w.count > 0) then
	begin
	/*Inserindo registro que não entraram outro for all devido a quantidade de registros no vetor*/

	forall i in fis_registros_w.first .. fis_registros_w.last
		insert into fis_efd_icmsipi_C490 values fis_registros_w(i);

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
-- REVOKE ALL ON PROCEDURE fis_gerar_reg_c490_icmsipi ( nr_seq_controle_p bigint, nr_ecf_cx_p text, dt_doc_p timestamp) FROM PUBLIC;
