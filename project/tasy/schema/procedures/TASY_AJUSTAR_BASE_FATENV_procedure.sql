-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tasy_ajustar_base_fatenv ( nm_usuario_p text) AS $body$
DECLARE



dt_versao_atual_cliente_w	timestamp;
qt_registro_w			bigint;

BEGIN

CALL abortar_se_base_wheb();

dt_versao_atual_cliente_w := coalesce(to_date(to_char(obter_data_geracao_versao-1,'dd/mm/yyyy') ||' 23:59:59','dd/mm/yyyy hh24:mi:ss'),clock_timestamp() - interval '90 days');

if (dt_versao_atual_cliente_w < to_date('12/04/2013','dd/mm/yyyy')) then

	CALL exec_sql_dinamico('Ronaldo','update funcao_filtro set	cd_funcao = 988 where	ds_filtro = ''filtros_gb'' and	cd_funcao = 801');

end if;

if (dt_versao_atual_cliente_w < to_date('22/04/2013','dd/mm/yyyy')) then

	select	count(*)
	into STRICT	qt_registro_w
	from	user_constraints
	where	constraint_name	= 'LAUHBAI_CONREIT_FK';

	if (qt_registro_w > 0) then
		CALL Exec_sql_Dinamico('lhalves', ' alter table LOTE_AUDIT_HIST_BAIXA drop constraint LAUHBAI_CONREIT_FK ');
	end if;

	select	count(*)
	into STRICT	qt_registro_w
	from	user_indexes
	where	index_name	= 'LAUHBAI_CONREIT_FK_I';

	if (qt_registro_w > 0) then
		CALL Exec_sql_Dinamico('lhalves', ' drop Index LAUHBAI_CONREIT_FK_I ');
	end if;
end if;

if (dt_versao_atual_cliente_w < to_date('18/09/2013','dd/mm/yyyy')) then

	CALL exec_sql_dinamico('lhalves ','update xml_projeto set ie_situacao = ''A'' where nr_sequencia in (101046,101076,101080,101116) ');

end if;

if (dt_versao_atual_cliente_w < to_date('17/06/2014','dd/mm/yyyy')) then

	CALL exec_sql_dinamico('lhalves ','update TISS_MOTIVO_SAIDA_INT set IE_VERSAO_TISS = ''3.02.00'' where IE_VERSAO_TISS in (''3.00.01'',''3.01.00'')');

	CALL exec_sql_dinamico('lhalves ','update TISS_MOTIVO_SAIDA_INT set DS_MOTIVO = ''(INATIVO) Alta da Puérpera e recém-nascido'' where nr_sequencia = 116');

	CALL exec_sql_dinamico('lhalves ','update TISS_MOTIVO_SAIDA_INT set DS_MOTIVO = ''Permanencia por Processo de doação de órgãos, tecidos e células - doador vivo'' where nr_sequencia = 121');

	CALL exec_sql_dinamico('lhalves ','update valor_dominio set ie_situacao = ''A'' where cd_dominio = 1761 and vl_dominio in (''11'',''13'')');

end if;

if (dt_versao_atual_cliente_w < to_date('07/08/2014','dd/mm/yyyy')) then

	CALL exec_sql_dinamico('lhalves ','update	TISS_TIPO_TABELA set IE_VERSAO_TISS = ''3.02.00'' where IE_VERSAO_TISS = ''3.01.00''');

end if;

if (dt_versao_atual_cliente_w < to_date('12/08/2014','dd/mm/yyyy')) then

	CALL exec_sql_dinamico('lhalves ','update xml_projeto set DS_PROJETO = ''TISS - 3.02.00 Hospital - Protocolo Convênio / Elegibilidade / Comunicação Beneficiário'' where NR_SEQUENCIA = 101383');
	CALL exec_sql_dinamico('lhalves ','update xml_projeto set DS_PROJETO = ''TISS RETORNO - 3.02.00 Demonstrativos e Protocolos'' where NR_SEQUENCIA = 101384');
	CALL exec_sql_dinamico('lhalves ','update xml_projeto set DS_PROJETO = ''TISS - 3.02.00 Hospital - Solicitações/Autorizações e Respostas de Autorizações'' where NR_SEQUENCIA = 101385');
	CALL exec_sql_dinamico('lhalves ','update xml_projeto set DS_PROJETO = ''TISS - 3.02.00 Hospital - Recurso de Glosa'' where NR_SEQUENCIA = 101386');

end if;

