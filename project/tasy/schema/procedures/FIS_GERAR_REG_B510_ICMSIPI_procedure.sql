-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fis_gerar_reg_b510_icmsipi ( nr_seq_controle_p bigint, nr_seq_superior_p bigint) AS $body$
DECLARE


-- VARIABLES
ie_gerou_dados_bloco_w 	varchar(1)	:= 'N';
nr_vetor_w		bigint	:= 0;
qt_cursor_w		bigint	:= 0;

-- FIS_EFD_ICMSIPI_B510
nr_seq_icmsipi_B510_w	fis_efd_icmsipi_B510.nr_sequencia%type;
cd_ver_w                fis_efd_icmsipi_controle.cd_ver%type;
			
-- USUARIO
nm_usuario_w			usuario.nm_usuario%type;

/*Cursor que retorna as informacoes para o registro B510 restringindo pela sequencia da nota fiscal e sendo agrupado pelos campos de Codigo da Situacao Tributaria, Codigo Fiscal de Operacao e Prestacao e  Aliquota do ICMS*/

c_movimentos_B510 CURSOR FOR
	SELECT 	d.nr_cpf,
		d.nm_pessoa_fisica, 
		c.ie_ind_prof,
		c.ie_ind_esc,
		c.ie_ind_soc
	FROM fis_efd_icmsipi_lote b, fis_efd_icmsipi_controle a, fis_efd_icmsipi_regra_b510 c
LEFT OUTER JOIN pessoa_fisica d ON (c.cd_pessoa_fisica = d.cd_pessoa_fisica)
WHERE a.nr_seq_lote = b.nr_sequencia and b.nr_sequencia = c.nr_seq_lote  and a.nr_sequencia = nr_seq_controle_p;
	
	
/*Criacao do array com o tipo sendo do cursor eespecificado - C_MOVIMENTOS_B510 */
	
type reg_c_movimentos_B510 is table of c_movimentos_B510%RowType;
vetmovimentos_B510	reg_c_movimentos_B510;

/*Criacao do array com o tipo sendo da tabela eespecificada - FIS_EFD_ICMSIPI_B510 */

type registro is table of fis_efd_icmsipi_B510%rowtype index by integer;
fis_registros_w		registro;
		
BEGIN
/*Obter o usuario ativo no tasy*/

nm_usuario_w := Obter_Usuario_Ativo;

select  a.cd_ver
into STRICT 	cd_ver_w
from  	fis_efd_icmsipi_controle   a
where  	a.nr_sequencia 		= nr_seq_controle_p;

if ((cd_ver_w)::numeric  >= 13) then
	open c_movimentos_B510;
	loop
	fetch c_movimentos_B510 bulk collect into vetmovimentos_B510 limit 1000;
		for i in 1..vetmovimentos_B510.Count loop
			begin
			
			/*Incrementa a variavel para o array*/

			qt_cursor_w:=	qt_cursor_w + 1;
			
			if (ie_gerou_dados_bloco_w = 'N') then
				ie_gerou_dados_bloco_w:=	'S';
			end if;
			
			/*Busca da sequencia da tabela especificada - fis_efd_icmsipi_B510 */

			select	nextval('fis_efd_icmsipi_b510_seq')
			into STRICT	nr_seq_icmsipi_B510_w
			;
			
			/*Inserindo valores no array para realizacao do forall posteriormente*/

			fis_registros_w[qt_cursor_w].nr_sequencia		:= nr_seq_icmsipi_B510_w;
			fis_registros_w[qt_cursor_w].dt_atualizacao		:= clock_timestamp();
			fis_registros_w[qt_cursor_w].nm_usuario			:= nm_usuario_w;
			fis_registros_w[qt_cursor_w].dt_atualizacao_nrec	:= clock_timestamp();
			fis_registros_w[qt_cursor_w].nm_usuario_nrec		:= nm_usuario_w;
			fis_registros_w[qt_cursor_w].cd_reg             	:= 'B510';
			fis_registros_w[qt_cursor_w].ie_ind_prof		:= vetmovimentos_B510[i].ie_ind_prof;
			fis_registros_w[qt_cursor_w].ie_ind_esc			:= vetmovimentos_B510[i].ie_ind_esc;
			fis_registros_w[qt_cursor_w].ie_ind_soc			:= vetmovimentos_B510[i].ie_ind_soc;
			fis_registros_w[qt_cursor_w].nr_cpf			:= vetmovimentos_B510[i].nr_cpf;
			fis_registros_w[qt_cursor_w].ds_nome			:= vetmovimentos_B510[i].nm_pessoa_fisica;		
			fis_registros_w[qt_cursor_w].nr_seq_controle    	:= nr_seq_controle_p;
			fis_registros_w[qt_cursor_w].nr_seq_superior   		:= nr_seq_superior_p;
			
			if (nr_vetor_w >= 1000) then
				begin
				/*Inserindo registros definitivamente na tabela especifica - FIS_EFD_ICMSIPI_B510 */

				forall j in fis_registros_w.first..fis_registros_w.last
					insert into fis_efd_icmsipi_B510 values fis_registros_w(j);

				nr_vetor_w	:= 0;
				fis_registros_w.delete;

				commit;

				end;
			end if;
			
			/*incrementa variavel para realizar o forall quando chegar no valor limite*/

			nr_vetor_w	:= nr_vetor_w 	+ 1;
			
			end;
		end loop;
	EXIT WHEN NOT FOUND; /* apply on c_movimentos_B510 */
	end loop;
	close c_movimentos_B510;
end if;

if (fis_registros_w.count > 0) then
	begin
	/*Inserindo registro que nao entraram outro for all devido a quantidade de registros no vetor*/

	forall l in fis_registros_w.first..fis_registros_w.last
		insert into fis_efd_icmsipi_B510 values fis_registros_w(l);
		
	fis_registros_w.delete;

	commit;
	
	end;
end if;

/*Libera memoria*/

dbms_session.free_unused_user_memory;

/*Atualizacao informacao no controle de geracao de registro para SIM*/

if (ie_gerou_dados_bloco_w = 'S') then
	update 	fis_efd_icmsipi_controle
	set	ie_mov_B 	= 'S'
	where 	nr_sequencia 	= nr_seq_controle_p;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_gerar_reg_b510_icmsipi ( nr_seq_controle_p bigint, nr_seq_superior_p bigint) FROM PUBLIC;
