-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_conta_proc ( nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_prestador_p pls_prestador.nr_sequencia%type, nr_seq_segurado_p pls_segurado.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_prestador_prot_p pls_prestador.nr_sequencia%type, ie_situacao_protocolo_p INOUT text, cd_versao_tiss_p text) AS $body$
DECLARE


_ora2pg_r RECORD;
nr_seq_proc_w			bigint;
cd_procedimento_imp_w		bigint;
dt_fim_proc_imp_w		timestamp;
dt_inicio_proc_imp_w		timestamp;
dt_procedimento_imp_w		timestamp;
ie_via_acesso_imp_w		varchar(2);
ie_tipo_despesa_imp_w		varchar(2);
dados_tipo_conv_tiss_w		pls_cta_valorizacao_pck.dados_tipo_conv_tiss;
cd_tipo_tabela_imp_xml_w	varchar(10);
ds_procedimento_imp_w		varchar(255);
ie_origem_proced_w		bigint;
cd_proc_existente_w		bigint;
tx_item_w			double precision;
nr_seq_proc_partic_w		bigint;
cd_medico_imp_w			varchar(10);
nr_cpf_imp_w			varchar(11);
ie_funcao_medico_imp_w		varchar(3);
cd_cbo_saude_imp_w		varchar(10);
nr_crm_imp_w			varchar(30);
uf_crm_imp_w			pls_proc_participante.uf_crm_imp%type;
nm_medico_executor_imp_w	varchar(255);
ie_situacao_protocolo_w		varchar(3)	:= 'A';
cd_medico_partic_w		varchar(10);
nr_seq_cbo_saude_w		bigint;
nr_seq_funcao_partic_w		bigint;
qt_registros_w			bigint;
ie_tipo_guia_w			varchar(2);
sg_conselho_imp_w		varchar(20);
ie_tipo_segurado_w		varchar(3);
ie_autorizado_w			varchar(1);
ie_liberar_item_autor_w		varchar(1);
ie_existe_regra_w		varchar(1);
nr_seq_guia_w			bigint;
cd_guia_w			varchar(20);
qt_utilizada_w			pls_guia_plano_proc.qt_solicitada%type;
qt_autorizada_w			pls_guia_plano_proc.qt_solicitada%type;
qt_conta_proc_w			bigint;
nr_seq_regra_conversao_w	bigint;
cd_prestador_imp_w		varchar(30);
ie_nascido_plano_w		varchar(10);
nr_seq_motivo_glosa_w		bigint;
ie_utilizado_conta_w		varchar(1);
ds_contas_autor_w		varchar(255);
qt_proc_conta_w			bigint;
qt_procedimento_imp_w		pls_conta_proc.qt_procedimento%type;
ds_observacao_ww		varchar(4000);
ie_medico_complementar_w 	varchar(2);
ie_utiliza_codigo_w		varchar(2);
cd_medico_executor_imp_w	varchar(20);
nr_seq_pacote_aut_w		bigint;
nr_seq_regra_preco_pac_w	bigint;
nr_seq_pacote_w			bigint;
ie_regra_preco_w		varchar(3);
qt_idade_segurado_w		bigint;
ie_via_acesso_regra_w		varchar(1);
ie_proc_ativo_w			varchar(1);
ie_carencia_abrangencia_ant_w	varchar(10);
nr_seq_conselho_w		bigint;
vl_procedimento_imp_w		double precision;
vl_unitario_imp_w		double precision;
ds_justificativa_w		varchar(500);
cd_proced_orig_w		bigint;
ie_origem_proc_orig_w		bigint;
qt_saldo_w					pls_conta_proc.qt_procedimento%type;
qt_conta_dif_w			integer;
ie_somente_codigo_w		pls_conversao_proc.ie_somente_codigo%type;
cd_grau_partic_imp_w		pls_proc_participante.cd_grau_partic_imp%type;
cd_grau_partic_w		pls_proc_participante.cd_grau_partic_imp%type;
ie_tecnica_utilizada_imp_w	pls_conta_proc.ie_tecnica_utilizada_imp%type;
ie_tecnica_utilizada_w		pls_conta_proc.ie_tecnica_utilizada%type;
sg_tiss_conselho_prof_w		tiss_conselho_profissional.sg_conselho%type;
ie_tipo_tabela_tiss_w		pls_procedimento_vigencia.ie_tipo_tabela%type;
cd_dente_imp_w			pls_conta_proc.cd_dente_imp%type;
cd_regiao_boca_imp_w		pls_conta_proc.cd_regiao_boca_imp%type;
cd_face_dente_imp_w		pls_conta_proc.cd_face_dente_imp%type;
qt_glosa_w			bigint := 0;
ie_segmentacao_w		pls_plano.ie_segmentacao%type;
nr_seq_regra_autor_w		pls_regra_autorizacao.nr_sequencia%type;
nr_seq_tipo_atendimento_w	pls_conta.nr_seq_tipo_atendimento%type;

C01 CURSOR FOR
	SELECT	nr_sequencia,
		cd_procedimento_imp,
		dt_fim_proc_imp,
		dt_inicio_proc_imp,
		dt_procedimento_imp,
		ie_via_acesso_imp,
		coalesce(ie_tipo_despesa_imp,'0'),
		cd_tipo_tabela_imp,
		ds_procedimento_imp,
		qt_procedimento_imp,
		vl_procedimento_imp,
		vl_unitario_imp,
		ds_justificativa,
		ds_procedimento_imp,
		ie_tecnica_utilizada_imp,
		cd_dente_imp,
		cd_regiao_boca_imp,
		cd_face_dente_imp
	from	pls_conta_proc
	where	nr_seq_conta	= nr_seq_conta_p;

