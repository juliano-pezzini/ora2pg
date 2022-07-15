-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_agend_fluxo_caixa (nr_documento_p bigint, nr_docto_compl_p bigint, ie_origem_info_p text, dt_referencia_info_p timestamp, ie_tipo_reg_p text, nm_usuario_p text, ie_commit_p text default 'N') AS $body$
DECLARE

							
qt_registros_w			bigint := 0;

/* ---- Tipo de registro - ie_tipo_reg_p -----
-- I - inclusão

-- A - alteração

-- E - exclusão

-- C - Carga inicial do fluxo

*/


/* ---- Status do agendamento - ie_status_agend ----
-- P - Pendente

-- E - Erro

-- R - Processado

-- A - Em processamento

*/


/* -------- Origem da Informação -------- */


/* -- Identifica de onde vem a informação que será gerada no fluxo de caixa -- 
 XFLCX - Carga do fluxo de caixa
 TP - Título a pagar
 TPB - Baixa do título a pagar
 TPBA - Baixa do título a pagar por adiantamento
 TR - Título a receber
 TRB - Baixa do título a receber
 TRT - Tributos a pagar (gerados pelo título a receber)
 CR - Cheque a receber
 CP - Cheque a pagar
 CC - Cartão
 CCB - Baixa de cartão
 RC - Recebimento convênio
 CBT - Controle bancário e Tesouraria
 PR - Projeto recurso
 BP - Borderô a pagar - Entra pelo título
 PE - Pagamento escritural - Entra pelo título
 PC - Protocolo convênio
 GR - Glosas a recuperar - Entra pelo título
 GEF - Gestão de empréstimos e financiamentos
 OC - Ordem de compra
 CO - Contrato
 PAC - Conta paciente
 RT - Repasse terceiro
 AG - Agenda
*/

/* Na carga inicial do fluxo de caixa, passar sempre o tipo de registro 'C', a origem da informação sempre 'XFLCX', a data de referência sysdate e o nm_usuario sempre o usuário que requisitou a carga, para que o mesmo possa receber um comunicado interno de finalização da carga. 
     Número de documento deve ser passado null neste caso, pois serão verificados todos os registros do sistema. */
BEGIN
if (wheb_usuario_pck.get_ie_lote_contabil() = 'N') then
	begin

	-- Verifica se existem registros pendentes de processamento para o documento
	select	count(*)
	into STRICT	qt_registros_w
	from	fluxo_caixa_agendamento
	where	nr_documento = nr_documento_p
	and	coalesce(nr_docto_compl,0) = coalesce(nr_docto_compl_p,0)
	and	ie_origem_info = ie_origem_info_p
	and	ie_status_agend = 'P';
	
	-- Se houver registro não processado e o registro estiver sendo excluído, exclui o agendamento do documento
	if (qt_registros_w > 0 and ie_tipo_reg_p = 'E') then
		begin
			delete from fluxo_caixa_agendamento
			where	nr_documento = nr_documento_p
			and	nr_docto_compl = nr_docto_compl_p
			and	ie_origem_info = ie_origem_info_p
			and	ie_status_agend = 'P';
			
			
		exception when others then
			null;
		end;
	end if;
	
	-- Em caso de exclusão do documento, excluir seus registros do fluxo de caixa
	if (ie_tipo_reg_p = 'E') then
		CALL remove_docto_fluxo_caixa(nr_documento_p,
					nr_docto_compl_p,
					ie_origem_info_p);
	end if;
	
	-- Caso não exista agendamento pendente para o documento e o mesmo não for exclusão, inclui no agendamento
	if (qt_registros_w = 0 and ie_tipo_reg_p <> 'E') then
		begin
			insert into fluxo_caixa_agendamento(
				nr_sequencia,
				nr_documento,
				nr_docto_compl,
				dt_referencia_info,
				dt_agendamento,
				ie_origem_info,
				ie_status_agend,
				nm_usuario,
				dt_atualizacao)
			values (nextval('fluxo_caixa_agendamento_seq'),
				nr_documento_p,
				nr_docto_compl_p,
				dt_referencia_info_p,
				clock_timestamp(),
				ie_origem_info_p,
				'P',
				nm_usuario_p,
				clock_timestamp());
			
			
		end;
	end if;
	
	if (ie_commit_p = 'S') then
		commit;
	end if;
	
	end;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_agend_fluxo_caixa (nr_documento_p bigint, nr_docto_compl_p bigint, ie_origem_info_p text, dt_referencia_info_p timestamp, ie_tipo_reg_p text, nm_usuario_p text, ie_commit_p text default 'N') FROM PUBLIC;

