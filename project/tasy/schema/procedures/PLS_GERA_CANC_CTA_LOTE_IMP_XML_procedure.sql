-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gera_canc_cta_lote_imp_xml ( nr_seq_lote_cancel_p pls_guia_plano_lote_cancel.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p text) AS $body$
DECLARE

						
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Gerar o cancelamento das contas medicas quando enviada a tag  tipoCancelamentoLote
 conforme solicitado no pedido de cancelamento
-------------------------------------------------------------------------------------------------------------------
Pontos de atencao: Status utilizado no pedido de cancelamento
1 Cancelado com sucesso   2 Nao cancelado  3 Guia inexistente  4 Em processamento
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
--Inicia com status 2 Nao cancelado
ie_status_w		pls_guia_plano_cancel.ie_status%type := '2';
ds_observacao_w		varchar(255);
nr_seq_w		pls_conta.nr_sequencia%type;


C01 CURSOR FOR
	SELECT	nr_protocolo_imp nr_seq_protocolo_imp,
		nr_lote_imp nr_seq_lote_imp
	from	pls_guia_plano_lote_cancel
	where	nr_sequencia = nr_seq_lote_cancel_p;


C02 CURSOR(	nr_seq_lote_pc 		pls_protocolo_conta.nr_seq_lote_conta%type,
		nr_seq_protocolo_pc 	pls_protocolo_conta.nr_sequencia%type)FOR
	SELECT	nr_sequencia
	from	pls_conta
	where	nr_seq_protocolo = nr_seq_protocolo_pc
	
union all

	SELECT	nr_sequencia
	from	pls_conta_v
	where 	nr_seq_Lote_conta = nr_seq_lote_pc;
						
BEGIN

for cr_01 in C01 loop
	begin
		
	select max(nr_sequencia)
	into STRICT	nr_seq_w
	from (
	SELECT	nr_sequencia
	from	pls_conta
	where	nr_seq_protocolo = cr_01.nr_seq_protocolo_imp
	and 	coalesce(cr_01.nr_seq_lote_imp::text, '') = ''
	
union all

	SELECT	nr_sequencia
	from	pls_conta_v
	where 	nr_seq_Lote_conta = cr_01.nr_seq_lote_imp
	and coalesce(cr_01.nr_seq_protocolo_imp::text, '') = ''
	
union all

	select	nr_sequencia
	from	pls_conta_v
	where 	nr_seq_Lote_conta = cr_01.nr_seq_lote_imp
	and nr_seq_protocolo = cr_01.nr_seq_protocolo_imp ) alias3;
		
	if (nr_seq_w IS NOT NULL AND nr_seq_w::text <> '') then
		--Por padrao o status sera 2 - Nao cancelado, e aplicado quando nao aplica o cancelamento na guia
		ie_status_w := '2';
			
		--altera??es aldellandrea
		for cr_02_w in C02(cr_01.nr_seq_lote_imp, cr_01.nr_seq_protocolo_imp) loop
			begin
			ds_observacao_w := pls_cancelar_conta(	cr_02_w.nr_sequencia, 0, nm_usuario_p, cd_estabelecimento_p, 1, ds_observacao_w, 'N');
			ds_observacao_w := pls_cancelar_conta(	cr_02_w.nr_sequencia, 0, nm_usuario_p, cd_estabelecimento_p, 2, ds_observacao_w, 'N');
			ie_status_w := 1;
			end;
		end loop;
	else
		ie_status_w := '3';
	end if;
		
	--Atualizar status do pedido de cancelamento
	update 	pls_guia_plano_lote_cancel
	set 	ie_status_cancelamento = ie_status_w
	where 	nr_sequencia = nr_seq_lote_cancel_p;
		
	end;
end loop;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gera_canc_cta_lote_imp_xml ( nr_seq_lote_cancel_p pls_guia_plano_lote_cancel.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p text) FROM PUBLIC;