C02 CURSOR FOR
	SELECT	nr_sequencia,
		cd_medico_imp,
		nr_cpf_imp,
		ie_funcao_medico_imp,
		cd_cbo_saude_imp,
		nr_crm_imp,
		uf_crm_imp,
		nm_medico_executor_imp,
		sg_conselho_imp,
		cd_prestador_imp,
		cd_grau_partic_imp,
		pls_obter_seq_saude(cd_cbo_saude_imp)
	from	pls_proc_participante
	where	nr_seq_conta_proc = nr_seq_proc_w;


BEGIN

select 	max(ie_segmentacao)
into STRICT	ie_segmentacao_w
from	pls_segurado a,
	pls_plano b
where	a.nr_seq_plano = b.nr_sequencia
and	a.nr_sequencia = nr_seq_segurado_p;

select	coalesce(ie_tipo_guia,0),
	ie_tipo_segurado,
	coalesce(cd_guia,cd_guia_imp),
	nr_seq_guia,
	nr_seq_tipo_atendimento
into STRICT	ie_tipo_guia_w,
	ie_tipo_segurado_w,
	cd_guia_w,
	nr_seq_guia_w,
	nr_seq_tipo_atendimento_w
from	pls_conta
where	nr_sequencia	= nr_seq_conta_p;

select	coalesce(max(ie_via_acesso_regra),'N'),
	coalesce(max(ie_carencia_abrangencia_ant),'N')
into STRICT	ie_via_acesso_regra_w,
	ie_carencia_abrangencia_ant_w
from	pls_parametros
where	cd_estabelecimento = cd_estabelecimento_p;