if (dt_versao_atual_cliente_w < to_date('03/10/2014','dd/mm/yyyy')) then
	CALL exec_sql_dinamico('lhalves ','update TISS_INCONSISTENCIA set DS_INCONSISTENCIA = ''Número de guias não permitido para a versão do TISS utilizada.'' where NR_SEQUENCIA = 49');
	CALL exec_sql_dinamico('lhalves ','update TISS_INCONSISTENCIA set DS_INCONSISTENCIA = ''CBOS informado para o médico solicitante não pertence a versão TISS utilizada pelo convênio'' where NR_SEQUENCIA = 80');
	CALL exec_sql_dinamico('lhalves ','update tiss_regra_guia_prest set ie_forma = ''12'' where ie_forma is null');

end if;

if (dt_versao_atual_cliente_w < to_date('21/10/2014','dd/mm/yyyy')) then
	CALL exec_sql_dinamico('lhalves ','update TISS_UNIDADE_MEDIDA set DS_UNIDADE_MEDIDA = ''Milílitro'' where nr_sequencia = 24');
end if;

if (dt_versao_atual_cliente_w < to_date('08/12/2014','dd/mm/yyyy')) then
	CALL Exec_sql_Dinamico_bv('lhalves','ALTER TABLE AUTORIZACAO_CONVENIO_COMPL MODIFY VL_AUTORIZADO NUMBER(15,2)','');
end if;

if (dt_versao_atual_cliente_w < to_date('20/03/2015','dd/mm/yyyy')) then

	/*select	count(*)
	into	qt_registro_w
	from	REGRA_COMUNIC_AUTOR_CONV;

	Alterei novamente, para verificar se o campo já foi alterado para long, se ainda não foi, tenta alterar novamente
	*/
	select	count(*)
	into STRICT	qt_registro_w
	from	user_tab_columns
	where	table_name 	= 'REGRA_COMUNIC_AUTOR_CONV'
	and	column_name	= 'DS_MENSAGEM'
	and	data_type	= 'LONG';

	if (qt_registro_w = 0) then
		CALL exec_sql_dinamico('lhalves','alter table REGRA_COMUNIC_AUTOR_CONV add DS_MENSAGEM_2 varchar2(4000)'); --Cria o campo auxiliar
		CALL exec_sql_dinamico('lhalves','update REGRA_COMUNIC_AUTOR_CONV set DS_MENSAGEM_2 = DS_MENSAGEM where DS_MENSAGEM is not null'); --Copia os valores atuais para o campo auxiliar
		CALL exec_sql_dinamico('lhalves','update REGRA_COMUNIC_AUTOR_CONV set DS_MENSAGEM = null where DS_MENSAGEM is not null'); --Limpa o campo auxiliar
		CALL exec_sql_dinamico('lhalves','alter table REGRA_COMUNIC_AUTOR_CONV modify DS_MENSAGEM long'); --Altera o tipo do campo atual
		CALL exec_sql_dinamico('lhalves','update REGRA_COMUNIC_AUTOR_CONV a set a.DS_MENSAGEM = DS_MENSAGEM_2 where DS_MENSAGEM_2 is not null'); --Volta os valores para o campo atual
		CALL exec_sql_dinamico('lhalves','alter table REGRA_COMUNIC_AUTOR_CONV drop column DS_MENSAGEM_2'); --Exclui o campo auxiliar
	end if;
end if;

if (dt_versao_atual_cliente_w < to_date('01/04/2015','dd/mm/yyyy')) then

	select	count(*)
	into STRICT	qt_registro_w
	from	user_tab_columns
	where	table_name 	= 'CONV_TAXA_FAT_DIRETO'
	and	column_name	= 'IE_ORIGEM_FAT_DIRETO';

	if (qt_registro_w > 0) then
		CALL exec_sql_dinamico('lhalves','alter table CONV_TAXA_FAT_DIRETO drop column IE_ORIGEM_FAT_DIRETO');
	end if;

end if;

if (dt_versao_atual_cliente_w < to_date('18/05/2015','dd/mm/yyyy')) then
	begin

	select	count(*)
	into STRICT 	qt_registro_w
	from	interface
	where	cd_interface = 2681;

	if (qt_registro_w = 0) then
		begin
		CALL exec_sql_dinamico('ralves', 'insert into interface select * from tasy_versao.interface where cd_interface in (2681)');
		CALL exec_sql_dinamico('ralves', 'insert into interface_reg select * from tasy_versao.interface_reg where cd_interface in(2681)');
		CALL exec_sql_dinamico('ralves', 'insert into interface_atributo select * from tasy_versao.interface_atributo where cd_interface in (2681)');
		end;
	end if;

	end;
end if;

