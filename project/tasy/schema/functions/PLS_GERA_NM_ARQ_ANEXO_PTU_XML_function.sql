-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_gera_nm_arq_anexo_ptu_xml ( nr_lote_p ptu_nota_cobranca.nr_lote%type, nr_nota_p ptu_nota_cobranca.nr_nota%type, nr_ordem_arq_p bigint, ds_extensao_p text, nr_seq_fatura_p ptu_nota_cobranca.nr_seq_fatura%type default null, ie_tipo_p ptu_nota_cobranca.ie_tipo_saida_spdat%type default 'C', nr_seq_cobranca_p ptu_nota_cobranca.nr_sequencia%type  DEFAULT NULL) RETURNS varchar AS $body$
DECLARE



ds_retorno_w      		varchar(255);
ds_extensao_w      		varchar(100);
nr_guia_tiss_prestador_w  	ptu_nota_cobranca.nr_guia_tiss_prestador%type;
ie_tipo_exportacao_w		ptu_fatura.ie_tipo_exportacao%type;



BEGIN

if  ((ds_extensao_p IS NOT NULL AND ds_extensao_p::text <> '') and (position('.' in ds_extensao_p) < 1)) then
	ds_extensao_w := '.'||ds_extensao_p;
else
	ds_extensao_w := ds_extensao_p;
end if;

if (nr_seq_fatura_p IS NOT NULL AND nr_seq_fatura_p::text <> '') then

	select	coalesce(max(ie_tipo_exportacao),'TXT')
	into STRICT	ie_tipo_exportacao_w
	from   	ptu_fatura pf
	where   pf.nr_sequencia   = nr_seq_fatura_p;

	-- se estiver configurado XML para o A500
	if (ie_tipo_exportacao_w = 'XML') then

		-- se for cobranca
		if (ie_tipo_p = 'C') then
			select  rpad(substr(coalesce(to_char(pnc.nr_lote_prest),'0'),1,12),12,'_') ||
				rpad(substr(coalesce(replace(to_char(pnc.nr_guia_tiss_prestador),'.',null),'_'),1,20),20,'_') ||
				'XXX' ||ds_extensao_w nm_arquivo
			into STRICT    ds_retorno_w
			from   	ptu_fatura pf,
				ptu_nota_cobranca pnc
			where	pf.nr_sequencia   	= nr_seq_fatura_p
			and   	pnc.nr_seq_fatura   	= pf.nr_sequencia
			and   	pnc.nr_nota    		= nr_nota_p
			and   	pnc.nr_sequencia  	= nr_seq_cobranca_p;

		elsif (ie_tipo_p = 'CA') then
			select  rpad(substr(coalesce(to_char(pnc.nr_lote_prest),'0'),1,12),12,'_') ||
				rpad(substr(coalesce(replace(to_char(pnc.nr_guia_tiss_prestador),'.',null),'_'),1,20),20,'_') ||ds_extensao_w nm_arquivo
			into STRICT    ds_retorno_w
			from   	ptu_fatura pf,
				ptu_nota_cobranca pnc
			where	pf.nr_sequencia   	= nr_seq_fatura_p
			and   	pnc.nr_seq_fatura   	= pf.nr_sequencia
			and   	pnc.nr_nota    		= nr_nota_p
			and   	pnc.nr_sequencia  	= nr_seq_cobranca_p;

		-- se for reembolso
		else
			select	f.nr_competencia ||
				rpad(coalesce(f.nr_nota_credito_debito,'_'),20,'_') ||
				rpad(coalesce(f.nr_fatura,'_'),20,'_') ||
				lpad(a.cd_unimed,4,'0') ||
				lpad(a.id_benef,13,'0') ||
				lpad(f.cd_unimed_origem,4,'0') ||
				'XXX' ||ds_extensao_w nm_arquivo
			into STRICT  	ds_retorno_w
			from  	ptu_nota_cobranca_rrs  a,
				ptu_fatura     f
			where	f.nr_sequencia	= a.nr_seq_fatura
			and	a.nr_seq_fatura	= nr_seq_fatura_p
			and	a.nr_sequencia	= nr_seq_cobranca_p;
		end if;
		
	-- se estiver configurado TXT para o A500	
	else
		
		-- se for cobranca
		if (ie_tipo_p = 'C') then
		
			select	lpad(substr(coalesce(to_char(pnc.nr_lote),'0'),1,8),8,'0') ||
				substr(rpad(substr(coalesce(replace(to_char(pnc.nr_nota),'.',null),'_'),1,20),20,'_') || lpad(nr_ordem_arq_p,3,'0'), 1, 255)||ds_extensao_w
			into STRICT 	ds_retorno_w
			from	ptu_fatura pf,
				ptu_nota_cobranca pnc
			where	pf.nr_sequencia   	= nr_seq_fatura_p
			and   	pnc.nr_seq_fatura   	= pf.nr_sequencia
			and   	pnc.nr_nota    		= nr_nota_p
			and   	pnc.nr_sequencia  	= nr_seq_cobranca_p;
			
		-- se for reembolso	
		else
		
			select	lpad(substr(coalesce(to_char(pnc.nr_lote),'0'),1,8),8,'0') ||
				substr(rpad(substr(coalesce(replace(to_char(pnc.nr_nota),'.',null),'_'),1,20),20,'_') || 'XXX', 1, 255)||ds_extensao_w
			into STRICT 	ds_retorno_w
			from	ptu_fatura pf,
				ptu_nota_cobranca_rrs pnc
			where	pf.nr_sequencia   	= nr_seq_fatura_p
			and   	pnc.nr_seq_fatura   	= pf.nr_sequencia
			and   	pnc.nr_nota    		= nr_nota_p
			and   	pnc.nr_sequencia  	= nr_seq_cobranca_p;
		end if;
	end if;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_gera_nm_arq_anexo_ptu_xml ( nr_lote_p ptu_nota_cobranca.nr_lote%type, nr_nota_p ptu_nota_cobranca.nr_nota%type, nr_ordem_arq_p bigint, ds_extensao_p text, nr_seq_fatura_p ptu_nota_cobranca.nr_seq_fatura%type default null, ie_tipo_p ptu_nota_cobranca.ie_tipo_saida_spdat%type default 'C', nr_seq_cobranca_p ptu_nota_cobranca.nr_sequencia%type  DEFAULT NULL) FROM PUBLIC;
