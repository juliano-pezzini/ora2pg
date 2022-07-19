-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_sip ( nr_seq_lote_sip_p bigint, ie_despesa_assist_p text, ie_anexo_ii_p text, ie_anexo_iii_p text, ie_anexo_iv_p text, nm_usuario_p text) AS $body$
DECLARE

			 
dt_alteracao_proc_w		timestamp;
dt_geracao_sip_w		timestamp;
ie_sip_regra_despesa_w		varchar(1);
			

BEGIN 
 
select	coalesce(max(dt_geracao_sip),clock_timestamp()) 
into STRICT	dt_geracao_sip_w 
from	pls_lote_sip 
where	nr_sequencia	= nr_seq_lote_sip_p;
 
/* Leitura do parâmetro 2 da OPS - Sistema de informações de produtos (SIP) */
 
begin 
select	coalesce(max(obter_valor_param_usuario(1231, 2, Obter_Perfil_Ativo, nm_usuario_p, 0)), 'N') 
into STRICT	ie_sip_regra_despesa_w
;
exception 
when others then 
	ie_sip_regra_despesa_w	:= 'N';
end;
 
/* Despesas não assistenciais */
 
if (ie_despesa_assist_p	= 'S') then 
	CALL sip_calcular_despesa_assist(nr_seq_lote_sip_p, nm_usuario_p);
end if;
/* Anexo II */
 
if (ie_anexo_ii_p	= 'S') then 
	delete	from w_sip_item_despesa 
	where	nr_seq_lote_sip	= nr_seq_lote_sip_p;
 
	select	coalesce(max(dt_atualizacao),clock_timestamp() - interval '1 days') 
	into STRICT	dt_alteracao_proc_w 
	from	sip_procedimento;
	if (dt_alteracao_proc_w > dt_geracao_sip_w) then 
		delete	from sip_anexo_ii_procedimento 
		where	nr_seq_lote_sip	= nr_seq_lote_sip_p;
	end if;
 
	delete	from pls_desp_sip_diops_conta 
	where	nr_seq_lote_sip	= nr_seq_lote_sip_p;
 
	delete	from w_sip_grupo_beneficiario 
	where	nr_seq_lote_sip	= nr_seq_lote_sip_p;
	 
	if (ie_sip_regra_despesa_w	= 'N') then 
		CALL sip_gerar_item_despesa(nr_seq_lote_sip_p, nm_usuario_p);
		CALL sip_calcular_coparticipacao(nr_seq_lote_sip_p, nm_usuario_p);
	elsif (ie_sip_regra_despesa_w	= 'S') then 
		CALL sip_gerar_anexo_ii(nr_seq_lote_sip_p, nm_usuario_p);
	end if;
	/* Anexo II-A */
	 
	CALL sip_gerar_grupo_beneficiario(nr_seq_lote_sip_p, nm_usuario_p);	
end if;
/* Anexo III */
 
if (ie_anexo_iii_p	= 'S') then 
	delete	from w_sip_anexo 
	where	nr_seq_lote_sip	= nr_seq_lote_sip_p;
 
	select	coalesce(max(dt_atualizacao),clock_timestamp() - interval '1 days') 
	into STRICT	dt_alteracao_proc_w 
	from	sip_estrut_anexo_regra;
	if (dt_alteracao_proc_w >= dt_geracao_sip_w) then 
		delete	from sip_anexo_iii_procedimento 
		where	nr_seq_lote_sip	= nr_seq_lote_sip_p;
	end if;
	 
	CALL sip_gerar_anexo_iii(nr_seq_lote_sip_p, nm_usuario_p);
end if;
/* Anexo IV */
 
if (ie_anexo_iv_p	= 'S') then 
	delete	from w_sip_atencao_saude 
	where	nr_seq_lote_sip	= nr_seq_lote_sip_p;
	 
	delete	from sip_anexo_iv_procedimento 
	where	nr_seq_lote_sip	= nr_seq_lote_sip_p;
	 
	CALL sip_gerar_atencao_saude(nr_seq_lote_sip_p, nm_usuario_p);
end if;
 
update	pls_lote_sip 
set	dt_geracao_sip	= clock_timestamp(), 
	nm_usuario	= nm_usuario_p, 
	dt_atualizacao	= clock_timestamp() 
where	nr_sequencia	= nr_seq_lote_sip_p;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_sip ( nr_seq_lote_sip_p bigint, ie_despesa_assist_p text, ie_anexo_ii_p text, ie_anexo_iii_p text, ie_anexo_iv_p text, nm_usuario_p text) FROM PUBLIC;