--begin
open C01;
loop
fetch C01 into
	nr_seq_proc_w,
	cd_procedimento_imp_w,
	dt_fim_proc_imp_w,
	dt_inicio_proc_imp_w,
	dt_procedimento_imp_w,
	ie_via_acesso_imp_w,
	ie_tipo_despesa_imp_w,
	dados_tipo_conv_tiss_w.ie_tipo_tabela,
	ds_procedimento_imp_w,
	qt_procedimento_imp_w,
	vl_procedimento_imp_w,
	vl_unitario_imp_w,
	ds_justificativa_w,
	ds_procedimento_imp_w,
	ie_tecnica_utilizada_imp_w,
	cd_dente_imp_w,
	cd_regiao_boca_imp_w,
	cd_face_dente_imp_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	/* ST_TABELA
	<enumeration value="05"/><!-- 05 Tabela Brasindice -->
	<enumeration value="12"/><!-- 12 Tabela SIMPRO -->
	<enumeration value="13"/><!-- 13 Tabela TUNEP -->
	<enumeration value="14"/><!-- 14 Tabela VRPO -->
	<enumeration value="15"/><!-- 15 Tabela de Intercambio Sistema Uniodonto -->
	<enumeration value="16"/><!-- 16 TUSS _ Procedimentos Medicos -->
	<enumeration value="17"/><!-- 17 TUSS _ Procedimentos Odontologicos -->
	<enumeration value="18"/><!-- 18 TUSS _ Taxas hospitalares -->
	<enumeration value="19"/><!-- 19 TUSS _ Materiais -->
	<enumeration value="20"/><!-- 20 TUSS - Medicamentos -->
	<enumeration value="21"/><!-- 21 TUSS _ Outras areas da saude -->
	<enumeration value="89"/><!-- 89 Tabela Propria Procedimentos nao medicos -->
	<enumeration value="90"/><!-- 90 Tabela Propria Pacote Odontologico -->
	<enumeration value="95"/><!-- 95 Tabela Propria Materiais -->
	<enumeration value="96"/><!-- 96 Tabela Propria Medicamentos -->
	<enumeration value="97"/><!-- 97 Tabela Propria de Taxas Hospitalares -->
	<enumeration value="98"/><!-- 98 Tabela Propria de Pacotes -->
	<enumeration value="99"/><!-- 99 Tabela Propria de Gases Medicinais -->
	<enumeration value="00"/><!-- 00 Outras Tabelas -->

	01 - Tabela AMB-90 (INATIVA)
	02 - Tabela AMB 92 (INATIVA)
	03 - Tabela AMB 96 (INATIVA)
	04 - Tabela AMB 99 (INATIVA)
	05 - Tabela Brasindice
	06 - Classificacao Brasileira Hierarquizada de Procedimentos Medicos
	07 - Tabela CIEFAS 93
	08 - Tabela CIEFAS 2000
	09 - Rol de procedimentos ANS
	10 - Tabela de procedimentos ambulatoriais SUS
	11 - Tabela de procedimentos hospitalares SUS
	12 - Tabela SIMPRO
	13 - Tabela TUNEP
	14 - Tabela VRPO
	15 - Tabela de Intercambio Sistema Uniodonto
	16 - TUSS - Procedimentos Medicos
	17 - TUSS - Procedimentos Odontologicos
	18 - TUSS - Taxas Hospitalares
	19 - TUSS - Materiais
	20 - TUSS - Medicamentos
	21 - TUSS - Outras especialidades
	91 - Tabela provisoria TUSS
	92 - Tabela provisoria TUSS - Procedimentos Odontologicos
	93 - Tabela provisoria TUSS - Procedimentos Medicos
	94 - Tabela propria procedimento (INATIVA)
	95 - Tabela propria materiais
	96 - Tabela propria medicamentos
	97 - Tabela propria taxas hospitalares
	98 - Tabela propria pacotes
	99 - Tabela propria gases medicinais
	00 - Outras tabelas (*/

	/*Tabela 00 ativada em 15/08/2012, conforme tratado com Paulo no otimo boletim da ANS, a tabela voltou a ser utilizada  Diogo*/


	/*
	1 - AMB '01','02','03','04','07','08'
	5 - CBHPM '06'
	7 - SUS_2008 '10','11'
	8 - TUSS '16'
	4 - PROPRIO '94','95','96','97','98','99'
	M - BRASINDICE '05'
	M - SIMPRO '12'

	"09" "13" "14" "15" "00"
	*/
	
	ds_observacao_ww := null;
	if ( cd_versao_tiss_p >= '3.01.00' ) then		
		--18, 22 TUSS, 

		--90, 98, 99 PROPRIO
		if (dados_tipo_conv_tiss_w.ie_tipo_tabela not in ('18','22','90','98','99', '00')) then
			ds_observacao_ww	:= 'Codigo da tabela enviada nao e compativel com a versao TISS '||cd_versao_tiss_p||'.';
		end if;
		
		if (coalesce(ie_tecnica_utilizada_imp_w,0) > 0) then
			if (ie_tecnica_utilizada_imp_w = 1) then
				ie_tecnica_utilizada_w := 'C';
			elsif (ie_tecnica_utilizada_imp_w = 2) then
				ie_tecnica_utilizada_w := 'V';
			elsif (ie_tecnica_utilizada_imp_w = 3) then
				ie_tecnica_utilizada_w := 'R';
			end if;
		end if;
	end if;
	
	if (coalesce(ds_observacao_ww::text, '') = '')then
		/* Felipe - OS 262692 - OPS - Cadastro de Regras / Contas medicas / Conversao tabela TISS */

		cd_tipo_tabela_imp_xml_w:= dados_tipo_conv_tiss_w.ie_tipo_tabela;
		dados_tipo_conv_tiss_w	:= pls_obter_conversao_tab_tiss(dados_tipo_conv_tiss_w.ie_tipo_tabela, cd_estabelecimento_p, cd_procedimento_imp_w, '', 'C', nr_seq_prestador_p, ie_tipo_despesa_imp_w);
		
		if (dados_tipo_conv_tiss_w.ie_tipo_tabela in ('01','02','03','04','07','08')) then
			ie_origem_proced_w	:= 1; /* AMB */
		elsif (dados_tipo_conv_tiss_w.ie_tipo_tabela = '06') then
			ie_origem_proced_w	:= 5; /* CBHPM */
		elsif (dados_tipo_conv_tiss_w.ie_tipo_tabela in ('10', '11')) then
			ie_origem_proced_w	:= 7; /* SUS_2008 */
		elsif (dados_tipo_conv_tiss_w.ie_tipo_tabela in ('16', '18', '22')) then
			ie_origem_proced_w	:= 8; /* TUSS */
		elsif (dados_tipo_conv_tiss_w.ie_tipo_tabela in ('94','95','96','97','98','99','00')) then
			ie_origem_proced_w	:= 4; /* PROPRIO */
		elsif (dados_tipo_conv_tiss_w.ie_tipo_tabela <> '00') then /*Problemas na tabela informada*/
			ds_observacao_ww	:= 'Codigo da tabela enviada nao e reconhecido.';
		end if;
		
		if (ie_tipo_despesa_imp_w = '0') then
			select 	coalesce(max(ie_classificacao),1)
			into STRICT	ie_tipo_despesa_imp_w
			from	procedimento
			where	cd_procedimento		= cd_procedimento_imp_w
			and	ie_origem_proced	= ie_origem_proced_w;
		else
			/* Eder - Conversao do tipo de despesa no TISS 3.01.00 - OS 677226 */

			if ( cd_versao_tiss_p >= '3.01.00' ) then
				if (ie_tipo_despesa_imp_w = '8') then  /* OPME */
					ie_tipo_despesa_imp_w := '7'; /* OPME */
				elsif (ie_tipo_despesa_imp_w = '7') then /* Taxas e alugueis */
					ie_tipo_despesa_imp_w := '4'; /* Taxas diversas */
				end if;
			end if;
		end if;

		/* ST_OUTRASDESPESAS - dom 1835 Prestador
			1 - Gases Medicinais
			2 - Medicamentos
			3 - Materiais
			4 - Taxas Diversas
			5 - Diarias
			6 - Aluguel
		OPS - (1,2,3,4)(Procedimentos,Taxas,Diarias,Pacotes) */
		select	max(nr_sequencia)
		into STRICT	nr_seq_pacote_w
		from	pls_pacote
		where	cd_procedimento		= cd_procedimento_imp_w
		and	coalesce(ie_situacao,'I')	= 'A';

		/* Francisco - 16/05/2012 - OS 447352 */

		if (nr_seq_pacote_w IS NOT NULL AND nr_seq_pacote_w::text <> '') then
			select	coalesce(ie_regra_preco,'N')
			into STRICT	ie_regra_preco_w
			from	pls_pacote a
			where	a.nr_sequencia	= nr_seq_pacote_w;

			if (ie_regra_preco_w = 'S') then
				SELECT * FROM pls_obter_regra_preco_pacote(cd_procedimento_imp_w, ie_origem_proced_w, 'C', nr_seq_proc_w, nm_usuario_p, nr_seq_pacote_w, nr_seq_regra_preco_pac_w) INTO STRICT nr_seq_pacote_w, nr_seq_regra_preco_pac_w;
			end if;
		end if;


		if (nr_seq_pacote_w IS NOT NULL AND nr_seq_pacote_w::text <> '') then
			ie_tipo_despesa_imp_w	:= '4';
		elsif (ie_tipo_despesa_imp_w in ('4','6')) then
			ie_tipo_despesa_imp_w	:= '2';
		elsif (ie_tipo_despesa_imp_w	= '5') then
			ie_tipo_despesa_imp_w	:= '3';
		else
			ie_tipo_despesa_imp_w	:= '1';
		end if;
		
		cd_proced_orig_w	:= cd_procedimento_imp_w;
		
		ie_origem_proc_orig_w	:= ie_origem_proced_w;
		/* Tratar a conversao de procedimentos TUSS - OPS - Cadastro de Regras / Procedimentos TUSS */

		if (ie_origem_proced_w	= 8) then
			SELECT * FROM pls_converte_codigo_tuss(cd_procedimento_imp_w, ie_origem_proced_w, cd_procedimento_imp_w, ie_origem_proced_w) INTO STRICT cd_procedimento_imp_w, ie_origem_proced_w;
		end if;
						
		if (cd_proced_orig_w = cd_procedimento_imp_w) and
			((ie_origem_proc_orig_w = ie_origem_proced_w )or (coalesce(ie_origem_proced_w::text, '') = '')) then
			
			SELECT * FROM pls_obter_proced_conversao(	cd_procedimento_imp_w, ie_origem_proced_w, nr_seq_prestador_p, cd_estabelecimento_p, 2, null, null, 'R', null, null, null, null, null, cd_procedimento_imp_w, ie_origem_proced_w, nr_seq_regra_conversao_w, ie_somente_codigo_w, clock_timestamp(), nr_seq_tipo_atendimento_w, null, null) INTO STRICT cd_procedimento_imp_w, ie_origem_proced_w, nr_seq_regra_conversao_w, ie_somente_codigo_w;
		end if;
		
		if (coalesce(nr_seq_pacote_w::text, '') = '') or (ie_origem_proced_w = 8) then
			select	coalesce(max(cd_procedimento),0)
			into STRICT	cd_proc_existente_w
			from	procedimento
			where	cd_procedimento		= cd_procedimento_imp_w
			and	ie_origem_proced	= ie_origem_proced_w;
		else
			select	max(ie_origem_proced)
			into STRICT	ie_origem_proced_w
			from	pls_pacote
			where	cd_procedimento		= cd_procedimento_imp_w
			and	coalesce(ie_situacao,'I')	= 'A';
			cd_proc_existente_w	:= cd_procedimento_imp_w;
		end if;
		/* se nao achar procedimento, procurar na amb */

		if	((cd_proc_existente_w	= 0) 			and (coalesce(ie_tipo_despesa_imp_w,'2') in ('2','3'))) 	or
			(dados_tipo_conv_tiss_w.ie_tipo_tabela = '00' AND cd_proc_existente_w = 0)			then

			select	coalesce(max(cd_procedimento),0)
			into STRICT	cd_proc_existente_w
			from	procedimento
			where	cd_procedimento		= cd_procedimento_imp_w
			and	ie_origem_proced	= 1
			and	ie_situacao		= 'A';

			ie_origem_proced_w		:= 1;
		end if;

		if (ie_tipo_guia_w = '6') then
			CALL pls_tiss_consistir_honorario(nr_seq_proc_w, 'CP', 'IA',
				null, null, '',
				nm_usuario_p, cd_estabelecimento_p, ie_origem_proced_w);
		end if;
	

		if (ie_tipo_despesa_imp_w = '2') then
			CALL pls_tiss_consistir_taxa(nr_seq_proc_w, 'CP', 'IA',
				null, null, '',
				nm_usuario_p, cd_estabelecimento_p, ie_origem_proced_w);
		end if;
		
		/*pls_tiss_consistir_autorizacao(nr_seq_proc_w, 'CP', 'IA',  nr_seq_prestador_p, null, '',
						nm_usuario_p, cd_estabelecimento_p, ie_origem_proced_w);
			esta chamado foi movida para depois do update da conta_proc, pois haviam casos de conversao de codigo de procedimento, e a mesma nao ocorreria de maneira correta gerando aglosa 1402 na conta
		*/
				

		if (ie_tipo_despesa_imp_w = '1') then
			CALL pls_tiss_consistir_proc(nr_seq_proc_w, 'CP', 'IA', null, null, '',
						nm_usuario_p, cd_estabelecimento_p, ie_origem_proced_w);
		end if;

		if ( cd_proc_existente_w	> 0) then
			ie_liberar_item_autor_w	:= 'N';
			ie_autorizado_w		:= 'N';

			/* Verificar se o procedimento importado e um procedimento de pacote */

			select	max(nr_sequencia)
			into STRICT	nr_seq_pacote_aut_w
			from	pls_pacote
			where	cd_procedimento		= cd_procedimento_imp_w
			and	ie_origem_proced	= ie_origem_proced_w
			and	coalesce(nr_seq_prestador,nr_seq_prestador_p)	= nr_seq_prestador_p
			and	coalesce(ie_situacao,'A')	= 'A';

			/* Francisco - 16/05/2012 - OS 447352 */

			if (nr_seq_pacote_w IS NOT NULL AND nr_seq_pacote_w::text <> '') then
				select	coalesce(ie_regra_preco,'N')
				into STRICT	ie_regra_preco_w
				from	pls_pacote a
				where	a.nr_sequencia	= nr_seq_pacote_w;

				if (ie_regra_preco_w = 'S') then
					SELECT * FROM pls_obter_regra_preco_pacote(cd_procedimento_imp_w, ie_origem_proced_w, 'C', nr_seq_proc_w, nm_usuario_p, nr_seq_pacote_w, nr_seq_regra_preco_pac_w) INTO STRICT nr_seq_pacote_w, nr_seq_regra_preco_pac_w;
				end if;
			end if;

			if (nr_seq_pacote_aut_w IS NOT NULL AND nr_seq_pacote_aut_w::text <> '') then
				ie_tipo_despesa_imp_w	:= '4'; /* Pacote */
			end if;

			tx_item_w	:= 100;
			
			if (ie_via_acesso_imp_w	= '1') then
				ie_via_acesso_imp_w	:= 'U';
			elsif (ie_via_acesso_imp_w	= '2') then
				ie_via_acesso_imp_w	:= 'M';
			elsif (ie_via_acesso_imp_w	= '3') then
				ie_via_acesso_imp_w	:= 'D';
			end if;
			
			if (ie_via_acesso_regra_w = 'N') then
				if (ie_via_acesso_imp_w = 'D') then
					tx_item_w	:= 70;
				elsif (ie_via_acesso_imp_w = 'M') then
					tx_item_w	:= 50;
				end if;
			else
				ie_via_acesso_imp_w	:= null;
			end if;

			begin
			update	pls_conta_proc
			set	cd_procedimento		= cd_procedimento_imp_w,
				ie_origem_proced	= ie_origem_proced_w,
				dt_fim_proc		= dt_fim_proc_imp_w,
				dt_inicio_proc		= dt_inicio_proc_imp_w,
				dt_procedimento		= dt_procedimento_imp_w,
				ie_tipo_despesa		= ie_tipo_despesa_imp_w,
				ie_via_acesso		= ie_via_acesso_imp_w,
				tx_item			= tx_item_w,
				qt_procedimento		= 0,
				vl_procedimento		= 0,
				vl_unitario		= 0,
				vl_liberado		= 0,
				nm_usuario		= nm_usuario_p,
				ds_log			= 'pls_gerar_conta',
				ie_valor_informado	= 'N',
				cd_tipo_tabela_imp	= cd_tipo_tabela_imp_xml_w,
				cd_tipo_tabela		= dados_tipo_conv_tiss_w.ie_tipo_tabela,
				ie_status		= 'C',
				ie_tecnica_utilizada	= ie_tecnica_utilizada_w,
				cd_dente		= cd_dente_imp_w,
				cd_regiao_boca		= cd_regiao_boca_imp_w
			where	nr_sequencia		= nr_seq_proc_w;
			exception
			when others then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(174835,'CD_PROCEDIMENTO_IMP=' ||cd_procedimento_imp_w|| ';' ||
									'IE_ORIGEM_PROCED=' ||ie_origem_proced_w || ';' ||
									'NR_SEQ_PROC=' ||nr_seq_proc_w);
			end;
			
			CALL pls_tiss_consistir_autorizacao(nr_seq_proc_w, 'CP', 'IA',  nr_seq_prestador_p, null, '',
				nm_usuario_p, cd_estabelecimento_p, ie_origem_proced_w);
			
			/* Gerar as faces de odonto */

			CALL pls_gerar_conta_proc_face(nr_seq_proc_w,cd_face_dente_imp_w,nm_usuario_p);

			/*Consistencia do procedimento liberado para o prestador */

			CALL pls_consistir_proc_prestador(nr_seq_prestador_prot_p, nr_seq_proc_w, null, null, null, cd_estabelecimento_p, nm_usuario_p,'IA');

			ie_proc_ativo_w	:= pls_obter_se_proc_ativo(cd_procedimento_imp_w, ie_origem_proced_w, dt_procedimento_imp_w);


			if (ie_proc_ativo_w = 'N') then
				CALL pls_gravar_conta_glosa('9920', nr_seq_conta_p, nr_seq_proc_w, null, 'N', 'O procedimento nao esta ativo.', nm_usuario_p, 'A', 'IA',
							nr_seq_prestador_p, cd_estabelecimento_p, '', null);
			elsif (ie_proc_ativo_w = 'D') then
				CALL pls_gravar_conta_glosa('9920', nr_seq_conta_p, nr_seq_proc_w, null, 'N', 'O procedimento esta fora da data de vigencia.', nm_usuario_p, 'A', 'IA',
							nr_seq_prestador_p, cd_estabelecimento_p, '', null);
			end if;
			
			select	max(a.ie_tipo_tabela)
			into STRICT	ie_tipo_tabela_tiss_w
			from	pls_procedimento_vigencia	a
			where	a.cd_procedimento	= cd_procedimento_imp_w
			and	a.ie_origem_proced	= ie_origem_proced_w
			and	dt_procedimento_imp_w between a.dt_inicio_vigencia and fim_dia(a.dt_fim_vigencia);
			
			if (ie_tipo_tabela_tiss_w IS NOT NULL AND ie_tipo_tabela_tiss_w::text <> '') then
				if (cd_tipo_tabela_imp_xml_w != ie_tipo_tabela_tiss_w) then
					ds_observacao_ww	:= 'Codigo da tabela enviada nao e permitido para o procedimento apresentado.';
				end if;
			end if;
		else/*Quando nao consegue identificar o procedimento*/

			/*Conforme visto com Adriano Geyer e Paulo Rosa deve sempre gerar glosa quando nao houver registro do proc na base OS 533430 - Demitrius*/


			--if	(ie_tipo_despesa_imp_w <> '2') then
				if (coalesce(ds_observacao_ww,'~c*') = '~c*') then
					ds_observacao_ww	:= 'Nao foi possivel localizar o procedimento nos registros.';
				end if;

		end if;
	end if;

	if (ds_observacao_ww IS NOT NULL AND ds_observacao_ww::text <> '') then
		CALL pls_gravar_conta_glosa('1801',nr_seq_conta_p, nr_seq_proc_w,
					null, 'N',ds_observacao_ww, --'Procedimento: '||ds_procedimento_imp_w
					nm_usuario_p, 'A', 'IA',
					nr_seq_prestador_p, cd_estabelecimento_p, '', null);
			
		ie_situacao_protocolo_w	:= 'RE';
	end if;
	
	/*Diego OS 337435 - Modificada a posicao da consitencia para que seja possivel utilizar a function pls_obter_se_proc_tipo_guia.*/

	CALL pls_tiss_consistir_guia(nr_seq_proc_w, 'CP', 'IA',  null, null, '',
				nm_usuario_p, cd_estabelecimento_p);

	CALL pls_consistir_elegibilidade(nr_seq_segurado_p, 'IA', nr_seq_proc_w,
					'CP', nr_seq_prestador_p, null,
					'', nm_usuario_p, cd_estabelecimento_p);
	
	qt_glosa_w := pls_consistir_cobertura_proc(nr_seq_segurado_p, null, nr_seq_proc_w, null, cd_procedimento_imp_w, ie_origem_proced_w, dt_procedimento_imp_w, ie_segmentacao_w, cd_estabelecimento_p, null, nm_usuario_p, qt_glosa_w, 'C');

	/* No manual de estrutura TISS tem a tabela de Conselho profissional que consta no dominio 2784 no Tasy*/

	select	max(vl_dominio)
	into STRICT	sg_conselho_imp_w
	from	valor_dominio_v
	where	vl_dominio	= sg_conselho_imp_w
	and	cd_dominio	= 2784;

	select 	coalesce(b.cd_medico_executor_imp,'0')
	into STRICT	cd_medico_executor_imp_w
	from	pls_conta	b,
		pls_conta_proc	a
	where	b.nr_sequencia	= a.nr_seq_conta
	and	a.nr_sequencia	= nr_seq_proc_w;

	if (coalesce(cd_medico_executor_imp_w,'0') = '0') then
		select 	coalesce(b.cd_medico_executor,'0')
		into STRICT	cd_medico_executor_imp_w
		from	pls_conta	b,
			pls_conta_proc	a
		where	b.nr_sequencia	= a.nr_seq_conta
		and	a.nr_sequencia	= nr_seq_proc_w;
	end if;

	begin
	select 	coalesce(ie_medico_complementar,'N'),
		coalesce(ie_codigo_prest_operadora,'S')
	into STRICT	ie_medico_complementar_w,
		ie_utiliza_codigo_w
	from 	pls_param_importacao_conta
	where	cd_estabelecimento	= cd_estabelecimento_p;
	exception
	when others then
		ie_medico_complementar_w 	 := 'N';
		ie_utiliza_codigo_w		 := 'S';
	end;

	/* Francisco 10/05/2012 - Antes excluia os participantes, deve apenas deixar o calculo zerado quando ocorrer esta situacao
	e somente para o participante que seja igual ao medico executor da conta */
	open C02;
	loop
	fetch C02 into
		nr_seq_proc_partic_w,
		cd_medico_imp_w,
		nr_cpf_imp_w,
		ie_funcao_medico_imp_w,
		cd_cbo_saude_imp_w,
		nr_crm_imp_w,
		uf_crm_imp_w,
		nm_medico_executor_imp_w,
		sg_conselho_imp_w,
		cd_prestador_imp_w,
		cd_grau_partic_imp_w,
		nr_seq_cbo_saude_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */

		cd_medico_partic_w := null;
		SELECT * FROM pls_valida_medico_importacao(null, 'ME', nr_seq_proc_partic_w, nr_seq_prestador_p, null, cd_estabelecimento_p, nm_usuario_p, cd_medico_partic_w, nr_crm_imp_w) INTO STRICT _ora2pg_r;
 cd_medico_partic_w := _ora2pg_r.cd_medico_p; nr_crm_imp_w := _ora2pg_r.cd_crm_p;

		if (cd_versao_tiss_p >= '3.01.00') then

			cd_grau_partic_w := cd_grau_partic_imp_w;
		else
			cd_grau_partic_w := ie_funcao_medico_imp_w;
		end if;

		select	max(nr_sequencia)
		into STRICT	nr_seq_funcao_partic_w
		from	pls_grau_participacao
		where	cd_tiss			= cd_grau_partic_w
		and	cd_estabelecimento	= cd_estabelecimento_p
		and	coalesce(ie_situacao,'A')	= 'A';

		if (cd_versao_tiss_p >= '3.01.00') then

			uf_crm_imp_w	:= pls_obter_sg_uf_tiss(uf_crm_imp_w);

			select 	max(sg_conselho)
			into STRICT 	sg_tiss_conselho_prof_w
			from 	tiss_conselho_profissional
			where 	cd_conselho = sg_conselho_imp_w;

			nr_seq_conselho_w	:= pls_obter_seq_conselho(sg_tiss_conselho_prof_w);
		else
			nr_seq_conselho_w	:= pls_obter_seq_conselho(sg_conselho_imp_w);
		end if;
		
		if (cd_medico_partic_w IS NOT NULL AND cd_medico_partic_w::text <> '') then
			if (coalesce(nm_medico_executor_imp_w::text, '') = '') then
				nm_medico_executor_imp_w := substr(obter_dados_medico(cd_medico_partic_w, 'NM'),1,255);
			end if;	
			
			if (coalesce(nr_seq_conselho_w::text, '') = '') then
				nr_seq_conselho_w := pls_obter_seq_conselho_prof(cd_medico_partic_w);
			end if;
			
			if (coalesce(uf_crm_imp_w::text, '') = '') then
				uf_crm_imp_w := obter_dados_medico(cd_medico_partic_w, 'UFCRM');
			end if;
		end if;
		
		update	pls_proc_participante
		set	cd_medico		= cd_medico_partic_w,
			cd_medico_imp		= cd_medico_partic_w,
			nm_medico_executor_imp	= nm_medico_executor_imp_w,
			nr_seq_grau_partic	= nr_seq_funcao_partic_w,
			nr_seq_cbo_saude	= nr_seq_cbo_saude_w,
			nr_seq_conselho		= nr_seq_conselho_w,
			uf_conselho		= uf_crm_imp_w,
			ie_status		= 'U',
			cd_cbo_saude_imp	= cd_cbo_saude_imp_w
		where	nr_sequencia		= nr_seq_proc_partic_w;
	end loop;
	close C02;

	CALL pls_gerar_campo_esp(nr_seq_proc_w, null);
	/*Diego 04/05/2011 - OS 316163 -  Gerar ocorrencia nas contas de importacao*/


	/*Diego 12/08/2011 - OS 336471 -  A chamada da rotina pls_gerar_ocorrencia_conta_web para procedimento sera realziada junto a rotina principal (pls_gerar_conta)
	*/


	/*Diego OS - 338098-  Consistir carencia.*/

	ie_liberar_item_autor_w	:= 'N';

	SELECT * FROM pls_consiste_proced_autor(	nr_seq_conta_p, nr_seq_proc_w, nm_usuario_p, cd_estabelecimento_p, nr_seq_prestador_p, 'IA', null, ie_liberar_item_autor_w, ie_existe_regra_w, nr_seq_motivo_glosa_w, nr_seq_regra_autor_w) INTO STRICT ie_liberar_item_autor_w, ie_existe_regra_w, nr_seq_motivo_glosa_w, nr_seq_regra_autor_w;

	if (ie_tipo_despesa_imp_w <> '3') then /*Quando NAO for diarias*/
	
		select 	coalesce(max(qt_saldo),0),
			coalesce(max(qt_utilizada),0),
			coalesce(max(qt_autorizada),0)
		into STRICT	qt_saldo_w,
			qt_utilizada_w,
			qt_autorizada_w
		from 	table(pls_conta_autor_pck.obter_dados(	nr_seq_guia_w, 'P', cd_estabelecimento_p,
								ie_origem_proced_w, cd_procedimento_imp_w, null));
					
		/*verifica se o procedimento exige autorizacao*/

		if (coalesce(ie_liberar_item_autor_w,'N') = 'S') and (qt_saldo_w < 0 ) and (qt_utilizada_w > 0 ) then

			select	count(1)
			into STRICT	qt_conta_dif_w
			from	pls_conta_autor_utilizada_v
			where	nr_seq_guia		=  nr_seq_guia_w
			and	nr_seq_conta		!= nr_seq_conta_p
			and	cd_procedimento 	= cd_procedimento_imp_w
			and	ie_origem_proced	= ie_origem_proced_w;

			if ( qt_conta_dif_w = 0 )	then -- Se a nao em outras contas
				CALL pls_gravar_conta_glosa('1820',null, nr_seq_proc_w,
							null,'N',
							'[1] - A quantidade de procedimentos autorizados e ainda nao utilizados e menor que a quantidade apresentada de procedimentos da conta. Procedimentos da conta: ' || qt_procedimento_imp_w ||
							' / Procedimento autorizados restantes: ' || qt_saldo_w || '. Regra de autorizacao: ' || nr_seq_regra_autor_w,
							nm_usuario_p,'A','IA',
							nr_seq_prestador_p, cd_estabelecimento_p, '', null);
			else

				select substr(pls_admin_cursor.obter_desc_cursor(cursor(  	select	nr_seq_conta ds
								from	pls_conta_autor_utilizada_v
								where	nr_seq_guia	=  nr_seq_guia_w
								and	nr_seq_conta	!= nr_seq_conta_p
								and	cd_procedimento 	= cd_procedimento_imp_w
								and	ie_origem_proced	= ie_origem_proced_w), ', '),1,255) x
				into STRICT	ds_contas_autor_w
				;

				CALL pls_gravar_conta_glosa('1820',null, nr_seq_proc_w,
							null,'N', '[3] - Esta guia foi executada em outras contas ('|| ds_contas_autor_w ||') e possui saldo de '|| qt_saldo_w || '. Regra de autorizacao: ' || nr_seq_regra_autor_w,
							nm_usuario_p,'A','IA',
							nr_seq_prestador_p, cd_estabelecimento_p, '', null);
			end if;

		end if;
	/*TIPO DESPESA DIARIAS E GUIA INTERNACAO*/

	elsif (ie_tipo_despesa_imp_w	= '3') and	-- Quando for diarias e
		(ie_tipo_guia_w	= '5') then		-- Guia de Resumo de Internacao
		ie_utilizado_conta_w	:= 'N';

		select 	coalesce(max(qt_saldo),0),
			coalesce(max(qt_utilizada),0),
			coalesce(max(qt_autorizada),0)
		into STRICT	qt_saldo_w,
			qt_utilizada_w,
			qt_autorizada_w
		from 	table(pls_conta_autor_pck.obter_dados(	nr_seq_guia_w, 'D', cd_estabelecimento_p,
								ie_origem_proced_w, cd_procedimento_imp_w, null));

		if	(qt_saldo_w < 0  AND qt_utilizada_w > 0 ) or (qt_autorizada_w = 0) then

			select	count(1)
			into STRICT	qt_conta_dif_w
			from	pls_conta_autor_utilizada_v
			where	nr_seq_guia		=  nr_seq_guia_w
			and	nr_seq_conta		!= nr_seq_conta_p
			and	((cd_procedimento 	= cd_procedimento_imp_w) or (coalesce(cd_procedimento::text, '') = ''))
			and	((ie_origem_proced	= ie_origem_proced_w) or (coalesce(ie_origem_proced::text, '') = ''));

			if (coalesce(nr_seq_guia_w,0) = 0) then
				CALL pls_gravar_conta_glosa('1999',null,nr_seq_proc_w,
							null,'N', '[1] Diarias nao autorizadas, favor verificar se existem autorizacoes para as mesmas. ',
							nm_usuario_p,'A','IA',
							nr_seq_prestador_p, cd_estabelecimento_p, '', null);
			elsif (qt_conta_dif_w = 0) then
				CALL pls_gravar_conta_glosa('1999',null,nr_seq_proc_w,
							null,'N', '[1] Quantidade de diarias utilizadas excede a quantidade de dias autorizados. '||
							'Autorizada: '||qt_autorizada_w||' Utilizada: '||qt_utilizada_w ,
							nm_usuario_p,'A','IA',
							nr_seq_prestador_p, cd_estabelecimento_p, '', null);

			else
				select substr(pls_admin_cursor.obter_desc_cursor(cursor(  	select	nr_seq_conta ds
								from	pls_conta_autor_utilizada_v
								where	nr_seq_guia	=  nr_seq_guia_w
								and	nr_seq_conta	!= nr_seq_conta_p
								and	cd_procedimento 	= cd_procedimento_imp_w
								and	ie_origem_proced	= ie_origem_proced_w), ', '),1,255) x
				into STRICT	ds_contas_autor_w
				;

				CALL pls_gravar_conta_glosa('1999',null,nr_seq_proc_w,
							null,'N', '[3] Quantidade de diarias utilizadas excede a quantidade de dias autorizados. Esta guia foi executada em outras contas ('|| ds_contas_autor_w ||') e possui saldo de '|| qt_saldo_w||'. '||
							'Autorizada: '||qt_autorizada_w||' Utilizada: '||qt_utilizada_w,
							nm_usuario_p,'A','IA',
							nr_seq_prestador_p, cd_estabelecimento_p, '', null);
			end if;

		end if;
	end if;

	if (ie_tipo_despesa_imp_w = '1') then
		select	count(1)
		into STRICT	qt_proc_conta_w
		from	pls_guia_plano_proc
		where	nr_seq_guia		= nr_seq_guia_w
		and	cd_procedimento		= cd_procedimento_imp_w
		and	ie_origem_proced	= ie_origem_proced_w  LIMIT 1;

		/* Teste se nao exigiu autorizacao, ou se exigiu, mas a quantidade de procedimentos na conta e maior do que na guia */

		if 	(ie_liberar_item_autor_w = 'S' AND qt_saldo_w < 0) or
			(ie_liberar_item_autor_w = 'N' AND qt_proc_conta_w = 0) then
			ie_nascido_plano_w := pls_obter_segurado_nasc_plano(nr_seq_segurado_p, cd_estabelecimento_p, ie_nascido_plano_w, nm_usuario_p);

			if (coalesce(ie_nascido_plano_w,'N') = 'N') and (coalesce(nr_seq_segurado_p,0) > 0) then
				CALL pls_consistir_carencia_proc(	nr_seq_segurado_p, null, null,
								nr_seq_proc_w, null, cd_procedimento_imp_w,
								ie_origem_proced_w, dt_procedimento_imp_w, cd_estabelecimento_p,
								nm_usuario_p, 'S',ie_carencia_abrangencia_ant_w);
			end if;

			/*Verificacao da idade e sexo . Geracao das glosas 1803 e 1802.*/

			qt_idade_segurado_w	:= pls_obter_idade_segurado(nr_seq_segurado_p, coalesce(dt_procedimento_imp_w,clock_timestamp()), 'A');

			CALL pls_consistir_benef_proc(	nr_seq_segurado_p, null, nr_seq_proc_w,
							null, 'IA', nm_usuario_p,
							cd_estabelecimento_p,qt_idade_segurado_w);

		end if;

	end if;

	<<final>>
	null;
	end;
end loop;
close C01;

/* Consistencia dos procedimentos */


/*if	(ie_tipo_segurado_w	= 'B') then OS. 377014 retirado para que avalie as glosas do procedimento - dgkorz*/

CALL pls_consiste_procedimento(nr_seq_conta_p, 'IA', nm_usuario_p, cd_estabelecimento_p);


select	count(1)
into STRICT	qt_conta_proc_w
from	pls_conta_glosa		a,
	tiss_motivo_glosa	b
where	a.nr_seq_motivo_glosa	= b.nr_sequencia
and	a.nr_seq_conta_proc in (SELECT	nr_sequencia
				from	pls_conta_proc
				where	nr_seq_conta	= nr_seq_conta_p)  LIMIT 1;

qt_registros_w	:= qt_conta_proc_w;

if (qt_registros_w > 0) then
	ie_situacao_protocolo_w	:= 'RE';
end if;

ie_situacao_protocolo_p	:= ie_situacao_protocolo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_conta_proc ( nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_prestador_p pls_prestador.nr_sequencia%type, nr_seq_segurado_p pls_segurado.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_prestador_prot_p pls_prestador.nr_sequencia%type, ie_situacao_protocolo_p INOUT text, cd_versao_tiss_p text) FROM PUBLIC;

