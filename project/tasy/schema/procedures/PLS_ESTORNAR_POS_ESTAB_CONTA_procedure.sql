-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_estornar_pos_estab_conta ( ds_contas_p text, --Aqui podem ser passadas várias contas de uma única vez, elas serão obtidas individualmenete depois. 
 ie_estornou_registro_p INOUT text , nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, ds_motivo_p text) AS $body$
DECLARE

 
nr_seq_conta_pos_estab_w	pls_conta_pos_estabelecido.nr_sequencia%type;
nr_seq_conta_w			pls_conta.nr_sequencia%type;
nr_seq_contador_w		integer;
ie_contas_com_pos_estab_w	varchar(1);
	
--Cursor utilizado para separar a lista de valores em sequencias de contas	 
C01 CURSOR(	ds_lista_p	text, 
		ds_separador_p	text) FOR 
	SELECT	nr_valor_number 
	from	table(pls_util_pck.converter_lista_valores(ds_lista_p, ds_separador_p));

--Registros de pós-estabelecido 	 
C02 CURSOR(nr_seq_conta_p	pls_conta.nr_sequencia%type) FOR 
	SELECT	a.nr_sequencia nr_seq_pos_estab 
	from	pls_conta_pos_estabelecido a, 
		pls_conta b 
	where	a.nr_seq_conta 		= nr_seq_conta_p 
	and	a.vl_beneficiario 	>= 0 
	and (a.ie_status_faturamento <> 'N' or a.ie_cobrar_mensalidade <> 'N') 
	and	b.nr_sequencia = a.nr_seq_conta 
	and	((ie_situacao	= 'A') or (coalesce(ie_situacao::text, '') = '')) 
	and	coalesce(b.nr_seq_fatura::text, '') = '';
					
BEGIN 
	 
	ie_contas_com_pos_estab_w := 'N';
	--Percorre a lista de valores, considerando a vírgula como separador de valores 
	for r_C01_w in C01(ds_contas_p, ',') loop 
		 
		nr_seq_conta_w := r_C01_w.nr_valor_number;		
		--Percorre individualmente os registros de pós-estabelecido 
		for r_C02_w in C02(nr_seq_conta_w) loop 
 
			--Realiza trabalho de estornar item de pós-estabelecido de maneira individual 
			CALL pls_estornar_custo_pos_estab( r_C02_w.nr_seq_pos_estab, nm_usuario_p, ds_motivo_p, 'C');
			ie_contas_com_pos_estab_w := 'S';
		end loop;
	end loop;
	 
	ie_estornou_registro_p := ie_contas_com_pos_estab_w;
	 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_estornar_pos_estab_conta ( ds_contas_p text, ie_estornou_registro_p INOUT text , nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, ds_motivo_p text) FROM PUBLIC;

