-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gera_canc_cta_guia_imp_xml ( nr_seq_lote_cancel_p pls_guia_plano_lote_cancel.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p text) AS $body$
DECLARE

						
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Gerar o cancelamento das contas medicas quando enviada a tag  tipoCancelamentoGuia 
conforme solicitado no pedido de cancelamento
-------------------------------------------------------------------------------------------------------------------
Pontos de atencao: Status utilizado no pedido de cancelamento
1 Cancelado com sucesso   2 Nao cancelado  3 Guia inexistente  4 Em processamento
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
--Inicia com status 2 Nao cancelado
ie_status_w		pls_guia_plano_cancel.ie_status%type := '2';
ds_observacao_w		varchar(255);


C01 CURSOR FOR
	SELECT	a.nr_seq_guia,
		a.nr_seq_requisicao,
		a.nr_sequencia,
		a.nr_protocolo_imp,
		a.ie_tipo_guia_imp ie_tipo_guia
	from	pls_guia_plano_cancel a
	where	a.nr_seq_lote_cancel = nr_seq_lote_cancel_p
	and	((a.ie_status <> '3' and ie_tipo_guia_imp = 1)
	or 	ie_tipo_guia_imp <> 1);

C02 CURSOR(nr_seq_guia_p  pls_conta.nr_seq_guia%type)FOR
	SELECT	nr_sequencia
	from	pls_conta
	where	nr_seq_guia = nr_seq_guia_p;
						
BEGIN

for cr_01 in C01 loop
	begin
		--Por padrao o status sera 2 - Nao cancelado, e aplicado quando nao aplica o cancelamento na guia
		ie_status_w := '2';
		
		--guia
		if (cr_01.ie_tipo_guia = 1) then
			CALL pls_gera_canc_guia_imp_xml( null,cd_estabelecimento_p, nm_usuario_p, cr_01.nr_sequencia);
			ie_status_w := 1;
		--conta
		elsif (cr_01.ie_tipo_guia = 2) then
										
			for cr_02_w in C02(cr_01.nr_seq_guia) loop
				begin
				ds_observacao_w := pls_cancelar_conta(	cr_02_w.nr_sequencia, 0, nm_usuario_p, cd_estabelecimento_p, 1, ds_observacao_w, 'N');
				ds_observacao_w := pls_cancelar_conta(	cr_02_w.nr_sequencia, 0, nm_usuario_p, cd_estabelecimento_p, 2, ds_observacao_w, 'N');
				ie_status_w := 1;
				end;
			end loop;
		--recurso
		else
			CALL pls_cancelar_rec_glosa_solic( nr_seq_lote_cancel_p, cd_estabelecimento_p, nm_usuario_p);			
		end if;
		if ( cr_01.ie_tipo_guia <> 3) then
			CALL pls_atualiza_status_canc_tiss(cr_01.nr_sequencia, ie_status_w, nm_usuario_p );
		end if;	
	end;
end loop;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gera_canc_cta_guia_imp_xml ( nr_seq_lote_cancel_p pls_guia_plano_lote_cancel.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p text) FROM PUBLIC;

