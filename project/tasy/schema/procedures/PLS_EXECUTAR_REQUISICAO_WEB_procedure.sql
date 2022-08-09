-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_executar_requisicao_web ( nr_seq_requisicao_p bigint, nr_seq_segurado_p bigint, nr_seq_prestador_p bigint, nr_seq_item_p bigint, ie_tipo_item_p text, nm_usuario_p text, cd_estabelecimento_p bigint, ie_exec_intercambio_p text, ie_origem_exec_p text, nr_seq_maquina_p bigint, id_maquina_p text, nr_seq_usuario_web_p bigint, nr_seq_guia_p INOUT bigint, cd_guia_p INOUT text) AS $body$
DECLARE


/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:   Executar a requisicao para autorizacao 
----------------------------------------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[  ]  Objetos do dicionario [  ] Tasy (Delphi/Java) [ x ] Portal [  ] Relatorios [ ] Outros:
 ----------------------------------------------------------------------------------------------------------------------------------------------------

Pontos de atencao:  
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/				
				
nr_seq_item_w			bigint;
nr_seq_guia_w			bigint := 0;
cd_guia_w			varchar(30);
nr_seq_segurado_w 		bigint;
ie_estagio_w			smallint;
nr_seq_execucao_w		bigint;
nr_seq_usuario_web_w		bigint := null;
ie_transacao_w			varchar(3);
nm_cooperativa_w		varchar(255);
cd_cooperativa_w		varchar(5);
ie_tipo_intercambio_w		varchar(3);
qt_reg_w			integer;
ie_tipo_gat_w			varchar(1);
nr_seq_prestador_exec_w		bigint;
nr_seq_prestador_w		bigint;
ie_estagio_req_w		smallint;
qt_procedimento_w		pls_requisicao_proc.qt_procedimento%type;
nr_seq_lote_execucao_w		bigint;

C01 CURSOR FOR
	SELECT	b.nr_sequencia,		
		b.qt_procedimento
	from	pls_requisicao a,
		pls_requisicao_proc b
	where	a.nr_sequencia = b.nr_seq_requisicao
	and	a.nr_sequencia = nr_seq_requisicao_p;


BEGIN

nr_seq_prestador_w := nr_seq_prestador_p;

select	ie_estagio,
	ie_tipo_gat,
	nr_seq_prestador_exec,
	nr_seq_segurado
into STRICT	ie_estagio_w,
	ie_tipo_gat_w,
	nr_seq_prestador_exec_w,
	nr_seq_segurado_w
from	pls_requisicao
where 	nr_sequencia = nr_seq_requisicao_p;

if (ie_exec_intercambio_p = 'S') then
	nr_seq_prestador_w := nr_seq_prestador_exec_w;
end if;

