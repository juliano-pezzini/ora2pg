-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_dados_partic (nr_seq_proc_partic_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

 
ds_retorno_w	varchar(400);

-- 	IE_OPCAO_P 
-- CDI	- cd medico imp 
-- NMI	- nome medico imp 
-- CRM	- nr_crm_medico 
-- SPR	- nr_seq_prestador 
-- NPR	- nm_prestador 
-- GRP	- nr_seq_grau_partic 
-- CDM	- cd_medico 
-- NMM	- nm_medico_executor 
-- IFM	- ie_funcao_medico_imp 
-- VLP	- vl_participante 
-- DRH	- ds_regra_honorario 
-- NCS	- nr_seq_cbo_saude 
-- CCS	- cd_cbo 
-- NSC	- nr_seq_conselho 
-- UFC	- uf_conselho 
-- DSC	- ds_cbo 
-- DFM	- ds_funcao_medico 
-- NPC	- nm_prestador_credenciado 
-- NPP	- nm_prestador_pgto 
-- NSP	- nr_seq_prestador_pgto 
	 

BEGIN 
if (coalesce(nr_seq_proc_partic_p,0) > 0) then 
	if (ie_opcao_p = 'CDI') then 
		begin 
		select	cd_medico_imp 
		into STRICT	ds_retorno_w 
		from 	pls_proc_participante 
		where	nr_sequencia = nr_seq_proc_partic_p;	
		exception 
		when others then 
			ds_retorno_w	:= '';
		end;	
		 
	elsif (ie_opcao_p = 'CDM') then 
		begin 
		select	cd_medico 
		into STRICT	ds_retorno_w 
		from 	pls_proc_participante 
		where	nr_sequencia = nr_seq_proc_partic_p;	
		exception 
		when others then 
			ds_retorno_w	:= '';
		end;	
		 
	elsif (ie_opcao_p = 'NMM') then 
		begin 
		select	substr(obter_nome_pf(cd_medico),1,255) 
		into STRICT	ds_retorno_w 
		from 	pls_proc_participante 
		where	nr_sequencia = nr_seq_proc_partic_p;	
		exception 
		when others then 
			ds_retorno_w	:= '';
		end;	
		 
	elsif (ie_opcao_p = 'NMI') then	 
		begin 
		select	nm_medico_executor_imp 
		into STRICT	ds_retorno_w 
		from 	pls_proc_participante 
		where	nr_sequencia = nr_seq_proc_partic_p;	
		exception 
		when others then 
			ds_retorno_w	:= '';
		end;	
		 
	elsif (ie_opcao_p = 'CRM') then	 
		begin 
		select	substr(obter_crm_medico(cd_medico),1,255) 
		into STRICT	ds_retorno_w 
		from 	pls_proc_participante 
		where	nr_sequencia = nr_seq_proc_partic_p;	
		exception 
		when others then 
			ds_retorno_w	:= '';
		end;
	 
	elsif (ie_opcao_p = 'SPR') then	 
		select	max(nr_seq_prestador) 
		into STRICT	ds_retorno_w 
		from 	pls_proc_participante 
		where	nr_sequencia = nr_seq_proc_partic_p;		
	 
	elsif (ie_opcao_p = 'SPR') then	 
		begin 
		select	substr(pls_obter_dados_prestador(nr_seq_prestador,'N'),1,255) 
		into STRICT	ds_retorno_w 
		from 	pls_proc_participante 
		where	nr_sequencia = nr_seq_proc_partic_p;
		exception 
		when others then 
			ds_retorno_w	:= '';
		end;	
 
	elsif (ie_opcao_p = 'NPR') then	 
		begin 
		select	substr(pls_obter_dados_prestador(nr_seq_prestador,'N'),1,255) 
		into STRICT	ds_retorno_w 
		from 	pls_proc_participante 
		where	nr_sequencia = nr_seq_proc_partic_p;
		exception 
		when others then 
			ds_retorno_w	:= '';
		end;	
 
	elsif (ie_opcao_p = 'GRP') then	 
		begin 
		select	substr(lpad(cd_tiss,2,0)||' - '||ds_grau_participacao,1,255) 
		into STRICT	ds_retorno_w 
		from	pls_grau_participacao	a, 	 
			pls_proc_participante	b 
		where	a.nr_sequencia	=	b.nr_seq_grau_partic 
		and	b.nr_sequencia = nr_seq_proc_partic_p;
		exception 
		when others then 
			ds_retorno_w	:= '';
		end;	
		 
	elsif (ie_opcao_p = 'IFM') then 
		begin 
		select	ie_funcao_medico_imp 
		into STRICT	ds_retorno_w 
		from 	pls_proc_participante 
		where	nr_sequencia = nr_seq_proc_partic_p;	
		exception 
		when others then 
			ds_retorno_w	:= '';
		end;
		 
	elsif (ie_opcao_p = 'VLP') then 
		select	coalesce(max(vl_participante),0) 
		into STRICT	ds_retorno_w 
		from 	pls_proc_participante 
		where	nr_sequencia = nr_seq_proc_partic_p;	
		 
	elsif (ie_opcao_p = 'DRH') then 
		begin 
		select	substr(pls_obter_desc_regra_honorario(nr_seq_honorario_crit),1,80) 
		into STRICT	ds_retorno_w 
		from 	pls_proc_participante 
		where	nr_sequencia = nr_seq_proc_partic_p;	
		exception 
		when others then 
			ds_retorno_w	:= '';
		end;
		 
	elsif (ie_opcao_p = 'NCS') then 
		select	max(nr_seq_cbo_saude) 
		into STRICT	ds_retorno_w 
		from 	pls_proc_participante 
		where	nr_sequencia = nr_seq_proc_partic_p;	
		 
	elsif (ie_opcao_p = 'CCS') then 
		begin 
		select	substr(obter_codigo_cbo_saude(nr_seq_cbo_saude),1,15) 
		into STRICT	ds_retorno_w 
		from 	pls_proc_participante 
		where	nr_sequencia = nr_seq_proc_partic_p;	
		exception 
		when others then 
			ds_retorno_w	:= '';
		end;
		 
	elsif (ie_opcao_p = 'NSC') then	 
		begin 
		select	substr(sg_conselho||' - '||ds_conselho,1,255) 
		into STRICT	ds_retorno_w 
		from	conselho_profissional	a, 	 
			pls_proc_participante	b 
		where	a.nr_sequencia	=	b.nr_seq_conselho 
		and	b.nr_sequencia = nr_seq_proc_partic_p;
		exception 
		when others then 
			ds_retorno_w	:= '';
		end;
		 
	elsif (ie_opcao_p = 'UFC') then	 
		begin 
		select	obter_valor_dominio(50,uf_conselho) 
		into STRICT	ds_retorno_w 
		from	pls_proc_participante 
		where	nr_sequencia = nr_seq_proc_partic_p;
		exception 
		when others then 
			ds_retorno_w	:= '';
		end;
		 
	elsif (ie_opcao_p = 'DSC') then	 
		begin 
		select	substr(obter_cbo_saude(nr_seq_cbo_saude),1,255) 
		into STRICT	ds_retorno_w 
		from	pls_proc_participante 
		where	nr_sequencia = nr_seq_proc_partic_p;
		exception 
		when others then 
			ds_retorno_w	:= '';
		end;
		 
	elsif (ie_opcao_p = 'DFM') then	 
		begin 
		select	substr(obter_descricao_padrao('PLS_GRAU_PARTICIPACAO','DS_GRAU_PARTICIPACAO',nr_seq_grau_partic),1,255) 
		into STRICT	ds_retorno_w 
		from	pls_proc_participante 
		where	nr_sequencia = nr_seq_proc_partic_p;
		exception 
		when others then 
			ds_retorno_w	:= '';
		end;
	 
	elsif (ie_opcao_p = 'NPC') then	 
		begin 
		select	substr(pls_obter_credenciado_partic(nr_sequencia),1,255) 
		into STRICT	ds_retorno_w 
		from	pls_proc_participante 
		where	nr_sequencia = nr_seq_proc_partic_p;
		exception 
		when others then 
			ds_retorno_w	:= '';
		end;
		 
	elsif (ie_opcao_p = 'NPP') then	 
		begin 
		select	substr(pls_obter_dados_prestador(nr_seq_prestador_pgto,'N'),1,255) 
		into STRICT	ds_retorno_w 
		from	pls_proc_participante 
		where	nr_sequencia = nr_seq_proc_partic_p;
		exception 
		when others then 
			ds_retorno_w	:= '';
		end;
		 
	elsif (ie_opcao_p = 'NSP') then 
		select	max(nr_seq_prestador_pgto) 
		into STRICT	ds_retorno_w 
		from 	pls_proc_participante 
		where	nr_sequencia = nr_seq_proc_partic_p;
		 
	end if;
end if;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_dados_partic (nr_seq_proc_partic_p bigint, ie_opcao_p text) FROM PUBLIC;