if (dt_versao_atual_cliente_w < to_date('24/06/2015','dd/mm/yyyy')) then

	CALL exec_sql_dinamico('lhalves', 'Alter Table CONVENIO_PACOTE_AUTOR_EXIG drop constraint CNVPCTEX_CNVPCTAT_FK');
	CALL exec_sql_dinamico('lhalves', 'Alter Table CONVENIO_PACOTE_AUTOR_EXIG add (Constraint CNVPCTEX_CNVPCTAT_FK Foreign Key (NR_SEQ_PACOTE) References CONVENIO_PACOTE_AUTOR (NR_SEQUENCIA) on delete cascade)');

	CALL exec_sql_dinamico('lhalves', 'Alter Table CONVENIO_PACOTE_AUTOR_PROC drop constraint CNVPCTPR_CNVPCTAT_FK');
	CALL exec_sql_dinamico('lhalves', 'Alter Table CONVENIO_PACOTE_AUTOR_PROC add (Constraint CNVPCTPR_CNVPCTAT_FK Foreign Key (NR_SEQ_PACOTE ) References CONVENIO_PACOTE_AUTOR (NR_SEQUENCIA) on delete cascade)');

	CALL exec_sql_dinamico('lhalves', 'Alter Table CONVENIO_PACOTE_AUTOR_MAT drop constraint CNVPCTMT_CNVPCTAT_FK');
	CALL exec_sql_dinamico('lhalves', 'Alter Table CONVENIO_PACOTE_AUTOR_MAT add (Constraint CNVPCTMT_CNVPCTAT_FK Foreign Key (NR_SEQ_PACOTE) References CONVENIO_PACOTE_AUTOR (NR_SEQUENCIA) on delete cascade)');

end if;


if (dt_versao_atual_cliente_w < to_date('08/10/2015','dd/mm/yyyy')) then

	CALL Baca_Criar_Ind_Autor_Exame_Lab();

end if;


if (dt_versao_atual_cliente_w < to_date('05/11/2015','dd/mm/yyyy')) then

	 select count(*)
	 into STRICT	qt_registro_w
	 from 	PROTOCOLO_CONVENIO_INTEGR a
	 where 	not exists ( 	SELECT 1
				from PROTOCOLO_CONVENIO b
				where 1 = 1
				and a.NR_SEQ_PROTOCOLO = b.NR_SEQ_PROTOCOLO)
	 and 	(a.NR_SEQ_PROTOCOLO IS NOT NULL AND a.NR_SEQ_PROTOCOLO::text <> '');

	 if (qt_registro_w > 0) then

		CALL exec_sql_dinamico('ralves', 'delete from PROTOCOLO_CONVENIO_INTEGR a where not exists ( select 1 from PROTOCOLO_CONVENIO b where 1 = 1 and a.NR_SEQ_PROTOCOLO = b.NR_SEQ_PROTOCOLO) and a.NR_SEQ_PROTOCOLO is not null');

	 end if;

	CALL exec_sql_dinamico('ralves', 'Alter Table PROTOCOLO_CONVENIO_INTEGR drop constraint PRCOINT_PROCONA_FK');
	CALL exec_sql_dinamico('ralves', 'Alter Table PROTOCOLO_CONVENIO_INTEGR add (Constraint PRCOINT_PROCONA_FK Foreign Key (NR_SEQ_PROTOCOLO) References PROTOCOLO_CONVENIO (NR_SEQ_PROTOCOLO) on delete cascade)');

end if;

if (dt_versao_atual_cliente_w < to_date('20/01/2016','dd/mm/yyyy')) then

	CALL exec_sql_dinamico('ralves', 'UPDATE integridade_atributo set nm_atributo = ''CD_MATERIAL_ESTOQUE'' WHERE nm_tabela = ''REGRA_CONVENIO_PLANO_MAT'' AND nm_atributo = ''CD_MATERIAL'' AND nm_integridade_referencial = ''RECOMAT_MATEST_FK'' ');
	CALL exec_sql_dinamico('ralves', 'update	indice_atributo set nm_atributo	= ''CD_MATERIAL_ESTOQUE'' where	NM_TABELA = ''REGRA_CONVENIO_PLANO_MAT'' and nm_atributo = ''CD_MATERIAL'' and	NM_INDICE = ''RECOMAT_MATEST_FK_I'' ');

	CALL exec_sql_dinamico('ralves', 'Alter Table REGRA_CONVENIO_PLANO_MAT add (Constraint RECOMAT_MATEST_FK Foreign Key (CD_MATERIAL_ESTOQUE) References MATERIAL (CD_MATERIAL))');
	CALL exec_sql_dinamico('ralves', 'Create Index RECOMAT_MATEST_FK_I on REGRA_CONVENIO_PLANO_MAT(CD_MATERIAL_ESTOQUE)');


end if;



commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tasy_ajustar_base_fatenv ( nm_usuario_p text) FROM PUBLIC;