if (ie_estagio_w = 2) then	

	SELECT * FROM pls_dados_intercambio_web(null, nr_seq_requisicao_p, cd_estabelecimento_p, ie_transacao_w, cd_cooperativa_w, nm_cooperativa_w, ie_tipo_intercambio_w, ie_estagio_req_w) INTO STRICT ie_transacao_w, cd_cooperativa_w, nm_cooperativa_w, ie_tipo_intercambio_w, ie_estagio_req_w;
	
	/* Transacao I - Intercambio */

	if	((coalesce(ie_transacao_w::text, '') = '' or ie_transacao_w <> 'I') or ie_exec_intercambio_p = 'S' or ie_tipo_gat_w = 'S') then
		
		/*Gera o lote para execucao direta da Requisicao de Consulta e Consulta de Urgencia */

		nr_seq_lote_execucao_w := pls_gerar_itens_lote_execucao(  nr_seq_prestador_w, nr_seq_segurado_w, nr_seq_requisicao_p, 'P', cd_estabelecimento_p, nr_seq_usuario_web_p, nm_usuario_p, 'Execucao direta, feita para guias de Consulta e Consulta de urgencia, somente pelo Portal.', nr_seq_lote_execucao_w);
						
		
		/* Gerar execucao na tabela PLS_EXECUCAO_REQUISICAO */

		nr_seq_execucao_w := pls_inserir_execusao_req(nr_seq_requisicao_p, nr_seq_prestador_w, nr_seq_lote_execucao_w, null, nm_usuario_p, nr_seq_execucao_w, null, null);	
		open C01;
		loop
		fetch C01 into	
			nr_seq_item_w,			
			qt_procedimento_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin
			select	coalesce(nr_seq_prestador_web,0)
			into STRICT 	nr_seq_usuario_web_w
			from	pls_requisicao
			where 	nr_sequencia = nr_seq_requisicao_p;	
			
			if (nr_seq_usuario_web_w = 0) then
				nr_seq_usuario_web_w := null;
			end if;
			
			update	pls_itens_lote_execucao
			set	ie_executar 		= 'S',
				qt_item_exec 		= qt_procedimento_w,
				nm_usuario		= nm_usuario_p,
				dt_atualizacao		= clock_timestamp()
			where	nr_seq_lote_exec	= nr_seq_lote_execucao_w
			and	nr_seq_req_proc		= nr_seq_item_w;

			/*Inserir os itens na PLS_EXECUCAO_REQ_ITEM*/

			CALL pls_inserir_itens_execusao_req(	'P', nr_seq_segurado_w, qt_procedimento_w,
							nr_seq_requisicao_p, nr_seq_execucao_w, null,
							nr_seq_item_w, null, nm_usuario_p, null);
			
			end;
		end loop;
		close C01;
		
		/* Gerar as guias apartir da tabela do lote  */

		CALL pls_gerar_guia_requisicao_lote(	nr_seq_lote_execucao_w, nr_seq_segurado_w, nr_seq_prestador_w,
						nm_usuario_p, 'EP', cd_estabelecimento_p,
						nr_seq_usuario_web_p, null, nr_seq_maquina_p,
						id_maquina_p,null);
		
		select	count(1)
		into STRICT	qt_reg_w
		from	pls_execucao_requisicao
		where	nr_sequencia = nr_seq_execucao_w
		and	(nr_seq_guia IS NOT NULL AND nr_seq_guia::text <> '');
		
		if (qt_reg_w > 0) then		
			select	coalesce(nr_seq_guia, 0)
			into STRICT	nr_seq_guia_w
			from	pls_execucao_requisicao
			where	nr_sequencia = nr_seq_execucao_w;

			update	pls_guia_plano
			set	ie_status 		= 1,
				ie_estagio 		= 6,
				dt_atualizacao		= clock_timestamp(),
				dt_autorizacao		= clock_timestamp(),
				dt_liberacao		= clock_timestamp(),
				nm_usuario		= nm_usuario_p
			where	nr_sequencia 		= nr_seq_guia_w;


			update	pls_guia_plano_proc
			set	ie_status 	= 'S',
				dt_atualizacao	= clock_timestamp(),
				nm_usuario	= nm_usuario_p
			where	nr_seq_guia 	= nr_seq_guia_w;
			
			select 	max(cd_guia)
			into STRICT   	cd_guia_w
			from 	pls_guia_plano
			where 	nr_sequencia = nr_seq_guia_w;
		end if;

		nr_seq_guia_p := nr_seq_guia_w;
		cd_guia_p     := cd_guia_w;
		
	end if;	
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_executar_requisicao_web ( nr_seq_requisicao_p bigint, nr_seq_segurado_p bigint, nr_seq_prestador_p bigint, nr_seq_item_p bigint, ie_tipo_item_p text, nm_usuario_p text, cd_estabelecimento_p bigint, ie_exec_intercambio_p text, ie_origem_exec_p text, nr_seq_maquina_p bigint, id_maquina_p text, nr_seq_usuario_web_p bigint, nr_seq_guia_p INOUT bigint, cd_guia_p INOUT text) FROM PUBLIC;
